DROP DATABASE IF EXISTS QuanLyKhoaHoc; 
CREATE DATABASE QuanLyKhoaHoc;         
USE QuanLyKhoaHoc;

-- =================================================================
-- PHẦN 1: TẠO BẢNG & DỮ LIỆU (Full ERD)
-- =================================================================

CREATE TABLE NGUOI_DUNG (
  MaND VARCHAR(20) PRIMARY KEY,
  Ten_Dang_Nhap VARCHAR(50) NOT NULL,
  Mat_Khau VARCHAR(255) NOT NULL,
  Ho_Ten VARCHAR(50) NOT NULL,
  Email VARCHAR(50),
  So_Dien_Thoai VARCHAR(15),
  Gioi_Tinh CHAR(3),
  Ngay_Sinh DATE,
  Duong VARCHAR(100),
  Quan VARCHAR(50),
  Thanh_Pho VARCHAR(50)
);

CREATE TABLE HOC_VIEN (
  MaHV VARCHAR(20) PRIMARY KEY,
  Diem_Tich_Luy INT DEFAULT 0
);

CREATE TABLE GIANG_VIEN (
  MaGV VARCHAR(20) PRIMARY KEY,
  Trinh_Do VARCHAR(50)
);

CREATE TABLE KHOA_HOC(
    MaKH VARCHAR(20) PRIMARY KEY,
    MaGV VARCHAR(20),
    Ten_Khoa_Hoc VARCHAR(255) NOT NULL,
    Mo_Ta TEXT,
    Lo_Trinh TEXT,
    Gia_Tien DECIMAL(11) NOT NULL
);

CREATE TABLE Bai_Hoc(
    MaKH VARCHAR(20),
    MaBH VARCHAR(20),
    MaGV VARCHAR(20),
    Ten_Bai_Hoc TEXT NOT NULL,
    Thoi_Gian_Dang DATE NOT NULL,
    Noi_Dung TEXT NOT NULL,
    PRIMARY KEY(MaKH,MaBH)
);

CREATE TABLE Flash_Card(
    MaKH VARCHAR(20),
    MaBH VARCHAR(20),
    MaFC VARCHAR(20),
    Tu_Vung VARCHAR(255) NOT NULL,
    Mo_Ta VARCHAR(255) NOT NULL,
    Hinh_Anh VARCHAR(255),
    Vi_Du VARCHAR(255),
    PRIMARY KEY(MaKH,MaBH,MaFC)
);

CREATE TABLE Bo_De_Thi(
    MaDe VARCHAR(20) PRIMARY KEY,
    MaGV VARCHAR(20),
    Ten_De VARCHAR(255) NOT NULL,
    Nam_Phat_Hanh DATE,
    Tong_Thoi_Gian TIME,
    Thang_Diem_Toi_Da DECIMAL(6,2) DEFAULT 10
);

CREATE TABLE Cau_Hoi(
    MaCH VARCHAR(20),
    MaDe VARCHAR(20),
    Noi_Dung TEXT NOT NULL,
    Giai_Thich TEXT NOT NULL,
    File_Am_Thanh VARCHAR(255),
    Dap_An VARCHAR(255) NOT NULL,
    PRIMARY KEY(MaCH,MaDe)
);

CREATE TABLE Phuong_An_Chon(
    MaCH VARCHAR(20),
    Phuong_AN VARCHAR(20),
    PRIMARY KEY(MaCH,Phuong_An)
);

CREATE TABLE BLOG(
    Ma_Blog VARCHAR(20) PRIMARY KEY,
    Ma_Nguoi_Viet VARCHAR(20),
    Chu_De VARCHAR(255),
    Thoi_Gian TIMESTAMP,
    Noi_Dung_Blog TEXT
);

CREATE TABLE Binh_Luan(
    MaBL VARCHAR(20) PRIMARY KEY,
    Ma_Nguoi_BL VARCHAR(20),
    Noi_Dung TEXT,
    Thoi_Gian TIMESTAMP,
    Ma_Phan_Hoi VARCHAR(20)
);

