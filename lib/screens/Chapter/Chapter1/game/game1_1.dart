import 'package:flutter/material.dart';
import 'game1_2.dart';

class Game1_1 extends StatefulWidget {
  @override
  _Game1_1State createState() => _Game1_1State();
}

class _Game1_1State extends State<Game1_1> {
  final List<int> numbers = List.generate(10, (index) => index + 1);
  final Map<int, String> images = {
    1: 'assets/images/one.png',
    2: 'assets/images/two.png',
    3: 'assets/images/three.png',
    4: 'assets/images/four.png',
    5: 'assets/images/five.png',
    6: 'assets/images/six.png',
    7: 'assets/images/seven.png',
    8: 'assets/images/eight.png',
    9: 'assets/images/nine.png',
    10: 'assets/images/ten.png',
  };

  int? selectedNumber;
  int? selectedImage;
  final Set<int> correctStages = {}; // เก็บสถานะคำตอบที่ถูกต้อง

  void resetGame() {
    setState(() {
      selectedNumber = null;
      selectedImage = null;
      correctStages.clear();
    });
  }

  void autoCheckMatch() {
    if (selectedNumber != null && selectedImage != null) {
      if (selectedNumber == selectedImage) {
        setState(() {
          correctStages.add(selectedNumber!); // บันทึกคำตอบที่ถูกต้อง
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('จับคู่ถูกต้อง!'),
              backgroundColor: Colors.green,
            ),
          );
          selectedNumber = null;
          selectedImage = null;
        });
        if (correctStages.length == numbers.length) {
          checkCompletion();
        }
      } else {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('ลองอีกครั้ง!'),
              backgroundColor: Colors.red,
            ),
          );
          selectedNumber = null;
          selectedImage = null;
        });
      }
    }
  }

  void checkCompletion() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('สำเร็จแล้ว!'),
        content: Text('คุณจับคู่ถูกทั้งหมดแล้ว'),
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
                MaterialPageRoute(builder: (context) => Game1_2()), // ใช้ MaterialPageRoute
              );
            },
            child: Text('ข้อถัดไป'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เกม: จับคู่จำนวนและสัญลักษณ์'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: resetGame,
            tooltip: 'เริ่มเกมใหม่',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'จับคู่ตัวเลขกับรูปภาพที่มีปริมาณตรงกัน',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Expanded(
              child: Row(
                children: [
                  // คอลัมน์ตัวเลข
                  Expanded(
                    child: ListView.builder(
                      itemCount: numbers.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: correctStages.contains(numbers[index])
                              ? null // หากตอบถูกแล้ว จะไม่สามารถกดได้อีก
                              : () {
                            setState(() {
                              selectedNumber = numbers[index];
                            });
                            autoCheckMatch(); // ตรวจสอบอัตโนมัติ
                          },
                          child: Card(
                            color: correctStages.contains(numbers[index])
                                ? Colors.grey[300] // หากตอบถูกแล้ว
                                : selectedNumber == numbers[index]
                                ? Colors.blue[100]
                                : Colors.white,
                            child: ListTile(
                              title: Text(
                                '${numbers[index]}',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // คอลัมน์รูปภาพ
                  Expanded(
                    child: ListView.builder(
                      itemCount: images.keys.length,
                      itemBuilder: (context, index) {
                        int key = images.keys.elementAt(index);
                        return GestureDetector(
                          onTap: correctStages.contains(key)
                              ? null // หากตอบถูกแล้ว จะไม่สามารถกดได้อีก
                              : () {
                            setState(() {
                              selectedImage = key;
                            });
                            autoCheckMatch(); // ตรวจสอบอัตโนมัติ
                          },
                          child: Card(
                            color: correctStages.contains(key)
                                ? Colors.grey[300] // หากตอบถูกแล้ว
                                : selectedImage == key
                                ? Colors.green[100]
                                : Colors.white,
                            child: ListTile(
                              title: Image.asset(
                                images[key]!,

                                height: 50,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
