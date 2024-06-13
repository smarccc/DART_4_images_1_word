import 'dart:async';
import 'package:flutter/material.dart';
import 'main_menu.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
   
    Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
      setState(() {
        _progress += 0.01;
        if (_progress >= 1.0) {
          timer.cancel();
        
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  MyApp()),
          );
        }
      });
    });
  }

  @override
 Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Color.fromARGB(255, 39, 34, 39), 
    appBar: AppBar(
      title: const Text(
        '4 Images 1 Word',
        style: TextStyle(
          color: Color.fromRGBO(255, 255, 255, 1),
          fontSize: 25,
          fontWeight: FontWeight.bold
        ),),
      centerTitle: true,
      backgroundColor: Color.fromARGB(255, 39, 34, 39), 
    ),
    body: Column(
      children: [
        Expanded(
          child: Center(
            child: Image.asset(
              'assets/images/logo1.png', 
              width: 320, 
              height: 320, 
            ),
          ),
        ),
        
       SizedBox(
  height: 20.0, 
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: LinearProgressIndicator(
      backgroundColor: Color.fromARGB(255, 87, 86, 84), 
      valueColor: const AlwaysStoppedAnimation<Color>(Color.fromRGBO(255, 255, 255, 1)), 
      value: _progress, 
    ),
  ),
),
        Padding(
          padding: const EdgeInsets.all(8.0),
          
          child: Text(
            
            '${(_progress * 100).toStringAsFixed(0)}%', 
            style: const TextStyle(
              color:Color.fromRGBO(255, 255, 255, 1), 
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    ),
  );
}


}
