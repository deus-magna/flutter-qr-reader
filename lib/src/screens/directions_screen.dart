import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/utils/utils.dart' as utils;

class DirectionsScreen extends StatelessWidget {

  final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {

    scansBloc.getScans();

    return StreamBuilder<List<ScanModel>>(
      stream: scansBloc.scansStreamHttp,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final scans = snapshot.data;

        if (scans.length == 0) {
          return Center(
            child: Text('No hay información'),
          );
        }

        // Dismissible es un widget que nos permite hacer un swipe de una celda
        // para poder realizar una accion, en este caso es una delete.
        return ListView.builder(
            itemCount: scans.length,
            itemBuilder: (context, i) => Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.red),
                  onDismissed: ( direction ) => scansBloc.deleteScan(scans[i].id),
                  child: ListTile(
                    onTap: () => utils.launchURL(context, scans[i]),
                    leading: Icon(Icons.map,
                        color: Theme.of(context).primaryColor),
                    title: Text(scans[i].valor),
                    subtitle: Text('ID: ${ scans[i].id }'),
                    trailing:
                        Icon(Icons.keyboard_arrow_right, color: Colors.grey),
                  ),
                ));
      },
    );
  }
}
