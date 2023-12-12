import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ResidentSearch extends SearchDelegate<String>{

  ResidentSearch({
    String hintText = "Search...",
  }) : super(
    searchFieldLabel: hintText,
    keyboardType: TextInputType.text,
    textInputAction: TextInputAction.go,
  );
  @override
  List<Widget>? buildActions(BuildContext context) {
    return[
      IconButton(icon: Icon(Icons.clear),
          onPressed: (){
            query="";
          })];
  }

  @override
  Widget? buildLeading(BuildContext context) {

    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context,query);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        child: Card(
          color: Colors.red,
          child: Center(
            child:Text(query),
          ),
        ),
      ),
    );
  }
  @override
  Widget buildSuggestions(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
        stream:FirebaseFirestore.instance.collection('shops').where("status", isEqualTo: "Active").orderBy("shopGeopoint").snapshots(),
        builder: (context,snapshot){
          if (!snapshot.hasData) return new Text('Loading...');
          final results =
          snapshot.data!.docs.where((a) => a['shopName'].toLowerCase().contains(query.toLowerCase())|| a['shopName'].startsWith(query.toLowerCase()));

          return ListView(
            children: results.map<Widget>((doc) {
              return Card(
                child: ListTile(
                  onTap: (){
                    //Navigator.push(context, MaterialPageRoute(builder: (context)=> ShopScreen(doc.id,doc['shopImage'],doc['shopName'],doc['shopGeopoint'].latitude ,doc['shopGeopoint'].longitude,doc['phoneNumber'],doc['shopAddress'])));
                  },
                  title: RichText(
                    text: TextSpan(
                      text: doc['shopName'],
                      style: TextStyle(
                          color: Colors.black,fontWeight: FontWeight.bold),
                    ),
                  ),
                  leading:Container(
                    width: 40,
                    height: 40,
                    child: ClipOval(
                      child: Image.network(
                        doc['shopImage'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }
    );


  }

}