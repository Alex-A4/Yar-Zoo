import 'package:flutter/material.dart';
import 'package:flutter_yar_zoo/views/full_news_viewer.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NewsView extends StatefulWidget {
  NewsView({Key key}): super(key: key);

  @override
  _NewsViewState createState() => _NewsViewState();
}



class _NewsViewState extends State<NewsView> {
  String _title = 'Новости';

  Future<List<News>> news;


  @override
  void initState() {
    super.initState();
    startDownloading();
  }

  void startDownloading(){
    news = fetchNews();
  }

  //TODO: fix title displaying
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          child: Image(image: AssetImage('assets/logo.png'),),
          padding: EdgeInsets.only(left:10.0, top:5.0, bottom: 5.0),
        ),
        title: Text(_title),
      ),
      body: getFutureBuilder(),

    );
  }


  Widget getFutureBuilder() {
    return FutureBuilder<List<News>>(
      future: news,
      builder: (context, snapshot) {
        print(NewsStore.getStore().news.length);

        //If news have been downloaded but internet disabled
        if (NewsStore.getStore().news.isNotEmpty) {
          _title = 'Новости';
          return getListView();
        }

        //If downloading finished
        if (snapshot.hasData) {
          NewsStore.getStore().updateNews(snapshot.data);
          _title = 'Новости';
          return getListView();
        } else if (snapshot.hasError) {
          // If error occurred
          Fluttertoast.showToast(
            msg: 'Проверьте интернет соединение',
            textColor: Colors.white,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            timeInSecForIos: 2,
          );
          _title = 'Ожидание сети..';
          return getUpdateScreen();
        }

        //Until downloading finishes, show progress bar
        _title = 'Соединение..';
        return getProgressBar();
      },
    );
  }

  Widget getUpdateScreen() {
    return Center(
            child: IconButton(
              iconSize: 50.0,
              icon: Icon(Icons.update),
              onPressed: (){
                setState(() {
                  _title = 'Новости';
                  startDownloading();
                });
              },
            ),
          );
  }

  Widget getListView() {
    return ListView.builder(
        key: PageStorageKey('NewsKey'),
        padding: EdgeInsets.only(top: 8.0),
        itemCount: NewsStore.getStore().news.length,
        itemBuilder: (BuildContext context, int pos) {
          return _NewsListItem(NewsStore.getStore().news[pos]);
        }
    );
  }

  // Getting circular progress bar
  Widget getProgressBar() {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.green[700],
        strokeWidth: 3.0,
      ),
    );
  }


  /// Fetching news from web-site
  Future<List<News>> fetchNews() async {
    //Checking internet connection
    var connectivityResult = await (new Connectivity().checkConnectivity());

    if (connectivityResult != ConnectivityResult.mobile
        && connectivityResult != ConnectivityResult.wifi)
      throw Exception('Проверьте интернет соединение');

    print('Internet exist');

    final response = await http.get('http://yar-zoo.ru/home/news.html');

    if (response.statusCode == 200) {
      List<News> news = [];

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
        news.add(new News(title, description, image, date, pageHref));
      }

      return news;
    } else throw Exception('Проверьте интернет соединение');
  }

}


/// Class describes news item from list
class _NewsListItem extends StatelessWidget {
  final News _news;
  _NewsListItem(this._news);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FullNewsViewer(_news.pageUrl)
          ),
        );
      },

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Text with title of news
          Container(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Text(
              _news._title,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.black,
              ),
            ),
          ),

          // Text with date
          Container(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Text(
              _news._postDate,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black45
              ),
            ),
          ),

          //An image which placed into the center
          Center( child: Container(
            padding: EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              child: Image.network(
                _news.imageUrl,
                width: 200.0,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          ),

          // A description of news
          Container(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Text(
              _news._description,
              textAlign: TextAlign.start,
              softWrap: true,
              style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.black45
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

}


///Singleton store of news
class NewsStore {
  List<News> _news = [];
  static NewsStore _sStore;
  static NewsStore getStore() {
    if (_sStore == null)
      _sStore = new NewsStore();

    return _sStore;
  }

  void updateNews(List<News> news) {
    _news = news;
  }

  List<News> get news => _news;
}


/// Class describes one news
class News {
  final String _title;
  final String _description;
  final String _imageUrl;
  final String _pageUrl;
  final String _postDate;

  News(this._title, this._description, this._imageUrl, this._postDate, this._pageUrl) :
  assert(_title != null),
  assert(_description != null),
  assert(_imageUrl != null),
  assert(_postDate != null),
  assert (_pageUrl != null);


  String get pageUrl => _pageUrl;

  String get postDate => _postDate;

  String get imageUrl => _imageUrl;

  String get description => _description;

  String get title => _title;


}