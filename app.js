const express = require('express');
const bodyParser = require('body-parser');
const session = require('express-session');
const pool = require('./db');

const app = express();

// Cấu hình Express
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static('public'));
app.set('view engine', 'ejs');
app.set('views', './views');

// Cấu hình Session (Duy trì đăng nhập)
app.use(session({
    secret: 'edumanage_hcmut_secret',
    resave: false,
    saveUninitialized: true
}));

// ==========================================
// 1. MIDDLEWARE KIỂM TRA QUYỀN TRUY CẬP
// ==========================================
const requireUser = (req, res, next) => {
    if (!req.session.user) return res.redirect('/login');
    next();
};

const requireAdmin = (req, res, next) => {
    if (!req.session.user) return res.redirect('/login');
    if (req.session.user.Role !== 'ADMIN') {
        return res.send(`<script>alert("Bạn không có quyền truy cập trang Quản trị!"); window.location.href="/";</script>`);
    }
    next();
};

// ==========================================
// 2. ĐĂNG KÝ VÀ ĐĂNG NHẬP
// ==========================================
// --- ĐĂNG KÝ ---
app.get('/register', (req, res) => res.render('register', { error: null }));

app.post('/register', async (req, res) => {
    const { username, password, hoten, email, sdt, ngaysinh, gioitinh, duong, quan, city } = req.body;
    const connection = await pool.getConnection(); 
    try {
        await connection.beginTransaction();

        // Tạo MaND ngẫu nhiên
        const maND = 'ND' + Date.now().toString().slice(-6);

        // 1. Chèn vào bảng NGUOI_DUNG
        const sqlND = `
            INSERT INTO NGUOI_DUNG (MaND, Ten_Dang_Nhap, Mat_Khau, Ho_Ten, Email, So_Dien_Thoai, Ngay_Sinh, Gioi_Tinh, Duong, Quan, Thanh_Pho)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `;
        await connection.query(sqlND, [maND, username, password, hoten, email, sdt, ngaysinh, gioitinh, duong, quan, city]);

        // 2. Chèn vào bảng HOC_VIEN
        const sqlHV = `INSERT INTO HOC_VIEN (MaHV, Diem_Tich_Luy) VALUES (?, 0)`;
        await connection.query(sqlHV, [maND]);

        await connection.commit();
        res.redirect('/login');
    } catch (error) {
        await connection.rollback();
        res.render('register', { error: 'Lỗi đăng ký: ' + error.message });
    } finally {
        connection.release();
    }
});

// --- ĐĂNG NHẬP ---
app.get('/login', (req, res) => {
    if (req.session.user) return res.redirect(req.session.user.Role === 'ADMIN' ? '/admin' : '/dashboard');
    res.render('login', { error: null });
});

app.post('/login', async (req, res) => {
    const { username, password } = req.body;
    try {
        // Kiểm tra user và xác định Role (ADMIN nếu có tên trong bảng GIANG_VIEN)
        const sql = `
            SELECT n.*, CASE WHEN g.MaGV IS NOT NULL THEN 'ADMIN' ELSE 'USER' END AS Role
            FROM NGUOI_DUNG n
            LEFT JOIN GIANG_VIEN g ON n.MaND = g.MaGV
            WHERE n.Ten_Dang_Nhap = ? AND n.Mat_Khau = ?
        `;
        const [rows] = await pool.query(sql, [username, password]);

        if (rows.length > 0) {
            req.session.user = {
                MaND: rows[0].MaND,
                Ho_Ten: rows[0].Ho_Ten,
                Username: rows[0].Ten_Dang_Nhap,
                Role: rows[0].Role
            };
            res.redirect(rows[0].Role === 'ADMIN' ? '/admin' : '/dashboard');
        } else {
            res.render('login', { error: 'Sai tài khoản hoặc mật khẩu!' });
        }
    } catch (error) {
        res.status(500).send("Lỗi Database: " + error.message);
    }
});

// --- ĐĂNG XUẤT ---
app.get('/logout', (req, res) => {
    req.session.destroy();
    res.redirect('/');
});


// ==========================================
// 3. TRANG NGƯỜI DÙNG (GIAO DIỆN STUDY4)
// ==========================================
// Trang chủ (Hiển thị tất cả khóa học)
app.get('/', async (req, res) => {
    try {
        const [coursesRows] = await pool.query('CALL sp_TimKiemKhoaHoc(?)', ['']);
        res.render('index', { courses: coursesRows[0], user: req.session.user || null }); 
    } catch (error) {
        res.status(500).send("Lỗi Database: " + error.message);
    }
});

