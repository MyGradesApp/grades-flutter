// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_bloc.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const GroupingMode _$date = const GroupingMode._('date');
const GroupingMode _$category = const GroupingMode._('category');

GroupingMode _$valueOf(String name) {
  switch (name) {
    case 'date':
      return _$date;
    case 'category':
      return _$category;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<GroupingMode> _$values =
    new BuiltSet<GroupingMode>(const <GroupingMode>[
  _$date,
  _$category,
]);

Serializer<GroupingMode> _$groupingModeSerializer =
    new _$GroupingModeSerializer();
Serializer<SettingsState> _$settingsStateSerializer =
    new _$SettingsStateSerializer();

class _$GroupingModeSerializer implements PrimitiveSerializer<GroupingMode> {
  @override
  final Iterable<Type> types = const <Type>[GroupingMode];
  @override
  final String wireName = 'GroupingMode';

  @override
  Object serialize(Serializers serializers, GroupingMode object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  GroupingMode deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      GroupingMode.valueOf(serialized as String);
}

class _$SettingsStateSerializer implements StructuredSerializer<SettingsState> {
  @override
  final Iterable<Type> types = const [SettingsState, _$SettingsState];
  @override
  final String wireName = 'SettingsState';

  @override
  Iterable<Object> serialize(Serializers serializers, SettingsState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'groupingMode',
      serializers.serialize(object.groupingMode,
          specifiedType: const FullType(GroupingMode)),
    ];

    return result;
  }

  @override
  SettingsState deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SettingsStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
      switch (key) {
        case 'groupingMode':
          result.groupingMode = serializers.deserialize(value,
              specifiedType: const FullType(GroupingMode)) as GroupingMode;
          break;
      }
    }

    return result.build();
  }
}

class _$SettingsState extends SettingsState {
  @override
  final GroupingMode groupingMode;

  factory _$SettingsState([void Function(SettingsStateBuilder) updates]) =>
      (new SettingsStateBuilder()..update(updates))._build();

  _$SettingsState._({this.groupingMode}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        groupingMode, 'SettingsState', 'groupingMode');
  }

  @override
  SettingsState rebuild(void Function(SettingsStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SettingsStateBuilder toBuilder() => new SettingsStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SettingsState && groupingMode == other.groupingMode;
  }

  @override
  int get hashCode {
    return $jf($jc(0, groupingMode.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SettingsState')
          ..add('groupingMode', groupingMode))
        .toString();
  }
}

class SettingsStateBuilder
    implements Builder<SettingsState, SettingsStateBuilder> {
  _$SettingsState _$v;

  GroupingMode _groupingMode;
  GroupingMode get groupingMode => _$this._groupingMode;
  set groupingMode(GroupingMode groupingMode) =>
      _$this._groupingMode = groupingMode;

  SettingsStateBuilder();

  SettingsStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _groupingMode = $v.groupingMode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SettingsState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SettingsState;
  }

  @override
  void update(void Function(SettingsStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  SettingsState build() => _build();

  _$SettingsState _build() {
    final _$result = _$v ??
        new _$SettingsState._(
            groupingMode: BuiltValueNullFieldError.checkNotNull(
                groupingMode, 'SettingsState', 'groupingMode'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
