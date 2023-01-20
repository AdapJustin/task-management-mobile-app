import 'package:flutter/material.dart';

class ProgressIcons extends StatelessWidget {
  final int total;
  final int done;

  const ProgressIcons({required this.total, required this.done});

  @override
  Widget build(BuildContext context) {


    final doneIcon=Image(image: AssetImage('assets/Images/done.png'),
    height: 50,
    width: 50,);

    final notDoneIcon=Image(image: AssetImage('assets/Images/notDone.png'),
      height: 50,
      width: 50,);

    List<Image> icons = [];


    for(int i=0; i < total; i++){
      if(i<done){
        icons.add(doneIcon);
      }else{
        icons.add(notDoneIcon);
      }
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: icons,),
    );
  }
}

