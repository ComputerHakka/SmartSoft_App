import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsoft_application/widgets/custom_appbar.dart';

import '../blocs/comparisonBloc/bloc/comparison_bloc.dart';
import '../models/product.dart';

class ComparisonPage extends StatelessWidget {
  const ComparisonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Сравнение',
        searchActivate: false,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
          child: ListView(
            children: [
              BlocBuilder<ComparisonBloc, ComparisonState>(
                builder: (context, state) {
                  if (state is ComparisonLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is ComparisonLoadedState) {
                    if (state.comparison.products.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              dataRowHeight: 70,
                              headingRowHeight: 200,
                              showBottomBorder: true,
                              columns: _buildTableColumns(
                                  state.comparison.products, context),
                              rows: _buildTableRows(
                                  state.comparison.products, context),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '0 = 0',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '\nДля сравнения товаров нажмите\nна кнопку сравнения в ячейках\nтоваров, которые хотите сравнить',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  } else {
                    return const Center(
                      child: Text('Упс...Что-то пошло не так'),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<DataColumn> _buildTableColumns(
      List<Product> products, BuildContext context) {
    List<DataColumn> columns = [];
    for (var product in products) {
      columns.add(
        DataColumn(
          label: SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Stack(children: [
                    Image.network(
                      product.imgUrl,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: -10,
                      right: -10,
                      child: IconButton(
                        onPressed: () {
                          context
                              .read<ComparisonBloc>()
                              .add(RemoveProductFromComparisonEvent(product));
                        },
                        icon: const Icon(
                          Icons.remove_circle_outline_sharp,
                        ),
                      ),
                    ),
                  ]),
                ),
                Text(
                  product.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
      );
    }
    return columns;
  }

  List<DataRow> _buildTableRows(List<Product> products, BuildContext context) {
    List<DataRow> rows = [];
    Set<String> allCharacteristics = {};

    for (var product in products) {
      allCharacteristics.addAll(product.characteristics!.keys);
    }

    for (var characteristic in allCharacteristics) {
      int counter = 0;
      List<DataCell> cells = [];
      Color rowColor = Colors.transparent;
      for (var product in products) {
        final value = product.characteristics![characteristic];
        rowColor = _compareValues(product, characteristic, products);
        cells.add(
          DataCell(
            Container(
              height: 70,
              width: MediaQuery.of(context).size.width / 2.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      counter == 0
                          ? Text(
                              characteristic,
                              style: const TextStyle(color: Colors.black54),
                            )
                          : const Text(''),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        value != null ? value.toString() : '-',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
        counter++;
      }
      rows.add(
          DataRow(cells: cells, color: MaterialStateProperty.all(rowColor)));
    }
    return rows;
  }

  Color _compareValues(
      Product product, String characteristic, List<Product> products) {
    for (var otherProduct in products) {
      if (product != otherProduct &&
          (product.characteristics![characteristic] !=
              otherProduct.characteristics![characteristic])) {
        return Colors.orange.withOpacity(0.2);
      }
    }
    return Colors.transparent;
  }
}
