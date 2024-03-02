import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import '../main.dart';

class AppWrapper extends StatefulWidget {
  @override
  _AppWrapperState createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  Future<void> _authenticate() async {
    bool isAuthenticated = false;

    try {
      isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to access the app',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print('Error during authentication: $e');
    }

    if (isAuthenticated) {
      // Authentication successful, proceed to the main part of the app
      runApp(MyApp());
    } else {
      // Authentication failed or user canceled, exit the app or show an error message
      print('Authentication failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Placeholder widget while authentication is in progress
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
