import 'package:flutter/material.dart';

class LGrid extends StatelessWidget {
  const LGrid({
    Key? key,
    required this.items,
    required this.onTileTap,
  }) : super(key: key);

  final List<Widget> items;
  final Function(int) onTileTap;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20.0),
      crossAxisSpacing: 10.0,
      crossAxisCount: 2,
      children: List.generate(
        items.length,
        (index) => InkWell(
          onTap: () {
            onTileTap(index);
          },
          child: items[index],
        ),
      ),
    );
  }
}