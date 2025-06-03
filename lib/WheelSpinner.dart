import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class Wheelspinner extends StatefulWidget {
  const Wheelspinner({super.key});

  @override
  State<Wheelspinner> createState() {
    return _WheelspinnerState();
  }
}

class _WheelspinnerState extends State<Wheelspinner>
    with TickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  late AudioPlayer _resultPlayer;
  late AnimationController _controller;
  late Animation<double> _animation;
  late AnimationController _numberController;
  late Animation<double> _scaleAnimation;
  final AudioPlayer _buttonPlayer = AudioPlayer();

  double _currentAngle = 0;
  int _selectedNumber = 1;

  final int segments = 8; // number of wheel segment
  final List<Color> colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.pink,
  ];

  @override
  void initState() {
    super.initState();

    _audioPlayer = AudioPlayer();
    _resultPlayer = AudioPlayer();

    _numberController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _numberController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await _audioPlayer.stop(); //stop music
        if (!mounted) return;
        Future.delayed(
          Duration(milliseconds: 100),
          () => _showCongratulationDialog(),
        );
      }
    });

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _numberController, curve: Curves.elasticOut),
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _animation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.decelerate));

    _controller.addListener(() {
      setState(() {
        _currentAngle = _animation.value;
      });
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _calculateSelectedNumber();
      }
    });
  }

  void _calculateSelectedNumber() async {
    //convert current angle 0 - 2pi range
    double normalizedAngle = _currentAngle % (2 * pi);
    //each segment covers 2 * pi
    double segmentAngle = 2 * pi / segments;

    //since selected spin is clockwise, selected segment is :
    int selectedSegment =
        (segments - (normalizedAngle / segmentAngle).floor()) % segments;
    if (selectedSegment < 0) selectedSegment += segments;

    setState(() {
      _selectedNumber = selectedSegment + 1;
    });

    //play result sound
    await _resultPlayer.play(
      AssetSource('audio/result_music.mp3'),
      volume: 1.0,
    );

    if (!_numberController.isAnimating) {
      _numberController
        ..reset()
        ..forward();
    }
  }

  void _spinWheel() async {
    if (_controller.isAnimating) return;

    //start playing music
    await _audioPlayer.play(AssetSource('audio/spin_music.mp3'), volume: 1.0);

    //Random spin Logic
    //Random number of spins + random extra angle
    final random = Random();
    int spins = random.nextInt(5) + 5; // 5 to 9 spins
    double extraAngle = random.nextDouble() * 2 * pi;

    double newEnd = _currentAngle + spins * 2 * pi + extraAngle;

    _animation = Tween<double>(
      begin: _currentAngle,
      end: newEnd,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.decelerate));

    _controller.reset();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _numberController.dispose();
    _audioPlayer.dispose();
    _resultPlayer.dispose();
    super.dispose();
  }

  void _showCongratulationDialog() {
    // print('Showing Congratulations dialog');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Transform.scale(
              scale: 1.0,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 20,
                      offset: Offset(4, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      size: 60,
                      color: Colors.yellowAccent,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '🎉 Congratulations!',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Your Lucky number is $_selectedNumber',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.deepPurple,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Awesome!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _playButtonSound() async {
    await _buttonPlayer.play(
      AssetSource('audio/button_sound.mp3'),
      volume: 1.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    double size = 300;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Center(
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: EdgeInsets.only(
                top: statusBarHeight,
                left: 20,
                bottom: 16,
              ),
              width: double.infinity,
              height: 170,
              decoration: BoxDecoration(
                color: const Color(0xFF240A78),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        'Welcome, Back',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 172, 171, 171),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        'Discover your lucky number!',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 148, 147, 147),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // const SizedBox(height: 50),

            // Text(
            //   'Hit the button and see!',
            //   style: TextStyle(
            //     color: Colors.white,
            //     fontSize: 17,
            //     fontStyle: FontStyle.italic,
            //   ),
            // ),
            SizedBox(height: 40),
            Stack(
              alignment: Alignment.center,
              children: [
                //spin wheel
                Transform.rotate(
                  angle: _currentAngle,
                  child: CustomPaint(
                    size: Size(size, size),
                    painter: WheelPainter(segments: segments, colors: colors),
                  ),
                ),

                //Center circle to highlight selected number
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Text(
                      '$_selectedNumber',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                _playButtonSound();
                _spinWheel();
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size(230, 55)),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Text('SPIN 🎯', style: TextStyle(fontSize: 24)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WheelPainter extends CustomPainter {
  final int segments;
  final List<Color> colors;

  WheelPainter({required this.segments, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;

    final center = Offset(radius, radius);
    final segmentAngle = 2 * pi / segments;

    final paint = Paint()..style = PaintingStyle.fill;
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < segments; i++) {
      paint.color = colors[i % colors.length];

      double startAngle = i * segmentAngle;

      //Draw segment
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        segmentAngle,
        true,
        paint,
      );

      //draw number text inside segment
      final textSpan = TextSpan(
        text: '${i + 1}',
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );

      textPainter.text = textSpan;
      textPainter.layout();

      //positioning text near the middle of the segment arc
      double textAngle = startAngle + segmentAngle / 2;
      final textRadius = radius * 0.65;

      final offset = Offset(
        center.dx + textRadius * cos(textAngle) - textPainter.width / 2,
        center.dy + textRadius * sin(textAngle) - textPainter.height / 2,
      );

      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(WheelPainter oldDelegate) => false;
}
