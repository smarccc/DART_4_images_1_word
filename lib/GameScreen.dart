import 'package:flutter/material.dart';
import 'dart:math';
import 'main_menu.dart'; // Import the main menu screen

void main() {
  runApp(QuizGame());
}

class Level {
  final List<String> images;
  final String correctWord;

  Level(this.images, this.correctWord);
}

class QuizGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '4 Images 1 Word',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int currentLevel = 0;
  late List<Level> levels;
  String guess = "";
  late List<TextEditingController> textControllers;
  late List<Widget> letterButtons;
  Color buttonColor = Color.fromARGB(255, 39, 34, 39); // Static button color

  @override
  void initState() {
    super.initState();
    levels = [
      Level(["assets/images/level1/1.png", "assets/images/level1/2.png", "assets/images/level1/3.png", "assets/images/level1/4.png"], "cold"),
      Level(["assets/images/level2/1.png", "assets/images/level2/2.png", "assets/images/level2/3.png", "assets/images/level2/4.png"], "loud"),
      Level(["assets/images/level3/1.png", "assets/images/level3/2.png", "assets/images/level3/3.png", "assets/images/level3/4.png"], "sweet"),
      Level(["assets/images/level4/1.png", "assets/images/level4/2.png", "assets/images/level4/3.png", "assets/images/level4/4.png"], "raw"),
      Level(["assets/images/level5/1.png", "assets/images/level5/2.png", "assets/images/level5/3.png", "assets/images/level5/4.png"], "ball"),
    ];
    textControllers = [];
    letterButtons = [];
    _initializeLevel();
  }

  // Initialize the level components
  void _initializeLevel() {
    Level level = levels[currentLevel];
    List<String> allLetters = _getAllLetters(level.correctWord);

    // Initialize text controllers for the current level
    textControllers = List.generate(
      level.correctWord.length,
      (index) => TextEditingController(),
    );

    // Initialize letter buttons
    letterButtons = _buildLetterButtons(allLetters);
  }

  // Function to generate all letters needed for buttons
  List<String> _getAllLetters(String correctWord) {
    Set<String> letters = correctWord.split("").toSet();
    List<String> allLetters = List.from(letters);

    // Add additional random letters
    Random random = Random();
    while (allLetters.length < 10) {
      allLetters.add(String.fromCharCode(random.nextInt(26) + 'a'.codeUnitAt(0)));
    }

    allLetters.shuffle(); // Shuffle the letters
    return allLetters;
  }

  @override
  Widget build(BuildContext context) {
    Level level = levels[currentLevel];

    return Scaffold(
      appBar: AppBar(
        title: Text('4 Pics 1 Word - Level ${currentLevel + 1}'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement( // Navigate to main_menu.dart
              context,
              MaterialPageRoute(builder: (context) => MyApp()),
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display images in 2x2 grid
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildImageWithBorder(level.images[0]),
                      _buildImageWithBorder(level.images[1]),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildImageWithBorder(level.images[2]),
                      _buildImageWithBorder(level.images[3]),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            // Input fields for guessing
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                level.correctWord.length,
                (index) => _buildTextField(textControllers[index].text),
              ),
            ),
            SizedBox(height: 20),
            // Button to clear text in text fields
            ElevatedButton(
              onPressed: () {
                textControllers.forEach((controller) => controller.clear());
                setState(() {
                  guess = "";
                });
              },
              child: Text('Clear'),
            ),
            SizedBox(height: 20),
            // Buttons with random letters
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 5,
                childAspectRatio: 2.0, // Adjust the aspect ratio
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: letterButtons,
              ),
            ),
           
         
          ],
        ),
      ),
    );
  }

  // Function to build text field with box border
  Widget _buildTextField(String initialValue) {
    return Container(
      margin: EdgeInsets.all(5), // Add margin
      width: 40,
      child: TextField(
        controller: TextEditingController(text: initialValue),
        maxLength: 1,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: OutlineInputBorder(), // Use box border
          counterText: "", // Hide character counter
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            // Move focus to the next text field
            FocusScope.of(context).nextFocus();
            setState(() {
              guess = textControllers.map((controller) => controller.text).join();
            });
            _checkCorrectAnswer(levels[currentLevel]);
          }
        },
      ),
    );
  }

  // Function to build letter buttons
 List<Widget> _buildLetterButtons(List<String> allLetters) {
  return allLetters.map((letter) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onPressed: () {
        setState(() {
          guess = textControllers.map((controller) => controller.text).join();
        });
        if (guess.length < textControllers.length) {
          for (int i = 0; i < textControllers.length; i++) {
            if (textControllers[i].text.isEmpty) {
              textControllers[i].text = letter;
              allLetters.remove(letter); // Remove letter from available letters
              break;
            }
          }
        }
        _checkCorrectAnswer(levels[currentLevel]); // Check if the answer is correct
      },
      child: Text(
        letter,
        style: TextStyle(color: Colors.white), // Set text color to white
      ),
    );
  }).toList();
}

  // Function to check the guess


  // Function to check if all text fields contain the correct answer
  void _checkCorrectAnswer(Level level) {
    if (textControllers.map((controller) => controller.text).join().toLowerCase() == level.correctWord) {
      _showDialog('Correct!', 'Congratulations, you got it right!', () {
        if (currentLevel < levels.length - 1) {
          setState(() {
            currentLevel++;
            guess = ""; // Reset guess after correct answer
            // Clear text field controllers
            textControllers.forEach((controller) => controller.clear());
            _initializeLevel(); // Reinitialize the level components
          });
        } else {
          // Handle game completion
          _showDialog('Game Over!', 'You completed all levels!', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyApp()),
            );
          });
        }
      });
    }
  }

  // Function to display feedback


  // Function to show dialog
  void _showDialog(String title, String message, [Function()? onPressed]) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onPressed?.call(); // Execute the onPressed function if provided
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Method to build images with border
Widget _buildImageWithBorder(String imagePath) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(
        color: Color.fromARGB(255, 39, 34, 39), // Change border color as needed
        width: 3.0, // Adjust border width as needed
      ),
    ),
    width: 150, // Specify the desired width
    height: 145, // Specify the desired height
    child: Image.asset(
      imagePath,
      fit: BoxFit.contain, // Ensure the image fits within the container
    ),
  );
}
}
