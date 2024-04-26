import 'package:flutter/material.dart';
import 'package:smartsoft_application/models/brand.dart';

import '../pages/brand_page.dart';

class BrandCard extends StatelessWidget {
  final Brand brand;
  const BrandCard({super.key, required this.brand});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BrandPage(brand: brand),
          ),
        );
      },
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          margin: const EdgeInsets.all(5.0),
          width: MediaQuery.of(context).size.width * 0.5 - 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.network(
              brand.imgUrl!,
            ),
          ),
        ),
      ),
    );
  }
}
