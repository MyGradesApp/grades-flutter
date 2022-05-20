import 'package:built_value/serializer.dart';

class StringOrInt {
  final bool _isString;
  final dynamic _value;

  bool get isString => _isString;

  bool get isInt => !_isString;

  String get string => _value as String;

  int get integer => _value as int;

  const StringOrInt(dynamic value)
      : assert(value is String || value is int),
        _isString = value is String,
        _value = value;

  @override
  bool operator ==(other) {
    return other is StringOrInt &&
        _isString == other._isString &&
        _value == other._value;
  }

  @override
  int get hashCode => _value.hashCode;

  @override
  String toString() {
    return _value.toString();
  }
}

class StringOrIntSerializer implements PrimitiveSerializer<StringOrInt> {
  @override
  Iterable<Type> get types => [StringOrInt];

  const StringOrIntSerializer();

  @override
  String get wireName => 'StringOrInt';

  @override
  StringOrInt deserialize(Serializers serializers, Object serialized,
      {FullType specifiedType = FullType.unspecified}) {
    return StringOrInt(serialized);
  }

  @override
  Object serialize(Serializers serializers, StringOrInt object,
      {FullType specifiedType = FullType.unspecified}) {
    return object.isString ? object.string : object.integer;
  }
}



class StringOrNum {
  final bool _isString;
  final dynamic _value;

  bool get isString => _isString;

  bool get isNum => !_isString;

  String get string => _value as String;

  num get number => _value as num;

  const StringOrNum(dynamic value)
      : assert(value is String || value is num),
        _isString = value is String,
        _value = value;

  @override
  bool operator ==(other) {
    return other is StringOrNum &&
        _isString == other._isString &&
        _value == other._value;
  }

  @override
  int get hashCode => _value.hashCode;

  @override
  String toString() {
    return _value.toString();
  }

  String maybeString() {
    return _value?.toString();
  }
}

class StringOrNumSerializer implements PrimitiveSerializer<StringOrNum> {
  @override
  Iterable<Type> get types => [StringOrNum];

  const StringOrNumSerializer();

  @override
  String get wireName => 'StringOrNum';

  @override
  StringOrNum deserialize(Serializers serializers, Object serialized,
      {FullType specifiedType = FullType.unspecified}) {
    return StringOrNum(serialized);
  }

  @override
  Object serialize(Serializers serializers, StringOrNum object,
      {FullType specifiedType = FullType.unspecified}) {
    return object.isString ? object.string : object.number;
  }
}
