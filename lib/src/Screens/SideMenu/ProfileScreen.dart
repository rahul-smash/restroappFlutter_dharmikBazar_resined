import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/UserResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/Utils.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {

  bool isComingFromOtpScreen;
  String id;
  ProfileScreen(this.isComingFromOtpScreen,this.id);

  @override
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  UserModel user;

  final firstNameController = new TextEditingController();
  final lastNameController = new TextEditingController();
  final emailController = new TextEditingController();
  final phoneController = new TextEditingController();
  File image;

  @override
  initState() {
    super.initState();
    if(!widget.isComingFromOtpScreen){
      getProfileData();
    }
  }

  getProfileData() async {
    user = await SharedPrefs.getUser();
    setState(() {
      firstNameController.text = user.fullName;
      emailController.text = user.email;
      phoneController.text = user.phone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text(widget.isComingFromOtpScreen == true ? 'SignUp' : "My Profile"),
        centerTitle: true,
      ),
      body: Container(

        /*decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/offer_bg.png"), fit: BoxFit.cover),
        ),*/
        child: SafeArea(
          top: false,
          bottom: false,
          child: new Form(
            key: _formKey,
            autovalidate: true,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: setProfileImage(context),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: TextField(
                        controller: firstNameController,
                        decoration: InputDecoration(
                            labelText: 'First name',
                            //floatingLabelBehavior: FloatingLabelBehavior.never
                        ),
                        style: TextStyle(
                            fontSize: 18,color: Color(0xFF495056),fontWeight: FontWeight.w500
                        ),
                      ),

                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: TextField(
                        controller: lastNameController,
                        decoration: InputDecoration(
                            labelText: 'Last name',
                            //floatingLabelBehavior: FloatingLabelBehavior.never
                        ),
                        style: TextStyle(
                            fontSize: 18,color: Color(0xFF495056),fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Text("Private Information",style: TextStyle(
                          fontSize: 16,color: Color(0xFF8F9396),fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: InputDecoration(
                            labelText: 'Email',
                            //floatingLabelBehavior: FloatingLabelBehavior.never
                        ),
                        style: TextStyle(
                            fontSize: 18,color: Color(0xFF495056),fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: TextField(
                        controller: phoneController,
                        decoration: InputDecoration(
                            labelText: 'Phone number',
                            //floatingLabelBehavior: FloatingLabelBehavior.never
                        ),
                        style: TextStyle(
                            fontSize: 18,color: Color(0xFF495056),fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 35.0,left: 20,right: 20),
                      child: ButtonTheme(
                        height: 50,
                        minWidth: MediaQuery.of(context).size.width,
                        child: RaisedButton(
                          onPressed: () => {


                          },
                          color: Color(0xFFF55202),
                          shape : RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Update",style: TextStyle(color: Colors.white,fontSize: 20)),
                              SizedBox(
                                  width: 6
                              ),
                              Image.asset("images/rightArrow.png",width: 15,height: 15,),
                            ],
                          ),
                        ),
                      ) ,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  setProfileImage(BuildContext context){
    var img = image == null ? NetworkImage('https://via.placeholder.com/140x100') : Image.file(image).image;
    return GestureDetector(
      onTap: (){
        showAlertDialog(context);
      },
      child: Center(
          child: CircleAvatar(
            backgroundColor: grayColor,
              radius: 60,
              backgroundImage: img
          )
      ),
    );
  }

  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget camera = FlatButton(
      child: Text("Camera"),
      onPressed:  () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        getCamera();

      },
    );
    Widget gallery = FlatButton(
      child: Text("Gallery"),
      onPressed:  () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        getGallery();

      },
    );

    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context, rootNavigator: true).pop('dialog');

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Select Image"),
      content: Text("Please select image "),
      actions: [
        camera,
        gallery,
        cancelButton
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  Future getCamera() async {
    var imageData = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      image =  imageData;
    });
  }

  Future getGallery() async {
    var imageData = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      image =  imageData;
    });
  }

  bool isValidEmail(String input) {
    final RegExp regex = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(input);
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
    } else {
      form.save();
      Utils.showProgressDialog(context);
      ApiController.updateProfileRequest(firstNameController.text, emailController.text,
          phoneController.text,widget.isComingFromOtpScreen,widget.id).then((response) {
        Utils.hideProgressDialog(context);
        if (response.success) {
          if(widget.isComingFromOtpScreen){

            UserModel user = UserModel();
            user.fullName =  firstNameController.text.trim();
            user.email =  emailController.text.trim();
            user.phone =  phoneController.text.trim();
            user.id = widget.id;
            Utils.showToast(response.message, true);
            SharedPrefs.saveUser(user);
            SharedPrefs.setUserLoggedIn(true);
            Navigator.pop(context);

          }else{
            user.fullName =  firstNameController.text.trim();
            user.email =  emailController.text.trim();
            user.phone =  phoneController.text.trim();
            Utils.showToast(response.message, true);
            SharedPrefs.saveUser(user);
            Navigator.pop(context);
          }
        }

      });

    }
  }
}
