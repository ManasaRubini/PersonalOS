import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final auth = context.read<AuthProvider>();
    final chat = context.read<ChatProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),

      body: ListView(
        children: [

          const SizedBox(height: 10),

          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text("Dark Mode"),
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (_) {
                themeProvider.toggleTheme();
              },
            ),
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text("Forget Conversation"),
            subtitle: const Text(
              "Clear the Digital Twin short-term memory",
            ),
            onTap: () async {

              final id = auth.currentUser?.userId;

              if (id == null) return;

              await chat.clearChat(id);

              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Conversation cleared.",
                  ),
                ),
              );
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("Application"),
            subtitle: const Text("PersonalOS"),
          ),

          const Divider(),

          const ListTile(
            leading: Icon(Icons.memory),
            title: Text("AI Model"),
            subtitle: Text("GPT-4o-mini"),
          ),

          const Divider(),

          const ListTile(
            leading: Icon(Icons.storage),
            title: Text("Database"),
            subtitle: Text("SQLite + FastAPI"),
          ),

          const Divider(),

          const ListTile(
            leading: Icon(Icons.psychology),
            title: Text("Semantic Search"),
            subtitle: Text("Embedding Vector Search"),
          ),

          const Divider(),

          const SizedBox(height: 30),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "PersonalOS\nVersion 1.0",
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 50),
        ],
      ),
    );
  }
}