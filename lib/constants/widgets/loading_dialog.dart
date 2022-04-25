import 'package:flutter/material.dart';

void loadingDialog({required BuildContext context, String? msg}) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(msg!),
          )
        ],
      ),
    ),
  );
}
