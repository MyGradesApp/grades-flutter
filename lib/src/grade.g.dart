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
      'raw',
      serializers.serialize(object.raw,
          specifiedType: const FullType(BuiltMap,
              const [const FullType(String), const FullType(String)])),
    ];

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
      final dynamic value = iterator.current;
      switch (key) {
        case 'raw':
          result.raw.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap,
                  const [const FullType(String), const FullType(String)])));
          break;
      }
    }

    return result.build();
  }
}

class _$Grade extends Grade {
  @override
  final BuiltMap<String, String> raw;

  factory _$Grade([void Function(GradeBuilder) updates]) =>
      (new GradeBuilder()..update(updates)).build();

  _$Grade._({this.raw}) : super._() {
    if (raw == null) {
      throw new BuiltValueNullFieldError('Grade', 'raw');
    }
  }

  @override
  Grade rebuild(void Function(GradeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GradeBuilder toBuilder() => new GradeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Grade && raw == other.raw;
  }

  @override
  int get hashCode {
    return $jf($jc(0, raw.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Grade')..add('raw', raw)).toString();
  }
}

class GradeBuilder implements Builder<Grade, GradeBuilder> {
  _$Grade _$v;

  MapBuilder<String, String> _raw;
  MapBuilder<String, String> get raw =>
      _$this._raw ??= new MapBuilder<String, String>();
  set raw(MapBuilder<String, String> raw) => _$this._raw = raw;

  GradeBuilder();

  GradeBuilder get _$this {
    if (_$v != null) {
      _raw = _$v.raw?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Grade other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Grade;
  }

  @override
  void update(void Function(GradeBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Grade build() {
    _$Grade _$result;
    try {
      _$result = _$v ?? new _$Grade._(raw: raw.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'raw';
        raw.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Grade', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
