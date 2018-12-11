import 'package:flutter/material.dart';



class ClickableImage extends StatelessWidget {
  final String _imageUrl;
  final double _width;

  ClickableImage(this._imageUrl, this._width);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // TODO: add logic to start image-viewer
      onTap: (){
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Image.network(
          _imageUrl,
          fit: BoxFit.fitWidth,
          width: _width,
        ),
      ),
    );
  }
}