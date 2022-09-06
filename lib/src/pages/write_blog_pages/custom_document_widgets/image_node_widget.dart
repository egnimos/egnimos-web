import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';

class ImageNodeWidget extends StatelessWidget {
  const ImageNodeWidget({
    Key? key,
    required this.node,
    required this.padding,
  }) : super(key: key);
  final ImageNode node;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        children: [
          //image
          Image.network(
            node.imageUrl,
            fit: BoxFit.contain,
          ),

          const SizedBox(
            height: 10.0,
          ),

          //src
          Text(
            node.altText,
            style: const TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}
