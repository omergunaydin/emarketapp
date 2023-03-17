import 'package:flutter/material.dart';

import '../../constants/values/colors.dart';

class ProductImage extends StatelessWidget {
  final String resim;
  const ProductImage({Key? key, required this.resim}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Image.network(
            resim,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(
                child: CircularProgressIndicator(
                  color: UiColorHelper.mainYellow,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
