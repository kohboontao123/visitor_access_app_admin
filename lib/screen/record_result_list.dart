import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class RecordResultList extends StatefulWidget {
  final String status;
  const RecordResultList( this.status) ;

  @override
  State<RecordResultList> createState() => _RecordResultListState();
}

class _RecordResultListState extends State<RecordResultList> {
  TextEditingController _searchTextController = TextEditingController();
  String searchText = '';
  List<DocumentSnapshot> uid = [];
  List<DocumentSnapshot> documents = [];
  @override
  Widget build(BuildContext context) {
    var query ;
    if (widget.status =="All" ){
      query = FirebaseFirestore.instance.collection(
          'invitation')
          .orderBy('startDate', descending: true)
          .snapshots();
    }else if (widget.status =="Accepted" ){
      query = FirebaseFirestore.instance.collection(
          'invitation')
          .where("status",isEqualTo:'Accepted')
          .orderBy('startDate', descending: true)
          .snapshots();
    }else if (widget.status =="Rejected" ){
      query = FirebaseFirestore.instance.collection(
          'invitation')
          .where("status",isEqualTo:'Rejected')
          .orderBy('startDate', descending: true)
          .snapshots();
    }else if (widget.status =='Pendings' ){
      query = FirebaseFirestore.instance.collection(
          'invitation')
          .where("status",isEqualTo:'Pending')
          .orderBy('startDate', descending: true)
          .snapshots();
    }else if (widget.status =="Cancel" ){
      query = FirebaseFirestore.instance.collection(
          'invitation')
          .where("status",isEqualTo:'Cancel')
          .orderBy('startDate', descending: true)
          .snapshots();
    }
    return SafeArea(
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  color: Theme
                      .of(context)
                      .scaffoldBackgroundColor,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.1,
                  child: Center(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.go,
                      style: TextStyle(color: Colors.black),
                      controller: _searchTextController,
                      onChanged: (value) {
                        setState(() {
                          searchText = value;
                        });
                      },
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white60,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.blue,
                                width: 0.0),

                          ),
                          hintText: "Visitor Name/PhoneNumber",
                          prefixIcon: Icon(Icons.search),
                          prefixIconColor: Colors.black
                      ),
                    ),
                  )
              ),
              Expanded(
                  child: StreamBuilder(
                      stream:query,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        for (int i =0; i < snapshot.data!.docs.length;i++){
                          if (snapshot.data!.docs[i]['status']=='Accepted' ){
                            if(snapshot.data!.docs[i]['checkInStatus']=='-'){
                              if (DateTime.parse(DateFormat('yyyy-MM-dd HH:mm:ss').format(snapshot.data!.docs[i]['endDate'].toDate())).isBefore(DateTime.parse(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())))==true){
                                updateInvitationInformation(snapshot.data!.docs[i].id);
                              }
                            }
                          }else if (snapshot.data!.docs[i]['status']=='Pending'){
                            if (DateTime.parse(DateFormat('yyyy-MM-dd HH:mm:ss').format(snapshot.data!.docs[i]['endDate'].toDate())).isBefore(DateTime.parse(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())))==true){
                              updateInvitationInformation(snapshot.data!.docs[i].id);
                            }
                          }

                        }
                        return StreamBuilder(
                            stream: FirebaseFirestore.instance.collection(
                                'visitor').snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<
                                QuerySnapshot> streamSnapshot) {
                              documents = streamSnapshot.data!.docs;
                              if (searchText.length > 0) {
                                if (RegExp(r'^[0-9]+$').hasMatch(
                                    searchText)) {
                                  documents = documents.where((element) {
                                    return element.get('phoneNumber')
                                        .toString()
                                        .toLowerCase()
                                        .contains(searchText.toLowerCase());
                                  }).toList();
                                } else {
                                  documents = documents.where((element) {
                                    return element.get('name')
                                        .toString()
                                        .toLowerCase()
                                        .contains(searchText.toLowerCase());
                                  }).toList();
                                }
                              }
                              return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    for (int i = 0; i < streamSnapshot.data!.docs.length; i++) {
                                      /* print(1111111111);
                                print( DateTime.parse(
                                    DateFormat('yyyy-MM-dd').format(
                                        snapshot.data!.docs[index]['GatekeeperRespondDate'].toDate()
                                    )
                                ));
                                print(
                                    DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()))
                                );
                                */

                                        if (snapshot.data!.docs[index]['visitorID'] ==
                                            documents[i]['uid']) {
                                          return GestureDetector(
                                            onTap: () {
                                              _showInvitationDetails(
                                                snapshot.data!
                                                    .docs[index]['visitorID'],
                                                snapshot.data!.docs[index].id,);
                                            },
                                            child: Column(
                                                children: [
                                                  SizedBox(height: 10),
                                                  ListTile(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius
                                                            .only(
                                                            topLeft: Radius
                                                                .circular(25),
                                                            topRight: Radius
                                                                .circular(25),
                                                            bottomRight: Radius
                                                                .circular(25),
                                                            bottomLeft: Radius
                                                                .circular(25))),
                                                    tileColor: snapshot.data!
                                                        .docs[index]['checkInStatus'] ==
                                                        'CheckIn'
                                                        ? Colors.green
                                                        :
                                                    snapshot.data!
                                                        .docs[index]['checkInStatus'] ==
                                                        'Reject' ? Colors.red :
                                                    snapshot.data!
                                                        .docs[index]['checkInStatus'] ==
                                                        'Expired' ? Colors.pink :
                                                    Colors.grey,
                                                    textColor: Colors.white,
                                                    contentPadding: EdgeInsets
                                                        .only(top: 4,
                                                        bottom: 10,
                                                        left: 0,
                                                        right: 6),
                                                    title: Text(
                                                      documents[i]['name'],
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    subtitle: Column(
                                                        crossAxisAlignment: CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          SizedBox(height: 10,),
                                                          Row(
                                                            children: [
                                                              Icon(Icons
                                                                  .phone,
                                                                color: Colors
                                                                    .white,
                                                                size: 15,),
                                                              SizedBox(
                                                                width: 5,),
                                                              Text(
                                                                "Phone Number:",
                                                                style: GoogleFonts
                                                                    .montserrat(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: 12),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 5,),
                                                          Text(
                                                            documents[i]['phoneNumber'],
                                                            style: GoogleFonts
                                                                .montserrat(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12),
                                                          ),
                                                          SizedBox(height: 10,),
                                                          Row(
                                                            children: [
                                                              Icon(Icons
                                                                  .access_time_sharp,
                                                                color: Colors
                                                                    .white,
                                                                size: 15,),
                                                              SizedBox(
                                                                width: 5,),
                                                              Text(
                                                                "Start Date:",
                                                                style: GoogleFonts
                                                                    .montserrat(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: 12),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 5,),
                                                          Text(
                                                            '${DateFormat
                                                                .yMMMMEEEEd()
                                                                .format(
                                                                snapshot.data!
                                                                    .docs[index]['startDate']
                                                                    .toDate())}',
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: GoogleFonts
                                                                .montserrat(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12),
                                                          ),
                                                          SizedBox(height: 10,),
                                                          Row(
                                                            children: [
                                                              Icon(Icons
                                                                  .access_time_sharp,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 15),
                                                              SizedBox(
                                                                width: 5,),
                                                              Text(
                                                                "End Date:",
                                                                style: GoogleFonts
                                                                    .montserrat(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: 12),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 5,),
                                                          Text(
                                                            '${DateFormat
                                                                .yMMMMEEEEd()
                                                                .format(
                                                                snapshot.data!
                                                                    .docs[index]['endDate']
                                                                    .toDate())}',
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: GoogleFonts
                                                                .montserrat(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12),
                                                          ),
                                                          SizedBox(height: 10,),
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                  Icons
                                                                      .access_time_sharp,
                                                                  color:
                                                                  snapshot.data!
                                                                      .docs[index]['checkInStatus'] =='-'?
                                                                  Colors.transparent:
                                                                  Colors
                                                                      .white,
                                                                  size: 15),
                                                              SizedBox(
                                                                width: 5,),
                                                              Text(
                                                                snapshot.data!
                                                                    .docs[index]['checkInStatus'] ==
                                                                      'CheckIn'
                                                                    ? 'Check-In Date'
                                                                    :
                                                                snapshot.data!
                                                                    .docs[index]['checkInStatus'] ==
                                                                    'Reject'
                                                                    ? 'Reject Date'
                                                                    :
                                                                snapshot.data!
                                                                    .docs[index]['checkInStatus'] ==
                                                                    'Expired'
                                                                    ? 'Expired'
                                                                    :
                                                                '',
                                                                style: GoogleFonts
                                                                    .montserrat(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: 12),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 5,),
                                                          Text(

                                                            '${DateFormat
                                                                .yMMMMEEEEd()
                                                                .format(
                                                                snapshot.data!
                                                                    .docs[index]['gatekeeperRespondDate']
                                                                    .toDate())}' =='Thursday, January 21, 1999' ? "":
                                                            '${DateFormat
                                                                .yMMMMEEEEd()
                                                                .format(
                                                                snapshot.data!
                                                                    .docs[index]['gatekeeperRespondDate']
                                                                    .toDate())}'

                                                            ,
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: GoogleFonts
                                                                .montserrat(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12),
                                                          ),
                                                        ]
                                                    ),
                                                    leading: CircleAvatar(
                                                      radius: 45.0,
                                                      backgroundImage: Image
                                                          .network(
                                                          documents[i]['userImage'])
                                                          .image, //here
                                                    ),
                                                  ),
                                                  SizedBox(height: 10,)
                                                ]
                                            ),
                                          );
                                        }
                                      }
                                    
                                    return SizedBox.shrink();
                                  }
                              );
                            }
                        );
                      }
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<QuerySnapshot<Map<String, dynamic>>> showResident(BuildContext context, String residentID) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('resident')
          .where("uid", isEqualTo: residentID)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loading indicator while waiting for the future to complete
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          // Handle any errors that occurred during the future execution
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.hasData) {
          // Access the documents and return the desired widget
          var documents = snapshot.data!.docs;
          if (documents.isNotEmpty) {
            var data = documents[0].data();

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'Resident Details',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 20,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: Image.network(data['userImage'].toString()).image,
                  ),
                  TextFormField(
                    minLines: 1,
                    maxLines: 3,
                    enabled: false,
                    controller: TextEditingController(
                        text: data['name'].toString()),
                    decoration: InputDecoration(
                      labelText: 'Resident Name',
                      icon: Icon(Icons.account_box),
                    ),
                  ),
                  TextFormField(
                    minLines: 1,
                    maxLines: 3,
                    enabled: false,
                    controller: TextEditingController(
                        text: data['phoneNumber'].toString()),
                    decoration: InputDecoration(
                      labelText: 'Resident Phone Number',
                      icon: Icon(Icons.phone),
                    ),
                  ),
                  TextFormField(
                    minLines: 1,
                    maxLines: 3,
                    enabled: false,
                    controller: TextEditingController(
                        text: data['address'].toString()),
                    decoration: InputDecoration(
                      labelText: 'Visitor Address',
                      icon: Icon(Icons.location_on),
                    ),
                  ),
                ],
              ),
            );
          }
        }
        // If the document does not exist or there is no data, return an empty widget
        return SizedBox.shrink();
      },
    );
  }
  FutureBuilder<QuerySnapshot<Map<String, dynamic>>> showGatekeeper(BuildContext context, String gatekeeperID) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('gatekeeper')
          .where("uid", isEqualTo: gatekeeperID)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loading indicator while waiting for the future to complete
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          // Handle any errors that occurred during the future execution
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.hasData) {

          // Access the documents and return the desired widget
          var documents = snapshot.data!.docs;
          if (documents.isNotEmpty) {
            var data = documents[0].data();
            print(22222);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'Gatekeeper Details',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 20,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: Image.network(data['userImage'].toString()).image,
                  ),
                  TextFormField(
                    minLines: 1,
                    maxLines: 3,
                    enabled: false,
                    controller: TextEditingController(
                        text: data['name'].toString()),
                    decoration: InputDecoration(
                      labelText: 'Resident Name',
                      icon: Icon(Icons.account_box),
                    ),
                  ),
                  TextFormField(
                    minLines: 1,
                    maxLines: 3,
                    enabled: false,
                    controller: TextEditingController(
                        text: data['phoneNumber'].toString()),
                    decoration: InputDecoration(
                      labelText: 'Resident Phone Number',
                      icon: Icon(Icons.phone),
                    ),
                  ),
                ],
              ),
            );
          }
        }
        // If the document does not exist or there is no data, return an empty widget
        return SizedBox.shrink();
      },
    );
  }
  _showInvitationDetails(String visitorID, String invitationID) async {
    var collection = FirebaseFirestore.instance.collection('visitor').where(
        "uid", isEqualTo: visitorID);
    var querySnapshot = await collection.get();
    Map<String, dynamic> data;
    FirebaseFirestore.instance
        .collection('invitation').doc(invitationID).get()
        .then((DocumentSnapshot documentSnapshot) =>
    {
      if(documentSnapshot.exists){
        for(var queryDocumentSnapshot in querySnapshot.docs){
          data = queryDocumentSnapshot.data(),
          if(data['uid'].toString() ==
              documentSnapshot['visitorID'].toString()){
            showDialog(
                context: context,
                builder: (BuildContext context) {

                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    scrollable: true,
                    title: Text(
                      'Invitation Details',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 20,
                        decoration: TextDecoration.none,
                      ),),
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50.0,
                              backgroundImage: Image
                                  .network(data['userImage'].toString())
                                  .image, //here
                            ),
                            TextFormField(
                              minLines: 1,
                              maxLines: 3,
                              enabled: false,
                              controller: TextEditingController(
                                  text: data['name'].toString()),
                              decoration: InputDecoration(
                                labelText: 'Visitor Name',
                                icon: Icon(Icons.account_box),
                              ),
                            ),
                            TextFormField(
                              minLines: 1,
                              maxLines: 3,
                              enabled: false,
                              controller: TextEditingController(
                                  text: data['icNumber'].toString()),
                              decoration: InputDecoration(
                                labelText: 'IC Number',
                                icon: Icon(Icons.switch_account),
                              ),
                            ),
                            TextFormField(
                              minLines: 1,
                              maxLines: 3,
                              enabled: false,
                              controller: TextEditingController(
                                  text: data['address'].toString()),
                              decoration: InputDecoration(
                                labelText: 'Visitor Address',
                                icon: Icon(Icons.location_on),
                              ),
                            ),
                            TextFormField(
                              minLines: 1,
                              maxLines: 3,
                              enabled: false,
                              controller: TextEditingController(
                                  text: data['phoneNumber'].toString()),
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                icon: Icon(Icons.phone),
                              ),
                            ),
                            TextFormField(
                              minLines: 1,
                              maxLines: 3,
                              enabled: false,
                              controller: TextEditingController(
                                  text: '${DateFormat('EEE, MMM d, ' 'yy')
                                      .format(documentSnapshot['startDate']
                                      .toDate())}'),
                              decoration: InputDecoration(
                                labelText: 'Start Date',
                                icon: Icon(Icons.access_time_outlined),
                              ),
                            ),
                            TextFormField(
                              minLines: 1,
                              maxLines: 3,
                              enabled: false,
                              controller: TextEditingController(
                                  text: '${DateFormat('EEE, MMM d, ' 'yy')
                                      .format(
                                      documentSnapshot['endDate'].toDate())}'),
                              decoration: InputDecoration(
                                labelText: 'End Date',
                                icon: Icon(Icons.access_time_outlined),
                              ),
                            ),
                            TextFormField(
                              minLines: 1,
                              maxLines: 3,
                              enabled: false,
                              controller: TextEditingController(
                                  text: '${ documentSnapshot['status']
                                      .toString()}'),
                              decoration: InputDecoration(
                                labelText: 'Visitor Respond',
                                icon: Icon(Icons.list),
                              ),
                            ),
                            TextFormField(
                              minLines: 1,
                              maxLines: 3,
                              enabled: false,
                              controller: TextEditingController(
                                  text: '${DateFormat('EEE, MMM d, ' 'yy')
                                      .format(
                                      documentSnapshot['gatekeeperRespondDate']
                                          .toDate())}'),
                              decoration: InputDecoration(
                                labelText: documentSnapshot['checkInStatus']
                                    .toString() == 'CheckIn'
                                    ? 'Check-In Date'
                                    : 'Reject Date',
                                icon: Icon(Icons.access_time_outlined),
                              ),
                            ),
                            TextFormField(
                              minLines: 1,
                              maxLines: 3,
                              enabled: false,
                              controller: TextEditingController(
                                  text: '${ documentSnapshot['checkInStatus']
                                      .toString()}'),
                              decoration: InputDecoration(
                                labelText: 'Check In Status',
                                icon: Icon(Icons.list),
                              ),
                            ),
                            showResident( context,documentSnapshot['residentID']),
                            showGatekeeper( context,documentSnapshot['checkInBy']),
                          ],
                        ),
                      ),
                    ),

                  );
                }
            )
          }
        }
      }
    });
  }
  updateInvitationInformation(String docID){
    var collection = FirebaseFirestore.instance.collection('invitation');
    collection
        .doc(docID) // <-- Doc ID where data should be updated.
        .update({'checkInStatus':'Expired',
      'status':'Rejected'
    }); // <-- Nested value;
  }
}
