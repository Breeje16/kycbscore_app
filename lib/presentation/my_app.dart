import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveller_ratings/data/shared_pref/prefs.dart';
import 'package:traveller_ratings/presentation/blocs/authentication/authentication_cubit.dart';
import 'package:traveller_ratings/presentation/blocs/check_customer/check_customer_cubit.dart';
import 'package:traveller_ratings/presentation/blocs/loading/loading_cubit.dart';
import 'package:traveller_ratings/presentation/blocs/rate_customer/rate_customer_cubit.dart';
import 'package:traveller_ratings/presentation/journeys/signup_screen.dart';
import 'package:traveller_ratings/presentation/journeys/home_screen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:traveller_ratings/presentation/journeys/splash_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    late bool newUser;

    Future<bool> getNewUser() async {
      var nUser = await Prefs.getToken();
      if (nUser != null) {
        await Prefs.setIsNewUser(false);
        newUser = false;
      } else {
        await Prefs.setIsNewUser(true);
        newUser = true;
      }
      return newUser;
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                AuthenticationCubit(loadingCubit: LoadingCubit())),
        BlocProvider(create: (context) => CheckCustomerCubit()),
        BlocProvider(create: (context) => RateCustomerCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'KYCB Score',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: AnimatedSplashScreen(
          splash: const SplashScreen(),
          nextScreen:
              // (newUser) ?
              SignUpScreen(),
          //  : const HomeScreen(),
          backgroundColor: const Color(0xFFFEF9EB),
          splashTransition: SplashTransition.scaleTransition,
        ),
      ),
    );
  }
}
