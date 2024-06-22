import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:secondhand_book_selling_platform/services/product_service.dart';
import 'package:secondhand_book_selling_platform/services/user_service.dart';

class AddNewBookPage extends StatefulWidget {
  // const AddNewBookPage({super.key});

  final Function()? onBookAdded;
  // final Function()? onBookDeleted; // Add this line

  const AddNewBookPage({
    super.key,
    this.onBookAdded,
  });
  @override
  _AddNewBookPageState createState() => _AddNewBookPageState();
}

class _AddNewBookPageState extends State<AddNewBookPage> {
  List<File> _images = [];
  final _picker = ImagePicker();
  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _bookPriceController = TextEditingController();
  final TextEditingController _bookDetailController = TextEditingController();
  String _selectedCourse = "Computing";
  String _selectedYear = "Year 1";
  int _quantity = 1;
  // UserService userService = UserService();
  // userId = UserService().getUserId;
  //   UserModel user = await userService.getUserData(userId);

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    setState(() {
      _images = pickedFiles.map((file) => File(file.path)).toList();
    });
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _uploadBook() async {
    if (_images.isEmpty) {
      print('No images selected.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload at least one image.')),
      );
      return;
    }

    if (_bookNameController.text.isEmpty ||
        _bookPriceController.text.isEmpty ||
        _bookDetailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all the fields.')),
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

      String userId = UserService().getUserId;

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
          userId);

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

      // Call onBookAdded function to notify HomeScreen to refresh the list of books
      widget.onBookAdded?.call();

      // // After successfully deleting the book
      // widget.onBookDeleted?.call();

      // Provide user feedback
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Book added successfully!')));
      Navigator.of(context).pop();
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
              const Text(
                'Upload book images',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                // Centers the button
                child: ElevatedButton(
                  onPressed: _pickImages,
                  child: const Text('Upload '),
                ),
              ),
              const SizedBox(height: 12),
              _images.isNotEmpty
                  ? SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _images.length,
                        itemBuilder: (context, index) => Stack(
                          children: [
                            Image.file(_images[index]),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => _removeImage(index),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const Center(
                      child: Text('No images selected'),
                    ),
              const SizedBox(height: 16),
              const Text(
                'Book Name',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
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
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter book name',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
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

                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter book price',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Book Detail',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
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
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter book detail',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Faculty',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
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
                        'Civil Engineering',
                        'Mechanical Engineering',
                        'Electrical Engineering',
                        'Chemical & Energy Engineering',
                        'Computing',
                        'Science',
                        'Built Environment & Surveying',
                        'Social Sciences & Humanities',
                        'Management',
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
              const SizedBox(height: 16),
              const Text(
                'Year',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
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
              const SizedBox(height: 18),
              Row(
                children: [
                  Text(
                    'Quantity: $_quantity',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(), // Adds space between the text and the buttons
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
              const SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: 263,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _uploadBook,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                      backgroundColor:
                          const Color(0xff4a56c1), // Change button color
                    ),
                    child: const Text(
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