CREATE TABLE Binh_Luan_Blog(
    MaBL VARCHAR(20) PRIMARY KEY,
    MaBlog VARCHAR(20),
    Luot_Up_Vote DECIMAL(6)
);

CREATE TABLE Binh_Luan_De_Thi(
    MaBL VARCHAR(20) PRIMARY KEY,
    MaDe VARCHAR(20),
    Muc_Do_Kho DECIMAL(3)
);

CREATE TABLE Binh_Luan_Bai_Hoc(
    MaBL VARCHAR(20) PRIMARY KEY,
    MaKH VARCHAR(20),
    MaBH VARCHAR(20),
    Moc_Thoi_Gian TIMESTAMP
);

CREATE TABLE Luot_Bai_Lam(
    MaDe VARCHAR(20),
    MaLuot VARCHAR(20),
    MaNguoiLam VARCHAR(20),
    Diem_So DECIMAL(6,2),
    Ngay_Lam DATE,
    Thoi_Gian_Hoan_Thanh TIME,
    PRIMARY KEY(MaDe,MaLuot)
);

CREATE TABLE Chi_Tiet_Bai_Lam(
    MaDe VARCHAR(20),
    MaLuot VARCHAR(20),
    STT VARCHAR(20),
    MaCH VARCHAR(20),
    Tinh_Dung_Sai DECIMAL(3),
    Phuong_An_Chon VARCHAR(255),
    PRIMARY KEY(MaDe,MaLuot,STT,MaCH)
);

CREATE TABLE GioHang (
  MaGH VARCHAR(20) PRIMARY KEY,
  Ngay_Tao DATE
);

CREATE TABLE HOA_DON (
  MaHD VARCHAR(20) PRIMARY KEY,
  Ma_Khach_Hang VARCHAR(20),
  Ngay_Thanh_Toan DATE,
  Phuong_Thuc VARCHAR(50),
  Trang_Thai VARCHAR(50)
);

CREATE TABLE Chi_Tiet_Mua (
  MaHD VARCHAR(20),
  MaKH VARCHAR(20),
  PRIMARY KEY (MaHD, MaKH)
);

CREATE TABLE CoQuyen (
  MaHV VARCHAR(20),
  MaKH VARCHAR(20),
  Ngay_Kich_Hoat DATE,
  PRIMARY KEY (MaHV, MaKH)
);

CREATE TABLE BaoGom (
  MaKH VARCHAR(20),
  MaGH VARCHAR(20),
  PRIMARY KEY (MaKH, MaGH)
);

