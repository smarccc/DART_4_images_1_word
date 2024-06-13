import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'GameScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Button Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ButtonScreen(),
    );
  }
}

class ButtonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MAIN MENU',
          // Set the title color here
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        // Set the app bar color here
        backgroundColor: Color.fromARGB(255, 39, 34, 39),
      ),
      body: Container(
        // Set the background color for the body here
        color: const Color.fromARGB(255, 39, 34, 39),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Navigate to GameScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuizGame()),
                  );
                },
                child: Text('Play'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Show instructions as a pop-up notification
                 showDialog(
  context: context,
  builder: (BuildContext context) {
    return AlertDialog(
      title: Text('Instructions'),
      content: SingleChildScrollView(
        child: Text(' ▢ Look at the Pictures: \n Youll see four images on your screen. Study them carefully. \n\n ▢ Find the Connection: \n Each picture has something in common with the others. ▢ Figure out what that is. \n\n ▢ Guess the Word: \n Based on the common theme, think of a word that fits all the pictures. \n\n ▢ Use the Letters: \n Below the pictures, youll find a jumble of letters. Use these letters to spell out your guess. \n\n ▢ Submit Your Answer: \n Enter your guess into the blank spaces provided. \n\n ▢ Check if its Right: \n If your guess is correct, youll move on to the next level. If not, try again. \n\n ▢ Enjoy the Challenge: \n It gets trickier as you progress, but thats part of the fun! \n\n ▢ Keep Playing: \n Go through as many levels as you like, challenging yourself to find the connections between the pictures.' ),
      ),
      actions: <Widget>[
        //▢
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Dismiss the dialog
          },
          child: Text('Close'),
        ),
      ],
    );
  },
);

                },
                child: Text('Instructions'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Show confirmation dialog before quitting
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Quit?'),
                        content: Text('Do you really want to quit?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Dismiss the dialog
                            },
                            child: Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              // If user confirms, quit the application
                              SystemNavigator.pop();
                            },
                            child: Text('Yes'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Quit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
