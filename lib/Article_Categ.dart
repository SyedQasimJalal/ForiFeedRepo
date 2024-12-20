import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleCategScreen extends StatefulWidget {
  final String articleUrl;
  final String title;

  const ArticleCategScreen({Key? key, required this.articleUrl, required this.title}) : super(key: key);

  @override
  _ArticleCategScreenState createState() => _ArticleCategScreenState();
}

class _ArticleCategScreenState extends State<ArticleCategScreen> {
  final FlutterTts flutterTts = FlutterTts();
  late WebViewController _webViewController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
    _setupTts();
  }

  void _initializeWebView() {
    // WebView is automatically initialized when placed in the widget tree
  }

  Future<void> _setupTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future<void> _speak() async {
    String articleContent = await _getArticleContent();
    if (articleContent.isNotEmpty) {
      print("Speaking content: $articleContent");
      await flutterTts.speak(articleContent);
    } else {
      print("No article content found!");
    }
  }

  Future<String> _getArticleContent() async {
    String content = await _webViewController.evaluateJavascript("""
      var articleContent = '';
      var titleElement = document.querySelector('h1');
      if (titleElement) {
        var nextElement = titleElement.nextElementSibling;
        while (nextElement) {
          if (nextElement.tagName === 'P' || nextElement.tagName === 'DIV' || nextElement.tagName === 'SECTION') {
            articleContent += nextElement.innerText + ' ';
          }
          nextElement = nextElement.nextElementSibling;
        }
      }
      return articleContent.trim();
    """);

    print("Extracted Article Content: $content");
    return content.trim();
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.volume_up),
            onPressed: _speak,
          ),
        ],
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: widget.articleUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onPageStarted: (url) {
              setState(() {
                isLoading = true;
              });
            },
            onPageFinished: (url) {
              setState(() {
                isLoading = false;
              });
              _speak();
            },
            onWebViewCreated: (WebViewController webViewController) {
              _webViewController = webViewController;
            },
          ),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Container(),
        ],
      ),
    );
  }
}