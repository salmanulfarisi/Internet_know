import 'package:flutter/material.dart';
import 'package:flutter_walkthrough_screen/flutter_walkthrough_screen.dart';
import 'package:internet_know/commons/colors.dart';
import 'package:internet_know/ui/home/home.dart';

class MyWalkthrough extends StatelessWidget {
  const MyWalkthrough({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<OnbordingData> list = [
      const OnbordingData(
        image: AssetImage('assets/image/fwatch.jpg'),
        titleText: Text(
          'What internet know about you?',
          style: TextStyle(fontSize: 20),
        ),
        descText: Text(
          'See your private data and how it is used by the internet',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      const OnbordingData(
        titleText: Text("How they gather your data, for ads",
            style: TextStyle(fontSize: 20)),
        descText: Text("You can stop them.", style: TextStyle(fontSize: 16)),
        image: AssetImage('assets/image/iwatch.jpg'),
      ),
      const OnbordingData(
        titleText: Text("Prevent them from keeping your data",
            style: TextStyle(fontSize: 20)),
        descText: Text(
            "You can delete the data and can turn off personalization",
            style: TextStyle(fontSize: 16)),
        image: AssetImage('assets/image/mob.jpg'),
      ),
    ];
    return IntroScreen(
      onbordingDataList: list,
      colors: const [
        //list of colors for per pages
        Colors.white,
        Colors.red,
      ],
      pageRoute: MaterialPageRoute(
        builder: (context) => const AnimationHome(),
      ),
      nextButton: const Text(
        "NEXT",
        style: TextStyle(
          color: purple,
        ),
      ),
      lastButton: const Text(
        "GOT IT",
        style: TextStyle(
          color: purple,
        ),
      ),
      skipButton: const Text(
        "SKIP",
        style: TextStyle(
          color: purple,
        ),
      ),
      selectedDotColor: purple,
      unSelectdDotColor: Colors.grey,
    );
  }
}
