import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../provider/attraction_provider.dart';
import '../models/touristAttraction.dart';
import 'detail_screen.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Provider.of<AttractionProvider>(context, listen: false).initData();
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('สถานที่ท่องเที่ยวที่เคยไป'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              // ออกจากแอปเมื่อกดปุ่ม
              SystemNavigator.pop(); // หรือใช้ exit(0); หากต้องการ
            },
          ),
        ],
      ),
      body: Consumer<AttractionProvider>(
        builder: (context, provider, child) {
          if (provider.attractions.isEmpty) {
            return const Center(child: Text('ไม่มีรายการ'));
          } else {
            return ListView.builder(
              itemCount: provider.attractions.length,
              itemBuilder: (context, index) {
                TouristAttraction attraction = provider.attractions[index];
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  child: ListTile(
                    leading: Image.file(
                      File(attraction.imagePath),
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                    title: Text(attraction.name),
                    subtitle: Text('${attraction.province}\n${DateFormat('dd MMM yyyy').format(attraction.date)}'),
                    isThreeLine: true,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => DetailScreen(attraction: attraction),
                      ));
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        provider.deleteAttraction(attraction.keyID);
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
