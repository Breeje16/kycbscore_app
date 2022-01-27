import 'package:flutter/material.dart';
import 'package:traveller_ratings/presentation/journeys/check_screen.dart';
import 'package:traveller_ratings/presentation/journeys/profile_screen.dart';
import 'package:traveller_ratings/presentation/journeys/rate_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  List listOfScreens = [
    const RateScreen(),
    const CheckScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text("Traveller Ratings"),
        ),
      ),
      body: listOfScreens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.blue.shade100,
          labelTextStyle: MaterialStateProperty.all(const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          )),
        ),
        child: NavigationBar(
            height: 60,
            backgroundColor: const Color(0xFFf1f5fb),
            selectedIndex: index,
            onDestinationSelected: (index) =>
                setState(() => this.index = index),
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.rate_review_outlined),
                  selectedIcon: Icon(Icons.rate_review),
                  label: 'Rate'),
              NavigationDestination(
                  icon: Icon(Icons.find_in_page_outlined),
                  selectedIcon: Icon(Icons.find_in_page),
                  label: 'Check'),
              NavigationDestination(
                  icon: Icon(Icons.account_box_outlined),
                  selectedIcon: Icon(Icons.account_box),
                  label: 'Profile'),
            ]),
      ),
    );
  }
}
