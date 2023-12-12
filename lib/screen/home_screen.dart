import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:visitor_access_app_admin/class/class.dart';
import 'package:visitor_access_app_admin/screen/entry_record_screen.dart';
import 'package:visitor_access_app_admin/screen/manage_gatekeeper_screen.dart';
import 'package:visitor_access_app_admin/screen/manage_visitor_screen.dart';
import 'package:visitor_access_app_admin/screen/record_screen.dart';
import '../reusable_widget/auth.dart';
import 'login_screen.dart';
import 'manage_resident_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    return Scaffold(
      backgroundColor:Colors.grey[300],
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.only(top:10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: (){},
                  icon: Icon(Icons.home,size:32)),
              IconButton(onPressed: (){
                logout(context);
              }, icon: Icon(Icons.logout,size:32)),
            ],
          ),
        )
      ),
      body:SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 25),
                child: Row(
                  children: [
                    Text(
                      'Hi,',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      AdminClass.name.toString(),
                      style: TextStyle(fontSize: 28),
                    ),
                  ],
                ),
              ),
              //card
             /* Container(
                width: 300,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color:  Colors.deepPurple[300],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Visitor Today',
                      style: TextStyle(
                        color:Colors.white,
                      ),
                    ),
                    SizedBox(height:10),
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          size:70,
                          color: Colors.white,
                        ),
                        SizedBox(width:20),
                        Text(
                          '0',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize:45,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height:10),
                    Text(
                      formatted,
                      style: TextStyle(color:Colors.white ),
                    ),
                    SizedBox(height: 25,),

                  ],
                ),

              ),*/
              SizedBox(height: 25,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      InkWell(
                        child: Container(
                          height: 100,
                          width: 95,
                          padding:EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(20),
                              boxShadow:[
                                BoxShadow(
                                    color:Colors.grey.shade500,
                                    blurRadius: 40,
                                    spreadRadius: 5
                                ),
                              ]
                          ),
                          child: Center(
                            child:Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.blue[200],
                            ),
                          ),
                        ),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> ManageResidentScreen()));
                        },
                      ),
                      SizedBox(height:20),
                      Text(
                        'Resident',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700]
                        ),
                      )

                    ],
                  ),
                  Column(
                    children: [
                      InkWell(
                        child: Container(
                          height: 100,
                          width: 95,
                          padding:EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(20),
                              boxShadow:[
                                BoxShadow(
                                    color:Colors.grey.shade500,
                                    blurRadius: 40,
                                    spreadRadius: 5
                                ),
                              ]
                          ),
                          child: Center(
                            child:Icon(
                              Icons.security,
                              size: 50,
                              color: Colors.purple[200],
                            ),
                          ),
                        ),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> ManageGatekeeperScreen( )));
                        },
                      ),
                      SizedBox(height:20),
                      Text(
                        'GateKeeper',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700]
                        ),
                      )

                    ],
                  ),
                  Column(
                    children: [
                      InkWell(
                        child: Container(
                          height: 100,
                          width: 95,
                          padding:EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(20),
                              boxShadow:[
                                BoxShadow(
                                    color:Colors.grey.shade500,
                                    blurRadius: 40,
                                    spreadRadius: 5
                                ),
                              ]
                          ),
                          child: Center(
                            child:Icon(
                              Icons.people,
                              size: 50,
                              color: Colors.pink[200],
                            ),
                          ),
                        ),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> ManageVisitorScreen( )));
                        },
                      ),
                      SizedBox(height:20),
                      Text(
                        'Visitor',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700]
                        ),
                      )

                    ],
                  )
                ],
              ),
              SizedBox(height :25),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: InkWell(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.library_books,
                                    size: 80,
                                    color: Colors.red[300],
                                  ),
                                ),
                                SizedBox(width:20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Record',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20
                                      ),
                                    ),
                                    SizedBox(height: 8,),
                                    Text('Check-in and Check-out',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color:Colors.grey[600]
                                      ),)
                                  ],
                                ),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios)
                          ],
                        )
                      ],
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> RecordScreen()));
                    },
                  )
              ),
              /*SizedBox(height :25),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: InkWell(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.analytics,
                                    size: 80,
                                    color: Colors.green[300],
                                  ),
                                ),
                                SizedBox(width:20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Statistics',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20
                                      ),
                                    ),
                                    SizedBox(height: 8,),
                                    Text('Payment and income',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color:Colors.grey[600]
                                      ),)
                                  ],
                                ),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios)
                          ],
                        )
                      ],
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> EntryRecordScreen()));
                    },
                  )
              ),*/

            ],
          ),
        )
      )

    );

  }
  Future<void> logout(BuildContext context) async {
    AuthClass authclass=AuthClass();
    await authclass.logout();
    await FirebaseAuth.instance.signOut();
    Fluttertoast.showToast(msg: "You have been logged out");
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

}
