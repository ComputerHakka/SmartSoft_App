import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smartsoft_application/blocs/authBloc/bloc/authorization_bloc.dart';
import 'package:smartsoft_application/models/wishlist.dart';
import 'package:smartsoft_application/repositories/product/product_repository.dart';
import 'package:smartsoft_application/repositories/wishlist/wishlist_repository.dart';

import '../../../models/product.dart';
import '../../../models/user.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final AuthorizationBloc _authorizationBloc;
  final WishlistRepository _wishlistRepository;
  final ProductRepository _productRepository;
  StreamSubscription? _authSubscription;
  StreamSubscription? _wishlistSubscription;
  StreamSubscription? _productSubscription;

  WishlistBloc(
      {required AuthorizationBloc authorizationBloc,
      required WishlistRepository wishlistRepository,
      required ProductRepository productRepository})
      : _authorizationBloc = authorizationBloc,
        _wishlistRepository = wishlistRepository,
        _productRepository = productRepository,
        super(WishlistLoadingState()) {
    on<LoadWishlistEvent>(_onLoadWishlist);
    on<UpdateWishlistEvent>(_onUpdateWishlist);
    on<WishlistNotExistEvent>(_onWishlistNotExist);
    on<AddProductToWishlistEvent>(_onAddProducttoWishlist);
    on<GetWishlistEvent>(_onGetWishlist);
    on<RemoveProductToWishlistEvent>(_onRemoveProductFromWishlist);

    _authSubscription = _authorizationBloc.stream.listen(
      (state) {
        if (state.status == AuthorizationStatus.unauthenticated) {
          add(WishlistNotExistEvent());
        } else {
          add(GetWishlistEvent(state.user!));
        }
      },
    );
  }

  void _onGetWishlist(GetWishlistEvent event, Emitter<WishlistState> emit) {
    if (event.user == null) {
      add(WishlistNotExistEvent());
    } else {
      List<Wishlist> currentWishlist = [];
      _wishlistSubscription?.cancel();
      _wishlistSubscription =
          _wishlistRepository.getAllWishlists().listen((wishlists) {
        currentWishlist = wishlists
            .where((w) => w.userId.contains(event.user!.id.toString()))
            .toList();
        if (currentWishlist.isNotEmpty) {
          add(UpdateWishlistEvent(wishlist: currentWishlist[0]));
        } else {
          add(WishlistNotExistEvent());
        }
      });
    }
  }

  void _onUpdateWishlist(
      UpdateWishlistEvent event, Emitter<WishlistState> emit) async {
    var currentWishlist = event.wishlist;
    var completedOperations = 0;
    var totalOperations = event.wishlist.productsIDs!.length;
    List<Product> pro = [];
    _productSubscription?.cancel();
    if (totalOperations != 0) {
      for (var id in event.wishlist.productsIDs!) {
        _productSubscription =
            _productRepository.getProductById(id).listen((product) {
          pro.add(product);
          completedOperations++;
          if (completedOperations == totalOperations) {
            add(LoadWishlistEvent(
              wishlist: currentWishlist,
              products: pro,
            ));
          }
        });
      }
    } else {
      add(LoadWishlistEvent(
        wishlist: currentWishlist,
        products: pro,
      ));
    }
  }

  void _onLoadWishlist(LoadWishlistEvent event, Emitter<WishlistState> emit) {
    emit(
      WishlistLoadedState(
        wishlist: Wishlist(
            id: event.wishlist.id,
            userId: event.wishlist.userId,
            productsIDs: event.wishlist.productsIDs,
            products: event.products),
      ),
    );
  }

  void _onWishlistNotExist(
      WishlistNotExistEvent event, Emitter<WishlistState> emit) {
    emit(WishlistErrorState());
  }

  void _onAddProducttoWishlist(
      AddProductToWishlistEvent event, Emitter<WishlistState> emit) async {
    await _wishlistRepository.addProductToWishlist(
        event.product.id, event.wishlist);
    List<Wishlist> currentWishlist = [];
    _wishlistSubscription?.cancel();
    _wishlistSubscription =
        _wishlistRepository.getAllWishlists().listen((wishlists) {
      currentWishlist = wishlists
          .where((w) => w.userId.contains(event.wishlist.userId.toString()))
          .toList();
      if (currentWishlist.isNotEmpty) {
        add(UpdateWishlistEvent(wishlist: currentWishlist[0]));
      } else {
        add(WishlistNotExistEvent());
      }
    });
  }

  void _onRemoveProductFromWishlist(
      RemoveProductToWishlistEvent event, Emitter<WishlistState> emit) async {
    await _wishlistRepository.removeProductFromWishlist(
        event.product.id, event.wishlist);
    List<Wishlist> currentWishlist = [];
    _wishlistSubscription?.cancel();
    _wishlistSubscription =
        _wishlistRepository.getAllWishlists().listen((wishlists) {
      currentWishlist = wishlists
          .where((w) => w.userId.contains(event.wishlist.userId.toString()))
          .toList();
      if (currentWishlist.isNotEmpty) {
        add(UpdateWishlistEvent(wishlist: currentWishlist[0]));
      } else {
        add(WishlistNotExistEvent());
      }
    });
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
