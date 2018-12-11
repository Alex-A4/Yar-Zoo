import 'package:flutter/material.dart';



/// Class describes main page of zoo manual
/// This page contains categories of animals
class ManualCategoryView extends StatefulWidget{
  ManualCategoryView({Key key}): super(key: key);

  _ManualCategoryViewState createState() => _ManualCategoryViewState();
}

class _ManualCategoryViewState extends State<ManualCategoryView> {
  // List of manuals items
  List<ManualCategoryItem> _items = [new ManualCategoryItem('http://yar-zoo.ru/media/zoo/images/1_eed4da7fb73b9e64cff6542489251cfc.png', '','Млекопитающие\nMammal'),
  new ManualCategoryItem('http://yar-zoo.ru/media/zoo/images/2_f730f226f853bc48e21a2ab1f6a15320.png', '', 'Птицы\nAves')];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          child: Image(image: AssetImage('assets/logo.png'),),
          padding: EdgeInsets.only(left:10.0, top:5.0, bottom: 5.0),
        ),
        title: Text('Справочник'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(top: 8.0),
        itemCount: _items.length,
        itemBuilder: (BuildContext context, int pos){
          return ManualCategoryListItem(_items[pos]);
        },
      ),
    );
  }
}


/// One item of list from manual
class ManualCategoryListItem extends StatelessWidget {
  final ManualCategoryItem _item;

  ManualCategoryListItem(this._item);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // TODO: add logic to start page with full info about manuals
      onTap: (){
      },

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //Image of manual
          Image.network(
            _item.imageUrl,
            width: 200.0,
            fit: BoxFit.fitWidth,
          ),

          //Description of manual
          Text(
            _item._description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
            ),
          ),

          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

}


/// Class describes one element of manual
class ManualCategoryItem {
  final String _imageUrl;
  final String _pageUrl;
  final String _description;

  ManualCategoryItem(this._imageUrl, this._pageUrl, this._description);

  String get description => _description;

  String get pageUrl => _pageUrl;

  String get imageUrl => _imageUrl;
}