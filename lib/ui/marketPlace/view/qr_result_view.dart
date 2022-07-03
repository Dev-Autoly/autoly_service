import 'package:autoly_service/utils/common_const.dart';
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
   return ViewModelBuilder<MarketViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: oceanBlue,
          appBar: AppBar(
            backgroundColor: oceanBlue,
            title: const Text('Scan Result'),
            centerTitle: true,
            elevation: 0,
          ),
          body: model.checkingOrders
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
              : !model.isQrCodeValid(widget.result)
                  ? const Center(
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
                                ? const Center(
                                    //  child: Text("Invalid barcode"),
                                    child: Text(
                                      "This service is not exist",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    // this service is not assigned to you => find nothing
                                  )
                                : ListView.builder(
                                    itemCount: model.allMatchingOrders.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 5,
                                        ),
                                        decoration: const BoxDecoration(
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
                                                    height: 250,
                                                    decoration:
                                                        const BoxDecoration(
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
                                                      fit: BoxFit.contain,
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
                                                          vertical: 10.0),
                                                      child: Text(
                                                        model
                                                            .allMatchingOrders[
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
                                                      padding: const EdgeInsets.only(bottom: 8.0),
                                                      child: Text(
                                                        "Order Num : ${model.allMatchingOrders[index].id}",
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            color: white),
                                                      ),
                                                    ),
                                                    Text(
                                                      "${model.allMatchingOrders[index].status.toString().toUpperCase()}",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
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
                                                    ? const Center(
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
                                                                  "pending" ||
                                                              model.filteringMatchingOrdersWithZero(
                                                                  model.allMatchingOrders[
                                                                      index])) {
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
                                                              const BoxDecoration(
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
                                                              model.allMatchingOrders[index].status ==
                                                                          "pending" ||
                                                                      model.filteringMatchingOrdersWithZero(
                                                                          model.allMatchingOrders[
                                                                              index])
                                                                  ? "Start the service"
                                                                  : model.allMatchingOrders[index]
                                                                              .status ==
                                                                          "processing"
                                                                      ? 'End the service'
                                                                      : "",
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          20),
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
      //     body: model.checkingOrders || model.updatingOrder
      //         ? Container(
      //             height: screen.height,
      //             width: screen.width,
      //             decoration: const BoxDecoration(color: oceanBlue),
      //             child: const Center(
      //               child: SizedBox(
      //                 height: 25,
      //                 width: 25,
      //                 child: CircularProgressIndicator(
      //                   backgroundColor: azure,
      //                   color: Colors.white,
      //                 ),
      //               ),
      //             ),
      //           )
      //         : !model.isQrCodeValid(widget.result)
      //             ? const Center(
      //                 //  child: Text("Invalid barcode"),
      //                 child: Text(
      //                   "This qr code is not valid",
      //                   style: TextStyle(fontSize: 20),
      //                 ),
      //                 // this service is not assigned to you => find nothing
      //               )
      //             : SafeArea(
      //                 child: Column(
      //                   children: [
      //                     Expanded(
      //                       child: model.allMatchingOrders.isEmpty
      //                           ? const Center(
      //                               //  child: Text("Invalid barcode"),
      //                               child: Text(
      //                                 "This service is not exist",
      //                                 style: TextStyle(fontSize: 20),
      //                               ),
      //                               // this service is not assigned to you => find nothing
      //                             )
      //                           : ListView.builder(
      //                               itemCount: model.allMatchingOrders.length,
      //                               itemBuilder: (context, index) {
      //                                 return Padding(
      //                                   padding: const EdgeInsets.all(8.0),
      //                                   child: Container(
      //                                     height: 100,
      //                                     margin: const EdgeInsets.symmetric(
      //                                         horizontal: 10, vertical: 5),
      //                                     padding: const EdgeInsets.symmetric(
      //                                         horizontal: 15, vertical: 10),
      //                                     decoration: BoxDecoration(
      //                                         color: oceanBlueThree,
      //                                         border: Border.all(
      //                                           color: cerulean,
      //                                         ),
      //                                         borderRadius:
      //                                             const BorderRadius.all(
      //                                                 Radius.circular(20))),
      //                                     child: Row(
      //                                       mainAxisAlignment:
      //                                           MainAxisAlignment.start,
      //                                       children: [
      //                                         ClipRRect(
      //                                           borderRadius:
      //                                               const BorderRadius.all(
      //                                             Radius.circular(8),
      //                                           ),
      //                                           child: SizedBox(
      //                                             height: 70,
      //                                             width: 70,
      //                                             child: CachedNetworkImage(
      //                                               imageUrl: model
      //                                                   .allMatchingOrders[
      //                                                       index]
      //                                                   .lineItems[0]
      //                                                   .image
      //                                                   .src,
      //                                               fit: BoxFit.cover,
      //                                             ),
      //                                           ),
      //                                         ),
      //                                         const SizedBox(
      //                                           width: 10,
      //                                         ),
      //                                         Column(
      //                                           crossAxisAlignment:
      //                                               CrossAxisAlignment.start,
      //                                           children: [
      //                                             Padding(
      //                                               padding:
      //                                                   const EdgeInsets.only(
      //                                                       bottom: 8.0),
      //                                               child: Text(
      //                                                 model
      //                                                     .allMatchingOrders[
      //                                                         index]
      //                                                     .lineItems[0]
      //                                                     .name
      //                                                     .toString(),
      //                                                 style: const TextStyle(
      //                                                     fontSize: 21,
      //                                                     color: white),
      //                                               ),
      //                                             ),
      //                                             Padding(
      //                                               padding:
      //                                                   const EdgeInsets.only(
      //                                                       bottom: 6.0),
      //                                               child: Text(
      //                                                 "Order number: ${model.allMatchingOrders[index].id.toString().toUpperCase()}",
      //                                                 style: const TextStyle(
      //                                                     fontSize: 12,
      //                                                     fontWeight:
      //                                                         FontWeight.bold,
      //                                                     color: white),
      //                                               ),
      //                                             ),
      //                                             Row(
      //                                               mainAxisAlignment:
      //                                                   MainAxisAlignment
      //                                                       .spaceBetween,
      //                                               mainAxisSize:
      //                                                   MainAxisSize.min,
      //                                               children: [
      //                                                 Text(
      //                                                   model
      //                                                       .allMatchingOrders[
      //                                                           index]
      //                                                       .status
      //                                                       .toString()
      //                                                       .toUpperCase(),
      //                                                   style: TextStyle(
      //                                                       fontSize: 16,
      //                                                       fontWeight:
      //                                                           FontWeight.bold,
      //                                                       color: model
      //                                                                   .allMatchingOrders[
      //                                                                       index]
      //                                                                   .status ==
      //                                                               "pending"
      //                                                           ? sicklyYellow
      //                                                           : model.allMatchingOrders[index]
      //                                                                       .status ==
      //                                                                   "processing"
      //                                                               ? brightLightBlue
      //                                                               : weirdGreen),
      //                                                 ),
      //                                                 model
      //                                                                 .allMatchingOrders[
      //                                                                     index]
      //                                                                 .status ==
      //                                                             "completed" ||
      //                                                         !model.filteringMatchingOrders(
      //                                                             model.allMatchingOrders[
      //                                                                 index])
      //                                                     ? Container()
      //                                                     : model.updatingOrder
      //                                                         ? Container()
      //                                                         : InkWell(
      //                                                             onTap:
      //                                                                 () async {
      //                                                               model
      //                                                                   .setCheckingOrders();
      //                                                               if (model.allMatchingOrders[index].status ==
      //                                                                       "pending" ||
      //                                                                   model.filteringMatchingOrdersWithZero(
      //                                                                       model.allMatchingOrders[index])) {
      //                                                                 await model.updateOrderWithDio(
      //                                                                     model
      //                                                                         .allMatchingOrders[
      //                                                                             index]
      //                                                                         .id,
      //                                                                     OrderStatus
      //                                                                         .pending,
      //                                                                     model.allMatchingOrders[
      //                                                                         index]);
      //                                                                 await model.initData(widget
      //                                                                     .result
      //                                                                     .trim());
      //                                                               } else {
      //                                                                 await model.updateOrderWithDio(
      //                                                                     model
      //                                                                         .allMatchingOrders[
      //                                                                             index]
      //                                                                         .id,
      //                                                                     OrderStatus
      //                                                                         .processing,
      //                                                                     model.allMatchingOrders[
      //                                                                         index]);
      //                                                                 await model.initData(widget
      //                                                                     .result
      //                                                                     .trim());
      //                                                               }
      //                                                             },
      //                                                             child:
      //                                                                 Container(
      //                                                               width: 80
      //                                                                   .getWidth(),
      //                                                               height: 30
      //                                                                   .getHeight(),
      //                                                               decoration: const BoxDecoration(
      //                                                                   color:
      //                                                                       carnationPink,
      //                                                                   borderRadius:
      //                                                                       BorderRadius.all(Radius.circular(20))),
      //                                                               child:
      //                                                                   Center(
      //                                                                 child:
      //                                                                     Text(
      //                                                                   model.allMatchingOrders[index].status == "pending" ||
      //                                                                           model.filteringMatchingOrdersWithZero(model.allMatchingOrders[index])
      //                                                                       ? "Start"
      //                                                                       : model.allMatchingOrders[index].status == "processing"
      //                                                                           ? 'End'
      //                                                                           : "",
      //                                                                   style: const TextStyle(
      //                                                                       fontSize:
      //                                                                           20),
      //                                                                 ),
      //                                                               ),
      //                                                             ),
      //                                                           ),
      //                                               ],
      //                                             ),
      //                                           ],
      //                                         ),
      //                                       ],
      //                                     ),
      //                                   ),
      //                                 );
      //                               }),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //   );
      // },
      viewModelBuilder: () => MarketViewModel(),
      onModelReady: (model) => model.initData(widget.result.trim()),
    );
  }
}
