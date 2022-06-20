import 'dart:async';
import 'package:autoly_service/ui/marketPlace/view/login_api_view.dart';
import 'package:autoly_service/ui/marketPlace/view/market_place_view.dart';
import 'package:autoly_service/utils/common_const.dart';
import 'package:autoly_service/utils/image_selector.dart';
import 'package:autoly_service/utils/shared_preferences/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashApiView extends StatefulWidget {
  _SplashApiViewState createState() => _SplashApiViewState();
}

class _SplashApiViewState extends State<SplashApiView> {
  Image splashImage;
  bool _initalRun = true;

  @override
  void initState() {
    super.initState();
    splashImage = Image.asset(
      'assets/launcher/autoly_splash.png',
      fit: BoxFit.cover,
    );
    if (_initalRun) {
      _checkIsLogin();
      _initalRun = false;
    }
  }

  Future<Null> _checkIsLogin() async {
    var userData = await SharedPreferencesHelper.getValue("user");
    await Future.delayed(Duration(
      milliseconds: 3000,
    )).then((value) {
      if (userData != null) {
        // _authProvider.setCurrentUser(User.fromJson(userData));
        // Provider.of<ComplainsProvider>(context, listen: false)
        //     .getComplainTypesList();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (ctx) =>
                  MarketPlaceView(), //TabsView(),  // AnimatedTabsView(), //  TabsView(),
            ));
      } else
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (ctx) => LoginApiView())); // SigninView()));
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(splashImage.image, context);
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return ScreenUtilInit(
      designSize: Size(411.50, 876.57),
      builder: (context, child) => Scaffold(
        body: SizedBox(
          width: screen.width,
          height: screen.height,
          child: splashImage,
          // child: Image.asset(
          //   'assets/launcher/logo.png',
          //   fit: BoxFit.cover,
          // ),
        ),
      ),
    );
  }

  Widget buildHeaderTop() {
    Size screen = MediaQuery.of(context).size;
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
              bottom: 0,
              top: -140.getHeight(), // -120,
              left: -30.getWidth(), // -50,
              child: Container(
                child: Image.asset(
                  SPLASH_TOP,
                  width: screen.width * 0.7,
                  height: screen.height * 0.3,
                ),
              )),

          // Positioned(
          //   bottom: 0,
          //   left: -150,
          //   top: -150,
          //   child: Container(
          //     width: 400,
          //     decoration: BoxDecoration(
          //       color: dusk, // Color(0xffe6f5fa)
          //       shape: BoxShape.circle,
          //     ),
          //   ),
          // ),
          //
          // Positioned(
          //   bottom: 0,
          //   left: 80,
          //   top: 80,
          //   child: Container(
          //     width: 160,
          //     height: 160,
          //     decoration: BoxDecoration(
          //       color: Color(0x330d9ecc), // Color(0xff355b7b),
          //       shape: BoxShape.circle,
          //     ),
          //   ),
          // ),
          //
          // Positioned(
          //   bottom: 0,
          //   top: 140,
          //   left: 120,
          //   child: Container(
          //     width: 160,
          //     height: 140,
          //     decoration: BoxDecoration(
          //       color: Color(0x1a0d9ecc),
          //       shape: BoxShape.circle,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget buildHeaderBottom() {
    Size screen = MediaQuery.of(context).size;
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
              bottom: -70.getHeight(),
              right: -50.getWidth(),
              child: Container(
                child: Image.asset(
                  SPLASH_BOTTOM,
                  width: screen.width * 0.5,
                  height: screen.height * 0.25,
                ),
              )),

          // Positioned(
          //   top: 0,
          //   right: -50,
          //   bottom: -150,
          //   child: Container(
          //     width: 220,
          //     height: 220,
          //     decoration: BoxDecoration(
          //       color: dusk, // Color(0xffe6f5fa)
          //       shape: BoxShape.circle,
          //     ),
          //   ),
          // ),
          //
          // Positioned(
          //   bottom: -100,
          //   right: 40,
          //   top: 0,
          //   child: Container(
          //     width: 120,
          //     height: 120,
          //     decoration: BoxDecoration(
          //       color: Color(0x1a0d9ecc),
          //       shape: BoxShape.circle,
          //     ),
          //   ),
          // ),
          //
          // Positioned(
          //   bottom: -50,
          //   right: 70,
          //   top: 0,
          //   child: Container(
          //     width: 120,
          //     height: 120,
          //     decoration: BoxDecoration(
          //       color: Color(0x330d9ecc),
          //       shape: BoxShape.circle,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
