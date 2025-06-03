import 'package:flutter/material.dart';
import 'package:random_number_generator/WheelSpinner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFF240A78),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Center(
          child: Text(
            'Lucky Spin',
            style: TextStyle(
              color: const Color.fromARGB(255, 236, 235, 235),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          // color: Color(0xFF1A1A40), // soft coral
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 90, 7, 134),
              Color.fromARGB(255, 36, 10, 120),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Wheelspinner(),
      ),
    );
  }
}
