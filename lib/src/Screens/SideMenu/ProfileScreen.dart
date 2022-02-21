import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:restroapp/src/UI/Language.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/FacebookModel.dart';
import 'package:restroapp/src/models/MobileVerified.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/models/UserResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/DialogUtils.dart';
import 'package:restroapp/src/utils/Utils.dart';

class ProfileScreen extends StatefulWidget {
  bool isComingFromOtpScreen;
  String id;
  String fullName = "";
  FacebookModel fbModel;
  GoogleSignInAccount googleResult;

  ProfileScreen(this.isComingFromOtpScreen, this.id, String fullName,
      this.fbModel, this.googleResult);

  @override
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  UserModel user;
  bool showGstNumber = false;
  final firstNameController = new TextEditingController();
  final emailController = new TextEditingController();
  final phoneController = new TextEditingController();
  final referCodeController = new TextEditingController();
  final gstCodeController = new TextEditingController();
  bool isLoginViaSocial = false;

  File image;
  StoreModel storeModel;
  bool isEmailEditable = false;
  bool isPhonereadOnly = true;
  bool showReferralCodeView = false;
  Language language;

  @override
  initState() {
    super.initState();
    language = Language();
    getProfileData();
  }

  getProfileData() async {
    //User Login with Mobile and OTP
    // 1 = email and 0 = ph-no
    try {
      user = await SharedPrefs.getUser();
    } catch (e) {
      print(e);
    }
    storeModel = await SharedPrefs.getStore();
    setState(() {
      if (user != null) {
        firstNameController.text = user.fullName;
        emailController.text = user.email;
        phoneController.text = user.phone;
      }
      print("storeModel.isRefererFnEnable=${storeModel.isRefererFnEnable}");
      if (storeModel.isRefererFnEnable && widget.fullName.isEmpty) {
        showReferralCodeView = true;
      } else {
        showReferralCodeView = false;
      }
      if (!widget.isComingFromOtpScreen) {
        showReferralCodeView = false;
      }
      if (storeModel.allowCustomerForGst != null &&
          storeModel.allowCustomerForGst.toLowerCase() == 'yes') {
        showGstNumber = true;
      } else {
        showGstNumber = false;
      }
      if (storeModel.internationalOtp == "0") {
        isEmailEditable = false;
      } else {
        isEmailEditable = true;
        isPhonereadOnly = false;
        showReferralCodeView = false;
      }

      if (widget.fbModel != null) {
        print("----------widget.fbModel != null---------");
        firstNameController.text = widget.fbModel.name;
        emailController.text = widget.fbModel.email;
        isPhonereadOnly = false;
        isLoginViaSocial = true;
      }
      if (widget.googleResult != null) {
        print("----------widget.googleResult != null---------");
        firstNameController.text = widget.googleResult.displayName;
        emailController.text = widget.googleResult.email;
        isPhonereadOnly = false;
        isLoginViaSocial = true;
      }

      if (isLoginViaSocial) {
        if (widget.fbModel != null) {
          if (widget.fbModel.email.isEmpty) {
            isEmailEditable = false;
          }
        } else if (widget.googleResult != null) {
          if (widget.googleResult.email.isEmpty) {
            isEmailEditable = false;
          }
        }
      }

      if (storeModel.internationalOtp == "1" && isLoginViaSocial) {
        if (widget.fbModel != null) {
          if (widget.fbModel.email.isNotEmpty) {
            isEmailEditable = true;
          }
        } else if (widget.googleResult != null) {
          if (widget.googleResult.email.isNotEmpty) {
            isEmailEditable = true;
          }
        }
      }

      print(
          "showReferralCodeView=${showReferralCodeView} and ${storeModel.isRefererFnEnable}");
    });
  }

