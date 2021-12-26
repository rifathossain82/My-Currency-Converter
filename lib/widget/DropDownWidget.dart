import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:overlay_support/overlay_support.dart';

Widget CustomDropDown(
    List<String> items,
    String value,
    void onChange(val)
    ){
  return InkWell(
    onTap: (){
      if(items.isEmpty){
        showSimpleNotification(
          Text('No Internet Connection!'),
          background: Colors.red,
        );
      }
    },
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButton<String>(
        icon: Icon(Icons.keyboard_arrow_down),
        elevation: 0,
        value: value.isEmpty?null :value,
        onChanged: (val){
          onChange(val);
        },
        items: items.map<DropdownMenuItem<String>>((String val){
          return DropdownMenuItem(
            child: Text(val,style: TextStyle(color: Colors.white),),
            value: val,
          );
        }).toList(),
        dropdownColor: Colors.blueGrey,
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}