-- THÊM KHÓA NGOẠI
ALTER TABLE HOC_VIEN ADD CONSTRAINT FK_HocVien_NguoiDung FOREIGN KEY (MaHV) REFERENCES NGUOI_DUNG(MaND) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE GIANG_VIEN ADD CONSTRAINT FK_GiangVien_NguoiDung FOREIGN KEY (MaGV) REFERENCES NGUOI_DUNG(MaND) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE KHOA_HOC ADD CONSTRAINT fk_khoahoc_gv FOREIGN KEY (MaGV) REFERENCES GIANG_VIEN(MaGV) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE Bai_Hoc ADD CONSTRAINT fk_baihoc_gv FOREIGN KEY (MaGV) REFERENCES GIANG_VIEN(MaGV) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE Flash_Card ADD CONSTRAINT fk_flashcard_baihoc FOREIGN KEY (MaKH,MaBH) REFERENCES Bai_Hoc(MaKH,MaBH) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Bo_De_Thi ADD CONSTRAINT fk_dethi_gv FOREIGN KEY (MaGV) REFERENCES GIANG_VIEN(MaGV) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE Cau_Hoi ADD CONSTRAINT fk_cauoi_dethi FOREIGN KEY (MaDe) REFERENCES Bo_De_Thi(MaDe) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Binh_Luan ADD CONSTRAINT fk_bl_nguoidung FOREIGN KEY (Ma_Nguoi_BL) REFERENCES NGUOI_DUNG(MaND) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE Binh_Luan ADD CONSTRAINT fk_bl_phanhoi FOREIGN KEY (Ma_Phan_Hoi) REFERENCES Binh_Luan(MaBL) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE Binh_Luan_Blog ADD CONSTRAINT fk_bl_blblog FOREIGN KEY (MaBL) REFERENCES Binh_Luan(MaBL) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Binh_Luan_Blog ADD CONSTRAINT fk_blblog_blog FOREIGN KEY (MaBlog) REFERENCES BLOG(Ma_Blog) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE Binh_Luan_De_Thi ADD CONSTRAINT fk_bldt_bl FOREIGN KEY (MaBL) REFERENCES Binh_Luan(MaBL) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Binh_Luan_De_Thi ADD CONSTRAINT fk_bldt_dethi FOREIGN KEY (MaDe) REFERENCES Bo_De_Thi(MaDe) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE Binh_Luan_Bai_Hoc ADD CONSTRAINT fk_blbh_bl FOREIGN KEY (MaBL) REFERENCES Binh_Luan(MaBL) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Binh_Luan_Bai_Hoc ADD CONSTRAINT fk_blbh_bh FOREIGN KEY (MaKH,MaBH) REFERENCES Bai_Hoc(MaKH,MaBH) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE Blog ADD CONSTRAINT fk_nguoidung_blog FOREIGN KEY (Ma_Nguoi_Viet) REFERENCES NGUOI_DUNG(MaND) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE Luot_Bai_Lam ADD CONSTRAINT fk_dethi_luotbailam FOREIGN KEY (MaDe) REFERENCES Bo_De_Thi(MaDe) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Luot_Bai_Lam ADD CONSTRAINT fk_nguoilam_luotbailam FOREIGN KEY (MaNguoiLam) REFERENCES HOC_VIEN(MaHV) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE Chi_Tiet_Bai_Lam ADD CONSTRAINT fk_ctbl_luotbailam FOREIGN KEY (MaDe,MaLuot) REFERENCES Luot_Bai_Lam(MaDe,MaLuot) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Chi_Tiet_Bai_Lam ADD CONSTRAINT fk_ctbl_cauhoi FOREIGN KEY (MaCH,MaDe) REFERENCES Cau_Hoi(MaCH,MaDe) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE HOA_DON ADD CONSTRAINT fk_hd_khachhang FOREIGN KEY (Ma_Khach_Hang) REFERENCES HOC_VIEN(MaHV) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE Chi_Tiet_Mua ADD CONSTRAINT fk_ctm_hd FOREIGN KEY (MaHD) REFERENCES HOA_DON(MaHD) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Chi_Tiet_Mua ADD CONSTRAINT fk_ctm_kh FOREIGN KEY (MaKH) REFERENCES KHOA_HOC(MaKH) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE CoQuyen ADD CONSTRAINT fk_cq_hv FOREIGN KEY (MaHV) REFERENCES HOC_VIEN(MaHV) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE CoQuyen ADD CONSTRAINT fk_cq_kh FOREIGN KEY (MaKH) REFERENCES KHOA_HOC(MaKH) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE BaoGom ADD CONSTRAINT fk_bg_kh FOREIGN KEY (MaKH) REFERENCES KHOA_HOC(MaKH) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE BaoGom ADD CONSTRAINT fk_bg_gh FOREIGN KEY (MaGH) REFERENCES GioHang(MaGH) ON DELETE CASCADE ON UPDATE CASCADE;

-- DỮ LIỆU MẪU ĐỂ TEST
-- =================================================================
-- PHẦN 1.2: DỮ LIỆU MẪU (ÍT NHẤT 5 DÒNG MỖI BẢNG)
-- =================================================================

-- 1. NGUOI_DUNG (5 người: 2 GV, 3 HV)
INSERT INTO NGUOI_DUNG (MaND, Ten_Dang_Nhap, Mat_Khau, Ho_Ten, Email, Gioi_Tinh) VALUES
('ND01', 'teacher_john', '123', 'John Smith', 'john@edu.vn', 'Nam'),
('ND02', 'ms_linh', '123', 'Nguyễn Thị Linh', 'linh@edu.vn', 'Nữ'),
('ND03', 'cuong_pro', '123', 'Lê Văn Cường', 'cuong@gmail.com', 'Nam'),
('ND04', 'lan_anh', '123', 'Trần Lan Anh', 'lananh@gmail.com', 'Nữ'),
('ND05', 'bao_it', '123', 'Trần Hoàng Bảo', 'bao@gmail.com', 'Nam');

