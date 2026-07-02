import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../theme/colors.dart';
import '../../widgets/statistic_card.dart';
import '../../widgets/quick_action_card.dart';
import '../../widgets/sidebar.dart';
import '../settings/settings_screen.dart';

import '../chat/chat_screen.dart';
import '../memory/memory_screen.dart';
import '../tasks/task_screen.dart';
import '../profile/profile_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgDecoration = isDark
        ? const BoxDecoration(
            color: Color(0xFF13151A),
          )
        : const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppColors.backgroundGradient,
            ),
          );

    return Scaffold(
      body: Container(
        decoration: bgDecoration,
        child: Row(
          children: [
            // 1. Persistent Sidebar on the Left (fixed width 250px)
            const Sidebar(),

            // 2. Main Dashboard Panel on the Right
            Expanded(
              child: Stack(
                children: [
                  // Ambient glowing blobs
                  Positioned(
                    top: -80,
                    right: -50,
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryGradient[0].withOpacity(isDark ? 0.12 : 0.08),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
                        child: Container(),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 80,
                    left: -80,
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.secondaryGradient[0].withOpacity(isDark ? 0.1 : 0.06),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                        child: Container(),
                      ),
                    ),
                  ),

                  // Content Area
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Navigation bar
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Dashboard Overview",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.settings_rounded, size: 24),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const SettingsScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Compact AI Status Pill
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white.withOpacity(0.03) : Colors.white.withOpacity(0.55),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.04),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.green,
                                        blurRadius: 6,
                                        spreadRadius: 1,
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "Twin System Online",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white70 : Colors.black54,
                                  ),
                                ),
                                const Spacer(),
                                const Icon(Icons.bolt, size: 14, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text(
                                  "Cognitive Engine Active",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white54 : Colors.black45,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Section: Insights
                          Text(
                            "INSIGHTS",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                              color: isDark ? Colors.white38 : Colors.black38,
                            ),
                          ),
                          const SizedBox(height: 8),

                          Row(
                            children: [
                              Expanded(
                                child: StatisticCard(
                                  title: "Tasks",
                                  value: provider.stats?.tasks.toString() ?? "0",
                                  icon: Icons.task_alt_rounded,
                                  color: AppColors.task,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: StatisticCard(
                                  title: "Memory",
                                  value: provider.stats?.memories.toString() ?? "0",
                                  icon: Icons.psychology_rounded,
                                  color: AppColors.memory,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: StatisticCard(
                                  title: "Chats",
                                  value: provider.stats?.conversations.toString() ?? "0",
                                  icon: Icons.forum_rounded,
                                  color: AppColors.chat,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),

                          // Section: Command Center
                          Text(
                            "COMMAND CENTER",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                              color: isDark ? Colors.white38 : Colors.black38,
                            ),
                          ),
                          const SizedBox(height: 8),

                          Expanded(
                            child: GridView.count(
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              childAspectRatio: 1.65,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              children: [
                                QuickActionCard(
                                  icon: Icons.forum_rounded,
                                  title: "AI Chat",
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const ChatScreen(),
                                      ),
                                    );
                                  },
                                ),
                                QuickActionCard(
                                  icon: Icons.psychology_rounded,
                                  title: "Knowledge Base",
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const MemoryScreen(),
                                      ),
                                    );
                                  },
                                ),
                                QuickActionCard(
                                  icon: Icons.task_alt_rounded,
                                  title: "Tasks Hub",
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const TaskScreen(),
                                      ),
                                    );
                                  },
                                ),
                                QuickActionCard(
                                  icon: Icons.account_circle_rounded,
                                  title: "Persona Profile",
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const ProfileScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}