// Trang xem chi tiết một khóa học
app.get('/khoa-hoc/:id', async (req, res) => {
    try {
        const sql = `
            SELECT k.*, n.Ho_Ten AS Ten_Giang_Vien 
            FROM KHOA_HOC k
            LEFT JOIN GIANG_VIEN g ON k.MaGV = g.MaGV
            LEFT JOIN NGUOI_DUNG n ON g.MaGV = n.MaND
            WHERE k.MaKH = ?
        `;
        const [rows] = await pool.query(sql, [req.params.id]);
        
        if (rows.length === 0) return res.status(404).send("Không tìm thấy khóa học!");

        res.render('detail', { course: rows[0], user: req.session.user || null });
    } catch (error) {
        res.status(500).send("Lỗi Database: " + error.message);
    }
});

// ==========================================
// 4. TRANG DASHBOARD CÁ NHÂN CỦA HỌC VIÊN
// ==========================================
// ==========================================
// 4. TRANG DASHBOARD CÁ NHÂN CỦA HỌC VIÊN
// ==========================================
app.get('/dashboard', requireUser, async (req, res) => {
    if (req.session.user.Role === 'ADMIN') return res.redirect('/admin'); 
    
    try {
        const maND = req.session.user.MaND;

        // 1. Lấy thông tin cá nhân cơ bản
        const sqlProfile = `
            SELECT n.*, h.Diem_Tich_Luy 
            FROM NGUOI_DUNG n
            LEFT JOIN HOC_VIEN h ON n.MaND = h.MaHV
            WHERE n.MaND = ?
        `;
        const [profileRows] = await pool.query(sqlProfile, [maND]);
        const userProfile = profileRows[0];

        // 2. GỌI HÀM CÂU 2.4: Lấy Điểm Trung Bình (Thang 10) và Xếp Loại
        const sqlAcademic = `SELECT fn_TinhDiemTrungBinh(?) AS DiemTB, fn_XepLoaiHocVien(?) AS XepLoai`;
        const [academicRows] = await pool.query(sqlAcademic, [maND, maND]);
        const academicInfo = academicRows[0] || { DiemTB: null, XepLoai: 'Chưa có dữ liệu' };

        // 3. Lấy danh sách khóa học
        const sqlCourses = `
            SELECT k.MaKH, k.Ten_Khoa_Hoc 
            FROM CoQuyen cq
            JOIN KHOA_HOC k ON cq.MaKH = k.MaKH
            WHERE cq.MaHV = ?
        `;
        const [enrolledCourses] = await pool.query(sqlCourses, [maND]);

        res.render('dashboard', { 
            user: req.session.user, 
            profile: userProfile,   
            academic: academicInfo, // Truyền dữ liệu học lực chuẩn thang 10 ra view
            enrolledCourses: enrolledCourses
        });
    } catch (error) {
        res.status(500).send("Lỗi Database: " + error.message);
    }
});

// THÊM MỚI: Route xử lý cập nhật thông tin cá nhân
app.post('/cap-nhat-thong-tin', requireUser, async (req, res) => {
    const { hoten, email, sdt, gioitinh, ngaysinh, duong, quan, thanhpho } = req.body;
    const maND = req.session.user.MaND; // Lấy mã từ session để bảo mật, không lấy từ form
    
    try {
        const sql = `
            UPDATE NGUOI_DUNG 
            SET Ho_Ten = ?, Email = ?, So_Dien_Thoai = ?, Gioi_Tinh = ?, Ngay_Sinh = ?, Duong = ?, Quan = ?, Thanh_Pho = ? 
            WHERE MaND = ?
        `;
        // Xử lý ngày sinh rỗng
        const formattedDate = ngaysinh ? ngaysinh : null; 
        
        await pool.query(sql, [hoten, email, sdt, gioitinh, formattedDate, duong, quan, thanhpho, maND]);
        
        // Cập nhật lại tên trong session nếu họ có đổi tên
        req.session.user.Ho_Ten = hoten; 
        
        res.redirect('/dashboard');
    } catch (error) {
        res.send(`<script>alert("Lỗi cập nhật: ${error.message}"); window.location.href="/dashboard";</script>`);
    }
});

