
import 'package:flutter/material.dart';

class ConfirmLogoutDialog extends StatelessWidget {
  final Function onLogout; // Callback function for logout action

  const ConfirmLogoutDialog({Key? key, required this.onLogout})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // Cancel button
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            onLogout(); // Call the callback function for logout
            Navigator.pop(context); // Close the dialog
          },
          child: const Text('Logout'),
        ),
      ],
    );
  }
}
