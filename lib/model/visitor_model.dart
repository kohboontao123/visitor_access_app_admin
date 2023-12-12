class VisitorModel{
  String? uid;
  String? email;
  String? name;
  String? address;
  String? gender;
  String? phoneNumber;
  String? userImage;
  String? icNumber;
  String? status;
  VisitorModel({this.uid,this.email,this.name,this.address,this.gender,this.phoneNumber,this.userImage,this.icNumber,this.status});

  factory VisitorModel.fromMap(map){
    return VisitorModel(
      uid:map['uid'],
      email: map['email'],
      name: map['name'],
      address: map['address'],
      gender: map['gender'],
      phoneNumber: map['phoneNumber'],
      userImage: map['userImage'],
      icNumber: map['icNumber'],
      status:map['status'],
    );
  }
  Map<String,dynamic> toMap(){
    return{
      'uid':uid,
      'email':email,
      'name':name,
      'address':address,
      'gender':gender,
      'phoneNumber':phoneNumber,
      'userImage':userImage,
      'icNumber':icNumber,
      'status':status,
    };
  }
  Map<String,dynamic> update(){
    return{
      'name':name,
      'address':address,
      'gender':gender,
      'phoneNumber':phoneNumber,
      'icNumber':icNumber,
      'status':status,
    };
  }
}