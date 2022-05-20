// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grade.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Grade> _$gradeSerializer = new _$GradeSerializer();

class _$GradeSerializer implements StructuredSerializer<Grade> {
  @override
  final Iterable<Type> types = const [Grade, _$Grade];
  @override
  final String wireName = 'Grade';

  @override
  Iterable<Object> serialize(Serializers serializers, Grade object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'ASSIGNMENT_TITLE',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'LETTER',
      serializers.serialize(object.rawLetter,
          specifiedType: const FullType(String)),
      'DUE_DATE',
      serializers.serialize(object.rawDueDate,
          specifiedType: const FullType(String)),
      'ASSIGNED_DATE',
      serializers.serialize(object.rawAssignedDate,
          specifiedType: const FullType(String)),
      'CATEGORY_TITLE',
      serializers.serialize(object.category,
          specifiedType: const FullType(String)),
    ];
    Object value;
    value = object.pointsEarnedRaw;
    if (value != null) {
      result
        ..add('POINTS_EARNED')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(StringOrNum)));
    }
    value = object.pointsPossibleRaw;
    if (value != null) {
      result
        ..add('POINTS_POSSIBLE')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(StringOrNum)));
    }
    value = object.rawUpdatedAt;
    if (value != null) {
      result
        ..add('UPDATED_AT')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.comment;
    if (value != null) {
      result
        ..add('COMMENT')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  Grade deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new GradeBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
      switch (key) {
        case 'ASSIGNMENT_TITLE':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'POINTS_EARNED':
          result.pointsEarnedRaw = serializers.deserialize(value,
              specifiedType: const FullType(StringOrNum)) as StringOrNum;
          break;
        case 'POINTS_POSSIBLE':
          result.pointsPossibleRaw = serializers.deserialize(value,
              specifiedType: const FullType(StringOrNum)) as StringOrNum;
          break;
        case 'LETTER':
          result.rawLetter = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'DUE_DATE':
          result.rawDueDate = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'ASSIGNED_DATE':
          result.rawAssignedDate = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'UPDATED_AT':
          result.rawUpdatedAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'CATEGORY_TITLE':
          result.category = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'COMMENT':
          result.comment = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$Grade extends Grade {
  @override
  final String name;
  @override
  final StringOrNum pointsEarnedRaw;
  @override
  final StringOrNum pointsPossibleRaw;
  @override
  final String rawLetter;
  @override
  final String rawDueDate;
  @override
  final String rawAssignedDate;
  @override
  final String rawUpdatedAt;
  @override
  final String category;
  @override
  final String comment;

  factory _$Grade([void Function(GradeBuilder) updates]) =>
      (new GradeBuilder()..update(updates))._build();

  _$Grade._(
      {this.name,
      this.pointsEarnedRaw,
      this.pointsPossibleRaw,
      this.rawLetter,
      this.rawDueDate,
      this.rawAssignedDate,
      this.rawUpdatedAt,
      this.category,
      this.comment})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(name, 'Grade', 'name');
    BuiltValueNullFieldError.checkNotNull(rawLetter, 'Grade', 'rawLetter');
    BuiltValueNullFieldError.checkNotNull(rawDueDate, 'Grade', 'rawDueDate');
    BuiltValueNullFieldError.checkNotNull(
        rawAssignedDate, 'Grade', 'rawAssignedDate');
    BuiltValueNullFieldError.checkNotNull(category, 'Grade', 'category');
  }

  @override
  Grade rebuild(void Function(GradeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GradeBuilder toBuilder() => new GradeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Grade &&
        name == other.name &&
        pointsEarnedRaw == other.pointsEarnedRaw &&
        pointsPossibleRaw == other.pointsPossibleRaw &&
        rawLetter == other.rawLetter &&
        rawDueDate == other.rawDueDate &&
        rawAssignedDate == other.rawAssignedDate &&
        rawUpdatedAt == other.rawUpdatedAt &&
        category == other.category &&
        comment == other.comment;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc($jc(0, name.hashCode),
                                    pointsEarnedRaw.hashCode),
                                pointsPossibleRaw.hashCode),
                            rawLetter.hashCode),
                        rawDueDate.hashCode),
                    rawAssignedDate.hashCode),
                rawUpdatedAt.hashCode),
            category.hashCode),
        comment.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Grade')
          ..add('name', name)
          ..add('pointsEarnedRaw', pointsEarnedRaw)
          ..add('pointsPossibleRaw', pointsPossibleRaw)
          ..add('rawLetter', rawLetter)
          ..add('rawDueDate', rawDueDate)
          ..add('rawAssignedDate', rawAssignedDate)
          ..add('rawUpdatedAt', rawUpdatedAt)
          ..add('category', category)
          ..add('comment', comment))
        .toString();
  }
}

