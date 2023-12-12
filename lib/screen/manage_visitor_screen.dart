import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:visitor_access_app_admin/screen/add_resident_screen.dart';
import 'package:visitor_access_app_admin/screen/edit_resident.dart';
import 'package:visitor_access_app_admin/screen/edit_visitor.dart';
import 'package:visitor_access_app_admin/screen/home_screen.dart';

import '../class/class.dart';


class ManageVisitorScreen extends StatefulWidget {
  const ManageVisitorScreen({Key? key}) : super(key: key);

  @override
  State<ManageVisitorScreen> createState() => _ManageVisitorScreenState();
}

class _ManageVisitorScreenState extends State<ManageVisitorScreen> {
  TextEditingController _searchTextController = TextEditingController();
  List<DocumentSnapshot> documents = [];
  String searchText ='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        leading: GestureDetector(
          onTap: (){
            Navigator.pushAndRemoveUntil((context), MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
          },
          child:Icon(
            Icons.arrow_back,
            size: 26.0,

          ),
        ),
        backgroundColor: Colors.deepPurple[200],
        elevation: 0,
        title: const Text('Visitor Details'),
      ),
      body:SafeArea(
        child: Center(
            child:Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.go,
                      style: TextStyle(color: Colors.black),
                      controller:_searchTextController,
                      onChanged:(value){
                        setState(() {
                          searchText=value;
                        });
                      },
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white60,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.blue, width: 0.0),

                          ),
                          hintText: "Visitor Name/PhoneNumber",
                          prefixIcon:Icon(Icons.search),
                          prefixIconColor: Colors.black
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Expanded(
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('visitor') .orderBy('status', descending: false).snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                          documents = snapshot.data!.docs;

                          if (searchText.length > 0) {
                            if ( RegExp(r'^[0-9]+$').hasMatch(searchText)){
                              documents = documents.where((element) {
                                return element.get('phoneNumber')
                                    .toString()
                                    .toLowerCase()
                                    .contains(searchText.toLowerCase());
                              }).toList();
                            }else{
                              documents = documents.where((element) {
                                return element.get('name')
                                    .toString()
                                    .toLowerCase()
                                    .contains(searchText.toLowerCase());
                              }).toList();
                            }

                          }

                          return ListView.builder(
                            itemCount: documents.length,
                            shrinkWrap: true,
                            itemBuilder: (context,index){

                              return Column(
                                  children:[
                                    ListTile(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(25),
                                              topRight: Radius.circular(25),
                                              bottomRight: Radius.circular(25),
                                              bottomLeft: Radius.circular(25))),
                                      tileColor: documents[index]['status']=='active'? Colors.green:Colors.red,
                                      textColor: Colors.white,
                                      contentPadding:EdgeInsets.only(top: 4,bottom: 10,left:0,right: 6),
                                      title: Text(
                                        documents[index]['name'],
                                        style: TextStyle(
                                          fontSize: 20,
                                          color:Colors.white,
                                        ),
                                      ),
                                      subtitle: Row(
                                        children: [
                                          SizedBox(height: 10,),
                                          Icon(Icons.phone,size: 20,color: Colors.white,),
                                          SizedBox(width: 10,),
                                          Text(
                                              documents[index]['phoneNumber'],
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white
                                              )
                                          )
                                        ],
                                      ),
                                      trailing: IconButton(
                                          onPressed: () {
                                            VisitorClass.uid = documents[index]['uid'];
                                            VisitorClass.email = documents[index]['email'];
                                            VisitorClass.name = documents[index]['name'];
                                            VisitorClass.address = documents[index]['address'];
                                            VisitorClass.gender = documents[index]['gender'];
                                            VisitorClass.phoneNumber = documents[index]['phoneNumber'];
                                            VisitorClass.userImage = documents[index]['userImage'];
                                            VisitorClass.icImage = documents[index]['icImage'];
                                            VisitorClass.icNumber = documents[index]['icNumber'];
                                            VisitorClass.status = documents[index]['status'];
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=> EditVisitorScreen()));
                                          },
                                          icon: Icon(Icons.more_vert)

                                      ),
                                      leading:CircleAvatar(
                                        radius: 45.0,
                                        backgroundImage: Image.network(documents[index]['userImage']).image, //here
                                      ),
                                    ),
                                    SizedBox(height: 10,)
                                  ]
                              );
                            },
                          );
                        }
                    ),
                  )
                ],
              ),
            )
        ),
      ),
    );
  }
}
