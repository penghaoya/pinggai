import 'package:flutter/material.dart';

class BottomPopup extends StatelessWidget {
  final Widget child;
  final String title;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsets contentPadding;
  final double? height;

  const BottomPopup({
    super.key,
    required this.child,
    required this.title,
    required this.onCancel,
    required this.onConfirm,
    this.initialChildSize = 0.5,
    this.minChildSize = 0.2,
    this.maxChildSize = 0.9,
    this.backgroundColor = Colors.white,
    this.borderRadius = 10,
    this.contentPadding = const EdgeInsets.all(16),
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadius)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          Expanded(
            child: Padding(
              padding: contentPadding,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(color: Colors.grey[300]!, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: onCancel,
            child: const Text('取消', style: TextStyle(color: Colors.black87)),
          ),
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          TextButton(
            onPressed: onConfirm,
            child: const Text('确定', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}

void showCustomBottomSheet({
  required BuildContext context,
  required Widget child,
  required String title,
  VoidCallback? onCancel,
  VoidCallback? onConfirm,
  double initialChildSize = 0.5,
  double minChildSize = 0.2,
  double maxChildSize = 0.9,
  Color backgroundColor = Colors.white,
  double borderRadius = 10,
  EdgeInsets contentPadding = const EdgeInsets.all(16),
  bool enableDrag = true,
  bool isDismissible = true,
  double? height,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    enableDrag: enableDrag,
    isDismissible: isDismissible,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(borderRadius)),
    ),
    builder: (BuildContext context) {
      if (height != null) {
        return SizedBox(
          height: height,
          child: BottomPopup(
            title: title,
            onCancel: onCancel ?? () => Navigator.pop(context),
            onConfirm: onConfirm ?? () => Navigator.pop(context),
            backgroundColor: backgroundColor,
            borderRadius: borderRadius,
            contentPadding: contentPadding,
            height: height,
            child: child,
          ),
        );
      } else {
        return DraggableScrollableSheet(
          initialChildSize: initialChildSize,
          minChildSize: minChildSize,
          maxChildSize: maxChildSize,
          builder: (_, controller) {
            return BottomPopup(
              title: title,
              onCancel: onCancel ?? () => Navigator.pop(context),
              onConfirm: onConfirm ?? () => Navigator.pop(context),
              initialChildSize: initialChildSize,
              minChildSize: minChildSize,
              maxChildSize: maxChildSize,
              backgroundColor: backgroundColor,
              borderRadius: borderRadius,
              contentPadding: contentPadding,
              child: ListView(
                controller: controller,
                children: [child],
              ),
            );
          },
        );
      }
    },
  );
}
