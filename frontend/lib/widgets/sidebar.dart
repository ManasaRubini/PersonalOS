import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/memory/memory_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/tasks/task_screen.dart';
import '../theme/colors.dart';
import 'glass_container.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  Widget _buildItem(
    BuildContext context,
    IconData icon,
    String title,
    Widget targetScreen,
    bool isReplacement,
  ) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).iconTheme.color, size: 20),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      onTap: () {
        if (isReplacement) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => targetScreen),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => targetScreen),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final user = auth.currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 250,
      height: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.04),
            width: 1.5,
          ),
        ),
      ),
      child: GlassContainer(
        borderRadius: 0,
        blur: 15,
        child: SafeArea(
          child: Column(
            children: [
              // User Profile Section (integrated into sidebar)
              if (user != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: AppColors.primaryGradient,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: isDark ? const Color(0xFF13151A) : Colors.white,
                          child: Icon(
                            Icons.person_rounded,
                            size: 30,
                            color: isDark ? Colors.white : AppColors.primaryGradient[0],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user.fullName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.role.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                          color: isDark ? Colors.white38 : Colors.black38,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              const Divider(),

              // Navigation Links
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    _buildItem(
                      context,
                      Icons.dashboard_rounded,
                      "Dashboard",
                      const DashboardScreen(),
                      true,
                    ),
                    _buildItem(
                      context,
                      Icons.forum_rounded,
                      "AI Chat",
                      const ChatScreen(),
                      false,
                    ),
                    _buildItem(
                      context,
                      Icons.psychology_rounded,
                      "Knowledge Base",
                      const MemoryScreen(),
                      false,
                    ),
                    _buildItem(
                      context,
                      Icons.task_alt_rounded,
                      "Tasks Hub",
                      const TaskScreen(),
                      false,
                    ),
                    _buildItem(
                      context,
                      Icons.account_circle_rounded,
                      "Persona Profile",
                      const ProfileScreen(),
                      false,
                    ),
                    _buildItem(
                      context,
                      Icons.settings_rounded,
                      "Settings",
                      const SettingsScreen(),
                      false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
