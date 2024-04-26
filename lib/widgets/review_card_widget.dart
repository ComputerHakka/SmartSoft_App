import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/reviewBloc/bloc/review_bloc.dart';
import '../models/review.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  final bool currentUserReview;
  const ReviewCard(
      {super.key, required this.review, this.currentUserReview = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black12, borderRadius: BorderRadius.circular(30)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 190, 190, 190),
                  ),
                  child: review.user!.imgUrl != null &&
                          review.user!.imgUrl!.isNotEmpty
                      ? Image.network(
                          review.user!.imgUrl!,
                          fit: BoxFit.cover,
                        )
                      : Center(
                          child: Text(
                              '${review.user!.firstName[0]}${review.user!.lastName[0]}'),
                        ),
                ),
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${review.user!.firstName} ${review.user!.lastName}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(review.rating.toString()),
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: 210,
                    child: Text(
                      review.text,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
            currentUserReview
                ? IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Подтверждение"),
                              content: const Text(
                                  "Вы уверены, что хотите удалить отзыв?"),
                              actions: [
                                TextButton(
                                  child: const Text("Отмена"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text("Да"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    context
                                        .read<ReviewBloc>()
                                        .add(DeleteReviewEvent(review));
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    icon: const Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                    ),
                  )
                : const SizedBox(
                    width: 0,
                    height: 0,
                  ),
          ],
        ),
      ),
    );
  }
}
