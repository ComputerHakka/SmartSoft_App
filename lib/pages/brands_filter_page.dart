import 'package:flutter/material.dart';
import 'package:smartsoft_application/theme/app_theme.dart';
import 'package:smartsoft_application/widgets/custom_appbar.dart';

import '../models/brand.dart';

class FilterBrandsPage extends StatefulWidget {
  final List<Brand> brands;
  final List<Brand> selectedBrands;
  const FilterBrandsPage({
    super.key,
    required this.brands,
    this.selectedBrands = const <Brand>[],
  });

  @override
  State<FilterBrandsPage> createState() => _FilterBrandsPageState();
}

class _FilterBrandsPageState extends State<FilterBrandsPage> {
  List<Brand> _selectedBrands = [];

  @override
  void initState() {
    super.initState();
    for (Brand brand in widget.selectedBrands) {
      _selectedBrands.add(brand);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Производители',
        searchActivate: false,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        height: double.infinity,
        child: ListView.builder(
          itemCount: widget.brands.length,
          itemBuilder: (context, index) {
            final brand = widget.brands[index];
            final isSelected = _selectedBrands.contains(brand);
            return ListTile(
              title: Text(brand.name),
              trailing: Checkbox(
                value: isSelected,
                onChanged: (bool? value) {
                  setState(() {
                    if (value != null && value) {
                      _selectedBrands.add(brand);
                    } else {
                      _selectedBrands.remove(brand);
                    }
                  });
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kAccentColor,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.pop(context, _selectedBrands);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
