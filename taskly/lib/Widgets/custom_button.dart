import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  final VoidCallback onTap;
  final String text;

  const CustomButton({required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 200,

      child: RaisedButton(
          onPressed: onTap,
      elevation: 2.0,
      child: Text(text,
      style: TextStyle(fontSize: 18,
      color: Colors.white)
      ),
        color: Color.fromRGBO(230, 126, 87, 1.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
      ),
    );
  }
}
