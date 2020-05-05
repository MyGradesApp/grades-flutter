import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HeaderedGroup<T> extends StatelessWidget {
  final String title;
  final List<T> children;
  final Widget Function(T) builder;
  final String subtitle;
  final int maxCount;

  HeaderedGroup({
    @required this.title,
    this.subtitle,
    @required this.children,
    this.maxCount,
    @required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    if (children.isNotEmpty) {
      var displayedChildren =
          maxCount == null ? children.length : min(children.length, maxCount);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 11.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
              ],
            ),
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: displayedChildren + 1,
            itemBuilder: (context, i) {
              if (i == displayedChildren) {
                if (maxCount != null && children.length > maxCount) {
                  return Text('and ${children.length - maxCount} more');
                }
                return Container();
              }
              return builder(children[i]);
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
