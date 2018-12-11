import 'package:flutter/material.dart';


class FullNewsViewer extends StatefulWidget {
  final String _newsUrl;

  FullNewsViewer(this._newsUrl);

  _FullNewsViewerState createState() => _FullNewsViewerState();
}


class _FullNewsViewerState extends State<FullNewsViewer>{
  bool _isDownloaded = false;

  // TODO: add logic to download info
  @override
  Widget build(BuildContext context) {
    return _isDownloaded ? getScaffold() : getCircularProgress();
  }

  Widget getCircularProgress() {
    return CircularProgressIndicator(
      backgroundColor: Colors.green[700],
      strokeWidth: 3.0,
    );
  }

  Widget getScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Full news',
          softWrap: false,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[

          //HEAD IMAGE OF NEWS
          Container(
            padding: EdgeInsets.all(16.0),
            child: Image.network(
              'IMAGE URL',
              fit: BoxFit.fitWidth,
            ),
          ),

          // TEXT OF NEWS
          Container(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Text(
              'TEXT OF NEWS',
              softWrap: true,
              style: TextStyle(
                color: Colors.black,
                fontSize: 17.0,
              ),
            ),
          ),

          // CONTENT OF NEWS
          Container(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(

            ),
          ),
        ],
      ),
    );
  }
}