import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

List<Column> rulerPin(int count) {
  return List.generate(count, (i) {
    return Column(
      children: [
        VerticalDivider(
          width: 2,
          thickness: 1,
          color: Colors.black,
        ),
        Text(i.toString(),style: TextStyle(fontSize: 2),),
      ],
    );
  }).toList();
}