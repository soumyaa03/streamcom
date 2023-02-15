import 'package:flutter/material.dart';
import 'package:streamcom/view/widgets/custom_button.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  startLiveStream() async {
    Navigator.pushReplacementNamed(
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: CustomButton(
        onTap: startLiveStream,
        text: 'Start Live Stream',
      )),
    );
  }
}
