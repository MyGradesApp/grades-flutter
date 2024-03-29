import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:grade_core/grade_core.dart';
import 'package:sis_loader/sis_loader.dart';

class DummyGrade implements Grade {
  double _gradePercent;
  String _category;
  String _name;

  @override
  DummyGrade(double grade, String cat, int index) {
    _gradePercent = grade;
    _category = cat;
    _name = 'Dummy Assignment ' + (index + 1).toString();
  }

  @override
  String get name => _name;

  @override
  String get category => _category;

  @override
  GradeBuilder toBuilder() {
    throw UnimplementedError();
  }

  @override
  DateTime get assignedDate => DateTime.now();

  @override
  DateTime get dateLastModified => DateTime.now();

  @override
  DateTime get dueDate => DateTime.now();

  @override
  Grade rebuild(any) {
    throw UnimplementedError();
  }

  @override
  String get comment => throw UnimplementedError();

  @override
  String get letter => normalLetter;

  @override
  String get pointsEarned => _gradePercent.toString();

  @override
  String get pointsPossible => '100';

  @override
  String get rawAssignedDate => throw UnimplementedError();

  @override
  String get rawDueDate => throw UnimplementedError();

  @override
  String get rawUpdatedAt => throw UnimplementedError();

  @override
  String get rawLetter => throw UnimplementedError();

  @override
  String get displayGrade => '${_gradePercent.round()}%';

  @override
  String get normalLetter => letterGradeForPercent(percentage);

  @override
  double get percentage => _gradePercent;

  @override
  // TODO: implement pointsEarnedRaw
  StringOrNum get pointsEarnedRaw => throw UnimplementedError();

  @override
  // TODO: implement pointsPossibleRaw
  StringOrNum get pointsPossibleRaw => throw UnimplementedError();
}

Future<DummyGrade> createDummyGradePopup(BuildContext context,
    BuiltMap<String, String> weights, List<DummyGrade> dummyGrades) async {
  var GradePickerArray = <List<dynamic>>[];
  DummyGrade grade;
  var percentList = <int>[];
  for (var i = 100; i >= 0; i--) {
    percentList.add(i);
  }
  GradePickerArray.add(percentList);
  if (weights != null) {
    if (weights.entries.isNotEmpty) {
      var categoryList = <String>[];
      for (var weight in weights.entries) {
        // print('${weight.key}, ${weight.value}');
        categoryList.add(weight.key);
      }
      GradePickerArray.add(categoryList);
    }
  }

  await Picker(
      adapter: PickerDataAdapter<String>(
          pickerdata: GradePickerArray, isArray: true),
      hideHeader: true,
      backgroundColor: Colors.transparent,
      textStyle:
          TextStyle(color: Theme.of(context).primaryColorLight, fontSize: 19),
      title: Column(children: [
        Padding(
          padding: EdgeInsets.only(bottom: 7),
          child: Center(
            child: Text('Grade Calculator'),
          ),
        ),
        Row(children: [
          Icon(Icons.info_outline),
          Expanded(
            child: Text(
              'The data presented by this utility may not be entirely accurate.',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          ),
        ]),
        Text(
          'Use at your own risk.',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
          textAlign: TextAlign.center,
        ),
      ]),
      confirmText: 'Add Dummy Grade',
      onConfirm: (Picker picker, List value) {
        var values = picker.getSelectedValues();
        grade = DummyGrade(int.parse(values.first as String).toDouble(),
            values.last.toString(), dummyGrades.length);
      }).showDialog(context);
  return grade;
}

Future<Grade> removeDummyGradePopup(BuildContext context, Grade grade) async {
  Grade gradeToRemove;
  if (Platform.isIOS) {
    await showDialog<CupertinoAlertDialog>(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text('Remove Dummy Grade?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('Remove'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    gradeToRemove = grade;
                  },
                )
              ],
            ));
  } else {
    await showDialog<AlertDialog>(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Remove Dummy Grade?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('Remove'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    gradeToRemove = grade;
                  },
                )
              ],
            ));
  }
  return gradeToRemove;
}
