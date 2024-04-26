import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:smartsoft_application/models/product.dart';
import 'package:smartsoft_application/models/user.dart';

class OrderModel extends Equatable {
  final UserModel? user;
  final List<Product>? products;

  final String? id;
  final String? addressId;
  final String? clientEmail;
  final String? clientLastName;
  final String? clientName;
  final DateTime? date;
  final bool? isPaid;
  final Map<String, dynamic>? productsFromBase;
  final String? statusId;
  final int? totalPrice;

  const OrderModel({
    this.user = UserModel.empty,
    this.products,
    this.addressId,
    this.clientEmail,
    this.clientLastName,
    this.clientName,
    this.date,
    this.id,
    this.isPaid,
    this.productsFromBase,
    this.statusId,
    this.totalPrice,
  });

  @override
  List<Object?> get props => [
        user,
        products,
        addressId,
        statusId,
        productsFromBase,
        isPaid,
        clientEmail,
        clientLastName,
        clientName,
        totalPrice,
        date,
        id
      ];

  Map productQuantity(List<Product> products) {
    var quantity = Map();

    for (var product in products) {
      if (!quantity.containsKey(product.id)) {
        quantity[product.id] = 1;
      } else {
        quantity[product.id] += 1;
      }
    }

    return quantity;
  }

  Map<String, Object> toDocument() {
    return {
      'clientEmail': user?.email ?? UserModel.empty.email,
      'clientName': user?.firstName ?? UserModel.empty.firstName,
      'clientLastName': user?.lastName ?? UserModel.empty.lastName,
      'date': Timestamp.fromDate(DateTime.now()),
      'isPaid': false,
      'statusID': '5ysB07cxIx3B6Qjw0HIR',
      'addressID': addressId!,
      'products': productQuantity(products!),
      'totalPrice': totalPrice!,
    };
  }

  static OrderModel fromSnapshot(DocumentSnapshot snap) {
    OrderModel order = OrderModel(
        id: snap.id,
        clientEmail: snap['clientEmail'],
        clientLastName: snap['clientLastName'],
        clientName: snap['clientName'],
        date: snap['date'].toDate(),
        isPaid: snap['isPaid'],
        statusId: snap['statusID'],
        addressId: snap['addressID'],
        productsFromBase: snap['products'],
        totalPrice: snap['totalPrice']);
    return order;
  }
}
