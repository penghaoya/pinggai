import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OtherFunButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;
  final Color textColor;

  const OtherFunButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.iconColor = Colors.blue, // 默认图标颜色
    this.textColor = Colors.black, // 默认文字颜色
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 3,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
              const SizedBox(height: 5),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
