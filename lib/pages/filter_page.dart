import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsoft_application/blocs/categoryBloc/bloc/category_bloc.dart';
import 'package:smartsoft_application/models/category.dart';
import 'package:smartsoft_application/widgets/custom_appbar.dart';

import '../blocs/brandBloc/bloc/brand_bloc.dart';
import '../blocs/filterBloc/bloc/filter_bloc.dart';
import '../models/brand.dart';
import '../repositories/category/category_repository.dart';
import 'brands_filter_page.dart';

List<String> categories = [];

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  RangeValues _priceRange = const RangeValues(1000, 300000);
  TextEditingController _minPriceController = TextEditingController();
  TextEditingController _maxPriceController = TextEditingController();
  Category? _selectedCategory;
  List<Brand> _selectedBrands = [];
  List<String> _selectedBrandsNames = [];
  List<Brand> _brands = [];
  bool _sortByName = true;
  bool _sortByPrice = false;
  bool _sortNameDescending = false;
  bool _sortPriceDescending = false;

  @override
  void initState() {
    super.initState();
    final filterState = context.read<FilterBloc>().state;
    if (filterState is FilterLoadedState) {
      final brandState = context.read<BrandBloc>().state;
      if (brandState is BrandLoadedState) {
        _minPriceController.text =
            (filterState.minPrice ?? _priceRange.start).round().toString();
        _maxPriceController.text =
            (filterState.maxPrice ?? _priceRange.end).round().toString();
        _brands = brandState.brands;
        _selectedBrands = filterState.brands!;
        _selectedBrandsNames =
            _selectedBrands.map((brand) => brand.name).toList();
        _selectedCategory = filterState.category;
        _priceRange = RangeValues(
            (filterState.minPrice ?? _priceRange.start).toDouble(),
            (filterState.maxPrice ?? _priceRange.end).toDouble());
        _sortByName = filterState.sortByName;
        _sortByPrice = filterState.sortByPrice;
        _sortNameDescending = filterState.sortNameDescending;
        _sortPriceDescending = filterState.sortPriceDescending;
      }
    } else {
      _minPriceController.text = _priceRange.start.round().toString();
      _maxPriceController.text = _priceRange.end.round().toString();
      final brandState = context.read<BrandBloc>().state;
      if (brandState is BrandLoadedState) {
        _brands = brandState.brands;
      }
    }
  }

  void _navigateToBrandsPage() async {
    final selectedBrands = await Navigator.push<List<Brand>>(
      context,
      MaterialPageRoute(
        builder: (context) => FilterBrandsPage(
          brands: _brands,
          selectedBrands: _selectedBrands,
        ),
      ),
    );

    if (selectedBrands != null) {
      setState(() {
        _selectedBrands = selectedBrands;
        _selectedBrandsNames =
            selectedBrands.map((brand) => brand.name).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Фильтры',
        searchActivate: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ценовой диапазон',
              style: TextStyle(fontSize: 18),
            ),
            RangeSlider(
              values: _priceRange,
              min: 1000,
              max: 300000,
              divisions: 150,
              onChanged: (RangeValues values) {
                setState(() {
                  _priceRange = values;
                  _minPriceController.text = values.start.round().toString();
                  _maxPriceController.text = values.end.round().toString();
                });
              },
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Мин. цена: ${_priceRange.start.round()}'),
                Text('Макс. цена: ${_priceRange.end.round()}'),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Категория',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryLoadedState) {
                  return DropDownTextField(
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value.value;
                      });
                    },
                    clearOption: false,
                    dropDownItemCount: 4,
                    enableSearch: false,
                    initialValue: _selectedCategory != null
                        ? _selectedCategory!.name
                        : 'Все',
                    dropDownList: state.categories.map((category) {
                      return DropDownValueModel(
                          name: category.name, value: category);
                    }).toList(),
                    textFieldDecoration: const InputDecoration(
                      hintText: "Выберите категорию",
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Производители',
              style: TextStyle(fontSize: 18),
            ),
            InkWell(
              onTap: _navigateToBrandsPage,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedBrands.isNotEmpty
                          ? _selectedBrandsNames.join(', ')
                          : 'Выберите производителей',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Сортировка',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            DropDownTextField(
              onChanged: (value) {
                setState(() {
                  if (value.name == 'А-Я по наименованию') {
                    _sortByName = true;
                    _sortNameDescending = false;
                    _sortByPrice = false;
                    _sortPriceDescending = false;
                  }
                  if (value.name == 'Я-А по наименованию') {
                    _sortByName = true;
                    _sortNameDescending = true;
                    _sortByPrice = false;
                    _sortPriceDescending = false;
                  }
                  if (value.name == 'По возрастанию цены') {
                    _sortByName = false;
                    _sortNameDescending = false;
                    _sortByPrice = true;
                    _sortPriceDescending = false;
                  }
                  if (value.name == 'По убыванию цены') {
                    _sortByName = false;
                    _sortNameDescending = false;
                    _sortByPrice = true;
                    _sortPriceDescending = true;
                  }
                });
              },
              clearOption: false,
              dropDownItemCount: 4,
              enableSearch: false,
              initialValue: _sortByName && !_sortNameDescending
                  ? 'А-Я по наименованию'
                  : _sortByName && _sortNameDescending
                      ? 'Я-А по наименованию'
                      : _sortByPrice && !_sortPriceDescending
                          ? 'По возрастанию цены'
                          : 'По убыванию цены',
              dropDownList: [
                DropDownValueModel(
                    name: 'А-Я по наименованию', value: _sortByName),
                DropDownValueModel(
                    name: 'Я-А по наименованию', value: _sortNameDescending),
                DropDownValueModel(
                    name: 'По возрастанию цены', value: _sortByPrice),
                DropDownValueModel(
                    name: 'По убыванию цены', value: _sortPriceDescending)
              ],
              textFieldDecoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 7, horizontal: 10),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      context.read<FilterBloc>().add(LoadFilterEvent());
                      setState(() {
                        _priceRange = const RangeValues(1000, 300000);
                        _minPriceController.text =
                            _priceRange.start.round().toString();
                        _maxPriceController.text =
                            _priceRange.end.round().toString();
                        _selectedCategory = null;
                        _selectedBrands = [];
                        _selectedBrandsNames = [];
                        _brands = [];
                        _sortByName = true;
                        _sortByPrice = false;
                        _sortNameDescending = false;
                        _sortPriceDescending = false;
                      });
                    },
                    child: const Text('Сброс'),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FilterBloc>().add(FilterProductEvent(
                            minPrice: _priceRange.start.toInt(),
                            maxPrice: _priceRange.end.toInt(),
                            brands: _selectedBrands,
                            category: _selectedCategory,
                            sortByName: _sortByName,
                            sortByPrice: _sortByPrice,
                            sortNameDescending: _sortNameDescending,
                            sortPriceDescending: _sortPriceDescending,
                          ));
                      Navigator.pop(context);
                    },
                    child: const Text('Применить'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