-- 2. GIANG_VIEN
INSERT INTO GIANG_VIEN (MaGV, Trinh_Do) VALUES 
('ND01', 'IELTS 8.5'), 
('ND02', 'Thạc sĩ Ngôn ngữ học');

-- 3. HOC_VIEN
INSERT INTO HOC_VIEN (MaHV, Diem_Tich_Luy) VALUES 
('ND03', 150), ('ND04', 200), ('ND05', 50);

-- 4. KHOA_HOC
INSERT INTO KHOA_HOC (MaKH, MaGV, Ten_Khoa_Hoc, Mo_Ta, Gia_Tien) VALUES
('KH01', 'ND01', 'IELTS Intensive Reading', 'Luyện kỹ năng đọc nâng cao', 1500000),
('KH02', 'ND02', 'Ngữ pháp toàn diện', 'Hệ thống lại toàn bộ ngữ pháp', 500000),
('KH03', 'ND01', 'IELTS Writing Task 2', 'Chuyên sâu nghị luận xã hội', 1200000),
('KH04', 'ND02', 'Tiếng Anh giao tiếp cơ bản', 'Phát âm và hội thoại', 800000),
('KH05', 'ND01', 'Từ vựng Academic', 'Bổ sung 3000 từ vựng học thuật', 600000);

-- 5. Bai_Hoc (5 bài cho KH01)
INSERT INTO Bai_Hoc (MaKH, MaBH, MaGV, Ten_Bai_Hoc, Thoi_Gian_Dang, Noi_Dung) VALUES
('KH01', 'BH01', 'ND01', 'Introduction to Reading', '2026-01-01', 'Tổng quan bài thi Reading'),
('KH01', 'BH02', 'ND01', 'Skimming and Scanning', '2026-01-05', 'Kỹ thuật đọc lướt'),
('KH01', 'BH03', 'ND01', 'Matching Headings', '2026-01-10', 'Dạng bài nối tiêu đề'),
('KH01', 'BH04', 'ND01', 'True/False/Not Given', '2026-01-15', 'Kỹ thuật xử lý bẫy'),
('KH01', 'BH05', 'ND01', 'Multiple Choice', '2026-01-20', 'Cách loại trừ phương án');

-- 6. Bo_De_Thi (5 đề với các Thang điểm khác nhau)
INSERT INTO Bo_De_Thi (MaDe, MaGV, Ten_De, Nam_Phat_Hanh, Thang_Diem_Toi_Da) VALUES
('D01', 'ND01', 'IELTS Mock Test 01', '2026-01-01', 9.0),
('D02', 'ND01', 'TOEIC Full Practice', '2026-02-01', 990),
('D03', 'ND02', 'Kiểm tra giữa kỳ', '2026-03-01', 10),
('D04', 'ND02', 'Trắc nghiệm từ vựng', '2026-04-01', 100),
('D05', 'ND01', 'IELTS Reading Final', '2026-05-01', 9.0);

-- 7. Luot_Bai_Lam (5 lượt làm bài cho HV ND03 để test hàm tính điểm)
INSERT INTO Luot_Bai_Lam (MaDe, MaLuot, MaNguoiLam, Diem_So, Ngay_Lam) VALUES
('D01', 'L01', 'ND03', 8.5, '2026-05-01'), -- (8.5/9)*10 = 9.44
('D02', 'L02', 'ND03', 850, '2026-05-02'), -- (850/990)*10 = 8.58
('D03', 'L03', 'ND03', 9.0, '2026-05-03'), -- (9/10)*10 = 9.0
('D04', 'L04', 'ND03', 75, '2026-05-04'),  -- (75/100)*10 = 7.5
('D05', 'L05', 'ND03', 8.0, '2026-05-05'); -- (8/9)*10 = 8.88

