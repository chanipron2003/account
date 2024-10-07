import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/tourist_attraction.dart';
import '../provider/attraction_provider.dart';

class EditScreen extends StatefulWidget {
  final TouristAttraction attraction;

  EditScreen({required this.attraction});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController provinceController;
  late TextEditingController dateController;
  late TextEditingController highlightController;
  late TextEditingController feelingController;
  File? _image;
  final picker = ImagePicker();

  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.attraction.name);
    provinceController = TextEditingController(text: widget.attraction.province);
    dateController = TextEditingController(text: widget.attraction.date.toLocal().toString().split(' ')[0]);
    highlightController = TextEditingController(text: widget.attraction.highlight);
    feelingController = TextEditingController(text: widget.attraction.feeling);
    _image = File(widget.attraction.imagePath);
    selectedDate = widget.attraction.date;
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : _image;
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
        title: const Text('แก้ไขสถานที่ท่องเที่ยว'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            // ชื่อสถานที่ท่องเที่ยว
            TextFormField(
              decoration: const InputDecoration(labelText: 'ชื่อสถานที่ท่องเที่ยว'),
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
            _image == null
                ? Text('ยังไม่ได้เลือกภาพ')
                : Image.file(_image!),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('เปลี่ยนภาพ'),
            ),
            SizedBox(height: 20),
            // ปุ่มบันทึก
            ElevatedButton(
              child: const Text('บันทึกการแก้ไข'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  var updatedAttraction = TouristAttraction(
                    keyID: widget.attraction.keyID,
                    name: nameController.text,
                    province: provinceController.text,
                    date: selectedDate,
                    highlight: highlightController.text,
                    feeling: feelingController.text,
                    imagePath: _image!.path,
                  );

                  var provider = Provider.of<AttractionProvider>(context, listen: false);
                  provider.updateAttraction(updatedAttraction);

                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
