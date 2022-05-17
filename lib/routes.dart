import 'package:flutter/widgets.dart';
import 'package:aquatic_xpress_shipping/screens/auth/forgot_password/forgot_password_screen.dart';
import 'package:aquatic_xpress_shipping/screens/auth/login_success/login_success_screen.dart';
import 'package:aquatic_xpress_shipping/screens/auth/sign_in/sign_in_screen.dart';
import 'package:aquatic_xpress_shipping/screens/auth/sign_up/sign_up_screen.dart';
import 'package:aquatic_xpress_shipping/screens/user/home/home_screen.dart';
import 'package:aquatic_xpress_shipping/screens/user/profile/profile_screen.dart';
import 'package:aquatic_xpress_shipping/screens/user/shipping/shipping.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  // SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  Shipping.routeName: (context) => Shipping(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
};
