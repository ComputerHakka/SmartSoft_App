import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartsoft_application/blocs/orderBloc/getOrders/get_orders_bloc.dart';
import 'package:smartsoft_application/blocs/profileBloc/bloc/profile_bloc.dart';
import 'package:smartsoft_application/models/user.dart';
import 'package:smartsoft_application/pages/my_orders_page.dart';
import 'package:smartsoft_application/pages/profile_page.dart';
import 'package:smartsoft_application/widgets/custom_appbar.dart';
import 'package:smartsoft_application/widgets/order_card_widget.dart';

import '../blocs/authBloc/bloc/authorization_bloc.dart';
import '../repositories/authorization/auth_repository.dart';
import '../theme/app_theme.dart';
import 'user_level_page.dart';

class UserPage extends StatelessWidget {
  final UserModel currentUser;
  final BuildContext currentContext;
  const UserPage({
    super.key,
    required this.currentUser,
    required this.currentContext,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
            child: ListView(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: double.infinity,
                      child: Stack(
                        alignment: const AlignmentDirectional(0, 0),
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(255, 190, 190, 190),
                            ),
                            child: currentUser.imgUrl != null &&
                                    currentUser.imgUrl!.isNotEmpty
                                ? Image.network(
                                    currentUser.imgUrl!,
                                    fit: BoxFit.cover,
                                  )
                                : IconButton(
                                    onPressed: () async {
                                      ImagePicker imagePicker = ImagePicker();
                                      final pickedFile =
                                          await imagePicker.pickImage(
                                              source: ImageSource.gallery);

                                      if (pickedFile != null) {
                                        final photo = File(pickedFile.path);
                                        currentContext.read<ProfileBloc>().add(
                                            ChangePhotoEvent(
                                                user: currentUser,
                                                photo: photo));
                                      }
                                    },
                                    icon: const Icon(
                                        Icons.add_photo_alternate_outlined),
                                    color: Colors.black26,
                                    iconSize: 50.0,
                                  ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${currentUser.firstName} ${currentUser.lastName}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 15),
                      child: Text(
                        'Уровень: ${currentUser.level.toString()}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 100,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MyOrdersPage(user: currentUser),
                                ),
                              );
                            },
                            child: Container(
                              width: 160,
                              margin: const EdgeInsetsDirectional.fromSTEB(
                                  5, 0, 5, 0),
                              decoration: BoxDecoration(
                                color: kSecondaryColor,
                                borderRadius: BorderRadius.circular(15),
                                shape: BoxShape.rectangle,
                              ),
                              child: const Center(
                                child: Text(
                                  'Мои заказы',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LevelPage(
                                    currentUser: currentUser,
                                    currentContext: currentContext,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 210,
                              margin: const EdgeInsetsDirectional.fromSTEB(
                                  5, 0, 5, 0),
                              decoration: BoxDecoration(
                                color: kSecondaryColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Center(
                                child: Text(
                                  'Прогресс уровня',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsetsDirectional.fromSTEB(10, 15, 10, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Последние заказы :',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          BlocBuilder<GetOrdersBloc, GetOrdersState>(
                            builder: (context, state) {
                              if (state is GetOrderLoadingState) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (state is GetOrderLoadedState) {
                                if (state.orders.isNotEmpty) {
                                  state.orders.sort((a, b) => a.date!
                                      .difference(DateTime.now())
                                      .abs()
                                      .compareTo(b.date!
                                          .difference(DateTime.now())
                                          .abs()));
                                  return Container(
                                    margin: const EdgeInsets.all(5),
                                    height:
                                        state.orders.length > 2 ? 545 : 272.5,
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount: state.orders.length > 2
                                          ? 2
                                          : state.orders.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return OrderCard(
                                            order: state.orders[index]);
                                      },
                                    ),
                                  );
                                } else {
                                  return Center(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: const Text(
                                        'Вы ещё не сделали\nни одного заказа',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                                }
                              }
                              if (state is GetOrderEmptyState) {
                                return Center(
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: const Text(
                                      'Вы ещё не сделали\nни одного заказа',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                              } else {
                                return const Center(
                                  child: Text('Упс...Что-то пошло не так'),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: [],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthRepository>().signOut();
                        context.read<ProfileBloc>().add(
                              LoadProfileEvent(
                                context
                                    .read<AuthorizationBloc>()
                                    .state
                                    .authUser,
                              ),
                            );
                      },
                      child: const Text('Выход'),
                    ),
                    const SizedBox(
                      height: 20.0,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