// ==========================================
// 5. TRANG QUẢN TRỊ ADMIN (CÁC YÊU CẦU BTL2)
// ==========================================
app.get('/admin', async (req, res) => {
    try {
        // 1. XỬ LÝ TÌM KIẾM (Gọi Procedure của bạn Sang)
        const keyword = req.query.keyword || '';
        const [searchResult] = await pool.query('CALL sp_TimKiemKhoaHoc(?)', [keyword]);
        // Kết quả từ procedure thường nằm trong mảng đầu tiên
        const coursesRows = searchResult[0]; 

        // 2. XỬ LÝ THỐNG KÊ DOANH THU (Gọi Procedure của bạn Sang)
        const [revenueResult] = await pool.query('CALL sp_ThongKeDoanhThu(?)', ['Đã thanh toán']);
        const revenueData = revenueResult[0];

        // 3. XỬ LÝ TRA CỨU HỌC LỰC (Gọi Function của bạn Bảo)
        const showRank = req.query.showRank === 'true';
        const mahv = req.query.mahv || '';
        let rank = null;

        if (showRank && mahv) {
            // Dùng SELECT để gọi Function trong MySQL
            const [rankResult] = await pool.query('SELECT fn_XepLoaiHocVien(?) AS XepLoai', [mahv]);
            if (rankResult.length > 0) {
                rank = rankResult[0].XepLoai;
            }
        }

        // 4. KIỂM TRA CHẾ ĐỘ SỬA KHÓA HỌC (Nếu có bấm nút Sửa)
        let editData = null;
        const editId = req.query.edit;
        if (editId) {
            const [editResult] = await pool.query('SELECT * FROM KHOA_HOC WHERE MaKH = ?', [editId]);
            if (editResult.length > 0) editData = editResult[0];
        }

        // Ném tất cả dữ liệu ra file admin.ejs
        res.render('admin', {
            user: req.session.user || { Ho_Ten: 'Ban Quản Trị' },
            courses: coursesRows,
            searchKeyword: keyword, // Khớp với EJS của bạn
            revenueData: revenueData,
            showRank: showRank,
            mahv: mahv,
            rank: rank,
            editData: editData
        });

    } catch (error) {
        console.error(error);
        res.status(500).send("Lỗi Database: " + error.message);
    }
});
// 5.4. Thêm / Sửa Khóa Học
app.post('/luu-khoa-hoc', requireAdmin, async (req, res) => {
    const { makh, magv, tenkhoahoc, mota, lotrinh, giatien, isEdit } = req.body;
    try {
        if (isEdit === "true") {
            await pool.query('CALL p_suakhoahoc(?,?,?,?,?,?)', [makh, magv, tenkhoahoc, mota, lotrinh, giatien]);
        } else {
            await pool.query('CALL sp_themkhoahoc(?,?,?,?,?,?)', [makh, magv, tenkhoahoc, mota, lotrinh, giatien]);
        }
        res.redirect('/admin');
    } catch (error) {
        res.send(`<script>alert("LỖI CSDL: ${error.message}"); window.location.href="/admin";</script>`);
    }
});

// 5.5. Xóa Khóa Học
app.post('/xoa-khoa-hoc/:id', requireAdmin, async (req, res) => {
    try {
        await pool.query('CALL p_xoakhoahoc(?)', [req.params.id]);
        res.redirect('/admin');
    } catch (error) {
        res.send(`<script>alert("LỖI CSDL: ${error.message}"); window.location.href="/admin";</script>`);
    }
});
// ==========================================
// ROUTE MỚI: TRANG DANH SÁCH CHƯƠNG TRÌNH HỌC
// ==========================================
app.get('/chuong-trinh-hoc', async (req, res) => {
    try {
        // Lấy toàn bộ khóa học từ CSDL
        const [coursesRows] = await pool.query('CALL sp_TimKiemKhoaHoc(?)', ['']);
        
        // Render ra file courses.ejs (mình sẽ tạo ở Bước 2)
        res.render('courses', { 
            courses: coursesRows[0], 
            user: req.session.user || null 
        }); 
    } catch (error) {
        res.status(500).send("Lỗi Database: " + error.message);
    }
});
// ==========================================
// 6. CHỨC NĂNG GIỎ HÀNG & THANH TOÁN
// ==========================================

// 6.1. Thêm khóa học vào giỏ hàng
app.post('/them-vao-gio/:makh', requireUser, async (req, res) => {
    const maHV = req.session.user.MaND;
    const maKH = req.params.makh;
    const maGH = maHV; 

    try {
        const [checkOwned] = await pool.query('SELECT * FROM CoQuyen WHERE MaHV = ? AND MaKH = ?', [maHV, maKH]);
        if (checkOwned.length > 0) return res.json({ status: 'info', message: 'Bạn đã sở hữu khóa học này rồi!' });

        const [checkCart] = await pool.query('SELECT * FROM BaoGom WHERE MaGH = ? AND MaKH = ?', [maGH, maKH]);
        if (checkCart.length > 0) return res.json({ status: 'warning', message: 'Khóa học này đã có sẵn trong giỏ!' });

        await pool.query('INSERT IGNORE INTO GioHang (MaGH, Ngay_Tao) VALUES (?, CURDATE())', [maGH]);
        await pool.query('INSERT IGNORE INTO BaoGom (MaGH, MaKH) VALUES (?, ?)', [maGH, maKH]);
        
        res.json({ status: 'success', message: 'Đã thêm khóa học vào giỏ hàng thành công!' });
    } catch (error) {
        res.json({ status: 'error', message: 'Lỗi Database: ' + error.message });
    }
});

