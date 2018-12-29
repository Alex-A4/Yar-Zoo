import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_yar_zoo/data_stores/manual_item.dart';
import 'package:flutter_yar_zoo/data_stores/manual_store.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;



/// Class describes main page of zoo manual
/// This page contains categories of animals
class ManualCategoryView extends StatefulWidget{
  ManualCategoryView({Key key}): super(key: key);

  _ManualCategoryViewState createState() => _ManualCategoryViewState();
}

class _ManualCategoryViewState extends State<ManualCategoryView> {
  Future<List<ManualItem>> _items;


  @override
  void initState() {
    super.initState();
    _items = fetchData();
  }

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
      body: FutureBuilder<List<ManualItem>>(
        future: _items,
        builder: (context, snapshot){
          //If downloading finished
          if (snapshot.hasData) {
            ManualStore.getStore().updateManual((snapshot.data));
//            _title = 'Новости';
            return GridView.builder(
              padding: EdgeInsets.only(top: 8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
              ),
              itemCount: ManualStore.getStore().items.length,
              itemBuilder: (BuildContext context, int pos){
                return ManualCategoryListItem(ManualStore.getStore().items[pos]);
              },
            );
          } else if (snapshot.hasError) {
            // If error occurred
            Fluttertoast.showToast(
              msg: snapshot.error.toString().replaceFirst('Exception: ', ''),
              textColor: Colors.white,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              timeInSecForIos: 2,
            );
//            _title = 'Ожидание сети..';
            return Text('WOW');
          }

          return Text('Downloading');
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

///Downloading items of manual and adding them to list
Future<List<ManualItem>> fetchData() async {
  //Checking connectivity
  var connectivityResult = await (new Connectivity().checkConnectivity());

  if (connectivityResult != ConnectivityResult.mobile
      && connectivityResult != ConnectivityResult.wifi)
    throw Exception('Отсутствует интернет соединение');


  //Getting data
  final response = await http.get('http://yar-zoo.ru/animals.html');

  if (response.statusCode == 200) {
    List<ManualItem> items = [];

    //Parsing data from page
    var elements = parse(response.body).getElementsByClassName('subcategory-image');

    for (int i = 0; i < elements.length; i++) {
      var body = elements[i].getElementsByTagName('a');

      String imageUrl = elements[i].getElementsByTagName('img')[0].attributes['src'];
      print(imageUrl);
      String description = body[0].attributes['title'];
      print(description);
      String pageUrl = 'http://yar-zoo.ru${body[0].attributes['href']}'; //.replaceFirst('<br/>', '\n')
      print(pageUrl);
      items.add(new ManualItem(imageUrl, description, pageUrl));
    }

    return items;
  } else throw Exception('Проверьте интернет соединение');
}