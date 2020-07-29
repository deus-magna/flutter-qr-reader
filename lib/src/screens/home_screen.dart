import 'dart:io';

import 'package:flutter/material.dart';

import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/screens/directions_screen.dart';
import 'package:qrreaderapp/src/screens/maps_screen.dart';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:qrreaderapp/src/utils/utils.dart' as utils;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final scansBloc = new ScansBloc();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: scansBloc.deleteAllScans,
          )
        ],
        title: Text(
          'QR Scanner'
        ),
      ),
      body: _callScreen(currentIndex),
      bottomNavigationBar: _buildBottomNavigatioBar(),
      floatingActionButton: _buildFloattingActionBottom(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _callScreen(int currentScreen){

    switch (currentScreen) {
      case 0: return MapsScreen();
      case 1: return DirectionsScreen();
      default: return MapsScreen();
    }
  }

  Widget _buildBottomNavigatioBar() {

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
           currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapas')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title: Text('Direcciones')
        )
      ]
    );
  }

  Widget _buildFloattingActionBottom() {
    return FloatingActionButton(
      child: Icon(Icons.filter_center_focus),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () => _scanQR(context),
    );
  }

  _scanQR(BuildContext context) async {

    // https://fernando-herrera.com
    // geo:40.7356804248455,-73.8947047277344
    String futureString; // = 'https://fernando-herrera.com';

    try {
      futureString = await BarcodeScanner.scan();
    } catch (e) {
      futureString = e.toString(); 
    }
    
    if (futureString != null) {

      final scan = ScanModel( valor: futureString);
      scansBloc.addScan(scan);

      // final scan2 = ScanModel( valor: 'geo:40.7356804248455,-73.8947047277344');
      // scansBloc.addScan(scan2);


      if (Platform.isIOS) {
        Future.delayed( Duration( milliseconds: 750) , () {
           utils.launchURL(context, scan);
        });
      } else {
         utils.launchURL(context, scan);
      }
    }
    
  }
}