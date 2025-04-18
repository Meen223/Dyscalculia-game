const express = require('express');
const { register, login } = require('../controllers/authController'); // นำเข้า Controller
const { verifyToken } = require('../utils/jwt'); // นำเข้า Middleware สำหรับตรวจสอบ Token

const router = express.Router();

// Route: Profile (ต้องมีการยืนยันตัวตน)
router.get('/profile', verifyToken, (req, res) => {
  res.status(200).json({
    message: 'Profile fetched successfully',
    user: req.user, // ข้อมูลผู้ใช้จาก Token
  });
});

// Route: Sign Up (สมัครสมาชิก)
router.post('/signup', register);

// Route: Login (เข้าสู่ระบบ)
router.post('/login', login);

module.exports = router;
