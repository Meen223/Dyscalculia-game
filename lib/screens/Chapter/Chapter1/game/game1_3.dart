import 'dart:math';
import 'package:flutter/material.dart';
// เพิ่มบรรทัดถัดไปเพื่ออ้างอิงหน้า Game1_4
import 'game1_4.dart';  // <-- (1) เพิ่มบรรทัดนี้

class Game1_3 extends StatefulWidget {
  @override
  _Game1_3State createState() => _Game1_3State();
}

class _Game1_3State extends State<Game1_3> {
  List<int> originalNumbers = [];
  List<int> userNumbers = [];

  @override
  void initState() {
    super.initState();
    generateRandomNumbers();
  }

  void generateRandomNumbers() {
    final random = Random();
    originalNumbers.clear();
    while (originalNumbers.length < 5) {
      int num = random.nextInt(10) + 1; // สุ่ม 1-10
      if (!originalNumbers.contains(num)) {
        originalNumbers.add(num);
      }
    }
    userNumbers = List.from(originalNumbers);
  }

  void checkAnswers() {
    final sortedNumbers = List.from(originalNumbers)..sort();

    if (userNumbers.toString() == sortedNumbers.toString()) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('สำเร็จแล้ว!'),
          content: Text('คุณเรียงลำดับถูกต้องทั้งหมด'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('ปิด'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // แก้บรรทัดด้านล่างนี้ จาก pushReplacementNamed(...) เป็น pushReplacement(...) ไป Game1_4
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Game1_4()),
                );
                // ^^^ (2) แก้จาก Named Route เป็น MaterialPageRoute
              },
              child: Text('ไปข้อถัดไป'),
            )
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ยังเรียงลำดับผิดอยู่ ลองอีกครั้ง!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('เกม: เรียงลำดับจากน้อยไปมาก'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: 'เริ่มเกมใหม่',
            onPressed: () {
              setState(() {
                generateRandomNumbers();
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'ลากและวางตัวเลขเพื่อเรียงลำดับจากน้อยไปมาก',
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ReorderableListView(
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final item = userNumbers.removeAt(oldIndex);
                    userNumbers.insert(newIndex, item);
                  });
                },
                children: [
                  for (int i = 0; i < userNumbers.length; i++)
                    ListTile(
                      key: ValueKey(userNumbers[i]),
                      leading: ReorderableDragStartListener(
                        index: i,
                        child: Icon(Icons.drag_handle),
                      ),
                      title: Text(
                        '${userNumbers[i]}',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 18 : 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      tileColor: Colors.blue[100],
                    ),
                ],
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: checkAnswers,
              child: Text('ตรวจสอบ'),
            ),
          ],
        ),
      ),
    );
  }
}
