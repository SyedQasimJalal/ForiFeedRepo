import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> articles = []; // To hold fetched articles
  bool isLoading = true; // To show loading indicator

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  // Function to fetch articles from your Flask API
  Future<void> fetchArticles() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.10.13:5000/news')); // Update with your local Flask API URL
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          articles = List<Map<String, dynamic>>.from(data['rss_news']);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false; // Stop loading if there's an error
      });
    }
  }

  List<Widget> _widgetOptions(BuildContext context) {
    return <Widget>[
      // Dashboard Page displaying articles
      isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading spinner while fetching
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return GestureDetector(
            onTap: () => _showArticle(context, article['link']), // Link to full article
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Set background color to white
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              margin: const EdgeInsets.only(bottom: 16.0), // Space between panels
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article['title'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    article['summary'],
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
      // Placeholder for other pages
      Center(child: Text('Analytics Dashboard Page')),
      Center(child: Text('Offline Mode Page')),
      Center(child: Text('Documents Page')),
      Center(child: Text('Profile Page')),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showArticle(BuildContext context, String link) {
    // Navigate to the article's full content
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticlePage(link: link), // Create an ArticlePage to display full content
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fori Feed',
          style: TextStyle(
            fontFamily: 'Rye', // Replace with your font name
            fontSize: 24,
          ),
        ),
      ),
      body: _widgetOptions(context)[_selectedIndex], // Display content based on selected tab
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade900,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.blue,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.analytics),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.wifi),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.description), // Document/notes icon
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Article Page to display full article content
class ArticlePage extends StatelessWidget {
  final String link;

  const ArticlePage({Key? key, required this.link}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Article'),
      ),
      body: WebView(
        initialUrl: link,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
