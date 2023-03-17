import 'package:emarketapp/constants/dimens/uihelper.dart';
import 'package:emarketapp/widgets/shimmer_skelton.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CarouselShimmer extends StatelessWidget {
  const CarouselShimmer({
    Key? key,
    required this.height,
    required this.width,
  }) : super(key: key);

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: Colors.black,
      child: Padding(
        padding: UiHelper.allPadding2x,
        child: SizedBox(
          width: width,
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Skelton(height: width / 100, width: width),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Skelton(height: 150, width: width / 100),
                  const Icon(
                    Icons.image,
                    size: 40,
                  ),
                  Skelton(height: 150, width: width / 100)
                ],
              ),
              Skelton(height: width / 100, width: width),
            ],
          ),
        ),
      ),
    );
  }
}
