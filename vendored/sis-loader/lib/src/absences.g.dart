// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'absences.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Absences> _$absencesSerializer = new _$AbsencesSerializer();

class _$AbsencesSerializer implements StructuredSerializer<Absences> {
  @override
  final Iterable<Type> types = const [Absences, _$Absences];
  @override
  final String wireName = 'Absences';

  @override
  Iterable<Object> serialize(Serializers serializers, Absences object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'periods',
      serializers.serialize(object.periods, specifiedType: const FullType(int)),
      'days',
      serializers.serialize(object.days, specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  Absences deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AbsencesBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
      switch (key) {
        case 'periods':
          result.periods = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'days':
          result.days = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$Absences extends Absences {
  @override
  final int periods;
  @override
  final int days;

  factory _$Absences([void Function(AbsencesBuilder) updates]) =>
      (new AbsencesBuilder()..update(updates))._build();

  _$Absences._({this.periods, this.days}) : super._() {
    BuiltValueNullFieldError.checkNotNull(periods, 'Absences', 'periods');
    BuiltValueNullFieldError.checkNotNull(days, 'Absences', 'days');
  }

  @override
  Absences rebuild(void Function(AbsencesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AbsencesBuilder toBuilder() => new AbsencesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Absences && periods == other.periods && days == other.days;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, periods.hashCode), days.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Absences')
          ..add('periods', periods)
          ..add('days', days))
        .toString();
  }
}

class AbsencesBuilder implements Builder<Absences, AbsencesBuilder> {
  _$Absences _$v;

  int _periods;
  int get periods => _$this._periods;
  set periods(int periods) => _$this._periods = periods;

  int _days;
  int get days => _$this._days;
  set days(int days) => _$this._days = days;

  AbsencesBuilder();

  AbsencesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _periods = $v.periods;
      _days = $v.days;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Absences other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Absences;
  }

  @override
  void update(void Function(AbsencesBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  Absences build() => _build();

  _$Absences _build() {
    final _$result = _$v ??
        new _$Absences._(
            periods: BuiltValueNullFieldError.checkNotNull(
                periods, 'Absences', 'periods'),
            days: BuiltValueNullFieldError.checkNotNull(
                days, 'Absences', 'days'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
