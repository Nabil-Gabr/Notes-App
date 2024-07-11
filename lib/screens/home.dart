// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:math';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_app/constants/colors.dart';
import 'package:note_app/screens/add.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:note_app/screens/edit.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //search:valueIsCheck
  String naem="";

  //getRandomColor
  getRandomColor(){
    Random random=Random();
    return backgroundColors[random.nextInt(backgroundColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //button go to page add aote
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey.shade800,
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddScreen(),));
        },
        child: Icon(Icons.add,size: 38,color: Colors.white,),
        ),


      backgroundColor: Colors.grey.shade900,


      body: Padding(
        padding: EdgeInsets.fromLTRB(16, 40, 16, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Notes",style: TextStyle(fontSize: 30,color: Colors.white),),
                IconButton(onPressed: (){}, icon: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800.withOpacity(.8),
                    borderRadius: BorderRadius.circular(10)),
                    child: Icon(Icons.sort,color: Colors.white,),
                ))
              ],
            ),

            SizedBox(height: 20,),
            
            TextField(
              onChanged: (value) {
                setState(() {
                  naem=value;});
              },
                  
              style: TextStyle(fontSize: 16,color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search Notes....",
                hintStyle: TextStyle(color: Colors.white),
                prefixIcon: Icon(Icons.search,color: Colors.white,),
                fillColor: Colors.grey.shade800,
                filled: true,

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.transparent)
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.transparent)
                ),
                
              ),
            ),
            SizedBox(height: 20,),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("notess").snapshots(), 
                builder: (context, snapshot) {
                  return (snapshot.connectionState==ConnectionState.waiting) ?
                  Center(
                    child: CircularProgressIndicator(),
                  )
                  :ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data=snapshot.data!.docs[index].data() as Map<String,dynamic>;

                      if(naem.isEmpty){
                        return InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditScreen(oldTitle: '${snapshot.data!.docs[index]['title']}', oldcontent: '${snapshot.data!.docs[index]['content']}', IDNote: snapshot.data!.docs[index].id,),));
                  },
                  child: Card(
                    margin: EdgeInsets.only(bottom: 20),
                    color: getRandomColor(),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListTile(
                          title:RichText(
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            text:  TextSpan( 
                                       
                              text: '${snapshot.data!.docs[index]['title']}\n',
                                    
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                height: 1.5,
                              ),
                              children: [
                                TextSpan(
                                  text: "${snapshot.data!.docs[index]['content']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    height: 1.5,
                                  ),)
                              ]
                            )
                            ) ,
                            
                          subtitle:Padding(
                            padding:  EdgeInsets.only(top: 8.0),
                            child: Text(DateFormat.jm().format(snapshot.data!.docs[index]['date'].toDate()),style: TextStyle(fontSize: 10,fontStyle: FontStyle.italic,color: Colors.grey.shade800),),
                                       
                          ) ,
                          trailing:IconButton(onPressed: (){
                  
                            showDialog(
                              context: context, 
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.grey.shade900,
                                  icon: Icon(Icons.info,color :Colors.grey,size: 40,),
                                  title: Text("ِAre you suer you want to delete",style: TextStyle(color: Colors.white),),
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                        onPressed: ()async{
                                          await FirebaseFirestore.instance.collection("notess").doc(snapshot.data!.docs[index].id).delete();
                                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen(),));
                                        }, 
                                        child: SizedBox(
                                          width: 80,
                                          child: Text("Yes",textAlign: TextAlign.center,style: TextStyle(color: Colors.white)),
                                        ) ,
                                      ),
                  
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                        onPressed: (){
                                          Navigator.pop(context,false);
                                        }, 
                                        child: SizedBox(
                                          width: 80,
                                          child: Text("No",textAlign: TextAlign.center,style: TextStyle(color: Colors.white)),
                                        ) ,
                                      ),
                                    ],
                                  ),
                                  
                                );
                                
                              },
                            );
                            
                  
                          }, icon: Icon(Icons.delete)),
                        ),
                      ),
                    ),
                ) ;
                      } 
                      if(data['title']
                      .toString()
                      .toLowerCase()
                      .startsWith(naem.toLowerCase())){
                        return InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditScreen(oldTitle: '${snapshot.data!.docs[index]['title']}', oldcontent: '${snapshot.data!.docs[index]['content']}', IDNote: snapshot.data!.docs[index].id,),));
                  },
                  child: Card(
                    margin: EdgeInsets.only(bottom: 20),
                    color: getRandomColor(),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListTile(
                          title:RichText(
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            text:  TextSpan( 
                              text: '${snapshot.data!.docs[index]['title']}\n',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                height: 1.5,
                              ),
                              children: [
                                TextSpan( 
                              text: "${snapshot.data!.docs[index]['content']}",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                height: 1.5,
                              ),)
                              ]
                            )
                            ) ,
                            
                          subtitle:Padding(
                            padding:  EdgeInsets.only(top: 8.0),
                            child: Text(DateFormat.jm().format(snapshot.data!.docs[index]['date'].toDate()),style: TextStyle(fontSize: 10,fontStyle: FontStyle.italic,color: Colors.grey.shade800),),
                          ) ,
                          trailing:IconButton(onPressed: (){
                  
                            showDialog(
                              context: context, 
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.grey.shade900,
                                  icon: Icon(Icons.info,color :Colors.grey,size: 40,),
                                  title: Text("ِAre you suer you want to delete",style: TextStyle(color: Colors.white),),
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                        onPressed: ()async{
                                          await FirebaseFirestore.instance.collection("notess").doc(snapshot.data!.docs[index].id).delete();
                                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen(),));
                                        }, 
                                        child: SizedBox(
                                          width: 80,
                                          child: Text("Yes",textAlign: TextAlign.center,style: TextStyle(color: Colors.white)),
                                        ) ,
                                      ),
                  
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                        onPressed: (){
                                          Navigator.pop(context,false);
                                        }, 
                                        child: SizedBox(
                                          width: 80,
                                          child: Text("No",textAlign: TextAlign.center,style: TextStyle(color: Colors.white)),
                                        ) ,
                                      ),
                                    ],
                                  ),
                                  
                                );
                                
                              },
                            );
                            
                  
                          }, icon: Icon(Icons.delete)),
                        ),
                      ),
                    ),
                ) ;
                      }

                      return Container();
                    },);
                },
              )
              )


          ],
        ),
        ),
    );
  }
}