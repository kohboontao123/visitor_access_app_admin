import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visitor_access_app_admin/model/gatekeepr_model.dart';
import 'package:visitor_access_app_admin/screen/manage_gatekeeper_screen.dart';
import 'package:visitor_access_app_admin/screen/manage_resident_screen.dart';
import '../class/class.dart';
import '../model/resident_model.dart';
import 'package:flutter/widgets.dart';


class EditGatekeeperScreen extends StatefulWidget {
  const EditGatekeeperScreen({Key? key}) : super(key: key);

  @override
  State<EditGatekeeperScreen> createState() => _EditGatekeeperScreenState();
}

class _EditGatekeeperScreenState extends State<EditGatekeeperScreen> {
  final _formKey=GlobalKey<FormState>();
  String? errorMessage;
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _idTextController = TextEditingController();
  TextEditingController _addressTextController = TextEditingController();
  TextEditingController _phoneNumberTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  UploadTask? uploadTask;
  String imgPath ="";
  var img = Image.network(GatekeeperClass.userImage.toString());
  late var gender;
  late List<String> listOfValue=['Male','Female'];
  bool _isLoading= false;
  bool _btnActiveIsLoading= false;
  bool _isBtnDisable = false;
  void initState(){
    super.initState();
    _nameTextController=TextEditingController(text:GatekeeperClass.name);
    _idTextController=TextEditingController(text:GatekeeperClass.icNumber);
    _addressTextController=TextEditingController(text:GatekeeperClass.address);
    _phoneNumberTextController=TextEditingController(text:GatekeeperClass.phoneNumber);
    _emailTextController=TextEditingController(text:GatekeeperClass.email);
    gender=GatekeeperClass.gender;

  }

