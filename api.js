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

// api lay danh sach khoa hoc
app.get('/api/khoahoc',async(req,res)=>{
    try{
        const connection =await mysql.createConnection(dbconfig);
        const [row]= await connection.execute('SELECT * FROM KHOA_HOC');
        await connection.end();
        res.json(row);
    }
    catch(error){
        res.status(500).json({message: error.message});
    }
});


//api them khoa hoc
app.post('/api/khoahoc',async(req,res)=>{
    const {makh,magv,tenkhoahoc,mota,lotrinh,giatien}=req.body;
    try{
        const connection=await mysql.createConnection(dbconfig);
        const [result]= await connection.query(
            'CALL sp_themkhoahoc(?,?,?,?,?,?)',
            [makh,magv,tenkhoahoc,mota,lotrinh,giatien]
        );
        await connection.end();
        res.json({message: result[0][0].thongbao});
    }
    catch(error){
        res.status(400).json({message: error.sqlMessage || error.message});
    }
});

//api sua khoa hoc
app.put('/api/khoahoc/:id',async(req,res)=>{
    const makh=req.params.id;
    const {magv,tenkhoahoc,mota,lotrinh,giatien}=req.body;
    try{
        const connection =await mysql.createConnection(dbconfig);
        const [result]=await connection.query(
            'CALL p_suakhoahoc(?,?,?,?,?,?)',
            [makh,magv,tenkhoahoc,mota,lotrinh,giatien]
        );
        await connection.end();
        res.json({message: result[0][0].thongbao});
    }
    catch(error){
        res.status(400).json({message: error.sqlMessage || error.message});
    }
});

//api xoa khoa hoc
app.delete('/api/khoahoc/:id',async(req,res)=>{
    const makh=req.params.id;
    try{
        const connection=await mysql.createConnection(dbconfig);
        const [result]=await connection.query('Call p_xoakhoahoc(?)',[makh]);
        await connection.end();
        res.json({message: result[0][0].thongbao});
    }
    catch(error){
        res.status(400).json({message: error.sqlMessage || error.message});
    }
});

app.listen(3000,()=>console.log('Server chay tai https://localhost:3000  ///http://127.0.0.1:3000/ '));