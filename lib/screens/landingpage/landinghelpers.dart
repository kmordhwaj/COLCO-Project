import 'package:colco_project/constants/constantcolors.dart';
import 'package:colco_project/screens/homepage/homepage.dart';
import 'package:colco_project/screens/landingpage/landingservices.dart';
import 'package:colco_project/screens/landingpage/landingutils.dart';
import 'package:colco_project/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class LandingHelpers with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

  Widget bodyImage(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/login.png'))),
    );
  }

  Widget taglineText(BuildContext context) {
    return Positioned(
        top: 450,
        left: 10,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 170),
          child: RichText(
              text: TextSpan(
                  text: 'Do You',
                  style: TextStyle(
                      color: constantColors.blueColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 35),
                  children: <TextSpan>[
                TextSpan(
                  text: 'Collaberate ',
                  style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
                TextSpan(
                  text: '?',
                  style: TextStyle(
                      color: constantColors.blueColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                )
              ])),
        ));
  }

  Widget mainButtons(BuildContext context) {
    return Positioned(
        top: 630,
        // ignore: sized_box_for_whitespace
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  emailAuthSheet(context);
                },
                child: Container(
                  width: 80,
                  height: 40,
                  child: Icon(
                    CupertinoIcons.envelope,
                    color: constantColors.blueColor,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: constantColors.blueColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // ignore: avoid_print
                  print('Signing with Google...');
                  Provider.of<Authentication>(context, listen: false)
                      .signInWithGoogle()
                      .whenComplete(() {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child:const HomePage(),
                            type: PageTransitionType.leftToRight));
                  });
                },
                child: Container(
                  width: 80,
                  height: 40,
                  child: Icon(
                    FontAwesomeIcons.google,
                    color: constantColors.redColor,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: constantColors.redColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget privacyText(BuildContext context) {
    return Positioned(
        top: 720,
        left: 20,
        right: 20,
        // ignore: avoid_unnecessary_containers
        child: Container(
          child: Column(
            children: [
              Text(
                "By Continuing you agree COLCO's term's of",
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
              Text(
                "services and privacy policy",
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              )
            ],
          ),
        ));
  }

  emailAuthSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150),
                  child:
                      Divider(thickness: 3, color: constantColors.whiteColor),
                ),
                Provider.of<LandingService>(context, listen: false)
                    .passwordlessSignIn(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                        color: constantColors.blueColor,
                        child: Text('Log In',
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        onPressed: () {
                          Provider.of<LandingService>(context, listen: false)
                              .loginSheet(context);
                        }),
                    MaterialButton(
                        color: constantColors.redColor,
                        child: Text('Register',
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        onPressed: () {
                          Provider.of<LandingUtils>(context, listen: false)
                              .selectAvatarOptionsSheet(context);
                        })
                  ],
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
          );
        });
  }
}
