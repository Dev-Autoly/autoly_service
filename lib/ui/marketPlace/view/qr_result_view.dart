import 'package:cached_network_image/cached_network_image.dart';
import 'package:autoly_service/ui/marketPlace/view/market_place_view.dart';
import 'package:autoly_service/ui/marketPlace/viewmodel/market_viewmodel.dart';
import 'package:autoly_service/utils/theme_const.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class QrResultView extends StatefulWidget {
  final String result;

  const QrResultView({Key key, @required this.result}) : super(key: key);

  @override
  _QrResultViewState createState() => _QrResultViewState();
}

class _QrResultViewState extends State<QrResultView> {
  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    var viewModelBuilder2 = ViewModelBuilder<MarketViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Scan Result'),
            centerTitle: true,
          ),
          body: model.checkingOrders
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
                      ),
                    ),
                  ),
                )
              : model.isQrCodeValid(widget.result)
                  ? Center(
                      //  child: Text("Invalid barcode"),
                      child: Text(
                        "This qr code is not valid",
                        style: TextStyle(fontSize: 20),
                      ),
                      // this service is not assigned to you => find nothing
                    )
                  : SafeArea(
                      child: Column(
                        children: [
                          Expanded(
                            child: model.allMatchingOrders.isEmpty
                                ? Center(
                                    //  child: Text("Invalid barcode"),
                                    child: Text(
                                      "This service is not assigned to you",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    // this service is not assigned to you => find nothing
                                  )
                                : ListView.builder(
                                    itemCount: model.allMatchingOrders.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                        child: Column(
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                    ),
                                                    width: screen.width * 0.85,
                                                    child: CachedNetworkImage(
                                                      imageUrl: model
                                                          .allMatchingOrders[
                                                              index]
                                                          .lineItems[0]
                                                          .image
                                                          .src,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 20.0),
                                                      child: Text(
                                                        model
                                                                .allMatchingOrders[
                                                                    index]
                                                                .lineItems[0]
                                                                .name
                                                                .toString() +
                                                            " " +
                                                            model
                                                                .allMatchingOrders[
                                                                    index]
                                                                .id
                                                                .toString(),
                                                        style: TextStyle(
                                                            fontSize: 21,
                                                            color: black),
                                                      ),
                                                    ),
                                                    Text(
                                                      model
                                                          .allMatchingOrders[
                                                              index]
                                                          .status
                                                          .toString()
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: model
                                                                      .allMatchingOrders[
                                                                          index]
                                                                      .status ==
                                                                  "pending"
                                                              ? red
                                                              : model.allMatchingOrders[index]
                                                                          .status ==
                                                                      "processing"
                                                                  ? Colors.blue
                                                                  : Colors.green),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            model.allMatchingOrders[index]
                                                            .status ==
                                                        "completed" ||
                                                    !model.filteringMatchingOrders(
                                                        model.allMatchingOrders[
                                                            index])
                                                ? Container()
                                                : model.updatingOrder
                                                    ? Center(
                                                        child: SizedBox(
                                                          height: 25,
                                                          width: 25,
                                                          child:
                                                              CircularProgressIndicator(
                                                            backgroundColor:
                                                                azure,
                                                          ),
                                                        ),
                                                      )
                                                    : InkWell(
                                                        onTap: () async {
                                                          model
                                                              .setCheckingOrders();
                                                          if (model
                                                                  .allMatchingOrders[
                                                                      index]
                                                                  .status ==
                                                              "pending") {
                                                            await model.updateOrderWithDio(
                                                                model
                                                                    .allMatchingOrders[
                                                                        index]
                                                                    .id,
                                                                OrderStatus
                                                                    .pending,
                                                                model.allMatchingOrders[
                                                                    index]);
                                                            await model
                                                                .initData(widget
                                                                    .result
                                                                    .trim());
                                                          } else {
                                                            await model.updateOrderWithDio(
                                                                model
                                                                    .allMatchingOrders[
                                                                        index]
                                                                    .id,
                                                                OrderStatus
                                                                    .processing,
                                                                model.allMatchingOrders[
                                                                    index]);
                                                            await model
                                                                .initData(widget
                                                                    .result
                                                                    .trim());
                                                          }
                                                        },
                                                        child: Container(
                                                          width: 300,
                                                          height: 50,
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                carnationPink,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            20)),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              model
                                                                          .allMatchingOrders[
                                                                              index]
                                                                          .status ==
                                                                      "pending"
                                                                  ? "Start the service"
                                                                  : model.allMatchingOrders[index]
                                                                              .status ==
                                                                          "processing"
                                                                      ? 'End the service'
                                                                      : "",
                                                              style: TextStyle(
                                                                  fontSize: 20),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                          ],
                                        ),
                                      );
                                    }),
                          ),
                        ],
                      ),
                    ),
        );
      },
      viewModelBuilder: () => MarketViewModel(),
      onModelReady: (model) => model.initData(widget.result.trim()),
    );
    return viewModelBuilder2;
  }
}
