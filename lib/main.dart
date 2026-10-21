import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(JapMalaApp());
}

class JapMalaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jap Mala Counter',
      home: JapMalaHomePage(),
    );
  }
}

class JapMalaHomePage extends StatefulWidget {
  @override
  _JapMalaHomePageState createState() => _JapMalaHomePageState();
}

class _JapMalaHomePageState extends State<JapMalaHomePage>
    with SingleTickerProviderStateMixin {
  int _counter = 0;
  int _malaCount = 0;
  String _selectedMala = 'Rudraksha';
  String _selectedLanguage = 'English';

  late AnimationController _animationController;
  late Animation<double> _animation;
  double _currentRotation = 0.0;

  final Map<String, Map<String, String>> _localizedStrings = {
    'English': {
      'appTitle': 'Jap Mala Counter',
      'Rudraksha': 'Rudraksha Mala',
      'Tulsi': 'Tulsi Mala',
      'Sandalwood': 'Sandalwood Mala',
      'completedMala': 'Completed Mala',
      'tapInstruction': 'Tap the Mala to count',
      'reset': 'Reset',
    },
    'Bengali': {
      'appTitle': 'জপ মালা কাউন্টার',
      'Rudraksha': 'রুদ্রাক্ষ মালা',
      'Tulsi': 'তুলসী মালা',
      'Sandalwood': 'চন্দন মালা',
      'completedMala': 'সম্পূর্ণ মালা',
      'tapInstruction': 'জপ করতে মালায় ট্যাপ করুন',
      'reset': 'রিসেট করুন',
    },
    'Hindi': {
      'appTitle': 'जाप माला काउंटर',
      'Rudraksha': 'रुद्राक्ष माला',
      'Tulsi': 'तुलसी माला',
      'Sandalwood': 'चंदन माला',
      'completedMala': 'पूरा माला',
      'tapInstruction': 'जाप करने के लिए माला पर टैप करें',
      'reset': 'रिसेट करें',
    },
  };

  @override
  void initState() {
    super.initState();
    _loadData();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = prefs.getInt('counter') ?? 0;
      _malaCount = prefs.getInt('malaCount') ?? 0;
      _selectedMala = prefs.getString('selectedMala') ?? 'Rudraksha';
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'English';
    });
  }

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', _counter);
    await prefs.setInt('malaCount', _malaCount);
    await prefs.setString('selectedMala', _selectedMala);
    await prefs.setString('selectedLanguage', _selectedLanguage);
  }

  Map<String, dynamic> getMalaTheme() {
    switch (_selectedMala) {
      case 'Tulsi':
        return {
          'primary': Colors.green[700],
          'background': Colors.green[50],
          'cardColor': Colors.green[900],
          'beadColor': Color(0xFF4D7C0F),
          'beadBorder': Color(0xFF365314),
          'threadColor': Colors.lightGreen[200],
        };
      case 'Sandalwood':
        return {
          'primary': Colors.amber[800],
          'background': Colors.amber[50],
          'cardColor': Colors.amber[900],
          'beadColor': Color(0xFFD97706),
          'beadBorder': Color(0xFF78350F),
          'threadColor': Colors.amber[100],
        };
      case 'Rudraksha':
      default:
        return {
          'primary': Colors.deepOrange[800],
          'background': Colors.orange[50],
          'cardColor': Colors.brown[900],
          'beadColor': Color(0xFFB45309),
          'beadBorder': Color(0xFF451A03),
          'threadColor': Colors.deepOrange[200],
        };
    }
  }

  void _incrementCounter() {
    HapticFeedback.lightImpact();

    setState(() {
      _counter++;
      _currentRotation += (2 * pi / 27);
      if (_counter >= 108) {
        _counter = 0;
        _malaCount++;
        HapticFeedback.vibrate();
      }
    });

    _animationController.forward(from: 0);
    _saveData();
  }

  void _resetCounter() {
    HapticFeedback.mediumImpact();
    setState(() {
      _counter = 0;
      _malaCount = 0;
      _currentRotation = 0;
    });
    _saveData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = getMalaTheme();
    final lang = _localizedStrings[_selectedLanguage]!;

    return Scaffold(
      backgroundColor: theme['background'],
      appBar: AppBar(
        title: Text(lang['appTitle']!),
        centerTitle: true,
        backgroundColor: theme['primary'],
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.language, color: Colors.white),
            onSelected: (String langCode) {
              setState(() {
                _selectedLanguage = langCode;
              });
              _saveData();
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(value: 'English', child: Text('English 🇬🇧')),
              PopupMenuItem<String>(value: 'Bengali', child: Text('বাংলা 🇮🇳')),
              PopupMenuItem<String>(value: 'Hindi', child: Text('हिंदी 🇮🇳')),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: theme['primary'], width: 2),
              ),
              child: DropdownButton<String>(
                value: _selectedMala,
                isExpanded: true,
                underline: SizedBox(),
                items: [
                  DropdownMenuItem(value: 'Rudraksha', child: Text(lang['Rudraksha']!)),
                  DropdownMenuItem(value: 'Tulsi', child: Text(lang['Tulsi']!)),
                  DropdownMenuItem(value: 'Sandalwood', child: Text(lang['Sandalwood']!)),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMala = newValue!;
                  });
                  _saveData();
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              '${lang[_selectedMala]} | ${lang['completedMala']}: $_malaCount',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme['cardColor'],
              ),
            ),
            SizedBox(height: 20),

            GestureDetector(
              onTap: _incrementCounter,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  double rotationAngle = _currentRotation -
                      ((1 - _animation.value) * (2 * pi / 27));
                  return CustomPaint(
                    size: Size(260, 260),
                    painter: MalaPainter(
                      beadColor: theme['beadColor'],
                      beadBorderColor: theme['beadBorder'],
                      threadColor: theme['threadColor'],
                      rotationAngle: rotationAngle,
                      malaType: _selectedMala,
                    ),
                    child: Container(
                      width: 260,
                      height: 260,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$_counter',
                              style: TextStyle(
                                fontSize: 55,
                                fontWeight: FontWeight.bold,
                                color: theme['cardColor'],
                              ),
                            ),
                            Text(
                              '/ 108',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: theme['primary'],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 25),
            Text(
              lang['tapInstruction']!,
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _resetCounter,
              icon: Icon(Icons.refresh),
              label: Text(lang['reset']!),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme['cardColor'],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MalaPainter extends CustomPainter {
  final Color beadColor;
  final Color beadBorderColor;
  final Color threadColor;
  final double rotationAngle;
  final String malaType;

  MalaPainter({
    required this.beadColor,
    required this.beadBorderColor,
    required this.threadColor,
    required this.rotationAngle,
    required this.malaType,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    final threadPaint = Paint()
      ..color = threadColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius, threadPaint);

    final int totalVisualBeads = 27;
    final beadRadius = 11.0;

    final beadPaint = Paint()..color = beadColor;
    final borderPaint = Paint()
      ..color = beadBorderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (int i = 0; i < totalVisualBeads; i++) {
      double angle = (2 * pi / totalVisualBeads) * i + rotationAngle;
      double x = center.dx + radius * cos(angle);
      double y = center.dy + radius * sin(angle);

      canvas.drawCircle(Offset(x, y), beadRadius, beadPaint);
      canvas.drawCircle(Offset(x, y), beadRadius, borderPaint);

      if (malaType == 'Rudraksha') {
        final linePaint = Paint()
          ..color = beadBorderColor
          ..strokeWidth = 1;
        canvas.drawLine(
          Offset(x - 4, y - 4),
          Offset(x + 4, y + 4),
          linePaint,
        );
      }
    }

    final guruBeadPaint = Paint()..color = Colors.red[900]!;
    double guruAngle = rotationAngle - (pi / 2);
    double gx = center.dx + radius * cos(guruAngle);
    double gy = center.dy + radius * sin(guruAngle);
    canvas.drawCircle(Offset(gx, gy), beadRadius + 3, guruBeadPaint);
  }

  @override
  bool shouldRepaint(covariant MalaPainter oldDelegate) {
    return oldDelegate.rotationAngle != rotationAngle ||
        oldDelegate.malaType != malaType;
  }
}
