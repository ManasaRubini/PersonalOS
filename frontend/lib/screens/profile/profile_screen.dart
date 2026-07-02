import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),

      body: user == null
          ? const Center(
              child: Text("No user found"),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),

              child: Column(
                children: [

                  const CircleAvatar(
                    radius: 55,
                    child: Icon(
                      Icons.person,
                      size: 60,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    user.fullName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    user.email,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Chip(
                    avatar: const Icon(Icons.work),
                    label: Text(user.role),
                  ),

                  const SizedBox(height: 35),

                  Card(
                    child: Column(
                      children: [

                        ListTile(
                          leading: const Icon(Icons.badge),
                          title: const Text("User ID"),
                          subtitle: Text(user.userId),
                        ),

                        const Divider(height: 1),

                        ListTile(
                          leading: const Icon(Icons.email),
                          title: const Text("Email"),
                          subtitle: Text(user.email),
                        ),

                        const Divider(height: 1),

                        ListTile(
                          leading: const Icon(Icons.work_outline),
                          title: const Text("Role"),
                          subtitle: Text(user.role),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.logout),
                      label: const Text("Logout"),
                      onPressed: () async {
                        await auth.logout();

                        if (!context.mounted) return;

                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/',
                          (route) => false,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}