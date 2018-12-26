import 'package:flutter/material.dart';
import 'package:flutter_yar_zoo/data_stores/full_news.dart';
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
    return FutureBuilder(
      future: _newsFuture,
      builder: (context, snapshot){
        //If data downloaded
        if (snapshot.hasData) {
          _fullNews = snapshot.data;
          return getScaffold();
        } else if (snapshot.hasError) {
          //If error occurred
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('Проверьте интернет соединение'), backgroundColor: Colors.red,),
          );
          Navigator.pop(context);
        }

        //Default widget
        return getCircularProgress();
      },
    );
  }

  Widget getCircularProgress() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Соединение..'),
      ),
      body: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.green[700],
          strokeWidth: 3.0,
        ),
      ),
    );
  }

  Widget getScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _fullNews.title,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: getListView(),
    );
  }

  //Getting list view which contains content
  Widget getListView() {
    return ListView(
      shrinkWrap: true,
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
        Container(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(

          ),
        ),
      ],
    );
  }

  Future<FullNews> fetchFullNews(String url) async {
    final response = await http.get(url);

    if (response.statusCode == 200) {

      //Parsing data from page
      var dateParse = parse(response.body).getElementsByClassName('element-itempublish_up');
      var descr = parse(response.body).getElementsByClassName('element-textarea');
      var docs = parse(response.body).getElementsByClassName('item-image');

      for (int i = 0; i < docs.length; i++) {
        var pageHref = docs[i].getElementsByTagName('a')[0].attributes['href'];
        var title = docs[i].getElementsByTagName('a')[0].attributes['title'];
        var image = docs[i].getElementsByTagName('img')[0].attributes['src'];
        var description = descr[i].getElementsByTagName('p')[0].text;
        var date = dateParse[i].text.trim();
      }

      FullNews news = new FullNews('','','',[]);
      print('DONE');
      return news;
    } else throw Exception('Проверьте интернет соединение');
  }
}
