import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class ArticleScreen extends StatelessWidget {
  final String articleUrl;

  const ArticleScreen({required this.articleUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Article'),
        backgroundColor: Colors.blue,
      ),
      body: WebView(
        initialUrl: articleUrl,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