-- 8. HOA_DON
INSERT INTO HOA_DON (MaHD, Ma_Khach_Hang, Ngay_Thanh_Toan, Trang_Thai) VALUES
('HD01', 'ND03', '2026-04-01', 'Đã thanh toán'),
('HD02', 'ND04', '2026-04-05', 'Đã thanh toán'),
('HD03', 'ND05', '2026-04-10', 'Chờ thanh toán'),
('HD04', 'ND03', '2026-04-15', 'Đã thanh toán'),
('HD05', 'ND04', '2026-04-20', 'Đã hủy');

-- 9. Chi_Tiet_Mua
INSERT INTO Chi_Tiet_Mua (MaHD, MaKH) VALUES
('HD01', 'KH01'), ('HD02', 'KH02'), ('HD03', 'KH03'), ('HD04', 'KH04'), ('HD05', 'KH05');

-- 10. BLOG
INSERT INTO BLOG (Ma_Blog, Ma_Nguoi_Viet, Chu_De, Noi_Dung_Blog) VALUES
('BL01', 'ND01', 'Mẹo học IELTS', 'Cách đạt 8.0 Reading...'),
('BL02', 'ND02', 'Ngữ pháp', 'Sử dụng thì Hiện tại hoàn thành...'),
('BL03', 'ND03', 'Kinh nghiệm học tập', 'Mình đã tự học như thế nào...'),
('BL04', 'ND01', 'Tin tức', 'Lịch thi IELTS 2026...'),
('BL05', 'ND05', 'Giải trí', 'Học tiếng Anh qua bài hát...');

-- 11. Binh_Luan
INSERT INTO Binh_Luan (MaBL, Ma_Nguoi_BL, Noi_Dung) VALUES
('C01', 'ND03', 'Bài viết rất hay!'),
('C02', 'ND04', 'Cảm ơn thầy ạ.'),
('C03', 'ND05', 'Cho em hỏi chút...'),
('C04', 'ND03', 'Đề này khó quá!'),
('C05', 'ND04', 'Mình làm được 8.0 nè.');

-- 12. Binh_Luan_Blog (Nối các comment trên vào blog)
INSERT INTO Binh_Luan_Blog (MaBL, MaBlog, Luot_Up_Vote) VALUES
('C01', 'BL01', 10), 
('C02', 'BL01', 5), 
('C03', 'BL02', 2), 
('C04', 'BL04', 15), 
('C05', 'BL05', 0);

-- 13. Flash_Card
INSERT INTO Flash_Card (MaKH, MaBH, MaFC, Tu_Vung, Mo_Ta) VALUES
('KH01', 'BH01', 'FC01', 'Analyze', 'Phân tích'),
('KH01', 'BH01', 'FC02', 'Identify', 'Nhận dạng'),
('KH01', 'BH01', 'FC03', 'Specific', 'Cụ thể'),
('KH01', 'BH01', 'FC04', 'Evidence', 'Bằng chứng'),
('KH01', 'BH01', 'FC05', 'Conclusion', 'Kết luận');

-- 14. CoQuyen
INSERT INTO CoQuyen (MaHV, MaKH, Ngay_Kich_Hoat) VALUES
('ND03', 'KH01', '2026-04-01'), ('ND04', 'KH02', '2026-04-05'), ('ND03', 'KH04', '2026-04-15'),
('ND05', 'KH01', '2026-05-01'), ('ND04', 'KH05', '2026-05-01');

