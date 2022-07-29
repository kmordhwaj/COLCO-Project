import 'package:colco_project/constants/constantcolors.dart';
import 'package:colco_project/screens/chatroom/chatroom.dart';
import 'package:colco_project/screens/feed/feed.dart';
import 'package:colco_project/screens/homepage/homepagehelpers.dart';
import 'package:colco_project/screens/profile/profile.dart';
import 'package:colco_project/services/firebaseoperations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ConstantColors constantColors = ConstantColors();
  final PageController homePageController = PageController();
  int pageIndex = 0;

  @override
  void initState() {
    Provider.of<FirebaseOperations>(context, listen: false)
        .initUserData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: constantColors.darkColor,
        body: PageView(
          controller: homePageController,
          children: [const FeedScreen(), const ChatRoom(), ProfileScreen()],
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (page) {
            setState(() {
              pageIndex = page;
            });
          },
        ),
        bottomNavigationBar:
            Provider.of<HomePageHelpers>(context, listen: false)
                .bottomNavBar(context, pageIndex, homePageController));
  }
}
