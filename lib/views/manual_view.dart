import 'package:flutter/material.dart';
import 'package:flutter_yar_zoo/data_stores/manual_item.dart';
import 'package:flutter_yar_zoo/data_stores/manual_store.dart';



/// Class describes main page of zoo manual
/// This page contains categories of animals
class ManualCategoryView extends StatefulWidget{
  ManualCategoryView({Key key}): super(key: key);

  _ManualCategoryViewState createState() => _ManualCategoryViewState();
}

class _ManualCategoryViewState extends State<ManualCategoryView> {

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
      body: GridView.builder(
        padding: EdgeInsets.only(top: 8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
        ),
        itemCount: ManualStore.getStore().items.length,
        itemBuilder: (BuildContext context, int pos){
          return ManualCategoryListItem(ManualStore.getStore().items[pos]);
        },
      ),
    );
  }
}


/// One item of list from manual
class ManualCategoryListItem extends StatelessWidget {
  final ManualItem _item;

  ManualCategoryListItem(this._item);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // TODO: add logic to launch page with full info about category of animals
      onTap: (){
      },

      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        elevation: 5.0,

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
              _item.description,
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
      ),
    );
  }

}