-- 15. Cau_Hoi (Cho đề D01)
INSERT INTO Cau_Hoi (MaCH, MaDe, Noi_Dung, Giai_Thich, Dap_An) VALUES
('CH01', 'D01', 'Reading là gì?', 'Dựa vào đoạn 1', 'A'),
('CH02', 'D01', 'Câu 2 chọn gì?', 'Dựa vào đoạn 2', 'B'),
('CH03', 'D01', 'Câu 3 đúng không?', 'Dựa vào đoạn 3', 'C'),
('CH04', 'D01', 'Câu 4 chọn gì?', 'Dựa vào đoạn 4', 'D'),
('CH05', 'D01', 'Câu cuối cùng?', 'Dựa vào đoạn cuối', 'A');
-- =================================================================
-- PHẦN 2: THỦ TỤC THÊM/SỬA/XÓA (CỦA ĐẠT - Câu 2.1)
-- =================================================================
DELIMITER //
CREATE PROCEDURE sp_themkhoahoc(
    IN p_makh VARCHAR(20), IN p_magv VARCHAR(20), IN p_tenkhoahoc VARCHAR(255),
    IN p_mota TEXT, IN p_lotrinh TEXT, IN p_giatien DECIMAL(11)
)
BEGIN
    IF p_giatien < 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Giá tiền không được âm!';
    ELSEIF EXISTS(SELECT 1 FROM KHOA_HOC WHERE MaKH=p_makh) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Khóa học đã tồn tại!';
    ELSE
        INSERT INTO KHOA_HOC(MaKH,MaGV,Ten_Khoa_Hoc,Mo_Ta,Lo_Trinh,Gia_Tien) VALUES(p_makh,p_magv,p_tenkhoahoc,p_mota,p_lotrinh,p_giatien);
        SELECT 'Thêm khóa học thành công!' AS thongbao;
    END IF;
END //

CREATE PROCEDURE p_suakhoahoc(
    IN p_makh VARCHAR(20), IN p_magv VARCHAR(20), IN p_tenkhoahoc VARCHAR(255),
    IN p_mota TEXT, IN p_lotrinh TEXT, IN p_giatien DECIMAL(11)
)
BEGIN
    IF p_giatien < 0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Giá tiền không được âm!';
    ELSE
        UPDATE KHOA_HOC SET Ten_Khoa_Hoc=p_tenkhoahoc, MaGV=p_magv, Mo_Ta=p_mota, Lo_trinh=p_lotrinh, Gia_Tien=p_giatien WHERE MaKH=p_makh;
        SELECT 'Cập nhật thành công!' AS thongbao;
    END IF;
END //

CREATE PROCEDURE p_xoakhoahoc(IN p_makh VARCHAR(20))
BEGIN
    -- Check bảng Chi_Tiet_Mua (đã có hóa đơn mua) theo đúng yêu cầu BTL
    IF EXISTS(SELECT 1 FROM Chi_Tiet_Mua WHERE MaKH=p_makh) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Không thể xóa: khóa học này đã phát sinh hóa đơn mua!';
    ELSE
        DELETE FROM KHOA_HOC WHERE MaKH=p_makh;
        SELECT 'Đã xóa khóa học thành công!' AS thongbao;
    END IF;
END //
DELIMITER ;


-- =================================================================
-- PHẦN 3: THỦ TỤC TÌM KIẾM & THỐNG KÊ (CỦA SANG - Câu 2.3)
-- =================================================================
DELIMITER //
CREATE PROCEDURE sp_TimKiemKhoaHoc(IN p_TuKhoa VARCHAR(255))
BEGIN
    SELECT k.MaKH, k.Ten_Khoa_Hoc, k.Gia_Tien, k.Mo_Ta, 
           g.MaGV, n.Ho_Ten AS Ten_Giang_Vien
    FROM KHOA_HOC k
    LEFT JOIN GIANG_VIEN g ON k.MaGV = g.MaGV
    LEFT JOIN NGUOI_DUNG n ON g.MaGV = n.MaND
    WHERE p_TuKhoa IS NULL OR p_TuKhoa = '' 
       OR k.Ten_Khoa_Hoc LIKE CONCAT('%', p_TuKhoa, '%')
       OR n.Ho_Ten LIKE CONCAT('%', p_TuKhoa, '%')
       OR k.MaKH LIKE CONCAT('%', p_TuKhoa, '%') -- ĐÃ XÓA DẤU CHẤM PHẨY Ở ĐÂY
    ORDER BY k.MaKH ASC; -- DẤU CHẤM PHẨY ĐẶT Ở CUỐI CÙNG
END //
DELIMITER ;

