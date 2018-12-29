import 'package:flutter/material.dart';
import 'package:flutter_yar_zoo/views/image_viewer.dart';



class ClickableImage extends StatelessWidget {
  final String _imageUrl;

  ClickableImage(this._imageUrl);

  //TODO: change logic of storing data
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => ImageViewer([_imageUrl], 0),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Image.network(
          _imageUrl,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}