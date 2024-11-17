import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:html/parser.dart' as html_parser;
import 'article_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class NewsScreen2 extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen2> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  List<Map<String, String>> articles = [];
  String errorMessage = '';
  bool _showWhatsNewPanel = false;
  late AnimationController _controller;
  late Animation<double> _panelAnimation;
  late Animation<Offset> _textAnimation;
  late Animation<double> _danceAnimation;

  @override
  void initState() {
    super.initState();
    fetchNews();
    _showWhatsNewPanelAfterDelay();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _panelAnimation = Tween<double>(begin: -100.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _textAnimation =
        Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0)).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(0.5, 1.0, curve: Curves.easeInOut),
          ),
        );

    _danceAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.elasticInOut,
        ));
  }

  Future<void> fetchNews() async {
    Map<String, String> rssSources = {
      'https://www.thenews.com.pk/rss/1': 'The News International',
      'https://tribune.com.pk/rss': 'Express Tribune',
      'https://www.nation.com.pk/sitemap_news_google.xml': 'The Nation',
      'https://www.dawn.com/feed': 'Dawn',
      'https://www.pakistantoday.com.pk/feed/': 'Pakistan Today',
      'https://www.brecorder.com/rss': 'Business Recorder',
      'https://www.sundayguardianlive.com/feed': 'Sunday Guardian',
      'https://www.mashriqtv.pk/feed/': 'Mashriq TV',
      'https://www.24newshd.tv/feed': '24 News HD',
      'https://www.samaa.tv/feed/': 'Samaa',
      'https://arynews.tv/feed/': 'ARY News',
      'https://www.geo.tv/rss/1/53': 'Geo News',
      'https://www.geo.tv/rss/1/1': 'Geo News',
      'https://www.geo.tv/rss/1/4': 'Geo News',
      'https://feeds.feedburner.com/geo/GiKR': 'Geo News',
      'https://www.bolnews.com/feed/': 'Bol News',
      'http://feeds.bbci.co.uk/news/rss.xml': 'BBC News',
      'https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml': 'The New York Times',
      'https://rss.cnn.com/rss/edition.rss': 'CNN',
      'https://feeds.skynews.com/feeds/rss/world.xml': 'Sky News',
      'https://feeds.foxnews.com/foxnews/latest': 'Fox News',
      'https://news.google.com/rss?hl=en-US&gl=US&ceid=US:en': 'Google News',
      'https://www.aljazeera.com/xml/rss/all.xml': 'Al Jazeera',
      'https://www.reuters.com/rssFeed/news': 'Reuters',
      'https://www.theguardian.com/world/rss': 'The Guardian',
      'https://www.bbc.com/news/10628494': 'BBC Top Stories',
      'https://www.huffpost.com/section/front-page/feed': 'HuffPost',
    };

    for (String url in rssSources.keys) {
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final document = xml.XmlDocument.parse(response.body);
          final items = document.findAllElements('item');

          for (var item in items) {
            final title = item
                .findElements('title')
                .first
                .text;
            final descriptionHtml = item
                .findElements('description')
                .first
                .text;
            final link = item
                .findElements('link')
                .first
                .text;

            final description = html_parser
                .parse(descriptionHtml)
                .body
                ?.text ?? '';

            // Look for image URL
            String? imageUrl;
            final mediaContent = item
                .findElements('media:content')
                .firstOrNull;
            if (mediaContent != null) {
              imageUrl = mediaContent.getAttribute('url');
            }

            articles.add({
              'title': title,
              'preview': description,
              'fullContent': link,
              'channel': rssSources[url]!,
              'imageUrl': imageUrl ?? '',
            });
          }
        } else {
          setState(() {
            errorMessage = 'Failed to load from $url: ${response.statusCode}';
          });
        }
      } catch (e) {
        setState(() {
          errorMessage = 'Error fetching from $url: $e';
        });
      }
    }

    setState(() {});
  }

  void _showWhatsNewPanelAfterDelay() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      _showWhatsNewPanel = true;
      _controller.forward();
    });
  }

  List<Widget> _widgetOptions(BuildContext context) {
    return <Widget>[
      SingleChildScrollView(
        child: Column(
          children: [
            SlideTransition(
              position: _textAnimation,
              child: Container(
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                padding: const EdgeInsets.all(16.0),
                height: 120.0,
                child: Row(
                  children: [
                    ScaleTransition(
                      scale: _danceAnimation,
                      child: Icon(
                        Icons.newspaper,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "What's New...",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (articles.isEmpty && errorMessage.isEmpty)
              Center(child: CircularProgressIndicator())
            else
              if (articles.isEmpty)
                Center(child: Text(
                    'Just a moment! We’re fetching the latest news stories...'))
              else
                ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: articles.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return GestureDetector(
                      onTap: () =>
                          _showArticle(context, article['fullContent']!),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4.0,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.only(bottom: 16.0),
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (article['imageUrl']!.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  article['imageUrl']!,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            SizedBox(height: 8.0),
                            Text(
                              article['channel']!,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              article['title']!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              article['preview']!,
                              style: TextStyle(fontSize: 14),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          ],
        ),
      ),
      Center(child: Text('Dashboard - Coming Soon!')),
      Center(child: Text('Offline Content - Coming Soon!')),
      Center(child: Text('Documents - Coming Soon!')),
      Center(child: Text('Profile - Coming Soon!')),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showArticle(BuildContext context, String articleUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleScreen(articleUrl: articleUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fori Feed'),
        backgroundColor: Colors.blueAccent,
      ),
      body: _widgetOptions(context)[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.newspaper), label: 'News'),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.chartBar), label: 'Dashboard'),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.wifi), label: 'Offline'),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.fileAlt), label: 'Documents'),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.user), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        // Color for the selected icon
        unselectedItemColor: Colors.blue,
        // Color for the unselected icons
        onTap: _onItemTapped,
      ),
    );
  }
}
