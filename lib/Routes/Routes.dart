import 'package:flutter/material.dart';
import 'package:sos_app/Screens/Auth/SignInScreen.dart';

import '../Screens/Home/HomeScreen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const HomeScreen(),
  '/sign-in': (context) => SignInScreen(),
};

Route<dynamic> generateRoute(RouteSettings settings) {
  final builder = appRoutes[settings.name];
  if (builder != null) {
    return MaterialPageRoute(settings: settings, builder: builder);
  }

  return MaterialPageRoute(
    settings: settings,
    builder: (context) => const Scaffold(
      body: Center(
        child: Text(
          '404: Screen Not Found 🚧',
          style: TextStyle(fontSize: 18, color: Colors.white70),
        ),
      ),
    ),
  );
}