  @override
  Widget build(BuildContext context) {
    //print("showReferralCodeView=${showReferralCodeView} and ${storeModel.isRefererFnEnable}");
    return WillPopScope(
        onWillPop: () async {
          if(!widget.isComingFromOtpScreen){
            return Future(()=>true);
          }else {
            return await nameValidation() &&
                isValidEmail(emailController.text) &&
                emailValidation();
          }
        },
        child: new Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: new Text("My Profile"),
            centerTitle: true,
            actions: [
//              InkWell(
//                onTap: () async {
//                  var result;
//
//                  String value = await SharedPrefs.getStoreSharedValue(AppConstant.SelectedLanguage);
//                  if(value == AppConstant.ENGLISH){
//                    value = AppConstant.Malay;
//                  }else {
//                    value = AppConstant.ENGLISH;
//                  }
//                  result = await DialogUtils.displayLanguageDialog(context, "Change Language",
//                      "Would you like to change the app language to ${value}?", "Cancel", "Ok");
//                  if(result == true){
//                    SharedPrefs.storeSharedValue(AppConstant.SelectedLanguage, value);
//                    language.changeLanguage().then((value){
//                      setState(() {
//
//                      });
//                    });
//                  }
//                },
//                child: Padding(
//                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
//                  child: Icon(Icons.language,color: Colors.white,),
//                ),
//              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 25, 20, 20),
              child: SafeArea(
                top: false,
                bottom: false,
                child: new Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 0),
                            child: Center(
                              child: Icon(
                                Icons.account_circle,
                                size: 100,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextField(
                              controller: firstNameController,
                              decoration: InputDecoration(
                                //labelText: 'Full name *',
                                labelText:
                                    Language.localizedValues["Full_name_txt"],
                              ),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF495056),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Visibility(
                            visible: showReferralCodeView,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: TextField(
                                controller: referCodeController,
                                decoration: InputDecoration(
                                  labelText: 'Referral Code',
                                ),
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF495056),
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextField(
                              readOnly: isEmailEditable,
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: 'Email *',
                              ),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF495056),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: TextField(
                              readOnly: isPhonereadOnly,
                              controller: phoneController,
                              decoration: InputDecoration(
                                labelText: 'Phone number',
                              ),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF495056),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Visibility(
                            visible:
                                widget.isComingFromOtpScreen && showGstNumber,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: TextField(
                                controller: gstCodeController,
                                decoration: InputDecoration(
                                  labelText: 'Enter Your GST number',
                                ),
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF495056),
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 35.0, left: 20, right: 20),
                            child: ButtonTheme(
                              height: 40,
                              minWidth: MediaQuery.of(context).size.width,
                              child: RaisedButton(
                                onPressed: () {
                                  _submitForm();
                                },
                                color: appThemeSecondary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("Update",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18)),
                                    SizedBox(width: 6),
                                    Image.asset(
                                      "images/rightArrow.png",
                                      width: 15,
                                      height: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  bool isValidEmail(String input) {
    //Email is opation
    if (input.trim().isEmpty) return true;
    final RegExp regex = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    bool isMatch = regex.hasMatch(input);
    if (!isMatch) Utils.showToast("Please enter valid email", false);
    return isMatch;
  }

  bool nameValidation() {
    if (firstNameController.text.trim().isEmpty) {
      Utils.showToast("Please enter your name", false);
      return false;
    } else {
      return true;
    }
  }

  bool emailValidation() {
    if (emailController.text.trim().isEmpty) {
      Utils.showToast("Please enter your email", false);
      return false;
    } else {
      return true;
    }
  }

  Future<void> _submitForm() async {
    if (!nameValidation()) {
      return;
    }
    if (!emailValidation()) {
      return;
    }
    if (!isValidEmail(emailController.text.trim())) {
      Utils.showToast("Please enter valid email", false);
      return;
    }
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
    } else {
      form.save();

      if (storeModel != null) {
        if (storeModel.internationalOtp == "0") {
          if (phoneController.text.trim().isEmpty) {
            Utils.showToast("Please enter your valid mobile number", false);
            return;
          }
        }
      }

      if (isLoginViaSocial) {
        Utils.showProgressDialog(context);
        MobileVerified userResponse = await ApiController.socialSignUp(
            widget.fbModel,
            widget.googleResult,
            firstNameController.text.trim(),
            emailController.text.trim(),
            phoneController.text.trim(),
            referCodeController.text.trim(),
            gstCodeController.text.trim());

        UserModel user = UserModel();
        user.fullName = firstNameController.text.trim();
        user.email = emailController.text.trim();
        user.phone = phoneController.text.trim();
        user.id = userResponse.user.id;
        SharedPrefs.saveUser(user);

        Utils.hideProgressDialog(context);
        Navigator.pop(context);
      } else {
        ApiController.updateProfileRequest(
                firstNameController.text.trim(),
                emailController.text.trim(),
                phoneController.text.trim(),
                widget.isComingFromOtpScreen,
                widget.id,
                referCodeController.text.trim(),
                gstCodeController.text.trim())
            .then((response) {
          Utils.hideProgressDialog(context);
          if (response.success) {
            if (widget.isComingFromOtpScreen) {
              UserModel user = UserModel();
              user.fullName = firstNameController.text.trim();
              user.email = emailController.text.trim();
              user.phone = phoneController.text.trim();
              user.id = widget.id;
              Utils.showToast(response.message, true);
              SharedPrefs.saveUser(user);
              SharedPrefs.setUserLoggedIn(true);
              Navigator.pop(context);
            } else {
              user.fullName = firstNameController.text.trim();
              user.email = emailController.text.trim();
              user.phone = phoneController.text.trim();
              Utils.showToast(response.message, true);
              SharedPrefs.saveUser(user);
              Navigator.pop(context);
            }
          } else {
            Utils.showToast(response.message, true);
          }
        });
      }
    }
  }
}
