import 'package:flutter/material.dart';
import 'success1.dart';

class Game1_5 extends StatefulWidget {
  @override
  _Game1_5State createState() => _Game1_5State();
}

class _Game1_5State extends State<Game1_5> {
  int currentQuestion = 5;
  int totalQuestions = 10;

  final Map<int, String> correctMapping = {
    1: 'หนึ่ง',
    2: 'สอง',
    3: 'สาม',
    4: 'สี่',
    5: 'ห้า',
    6: 'หก',
  };

  late List<int> leftNumbers;
  late List<String> rightWords;
  final Set<int> matchedLeft = {};
  final Set<String> matchedRight = {};
  int? selectedLeft;
  String? selectedRight;

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    leftNumbers = [1, 2, 3, 4, 5, 6];
    rightWords = correctMapping.values.toList()..shuffle();
    matchedLeft.clear();
    matchedRight.clear();
    selectedLeft = null;
    selectedRight = null;
  }

  void checkAnswers() {
    if (matchedLeft.length == 6) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('สำเร็จแล้ว!'),
          content: Text('คุณจับคู่ตัวเลขกับคำอ่านครบถูกต้องทั้งหมด'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('ปิด'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/success1');
              },
              child: Text('ไปหน้าสรุป'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ยังมีคู่ที่ไม่ถูก หรือยังไม่ครบ ลองจับคู่ต่อ!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void tryMatchPair() {
    if (selectedLeft == null || selectedRight == null) return;
    if (correctMapping[selectedLeft!] == selectedRight) {
      setState(() {
        matchedLeft.add(selectedLeft!);
        matchedRight.add(selectedRight!);
        selectedLeft = null;
        selectedRight = null;
      });
      if (matchedLeft.length == 6) {
        Future.delayed(Duration(milliseconds: 300), () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('สำเร็จแล้ว!'),
              content: Text('คุณจับคู่ตัวเลขกับคำอ่านครบถูกต้องทั้งหมด'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('ปิด'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/success1');
                  },
                  child: Text('ไปหน้าสรุป'),
                ),
              ],
            ),
          );
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ไม่ถูกต้อง ลองใหม่!'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        selectedLeft = null;
        selectedRight = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อที่ $currentQuestion เชื่อมโยงตัวเลขกับคำอ่าน'),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.green,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '0 | $totalQuestions',
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'คลิกตัวเลขฝั่งซ้าย -> คลิกคำอ่านฝั่งขวา\nจับคู่ให้ถูกต้อง (1->หนึ่ง, 2->สอง, ...)',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: leftNumbers.length,
                    itemBuilder: (context, index) {
                      final num = leftNumbers[index];
                      bool isMatched = matchedLeft.contains(num);
                      bool isSelected = (selectedLeft == num);
                      return GestureDetector(
                        onTap: () {
                          if (isMatched) return;
                          setState(() {
                            if (selectedLeft == num) {
                              selectedLeft = null;
                            } else {
                              selectedLeft = num;
                            }
                          });
                          tryMatchPair();
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isMatched
                                ? Colors.grey[300]
                                : isSelected
                                ? Colors.green[300]
                                : Colors.green[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$num',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isMatched ? Colors.grey[600] : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: rightWords.length,
                    itemBuilder: (context, index) {
                      final word = rightWords[index];
                      bool isMatched = matchedRight.contains(word);
                      bool isSelected = (selectedRight == word);
                      return GestureDetector(
                        onTap: () {
                          if (isMatched) return;
                          setState(() {
                            if (selectedRight == word) {
                              selectedRight = null;
                            } else {
                              selectedRight = word;
                            }
                          });
                          tryMatchPair();
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isMatched
                                ? Colors.grey[300]
                                : isSelected
                                ? Colors.orange[300]
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            word,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: isMatched ? Colors.grey[600] : Colors.black87,
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton.icon(
              icon: Icon(Icons.check),
              label: Text('ตรวจสอบ'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                textStyle: TextStyle(fontSize: 18),
              ),
              onPressed: checkAnswers,
            ),
          ),
        ],
      ),
    );
  }
}
