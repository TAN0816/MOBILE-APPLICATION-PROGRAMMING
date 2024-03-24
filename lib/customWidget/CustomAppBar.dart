import "package:flutter/material.dart";


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String description;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.indigo[700],
        toolbarHeight: 130,
        shape: const ContinuousRectangleBorder(
            borderRadius:
                BorderRadius.vertical(bottom: Radius.circular(30))),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(130);
}