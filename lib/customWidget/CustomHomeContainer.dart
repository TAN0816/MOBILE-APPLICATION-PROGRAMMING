import 'package:flutter/material.dart';

class CustomHomeContainer extends StatelessWidget {
  final String link;
  final String title;
  final String description;
  final void Function(BuildContext)? onTapCallback;

  const CustomHomeContainer({
    Key? key,
    required this.link,
    required this.title,
    required this.description,
    this.onTapCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapCallback?.call(context);
      },
      child: Container(
        width: 360,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Container(
                  width: 100,
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(link, fit: BoxFit.cover),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: SizedBox(
                width: 200,
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
