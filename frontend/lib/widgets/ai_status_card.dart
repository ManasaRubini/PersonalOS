import 'package:flutter/material.dart';
import 'glass_container.dart';

class AIStatusCard extends StatelessWidget {
  const AIStatusCard({super.key});

  Widget buildItem(
    BuildContext context,
    IconData icon,
    String title,
    Color color,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(isDark ? 0.12 : 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 18,
              color: color,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isDark ? Colors.white.withOpacity(0.9) : Colors.black87,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green.withOpacity(0.1),
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.green,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassContainer(
      borderRadius: 24,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                      blurRadius: 8,
                      spreadRadius: 1,
                    )
                  ]
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "Digital Twin Status",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  letterSpacing: -0.5,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          buildItem(
            context,
            Icons.memory_rounded,
            "Semantic Memory Engine",
            Colors.deepPurple,
          ),
          buildItem(
            context,
            Icons.psychology_rounded,
            "Persona Simulation System",
            Colors.blue,
          ),
          buildItem(
            context,
            Icons.task_alt_rounded,
            "Proactive Task Orchestration",
            Colors.green,
          ),
          buildItem(
            context,
            Icons.storage_rounded,
            "Knowledge Graph Vector DB",
            Colors.orange,
          ),
        ],
      ),
    );
  }
}