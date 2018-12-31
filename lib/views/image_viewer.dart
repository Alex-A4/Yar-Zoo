import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  final List<String> _imageUrl;
  final int _position;

  ImageViewer(this._imageUrl, this._position);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: PageView.builder(
        itemCount: _imageUrl.length,
        controller: PageController(
          initialPage: _position,
        ),
        itemBuilder: (context, pos) {
          return Container(
            color: Colors.black,
            child: Center(
              child: Image.network(
                _imageUrl[pos],
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
    );
  }
}