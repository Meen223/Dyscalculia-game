import 'dart:math';
import 'package:flutter/material.dart';
import 'game1_3.dart'; // ตรวจสอบให้เส้นทางถูกต้อง

class Game1_2 extends StatefulWidget {
  @override
  _Game1_2State createState() => _Game1_2State();
}

class _Game1_2State extends State<Game1_2> {
  final List<int> numbers = List.generate(10, (index) => index + 1);
  List<int> missingNumbers = []; // ตัวเลขที่หายไป
  List<int?> userAnswers = [null, null]; // เก็บคำตอบของผู้ใช้

  @override
  void initState() {
    super.initState();
    generateMissingNumbers(); // สุ่มหมายเลขที่หายไป
  }

  void generateMissingNumbers() {
    final random = Random();
    missingNumbers = [];
    while (missingNumbers.length < 2) {
      int randomNum = random.nextInt(10) + 1; // สุ่มเลข 1-10
      if (!missingNumbers.contains(randomNum)) {
        missingNumbers.add(randomNum);
      }
    }
    userAnswers = List.filled(missingNumbers.length, null);
  }

  void checkAnswers() {
    if (userAnswers[0] == missingNumbers[0] &&
        userAnswers[1] == missingNumbers[1]) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('สำเร็จแล้ว!'),
          content: Text('คุณเติมหมายเลขถูกต้องทั้งหมด'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // ปิด Popup
              },
              child: Text('ปิด'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Game1_3()),
                ); // ใช้ MaterialPageRoute สำหรับไปยัง game1_3
              },
              child: Text('ไปข้อถัดไป'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ยังมีหมายเลขที่ผิด ลองอีกครั้ง!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('เกม: ตามหาหมายเลขที่หายไป'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                generateMissingNumbers(); // สุ่มหมายเลขใหม่
              });
            },
            tooltip: 'เริ่มเกมใหม่',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'เติมหมายเลขที่หายไปในลำดับตัวเลข',
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.02),
              Wrap(
                spacing: screenWidth * 0.02,
                runSpacing: screenHeight * 0.01,
                alignment: WrapAlignment.center,
                children: numbers.map((number) {
                  if (missingNumbers.contains(number)) {
                    int index = missingNumbers.indexOf(number);
                    return Container(
                      width: screenWidth * 0.1,
                      height: screenWidth * 0.1,
                      margin:
                      EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: userAnswers[index] != null
                          ? Center(
                        child: Text(
                          '${userAnswers[index]}',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                          : null,
                    );
                  } else {
                    return Container(
                      width: screenWidth * 0.1,
                      height: screenWidth * 0.1,
                      margin:
                      EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Center(
                        child: Text(
                          '$number',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }
                }).toList(),
              ),
              SizedBox(height: screenHeight * 0.02),
              Wrap(
                spacing: screenWidth * 0.02,
                runSpacing: screenHeight * 0.01,
                alignment: WrapAlignment.center,
                children: numbers.map((number) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (!userAnswers.contains(number)) {
                          int emptyIndex = userAnswers.indexOf(null);
                          if (emptyIndex != -1) {
                            userAnswers[emptyIndex] = number;
                          }
                        }
                      });
                    },
                    child: Container(
                      width: screenWidth * 0.1,
                      height: screenWidth * 0.1,
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Center(
                        child: Text(
                          '$number',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: screenHeight * 0.04),
              ElevatedButton(
                onPressed: checkAnswers,
                child: Text('ตรวจสอบ'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.02,
                    horizontal: screenWidth * 0.1,
                  ),
                  textStyle: TextStyle(
                    fontSize: isSmallScreen ? 16 : 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
