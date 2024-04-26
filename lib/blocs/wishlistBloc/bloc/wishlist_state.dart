part of 'wishlist_bloc.dart';

abstract class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object?> get props => [];
}

class WishlistLoadingState extends WishlistState {}

class WishlistLoadedState extends WishlistState {
  final Wishlist wishlist;

  const WishlistLoadedState({required this.wishlist});

  @override
  List<Object?> get props => [wishlist];
}

class WishlistErrorState extends WishlistState {}
