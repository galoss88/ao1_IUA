import 'package:flutter/material.dart';

class ButtonLoginWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  
  const ButtonLoginWidget({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.blue),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.horizontal(
              right: Radius.circular(5),
              left: Radius.circular(5),
            ),
          ),
        ),
      ),
      child: const Text(
        "Iniciar sesión",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
