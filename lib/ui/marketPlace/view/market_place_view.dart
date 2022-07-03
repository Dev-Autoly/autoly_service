import 'package:autoly_service/ui/marketPlace/view/order_details_view.dart';
import 'package:autoly_service/utils/image_selector.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:autoly_service/ui/marketPlace/view/login_api_view.dart';
import 'package:autoly_service/ui/marketPlace/view/qr_result_view.dart';
import 'package:autoly_service/ui/marketPlace/view/qr_scanner_view.dart';
import 'package:autoly_service/ui/marketPlace/viewmodel/market_viewmodel.dart';
import 'package:autoly_service/utils/common_const.dart';
import 'package:autoly_service/utils/shared_preferences/shared_preferences_helper.dart';
import 'package:autoly_service/utils/theme_const.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';

class MarketPlaceView extends StatefulWidget {
  const MarketPlaceView({Key key}) : super(key: key);

  @override
  _MarketPlaceViewState createState() => _MarketPlaceViewState();
}

class _MarketPlaceViewState extends State<MarketPlaceView> {
  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return ViewModelBuilder<MarketViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: oceanBlue,
          appBar: AppBar(
            backgroundColor: oceanBlue,
            leading: Container(),
            title: const Text(
              'Home',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 21,
                  color: Colors.white),
            ),
            centerTitle: true,
            elevation: 0,
            actions: [
              GestureDetector(
                onTap: () async {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (ctx) => const LoginApiView()),
                      (Route<dynamic> route) => false);
                  SharedPreferencesHelper.remove("user");
                },
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: const [
                        Text(
                          "Logout",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.grey),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(Icons.logout, size: 21, color: Colors.grey),
                      ],
                    )),
              ),
              // GestureDetector(
              //   onTap: () async {
              //     // model.setLoading();
              //     model.changeBusyState(true);
              //     await model.resetOrder(384);
              //     await model.getAllOrders("");
              //   },
              //   child: Padding(
              //       padding: EdgeInsets.symmetric(horizontal: 8),
              //       child: Icon(Icons.repeat, size: 25, color: white)),
              // ),
            ],
          ),
          body: model.isBusy
              ? Container(
                  height: screen.height,
                  width: screen.width,
                  decoration: const BoxDecoration(color: oceanBlue),
                  child: const Center(
                    child: SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(
                        backgroundColor: azure,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          String txt = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const QrScannerView()),
                          );
                          if (txt != null) {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            QrResultView(result: txt)))
                                .whenComplete(
                              () async {
                                model.changeBusyState(true);
                                await model.getAllOrders("");
                              },
                            );
                          } else {}
                        },
                        child: Center(
                          child: Container(
                            width: 300.getWidth(),
                            height: 150,
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                    begin: Alignment(0.5, 0),
                                    end: Alignment(0.5, 1),
                                    colors: [waterBlue, ceruleanTwo]),
                                border: Border.all(color: brightCyan, width: 1),
                                borderRadius: BorderRadius.circular(25)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 15),
                                  child: Image.asset(
                                    pickCamera,
                                    width: 100.getWidth(),
                                  ),
                                ),
                                const Text(
                                  "Scan",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 21,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      model.filteredOrdersWithServiceProvider.isEmpty
                          ? Container()
                          : Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: const Text("List Of Orders",
                                  style: TextStyle(
                                      color: white,
                                      // dusk,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Poppins",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 21.0),
                                  textAlign: TextAlign.left),
                            ),
                      Expanded(
                        child: model.filteredOrdersWithServiceProvider.isEmpty
                            ? const Center(
                                child: Text(
                                  "No orders found",
                                  style: const TextStyle(
                                      fontSize: 21, color: white),
                                ),
                              )
                            : ListView.builder(
                                itemCount: model
                                    .filteredOrdersWithServiceProvider.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => OrderDetailsView(
                                                isMine: model.filteringMatchingOrders(model.filteredOrdersWithServiceProvider[index]),
                                                  order: model
                                                          .filteredOrdersWithServiceProvider[
                                                      index]))).whenComplete(
                                        () async {
                                          model.changeBusyState(true);
                                          await model.getAllOrders("");
                                        },
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 100,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                        decoration: BoxDecoration(
                                            color: oceanBlueThree,
                                            border: Border.all(
                                              color: cerulean,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20))),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: SizedBox(
                                                height: 70,
                                                width: 70,
                                                child: CachedNetworkImage(
                                                  imageUrl: model
                                                      .filteredOrdersWithServiceProvider[
                                                          index]
                                                      .lineItems[0]
                                                      .image
                                                      .src,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 8.0),
                                                    child: Text(
                                                      model
                                                          .filteredOrdersWithServiceProvider[
                                                              index]
                                                          .lineItems[0]
                                                          .name
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 21,
                                                          color: white),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 6.0),
                                                    child: Text(
                                                      "Order number: ${model.filteredOrdersWithServiceProvider[index].id.toString().toUpperCase()}",
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: white),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    // color: white,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                          model
                                                              .filteredOrdersWithServiceProvider[
                                                                  index]
                                                              .status
                                                              .toString()
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: model
                                                                          .filteredOrdersWithServiceProvider[
                                                                              index]
                                                                          .status ==
                                                                      "pending"
                                                                  ? sicklyYellow
                                                                  : model.filteredOrdersWithServiceProvider[index]
                                                                              .status ==
                                                                          "processing"
                                                                      ? brightLightBlue
                                                                      : weirdGreen),
                                                        ),
                                                        model.filteredOrdersWithServiceProvider[index]
                                                                    .status ==
                                                                "completed"
                                                            ? Container()
                                                            : InkWell(
                                                                onTap:
                                                                    () async {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => OrderDetailsView(
                                                                                  isMine: model.filteringMatchingOrders(model.filteredOrdersWithServiceProvider[index]),
                                                                                  order: model
                                                                                      .filteredOrdersWithServiceProvider[
                                                                                  index]))).whenComplete(
                                                                            () async {
                                                                          model.changeBusyState(true);
                                                                          await model.getAllOrders("");
                                                                        },
                                                                      );
                                                                  // model
                                                                  //     .changeBusyState(
                                                                  //         true);
                                                                  // if (model.filteredOrdersWithServiceProvider[index].status ==
                                                                  //         "pending" ||
                                                                  //     model.filteringMatchingOrdersWithZero(
                                                                  //         model.filteredOrdersWithServiceProvider[
                                                                  //             index])) {
                                                                  //   await model.updateOrderWithDio(
                                                                  //       model
                                                                  //           .filteredOrdersWithServiceProvider[
                                                                  //               index]
                                                                  //           .id,
                                                                  //       OrderStatus
                                                                  //           .pending,
                                                                  //       model.filteredOrdersWithServiceProvider[
                                                                  //           index]);
                                                                  //   await model
                                                                  //       .getAllOrders(
                                                                  //           "");
                                                                  // } else {
                                                                  //   await model.updateOrderWithDio(
                                                                  //       model
                                                                  //           .filteredOrdersWithServiceProvider[
                                                                  //               index]
                                                                  //           .id,
                                                                  //       OrderStatus
                                                                  //           .processing,
                                                                  //       model.filteredOrdersWithServiceProvider[
                                                                  //           index]);
                                                                  //   await model
                                                                  //       .getAllOrders(
                                                                  //           "");
                                                                  // }
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 80
                                                                      .getWidth(),
                                                                  height: 30
                                                                      .getHeight(),
                                                                  decoration: const BoxDecoration(
                                                                      color:
                                                                          carnationPink,
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(20))),
                                                                  child: Center(
                                                                      child:
                                                                          Text(
                                                                    model.filteredOrdersWithServiceProvider[index].status ==
                                                                                "pending" ||
                                                                            model.filteringMatchingOrdersWithZero(model.filteredOrdersWithServiceProvider[
                                                                                index])
                                                                        ? "START"
                                                                        : model.filteredOrdersWithServiceProvider[index].status ==
                                                                                "processing"
                                                                            ? 'END'
                                                                            : "",
                                                                    style: const TextStyle(
                                                                        color:
                                                                            white,
                                                                        fontSize:
                                                                            16.0),
                                                                  )),
                                                                ),
                                                              ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                      ),
                    ],
                  ),
                ),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () async {
          //     // model.updateOrder(384, OrderStatus.pending);
          //     String txt = await Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => const QrScannerView()),
          //     );
          //     if (txt != null) {
          //       Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                   builder: (context) => QrResultView(result: txt)))
          //           .whenComplete(
          //         () async {
          //           model.changeBusyState(true);
          //           await model.getAllOrders("");
          //         },
          //       );
          //     } else {
          //       Fluttertoast.showToast(
          //           msg: "Please try again, we could't recgonize qr code",
          //           textColor: white,
          //           backgroundColor: red);
          //     }
          //   },
          //   child: const Text("Scan"),
          // ),
        );
      },
      viewModelBuilder: () => MarketViewModel(),
      onModelReady: (model) => model.initData(""),
    );
  }
}
