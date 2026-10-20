import 'package:flutter/material.dart';

void main() {
  runApp(JapMalaApp());
}

class JapMalaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'জপ মালা কাউন্টার',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.orange[50],
      ),
      home: JapMalaHomePage(),
    );
  }
}

class JapMalaHomePage extends StatefulWidget {
  @override
  _JapMalaHomePageState createState() => _JapMalaHomePageState();
}

class _JapMalaHomePageState extends State<JapMalaHomePage> {
  int _counter = 0;
  int _malaCount = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
      if (_counter >= 108) {
        _counter = 0;
        _malaCount++;
      }
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
      _malaCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('জপ মালা কাউন্টার'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'সম্পূর্ণ মালা: $_malaCount',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.brown[700]),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: _incrementCounter,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.deepOrange,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$_counter',
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '/ ১০৮',
                        style: TextStyle(fontSize: 18, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Text(
              'বড় গোল বৃত্তে ট্যাপ করুন',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _resetCounter,
              icon: Icon(Icons.refresh),
              label: Text('রিসেট করুন'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