-- Thủ tục 2: Thống kê Doanh thu (JOIN KHOA_HOC, Chi_Tiet_Mua, HOA_DON)
DELIMITER //
-- Thêm tham số đầu vào p_TrangThai để thỏa mãn yêu cầu 2.3
CREATE PROCEDURE sp_ThongKeDoanhThu(IN p_TrangThai VARCHAR(50))
BEGIN
    SELECT k.MaKH, k.Ten_Khoa_Hoc, n.Ho_Ten AS Ten_Giang_Vien,
           IFNULL(SUM(k.Gia_Tien), 0) AS DoanhThu
    FROM KHOA_HOC k
    LEFT JOIN Chi_Tiet_Mua ctm ON k.MaKH = ctm.MaKH
    LEFT JOIN HOA_DON hd ON ctm.MaHD = hd.MaHD
    LEFT JOIN GIANG_VIEN g ON k.MaGV = g.MaGV
    LEFT JOIN NGUOI_DUNG n ON g.MaGV = n.MaND
    WHERE hd.Trang_Thai = p_TrangThai -- Sử dụng tham số trong WHERE
    GROUP BY k.MaKH, k.Ten_Khoa_Hoc, n.Ho_Ten
    ORDER BY DoanhThu DESC;
END //
DELIMITER ;


-- =================================================================
-- PHẦN 4: TRIGGER NGHIỆP VỤ & DẪN XUẤT (CỦA HUY - Câu 2.2)
-- =================================================================
DELIMITER //
-- Trigger 1: Chặn mua trùng khóa học
CREATE TRIGGER trg_ChongMuaTrung
BEFORE INSERT ON Chi_Tiet_Mua
FOR EACH ROW
BEGIN
    DECLARE v_MaHV VARCHAR(20);
    -- Tìm xem Hóa đơn này là của Học viên nào
    SELECT Ma_Khach_Hang INTO v_MaHV FROM HOA_DON WHERE MaHD = NEW.MaHD;
    
    -- Nếu Học viên đó đã có khóa học trong bảng CoQuyen -> Lỗi
    IF EXISTS (SELECT 1 FROM CoQuyen WHERE MaKH = NEW.MaKH AND MaHV = v_MaHV) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi Nghiệp vụ: Học viên đã sở hữu khóa học này, không thể thêm vào hóa đơn!';
    END IF;
END //

-- Trigger 2: Thuộc tính dẫn xuất cộng dồn điểm tích lũy
CREATE TRIGGER trg_CongDiemTichLuy
AFTER INSERT ON Luot_Bai_Lam
FOR EACH ROW
BEGIN
    DECLARE v_DiemCaoNhatCu DECIMAL(6,2);
    SELECT MAX(Diem_So) INTO v_DiemCaoNhatCu FROM Luot_Bai_Lam 
    WHERE MaNguoiLam = NEW.MaNguoiLam AND MaDe = NEW.MaDe AND MaLuot != NEW.MaLuot;
    
    SET v_DiemCaoNhatCu = IFNULL(v_DiemCaoNhatCu, 0);
    
    IF NEW.Diem_So > v_DiemCaoNhatCu THEN
        UPDATE HOC_VIEN 
        SET Diem_Tich_Luy = IFNULL(Diem_Tich_Luy, 0) + (NEW.Diem_So - v_DiemCaoNhatCu)
        WHERE MaHV = NEW.MaNguoiLam;
    END IF;
END //
DELIMITER ;