// 6.2. Hiển thị trang Giỏ hàng
app.get('/gio-hang', requireUser, async (req, res) => {
    const maGH = req.session.user.MaND;
    try {
        const sql = `
            SELECT k.MaKH, k.Ten_Khoa_Hoc, k.Gia_Tien, k.Mo_Ta 
            FROM BaoGom bg
            JOIN KHOA_HOC k ON bg.MaKH = k.MaKH
            WHERE bg.MaGH = ?
        `;
        const [cartItems] = await pool.query(sql, [maGH]);
        
        // Tính tổng tiền
        const tongTien = cartItems.reduce((sum, item) => sum + Number(item.Gia_Tien), 0);

        res.render('cart', { 
            user: req.session.user, 
            cartItems: cartItems,
            tongTien: tongTien 
        });
    } catch (error) {
        res.status(500).send("Lỗi Database: " + error.message);
    }
});

app.post('/thanh-toan', requireUser, async (req, res) => {
    const maHV = req.session.user.MaND;
    const maGH = maHV;
    const connection = await pool.getConnection();

    try {
        await connection.beginTransaction();

        const [cartItems] = await connection.query('SELECT MaKH FROM BaoGom WHERE MaGH = ?', [maGH]);
        if (cartItems.length === 0) throw new Error("Giỏ hàng trống!");

        const maHD = 'HD' + Date.now().toString().slice(-5);
        await connection.query(
            'INSERT INTO HOA_DON (MaHD, Ma_Khach_Hang, Ngay_Thanh_Toan, Phuong_Thuc, Trang_Thai) VALUES (?, ?, CURDATE(), ?, ?)',
            [maHD, maHV, 'CK', 'Đã thanh toán']
        );

        for (let item of cartItems) {
            await connection.query('INSERT INTO Chi_Tiet_Mua (MaHD, MaKH) VALUES (?, ?)', [maHD, item.MaKH]);
            await connection.query('INSERT INTO CoQuyen (MaHV, MaKH, Ngay_Kich_Hoat) VALUES (?, ?, CURDATE())', [maHV, item.MaKH]);
        }

        await connection.query('DELETE FROM BaoGom WHERE MaGH = ?', [maGH]);

        await connection.commit();
        res.json({ status: 'success', message: 'Thanh toán thành công! Khóa học đã được thêm vào Dashboard.' });
    } catch (error) {
        await connection.rollback();
        // Lỗi từ Trigger mua trùng sẽ được hứng và báo ra đây
        res.json({ status: 'error', message: error.message }); 
    } finally {
        connection.release();
    }
});
// 6.4 Xóa 1 item khỏi giỏ hàng
app.post('/xoa-khoi-gio/:makh', requireUser, async (req, res) => {
    try {
        await pool.query('DELETE FROM BaoGom WHERE MaGH = ? AND MaKH = ?', [req.session.user.MaND, req.params.makh]);
        res.redirect('/gio-hang');
    } catch (error) {
        res.status(500).send("Lỗi Database");
    }
});
// ==========================================
// 7. GIAO DIỆN KHÔNG GIAN HỌC TẬP
// ==========================================
app.get('/vao-hoc/:makh', requireUser, async (req, res) => {
    const maHV = req.session.user.MaND;
    const maKH = req.params.makh;

    try {
        // 1. Bảo mật: Kiểm tra xem học viên đã thực sự có quyền (CoQuyen) khóa này chưa
        const [checkQuyen] = await pool.query('SELECT * FROM CoQuyen WHERE MaHV = ? AND MaKH = ?', [maHV, maKH]);
        
        // Nếu không có quyền và cũng không phải ADMIN thì đuổi ra ngoài
        if (checkQuyen.length === 0 && req.session.user.Role !== 'ADMIN') {
            return res.send(`<script>alert("Bạn chưa mua khóa học này!"); window.location.href="/dashboard";</script>`);
        }

        // 2. Lấy thông tin Tên Khóa Học
        const [courseInfo] = await pool.query('SELECT * FROM KHOA_HOC WHERE MaKH = ?', [maKH]);
        
        // 3. Lấy danh sách Bài Học thuộc khóa này (lấy từ bảng BAI_HOC)
        const [lessons] = await pool.query('SELECT * FROM BAI_HOC WHERE MaKH = ? ORDER BY MaBH ASC', [maKH]);

        // 4. Render ra giao diện học tập
        res.render('learning', {
            user: req.session.user,
            course: courseInfo[0],
            lessons: lessons
        });

    } catch (error) {
        res.status(500).send("Lỗi Database: " + error.message);
    }
});

// ==========================================
// KHỞI ĐỘNG SERVER
// ==========================================
app.listen(3000, () => {
    console.log(`🚀 Hệ thống EduManage đang chạy tại: http://localhost:3000`);
});