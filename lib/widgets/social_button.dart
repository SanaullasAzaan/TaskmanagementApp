import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final VoidCallback onTap;
  final String iconPath;
  final double size;
  final double iconSize;

  const SocialButton({
    super.key,
    required this.onTap,
    required this.iconPath,
    this.size = 64,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black38, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Image.asset(
            iconPath,
            width: iconSize,
            height: iconSize,
          ),
        ),
      ),
    );
  }
} 