// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<GradeData> _$gradeDataSerializer = new _$GradeDataSerializer();
Serializer<Course> _$courseSerializer = new _$CourseSerializer();

class _$GradeDataSerializer implements StructuredSerializer<GradeData> {
  @override
  final Iterable<Type> types = const [GradeData, _$GradeData];
  @override
  final String wireName = 'GradeData';

  @override
  Iterable<Object> serialize(Serializers serializers, GradeData object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.grades != null) {
      result
        ..add('grades')
        ..add(serializers.serialize(object.grades,
            specifiedType:
                const FullType(BuiltList, const [const FullType(Grade)])));
    }
    if (object.weights != null) {
      result
        ..add('weights')
        ..add(serializers.serialize(object.weights,
            specifiedType: const FullType(BuiltMap,
                const [const FullType(String), const FullType(String)])));
    }
    return result;
  }

  @override
  GradeData deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new GradeDataBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'grades':
          result.grades.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(Grade)]))
              as BuiltList<Object>);
          break;
        case 'weights':
          result.weights.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap,
                  const [const FullType(String), const FullType(String)])));
          break;
      }
    }

    return result.build();
  }
}

class _$CourseSerializer implements StructuredSerializer<Course> {
  @override
  final Iterable<Type> types = const [Course, _$Course];
  @override
  final String wireName = 'Course';

