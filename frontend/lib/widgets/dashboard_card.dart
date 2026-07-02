import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final Widget child;
  final double height;

  const DashboardCard({
    super.key,
    required this.child,
    this.height = 150,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Container(
        width: double.infinity,
        height: height,
        padding: const EdgeInsets.all(18),
        child: child,
      ),
    );
  }
}