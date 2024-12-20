import 'package:flutter/material.dart';
import 'categ_sports.dart'; // Import your sports category screen

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
            children: [
              // Custom Drawer Header with a Close Button
              Container(
                color: Colors.blue,
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context), // Close the drawer
                    ),
                    Expanded(
                      child: Text(
                        'Categories',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 48), // Placeholder for symmetry
                  ],
                ),
              ),
              // List Items
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      leading: Icon(Icons.sports, color: Colors.blue),
                      title: Text('Sports'),
                      onTap: () {
                        Navigator.pop(context); // Close the drawer
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CategSports()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.movie, color: Colors.blue),
                      title: Text('Entertainment'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.movie, color: Colors.blue),
                      title: Text('Palestine'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ), ListTile(
                      leading: Icon(Icons.movie, color: Colors.blue),
                      title: Text('Pakistan'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.movie, color: Colors.blue),
                      title: Text('Business'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.movie, color: Colors.blue),
                      title: Text('Politics'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.movie, color: Colors.blue),
                      title: Text('Latest'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    // Add more items here as needed
                  ],
                ),
              ),
              // Footer Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
            ),
        );
    }
}