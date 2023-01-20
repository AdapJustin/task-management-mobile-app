import 'package:flutter/material.dart';
import 'package:final_academic_project/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ReusableCardCalendar extends StatelessWidget {
  ReusableCardCalendar({required this.Category,required this.TaskName
    ,required this.startTime,required this.colour, required this.onPress});

  final String Category;
  final String TaskName;
  final TimeOfDay startTime;
  final Color colour;
  final VoidCallback onPress;

  String fixTime(TimeOfDay timeStart){
    String fixHrStart = timeStart.hour.toString();
    String fixMinStart = timeStart.minute.toString();

    if(int.parse(fixHrStart) < 10)
      fixHrStart = "0" + fixHrStart;
    if(int.parse(fixMinStart) < 10)
      fixMinStart = "0" + fixMinStart;

    String fixedTime  = fixHrStart + ":" + fixMinStart;// + " - " + fixHrEnd + ":" + fixMinEnd;

    return fixedTime;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onPress,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0),
        padding: EdgeInsets.fromLTRB(0, 20.0, 20.0, 10.0),
        height: 130,
        width: 326.0,
        decoration: BoxDecoration(
          color: kActiveCardColour,
          borderRadius: BorderRadius.circular(10.0),

        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height:100,
              width: 8.0,
              margin: EdgeInsets.fromLTRB(0, 6.0, 0, 6.0),
              decoration: BoxDecoration(
                color: colour,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '$Category',
                          style: TextStyle(
                            fontSize: 17.0,
                            color: colour,
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '$TaskName',
                          style: kTagLabelTextStyle2,
                        ),
                      ),

                      Expanded(
                        child: Row(

                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.clock,
                              color: kTagDateColour,
                              size: 17,
                            ),
                            SizedBox(width: 3,),
                            Text(
                              fixTime(startTime),
                              style: kTagDateStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
