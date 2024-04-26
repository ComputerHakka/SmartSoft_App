import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsoft_application/blocs/addressBloc/bloc/address_bloc.dart';
import 'package:smartsoft_application/blocs/authBloc/bloc/authorization_bloc.dart';
import 'package:smartsoft_application/blocs/brandBloc/bloc/brand_bloc.dart';
import 'package:smartsoft_application/blocs/cartBloc/bloc/cart_bloc.dart';
import 'package:smartsoft_application/blocs/categoryBloc/bloc/category_bloc.dart';
import 'package:smartsoft_application/blocs/cityBloc/bloc/city_bloc.dart';
import 'package:smartsoft_application/blocs/filterBloc/bloc/filter_bloc.dart';
import 'package:smartsoft_application/blocs/navigationBloc/nav_index_bloc.dart';
import 'package:smartsoft_application/blocs/orderBloc/getOrders/get_orders_bloc.dart';
import 'package:smartsoft_application/blocs/searchBloc/bloc/search_bloc.dart';
import 'package:smartsoft_application/blocs/statusBloc/bloc/status_bloc.dart';
import 'package:smartsoft_application/blocs/wishlistBloc/bloc/wishlist_bloc.dart';
import 'package:smartsoft_application/cubits/authorization/auth_cubit.dart';
import 'package:smartsoft_application/pages/main_page.dart';
import 'package:smartsoft_application/repositories/address/address_repository.dart';
import 'package:smartsoft_application/repositories/authorization/auth_repository.dart';
import 'package:smartsoft_application/repositories/brand/brand_repository.dart';
import 'package:smartsoft_application/repositories/category/category_repository.dart';
import 'package:smartsoft_application/repositories/city/city_repository.dart';
import 'package:smartsoft_application/repositories/review/review_repository.dart';
import 'package:smartsoft_application/repositories/status/status_repository.dart';
import 'package:smartsoft_application/repositories/user/user_repository.dart';
import 'package:smartsoft_application/repositories/wishlist/wishlist_repository.dart';
import 'package:smartsoft_application/theme/app_theme.dart';

import 'blocs/comparisonBloc/bloc/comparison_bloc.dart';
import 'blocs/orderBloc/bloc/order_bloc.dart';
import 'blocs/productBloc/bloc/product_bloc.dart';
import 'blocs/reviewBloc/bloc/review_bloc.dart';
import 'cubits/registration/reg_cubit.dart';
import 'firebase_options.dart';
import 'repositories/order/order_repository.dart';
import 'repositories/product/product_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    runApp(const NoConnection());
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
  }
}

class NoConnection extends StatelessWidget {
  const NoConnection({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      title: 'SmartSoft',
      home: const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Увы (',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Отсутствует подключение к интернету',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => UserRepository(),
        ),
        RepositoryProvider(
          create: (context) => AuthRepository(
            userRepository: context.read<UserRepository>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthorizationBloc(
              authRepository: context.read<AuthRepository>(),
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider<NavIndexBloc>(create: (context) => NavIndexBloc()),
          BlocProvider(
            create: (_) => CategoryBloc(
              categoryRepository: CategoryRepository(),
            )..add(LoadCategoriesEvent()),
          ),
          BlocProvider(
            create: (_) => BrandBloc(
              brandRepository: BrandRepository(),
            )..add(const LoadBrandsEvent()),
          ),
          BlocProvider(
            create: (_) => CityBloc(
              cityRepository: CityRepository(),
            )..add(LoadCitiesEvent()),
          ),
          BlocProvider(
            create: (_) => AddressBloc(
              addressRepository: AddressRepository(),
            )..add(LoadAddressesEvent()),
          ),
          BlocProvider(
            create: (context) => ReviewBloc(
              reviewRepository: ReviewRepository(),
              userRepository: UserRepository(),
            )..add(LoadReviewsEvent()),
          ),
          BlocProvider(
            create: (context) => ProductBloc(
              productRepository: ProductRepository(),
            )..add(LoadProductsEvent()),
          ),
          BlocProvider(
            create: (_) => StatusBloc(
              statusRepository: StatusRepository(),
            )..add(LoadStatusesEvent()),
          ),
          BlocProvider(
            create: (context) => AuthCubit(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => RegistrationCubit(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => CartBloc()..add(LoadCartEvent()),
          ),
          BlocProvider(
            create: (context) => ComparisonBloc()..add(LoadComparisonEvent()),
          ),
          BlocProvider(
            create: (context) =>
                SearchBloc(productBloc: context.read<ProductBloc>())
                  ..add(LoadSearchEvent()),
          ),
          BlocProvider(
            create: (context) =>
                FilterBloc(productBloc: context.read<ProductBloc>())
                  ..add(LoadFilterEvent()),
          ),
          BlocProvider(
            create: (context) => WishlistBloc(
              authorizationBloc: context.read<AuthorizationBloc>(),
              wishlistRepository: WishlistRepository(),
              productRepository: ProductRepository(),
            )..add(
                GetWishlistEvent(context.read<AuthorizationBloc>().state.user)),
          ),
          BlocProvider(
            create: (context) => OrderBloc(
              authBloc: context.read<AuthorizationBloc>(),
              cartBloc: context.read<CartBloc>(),
              orderRepository: OrderRepository(),
            ),
          ),
          BlocProvider(
            create: (context) => GetOrdersBloc(
              orderRepository: OrderRepository(),
              authorizationBloc: context.read<AuthorizationBloc>(),
            )..add(LoadOrdersEvent(
                user: context.read<AuthorizationBloc>().state.user)),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SmartSoft',
          theme: appTheme(),
          home: MainPage(),
        ),
      ),
    );
  }
}
