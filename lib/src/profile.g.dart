// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Profile> _$profileSerializer = new _$ProfileSerializer();

class _$ProfileSerializer implements StructuredSerializer<Profile> {
  @override
  final Iterable<Type> types = const [Profile, _$Profile];
  @override
  final String wireName = 'Profile';

  @override
  Iterable<Object> serialize(Serializers serializers, Profile object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    Object value;
    value = object.cumulative_gpa;
    if (value != null) {
      result
        ..add('cumulative_gpa')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    value = object.cumulative_weighted_gpa;
    if (value != null) {
      result
        ..add('cumulative_weighted_gpa')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    value = object.class_rank_numerator;
    if (value != null) {
      result
        ..add('class_rank_numerator')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.class_rank_denominator;
    if (value != null) {
      result
        ..add('class_rank_denominator')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  Profile deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ProfileBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
      switch (key) {
        case 'cumulative_gpa':
          result.cumulative_gpa = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'cumulative_weighted_gpa':
          result.cumulative_weighted_gpa = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'class_rank_numerator':
          result.class_rank_numerator = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'class_rank_denominator':
          result.class_rank_denominator = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$Profile extends Profile {
  @override
  final double cumulative_gpa;
  @override
  final double cumulative_weighted_gpa;
  @override
  final int class_rank_numerator;
  @override
  final int class_rank_denominator;

  factory _$Profile([void Function(ProfileBuilder) updates]) =>
      (new ProfileBuilder()..update(updates)).build();

  _$Profile._(
      {this.cumulative_gpa,
      this.cumulative_weighted_gpa,
      this.class_rank_numerator,
      this.class_rank_denominator})
      : super._();

  @override
  Profile rebuild(void Function(ProfileBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProfileBuilder toBuilder() => new ProfileBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Profile &&
        cumulative_gpa == other.cumulative_gpa &&
        cumulative_weighted_gpa == other.cumulative_weighted_gpa &&
        class_rank_numerator == other.class_rank_numerator &&
        class_rank_denominator == other.class_rank_denominator;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc(0, cumulative_gpa.hashCode),
                cumulative_weighted_gpa.hashCode),
            class_rank_numerator.hashCode),
        class_rank_denominator.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Profile')
          ..add('cumulative_gpa', cumulative_gpa)
          ..add('cumulative_weighted_gpa', cumulative_weighted_gpa)
          ..add('class_rank_numerator', class_rank_numerator)
          ..add('class_rank_denominator', class_rank_denominator))
        .toString();
  }
}

class ProfileBuilder implements Builder<Profile, ProfileBuilder> {
  _$Profile _$v;

  double _cumulative_gpa;
  double get cumulative_gpa => _$this._cumulative_gpa;
  set cumulative_gpa(double cumulative_gpa) =>
      _$this._cumulative_gpa = cumulative_gpa;

  double _cumulative_weighted_gpa;
  double get cumulative_weighted_gpa => _$this._cumulative_weighted_gpa;
  set cumulative_weighted_gpa(double cumulative_weighted_gpa) =>
      _$this._cumulative_weighted_gpa = cumulative_weighted_gpa;

  int _class_rank_numerator;
  int get class_rank_numerator => _$this._class_rank_numerator;
  set class_rank_numerator(int class_rank_numerator) =>
      _$this._class_rank_numerator = class_rank_numerator;

  int _class_rank_denominator;
  int get class_rank_denominator => _$this._class_rank_denominator;
  set class_rank_denominator(int class_rank_denominator) =>
      _$this._class_rank_denominator = class_rank_denominator;

  ProfileBuilder();

  ProfileBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cumulative_gpa = $v.cumulative_gpa;
      _cumulative_weighted_gpa = $v.cumulative_weighted_gpa;
      _class_rank_numerator = $v.class_rank_numerator;
      _class_rank_denominator = $v.class_rank_denominator;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Profile other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Profile;
  }

  @override
  void update(void Function(ProfileBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Profile build() {
    final _$result = _$v ??
        new _$Profile._(
            cumulative_gpa: cumulative_gpa,
            cumulative_weighted_gpa: cumulative_weighted_gpa,
            class_rank_numerator: class_rank_numerator,
            class_rank_denominator: class_rank_denominator);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
