import 'package:autoly_service/ui/marketPlace/model/order.dart';
import 'package:autoly_service/ui/marketPlace/viewmodel/market_viewmodel.dart';
import 'package:autoly_service/utils/theme_const.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class OrderDetailsView extends StatefulWidget {
  final Order order;
  final bool isMine;

  const OrderDetailsView({Key key, this.order, this.isMine}) : super(key: key);

  @override
  _OrderDetailsViewState createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends State<OrderDetailsView> {
  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return ViewModelBuilder<MarketViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: oceanBlue,
          appBar: AppBar(
            backgroundColor: oceanBlue,
            title: const Text('Order Details'),
            centerTitle: true,
            elevation: 0,
          ),
          body: model.updatingOrder
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: 250,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              width: screen.width * 0.85,
                              child: CachedNetworkImage(
                                imageUrl: widget.order.lineItems[0].image.src,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            widget.order.lineItems[0].name.toString(),
                            style: const TextStyle(fontSize: 21, color: white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            "Order Num : ${widget.order.id}",
                            style: const TextStyle(fontSize: 16, color: white),
                          ),
                        ),
                        Text(
                          "${widget.order.status.toString().toUpperCase()}",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: widget.order.status == "pending"
                                  ? sicklyYellow
                                  : widget.order.status == "processing"
                                      ? brightLightBlue
                                      : weirdGreen),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        widget.order.status == "completed" || !widget.isMine
                            ? Container()
                            : InkWell(
                                onTap: () async {
                                  model.setCheckingOrders();
                                  if (widget.order.status == "pending" ||
                                      model.filteringMatchingOrdersWithZero(
                                          widget.order)) {
                                    await model.updateOrderWithDio(
                                        widget.order.id,
                                        OrderStatus.pending,
                                        widget.order);
                                    Navigator.of(context).pop();
                                    // await model
                                    //     .initData(widget.`result.trim());
                                  } else {
                                    await model.updateOrderWithDio(
                                        widget.order.id,
                                        OrderStatus.processing,
                                        widget.order);
                                    Navigator.of(context).pop();
                                    // await model
                                    //     .initData(widget.result.trim());
                                  }
                                },
                                child: Container(
                                  width: 300,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    color: carnationPink,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      widget.order.status == "pending" ||
                                              model
                                                  .filteringMatchingOrdersWithZero(
                                                      widget.order)
                                          ? "Start the service"
                                          : widget.order.status == "processing"
                                              ? 'End the service'
                                              : "",
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                      ]),
                ),
        );
      },
      viewModelBuilder: () => MarketViewModel(),
      onModelReady: (model) => model.initShared(),
    );
  }
}
