import 'package:smartsoft_application/models/wishlist.dart';

abstract class BaseWishlistRepository {
  Stream<Wishlist> getWishlistById(String wishlistId);
  Stream<List<Wishlist>> getAllWishlists();
  Future<void> addProductToWishlist(String productId, Wishlist wishlist);
  Future<void> removeProductFromWishlist(String productId, Wishlist wishlist);
  Future<void> createWishlist(Wishlist wishlist);
}
