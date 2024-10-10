import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/touristAttraction.dart';
import '../provider/attraction_provider.dart';
import '../main.dart';

class FormScreen extends StatefulWidget {
  FormScreen({Key? key}) : super(key: key);

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final provinceController = TextEditingController();
  final dateController = TextEditingController();
  final highlightController = TextEditingController();
  final feelingController = TextEditingController();
  File? _image;
  final picker = ImagePicker();

  DateTime selectedDate = DateTime.now();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null)
      setState(() {
        selectedDate = picked;
        dateController.text = picked.toLocal().toString().split(' ')[0];
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เพิ่มสถานที่ท่องเที่ยว'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            // ชื่อสถานที่ท่องเที่ยว
            TextFormField(
              decoration:
                  const InputDecoration(labelText: 'ชื่อสถานที่ท่องเที่ยว'),
              controller: nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'กรุณากรอกชื่อสถานที่ท่องเที่ยว';
                }
                return null;
              },
            ),
            // จังหวัด
            TextFormField(
              decoration: const InputDecoration(labelText: 'จังหวัด'),
              controller: provinceController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'กรุณากรอกจังหวัด';
                }
                return null;
              },
            ),
            // วันที่
            TextFormField(
              decoration: const InputDecoration(labelText: 'วันที่'),
              controller: dateController,
              readOnly: true,
              onTap: () => _selectDate(context),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'กรุณาเลือกวันที่';
                }
                return null;
              },
            ),
            // จุดเด่น
            TextFormField(
              decoration: const InputDecoration(labelText: 'จุดเด่น'),
              controller: highlightController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'กรุณากรอกจุดเด่น';
                }
                return null;
              },
            ),
            // ความรู้สึก
            TextFormField(
              decoration: const InputDecoration(labelText: 'ความรู้สึก'),
              controller: feelingController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'กรุณากรอกความรู้สึก';
                }
                return null;
              },
            ),
            // รูปภาพ
            SizedBox(height: 10),
            _image == null ? Text('ยังไม่ได้เลือกภาพ') : Image.file(_image!),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('เลือกภาพ'),
            ),
            SizedBox(height: 20),
            // ปุ่มบันทึก
            // ปุ่มบันทึก
            ElevatedButton(
              child: const Text('บันทึก'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  if (_image == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('กรุณาเลือกภาพ')),
                    );
                    return;
                  }
                  var attraction = TouristAttraction(
                    keyID: null,
                    name: nameController.text,
                    province: provinceController.text,
                    date: selectedDate,
                    highlight: highlightController.text,
                    feeling: feelingController.text,
                    imagePath: _image!.path,
                  );

                  var provider =
                      Provider.of<AttractionProvider>(context, listen: false);
                  provider.addAttraction(attraction);

                  // นำทางกลับไปยังหน้าแรกของแอพและลบเส้นทางก่อนหน้านี้
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                    (Route<dynamic> route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
