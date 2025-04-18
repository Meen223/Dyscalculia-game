import 'package:flutter/material.dart';

class Success1 extends StatelessWidget {
  const Success1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      appBar: AppBar(
        title: Text('สรุปบทที่ 1'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: isSmallScreen ? 150 : 200,
                height: isSmallScreen ? 150 : 200,
                child: Image.asset(
                  'assets/images/success.png',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 24),
              Text(
                'จบบทที่ 1 แล้ว!',
                style: TextStyle(
                  fontSize: isSmallScreen ? 24 : 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              SizedBox(height: 16),
              Text(
                'คุณได้ผ่านกิจกรรมทั้งหมดของบทที่ 1 เรียบร้อย',
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 20,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Text('กลับสู่หน้าหลัก'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
