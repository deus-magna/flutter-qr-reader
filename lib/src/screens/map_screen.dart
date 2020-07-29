import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qrreaderapp/src/providers/db_provider.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  
  final MapController map = MapController();

  String mapType = 'streets';

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              map.move(scan.getLatLng(), 15);
            },
          )
        ],
      ),
      body: _buildFlutterMap(scan),
      floatingActionButton: _buildFloattingButton( context ),
    );
  }

  Widget _buildFlutterMap(ScanModel scan) {
    return FlutterMap(
      mapController: map,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 15,
      ),
      layers: [
        _buildMap(),
        _buildMarkers(scan),
      ],
    );
  }

  _buildMap() {
    return TileLayerOptions(
        urlTemplate: 'https://api.mapbox.com/v4/'
            '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
        additionalOptions: {
          'accessToken':
              'Your MAPBOX KEY HERE',
          'id': 'mapbox.$mapType' // streets, dark, light, outdoors, satellite
        });
  }

  _buildMarkers(ScanModel scan) {
    return MarkerLayerOptions(markers: <Marker>[
      Marker(
        height: 100.0,
        width: 100.0,
        point: scan.getLatLng(),
        builder: (context) => Container(
          child: Icon(
            Icons.location_on,
            size: 70.0,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    ]);
  }

  Widget _buildFloattingButton(BuildContext context) {
    return FloatingActionButton(onPressed: (){

      if (mapType == 'streets') {
        mapType = 'dark';
      } else if (mapType == 'dark') {
        mapType = 'light';
      } else if (mapType == 'light') {
        mapType = 'outdoors';
      } else if (mapType == 'outdoors') {
        mapType = 'satellite';
      }else {
        mapType = 'streets';
      }
      setState(() { });

    },
    child: Icon(Icons.repeat),
    backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
