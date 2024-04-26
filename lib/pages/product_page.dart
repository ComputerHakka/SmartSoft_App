import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smartsoft_application/blocs/profileBloc/bloc/profile_bloc.dart';
import 'package:smartsoft_application/models/product.dart';
import 'package:smartsoft_application/models/review.dart';
import 'package:smartsoft_application/theme/app_theme.dart';
import 'package:smartsoft_application/widgets/review_card_widget.dart';

import '../blocs/authBloc/bloc/authorization_bloc.dart';
import '../blocs/cartBloc/bloc/cart_bloc.dart';
import '../blocs/reviewBloc/bloc/review_bloc.dart';
import '../repositories/user/user_repository.dart';
import '../widgets/custom_appbar.dart';

class ProductPage extends StatefulWidget {
  final Product product;
  const ProductPage({super.key, required this.product});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  TextEditingController _reviewController = TextEditingController();
  double _userRating = 0.0;
  String _reviewText = '';

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Товар',
        searchActivate: false,
      ),
      bottomNavigationBar: BottomAppBar(
        height: 70,
        color: HexColor('#1E1E1E'),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    elevation: 5,
                    margin: EdgeInsets.fromLTRB(50, 0, 50, 30),
                    content: Text(
                      'Товар добавлен в корзину',
                      textAlign: TextAlign.center,
                    ),
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                context.read<CartBloc>().add(AddProductEvent(widget.product));
              },
              child: const Text('Добавить в корзину'),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                  width: 250,
                  height: 250,
                  margin: const EdgeInsets.all(10.0),
                  child: Image.network(widget.product.imgUrl)),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black.withAlpha(50),
                  ),
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      color: kPrimaryColor,
                    ),
                    padding: const EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width - 10,
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.product.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          width: 300,
                          height: 10,
                          child: Divider(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${widget.product.price} Руб.',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ExpansionTile(
                  title: const Text('Описание'),
                  initiallyExpanded: true,
                  children: [
                    ListTile(
                      title: Text(
                          widget.product.description ?? 'Описание отсутствует'),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ExpansionTile(
                  title: const Text('Характеристики'),
                  children: [
                    widget.product.characteristics!.isNotEmpty
                        ? ListView.builder(
                            itemCount: widget.product.characteristics!.length,
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              var keys =
                                  widget.product.characteristics!.keys.toList();
                              var values = widget
                                  .product.characteristics!.values
                                  .toList();
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${keys[index]}:',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      values[index],
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            })
                        : ListTile(
                            title: Text(widget.product.description ??
                                'Характеристики неизвестны'),
                          )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 0,
                ),
                child: BlocBuilder<ReviewBloc, ReviewState>(
                  builder: (context, stateR) {
                    if (stateR is ReviewLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (stateR is ReviewLoadedState) {
                      var productReviews = stateR.reviews
                          .where(
                              (review) => review.productId == widget.product.id)
                          .toList();
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                                child: const Text(
                                  'Отзывы',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          BlocProvider<ProfileBloc>(
                            create: (context) => ProfileBloc(
                              authBloc: context.read<AuthorizationBloc>(),
                              userRepository: context.read<UserRepository>(),
                            )..add(
                                LoadProfileEvent(
                                  context
                                      .read<AuthorizationBloc>()
                                      .state
                                      .authUser,
                                ),
                              ),
                            child: BlocBuilder<ProfileBloc, ProfileState>(
                              builder: (context, state) {
                                if (state is ProfileLoadingState) {
                                  return Container();
                                }
                                if (state is ProfileLoadedState) {
                                  bool existReview = productReviews.any(
                                      (review) =>
                                          review.userId!.replaceAll(' ', '') ==
                                          state.user.id!.replaceAll(' ', ''));
                                  return Column(
                                    children: [
                                      productReviews.isNotEmpty
                                          ? ListView.builder(
                                              itemCount: productReviews.length,
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                if (productReviews[index]
                                                        .userId!
                                                        .replaceAll(' ', '') ==
                                                    state.user.id!
                                                        .replaceAll(' ', '')) {
                                                  return ReviewCard(
                                                    review:
                                                        productReviews[index],
                                                    currentUserReview: true,
                                                  );
                                                }
                                                return ReviewCard(
                                                    review:
                                                        productReviews[index]);
                                              },
                                            )
                                          : const Text(
                                              'О данном товаре нет отзывов',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: !existReview
                                            ? Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                                .fromLTRB(
                                                            15, 0, 0, 0),
                                                        child: const Text(
                                                          'Оставить отзыв',
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 15),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        RatingBar.builder(
                                                          minRating: 1.0,
                                                          initialRating:
                                                              _userRating,
                                                          itemBuilder: (context,
                                                                  index) =>
                                                              const Icon(
                                                                  Icons.star,
                                                                  color: Colors
                                                                      .amber),
                                                          onRatingUpdate:
                                                              (value) {
                                                            setState(() {
                                                              _userRating =
                                                                  value;
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets
                                                        .fromLTRB(15, 0, 15, 0),
                                                    child: TextField(
                                                      controller:
                                                          _reviewController,
                                                      maxLines: 3,
                                                      decoration: const InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          10,
                                                                      horizontal:
                                                                          15),
                                                          hintText:
                                                              'Введите текст отзыва...'),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _reviewText = value;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      if (_reviewText
                                                          .isNotEmpty) {
                                                        context
                                                            .read<ReviewBloc>()
                                                            .add(
                                                              SendReviewEvent(
                                                                review: Review(
                                                                  text:
                                                                      _reviewText,
                                                                  rating:
                                                                      _userRating
                                                                          .toInt(),
                                                                  product: widget
                                                                      .product,
                                                                  user: state
                                                                      .user,
                                                                ),
                                                              ),
                                                            );
                                                      } else {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      30,
                                                                      30,
                                                                      30,
                                                                      0),
                                                              content:
                                                                  const Text(
                                                                ' Текст отзыва не должен быть пустым!',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  child:
                                                                      const Text(
                                                                          'OK'),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      }
                                                    },
                                                    child: const Text(
                                                        'Оставить отзыв'),
                                                  ),
                                                ],
                                              )
                                            : Container(),
                                      ),
                                    ],
                                  );
                                }
                                if (state is ProfileUnauthenticated) {
                                  return Column(
                                    children: [
                                      productReviews.isNotEmpty
                                          ? ListView.builder(
                                              itemCount: productReviews.length,
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return ReviewCard(
                                                    review:
                                                        productReviews[index]);
                                              },
                                            )
                                          : const Text(
                                              'О данном товаре нет отзывов',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(
                        child: Text('Упс...Что-то пошло не так'),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
