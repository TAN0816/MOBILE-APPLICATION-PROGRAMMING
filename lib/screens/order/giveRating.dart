import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:secondhand_book_selling_platform/services/rating_service.dart';

class GiveRating extends StatefulWidget {
  final String orderId;

  const GiveRating({super.key, required this.orderId});

  @override
  _GiveRatingState createState() => _GiveRatingState();
}

class _GiveRatingState extends State<GiveRating> {
  int _rating = 0;
  bool rated = false;
  final RatingService _ratingService = RatingService();

  @override
  void initState() {
    super.initState();
    _checkAndSetRating();
  }

  void _checkAndSetRating() async {
    bool rated = await _ratingService.getRatingStatus(widget.orderId);
    if (rated) {
      int rating = await _ratingService.getRating(widget.orderId);
      setState(() {
        this.rated = rated;
        _rating = rating;
      });
    } else {
      setState(() {
        this.rated = rated;
      });
    }
       print("ratingstatus $rated and $_rating");
  }

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
              child: !rated
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                22.0, 21.0, 5.0, 21.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Your opinion matters!',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          color: const Color(0xFFE8E8F5),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                22.0, 23.0, 15.0, 23.0),
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
                                    initialRating: 0,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    itemCount: 5,
                                    itemSize: 40,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      setState(() {
                                        _rating = rating.toInt();
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
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.fromLTRB(
                                    10.0, 5.0, 10.0, 5.0),
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
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(22.0, 21.0, 5.0, 21.0),
                            child: Text(
                              'Thanks for your Rating!',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          color: const Color(0xFFE8E8F5),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                22.0, 23.0, 15.0, 23.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          'Here is your rating',
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
                                  child: RatingBarIndicator(
                                    rating: _rating.toDouble(),
                                    direction: Axis.horizontal,
                                    itemCount: 5,
                                    itemSize: 40,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                              ),
                            ),
                            child: const Text(
                              'Close',
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

  Future<void> updateRating(String orderId, int rating) async {
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
