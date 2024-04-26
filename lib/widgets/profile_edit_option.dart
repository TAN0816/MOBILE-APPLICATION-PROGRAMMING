import 'package:flutter/material.dart';

class ProfileEditOption extends StatefulWidget {
  final String title;
  final String placeholder;
  final Function(String) updateProfile;

  const ProfileEditOption({
    super.key,
    required this.title,
    required this.placeholder,
    required this.updateProfile,
  });

  @override
  _ProfileEditOptionState createState() => _ProfileEditOptionState();
}

class _ProfileEditOptionState extends State<ProfileEditOption> {
  void _showModalBottomSheet(BuildContext context) {
    final GlobalKey<FormState> _profileFormKey = GlobalKey<FormState>();
    final TextEditingController _textEditingController =
        TextEditingController(text: widget.placeholder);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _profileFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () => Navigator.of(context).pop(),
                            color: Colors.black,
                          ),
                        ),
                        Center(
                          child: Text(
                            'Change ${widget.title}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              height: 2.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextFormField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      labelText: 'Enter ${widget.title}: ',
                      labelStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30.0),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xff4a56c1),
                    ),
                    onPressed: () {
                      if (_profileFormKey.currentState!.validate()) {
                        String inputText = _textEditingController.text;
                        // Handle submit action here
                        print('Submitted: $inputText');
                        widget.updateProfile(inputText);
                        Navigator.of(context).pop(); // Close bottom sheet
                      }
                    },
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        onPressed: () => {_showModalBottomSheet(context)},
        child: Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          padding: const EdgeInsets.fromLTRB(20.0, 20, 20.0, 20.0),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: Color.fromARGB(255, 211, 211, 211),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
              Row(
                children: [
                  Text(
                    widget.placeholder,
                    style: const TextStyle(
                      color: Color.fromARGB(100, 0, 0, 0),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.arrow_forward_ios_rounded),
                ],
              ),
            ],
          ),
        ));
  }
}
