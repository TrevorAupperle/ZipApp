import 'package:flutter/material.dart';
import 'package:zipapp/business/user.dart';
import 'package:zipapp/constants/zip_colors.dart';
//import 'package:zipapp/ui/widgets/map.dart' as mapwidget;
import 'package:zipapp/ui/widgets/mapWidget.dart' as mapwidget;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZipColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: ZipColors.primaryBackground,
        titleSpacing: 0.0,
        leading: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 0),
            child: Image.asset(
              'assets/two_tone_zip_black.png',
              width: 40,
              height: 40,
            )),
        title: Text('Good afternoon, ${userService.user.firstName}',
            style: const TextStyle(
                fontSize: 24.0,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w500)),
      ),
      body: const Center(
        child: mapwidget.MapWidget(driver: false),
      ),
    );
  }
}
