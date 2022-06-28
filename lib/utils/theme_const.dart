import 'package:autoly_service/utils/common_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const color1 = Color(0xff2e668f);
const logoColor = Color(0xff28A1FF);
const greenColor = Color(0xff97c047);
const white = const Color(0xffffffff);
const niceBlue = const Color(0xff187b9f);
const brownGrey = const Color(0xff999999);
const black = const Color(0xff000000);
const yellowOrange = const Color(0xffea9800);
const lightOliveGreen = const Color(0xff97c047);
const candyPink = const Color(0xffff69f9);
const sunYellow = const Color(0xfffad925);
const orangeyRed = const Color(0xffff2727);
const ice = const Color(0xffeaebeb);
const vividPurple = const Color(0xff8e00f7);
const dusk = const Color(0xff404a66);
const waterBlue = const Color(0xff0d9ecc);
const offYellow = const Color(0xffd6ed40);
const darkGreyBlue = const Color(0xff323a52);
const darkGreyGreen = const Color(0xff074F66);
const darkBlue = const Color(0xff16253C);
const darkGray = const Color(0xff5C5C5C);
const warmGrey = const Color(0xff707070);
const water = const Color(0xff22FEFF);
const waterBlueTwo = const Color(0xff0fa2cf);
const red = const Color(0xffe80000);
const duskTwo = const Color(0xff404a69);
const robinsEggBlue = const Color(0xff98dcf2);
const brownishGrey = const Color(0xff5c5c5c);
const whiteTwo = const Color(0xfff7f7f7);
const brightYellow = const Color(0xfffff200);
const blueColor = Color(0xff03a0e6);
const mediumPink = const Color(0xffeb6691);
const cerulean = const Color(0xff009ada);
const azure = const Color(0xff03a0e6);
const ceruleanTwo = const Color(0xff008dcc);
const pinkish = const Color(0xffdb6f91);
const lipstick = const Color(0xffe22058);
const greenishTealTwo = const Color(0xff2ecc70);

const redTwo = const Color(0xffc40101);
const pinkishGrey = const Color(0xffbebebe);
const whiteThree = const Color(0xffe3e3e3);
const warmGreyTwo = const Color(0xff959595);
const sunYellowTwo = const Color(0xffffe62d);
const greenishTeal = const Color(0xff2fcc70);
const greyish = const Color(0xffb5b5b5);
const robinEggBlue = const Color(0xff8be5ff);
const pumpkinOrange = const Color(0xffff7f23);
const cherryRed = const Color(0xffeb0a1e);
const slateGrey = const Color(0xff565a6d);
const goldenYellow = const Color(0xffffc418);
const charcoalGrey = const Color(0xff3f4252);
const steel = const Color(0xff8c8e99);
const darkPeach = const Color(0xffd7876a);
const cocoa = const Color(0xff8b4539);
const darkSeaGreen = const Color(0xff11954a);
const greyBlue = const Color(0xff65a0a8);
const coolBlue = const Color(0xff438ab7);
const jadeGreen = const Color(0xff28ac61);
const deepSeaBlue = const Color(0xff005981);
const deepSeaBlueTwo = const Color(0xff025174);
const wintergreen = const Color(0xff32fa85);
const whiteFour = const Color(0xffd9d9d9);
const brownishPink = const Color(0xffbf7870);
const peacockBlue = const Color(0xff016592);
const brownishPinkTwo = const Color(0xffc6877f);
const darkSlateBlue = const Color(0xff194662);
const mediumPinkTwo = const Color(0xffec6792);
const oceanBlue = const Color(0xff0172a5);
const oceanBlueTwo = const Color(0xff046a98);
const cocoaTwo = const Color(0xff964b41);
const silver = const Color(0xffc7cfd1);
const carnation = const Color(0xfffb739f);
const lightNavyBlue = const Color(0xff275a7a);
const robinsEggTwo = const Color(0xff73e0ff);
const azureTwo = const Color(0xff0ba8ef);
const brightSkyBlue = const Color(0xff00b0ff);
const oceanBlueThree = const Color(0xff0074a8);
const lipstickTwo = const Color(0xffe62552);
const orangeYellow = const Color(0xffffb100);
const ceruleanThree = const Color(0xff0071bc);
const greyishBrown = const Color(0xff534741);
const butterscotch = const Color(0xfffbb03b);
const putty = const Color(0xffc7b299);
const fadedRed = const Color(0xffc1272d);
const oceanBlueFour = const Color(0xff0574a5);
const blackTwo = const Color(0xff303030);
const peacockBlueTwo = const Color(0xff006b96);
const macaroniAndCheese = const Color(0xfff0ba27);
const azureThree = const Color(0xff2fb5f2);
const robinsEgg = const Color(0xff62dafc);
const warmGreyThree = const Color(0xff848484);
const azureFour = const Color(0xff1a9dfd);
const orangeRed = const Color(0xffff3e30);
const denimBlue = const Color(0xff3b5998);
const azureFive = const Color(0xff08a0e9);
const warmGreyFour = const Color(0xff939393);
const carnationPink = const Color(0xffff77a3);
const robinsEggThree = const Color(0xff74e0ff);
const slate = const Color(0xff545c75);
const uglyBlue = const Color(0xff2b6a92);
const orangeYello = const Color(0xffffb100);
const brightCyan = Color(0xff46f8ff);
const weirdGreen = Color(0xff2be161);
const brightLightBlue = Color(0xff31ceff);
const sicklyYellow = Color(0xffd6e047);
const paleGrey = Color(0xffdde1e6);

Widget buildHeaderWithImage(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  return Container(
    height: 260.getHeight(),
    width: double.infinity,
    child: Stack(
      children: [
        // *** 60% lighter color of primaray
        Positioned(
          bottom: 0,
          left: -20,
          top: -180,
          child: Container(
            width: 320,
            height: 240,
            decoration: BoxDecoration(
              color: Color(0xffe6f5fa),
              shape: BoxShape.circle,
            ),
          ),
        ),

        // *** 20%  darker color of primaray
        Positioned(
          bottom: 0,
          left: -20,
          top: -170,
          child: Container(
            width: 300,
            height: 220,
            decoration: BoxDecoration(
              color: Color(0xff355b7b),
              shape: BoxShape.circle,
            ),
          ),
        ),

        // **** primary Color ****//
        Positioned(
          bottom: 0,
          left: -20,
          top: -150,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              color: dusk, // Color(0xffe6f5fa)
              shape: BoxShape.circle,
            ),
          ),
        ),

        // Positioned(
        //   left: 40,
        //   top: 50,
        //   child: Container(
        //     width: 200.getWidth(), // double.infinity,
        //     height: 80.getHeight(),
        //     margin: EdgeInsets.only(top: 10.getHeight()),
        //     child: Image.asset(
        //       'assets/images/profile/login_title.png',
        //       color: white,
        //     ),
        //   ),
        // ),
      ],
    ),
  );
}


