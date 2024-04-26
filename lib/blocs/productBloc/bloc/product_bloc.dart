import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/product.dart';
import '../../../repositories/product/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;
  StreamSubscription? _productSubscription;
  ProductBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(ProductLoadingState()) {
    on<LoadProductsEvent>(_onLoadProducts);
    on<UpdateProductsEvent>(_onUpdateProducts);
    on<GetProductEvent>(_onGetProducts);
  }

  void _onLoadProducts(event, Emitter<ProductState> emit) {
    _productSubscription?.cancel();
    _productSubscription = _productRepository.getAllProducts().listen(
          (products) => add(
            UpdateProductsEvent(products),
          ),
        );
  }

  void _onUpdateProducts(event, Emitter<ProductState> emit) {
    emit(ProductLoadedState(products: event.products));
  }

  void _onGetProducts(GetProductEvent event, Emitter<ProductState> emit) {
    List<Product> currentProducts = [];

    for (String id in event.productIds) {
      _productSubscription?.cancel();
      _productSubscription =
          _productRepository.getProductById(id).listen((product) {
        currentProducts.add(product);
        if (currentProducts.length == event.productIds.length) {
          add(UpdateProductsEvent(currentProducts));
        }
      });
    }
  }
}
