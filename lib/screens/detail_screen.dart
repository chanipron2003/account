import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/TouristAttraction.dart';
import 'edit_screen.dart';

class DetailScreen extends StatelessWidget {
  final TouristAttraction attraction;

  DetailScreen({required this.attraction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(attraction.name),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => EditScreen(attraction: attraction),
              ));
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Image.file(
            File(attraction.imagePath),
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
          ),
          ListTile(
            title: Text('จังหวัด'),
            subtitle: Text(attraction.province),
          ),
          ListTile(
            title: Text('วันที่'),
            subtitle: Text(DateFormat('dd MMM yyyy').format(attraction.date)),
          ),
          ListTile(
            title: Text('จุดเด่น'),
            subtitle: Text(attraction.highlight),
          ),
          ListTile(
            title: Text('ความรู้สึก'),
            subtitle: Text(attraction.feeling),
          ),
        ],
      ),
    );
  }
}
