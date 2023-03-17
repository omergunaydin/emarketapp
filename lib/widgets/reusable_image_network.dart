import 'package:flutter/material.dart';

class ReusableImage extends StatelessWidget {
  String url;
  double? width;
  double? height;
  BoxFit? fit;
  ReusableImage({Key? key, required this.url, this.width, this.height, this.fit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: fit,
      width: width,
      height: height,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
          ),
        );
      },
    );
  }
}
