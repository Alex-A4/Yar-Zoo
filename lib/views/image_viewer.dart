import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  final List<String> _imageUrl;
  final int _position;

  ImageViewer(this._imageUrl, this._position);

  //TODO: change displaying from 1 image to PageView
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(_imageUrl.length.toString()),
      ),

      body: Container(
        color: Colors.black,
        child: Center(
          child: Image.network(
            _imageUrl[_position],
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}