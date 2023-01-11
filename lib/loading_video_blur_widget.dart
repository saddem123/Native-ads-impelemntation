import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

class LoadingVideoBlurWidget extends StatelessWidget {
  final String? hashThumbnail;
  const LoadingVideoBlurWidget({Key? key,this.hashThumbnail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlurHash(hash: hashThumbnail=='' ? "L00cGya#j[a}bHazWojbbHazjbfQ":hashThumbnail!,duration:Duration(milliseconds: 0));
  }
}

