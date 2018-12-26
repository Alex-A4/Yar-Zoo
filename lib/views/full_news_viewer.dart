import 'package:flutter/material.dart';
import 'package:flutter_yar_zoo/data_stores/full_news.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';


class FullNewsViewer extends StatefulWidget {
  final String _newsUrl;

  FullNewsViewer(this._newsUrl);

  _FullNewsViewerState createState() => _FullNewsViewerState();
}

// TODO: add slivers app bar
class _FullNewsViewerState extends State<FullNewsViewer>{
  Future<FullNews> _newsFuture;

  FullNews _fullNews;


  @override
  void initState() {
    super.initState();
    print(widget._newsUrl);
    _newsFuture = fetchFullNews(widget._newsUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getFutureBuilder(),
    );
  }

  Widget getFutureBuilder() {
    return FutureBuilder(
      future: _newsFuture,
      builder: (context, snapshot){
        //If data downloaded
        if (snapshot.hasData) {
          _fullNews = snapshot.data;
          return getListView();
        } else if (snapshot.hasError) {
          //If error occurred
          Fluttertoast.showToast(
            msg: 'Проверьте интернет соединение',
            textColor: Colors.white,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            timeInSecForIos: 2,
          );

          Navigator.pop(context);
        }

        //Default widget
        return getCircularProgress();
      },
    );
  }

  //Getting progress bar until downloading finish
  Widget getCircularProgress() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Соединение..'
        ),
      ),
      body: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.green[700],
          strokeWidth: 3.0,
        ),
      ),
    );
  }

  //Getting list view which contains content
  Widget getListView() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _fullNews.title,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: ListView(
        key: PageStorageKey('FullNewsKey'),
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: 20),
        children: <Widget>[
          //HEAD IMAGE OF NEWS
          Container(
            padding: EdgeInsets.all(16.0),
            child: Image.network(
              _fullNews.headerImageUrl,
              fit: BoxFit.fitWidth,
            ),
          ),

          // TEXT OF NEWS
          Container(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Text(
              _fullNews.text,
              softWrap: true,
              style: TextStyle(
                color: Colors.black,
                fontSize: 17.0,
              ),
            ),
          ),

          // CONTENT OF NEWS
          Column(
            children: _fullNews.imageUrls.map((link) =>
            new Padding(
              padding: EdgeInsets.only(left: 32, right: 32, top: 16),
              child: Image.network(
                link,
                fit: BoxFit.fitWidth,
              ),
            )
            ).toList(),
          ),
        ],
      ),
    );
  }



  ///Asynchronous fetching data from url
  /// and then parse data
  Future<FullNews> fetchFullNews(String url) async {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<String> imagesUrl = [];
      //Parsing data from page
      var titleAndImage = parse(response.body).getElementsByClassName('jbimage-link');
      var descr = parse(response.body).getElementsByClassName('element-textarea')[0].getElementsByTagName('p');
      var gallery = parse(response.body).getElementsByClassName('element-jbgallery');

      //Parsing gallery of photos if it is exist in a news
      if (gallery.length > 0) {
        gallery = gallery[0].getElementsByTagName('a');
        //Adding images to list
        for (int i = 0; i < gallery.length; i++)
          imagesUrl.add(gallery[i].attributes['href']);
      }

      var title = titleAndImage[0].attributes['title'];
      var image = titleAndImage[0].attributes['href'];

      //Building description
      String description = '';
      for (int i = 0; i < descr.length; i++) {
        description += descr[i].text + '\n';
      }

      FullNews news = new FullNews(image,title,description,imagesUrl);
      return news;
    } else throw Exception('Проверьте интернет соединение');
  }
}
