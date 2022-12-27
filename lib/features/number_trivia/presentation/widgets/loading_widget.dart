import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      // to make the text scrollable we wrap it with the SingleChildScrollView
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
