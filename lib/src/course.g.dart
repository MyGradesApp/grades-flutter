// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Course> _$courseSerializer = new _$CourseSerializer();

class _$CourseSerializer implements StructuredSerializer<Course> {
  @override
  final Iterable<Type> types = const [Course, _$Course];
  @override
  final String wireName = 'Course';

  @override
  Iterable<Object> serialize(Serializers serializers, Course object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'gradesUrl',
      serializers.serialize(object.gradesUrl,
          specifiedType: const FullType(String)),
      'courseName',
      serializers.serialize(object.courseName,
          specifiedType: const FullType(String)),
      'periodString',
      serializers.serialize(object.periodString,
          specifiedType: const FullType(String)),
      'teacherName',
      serializers.serialize(object.teacherName,
          specifiedType: const FullType(String)),
      'gradePercent',
      serializers.serialize(object.gradePercent,
          specifiedType: const FullType(StringOrInt)),
      'gradeLetter',
      serializers.serialize(object.gradeLetter,
          specifiedType: const FullType(String)),
    ];

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
    if (gradesUrl == null) {
      throw new BuiltValueNullFieldError('Course', 'gradesUrl');
    }
    if (courseName == null) {
      throw new BuiltValueNullFieldError('Course', 'courseName');
    }
    if (periodString == null) {
      throw new BuiltValueNullFieldError('Course', 'periodString');
    }
    if (teacherName == null) {
      throw new BuiltValueNullFieldError('Course', 'teacherName');
    }
    if (gradePercent == null) {
      throw new BuiltValueNullFieldError('Course', 'gradePercent');
    }
    if (gradeLetter == null) {
      throw new BuiltValueNullFieldError('Course', 'gradeLetter');
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
