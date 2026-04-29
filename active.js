const express=require('express');
const mysql=require('mysql2/promise');
const bodyParser=require('body-parser');
const path=require('path');
const { execPath } = require('process');

const app=express();
app.use(bodyParser.json());
app.use(express.static('public'));

const dbconfig={
    host: 'localhost',
    user: 'root',
    password: 'matkhau123',
    database: 'QuanLyKhoaHoc'
};

// api 
app.get('/api/khoahoc',async(req,res)=>{
    try{
        const connection =await mysql.createConnection(dbconfig);
        const [row]= await connection.execute('CALL sp_timkiemkhoahoc'); 
        await connection.end();
        res.json(row);
    }
    catch(error){
        res.status(500).json({message: error.message});
    }
});
// 1. Hàm hiển thị Khóa học doanh thu cao nhất 
let allData = [];
let currentSort = 'desc';

async function loadCourses() {
    const res = await fetch('/api/khoahoc');
    allData = await res.json();
    renderTable(allData);
}

async function toggleSort() {
    currentSort = (currentSort === 'desc') ? 'asc' : 'desc';
    
    document.getElementById('sortIcon').innerText = (currentSort === 'desc') ? '↓' : '↑';

    allData.sort((a, b) => {
        const revenueA = Number(a.DoanhThu || 0);
        const revenueB = Number(b.DoanhThu || 0);
        
        return (currentSort === 'desc') 
            ? revenueB - revenueA  
            : revenueA - revenueB; 
    });

    renderTable(allData);
}

function renderTable(data) {
    const tbody = document.getElementById('courseTableBody');
    
    // Xóa nội dung cũ trước khi vẽ mới
    tbody.innerHTML = "";

    // Dùng map để tạo các dòng <tr>
    tbody.innerHTML = data.map(item => `
        <tr>
            <td class="fw-bold">${item.makh}</td>
            <td>${item.tenkhoahoc}</td>
            <td>${item.tengv}</td>
            <td class="fw-bold text-primary-blue">
                ${Number(item.DoanhThu).toLocaleString()} VNĐ
            </td>
            <td class="text-end">
                <button class="btn-outline-flat" onclick="viewDetails('${item.makh}')">
                    Chi tiết
                </button>
            </td>
        </tr>
    `).join('');
}

// 2. Hàm hiển thị danh sách và tìm kiếm
async function loadFindingCourses() {
    const keyword = document.getElementById('searchInput').value;
    const tbody = document.getElementById('courseTableBody');
    try {
        const res = await fetch(`/api/khoahoc?keyword=${keyword}`);
        const courses = await res.json();

        // Xóa nội dung cũ trước khi vẽ mới
        tbody.innerHTML = "";

        tbody.innerHTML = courses.map(c => `
            <tr>
                <td class="fw-bold">${c.makh}</td>
                <td>${c.tenkhoahoc}</td>
                <td>${c.tengv}</td>
                <td>${Number(c.DoanhThu).toLocaleString()} VNĐ</td>
                <td class="text-end">
                    <span class="badge bg-success rounded-0">Đang hiển thị</span>
                </td>
            </tr>
        `).join('');
    } catch (err) { console.error(err); }
}

// Khởi chạy khi vào trang
document.addEventListener('DOMContentLoaded', () => {
    loadCourses();
});