import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secondhand_book_selling_platform/model/book.dart';
import 'package:secondhand_book_selling_platform/services/product_service.dart';
import 'dart:io';

class EditProductPage extends StatefulWidget {
  final String bookId;
  final Function()? onBookUpdate;

  const EditProductPage({super.key, required this.bookId, this.onBookUpdate});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final List<File> _images = [];

  List<String> _existingImages = [];
  final _picker = ImagePicker();
  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _bookPriceController = TextEditingController();
  final TextEditingController _bookDetailController = TextEditingController();
  String _selectedCourse = "Software Engineering";
  String _selectedYear = "Year 1";
  int _quantity = 1;
  bool _isLoading = true;

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
        _selectedCourse = book.faculty;
        _selectedYear = book.year;
        _quantity = book.quantity;
        _existingImages = book.images;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching book details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load book details.')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    setState(() {
      for (var pickedFile in pickedFiles) {
        File file = File(pickedFile.path);
        if (!_images.contains(file)) {
          _images.add(file);
        }
      }
      // _images = pickedFiles.map((file) => File(file.path)).toList();
    });
  }

  Future<void> _updateBook() async {
    if (_images.isEmpty && _existingImages.isEmpty) {
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

    List<String> imageUrls = _existingImages;

    try {
      // Upload new images to Firebase Storage
      for (File image in _images) {
        String fileName = image.path.split('/').last;
        Reference storageRef =
            FirebaseStorage.instance.ref().child('book_images/$fileName');
        UploadTask uploadTask = storageRef.putFile(image);
        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
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
      // Invoke the callback function to notify the parent screen (ProductDetailSeller)
      widget.onBookUpdate?.call();

      // Clear inputs after successful submission
      _bookNameController.clear();
      _bookPriceController.clear();
      _bookDetailController.clear();
      setState(() {
        _images.clear();
        _selectedCourse = 'Computing';
        _selectedYear = 'Year 1';
        _quantity = 1;
      });

      // Provide user feedback
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Book updated successfully!')));
      Navigator.of(context).pop();
    } catch (e) {
      print('Error updating book: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update book.')));
    }
  }

  void _removeExistingImage(int index) {
    setState(() {
      _existingImages.removeAt(index);
    });
  }

  void _removeNewImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Book'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
                      child: ElevatedButton(
                        onPressed: _pickImages,
                        child: const Text('Upload '),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: [
                        ..._existingImages.map((url) {
                          int index = _existingImages.indexOf(url);
                          return Stack(
                            children: [
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () => _removeExistingImage(index),
                                ),
                              ),
                            ],
                          );
                        }),
                        ..._images.map((file) {
                          int index = _images.indexOf(file);
                          return Stack(
                            children: [
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: Image.file(
                                  file,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () => _removeNewImage(index),
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
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
                          keyboardType: TextInputType.number,
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
                      'Course',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 63,
                      width: double.infinity,
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
                              'Management'
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
                      width: double.infinity,
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
                        const Spacer(),
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
                          onPressed: _updateBook,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(fontSize: 18),
                            backgroundColor: const Color(0xff4a56c1),
                          ),
                          child: const Text(
                            'Update',
                            style: TextStyle(color: Colors.white),
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
