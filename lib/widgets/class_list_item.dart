import 'package:flutter/material.dart';
import 'package:sis_loader/sis_loader.dart' show StringOrInt;

import 'colored_grade_dot.dart';

class ClassListItem extends StatelessWidget {
  ClassListItem(
      {@required this.course,
      @required this.teacher,
      @required this.letterGrade,
      @required this.percent,
      this.onTap})
      : assert(course != null),
        assert(teacher != null);

  final String course;
  final String teacher;
  final String letterGrade;

  final StringOrInt percent;
  final void Function() onTap;

  Widget _buildColumn(String topText, String bottomText,
      CrossAxisAlignment alignment, Color textColor,
      {bool chevron = false, String grade}) {
    return Column(
      crossAxisAlignment: alignment,
      children: <Widget>[
        AnimatedOpacity(
          opacity: topText == '' ? 0 : 1,
          duration: Duration(milliseconds: 150),
          child: Text(
            topText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 19,
              color: textColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
          child: Container(
            child: Row(
              children: <Widget>[
                if (grade != null) ColoredGradeDot.grade(grade),
                const SizedBox(width: 3),
                Text(
                  bottomText,
                  style: TextStyle(fontSize: 15, color: textColor),
                ),
                if (chevron)
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.black26,
                  )
              ],
            ),
          ),
          padding: const EdgeInsets.only(top: 30),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var fmt_percent = _formatPercent(percent);

    return Card(
      color: Theme.of(context).cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10.5, vertical: 6.5),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: onTap,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 15),
          child: Row(children: <Widget>[
            Expanded(
              child: _buildColumn(
                course,
                teacher.replaceAll('  ', ' '),
                CrossAxisAlignment.start,
                Theme.of(context).primaryColorLight,
              ),
            ),
            _buildColumn(
              fmt_percent,
              letterGrade ?? '',
              CrossAxisAlignment.end,
              Theme.of(context).primaryColorLight,
              chevron: true,
              grade: letterGrade,
            ),
          ]),
        ),
      ),
    );
  }

  String _formatPercent(StringOrInt percent) {
    if (percent == null) {
      return '';
    } else if (percent.isInt) {
      return '${percent.integer}%';
    } else {
      if (percent.string == 'Not Graded') {
        return 'N/A';
      } else {
        // Handle string cases that aren't `Not Graded`
        return percent.string;
      }
    }
  }
}
