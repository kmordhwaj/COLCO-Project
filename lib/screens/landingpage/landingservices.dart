//import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colco_project/constants/constantcolors.dart';
import 'package:colco_project/screens/homepage/homepage.dart';
import 'package:colco_project/screens/landingpage/landingutils.dart';
import 'package:colco_project/services/authentication.dart';
import 'package:colco_project/services/firebaseoperations.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/painting.dart';
//import 'package:flutter/rendering.dart';
//import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class LandingService with ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  ConstantColors constantColors = ConstantColors();

  showUserAvatar(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150),
                    child:
                        Divider(thickness: 3, color: constantColors.whiteColor),
                  ),
                  CircleAvatar(
                    backgroundColor: constantColors.transparent,
                    radius: 80,
                    backgroundImage: FileImage(
                        Provider.of<LandingUtils>(context, listen: false)
                            .userAvatar),
                  ),
                  // ignore: avoid_unnecessary_containers
                  Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                          color: constantColors.redColor,
                          child: Text('Reselect',
                              style: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  decorationColor: constantColors.whiteColor)),
                          onPressed: () {
                            Provider.of<LandingUtils>(context, listen: false)
                                .pickUserAvatar(context, ImageSource.gallery);
                          }),
                      MaterialButton(
                          color: constantColors.blueColor,
                          child: Text('Confirm',
                              style: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                              )),
                          onPressed: () {
                            Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .uploadUserAvatar(context)
                                .whenComplete(() {});
                          })
                    ],
                  ))
                ],
              ),
              decoration: BoxDecoration(
                  color: constantColors.blueGreyColor,
                  borderRadius: BorderRadius.circular(15)));
        });
  }

  Widget passwordlessSignIn(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView(
                children: snapshot.data!.docs
                    .map((DocumentSnapshot documentSnapshot) {
              return ListTile(
                trailing: IconButton(
                    onPressed: () {},
                    icon: Icon(FontAwesomeIcons.trash,
                        color: Colors.red.shade200)),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(documentSnapshot['userImage']),
                ),
                title: Text(
                  documentSnapshot['userName'],
                  style: TextStyle(
                      color: constantColors.greenColor,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  documentSnapshot['userEmail'],
                  style: TextStyle(
                      color: constantColors.greenColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              );
            }).toList());
          }
        },
      ),
    );
  }

  loginSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 150),
                      child: Divider(
                          thickness: 3, color: constantColors.whiteColor),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                              hintText: 'Enter Email',
                              hintStyle: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                              hintText: 'Enter Password',
                              hintStyle: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          style: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                    ),
                    FloatingActionButton(
                        backgroundColor: constantColors.blueColor,
                        onPressed: () {
                          if (emailController.text.isNotEmpty) {
                            Provider.of<Authentication>(context, listen: false)
                                .loginToAccount(emailController.text,
                                    passwordController.text)
                                .whenComplete(() {
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      child:const HomePage(),
                                      type: PageTransitionType.bottomToTop));
                            });
                          } else {
                            warningText(context, 'Fill all the data!');
                          }
                        },
                        child: Icon(
                          FontAwesomeIcons.check,
                          color: constantColors.whiteColor,
                        ))
                  ],
                ),
                decoration: BoxDecoration(
                    color: constantColors.blueGreyColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14)))),
          );
        });
  }

  registerSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: constantColors.blueGreyColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150),
                    child:
                        Divider(thickness: 3, color: constantColors.whiteColor),
                  ),
                  CircleAvatar(
                    backgroundImage: FileImage(
                        Provider.of<LandingUtils>(context, listen: false)
                            .getUserAvatar),
                    backgroundColor: constantColors.transparent,
                    radius: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                        controller: userNameController,
                        decoration: InputDecoration(
                            hintText: 'Enter Name',
                            hintStyle: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                            hintText: 'Enter Email',
                            hintStyle: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                            hintText: 'Enter Password',
                            hintStyle: TextStyle(
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: FloatingActionButton(
                        backgroundColor: constantColors.redColor,
                        onPressed: () {
                          if (emailController.text.isNotEmpty) {
                            Provider.of<Authentication>(context, listen: false)
                                .createAccount(emailController.text,
                                    passwordController.text)
                                .whenComplete(() {
                              // ignore: avoid_print
                              print('creating collection');
                              Provider.of<FirebaseOperations>(context,
                                      listen: false)
                                  .createUserCollection(context, {
                                'userUid': Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid,
                                'userEmail': emailController.text,
                                'userName': userNameController.text,
                                'userImage': Provider.of<LandingUtils>(context,
                                        listen: false)
                                    .getUserAvatarUrl
                              });
                            }).whenComplete(() {
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      child:const HomePage(),
                                      type: PageTransitionType.bottomToTop));
                            });
                          } else {
                            warningText(context, 'Fill all the data!');
                          }
                        },
                        child: Icon(
                          FontAwesomeIcons.check,
                          color: constantColors.whiteColor,
                        )),
                  )
                ],
              ),
            ),
          );
        });
  }

  warningText(BuildContext context, String warning) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              decoration: BoxDecoration(
                  color: constantColors.darkColor,
                  borderRadius: BorderRadius.circular(15)),
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text(warning,
                      style: TextStyle(
                          color: constantColors.whiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold))));
        });
  }
}
