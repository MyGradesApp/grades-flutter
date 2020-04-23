import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HeaderedGroup<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final Widget Function(T) builder;

  HeaderedGroup(this.title, this.items, this.builder);

  @override
  Widget build(BuildContext context) {
    if (items.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 11.0),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, i) {
              return builder(items[i]);
            },
          ),
        ],
      );
    } else {
      // No items in this course, so we don't display anything
      return Container();
    }
  }
}
