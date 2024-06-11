import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var urlBase = "https://api.daveget.tech/api";

  var attendanceStatus = "";
  void sendQRToAPI(code) async {
    final dio = Dio();
    var response = await dio.post(
      "$urlBase/Laborers/QRCode?QRCode=$code",
      data: "",
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      attendanceStatus = response.data;
      print(response);
    } else {
      print(response);
    }
  }

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen(
      (scanData) {
        setState(() {
          result = scanData;
        });
        print(result?.code);
        if (result?.code?.isNotEmpty == true) {
          sendQRToAPI(result?.code);
        }
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.calendar_month),
        title: const Text(
          "Attendance Scanner",
        ),
        actions: [
          IconButton(
            onPressed: () {
              controller!.pauseCamera();
            },
            icon: const Icon(
              Icons.stop_outlined,
            ),
          ),
          IconButton(
            onPressed: () {
              controller!.resumeCamera();
            },
            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 5.0, bottom: 15.0),
            child: Text(
              "Scan an Employee's QR Code to sign attendance.",
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
              ),
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  formatsAllowed: const [BarcodeFormat.qrcode],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 28.0,
                            bottom: 10.0,
                          ),
                          child: Text(
                            'Employee QRCode: ${result!.code}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 5.0,
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.greenAccent,
                          ),
                          child: Text(
                            attendanceStatus.toString(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )
                  : const Text("Employee QRCode Will Show Down Here"),
            ),
          ),
        ],
      ),
    );
  }
}
