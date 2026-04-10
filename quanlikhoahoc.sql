DROP DATABASE IF EXISTS quanlykhoahoc;
CREATE DATABASE IF NOT EXISTS QuanLyKhoaHoc;
/* 2026-04-02 13:26:39 [2 ms] */ 
USE QuanLyKhoaHoc;
/* 2026-04-02 13:26:41 [28 ms] */ 
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
    Hinh_Anh VARCHAR(255), -- luu link cua anh
    Vi_Du VARCHAR(255),
    PRIMARY KEY(MaKH,MaBH,MaFC)

    
);
CREATE TABLE Bo_De_Thi(
    MaGV VARCHAR(20),
    MaDe VARCHAR(20),
    Ten_De VARCHAR(255) NOT NULL,
    Nam_Phat_Hanh DATE,
    Tong_Thoi_Gian TIME,
    PRIMARY KEY(MaDe)

    
);
CREATE TABLE Cau_Hoi(
    MaCH VARCHAR(20),
    MaDe VARCHAR(20),
    Noi_Dung TEXT NOT NULL,
    Giai_Thich TEXT NOT NULL,
    Fill_Am_Thanh VARCHAR(255), -- link file am thanh
    Dap_An VARCHAR(255) NOT NULL, -- luu dang ABDCABDD
    PRIMARY KEY(MaCH,MaDe)
    
    
);
CREATE TABLE Binh_Luan(
    MaBL VARCHAR(20),
    Ma_Nguoi_BL VARCHAR(20),
    Noi_Dung TEXT,
    Thoi_Gian TIMESTAMP,
    Ma_Phan_Hoi VARCHAR(20),
    PRIMARY KEY(MaBL)

    
);
CREATE TABLE Binh_Luan_Blog(
    MaBL VARCHAR(20) PRIMARY KEY,
    MaBlog VARCHAR(20),
    Luot_Up_Vote DECIMAL(6)

    
);
CREATE TABLE Binh_Luan_De_Thi(
    MaBL VARCHAR(20) PRIMARY KEY,
    MaDe VARCHAR(20),
    Muc_Do_Kho DECIMAL(3) -- luu dang tu 0 den 99 diem kho

    
);
CREATE TABLE Binh_Luan_Bai_Hoc(
    MaBl VARCHAR(20) PRIMARY KEY,
    MaKH VARCHAR(20),
    MaBH VARCHAR(20),
    Moc_Thoi_Gian TIMESTAMP

    
);
CREATE TABLE BLOG(
    Ma_Nguoi_Viet VARCHAR(20),
    Ma_Blog VARCHAR(20) PRIMARY KEY,
    Chu_De VARCHAR(255),
    Thoi_Gian TIMESTAMP,
    Noi_Dung_Blog TEXT

    
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
CREATE TABLE Phuong_An_Chon(
    MaCH VARCHAR(20),
    Phuong_AN VARCHAR(20),
    PRIMARY KEY(MaCH,Phuong_An)
);
CREATE TABLE NGUOI_DUNG (
  Ten_Dang_Nhap VARCHAR(50) NOT NULL,
  Mat_Khau VARCHAR(255) NOT NULL,
  So_Dien_Thoai VARCHAR(15),
  Email VARCHAR(50),
  Ngay_Sinh DATE,
  Ho_Ten VARCHAR(50) NOT NULL,
  MaND VARCHAR(20) PRIMARY KEY,
  Gioi_Tinh CHAR(3),
  
  Duong VARCHAR(100),
  Quan VARCHAR(50),
  Thanh_Pho VARCHAR(50)
);

CREATE TABLE HOC_VIEN (
  MaHV VARCHAR(20) PRIMARY KEY,
  Diem_Tich_Luy INT

  
);

CREATE TABLE GIANG_VIEN (
  MaGV VARCHAR(20) PRIMARY KEY,
  Trinh_Do VARCHAR(50)
  
  
);

CREATE TABLE GioHang (
  MaGH VARCHAR(20) PRIMARY KEY,
  Ngay_Tao DATE
);

CREATE TABLE HOA_DON (
  MaHD VARCHAR(20) PRIMARY KEY,
  Ngay_Thanh_Toan DATE,
  Phuong_Thuc VARCHAR(10),
  Trang_Thai VARCHAR(10)
);

CREATE TABLE CoQuyen (
  MaKH VARCHAR(20),
  MaHV VARCHAR(20),
  Ngay_Kich_Hoat DATE,
  PRIMARY KEY (MaHV, MaKH)
);

CREATE TABLE BaoGom (
  MaKH VARCHAR(20),
  MaGH VARCHAR(20),
  PRIMARY KEY (MaKH, MaGH)
  
);



--them khoa ngoai
ALTER TABLE KHOA_HOC
ADD CONSTRAINT fk_khoahoc_gv
    Foreign Key (MaGV) REFERENCES Giang_Vien(MaGV)
    ON DELETE SET NULL
    ON UPDATE CASCADE;

ALTER TABLE Bai_Hoc
ADD CONSTRAINT fk_baihoc_gv
    FOREIGN KEY (MaGV) REFERENCES Giang_Vien(MaGV)
    ON DELETE SET NULL
    ON UPDATE CASCADE;

ALTER TABLE Flash_Card
ADD CONSTRAINT fk_flashcard_baihoc
    Foreign Key (MaKH,MaBH) REFERENCES Bai_Hoc(MaKH,MaBH)
    ON DELETE CASCADE
    ON UPDATE CASCADE;


ALTER TABLE Bo_De_Thi
ADD CONSTRAINT fk_dethi_gv
    Foreign Key (MaGV) REFERENCES Giang_Vien(MaGV)
    ON DELETE SET NULL
    ON UPDATE CASCADE;


ALTER TABLE Cau_Hoi
ADD CONSTRAINT fk_cauoi_dethi
    Foreign Key (MaDe) REFERENCES Bo_De_Thi(MaDe)
    ON DELETE CASCADE
    ON UPDATE CASCADE;


ALTER TABLE Binh_Luan
ADD CONSTRAINT fk_bl_nguoidung
    Foreign Key (Ma_Nguoi_BL) REFERENCES Nguoi_Dung(MaND)
    ON DELETE SET NULL
    ON UPDATE CASCADE,

ADD CONSTRAINT fk_bl_phanhoi
    Foreign Key (Ma_Phan_Hoi) REFERENCES Binh_Luan(MaBL)
    ON DELETE SET NULL
    ON UPDATE CASCADE;


ALTER TABLE Binh_Luan_Blog
ADD CONSTRAINT fk_bl_blblog
    Foreign Key (MaBL) REFERENCES Binh_Luan(MaBL)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

ADD CONSTRAINT fk_blblog_blog
    Foreign Key (MaBlog) REFERENCES BLOG(Ma_BLog)
    ON DELETE SET NULL
    ON UPDATE CASCADE;


ALTER TABLE Binh_Luan_De_Thi
ADD CONSTRAINT fk_bldt_bl
    Foreign Key (MaBL) REFERENCES Binh_Luan(MaBL)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

ADD CONSTRAINT fk_bldt_dethi
    Foreign Key (MaDe) REFERENCES Bo_De_Thi(MaDe)
    ON DELETE SET NULL
    ON UPDATE CASCADE;


ALTER TABLE Binh_Luan_Bai_Hoc
ADD CONSTRAINT fk_blbh_bl
    Foreign Key (MaBL) REFERENCES Binh_Luan(MaBL)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

ADD CONSTRAINT fk_blbh_bh
    Foreign Key (MaKH,MaBH) REFERENCES Bai_Hoc(MaKH,MaBH)
    ON DELETE SET NULL
    ON UPDATE CASCADE;


ALTER TABLE Blog
ADD CONSTRAINT fk_nguoidung_blog
    Foreign Key (Ma_Nguoi_Viet) REFERENCES Nguoi_Dung(MaND)
    ON DELETE SET NULL
    ON UPDATE CASCADE;


ALTER TABLE Luot_Bai_Lam
ADD CONSTRAINT fk_dethi_luotbailam
    Foreign Key (MaDe) REFERENCES Bo_De_Thi(MaDe)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

ADD CONSTRAINT fk_nguoilam_luotbailam
    Foreign Key (MaNguoiLam) REFERENCES Hoc_Vien(MaHV)
    ON DELETE SET NULL
    ON UPDATE CASCADE;


ALTER TABLE Chi_Tiet_Bai_Lam
ADD CONSTRAINT fk_ctbl_luotbailam
    Foreign Key (MaDe,MaLuot) REFERENCES Luot_Bai_Lam(MaDe,MaLuot)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
ADD CONSTRAINT fk_ctbl_cauhoi
    Foreign Key (MaCH,MaDe) REFERENCES Cau_Hoi(MaCH,MaDe)
    ON DELETE CASCADE
    ON UPDATE CASCADE;


ALTER TABLE HOC_VIEN
ADD CONSTRAINT FK_HocVien_NguoiDung 
  FOREIGN KEY (MaHV) REFERENCES NGUOI_DUNG(MaND)
  ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE GIANG_VIEN
ADD CONSTRAINT FK_GiangVien_NguoiDung 
  FOREIGN KEY (MaGV) REFERENCES NGUOI_DUNG(MaND)
  ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE CoQuyen
ADD CONSTRAINT fk_cq_hv 
FOREIGN KEY (MaHV) REFERENCES HOC_VIEN(MaHV)
ON DELETE CASCADE
ON UPDATE CASCADE,
ADD CONSTRAINT fk_cq_kh 
FOREIGN KEY (MaKH) REFERENCES KHOA_HOC(MaKH)
ON DELETE CASCADE
ON UPDATE CASCADE;


ALTER TABLE BaoGom
ADD CONSTRAINT fk_bg_kh
FOREIGN KEY (MaKH) REFERENCES KHOA_HOC(MaKH)
ON DELETE CASCADE
ON UPDATE CASCADE,
ADD CONSTRAINT fk_bg_gh
FOREIGN KEY (MaGH) REFERENCES GioHang(MaGH)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- them khoa hoc
DELIMITER //
CREATE PROCEDURE sp_themkhoahoc(
    IN p_makh VARCHAR(20),
    IN p_magv VARCHAR(20),
    IN p_tenkhoahoc VARCHAR(255),
    IN p_mota TEXT,
    IN p_lotrinh TEXT,
    IN p_giatien DECIMAL(11)
)
BEGIN
    IF p_giatien < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Giá tiền không được nhỏ hơn 0!';
    ELSEIF EXISTS(SELECT 1 FROM KHOA_HOC WHERE MaKH=p_makh) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Khóa học đã tồn tại!';
    ELSEIF p_tenkhoahoc='' OR p_tenkhoahoc IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Tên khóa học không được để trống!';
    ELSE
        INSERT INTO KHOA_HOC(MaKH,MaGV,Ten_Khoa_Hoc,Mo_Ta,Lo_Trinh,Gia_Tien)
        VALUES(p_makh,p_magv,p_tenkhoahoc,p_mota,p_lotrinh,p_giatien);
        SELECT 'Thêm khóa học thành công!' AS thongbao;
    END IF;
END//
DELIMITER ;


-- sua khoa hoc
DELIMITER //
CREATE Procedure p_suakhoahoc(
    IN p_makh VARCHAR(20),
    IN p_magv VARCHAR(20),
    IN p_tenkhoahoc VARCHAR(255),
    IN p_mota TEXT,
    IN p_lotrinh TEXT,
    IN p_giatien DECIMAL(11)
)
BEGIN
    IF p_giatien < 0 THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Giá tiền không được nhỏ hơn không!';
    ELSEIF NOT EXISTS(SELECT 1 FROM KHOA_HOC WHERE MaKH=p_makh) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = "Lỗi: không tìm thấy khoa học!";
    ELSE
        UPDATE KHOA_HOC
        SET Ten_Khoa_Hoc=p_tenkhoahoc,
            MaGV=p_magv,
            Mo_Ta=p_mota,
            Lo_trinh=p_lotrinh,
            Gia_Tien=p_giatien
        WHERE MaKH=p_makh;
        SELECT 'Cập nhật thành công!' AS thongbao;
    END IF;
END //
DELIMITER ;

--xoa khoa hoc
DELIMITER //
CREATE PROCEDURE p_xoakhoahoc(
    IN p_makh VARCHAR(20)
)
BEGIN
    IF EXISTS(SELECT 1 FROM CoQuyen WHERE MaKH=p_makh) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không thể xóa: khóa học này đã có học viên sở hữu';
    ELSEIF NOT EXISTS(SELECT 1 FROM KHOA_HOC WHERE MaKH=p_makh) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: mã khóa học không tồn tại!';
    ELSE
        DELETE FROM KHOA_HOC WHERE MaKH=p_makh;
        SELECT 'Đã xóa khóa học thành công!' AS thongbao;
    END IF;
END //
DELIMITER ;

-- Chèn 5 người dùng (2 giáo viên, 3 học viên)
INSERT INTO NGUOI_DUNG (MaND, Ten_Dang_Nhap, Mat_Khau, Ho_Ten, Email, So_Dien_Thoai, Gioi_Tinh) VALUES
('ND01', 'teacher_john', '123', 'Mr. John Smith', 'john@edu.vn', '0912345678', 'Nam'),
('ND02', 'ms_linh', '123', 'Nguyễn Thị Linh', 'linh.grammar@edu.vn', '0922345678', 'Nữ'),
('ND03', 'cuong_pro', '123', 'Lê Văn Cường', 'cuong.hv@gmail.com', '0932345678', 'Nam'),
('ND04', 'lan_english', '123', 'Trần Thị Lan', 'lan.study@gmail.com', '0942345678', 'Nữ'),
('ND05', 'minh_toiec', '123', 'Hoàng Văn Minh', 'minh.hv@gmail.com', '0952345678', 'Nam');

-- Xác định vai trò
INSERT INTO GIANG_VIEN (MaGV, Trinh_Do) VALUES 
('ND01', 'IELTS 8.5 - TESOL'), 
('ND02', 'Thạc sĩ Ngôn ngữ Anh');

INSERT INTO HOC_VIEN (MaHV, Diem_Tich_Luy) VALUES 
('ND03', 150), ('ND04', 80), ('ND05', 0);




-- 5 Khóa học tiếng Anh tiêu biểu
INSERT INTO KHOA_HOC (MaKH, MaGV, Ten_Khoa_Hoc, Mo_Ta, Gia_Tien) VALUES
('KH01', 'ND01', 'IELTS Intensive Reading', 'Luyện kỹ năng đọc chuyên sâu cho IELTS', 1500000),
('KH02', 'ND02', 'Ngữ pháp toàn diện', 'Hệ thống lại toàn bộ ngữ pháp tiếng Anh', 500000),
('KH03', 'ND01', 'TOEIC 750+ Cấp tốc', 'Luyện đề TOEIC format mới nhất', 900000),
('KH04', 'ND02', 'Tiếng Anh giao tiếp công sở', 'Tập trung vào môi trường làm việc', 1200000),
('KH05', 'ND01', 'Phát âm chuẩn IPA', 'Luyện phát âm từ bảng ký tự quốc tế', 400000);

-- 5 Bài học mẫu
INSERT INTO Bai_Hoc (MaKH, MaBH, MaGV, Ten_Bai_Hoc, Thoi_Gian_Dang, Noi_Dung) VALUES
('KH01', 'BH01', 'ND01', 'Kỹ thuật Skimming & Scanning', '2024-01-10', 'Cách đọc nhanh lấy ý chính...'),
('KH02', 'BH01', 'ND02', 'Thì hiện tại hoàn thành', '2024-01-12', 'Cách dùng Have/Has + V3...'),
('KH03', 'BH01', 'ND01', 'Bí kíp Part 5 TOEIC', '2024-01-15', 'Mẹo xử lý nhanh 30 câu hỏi...'),
('KH04', 'BH01', 'ND02', 'Cách viết Email cho sếp', '2024-01-20', 'Cấu trúc Dear Manager...'),
('KH05', 'BH01', 'ND01', 'Âm hữu thanh và vô thanh', '2024-01-25', 'Phân biệt âm P và B...');

-- 5 Flashcard ôn từ vựng
INSERT INTO Flash_Card (MaKH, MaBH, MaFC, Tu_Vung, Mo_Ta, Vi_Du) VALUES
('KH02', 'BH01', 'FC01', 'Accomplish', 'Hoàn thành, đạt được', 'I want to accomplish my goals.'),
('KH04', 'BH01', 'FC01', 'Sincerely', 'Một cách chân thành', 'Yours sincerely,'),
('KH01', 'BH01', 'FC01', 'Analyze', 'Phân tích', 'You need to analyze the data.'),
('KH03', 'BH01', 'FC01', 'Strategy', 'Chiến lược', 'We need a new test strategy.'),
('KH05', 'BH01', 'FC01', 'Vibrate', 'Rung động', 'Your throat should vibrate.');





-- 5 Blog hướng dẫn học tập
INSERT INTO BLOG (Ma_Blog, Ma_Nguoi_Viet, Chu_De, Thoi_Gian, Noi_Dung_Blog) VALUES
('B01', 'ND01', 'Lộ trình IELTS cho người mới', NOW(), 'Bước 1 hãy học phát âm...'),
('B02', 'ND02', '10 lỗi ngữ pháp hay gặp', NOW(), 'Lỗi chia thì, lỗi danh từ số nhiều...'),
('B03', 'ND01', 'Học tiếng Anh qua bài hát', NOW(), 'Giai điệu giúp nhớ từ vựng lâu hơn...'),
('B04', 'ND02', 'Phân biệt IELTS và TOEIC', NOW(), 'Nên thi chứng chỉ nào để đi làm?...'),
('B05', 'ND01', 'Tại sao bạn nghe mãi không ra?', NOW(), 'Do bạn chưa nắm vững quy tắc nối âm...');

-- 5 Bình luận mẫu (Trộn giữa Blog, Bài học, Đề thi)
INSERT INTO Binh_Luan (MaBL, Ma_Nguoi_BL, Noi_Dung, Thoi_Gian) VALUES
('BL01', 'ND03', 'Bài viết Blog rất hữu ích ạ!', NOW()),
('BL02', 'ND04', 'Phần ngữ pháp này em vẫn hơi khó hiểu.', NOW()),
('BL03', 'ND05', 'Đề thi này khó quá sếp ơi!', NOW()),
('BL04', 'ND03', 'Cảm ơn thầy John vì bài học Skimming.', NOW()),
('BL05', 'ND04', 'Flashcard rất dễ học, em đã thuộc từ!', NOW());

-- Phân loại bình luận
INSERT INTO Binh_Luan_Blog (MaBL, MaBlog, Luot_Up_Vote) VALUES ('BL01', 'B01', 10);
INSERT INTO Binh_Luan_Bai_Hoc (MaBL, MaKH, MaBH) VALUES ('BL02', 'KH02', 'BH01');
INSERT INTO Binh_Luan_Bai_Hoc (MaBL, MaKH, MaBH) VALUES ('BL04', 'KH01', 'BH01');





-- 5 Đề thi tiếng Anh
INSERT INTO Bo_De_Thi (MaDe, MaGV, Ten_De, Nam_Phat_Hanh, Tong_Thoi_Gian) VALUES
('D01', 'ND01', 'IELTS Reading Mock Test 1', '2024-01-01', '01:00:00'),
('D02', 'ND02', 'Final Grammar Quiz', '2024-02-01', '00:30:00'),
('D03', 'ND01', 'TOEIC Full Test #101', '2024-03-01', '02:00:00'),
('D04', 'ND01', 'Business English Vocab', '2024-03-15', '00:15:00'),
('D05', 'ND02', 'Placement Test (Đầu vào)', '2024-04-01', '00:45:00');

-- 5 Câu hỏi trắc nghiệm
INSERT INTO Cau_Hoi (MaCH, MaDe, Noi_Dung, Giai_Thich, Dap_An) VALUES
('C01', 'D02', 'I ___ a student.', 'Thì hiện tại đơn với be', 'am'),
('C01', 'D01', 'What is the synonym of Big?', 'Từ đồng nghĩa', 'Large'),
('C01', 'D03', 'Choose the correct word: ___', 'Part 5 TOEIC', 'Strategy'),
('C01', 'D04', 'End a formal email with: ___', 'Business writing', 'Sincerely'),
('C02', 'D02', 'She ___ TV every night.', 'Thì hiện tại đơn ngôi thứ 3', 'watches');

-- 5 Lượt làm bài của học viên
INSERT INTO Luot_Bai_Lam (MaDe, MaLuot, MaNguoiLam, Diem_So, Ngay_Lam) VALUES
('D02', 'L01', 'ND03', 10.0, '2024-04-20'),
('D02', 'L02', 'ND04', 8.0, '2024-04-20'),
('D01', 'L01', 'ND03', 7.5, '2024-04-21'),
('D03', 'L01', 'ND05', 650.0, '2024-04-22'),
('D05', 'L01', 'ND04', 9.0, '2024-04-23');

-- Chi tiết từng câu trả lời trong lượt làm bài
INSERT INTO Chi_Tiet_Bai_Lam (MaDe, MaLuot, STT, MaCH, Tinh_Dung_Sai, Phuong_An_Chon) VALUES
('D02', 'L01', '1', 'C01', 1, 'am'),
('D02', 'L01', '2', 'C02', 1, 'watches'),
('D02', 'L02', '1', 'C01', 1, 'am'),
('D02', 'L02', '2', 'C02', 0, 'watch'),
('D01', 'L01', '1', 'C01', 1, 'Large');