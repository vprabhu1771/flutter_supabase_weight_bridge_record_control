import 'package:flutter/material.dart';
import 'package:flutter_supabase_weight_bridge_record_control/screens/AboutUsScreen.dart';
import 'package:flutter_supabase_weight_bridge_record_control/screens/ContactUsScreen.dart';
import 'package:flutter_supabase_weight_bridge_record_control/screens/auth/ProfileScreen.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


import '../screens/HomeScreen.dart';
import '../screens/auth/LoginScreen.dart';
import '../screens/auth/RegisterScreen.dart';

final supabase = Supabase.instance.client;
final storage = FlutterSecureStorage();

class CustomDrawer extends StatelessWidget {
  final BuildContext parentContext;

  CustomDrawer({required this.parentContext});

  Future<void> signOut() async {
    await supabase.auth.signOut();
    await storage.delete(key: 'session');

    // Navigate to login screen and remove all previous routes
    Navigator.pushReplacement(
      parentContext,
      MaterialPageRoute(
        // builder: (context) => LoginScreen(title: 'Login'),
        builder: (context) => HomeScreen(title: 'Home'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          if (user != null) ...[
            UserAccountsDrawerHeader(
              accountName: Text(user.userMetadata?['name'] ?? "Guest"),
              accountEmail: Text(user.email ?? "No Email"),
              currentAccountPicture: CircleAvatar(
                child: Icon(Icons.person, size: 40),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            ListTile(
              leading: Icon(Icons.contacts),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(title: 'Profile'),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: Icon(Icons.contacts),
              title: Text('About Us'),
              onTap: () {
                // Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutUsScreen(title: 'About Us'),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.contacts),
              title: Text('Contact Us'),
              onTap: () {
                // Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactUsScreen(title: 'Contact Us'),
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.red),
              title: Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: signOut,
            ),
          ] else ...[
            UserAccountsDrawerHeader(
              accountName: Text(user != null ? "User Name" : "Guest"),
              accountEmail: Text(user?.email ?? "No Email"),
              currentAccountPicture: CircleAvatar(
                child: Icon(Icons.person, size: 40),
              ),
            ),
            ListTile(
              leading: Icon(Icons.login),
              title: Text('Login'),
              onTap: () {
                Navigator.pushReplacement(
                  parentContext,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(title: 'Login'),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.login),
              title: Text('Register'),
              onTap: () {
                Navigator.pushReplacement(
                  parentContext,
                  MaterialPageRoute(
                    builder: (context) => RegisterScreen(title: 'Register'),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}