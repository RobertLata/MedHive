import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medhive/constants/mh_colors.dart';
import 'package:medhive/constants/mh_margins.dart';
import 'package:medhive/constants/mh_style.dart';
import 'package:medhive/widgets/mh_snackbar.dart';

import '../entities/pharmacy.dart';

class CommentSection extends StatefulWidget {
  final Pharmacy? pharmacy;
  final double? rating;
  const CommentSection({super.key, this.pharmacy, this.rating});

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _controller = TextEditingController();
  String _comment = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(MhMargins.standardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintStyle: MhTextStyle.bodyRegularStyle
                  .copyWith(color: MhColors.mhBlueLight),
              border: const OutlineInputBorder(),
              hintText: 'Write a comment...',
            ),
            textInputAction: TextInputAction.done,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: MhMargins.standardPadding),
            child: ElevatedButton(
              onPressed: _submitCommentAndRating,
              child: Text(
                'Submit Rating',
                style: MhTextStyle.bodyRegularStyle
                    .copyWith(color: MhColors.mhPurple),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitCommentAndRating() async {
    setState(() {
      _comment = _controller.text;
    });
    final collectionPharmacies =
        FirebaseFirestore.instance.collection('Pharmacies');

    final docRefPharmacies = collectionPharmacies.doc(widget.pharmacy?.id);

    int numberOfReviews =
        widget.pharmacy != null ? widget.pharmacy!.reviewCount : 0;
    double currentRating =
        widget.pharmacy != null ? widget.pharmacy!.rating : 0;
    currentRating = ((currentRating * numberOfReviews) + (widget.rating ?? 0)) /
        (numberOfReviews + 1);
    numberOfReviews += 1;
    await docRefPharmacies.update({
      'comments': FieldValue.arrayUnion([_comment]),
      'rating': currentRating,
      'reviewCount': numberOfReviews
    });
    showMhSnackbar(context, 'Rating submitted successfully', isError: false);
    Navigator.of(context).pop();
  }
}