class GradeBuilder implements Builder<Grade, GradeBuilder> {
  _$Grade _$v;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  StringOrNum _pointsEarnedRaw;
  StringOrNum get pointsEarnedRaw => _$this._pointsEarnedRaw;
  set pointsEarnedRaw(StringOrNum pointsEarnedRaw) =>
      _$this._pointsEarnedRaw = pointsEarnedRaw;

  StringOrNum _pointsPossibleRaw;
  StringOrNum get pointsPossibleRaw => _$this._pointsPossibleRaw;
  set pointsPossibleRaw(StringOrNum pointsPossibleRaw) =>
      _$this._pointsPossibleRaw = pointsPossibleRaw;

  String _rawLetter;
  String get rawLetter => _$this._rawLetter;
  set rawLetter(String rawLetter) => _$this._rawLetter = rawLetter;

  String _rawDueDate;
  String get rawDueDate => _$this._rawDueDate;
  set rawDueDate(String rawDueDate) => _$this._rawDueDate = rawDueDate;

  String _rawAssignedDate;
  String get rawAssignedDate => _$this._rawAssignedDate;
  set rawAssignedDate(String rawAssignedDate) =>
      _$this._rawAssignedDate = rawAssignedDate;

  String _rawUpdatedAt;
  String get rawUpdatedAt => _$this._rawUpdatedAt;
  set rawUpdatedAt(String rawUpdatedAt) => _$this._rawUpdatedAt = rawUpdatedAt;

  String _category;
  String get category => _$this._category;
  set category(String category) => _$this._category = category;

  String _comment;
  String get comment => _$this._comment;
  set comment(String comment) => _$this._comment = comment;

  GradeBuilder();

  GradeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _pointsEarnedRaw = $v.pointsEarnedRaw;
      _pointsPossibleRaw = $v.pointsPossibleRaw;
      _rawLetter = $v.rawLetter;
      _rawDueDate = $v.rawDueDate;
      _rawAssignedDate = $v.rawAssignedDate;
      _rawUpdatedAt = $v.rawUpdatedAt;
      _category = $v.category;
      _comment = $v.comment;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Grade other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Grade;
  }

  @override
  void update(void Function(GradeBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  Grade build() => _build();

  _$Grade _build() {
    final _$result = _$v ??
        new _$Grade._(
            name: BuiltValueNullFieldError.checkNotNull(name, 'Grade', 'name'),
            pointsEarnedRaw: pointsEarnedRaw,
            pointsPossibleRaw: pointsPossibleRaw,
            rawLetter: BuiltValueNullFieldError.checkNotNull(
                rawLetter, 'Grade', 'rawLetter'),
            rawDueDate: BuiltValueNullFieldError.checkNotNull(
                rawDueDate, 'Grade', 'rawDueDate'),
            rawAssignedDate: BuiltValueNullFieldError.checkNotNull(
                rawAssignedDate, 'Grade', 'rawAssignedDate'),
            rawUpdatedAt: rawUpdatedAt,
            category: BuiltValueNullFieldError.checkNotNull(
                category, 'Grade', 'category'),
            comment: comment);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
