import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final double? width;
  final double? height;
  final double topSectionHeight;
  final Widget topSection;
  final Widget bottomSection;
  final Color headerColor;
  final Color cardColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final BoxShadow? boxShadow;

  const CustomCard({
    super.key,
    this.width,
    this.height,
    required this.topSectionHeight,
    required this.topSection,
    required this.bottomSection,
    this.headerColor = Colors.blue,
    this.cardColor = Colors.white,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.all(0),
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: boxShadow != null
            ? [boxShadow!]
            : [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Column(
        children: [
          Container(
            height: topSectionHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                topRight: Radius.circular(borderRadius),
              ),
            ),
            child: topSection,
          ),
          Expanded(
            child: bottomSection,
          ),
        ],
      ),
    );
  }
}
