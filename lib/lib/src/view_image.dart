import 'dart:core';

import 'package:flutter/material.dart';


class ViewImage extends StatelessWidget {
  const ViewImage({Key? key, required this.image}) : super(key: key);
  final Image image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View image'),
        centerTitle: true,
      ),
      body: image,
    );
  }
}
