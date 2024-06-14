import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:secondhand_book_selling_platform/services/rating_service.dart';

class GiveRating extends StatefulWidget {
  final String orderId;

  const GiveRating({super.key, required this.orderId});

  @override
  _GiveRating createState() => _GiveRating();
}

class _GiveRating extends State<GiveRating> {
  double _rating = 0;
  final RatingService _ratingService = RatingService();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(22.0, 21.0, 30.0, 21.0),
                      child: Text(
                        'Your opinion matters to us!',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Container(
                    color: const Color(0xFFE8E8F5),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(22.0, 23.0, 15.0, 23.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'How was the order',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: RatingBar.builder(
                              initialRating: _rating,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 5,
                              itemSize: 40,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                setState(() {
                                  _rating = rating;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: _rating > 0
                          ? () async {
                              await updateRating(widget.orderId, _rating);
                            }
                          : null,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.fromLTRB(22.0, 20.0, 15.0, 20.0),
                        ),
                      ),
                      child: const Text(
                        'Send Rating',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 47, 237),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateRating(String orderId, double rating) async {
    try {
      await _ratingService.placeRating(orderId, rating);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rating submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      // Handle errors
      print('Error updating order status and reasons: $e');
      rethrow; // Rethrow the exception for handling
    }
  }
}
