import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secondhand_book_selling_platform/model/book.dart';
import 'dart:io';

import 'package:secondhand_book_selling_platform/services/user_service.dart';
import 'package:secondhand_book_selling_platform/services/produuct_service.dart';

class EditProductPage extends StatefulWidget {
  final String bookId;

  EditProductPage({required this.bookId});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  List<File> _images = [];
  final _picker = ImagePicker();
  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _bookPriceController = TextEditingController();
  final TextEditingController _bookDetailController = TextEditingController();
  String _selectedCourse = "Software Engineering";
  String _selectedYear = "Year 1";
  int _quantity = 1;
  bool _isLoading = true;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _fetchBookDetails();
  }

  Future<void> _fetchBookDetails() async {
    try {
      Book book = await ProductService().getBookById(widget.bookId);
      setState(() {
        _bookNameController.text = book.name;
        _bookPriceController.text = book.price.toString();
        _bookDetailController.text = book.detail;
        _selectedCourse = book.course;
        _selectedYear = book.year;
        _quantity = book.quantity;
        _imageUrl = book.imageUrls.isNotEmpty ? book.imageUrls.first : null;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching book details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch book details.')));
    }
  }

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _images = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  Future<void> _updateBook() async {
    if (_images.isEmpty && _imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please upload at least one image.')));
      return;
    }

    if (_bookNameController.text.isEmpty ||
        _bookPriceController.text.isEmpty ||
        _bookDetailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill in all the fields.')));
      return;
    }

    List<String> imageUrls = [];

    try {
      // Upload new images to Firebase Storage if selected
      for (File image in _images) {
        String fileName = image.path.split('/').last;
        Reference storageRef =
            FirebaseStorage.instance.ref().child('book_images/$fileName');
        UploadTask uploadTask = storageRef.putFile(image);
        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }

      // Use existing imageUrl if no new images are selected
      if (imageUrls.isEmpty && _imageUrl != null) {
        imageUrls.add(_imageUrl!);
      }

      // Update book details in Firestore
      await ProductService().updateBook(
        widget.bookId,
        _bookNameController.text,
        double.parse(_bookPriceController.text),
        _bookDetailController.text,
        _selectedCourse,
        _selectedYear,
        _quantity,
        imageUrls,
      );

      // Provide user feedback
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Book updated successfully!')));
      Navigator.pop(context); // Return to the previous screen
    } catch (e) {
      print('Error updating book: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to update book.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Book'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(22.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upload new book image',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Column(
                        children: [
                          _imageUrl != null
                              ? Image.network(_imageUrl!, height: 150)
                              : Container(),
                          ElevatedButton(
                            onPressed: _pickImages,
                            child: Text('Edit image'),
                          ),
                        ],
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                      width: double
                          .infinity, // Adjusts width to the available space
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
                      width: double
                          .infinity, // Adjusts width to the available space
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
                            items: <String>[
                              'Year 1',
                              'Year 2',
                              'Year 3',
                              'Year 4'
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
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (_quantity > 1) _quantity--;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
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
                          onPressed: _updateBook,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            textStyle: TextStyle(fontSize: 18),
                            backgroundColor:
                                const Color(0xff4a56c1), // Change button color
                          ),
                          child: Text(
                            'Submit',
                            style: TextStyle(
                                color: Colors.white), // Change text color
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
