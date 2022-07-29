import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colco_project/constants/constantcolors.dart';
import 'package:colco_project/screens/profile/profilehelpers.dart';
import 'package:colco_project/services/authentication.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);
  final ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              EvaIcons.settings2Outline,
              color: constantColors.lightBlueColor,
            )),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                EvaIcons.logOutOutline,
                color: constantColors.greenColor,
              ))
        ],
        backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
        title: RichText(
            text: TextSpan(
                text: 'My',
                style: TextStyle(
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                children: <TextSpan>[
              TextSpan(
                text: 'Profile',
                style: TextStyle(
                    color: constantColors.blueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              )
            ])),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder<DocumentSnapshot<Object?>>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(Provider.of<Authentication>(context, listen: false)
                    .getUserUid)
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              final ds = snapshot.data!;

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Column(
                  children: [
                    Provider.of<ProfileHelpers>(context, listen: false)
                        .headerProfile(context, ds),
                    Provider.of<ProfileHelpers>(context, listen: false)
                        .divider()
                  ],
                );
              }
            },
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: constantColors.blueGreyColor.withOpacity(0.6)),
        ),
      ),
    );
  }
}
