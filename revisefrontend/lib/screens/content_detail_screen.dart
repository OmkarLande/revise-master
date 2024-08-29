// screens/content_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class ContentDetailScreen extends StatefulWidget {
  final String? id;
  final String? title;
  final String? body;

  ContentDetailScreen({this.id, this.title, this.body});

  @override
  _ContentDetailScreenState createState() => _ContentDetailScreenState();
}

class _ContentDetailScreenState extends State<ContentDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _body;

  @override
  void initState() {
    super.initState();
    _title = widget.title ?? '';
    _body = widget.body ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? 'Add Content' : 'Edit Content'),
        actions: widget.id != null
            ? [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    final success = await authService.deleteTextContent(widget.id!);
                    if (success) {
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to delete content')),
                      );
                    }
                  },
                ),
              ]
            : [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                initialValue: _body,
                decoration: InputDecoration(labelText: 'Body'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onSaved: (value) {
                  _body = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    bool success;
                    if (widget.id == null) {
                      success = await authService.addTextContent(_title, _body);
                    } else {
                      success = await authService.updateTextContent(widget.id!, _title, _body);
                    }
                    if (success) {
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to save content')),
                      );
                    }
                  }
                },
                child: Text(widget.id == null ? 'Add Content' : 'Update Content'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
