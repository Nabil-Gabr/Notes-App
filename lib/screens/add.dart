// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_final_fields, unused_local_variable, avoid_print

import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_app/screens/home.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  TextEditingController _tileController=TextEditingController();
  TextEditingController _contentController=TextEditingController();

  //addNote
  CollectionReference notess=FirebaseFirestore.instance.collection("notess");

  addNotes()async{
    try {
      DocumentReference x= await notess.add({
        'title':_tileController.text,
        'content':_contentController.text,
        "date":Timestamp.now()
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen(),));
    } catch (e) {
      print("Error:$e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey.shade800,
        onPressed: (){
          addNotes();
        },
        child: Icon(Icons.save,size: 38,color: Colors.white,),
        ),
      backgroundColor: Colors.grey.shade900,

      body: Padding(
        padding: EdgeInsets.fromLTRB(16, 40, 16, 0),

        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800.withOpacity(.8),
                    borderRadius: BorderRadius.circular(10)),
                    child: Icon(Icons.arrow_back_ios_new,color: Colors.white,),
                ))
              ],
            ),

            Expanded(child: ListView(
              children: [
                TextField(
                  controller: _tileController,
                  style: TextStyle(fontSize: 30,color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Title',
                    hintStyle: TextStyle(fontSize: 30,color: Colors.grey)
                  ),
                ),

                TextField(
                  maxLines: null,
                  controller: _contentController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type something here',
                    hintStyle: TextStyle(color: Colors.white)
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}