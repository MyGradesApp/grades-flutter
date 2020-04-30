// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'academic_info.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<AcademicInfo> _$academicInfoSerializer =
    new _$AcademicInfoSerializer();

class _$AcademicInfoSerializer implements StructuredSerializer<AcademicInfo> {
  @override
  final Iterable<Type> types = const [AcademicInfo, _$AcademicInfo];
  @override
  final String wireName = 'AcademicInfo';

  @override
  Iterable<Object> serialize(Serializers serializers, AcademicInfo object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'profile',
      serializers.serialize(object.profile,
          specifiedType: const FullType(Profile)),
      'absences',
      serializers.serialize(object.absences,
          specifiedType: const FullType(Absences)),
    ];

    return result;
  }

  @override
  AcademicInfo deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AcademicInfoBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'profile':
          result.profile.replace(serializers.deserialize(value,
              specifiedType: const FullType(Profile)) as Profile);
          break;
        case 'absences':
          result.absences.replace(serializers.deserialize(value,
              specifiedType: const FullType(Absences)) as Absences);
          break;
      }
    }

    return result.build();
  }
}

class _$AcademicInfo extends AcademicInfo {
  @override
  final Profile profile;
  @override
  final Absences absences;

  factory _$AcademicInfo([void Function(AcademicInfoBuilder) updates]) =>
      (new AcademicInfoBuilder()..update(updates)).build();

  _$AcademicInfo._({this.profile, this.absences}) : super._() {
    if (profile == null) {
      throw new BuiltValueNullFieldError('AcademicInfo', 'profile');
    }
    if (absences == null) {
      throw new BuiltValueNullFieldError('AcademicInfo', 'absences');
    }
  }

  @override
  AcademicInfo rebuild(void Function(AcademicInfoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AcademicInfoBuilder toBuilder() => new AcademicInfoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AcademicInfo &&
        profile == other.profile &&
        absences == other.absences;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, profile.hashCode), absences.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AcademicInfo')
          ..add('profile', profile)
          ..add('absences', absences))
        .toString();
  }
}

class AcademicInfoBuilder
    implements Builder<AcademicInfo, AcademicInfoBuilder> {
  _$AcademicInfo _$v;

  ProfileBuilder _profile;
  ProfileBuilder get profile => _$this._profile ??= new ProfileBuilder();
  set profile(ProfileBuilder profile) => _$this._profile = profile;

  AbsencesBuilder _absences;
  AbsencesBuilder get absences => _$this._absences ??= new AbsencesBuilder();
  set absences(AbsencesBuilder absences) => _$this._absences = absences;

  AcademicInfoBuilder();

  AcademicInfoBuilder get _$this {
    if (_$v != null) {
      _profile = _$v.profile?.toBuilder();
      _absences = _$v.absences?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AcademicInfo other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$AcademicInfo;
  }

  @override
  void update(void Function(AcademicInfoBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AcademicInfo build() {
    _$AcademicInfo _$result;
    try {
      _$result = _$v ??
          new _$AcademicInfo._(
              profile: profile.build(), absences: absences.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'profile';
        profile.build();
        _$failedField = 'absences';
        absences.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'AcademicInfo', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
