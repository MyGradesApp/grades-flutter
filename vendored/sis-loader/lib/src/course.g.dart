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
    Object value;
    value = object.grades;
    if (value != null) {
      result
        ..add('grades')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(Grade)])));
    }
    value = object.weights;
    if (value != null) {
      result
        ..add('weights')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(BuiltMap,
                const [const FullType(String), const FullType(String)])));
    }
    value = object.classPercent;
    if (value != null) {
      result
        ..add('classPercent')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
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
      final Object value = iterator.current;
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
        case 'classPercent':
          result.classPercent = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
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
      'coursePeriodId',
      serializers.serialize(object.coursePeriodId,
          specifiedType: const FullType(int)),
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
    Object value;
    value = object.gradesUrl;
    if (value != null) {
      result
        ..add('gradesUrl')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.gradePercent;
    if (value != null) {
      result
        ..add('gradePercent')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(StringOrInt)));
    }
    value = object.gradeLetter;
    if (value != null) {
      result
        ..add('gradeLetter')
        ..add(serializers.serialize(value,
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
      final Object value = iterator.current;
      switch (key) {
        case 'coursePeriodId':
          result.coursePeriodId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
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
  @override
  final int classPercent;

  factory _$GradeData([void Function(GradeDataBuilder) updates]) =>
      (new GradeDataBuilder()..update(updates))._build();

  _$GradeData._({this.grades, this.weights, this.classPercent}) : super._();

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
        weights == other.weights &&
        classPercent == other.classPercent;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc(0, grades.hashCode), weights.hashCode), classPercent.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('GradeData')
          ..add('grades', grades)
          ..add('weights', weights)
          ..add('classPercent', classPercent))
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

  int _classPercent;
  int get classPercent => _$this._classPercent;
  set classPercent(int classPercent) => _$this._classPercent = classPercent;

  GradeDataBuilder();

  GradeDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _grades = $v.grades?.toBuilder();
      _weights = $v.weights?.toBuilder();
      _classPercent = $v.classPercent;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GradeData other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$GradeData;
  }

  @override
  void update(void Function(GradeDataBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  GradeData build() => _build();

  _$GradeData _build() {
    _$GradeData _$result;
    try {
      _$result = _$v ??
          new _$GradeData._(
              grades: _grades?.build(),
              weights: _weights?.build(),
              classPercent: classPercent);
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
  final int coursePeriodId;
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
      (new CourseBuilder()..update(updates))._build();

  _$Course._(
      {this.coursePeriodId,
      this.gradesUrl,
      this.courseName,
      this.periodString,
      this.teacherName,
      this.gradePercent,
      this.gradeLetter})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        coursePeriodId, 'Course', 'coursePeriodId');
    BuiltValueNullFieldError.checkNotNull(courseName, 'Course', 'courseName');
    BuiltValueNullFieldError.checkNotNull(
        periodString, 'Course', 'periodString');
    BuiltValueNullFieldError.checkNotNull(teacherName, 'Course', 'teacherName');
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
        coursePeriodId == other.coursePeriodId &&
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
                $jc(
                    $jc(
                        $jc($jc(0, coursePeriodId.hashCode),
                            gradesUrl.hashCode),
                        courseName.hashCode),
                    periodString.hashCode),
                teacherName.hashCode),
            gradePercent.hashCode),
        gradeLetter.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Course')
          ..add('coursePeriodId', coursePeriodId)
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

  int _coursePeriodId;
  int get coursePeriodId => _$this._coursePeriodId;
  set coursePeriodId(int coursePeriodId) =>
      _$this._coursePeriodId = coursePeriodId;

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
    final $v = _$v;
    if ($v != null) {
      _coursePeriodId = $v.coursePeriodId;
      _gradesUrl = $v.gradesUrl;
      _courseName = $v.courseName;
      _periodString = $v.periodString;
      _teacherName = $v.teacherName;
      _gradePercent = $v.gradePercent;
      _gradeLetter = $v.gradeLetter;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Course other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Course;
  }

  @override
  void update(void Function(CourseBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  Course build() => _build();

  _$Course _build() {
    final _$result = _$v ??
        new _$Course._(
            coursePeriodId: BuiltValueNullFieldError.checkNotNull(
                coursePeriodId, 'Course', 'coursePeriodId'),
            gradesUrl: gradesUrl,
            courseName: BuiltValueNullFieldError.checkNotNull(
                courseName, 'Course', 'courseName'),
            periodString: BuiltValueNullFieldError.checkNotNull(
                periodString, 'Course', 'periodString'),
            teacherName: BuiltValueNullFieldError.checkNotNull(
                teacherName, 'Course', 'teacherName'),
            gradePercent: gradePercent,
            gradeLetter: gradeLetter);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
