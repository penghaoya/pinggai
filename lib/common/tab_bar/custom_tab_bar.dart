import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  final TabController controller;
  final List<String> tabs;
  final Color backgroundColor;
  final Color selectedLabelColor;
  final Color unselectedLabelColor;
  final TextStyle selectedLabelStyle;
  final TextStyle unselectedLabelStyle;
  final Color indicatorColor;
  final double height;
  final double borderRadius;
  final double width;
  const CustomTabBar({
    super.key,
    required this.controller,
    required this.tabs,
    this.backgroundColor = const Color(0xFFEEEEEE),
    this.selectedLabelColor = Colors.black,
    this.unselectedLabelColor = Colors.black54,
    this.selectedLabelStyle =
        const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    this.unselectedLabelStyle = const TextStyle(fontSize: 14),
    this.indicatorColor = Colors.white,
    this.height = 38,
    this.width = 300,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: TabBar(
        controller: controller,
        tabs: tabs.map((text) => Tab(text: text)).toList(),
        labelColor: selectedLabelColor,
        unselectedLabelColor: unselectedLabelColor,
        labelStyle: selectedLabelStyle,
        unselectedLabelStyle: unselectedLabelStyle,
        indicator: BoxDecoration(
          color: indicatorColor,
          borderRadius: BorderRadius.circular(borderRadius - 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorPadding:
            const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        labelPadding: const EdgeInsets.symmetric(horizontal: 10),
        indicatorSize: TabBarIndicatorSize.tab,
      ),
    );
  }
}
