import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  final List<String> _imageUrl;

  ImageViewer(this._imageUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(_imageUrl.length.toString()),
      ),

      body: Container(
        color: Colors.black,
        child: Center(
          child: Image.network(
            _imageUrl[0],
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}