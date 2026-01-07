import 'package:flutter/material.dart';

enum CommonButtonType { elevated, outlined }

class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
    this.height = 48,
    this.icon,
    this.type = CommonButtonType.elevated,
  });

  final String title;
  final VoidCallback onPressed;
  final bool isLoading;
  final double height;
  final IconData? icon;
  final CommonButtonType type;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: _buildButton(),
    );
  }

  Widget _buildButton() {
    if (type == CommonButtonType.outlined) {
      return OutlinedButton.icon(
        icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
        label: isLoading
            ? const SizedBox(
          height: 22,
          width: 22,
          child: CircularProgressIndicator(strokeWidth: 2),
        )
            : Text(title),
        onPressed: isLoading ? null : onPressed,
      );
    }

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      )
          : Text(title),
    );
  }
}
