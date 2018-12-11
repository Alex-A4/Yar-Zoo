import 'package:flutter/material.dart';

class NewsView extends StatefulWidget {
  NewsView({Key key}): super(key: key);

  @override
  _NewsViewState createState() => _NewsViewState();
}



/// TODO: add logic to parse html pages from yar-zoo.ru
class _NewsViewState extends State<NewsView> {
  //List with news
  List<News> _newsList = [
    new News('Наблюдайте за спячкой Умы в режиме он-лайн!', '26 декабря 2018 года мы проводили наших медведей Уму и Топу в зимнюю спячку, подготовили им специальные мягкие лежанки и пожелали "Сладких снов"',
        "http://yar-zoo.ru/media/zoo/images/03122018_aef8d5c7c9516226adefd3078d3188c7.jpg", '26 декабря 2018', "http://yar-zoo.ru/home/news/bearsleep-copy.html"),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          child: Image(image: AssetImage('assets/logo.png'),),
          padding: EdgeInsets.only(left:10.0, top:5.0, bottom: 5.0),
        ),
        title: Text('Новости'),
        actions: <Widget>[
          // Action for open settings
          IconButton(
            icon: Icon(Icons.settings),
            //TODO: add logic to start settings
            onPressed: (){
              Scaffold.of(context).removeCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text('Settings clicked'), duration: Duration(seconds: 2))
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(top: 8.0),
        itemCount: _newsList.length,
        itemBuilder: (BuildContext context, int pos) {
          return _NewsListItem(_newsList[pos]);
        },
      )
    );
  }

}


/// Class describes news item from list
class _NewsListItem extends StatelessWidget {
  final News _news;
  _NewsListItem(this._news);

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }

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