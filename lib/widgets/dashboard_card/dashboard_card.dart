import 'package:flutter/material.dart';

import '../../resource/colors.dart';
class DashboardCard extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String name;
  const DashboardCard({super.key, required this.icon, required this.name, required this.onPressed});

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:widget.onPressed,
      child: Container(
        width: 70,
        height: 65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xff868484),
            width: 0.4,
          ),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: AppColors.primary,
                size: 26,
              ),
              const SizedBox(height: 4,),
              Text(
                widget.name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10,fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
