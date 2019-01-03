import 'package:flutter/material.dart';
import 'package:flutter_yar_zoo/data_stores/animals.dart';
import 'package:flutter_yar_zoo/data_stores/animals_category_data.dart';
import 'package:flutter_yar_zoo/widgets/downloading_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';


class AnimalsViewer extends StatefulWidget {
  final AnimalCategory  _category;

  AnimalsViewer(this._category);

  @override
  _AnimalsViewerState createState() => _AnimalsViewerState(_category);
}

class _AnimalsViewerState extends State<AnimalsViewer> {
  final AnimalCategory _category;

  Future<Animal> _data;


  @override
  void initState() {
    super.initState();
    _data = fetchData(_category.pageUrl);
  }

  _AnimalsViewerState(this._category);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return getListView(snapshot.data);
          } else if (snapshot.hasError) {
            showToast('Проверьте интернет соединение');

            // Close news if there is no connectivity
            Navigator.pop(context);
          }

          return getProgressBar();
        },
      ),
    );
  }


  Widget getListView(Animal animal) {
    return CustomScrollView(
        key: PageStorageKey("AnimalList"),
        slivers: <Widget>[
          //AppBar
          SliverAppBar(
            pinned: true,
            elevation: 3,
            title: Text(
              _category.title,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            expandedHeight: 250,
            //HEADER IMAGE
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                _category.imageUrl,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),

          //Content
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                // TEXT OF ANIMAL
                Container(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Text(
                    animal.description,
                    softWrap: true,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17.0,
                    ),
                  ),
                ),

                // CONTENT OF ANIMAL
                //Add tab here
              ],
            ),
          ),
        ],
    );
  }

  //Downloading data
  Future<Animal> fetchData(String pageUrl) async {
    final response = await http.get(pageUrl);

    if (response.statusCode == 200) {
      Map<String, String> tabItems = new Map();
      var textAreas = parse(response.body).getElementsByClassName('element-textarea');
      var itemRows = parse(response.body).getElementsByClassName('item-tabs')[0]
          .getElementsByTagName('ul')[0].getElementsByTagName('li');

      var descrP = textAreas[0].getElementsByTagName('p');
      String description = '';

      //Building description
      //Replace all tags to empty string
      for (int i = 0; i < descrP.length; i++)
        description += descrP[i].text.replaceAll('<\/?[\w]+>', '');

      //Building items of tab
      for (int i = 0; i < itemRows.length; i++) {
        String tabName = itemRows[i].getElementsByTagName('a')[0].text.trim();
        String tabText = textAreas[i+1].getElementsByTagName('p')[0].text;
        print('$tabName\n$tabText');

        tabItems['$tabName'] = tabText;
      }

      print(tabItems);
      return new Animal(description, tabItems);
    } else throw Exception('Проверьте интернет соединение');
  }
}