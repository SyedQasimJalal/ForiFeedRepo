import 'package:flutter/material.dart';
import 'package:fori_feed/Article_Categ.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:lottie/lottie.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'Article_Categ.dart';
import 'article_screen.dart';



class CategSports extends StatefulWidget {
  const CategSports({Key? key}) : super(key: key);

  @override
  _CategSportsState createState() => _CategSportsState();
}

class _CategSportsState extends State<CategSports> {
  List<Map<String, String>> _geoNewsItems = [];
  List<Map<String, String>> _aSportsNewsItems = [];
  List<Map<String, String>> _dawnNewsItems = [];
  List<Map<String, String>> _AlmashriqnewsItems = [];
  List<Map<String, String>> _AajTvNewsItems = [];
  List<Map<String, String>> _AbtakkNewsItems = [];
  List<Map<String, String>> _PakistanTodayNewsItems = [];

  bool _isLoadingGeo = true;
  bool _isLoadingASports = true;
  bool _isLoadingDawnNews = true;
  bool _isLoadingAlmashriqNews = true;
  bool _isLoadingAajtvNews = true;
  bool _isLoadingAbtakkNews = true;
  bool _isLoadingPakistanTodayNews = false;

  @override
  void initState() {
    super.initState();
    _fetchGeoNews();
    _fetchASportsNews();
    _fetchDawnNews();
    _fetchAlmashriqNews();
    _fetchAajTvNews();
    _fetchAbtakkNews();
    _fetchPakistanTodayNews();
  }

  // Fetch Geo News
  Future<void> _fetchGeoNews() async {
    await _fetchNews(
      'https://feeds.feedburner.com/GeoSport-GeoTvNetwork',
          (news) => setState(() {
        _geoNewsItems = news;
        _isLoadingGeo = false;
      }),
    );
  }

  // Fetch ASports News
  Future<void> _fetchASportsNews() async {
    await _fetchNews(
      'https://a-sports.tv/feed/',
          (news) => setState(() {
        _aSportsNewsItems = news;
        _isLoadingASports = false;
      }),
    );
  }

  // Fetch Dawn News
  Future<void> _fetchDawnNews() async {
    await _fetchNews(
      'https://www.dawn.com/feeds/sport/',
          (news) => setState(() {
        _dawnNewsItems = news;
        _isLoadingDawnNews = false;
      }),
    );
  }

  // Fetch Almashriq News
  Future<void> _fetchAlmashriqNews() async {
    await _fetchNews(
      'https://mashriqtv.pk/category/sports-news/feed/',
          (news) => setState(() {
        _AlmashriqnewsItems = news;
        _isLoadingAlmashriqNews = false;
      }),
    );
  }

  Future<void> _fetchAajTvNews() async {
    await _fetchNews(
      'https://www.aaj.tv/feeds/sports/',
          (news) => setState(() {
        _AajTvNewsItems = news;
        _isLoadingAajtvNews = false;
      }),
    );
  }

  Future<void> _fetchAbtakkNews() async {
    await _fetchNews(
      'https://abbtakk.tv/search/sports/feed/rss2/',
          (news) => setState(() {
        _AbtakkNewsItems = news;
        _isLoadingAbtakkNews = false;
      }),
    );
  }

  Future<void> _fetchPakistanTodayNews() async {
    await _fetchNews(
      'https://www.pakistantoday.com.pk/category/sports/feed/',
          (news) => setState(() {
        _PakistanTodayNewsItems = news;
        _isLoadingPakistanTodayNews = false;
      }),
    );
  }


  String stripHtmlTags(String htmlString) {
    final document = html_parser.parse(htmlString);
    final String parsedString = document.body?.text ?? '';
    return parsedString;
  }


  // Generic function to fetch news
  // Generic function to fetch news
  Future<void> _fetchNews(String url, Function(List<Map<String, String>>) onComplete) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final document = xml.XmlDocument.parse(response.body);
        final items = document.findAllElements('item');

        print('Fetched ${items.length} items from $url'); // Debug print

        List<Map<String, String>> news = items.map((item) {
          final title = item.findElements('title').isNotEmpty ? item.findElements('title').first.text : 'No title';
          final link = item.findElements('link').isNotEmpty ? item.findElements('link').first.text : '';
          final description = item.findElements('description').isNotEmpty ? item.findElements('description').first.text : 'No description';

          final imageUrl = parseHtmlString(description); // Extract image URL

          return {
            'title': title,
            'link': link,
            'description': parseHtmlString(description),
            'imageUrl': imageUrl, // Add the image URL to the map
          };
        }).toList();

        onComplete(news);
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      print('Error fetching news: $e');
    }
  }

  // Function to clean HTML entities from description
  // Function to clean HTML entities from description and extract image URL
  String parseHtmlString(String htmlString) {
    final document = html_parser.parse(htmlString);
    final imageElement = document.querySelector('img');
    String? imageUrl;

    if (imageElement != null) {
      imageUrl = imageElement.attributes['src'];
    } else {
      // Fallback for cases where no <img> is found
      final ogImageMeta = document.querySelector('meta[property="og:image"]');
      if (ogImageMeta != null) {
        imageUrl = ogImageMeta.attributes['content'];
      }
    }

    return imageUrl ?? '';
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sports News'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCollapsibleSection('Geo News', _geoNewsItems, _isLoadingGeo),
            SizedBox(height: 20),
            _buildCollapsibleSection('ASports', _aSportsNewsItems, _isLoadingASports),
            SizedBox(height: 20),
            _buildCollapsibleSection('Dawn News', _dawnNewsItems, _isLoadingDawnNews),
            SizedBox(height: 20),
            _buildCollapsibleSection('AlMashriq News', _AlmashriqnewsItems, _isLoadingAlmashriqNews),
            SizedBox(height: 20),
            _buildCollapsibleSection('Aaj Tv News', _AajTvNewsItems, _isLoadingAajtvNews),
            SizedBox(height: 20),
            _buildCollapsibleSection('Ab Takk News', _AbtakkNewsItems, _isLoadingAbtakkNews),
            SizedBox(height: 20),
            _buildCollapsibleSection('Pakistan Today', _PakistanTodayNewsItems, _isLoadingPakistanTodayNews),
          ],
        ),
      ),
    );
  }

  // Function to build collapsible news sections
  Widget _buildCollapsibleSection(String title, List<Map<String, String>> newsItems, bool isLoading) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        elevation: 2,
        child: ExpansionTile(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          children: [
            isLoading
                ? Padding(
              padding: const EdgeInsets.all(14.0),
              child: Center(
                child: Lottie.asset(
                  'assets/animations/loading.json',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            )
                : newsItems.isEmpty
                ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(child: Text('No news available')),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: newsItems.length,
              itemBuilder: (context, index) {
                final news = newsItems[index];
                return _buildNewsCard(news);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Function to build a news card
  // Function to build a news card
  Widget _buildNewsCard(Map<String, String> news) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display Image if URL is available
            news['imageUrl'] != null && news['imageUrl']!.isNotEmpty
                ? Image.network(news['imageUrl']!)
                : Container(), // Placeholder or no image

            Text(
              news['title']!,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Text(
              news['description']!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  _launchURL(news['link']!, news['title']!);
                },
                child: Text(
                  'Read More',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to open the URL in the browser
  void _launchURL(String url, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleCategScreen(
          articleUrl: url,  // Pass 'articleUrl' instead of 'url'
          title: title,
        ),
      ),
    );
  }
}