import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:secondhand_book_selling_platform/services/user_service.dart';
import 'package:secondhand_book_selling_platform/services/produuct_service.dart';

class AddNewBookPage extends StatefulWidget {
  const AddNewBookPage({super.key});

  @override
  _AddNewBookPageState createState() => _AddNewBookPageState();
}

class _AddNewBookPageState extends State<AddNewBookPage> {
  List<File> _images = [];
  final _picker = ImagePicker();
  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _bookPriceController = TextEditingController();
  final TextEditingController _bookDetailController = TextEditingController();
  String _selectedCourse = "Software Engineering";
  String _selectedYear = "Year 1";
  int _quantity = 1;

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    setState(() {
      _images = pickedFiles.map((file) => File(file.path)).toList();
    });
    }

  Future<void> _uploadBook() async {
    if (_images.isEmpty) {
      print('No images selected.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please upload at least one image.')),
      );
      return;
    }

    if (_bookNameController.text.isEmpty ||
        _bookPriceController.text.isEmpty ||
        _bookDetailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all the fields.')),
      );
      return;
    }
    List<String> imageUrls = [];

    try {
      // Upload images to Firebase Storage
      for (File image in _images) {
        String fileName = image.path.split('/').last;
        Reference storageRef =
            FirebaseStorage.instance.ref().child('book_images/$fileName');
        UploadTask uploadTask = storageRef.putFile(image);
        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }
      // String userId = UserService().getUserId;

      // // Save book details to Firestore
      // await FirebaseFirestore.instance.collection('books').add({
      //   'name': _bookNameController.text,
      //   'price': double.parse(_bookPriceController.text),
      //   'detail': _bookDetailController.text,
      //   'course': _selectedCourse,
      //   'year': _selectedYear,
      //   'quantity': _quantity,
      //   'images': imageUrls,
      //   // 'sellerId': userId,
      // });

      // Call ProductService to upload book details to Firestore
      await ProductService().uploadBook(
        _bookNameController.text,
        double.parse(_bookPriceController.text),
        _bookDetailController.text,
        _selectedCourse,
        _selectedYear,
        _quantity,
        imageUrls,
      );

      // Clear inputs after successful submission
      _bookNameController.clear();
      _bookPriceController.clear();
      _bookDetailController.clear();
      setState(() {
        _images.clear();
        _selectedCourse = 'Software Engineering';
        _selectedYear = 'Year 1';
        _quantity = 1;
      });

      // Provide user feedback
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Book added successfully!')));
    } catch (e) {
      print('Error uploading book: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed to add book.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upload book images',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Center(
                // Centers the button
                child: ElevatedButton(
                  onPressed: _pickImages,
                  child: Text('Upload '),
                ),
              ),
              SizedBox(height: 12),
              _images.isNotEmpty
                  ? SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _images.length,
                        itemBuilder: (context, index) =>
                            Image.file(_images[index]),
                      ),
                    )
                  : Center(
                      child: Text('No images selected'),
                    ),
              SizedBox(height: 16),
              Text(
                'Book Name',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Container(
                height: 63,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: const Color(0xfff4f4f4),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: _bookNameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter book name',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Book Price',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                height: 63,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: const Color(0xfff4f4f4),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: _bookPriceController,
                    keyboardType: TextInputType
                        .number, // Sets the keyboard type to number

                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter book price',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Book Detail',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Container(
                height: 63,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: const Color(0xfff4f4f4),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: _bookDetailController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter book detail',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Course',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Container(
                height: 63,
                width: double.infinity, // Adjusts width to the available space
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: const Color(0xfff4f4f4),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCourse,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCourse = newValue!;
                        });
                      },
                      isExpanded: true,
                      items: <String>[
                        'Software Engineering',
                        'Data Engineering',
                        'Network and Security',
                        'Bioinformatics',
                        'Graphics and Multimedia Design'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Year',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Container(
                height: 63,
                width: double.infinity, // Adjusts width to the available space
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: const Color(0xfff4f4f4),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedYear,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedYear = newValue!;
                        });
                      },
                      isExpanded: true,
                      items: <String>['Year 1', 'Year 2', 'Year 3', 'Year 4']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 18),
              Row(
                children: [
                  Text(
                    'Quantity: $_quantity',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(), // Adds space between the text and the buttons
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        if (_quantity > 1) _quantity--;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        _quantity++;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              Center(
                child: Container(
                  width: 263,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _uploadBook,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      textStyle: TextStyle(fontSize: 18),
                      backgroundColor:
                          const Color(0xff4a56c1), // Change button color
                    ),
                    child: Text(
                      'Submit',
                      style:
                          TextStyle(color: Colors.white), // Change text color
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
