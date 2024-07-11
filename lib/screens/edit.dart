// ignore_for_file: prefer_final_fields, non_constant_identifier_names, prefer_const_constructors, avoid_print, use_key_in_widget_constructors

// ignore: unused_import
import 'package:date_format/date_format.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_app/screens/home.dart';

class EditScreen extends StatefulWidget {
  //path title and contect
  final String oldTitle;
  final String oldcontent;
  final String IDNote;
  const EditScreen({required this.oldTitle, required this.oldcontent, required this.IDNote});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController _tileController=TextEditingController();
  TextEditingController _contentController=TextEditingController();

  @override
  void initState() {
    _tileController.text=widget.oldTitle;
    _contentController.text=widget.oldcontent;
    
    super.initState();
  }
  CollectionReference notess=FirebaseFirestore.instance.collection("notess");
  Future<void>editNote(){
    return notess.doc(widget.IDNote).update({
      'title':_tileController.text,
      'content':_contentController.text,
    }).then((value) => print("edited Note")).catchError((error) => print("Failed to update note: $error"))
    ;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey.shade800,
        onPressed: (){
          editNote();
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen(),));
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