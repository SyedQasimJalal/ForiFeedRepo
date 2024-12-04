import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Saves a list of followed channels for the current user.
  Future<void> saveFollowedChannels(List<String> channels) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set(
        {
          'followedChannels': channels,
        },
        SetOptions(merge: true), // Merges with existing data
      );
    } else {
      throw Exception("No user is logged in");
    }
  }

  /// Fetches the followed channels for the current user.
  Future<List<String>> fetchFollowedChannels() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await _firestore.collection('users').doc(user.uid).get();
      if (snapshot.exists && snapshot.data() != null) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return List<String>.from(data['followedChannels'] ?? []);
      }
    }
    return [];
  }

  /// Fetches the names of all available news channels.
  Future<List<String>> fetchAvailableNewsChannels() async {
    // This should be replaced with your actual collection and field for channel names
    QuerySnapshot snapshot = await _firestore.collection('news_channels').get();
    List<String> channelNames = [];
    for (var doc in snapshot.docs) {
      // Assuming 'name' field holds the name of the news channel
      channelNames.add(doc['name']);
    }
    return channelNames;
  }

  /// Logs the user in with email and password.
  Future<User?> signInWithEmail(String email, String password) async {
    UserCredential credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  /// Logs the user out.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Saves a tapped article's title and URL for the current user.
  Future<void> saveTappedArticle(String articleTitle, String articleUrl) async {
    User? user = _auth.currentUser;
    if (user != null) {
      // Save the tapped article under the user's 'tappedArticles' sub-collection
      await _firestore.collection('users').doc(user.uid).collection('tappedArticles').add(
        {
          'title': articleTitle,
          'url': articleUrl,
          'timestamp': FieldValue.serverTimestamp(),
        },
      );
    } else {
      throw Exception("No user is logged in");
    }
  }

  /// Fetches the tapped articles for the current user.
  Future<List<Map<String, dynamic>>> fetchTappedArticles() async {
    User? user = _auth.currentUser;
    List<Map<String, dynamic>> tappedArticles = [];
    if (user != null) {
      QuerySnapshot snapshot = await _firestore.collection('users').doc(user.uid).collection('tappedArticles').get();
      for (var doc in snapshot.docs) {
        tappedArticles.add(doc.data() as Map<String, dynamic>);
      }
    }
    return tappedArticles;
  }
}
