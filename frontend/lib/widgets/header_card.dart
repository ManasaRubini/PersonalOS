import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'glass_container.dart';

class HeaderCard extends StatelessWidget {
  final String name;
  final String role;

  const HeaderCard({
    super.key,
    required this.name,
    required this.role,
  });

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.primaryGradient[0].withOpacity(0.15),
                  AppColors.primaryGradient[1].withOpacity(0.05),
                ]
              : [
                  AppColors.primaryGradient[0].withOpacity(0.08),
                  AppColors.primaryGradient[1].withOpacity(0.03),
                ],
        ),
      ),
      child: GlassContainer(
        padding: const EdgeInsets.all(24),
        borderRadius: 24,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: AppColors.primaryGradient,
                ),
              ),
              child: CircleAvatar(
                radius: 32,
                backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
                child: Icon(
                  Icons.person_rounded,
                  size: 32,
                  color: isDark ? Colors.white : AppColors.primaryGradient[0],
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _greeting().toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: isDark
                          ? Colors.white.withOpacity(0.5)
                          : Colors.black.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : AppColors.primaryGradient[0].withOpacity(0.05),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withOpacity(0.1)
                            : AppColors.primaryGradient[0].withOpacity(0.1),
                      ),
                    ),
                    child: Text(
                      role,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? Colors.white.withOpacity(0.8)
                            : AppColors.primaryGradient[0],
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