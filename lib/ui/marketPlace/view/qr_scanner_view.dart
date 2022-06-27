import 'dart:io';

import 'package:autoly_service/ui/marketPlace/view/qr_result_view.dart';
import 'package:autoly_service/utils/common_const.dart';
import 'package:autoly_service/utils/theme_const.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScannerView extends StatefulWidget {
  const QrScannerView({Key key}) : super(key: key);

  @override
  _QrScannerViewState createState() => _QrScannerViewState();
}

class _QrScannerViewState extends State<QrScannerView> {
  final qrKey = GlobalKey(debugLabel: "QR");
  QRViewController controller;
  Barcode barcode;
  bool qrDetected = false;

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  // This is needed for hot reload
  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await controller.pauseCamera();
    }

    controller.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    if (controller != null && mounted) {
      controller.pauseCamera();
      controller.resumeCamera();
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.center,
        children: [
          buildQrView(context),
          // barcode == null
          //     ? Container()
          //     : Positioned(bottom: 20, child: buildResult()),

          Positioned(
            top: 0,
            left: 15,
            right: 15,
            child: Container(
              height: size.height * 0.170,
              width: size.width,
              color: Colors.transparent,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    child: Container(
                      height: size.height * 0.150,
                      decoration: BoxDecoration(
                          color: ceruleanTwo,
                          border: Border.all(
                              color: Colors.white
                          ),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(
                                  (size.height * 0.150) * 0.2),
                              bottomLeft: Radius.circular(
                                  (size.height * 0.150) * 0.2))),
                    ),
                  ),

                  // Appbar title
                  Positioned(
                      top: (size.height * 0.170) * 0.2,
                      left: 10,
                      right: 10,
                      child: AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0.0,
                        centerTitle: true,
                        title: Text(
                          "Scan",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 21,
                              color: Colors.white),
                        ),
                      )),

                  Positioned(
                    top: (size.height * 0.170) * 0.55,
                    //left: 10,
                    right: 15,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(Icons.close, color: Colors.grey, size: 30,)),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildQrView(BuildContext context) =>
      QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderRadius: 10,
          borderColor: Colors.blue,
          borderWidth: 10,
          borderLength: 20,
          cutOutSize: MediaQuery
              .of(context)
              .size
              .width * 0.8,
        ),
      );

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    // call resumeCamera fucntion
    controller.resumeCamera();

    controller.scannedDataStream.listen((barcode) {
      this.barcode = barcode;
      print("code is ${barcode.code}");
      if (!qrDetected) {
        Navigator.of(context).pop(barcode.code);
        // Navigator.of(context).pop("62ab418ae8152");
        qrDetected = true;
        setState(() {});
      }
    });
  }

  Widget buildResult() =>
      Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white24,
        ),
        child: Column(
          children: [
            const Text(
              "To Complete the service ask customer to scan this qr code",
              // barcode != null ? "Result : ${barcode.code}" : "Scan a code!",
              maxLines: 3,
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(onPressed: () {}, child: const Text("Ask"))
          ],
        ),
      );
}
