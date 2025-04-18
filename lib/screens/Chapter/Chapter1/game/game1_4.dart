import 'dart:math';
import 'package:flutter/material.dart';
// (1) เพิ่ม import หน้าเกมถัดไป
import 'game1_5.dart';

class Game1_4 extends StatefulWidget {
  @override
  _Game1_4State createState() => _Game1_4State();
}

class _Game1_4State extends State<Game1_4> {
  int currentQuestion = 4;     // แสดงว่าเป็นข้อที่ 4
  int totalQuestions = 10;     // รวม 10 ข้อ
  int score = 0;               // กำหนดคะแนน 0 ไว้ก่อน (ตัวอย่าง)

  List<int> gridNumbers = [];  // เลขที่จะแสดงบน grid 12 ช่อง
  int differentIndex = -1;     // ตำแหน่งเลขที่ต่าง
  List<int> bottomOptions = []; // ตัวเลือกข้างล่าง 3 ช่อง
  int? selectedOption;         // ผู้เล่นเลือกตัวไหน

  @override
  void initState() {
    super.initState();
    generateNumbers();
  }

  /// สร้างเลขในตาราง 12 ช่อง
  /// 11 ช่องเป็นเลขเหมือนกัน, 1 ช่องแตกต่าง
  void generateNumbers() {
    final random = Random();
    gridNumbers.clear();

    // สุ่มเลขหลัก (1-9)
    int baseNum = random.nextInt(9) + 1;

    // สุ่มเลขที่ต่าง (1-9) แต่ไม่ให้ซ้ำ baseNum
    int diffNum = baseNum;
    while (diffNum == baseNum) {
      diffNum = random.nextInt(9) + 1;
    }

    // ใส่ baseNum 11 ครั้ง
    for (int i = 0; i < 11; i++) {
      gridNumbers.add(baseNum);
    }
    // เพิ่มตัวที่ต่าง 1 ครั้ง
    gridNumbers.add(diffNum);

    // สุ่มสลับ
    gridNumbers.shuffle();

    // หาตำแหน่ง (index) ของตัวที่ต่าง
    differentIndex = gridNumbers.indexOf(diffNum);

    // กำหนดตัวเลือกข้างล่าง 3 ช่อง (รวมเลขที่ต่าง)
    bottomOptions.clear();
    bottomOptions.add(diffNum);  // ตัวเลือกที่ถูกต้อง
    // สุ่มอีก 2 ตัว (1-9) ที่ไม่ซ้ำ diffNum
    while (bottomOptions.length < 3) {
      int newOption = random.nextInt(9) + 1;
      if (!bottomOptions.contains(newOption)) {
        bottomOptions.add(newOption);
      }
    }
    // สุ่มสลับตัวเลือกให้กระจาย
    bottomOptions.shuffle();

    selectedOption = null; // รีเซ็ตตัวเลือกของผู้เล่น
  }

  /// เมื่อกดปุ่มตรวจสอบ
  void checkAnswer() {
    // ถ้าผู้เล่นยังไม่เลือก bottomOptions เลย
    if (selectedOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('โปรดเลือกคำตอบก่อน'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // ตัวเลขที่แตกต่างจริง ๆ คือ gridNumbers[differentIndex]
    int actualDiff = gridNumbers[differentIndex];

    // หากผู้เล่นเลือกตรงกับ actualDiff
    if (selectedOption == actualDiff) {
      // ตัวอย่าง +1 คะแนน (ถ้ามีระบบสะสมคะแนนจริงอาจต้องรับค่าจากหน้าที่แล้ว)
      setState(() {
        score++;
      });
      // แสดง Dialog ตอบถูก
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('ถูกต้อง!'),
          content: Text('คุณเลือกตัวเลขที่แตกต่างได้ถูกต้อง'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('ปิด'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // (2) ไปหน้า game1_5 ด้วย pushReplacement
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Game1_5()),
                );
              },
              child: Text('ไปข้อถัดไป'),
            ),
          ],
        ),
      );
    } else {
      // ตอบผิด
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ยังไม่ถูกต้อง ลองใหม่!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      // (3) ใช้ PreferredSize เพื่อสร้าง AppBar ที่กำหนดเอง (ถ้าอยากได้ทรงโค้ง หรือใส่ Row ตรงกลาง ฯลฯ)
      appBar: AppBar(
        title: Text('ข้อที่ $currentQuestion หาตัวเลขที่แตกต่าง'),
        // สามารถเพิ่ม actions ได้หากต้องการ หรือใส่คะแนน
      ),
      body: Column(
        children: [
          // ส่วนคะแนน (0 | 10)
          Container(
            color: Colors.green,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$score | $totalQuestions',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 20 : 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'คะแนน',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 18 : 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // แสดง gridNumbers 12 ช่อง (4 แถว x 3 คอลัมน์)
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              itemCount: gridNumbers.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.green[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${gridNumbers[index]}',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 24 : 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // เส้นคั่น
          Divider(thickness: 2, height: 2),

          // ตัวเลือกด้านล่าง bottomOptions 3 ช่อง
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Wrap(
              spacing: 16,
              children: bottomOptions.map((num) {
                bool isSelected = (num == selectedOption);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = num;
                    });
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green[700] : Colors.green[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '$num',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 24 : 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // ปุ่มตรวจสอบ
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ElevatedButton.icon(
              icon: Icon(Icons.check),
              label: Text('ตรวจสอบ'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
                textStyle: TextStyle(fontSize: 20),
              ),
              onPressed: checkAnswer,
            ),
          ),
        ],
      ),
    );
  }
}