  @override
  Iterable<Object> serialize(Serializers serializers, Course object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'courseName',
      serializers.serialize(object.courseName,
          specifiedType: const FullType(String)),
      'periodString',
      serializers.serialize(object.periodString,
          specifiedType: const FullType(String)),
      'teacherName',
      serializers.serialize(object.teacherName,
          specifiedType: const FullType(String)),
    ];
    if (object.gradesUrl != null) {
      result
        ..add('gradesUrl')
        ..add(serializers.serialize(object.gradesUrl,
            specifiedType: const FullType(String)));
    }
    if (object.gradePercent != null) {
      result
        ..add('gradePercent')
        ..add(serializers.serialize(object.gradePercent,
            specifiedType: const FullType(StringOrInt)));
    }
    if (object.gradeLetter != null) {
      result
        ..add('gradeLetter')
        ..add(serializers.serialize(object.gradeLetter,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  Course deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new CourseBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'gradesUrl':
          result.gradesUrl = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'courseName':
          result.courseName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'periodString':
          result.periodString = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'teacherName':
          result.teacherName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'gradePercent':
          result.gradePercent = serializers.deserialize(value,
              specifiedType: const FullType(StringOrInt)) as StringOrInt;
          break;
        case 'gradeLetter':
          result.gradeLetter = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$GradeData extends GradeData {
  @override
  final BuiltList<Grade> grades;
  @override
  final BuiltMap<String, String> weights;

  factory _$GradeData([void Function(GradeDataBuilder) updates]) =>
      (new GradeDataBuilder()..update(updates)).build();

  _$GradeData._({this.grades, this.weights}) : super._();

  @override
  GradeData rebuild(void Function(GradeDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GradeDataBuilder toBuilder() => new GradeDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GradeData &&
        grades == other.grades &&
        weights == other.weights;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, grades.hashCode), weights.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('GradeData')
          ..add('grades', grades)
          ..add('weights', weights))
        .toString();
  }
}

class GradeDataBuilder implements Builder<GradeData, GradeDataBuilder> {
  _$GradeData _$v;

  ListBuilder<Grade> _grades;
  ListBuilder<Grade> get grades => _$this._grades ??= new ListBuilder<Grade>();
  set grades(ListBuilder<Grade> grades) => _$this._grades = grades;

  MapBuilder<String, String> _weights;
  MapBuilder<String, String> get weights =>
      _$this._weights ??= new MapBuilder<String, String>();
  set weights(MapBuilder<String, String> weights) => _$this._weights = weights;

  GradeDataBuilder();

  GradeDataBuilder get _$this {
    if (_$v != null) {
      _grades = _$v.grades?.toBuilder();
      _weights = _$v.weights?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GradeData other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$GradeData;
  }

  @override
  void update(void Function(GradeDataBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$GradeData build() {
    _$GradeData _$result;
    try {
      _$result = _$v ??
          new _$GradeData._(
              grades: _grades?.build(), weights: _weights?.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'grades';
        _grades?.build();
        _$failedField = 'weights';
        _weights?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'GradeData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$Course extends Course {
  @override
  final String gradesUrl;
  @override
  final String courseName;
  @override
  final String periodString;
  @override
  final String teacherName;
  @override
  final StringOrInt gradePercent;
  @override
  final String gradeLetter;

  factory _$Course([void Function(CourseBuilder) updates]) =>
      (new CourseBuilder()..update(updates)).build();

  _$Course._(
      {this.gradesUrl,
      this.courseName,
      this.periodString,
      this.teacherName,
      this.gradePercent,
      this.gradeLetter})
      : super._() {
    if (courseName == null) {
      throw new BuiltValueNullFieldError('Course', 'courseName');
    }
    if (periodString == null) {
      throw new BuiltValueNullFieldError('Course', 'periodString');
    }
    if (teacherName == null) {
      throw new BuiltValueNullFieldError('Course', 'teacherName');
    }
  }

  @override
  Course rebuild(void Function(CourseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CourseBuilder toBuilder() => new CourseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Course &&
        gradesUrl == other.gradesUrl &&
        courseName == other.courseName &&
        periodString == other.periodString &&
        teacherName == other.teacherName &&
        gradePercent == other.gradePercent &&
        gradeLetter == other.gradeLetter;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc($jc($jc(0, gradesUrl.hashCode), courseName.hashCode),
                    periodString.hashCode),
                teacherName.hashCode),
            gradePercent.hashCode),
        gradeLetter.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Course')
          ..add('gradesUrl', gradesUrl)
          ..add('courseName', courseName)
          ..add('periodString', periodString)
          ..add('teacherName', teacherName)
          ..add('gradePercent', gradePercent)
          ..add('gradeLetter', gradeLetter))
        .toString();
  }
}

class CourseBuilder implements Builder<Course, CourseBuilder> {
  _$Course _$v;

  String _gradesUrl;
  String get gradesUrl => _$this._gradesUrl;
  set gradesUrl(String gradesUrl) => _$this._gradesUrl = gradesUrl;

  String _courseName;
  String get courseName => _$this._courseName;
  set courseName(String courseName) => _$this._courseName = courseName;

  String _periodString;
  String get periodString => _$this._periodString;
  set periodString(String periodString) => _$this._periodString = periodString;

  String _teacherName;
  String get teacherName => _$this._teacherName;
  set teacherName(String teacherName) => _$this._teacherName = teacherName;

  StringOrInt _gradePercent;
  StringOrInt get gradePercent => _$this._gradePercent;
  set gradePercent(StringOrInt gradePercent) =>
      _$this._gradePercent = gradePercent;

  String _gradeLetter;
  String get gradeLetter => _$this._gradeLetter;
  set gradeLetter(String gradeLetter) => _$this._gradeLetter = gradeLetter;

  CourseBuilder();

  CourseBuilder get _$this {
    if (_$v != null) {
      _gradesUrl = _$v.gradesUrl;
      _courseName = _$v.courseName;
      _periodString = _$v.periodString;
      _teacherName = _$v.teacherName;
      _gradePercent = _$v.gradePercent;
      _gradeLetter = _$v.gradeLetter;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Course other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Course;
  }

  @override
  void update(void Function(CourseBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Course build() {
    final _$result = _$v ??
        new _$Course._(
            gradesUrl: gradesUrl,
            courseName: courseName,
            periodString: periodString,
            teacherName: teacherName,
            gradePercent: gradePercent,
            gradeLetter: gradeLetter);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
