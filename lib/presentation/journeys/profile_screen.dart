import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:traveller_ratings/data/shared_pref/prefs.dart';
import 'package:traveller_ratings/presentation/blocs/authentication/authentication_cubit.dart';
import 'package:traveller_ratings/presentation/journeys/signup_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  fetchUserDetails() async {
    var token = await Prefs.getToken();
    var hotelName = await Prefs.getHotelName();
    var hotelCity = await Prefs.getHotelCity();
    var hotelCountry = await Prefs.getHotelCountry();
  }

  late AuthenticationCubit authCubit;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
    authCubit = BlocProvider.of<AuthenticationCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            "Account",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircleAvatar(
                radius: 60.0,
                backgroundImage: AssetImage(
                  'assets/images/kycblogo.png',
                ),
                backgroundColor: Colors.transparent,
              ),
            ),
            Column(
              children: const [
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "WELCOME,",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                ),
                Text(
                  "Hotelier",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
              ],
            ),
          ],
        ),
        ListTile(
          title: const Text('Report a Bug'),
          leading: const Icon(Icons.bug_report),
          onTap: () {},
        ),
        ListTile(
          title: const Text('Contact Us'),
          leading: const Icon(Icons.contact_mail),
          onTap: () {},
        ),
        ListTile(
          title: const Text('Logout'),
          leading: const Icon(Icons.logout),
          onTap: () {
            authCubit.logoutUser();
          },
        ),
        BlocConsumer<AuthenticationCubit, AuthenticationState>(
            buildWhen: (previous, current) => current is AuthenticationError,
            builder: (context, state) {
              if (state is AuthenticationError) {
                return const Text("Some Error");
              }
              return const SizedBox.shrink();
            },
            listenWhen: (previous, current) => current is AuthenticationLoaded,
            listener: (context, state) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()));
            }),
      ],
    );
  }
}
