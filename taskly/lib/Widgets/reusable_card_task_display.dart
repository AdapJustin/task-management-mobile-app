import 'package:flutter/material.dart';
import 'package:final_academic_project/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ReusableCardTaskDisplay extends StatelessWidget {
  ReusableCardTaskDisplay(
      {required this.colour, required this.cardChild, required this.onPress});

  final Color colour;
  final Widget cardChild;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
        ),
        elevation: 1,
        child: ClipPath(
          clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: colour, width: 5),
              ),
              color: Color.fromRGBO(255, 255, 255, 1.0),
            ),
            padding: EdgeInsets.all(20.0),
            alignment: Alignment.centerLeft,
            child:cardChild,
          ),
        ),
      ),
    );
  }
}
