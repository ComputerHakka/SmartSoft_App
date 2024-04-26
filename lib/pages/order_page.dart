import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smartsoft_application/blocs/orderBloc/getOrders/get_orders_bloc.dart';
import 'package:smartsoft_application/models/address.dart';
import 'package:smartsoft_application/models/city.dart';
import 'package:smartsoft_application/models/user.dart';
import 'package:smartsoft_application/theme/app_theme.dart';

import '../blocs/addressBloc/bloc/address_bloc.dart';
import '../blocs/authBloc/bloc/authorization_bloc.dart';
import '../blocs/cartBloc/bloc/cart_bloc.dart';
import '../blocs/cityBloc/bloc/city_bloc.dart';
import '../blocs/orderBloc/bloc/order_bloc.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_textform_field_widget.dart';
import '../widgets/order_summary.dart';
import 'complete_order_page.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(
        title: 'Оформление',
        searchActivate: false,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: BlocBuilder<OrderBloc, OrderState>(
                builder: (context, state) {
                  if (state is OrderLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    );
                  }
                  if (state is OrderLoadedState) {
                    var user = state.user ?? UserModel.empty;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ИНФОРМАЦИЯ ПОКУПАТЕЛЯ',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextFormField(
                          title: 'Email',
                          readOnly: user.id!.isEmpty ? false : true,
                          initialValue: user.email,
                          onChanged: (value) {
                            context.read<OrderBloc>().add(
                                  UpdateOrderEvent(
                                    user: state.order.user!
                                        .copyWith(email: value),
                                  ),
                                );
                          },
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CustomTextFormField(
                          title: 'Имя',
                          readOnly: user.id!.isEmpty ? false : true,
                          initialValue: user.firstName,
                          onChanged: (value) {
                            context.read<OrderBloc>().add(
                                  UpdateOrderEvent(
                                    user: state.order.user!
                                        .copyWith(firstName: value),
                                  ),
                                );
                          },
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CustomTextFormField(
                          title: 'Фамилия',
                          readOnly: user.id!.isEmpty ? false : true,
                          initialValue: user.lastName,
                          onChanged: (value) {
                            context.read<OrderBloc>().add(
                                  UpdateOrderEvent(
                                    user: state.order.user!
                                        .copyWith(lastName: value),
                                  ),
                                );
                          },
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'ИНФОРМАЦИЯ О ДОСТАВКЕ',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BlocBuilder<CityBloc, CityState>(
                          builder: (context, stateC) {
                            if (stateC is CityLoadingState) {
                              return Container();
                            }
                            if (stateC is CityLoadedState) {
                              var currentCity;
                              List<DropDownValueModel> cities = [];

                              for (City city in stateC.cities) {
                                cities.add(DropDownValueModel(
                                    name: city.name, value: city));
                              }
                              cities.sort((a, b) => a.name.compareTo(b.name));
                              if (stateC.selectedCity == null) {
                                context.read<CityBloc>().add(UpdateCitiesEvent(
                                    stateC.cities,
                                    selectedCity: cities[0].value));
                              }
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: DropDownTextField(
                                      clearOption: false,
                                      onChanged: (value) {
                                        context.read<CityBloc>().add(
                                            UpdateCitiesEvent(stateC.cities,
                                                selectedCity: value.value));
                                      },
                                      initialValue: stateC.selectedCity?.name ??
                                          cities[0].name,
                                      dropDownItemCount: 4,
                                      textFieldDecoration:
                                          const InputDecoration(
                                        hintText: "Выберите город",
                                        labelText: 'Город',
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 7, horizontal: 10),
                                      ),
                                      searchDecoration: const InputDecoration(
                                        hintText: "Введите ваш город",
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 7, horizontal: 10),
                                      ),
                                      enableSearch: true,
                                      dropDownList: cities,
                                    ),
                                  ),
                                  BlocBuilder<AddressBloc, AddressState>(
                                    builder: (context, stateA) {
                                      if (stateA is AddressLoadingState) {}
                                      if (stateA is AddressLoadedState) {
                                        String initialAddress;
                                        List<DropDownValueModel> addresses = [];
                                        for (Address address
                                            in stateA.addresses) {
                                          if (address.cityId ==
                                              (stateC.selectedCity?.id ??
                                                  cities[0].value.id)) {
                                            addresses.add(DropDownValueModel(
                                                name:
                                                    'ул. ${address.street}, д. ${address.home}',
                                                value: address));
                                          }
                                        }

                                        if (addresses.isNotEmpty) {
                                          initialAddress = addresses[0].name;
                                          return Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: DropDownTextField(
                                              onChanged: (value) {
                                                context.read<AddressBloc>().add(
                                                    UpdateAddressesEvent(
                                                        stateA.addresses,
                                                        selectedAddress:
                                                            value.value));
                                                context.read<OrderBloc>().add(
                                                    UpdateOrderEvent(
                                                        addressId:
                                                            value.value.id));
                                              },
                                              clearOption: false,
                                              dropDownItemCount: 4,
                                              searchDecoration:
                                                  const InputDecoration(
                                                hintText:
                                                    "Введите адрес магазина",
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 7,
                                                        horizontal: 10),
                                              ),
                                              enableSearch: false,
                                              initialValue: initialAddress,
                                              dropDownList: addresses,
                                              textFieldDecoration:
                                                  const InputDecoration(
                                                hintText:
                                                    "Выберите адрес магазина",
                                                labelText: 'Адрес',
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 7,
                                                        horizontal: 10),
                                              ),
                                            ),
                                          );
                                        } else {
                                          return const Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                15, 15, 15, 0),
                                            child: Center(
                                              child: Text(
                                                  'Доставка в ваш город на данный момент не осуществляется :('),
                                            ),
                                          );
                                        }
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        Container(
                          height: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Оплата производится после\nполучения товаров',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'СУММА К ОПЛАТЕ',
                          style: TextStyle(fontSize: 16),
                        ),
                        OrderSummary(
                          user: user,
                        ),
                        const SizedBox(height: 5),
                        Center(
                          child: ElevatedButton(
                              onPressed: () {
                                if (state.order.user!.email.isEmpty ||
                                    state.order.user!.firstName.isEmpty ||
                                    state.order.user!.lastName.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      elevation: 5,
                                      duration: Duration(seconds: 2),
                                      behavior: SnackBarBehavior.floating,
                                      margin:
                                          EdgeInsets.fromLTRB(20, 0, 20, 30),
                                      content: Text(
                                        'Заполнена не вся информация о заказчике',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                } else {
                                  if (!RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(state.order.user!.email)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        elevation: 5,
                                        duration: Duration(seconds: 2),
                                        behavior: SnackBarBehavior.floating,
                                        margin:
                                            EdgeInsets.fromLTRB(20, 0, 20, 30),
                                        content: Text(
                                          'Введен некорректный Email',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  } else {
                                    context.read<OrderBloc>().add(
                                        ConfirmOrderEvent(order: state.order));
                                    context
                                        .read<CartBloc>()
                                        .add(ClearCartEvent());
                                    context.read<GetOrdersBloc>().add(
                                        LoadOrdersEvent(
                                            user: context
                                                .read<AuthorizationBloc>()
                                                .state
                                                .user));
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CompleteOrderPage(
                                                  user: state.order.user!,
                                                )));
                                  }
                                }
                              },
                              child: const Text('Подтвердить')),
                        )
                      ],
                    );
                  } else {
                    return const Text('Упс..Что-то пошло не так');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
