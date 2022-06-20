import 'dart:io';

import 'package:autoly_service/ui/marketPlace/view/qr_result_view.dart';
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
        ],
      ),
    );
  }

  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderRadius: 10,
          borderColor: Colors.blue,
          borderWidth: 10,
          borderLength: 20,
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
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
       // Navigator.of(context).pop(barcode.code);
        Navigator.of(context).pop("62ab418ae8152");
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => QrResultView(
        //               result: barcode.code,
        //             ))).whenComplete(() {
        //   setState(() {
        //     qrDetected = false;
        //   });
        // });
        //   MaterialPageRoute(builder: (context) => QrResultView(result: "62ab418ae8152",))).whenComplete(() {
        //   setState(() {
        //     qrDetected = false;
        //   });
        // });
        qrDetected = true;
        setState(() {});
      }
    });
  }

  Widget buildResult() => Container(
        margin: EdgeInsets.all(12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white24,
        ),
        child: Column(
          children: [
            Text(
              "To Complete the service ask customer to scan this qr code",
              // barcode != null ? "Result : ${barcode.code}" : "Scan a code!",
              maxLines: 3,
            ),
            SizedBox(
              height: 10,
            ),
            TextButton(onPressed: () {}, child: Text("Ask"))
          ],
        ),
      );
}