-- =================================================================
-- PHẦN 5: FUNCTION CURSOR LƯU TRỮ VÀ XẾP LOẠI (CỦA BẢO - Câu 2.4)
-- =================================================================
DELIMITER //
-- ==============================================
-- 1. HÀM TÍNH ĐIỂM TRUNG BÌNH (QUY ĐỔI ĐỘNG THEO THANG ĐIỂM CSDL)
-- ==============================================
CREATE FUNCTION fn_TinhDiemTrungBinh(p_MaHV VARCHAR(20)) 
RETURNS DECIMAL(4,2) 
READS SQL DATA
BEGIN
    DECLARE v_DiemSo DECIMAL(6,2);
    DECLARE v_ThangDiemToiDa DECIMAL(6,2);
    DECLARE v_DiemQuyDoi DECIMAL(6,2);
    DECLARE v_TongDiem DECIMAL(10,2) DEFAULT 0;
    DECLARE v_SoLuot INT DEFAULT 0;
    DECLARE v_DiemTB DECIMAL(6,2);
    DECLARE done INT DEFAULT FALSE;
    
    -- [Yêu cầu 2.4]: Con trỏ kết nối 2 bảng để lấy Điểm số và Thang điểm tối đa
    DECLARE cur_Diem CURSOR FOR 
        SELECT lbl.Diem_So, bdt.Thang_Diem_Toi_Da 
        FROM Luot_Bai_Lam lbl
        JOIN Bo_De_Thi bdt ON lbl.MaDe = bdt.MaDe
        WHERE lbl.MaNguoiLam = p_MaHV;
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- [Yêu cầu 2.4]: Validation kiểm tra tham số đầu vào
    IF NOT EXISTS (SELECT 1 FROM HOC_VIEN WHERE MaHV = p_MaHV) THEN 
        RETURN NULL; 
    END IF;

    -- [Yêu cầu 2.4]: Sử dụng Vòng lặp và cấu trúc rẽ nhánh để tính toán
    OPEN cur_Diem;
    read_loop: LOOP
        FETCH cur_Diem INTO v_DiemSo, v_ThangDiemToiDa;
        IF done THEN LEAVE read_loop; END IF;
        
        -- Logic bảo vệ: Nếu giảng viên quên nhập thang điểm tối đa (NULL) hoặc nhập = 0, mặc định là thang 10
        IF v_ThangDiemToiDa IS NULL OR v_ThangDiemToiDa = 0 THEN 
            SET v_ThangDiemToiDa = 10; 
        END IF;

        -- CÔNG THỨC CHUẨN: (Điểm đạt được / Thang điểm tối đa) * 10
        SET v_DiemQuyDoi = (v_DiemSo / v_ThangDiemToiDa) * 10;
        
        -- Chống tràn: Phòng trường hợp nhập điểm cao hơn cả điểm tối đa
        IF v_DiemQuyDoi > 10 THEN
            SET v_DiemQuyDoi = 10;
        END IF;

        -- Cộng dồn điểm quy chuẩn và số bài đã làm
        SET v_TongDiem = v_TongDiem + v_DiemQuyDoi;
        SET v_SoLuot = v_SoLuot + 1;
    END LOOP;
    CLOSE cur_Diem;

    -- Trả về điểm trung bình làm tròn 2 chữ số thập phân
    IF v_SoLuot > 0 THEN 
        SET v_DiemTB = v_TongDiem / v_SoLuot;
        RETURN ROUND(v_DiemTB, 2); 
    END IF;
    
    RETURN NULL;
END //

-- ==============================================
-- 2. HÀM XẾP LOẠI HỌC VIÊN (CÓ ĐÍNH KÈM ĐIỂM)
-- ==============================================
CREATE FUNCTION fn_XepLoaiHocVien(p_MaHV VARCHAR(20)) 
RETURNS VARCHAR(50) 
READS SQL DATA
BEGIN
    DECLARE v_DiemTB DECIMAL(4,2);
    
    -- Lấy dữ liệu từ hàm tính toán phía trên
    SET v_DiemTB = fn_TinhDiemTrungBinh(p_MaHV);
    
    IF v_DiemTB IS NULL THEN 
        RETURN 'Chưa có dữ liệu'; 
    END IF;
    
    -- Xếp loại học lực
    IF v_DiemTB >= 9.0 THEN RETURN CONCAT('Xuất Sắc (', v_DiemTB, '/10)');
    ELSEIF v_DiemTB >= 8.0 THEN RETURN CONCAT('Giỏi (', v_DiemTB, '/10)');
    ELSEIF v_DiemTB >= 7.0 THEN RETURN CONCAT('Khá (', v_DiemTB, '/10)');
    ELSEIF v_DiemTB >= 5.0 THEN RETURN CONCAT('Trung Bình (', v_DiemTB, '/10)');
    ELSE RETURN CONCAT('Cần Cố Gắng (', v_DiemTB, '/10)');
    END IF;
END //

DELIMITER ;