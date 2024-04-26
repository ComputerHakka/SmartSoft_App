import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smartsoft_application/blocs/navigationBloc/nav_index_bloc.dart';
import 'package:smartsoft_application/blocs/navigationBloc/nav_index_event.dart';
import 'package:smartsoft_application/blocs/navigationBloc/nav_index_state.dart';
import 'package:smartsoft_application/pages/category_page.dart';
import 'package:smartsoft_application/pages/wishlist_page.dart';
import 'package:smartsoft_application/pages/home_page.dart';
import 'package:smartsoft_application/pages/profile_page.dart';
import 'package:smartsoft_application/pages/shopping_cart_page.dart';

import 'catalog_page.dart';

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  final screens = [
    const HomePage(),
    const CatalogPage(),
    const ShoppingCartPage(),
    const WishlistPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(Icons.home, size: 30, color: HexColor('#FFFFFF')),
      Icon(Icons.menu, size: 30, color: HexColor('#FFFFFF')),
      Icon(Icons.shopping_basket, size: 30, color: HexColor('#FFFFFF')),
      Icon(Icons.favorite, size: 30, color: HexColor('#FFFFFF')),
      Icon(Icons.person, size: 30, color: HexColor('#FFFFFF')),
    ];
    return BlocBuilder<NavIndexBloc, NavIndexState>(builder: (context, state) {
      if (state is InitialState) {
        return _mainPage(context, 0, items, screens);
      }
      if (state is UpdateState) {
        return _mainPage(context, state.index, items, screens);
      }
      return Container();
    });
  }
}

Widget _mainPage(
    BuildContext context, int index, List<Widget> items, List<Widget> screens) {
  return Scaffold(
    extendBody: true,
    body: screens[index],
    bottomNavigationBar: CurvedNavigationBar(
      color: HexColor('#1E1E1E'),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      items: items,
      height: 60,
      index: index,
      onTap: (index) {
        context.read<NavIndexBloc>().add(SetIndexEvent(index: index));
      },
    ),
  );
}
