import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';

class ProfileScreenLoading extends StatelessWidget {
  const ProfileScreenLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ProfilePageShimmer(),
    );
  }
}
