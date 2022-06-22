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
          backgroundColor: white,
          appBar: AppBar(
            leading: Container(),
            title: const Text('Home'),
            centerTitle: true,
            actions: [
              GestureDetector(
                onTap: () async {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (ctx) => LoginApiView()),
                      (Route<dynamic> route) => false);
                  SharedPreferencesHelper.remove("user");
                },
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.logout, size: 25, color: white)),
              ),
              GestureDetector(
                onTap: () async {
                  // model.setLoading();
                  model.changeBusyState(true);
                  await model.resetOrder(384);
                  await model.getAllOrders("");
                },
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.repeat, size: 25, color: white)),
              ),
            ],
          ),
          body: model.isBusy
              ? Container(
                  height: screen.height,
                  width: screen.width,
                  decoration: BoxDecoration(color: white),
                  child: Center(
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
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: model.filteredOrdersWithServiceProvider.isEmpty
                            ? Center(
                                child: Text("No record found"),
                              )
                            : ListView.builder(
                                itemCount: model
                                    .filteredOrdersWithServiceProvider.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      child: Container(
                                        height: 50,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 50,
                                              width: 50,
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
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  model
                                                      .filteredOrdersWithServiceProvider[
                                                          index]
                                                      .lineItems[0]
                                                      .name
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 21,
                                                      color: black),
                                                ),
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
                                                          FontWeight.bold,
                                                      color: model
                                                                  .filteredOrdersWithServiceProvider[
                                                                      index]
                                                                  .status ==
                                                              "pending"
                                                          ? red
                                                          : model
                                                                      .filteredOrdersWithServiceProvider[
                                                                          index]
                                                                      .status ==
                                                                  "processing"
                                                              ? Colors.blue
                                                              : Colors.green),
                                                ),
                                              ],
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
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              // model.updateOrder(384, OrderStatus.pending);
              String txt = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QrScannerView()),
              );
              if(txt != null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QrResultView(result: txt)))
                    .whenComplete(
                      () async {
                    model.changeBusyState(true);
                    await model.getAllOrders("");
                  },
                );
              }else {
                Fluttertoast.showToast(msg: "Please try again, we could't recgonize qr code", textColor: white, backgroundColor: red);
              }
            },
            child: Text("Scan"),
          ),
        );
      },
      viewModelBuilder: () => MarketViewModel(),
      onModelReady: (model) => model.initData("ghjkjkf"),
    );
  }
}
