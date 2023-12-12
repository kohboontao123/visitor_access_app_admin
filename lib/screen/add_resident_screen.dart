import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../model/resident_model.dart';
import 'package:flutter/widgets.dart';


class AddResidentScreen extends StatefulWidget {
  const AddResidentScreen({Key? key}) : super(key: key);

  @override
  State<AddResidentScreen> createState() => _AddResidentScreenState();
}

class _AddResidentScreenState extends State<AddResidentScreen> {
  final _formKey=GlobalKey<FormState>();
  String? errorMessage;
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _idTextController = TextEditingController();
  TextEditingController _addressTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _phoneNumberTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _comfirmPasswordTextController = TextEditingController();
  UploadTask? uploadTask;
  String imgPath ="";
  var img = Image.network('https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=');
  late var gender;
  late List<String> listOfValue=['Male','Female'];
  bool _isLoading= false;
  bool _isBtnDisable = false;

  @override
  Widget build(BuildContext context) {
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
            return ("Please Enter Resident Name");
          }
          return null;
        },
        onSaved:(value){
          _nameTextController.text=value!;
        },
        decoration: InputDecoration(
            hintText: "Resident Name",
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
            return ("Please Enter Resident ID Number");
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
            hintText: "Resident ID Number",
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
            return ("Please Enter Resident Address");
          }

          return null;
        },
        onSaved:(value){
          _addressTextController.text=value!;
        },
        decoration: InputDecoration(
            hintText: "Resident Address",
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
    final emailField = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child:TextFormField(
        controller:_emailTextController,
        keyboardType: TextInputType.emailAddress,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z 0-9_@.]')),
        ],
        validator: (value){
          if (value!.isEmpty){
            return ("Please Enter Resident Email Address");
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
            hintText: "Resident Email Address",
            labelText: "Email Address",
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
            return ("Please Enter Resident Phone Number");
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
            hintText: "Resident Phone Number",
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
    final passwordField =  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child:TextFormField(
        controller:_passwordTextController,
        validator: (value){
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty){
            return ("Password is required for register");
          }
          if (!regex.hasMatch(value)){
            return ("PLease Enter Valid Password(Min. 6 Character");
          }
        },
        onSaved:(value){
          _passwordTextController.text=value!;
        },
        decoration: InputDecoration(
            hintText: "Resident Password",
            labelText: "Password",
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
        obscureText: true,
        //maxLength: 20,
      ),
    );
    final confirmPasswordField = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child:TextFormField(
        controller:_comfirmPasswordTextController,
        validator: (value){
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty){
            return ("Password is required for register");
          }
          if (!regex.hasMatch(value)){
            return ("PLease Enter Valid Password(Min. 6 Character");
          }
        },
        onSaved:(value){
          _comfirmPasswordTextController.text=value!;
        },
        decoration: InputDecoration(
            hintText: "Confirm Resident Password",
            labelText: "Confirm Password",
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
        obscureText: true,
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
                  //value: UserRegister.gender,
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
    final btnRegister = MaterialButton(
      onPressed: _isBtnDisable? null: ()async {
        if(_isLoading)return;
        setState((){
          _isLoading=true;
          if (_passwordTextController.text==_comfirmPasswordTextController.text){
            signUp( _emailTextController.text, _passwordTextController.text,context);
          }else{
            Fluttertoast.showToast(msg: "Please ensure that the password and the confirmation password are the same.");
            _isLoading=false;
          }
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
                'Register',
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
        backgroundColor: Colors.deepPurple[200],
        elevation: 0,
        title: Text('Add Resident'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              Text(
                'Review resident details',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Container(
                    width: double.infinity,
                    height: 40,
                    color:  Colors.deepPurple[100],
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Icon(Icons.warning),
                        SizedBox(width: 20),
                        const Text("Please fill in resident real information, it cannot \nbe modified after verification",
                            style: TextStyle(fontSize : 15)),
                      ],
                    )
                ),
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
              nameField,
              SizedBox(height: 20),
              genderDropDown,//gender
              //idField,
              SizedBox(height: 20),
              addressField,
              SizedBox(height: 20),
              emailField,
              SizedBox(height: 20),
              phoneField,
              SizedBox(height: 20),
              passwordField,
              SizedBox(height: 20),
              confirmPasswordField,
              SizedBox(height: 20),
              Row(
                  children:[
                    SizedBox( width:20),
                    Icon(
                      Icons.shield,
                      size:30,
                      color: Colors.green,
                    ),
                    SizedBox( width:10),
                    Column(
                      children: [
                        Text('Rest assured that resident data are kept secure \nand confidential ',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15
                          ),
                        ),
                      ],
                    )
                  ]
              ),
              SizedBox( height:10),
              btnRegister,
            ],
          ),
        ),
      ),
    );
  }
  void signUp(String email, String password,context) async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore(context),})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        setState(()=>_isLoading=false);
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }
  postDetailsToFirestore(context) async {
    // calling our firestore
    // calling our user model
    // sedning these values
    Fluttertoast.showToast(msg: "Please wait...");
    _isBtnDisable=false;
    FirebaseFirestore  firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    ResidentModel residentModel = ResidentModel();

    // writing all the values
    residentModel.email = user!.email;
    residentModel.uid = user.uid;
    residentModel.name=_nameTextController.text;
    residentModel.address=_addressTextController.text;
    residentModel.gender= gender;
    residentModel.phoneNumber=_phoneNumberTextController.text;
    residentModel.icNumber=_idTextController.text;
    residentModel.userImage=await uploadResidentImage();
    residentModel.status = 'active';
    _isBtnDisable=true;
    await firebaseFirestore
        .collection("resident")
        .doc(user.uid)
        .set(residentModel.toMap());
    Fluttertoast.showToast(msg: "Successful to add a resident");
    reset();
    _isBtnDisable=false;
  }
  void reset(){
    setState(() {
       _nameTextController.text = "";
        _idTextController.text= "";
       _addressTextController.text = "";
       _emailTextController.text= "";
       _phoneNumberTextController.text = "";
       _passwordTextController.text= "";
       _comfirmPasswordTextController.text = "";
       imgPath ="";
       img = Image.network('https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=');
       gender = null;
    });
  }
  Future<String> uploadResidentImage() async {
    if (imgPath==""){
      return 'https://media.istockphoto.com/vectors/user-icon-flat-isolated-on-white-background-user-symbol-vector-vector-id1300845620?k=20&m=1300845620&s=612x612&w=0&h=f4XTZDAv7NPuZbG0habSpU0sNgECM0X7nbKzTUta3n8=';
    }else{
      final path= 'residentImage/${_idTextController.text+"_"+_nameTextController.text}';
      final file= File(imgPath);
      final ref=FirebaseStorage.instance.ref().child(path);
      uploadTask=ref.putFile(file);
      final snapshot= await uploadTask!.whenComplete(() {});
      return await snapshot.ref.getDownloadURL();
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
