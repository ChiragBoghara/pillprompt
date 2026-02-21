import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showAppSnackbar({
  required String message,
  Color? backgroundColor,
  IconData? icon,
}) {
  Get.showSnackbar(
    GetSnackBar(
      messageText: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: 'Lexend',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor ?? Get.theme.colorScheme.primary,
      borderRadius: 12,
      margin: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      maxWidth: 280,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.TOP,
      animationDuration: const Duration(milliseconds: 300),
    ),
  );
}