  @override
  Widget build(BuildContext context) {
    final emailField = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child:TextFormField(
        enabled: false,
        controller:_emailTextController,
        keyboardType: TextInputType.emailAddress,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z 0-9_@.]')),
        ],
        validator: (value){
          if (value!.isEmpty){
            return ("Please Enter Your Email Address");
          }
          if (!RegExp("^[a-zA-Z0-9+.-]+@[a-zA-Z0-9+.-]+.[a-z]").hasMatch(value)){
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved:(value){
          _emailTextController.text=value!;
        },
        decoration: InputDecoration(
            hintText: "Your Email Address",
            labelText: "Email Address (Not editable)",
            labelStyle: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.grey[600]),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            fillColor: Colors.black12,
            filled: true),
        obscureText: false,
        //maxLength: 20,
      ),
    );
    final nameField=  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: TextFormField(
        controller:_nameTextController,
        textCapitalization: TextCapitalization.characters,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
        ],
        validator: (value){
          if (value!.isEmpty){
            return ("Please Enter Gatekeeper Name");
          }
          return null;
        },
        onSaved:(value){
          _nameTextController.text=value!;
        },
        decoration: InputDecoration(
            hintText: "Gatekeeper Name",
            labelText: "Full Name (as per Mykad)",
            labelStyle: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.grey[600]),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            fillColor: Colors.black12,
            filled: true),
        obscureText: false,
        //maxLength: 20,
      ),
    );
    final idField= Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child:TextFormField(
        keyboardType: TextInputType.number,
        controller:_idTextController,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        ],
        validator: (value){
          if (value!.isEmpty){
            return ("Please Enter Gatekeeper ID Number");
          }
          if (value.length != 12 ){
            return ("ID must equal 12 digits");
          }
          return null;
        },
        onSaved:(value){
          _idTextController.text=value!;
        },
        decoration: InputDecoration(
            hintText: "Gatekeeper ID Number",
            labelText: "ID Number",
            labelStyle: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.grey[600]),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            fillColor: Colors.black12,
            filled: true),
        obscureText: false,
        //maxLength: 14,
      ),
    );
    final addressField= Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child:TextFormField(
        controller:_addressTextController,
        textCapitalization: TextCapitalization.characters,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z 0-9/-]')),
        ],
        validator: (value){
          if (value!.isEmpty){
            return ("Please Enter Gatekeeper Address");
          }

          return null;
        },
        onSaved:(value){
          _addressTextController.text=value!;
        },
        decoration: InputDecoration(
            hintText: "Gatekeeper Address",
            labelText: "Address",
            labelStyle: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.grey[600]),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            fillColor: Colors.black12,
            filled: true),
        obscureText: false,
        //maxLength: 20,
      ),
    );
    final phoneField = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child:TextFormField(
        controller:_phoneNumberTextController,
        keyboardType: TextInputType.phone,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        ],
        validator: (value){
          if (value!.isEmpty){
            return ("Please Enter Gatekeeper Phone Number");
          }
          if (value.length < 10){
            return ("Phone Number must more then or equal 10 digits");
          }
          return null;
        },
        onSaved:(value){
          _phoneNumberTextController.text=value!;
        },
        decoration: InputDecoration(
            hintText: "Gatekeeper Phone Number",
            labelText: "Phone Number",
            labelStyle: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.grey[600]),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            fillColor: Colors.black12,
            filled: true),
        obscureText: false,
        //maxLength: 20,
      ),
    );
    final genderDropDown =SizedBox(
        width: MediaQuery. of(context). size. width,
        child: Row(
          children: [
            Expanded(
                child: idField
            ),
            Expanded(
              child:Padding(
                padding:  EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: DropdownButtonFormField(

                  decoration: InputDecoration(
                      labelText: "Gender",
                      labelStyle: TextStyle(fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.grey[600]),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      fillColor: Colors.black12,
                      filled: true),
                  value: GatekeeperClass.gender,
                  hint: Text(
                    'choose one',
                  ),
                  isExpanded: true,
                  onChanged: (value) {
                    setState(() {
                      gender = value;
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      gender = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Gender is required';
                    }
                  },
                  items: listOfValue
                      .map((String val) {
                    return DropdownMenuItem(
                      value: val,
                      child: Text(
                        val,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        )
    );
    final btnUpdate = MaterialButton(
      onPressed: _isBtnDisable? null: ()async {
        if(_isLoading)return;
        update();
        setState((){
          _isLoading=true;
        });

        //Navigator.push(context, MaterialPageRoute(builder: (context)=> CameraScreen()));
        await Future.delayed(Duration(seconds: 2));
        setState(()=>_isLoading=false);
      },
      child: Padding(
        padding:const EdgeInsets.symmetric(horizontal: 25.0),
        child: Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: _isLoading
                  ?Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 20, height: 20,
                      child: CircularProgressIndicator(color: Colors.white,)),
                  SizedBox(width:24),
                  Text(
                    'Please wait...',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18
                    ),
                  ),
                ],
              )
                  :Text(
                'Update',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                ),
              ),
            )
        ),
      ),
    );
    final btnDeactive = MaterialButton(
      onPressed: _btnActiveIsLoading? null: ()async {

        if(_btnActiveIsLoading)return;
        activate();
        setState((){
          _btnActiveIsLoading=true;
        });
        setState(()=>_btnActiveIsLoading=false);
      },
      child: Padding(
        padding:const EdgeInsets.symmetric(horizontal: 25.0),
        child: Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color:GatekeeperClass.status=="active"? Colors.red: Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: _btnActiveIsLoading
                  ?Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 20, height: 20,
                      child: CircularProgressIndicator(color: Colors.white,)),
                  SizedBox(width:24),
                  Text(
                    'Please wait...',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18
                    ),
                  ),
                ],
              )
                  :GatekeeperClass.status=="active"?Text(
                'Deactivate',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                ),
              ):Text(
                'Activate',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                ),
              ),
            )
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        leading:GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> ManageGatekeeperScreen()));
          },
          child:Icon(
            Icons.arrow_back,
            size: 26.0,

          ),
        ),
        backgroundColor: Colors.deepPurple[200],
        elevation: 0,
        title: Text('Edit Gatekeeper Information'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              Text(
                'Review gatekeeper details',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  await ImagePicker().pickImage(source: ImageSource.gallery).then(
                          (value) => setImage(value!.path));
                  //_pickImage(ImageSource.gallery);
                },
                child:Container(
                  color: Colors.transparent,
                  child: CircleAvatar(
                    radius: 90.0,
                    backgroundImage: img.image, //here
                  ),

                ),
              ),
              SizedBox(height: 20),
              emailField,
              SizedBox(height: 20),
              nameField,
              SizedBox(height: 20),
              genderDropDown,
              SizedBox(height: 20),
              addressField,
              SizedBox(height: 20),
              phoneField,
              SizedBox(height: 20),
              btnUpdate,
              SizedBox( height:5),
              btnDeactive
            ],
          ),
        ),
      ),
    );
  }
  update() async {
    GatekeeperModel gatekeeperModel = GatekeeperModel();
    gatekeeperModel.email=GatekeeperClass.email;
    gatekeeperModel.uid=GatekeeperClass.uid;
    gatekeeperModel.name=_nameTextController.text;
    gatekeeperModel.address=_addressTextController.text;
    gatekeeperModel.gender= gender;
    gatekeeperModel.phoneNumber=_phoneNumberTextController.text;
    gatekeeperModel.icNumber=_idTextController.text;
    gatekeeperModel.userImage=await uploadGatekeeperImage();
    gatekeeperModel.status = 'active';
    var collection = FirebaseFirestore.instance.collection('gatekeeper');
    collection
        .doc(GatekeeperClass.uid) // <-- Doc ID where data should be updated.
        .update(gatekeeperModel.toMap()) // <-- Nested value
        .then((_) => Fluttertoast.showToast(msg: "The gatekeeper's profile has been successfully updated"))
        .catchError((error) =>  Fluttertoast.showToast(msg: 'Update failed: $error'));
  }
  Future<String> uploadGatekeeperImage() async {
    if (imgPath==""){
      return 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=';
    }else{
      final path= 'gatekeeperImage/${_idTextController.text+"_"+_nameTextController.text}';
      final file= File(imgPath);
      final ref=FirebaseStorage.instance.ref().child(path);
      uploadTask=ref.putFile(file);
      final snapshot= await uploadTask!.whenComplete(() {});
      return await snapshot.ref.getDownloadURL();
    }


  }

  activate() async {
    try{
      var name = GatekeeperClass.name;
      if(GatekeeperClass.status=="active"){
        var collection = FirebaseFirestore.instance.collection('gatekeeper');
        collection
            .doc(GatekeeperClass.uid) // <-- Doc ID where data should be updated.
              .update({'status':'deactive'}) // <-- Nested value
            .then((_) => Fluttertoast.showToast(msg: '$name has been deactivated'))
            .catchError((error) =>  Fluttertoast.showToast(msg: 'Update failed: $error'));
      }else{
        var collection = FirebaseFirestore.instance.collection('gatekeeper');
        collection
            .doc(GatekeeperClass.uid) // <-- Doc ID where data should be updated.
            .update({'status':'active'}) // <-- Nested value
            .then((_) => Fluttertoast.showToast(msg: '$name has been activated'))
            .catchError((error) =>  Fluttertoast.showToast(msg: 'Update failed: $error'));
      }
      Navigator.pushAndRemoveUntil((context), MaterialPageRoute(builder: (context) => ManageGatekeeperScreen()), (route) => false);

    }on FirebaseAuthException catch (error){
      Fluttertoast.showToast(msg: error.code);
    }


  }
  setImage(String imagePath) {
    if (imagePath == null) return Fluttertoast.showToast(msg: "No Image Selected");
    setState(() {
      img = Image.file(File(imagePath));
      imgPath=imagePath;
    }
    );
  }

}
