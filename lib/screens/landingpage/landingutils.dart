import 'dart:io';
import 'package:colco_project/constants/constantcolors.dart';
import 'package:colco_project/screens/landingpage/landingservices.dart';
//import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class LandingUtils with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  final picker = ImagePicker();
  late File userAvatar;
  File get getUserAvatar => userAvatar;
  late String userAvatarUrl;
  String get getUserAvatarUrl => userAvatarUrl;

  Future pickUserAvatar(BuildContext context, ImageSource source) async {
    final pickedUserAvatar = await picker.pickImage(source: source);
    pickedUserAvatar == null
        // ignore: avoid_print
        ? print('Select image')
        : userAvatar = File(pickedUserAvatar.path);
    // ignore: avoid_print
    print(userAvatar.path);

    // ignore: unnecessary_null_comparison
    userAvatar != null
        ? Provider.of<LandingService>(context, listen: false)
            .showUserAvatar(context)
        // ignore: avoid_print
        : print('image upload error');
    notifyListeners();
  }

  Future selectAvatarOptionsSheet(BuildContext context) async {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                          color: constantColors.blueColor,
                          child: Text(
                            'Gallery',
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            pickUserAvatar(context, ImageSource.gallery)
                                .whenComplete(() {
                              Navigator.pop(context);
                              Provider.of<LandingService>(context,
                                      listen: false)
                                  .showUserAvatar(context);
                            });
                          }
                          ),
                          MaterialButton(
                          color: constantColors.blueColor,
                          child: Text(
                            'Camera',
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            pickUserAvatar(context, ImageSource.camera)
                                .whenComplete(() {
                              Navigator.pop(context);
                              Provider.of<LandingService>(context,
                                      listen: false)
                                  .showUserAvatar(context);
                            });
                          }
                          )
                    ],
                  )
                ],
              ),
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: constantColors.blueGreyColor,
                  borderRadius: BorderRadius.circular(12)));
        });
  }
}
