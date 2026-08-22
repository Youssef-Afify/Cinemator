import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/features/auth/provider/user_provider.dart';
import 'package:task/widgets/custom_app_bar.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = context.watch<UserProvider>();
    return Scaffold(
      appBar: CustomAppBar('Profile'),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              Text(
                'Hello ${userProvider.username}',
                style: TextStyle(color: Colors.black, fontSize: 22),
              ),
              SizedBox(height: 5),
              Text(
                'Email: ${userProvider.email}',
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
