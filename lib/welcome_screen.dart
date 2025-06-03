import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:random_number_generator/home_screen.dart';
import 'package:random_number_generator/custom_button.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() {
    return _WelcomeScreenState();
  }
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();
  int currentPageIndex = 0;

  void goToHome(BuildContext context) {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF240A78), Color(0xFF3B1E8F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: IntroductionScreen(
          key: introKey,
          pages: [
            //first one
            PageViewModel(
              titleWidget: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(
                      "Welcome to Lucky Spin",
                      textStyle: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      speed: Duration(milliseconds: 80),
                    ),
                  ],
                  totalRepeatCount: 1,
                  pause: Duration(milliseconds: 1000),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
                ),
              ),
              bodyWidget: AnimatedThenStaticText(
                text: "Spin the wheel and discover your lucky number.",
                repeatCount: 2,
              ),
              footer: Image.asset('assets/images/first_splash.png'),
              decoration: getPageDecoration(),
            ),
            //second one
            PageViewModel(
              titleWidget: Padding(
                padding: EdgeInsetsGeometry.only(top: 30.0),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(
                      "Simple & Fun",
                      textStyle: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      speed: Duration(milliseconds: 80),
                    ),
                  ],
                  totalRepeatCount: 1,
                  pause: Duration(milliseconds: 1000),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
                ),
              ),
              bodyWidget: AnimatedThenStaticText(
                text: "Just tap to spin. Each time, a surprise awaits!",
                repeatCount: 2,
              ),
              footer: Image.asset('assets/images/second_splash.png'),
              decoration: getPageDecoration(),
            ),
            //third one
            PageViewModel(
              titleWidget: Padding(
                padding: EdgeInsetsGeometry.only(top: 20.0),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(
                      "Celebrate Your Luck",
                      textStyle: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      speed: Duration(milliseconds: 80),
                    ),
                  ],
                  totalRepeatCount: 1,
                  pause: Duration(milliseconds: 1000),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
                ),
              ),
              bodyWidget: AnimatedThenStaticText(
                text: "Get a popUp with your lucky number. Enjoy the thrill!",
                repeatCount: 2,
              ),
              footer: Image.asset('assets/images/third_splashe.png'),
              decoration: getPageDecoration(),
            ),
          ],
          onChange: (index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          onDone: () => goToHome(context),
          showSkipButton: false,
          showNextButton: false,
          showDoneButton: false,
          dotsDecorator: getDotDecoration(),
          globalFooter: Container(
            color: const Color(0xFF240A78), // Match the page background
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomButton(
                    text: "Previous",
                    onPressed: () {
                      introKey.currentState?.previous();
                    },
                    backgroundColor: Colors.amber,
                    textColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomButton(
                    text: "Skip",
                    onPressed: () {
                      goToHome(context);
                    },
                    backgroundColor: Colors.amber,
                    textColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomButton(
                    text: "Next",
                    onPressed: () {
                      if (currentPageIndex == 2) {
                        goToHome(context);
                      } else {
                        introKey.currentState?.next();
                      }
                    },
                    backgroundColor: Colors.amber,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PageDecoration getPageDecoration() => const PageDecoration(
    titleTextStyle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    bodyTextStyle: TextStyle(fontSize: 18, color: Colors.white70),
    imagePadding: EdgeInsets.all(24),
    pageColor: Color(0xFF240A78),
    titlePadding: EdgeInsets.only(top: 40),
    bodyPadding: EdgeInsets.symmetric(horizontal: 16),
  );

  DotsDecorator getDotDecoration() => const DotsDecorator(
    size: Size(10, 10),
    activeSize: Size(22, 10),
    activeColor: Colors.amber,
    color: Color(0xFF240A78),
    spacing: EdgeInsets.symmetric(horizontal: 3),
    activeShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(25)),
    ),
  );
}

class AnimatedThenStaticText extends StatefulWidget {
  final String text;
  final int repeatCount;

  const AnimatedThenStaticText({
    super.key,
    required this.text,
    required this.repeatCount,
  });

  @override
  State<AnimatedThenStaticText> createState() => _AnimatedThenStaticText();
}

class _AnimatedThenStaticText extends State<AnimatedThenStaticText> {
  bool _showFinalText = false;

  @override
  Widget build(BuildContext context) {
    if (_showFinalText) {
      return Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: Text(
          widget.text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.white70),
        ),
      );
    }
    return AnimatedTextKit(
      animatedTexts: [
        FadeAnimatedText(
          widget.text,
          textStyle: TextStyle(fontSize: 18, color: Colors.white70),
        ),
      ],
      totalRepeatCount: widget.repeatCount,
      isRepeatingAnimation: false,
      onFinished: () {
        setState(() {
          _showFinalText = true;
        });
      },
    );
  }
}

// class FadeInBodyText extends StatefulWidget {
//   final String text;

//   const FadeInBodyText({super.key, required this.text});

//   @override
//   State<FadeInBodyText> createState() => _FadeInBodyTextState();
// }

// class _FadeInBodyTextState extends State<FadeInBodyText> {
//   bool _showFinalText = false;

//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration(milliseconds: 200), () {
//       setState(() {
//         _showFinalText = true;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedOpacity(
//       opacity: _showFinalText ? 1.0 : 0.0,
//       duration: Duration(seconds: 2),
//       child: Padding(
//         padding: const EdgeInsets.only(top: 40.0),
//         child: Text(
//           widget.text,
//           textAlign: TextAlign.center,
//           style: TextStyle(fontSize: 18, color: Colors.white70),
//         ),
//       ),
//     );
//   }
// }
