part of 'wishlist_bloc.dart';

abstract class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object?> get props => [];
}

class LoadWishlistEvent extends WishlistEvent {
  final Wishlist wishlist;
  final List<Product>? products;

  const LoadWishlistEvent(
      {required this.wishlist, this.products = const <Product>[]});
}

class GetWishlistEvent extends WishlistEvent {
  final UserModel? user;

  const GetWishlistEvent(this.user);

  @override
  List<Object?> get props => [user];
}

class UpdateWishlistEvent extends WishlistEvent {
  final Wishlist wishlist;

  const UpdateWishlistEvent({
    required this.wishlist,
  });

  @override
  List<Object?> get props => [wishlist];
}

class GetProductsToWishlistEvent extends WishlistEvent {
  final List<Product> products;

  const GetProductsToWishlistEvent({required this.products});
}

class AddProductToWishlistEvent extends WishlistEvent {
  final Product product;
  final Wishlist wishlist;

  const AddProductToWishlistEvent(
      {required this.product, required this.wishlist});
}

class RemoveProductToWishlistEvent extends WishlistEvent {
  final Product product;
  final Wishlist wishlist;

  const RemoveProductToWishlistEvent(
      {required this.product, required this.wishlist});
}

class WishlistNotExistEvent extends WishlistEvent {}
