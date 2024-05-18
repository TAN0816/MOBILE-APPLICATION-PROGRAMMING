// import 'package:flutter/material.dart';

// class AddNewBookPage extends StatefulWidget {
//   @override
//   _AddNewBookPageState createState() => _AddNewBookPageState();
// }

// class _AddNewBookPageState extends State<AddNewBookPage> {
//   // Define variables to store book information
//   String _bookName = '';
//   double _bookPrice = 0.0;
//   String _bookDetails = '';
//   String? _selectedCourse; // Nullable type
//   String? _selectedYear; // Nullable type
//   int _quantity = 1;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add New Book'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Book Name
//             TextField(
//               decoration: InputDecoration(labelText: 'Book Name'),
//               onChanged: (value) {
//                 setState(() {
//                   _bookName = value;
//                 });
//               },
//             ),
//             SizedBox(height: 20.0),
//             // Book Price
//             TextField(
//               decoration: InputDecoration(labelText: 'Book Price'),
//               keyboardType: TextInputType.number,
//               onChanged: (value) {
//                 setState(() {
//                   _bookPrice = double.tryParse(value) ?? 0.0;
//                 });
//               },
//             ),
//             SizedBox(height: 20.0),
//             // Book Details
//             TextField(
//               decoration: InputDecoration(labelText: 'Book Details'),
//               maxLines: 3,
//               onChanged: (value) {
//                 setState(() {
//                   _bookDetails = value;
//                 });
//               },
//             ),
//             SizedBox(height: 20.0),
//             // Course Dropdown
//             DropdownButtonFormField<String>(
//               value: _selectedCourse,
//               decoration: InputDecoration(labelText: 'Course'),
//               items: ['Course A', 'Course B', 'Course C']
//                   .map((course) => DropdownMenuItem(
//                         value: course,
//                         child: Text(course),
//                       ))
//                   .toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedCourse = value!;
//                 });
//               },
//             ),
//             SizedBox(height: 20.0),
//             // Year Dropdown
//             DropdownButtonFormField<String>(
//               value: _selectedYear,
//               decoration: InputDecoration(labelText: 'Year'),
//               items: ['Year 1', 'Year 2', 'Year 3']
//                   .map((year) => DropdownMenuItem(
//                         value: year,
//                         child: Text(year),
//                       ))
//                   .toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedYear = value;
//                 });
//               },
//             ),
//             SizedBox(height: 20.0),
//             // Quantity Selector
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Quantity: '),
//                 Row(
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.remove),
//                       onPressed: () {
//                         setState(() {
//                           if (_quantity > 1) _quantity--;
//                         });
//                       },
//                     ),
//                     Text('$_quantity'),
//                     IconButton(
//                       icon: Icon(Icons.add),
//                       onPressed: () {
//                         setState(() {
//                           _quantity++;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             SizedBox(height: 20.0),
//             // Submit Button
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Handle submission here
//                   // You can access all the entered data using _bookName, _bookPrice, etc.
//                 },
//                 child: Text('Submit'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: AddNewBookPage(),
//   ));
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:secondhand_book_selling_platform/services/user_service.dart';

class AddNewBookPage extends StatefulWidget {
  @override
  _AddNewBookPageState createState() => _AddNewBookPageState();
}

class _AddNewBookPageState extends State<AddNewBookPage> {
  List<File> _images = [];
  final _picker = ImagePicker();
  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _bookPriceController = TextEditingController();
  final TextEditingController _bookDetailController = TextEditingController();
  String _selectedCourse = "Course 1";
  String _selectedYear = "2024";
  int _quantity = 1;

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _images = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  Future<void> _uploadBook() async {
    if (_images.isEmpty) {
      print('No images selected.');
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

      // Save book details to Firestore
      await FirebaseFirestore.instance.collection('books').add({
        'name': _bookNameController.text,
        'price': double.parse(_bookPriceController.text),
        'detail': _bookDetailController.text,
        'course': _selectedCourse,
        'year': _selectedYear,
        'quantity': _quantity,
        'images': imageUrls,
        // 'sellerId': userId,
      });

      // Clear inputs after successful submission
      _bookNameController.clear();
      _bookPriceController.clear();
      _bookDetailController.clear();
      setState(() {
        _images.clear();
        _selectedCourse = 'Course 1';
        _selectedYear = '2024';
        _quantity = 1;
      });

      // Provide user feedback
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Book added successfully!')));
    } catch (e) {
      print('Error uploading book: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to add book.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: _pickImages,
                child: Text('Upload Book Images'),
              ),
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
                  : Text('No images selected'),
              TextField(
                controller: _bookNameController,
                decoration: InputDecoration(labelText: 'Book Name'),
              ),
              TextField(
                controller: _bookPriceController,
                decoration: InputDecoration(labelText: 'Book Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _bookDetailController,
                decoration: InputDecoration(labelText: 'Book Detail'),
              ),
              DropdownButton<String>(
                value: _selectedCourse,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCourse = newValue!;
                  });
                },
                items: <String>['Course 1', 'Course 2', 'Course 3']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              DropdownButton<String>(
                value: _selectedYear,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedYear = newValue!;
                  });
                },
                items: <String>['2023', '2024', '2025']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        if (_quantity > 1) _quantity--;
                      });
                    },
                  ),
                  Text('$_quantity'),
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
              ElevatedButton(
                onPressed: _uploadBook,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
