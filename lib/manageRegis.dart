import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';




class manageRegis extends StatefulWidget {
  static String routeName = '/manageRegis';
  const manageRegis({super.key});
  @override
  State<manageRegis> createState() => _manageRegisState();
}

// ต้องใส่ListView.builderยังไงให้เเบบtextเรียงต่อกันเป็นlist?

class _manageRegisState extends State<manageRegis> {
  //เเสดงผลข้อมูล
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Manage Registration Form'),
        )
      ), //Appbar 

      //ListView.builder???
      body: Padding(
        padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.lightBlue, 
              borderRadius: BorderRadius.circular(20)
              ), //Boxdecoration
              height: 200,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "FullName: ",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                      ), //textstyle
                    ), //text
                    Text(
                    "Username: ",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                      ), //textstyle
                    ) //text

                   
                ],
              ), //Row
          ), //container
          SizedBox(height: 5,),
          Container(
            decoration: BoxDecoration(
              color: Colors.lightBlue, 
              borderRadius: BorderRadius.circular(20)
              ), //Boxdecoration
              height: 200,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "FullName",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                      ), //textstyle
                    ), //text
                    Text("Username")
                ],
              ), //Row
          ),
          SizedBox(height: 5,),
          Container(
            decoration: BoxDecoration(
              color: Colors.lightBlue, 
              borderRadius: BorderRadius.circular(20)
              ), //Boxdecoration
              height: 200,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "FullName",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                      ), //textstyle
                    ), //text
                    Text("Username")
                ],
              ), //Row
          )
          
          

        ]
      ) //Column
    )); //Padding //Scaffold
    
  }
}