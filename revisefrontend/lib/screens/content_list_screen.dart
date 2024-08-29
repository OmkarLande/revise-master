import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'content_detail_screen.dart';

class ContentListScreen extends StatefulWidget {
  @override
  _ContentListScreenState createState() => _ContentListScreenState();
}

class _ContentListScreenState extends State<ContentListScreen> {
  late Future<List<dynamic>> _content;

  @override
  void initState() {
    super.initState();
    _fetchContent();
  }

  Future<void> _fetchContent() async {
    setState(() {
      _content = Provider.of<AuthService>(context, listen: false).getTextContent();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Content'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchContent,
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _content,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No content available'));
          } else {
            final content = snapshot.data!;
            return ListView.builder(
              itemCount: content.length,
              itemBuilder: (context, index) {
                final item = content[index];
                return ListTile(
                  title: Text(item['title']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContentDetailScreen(id: item['_id'], title: item['title'], body: item['body']),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ContentDetailScreen()),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add Content',
      ),
    );
  }
}
