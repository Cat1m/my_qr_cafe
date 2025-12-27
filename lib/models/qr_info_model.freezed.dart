// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qr_info_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QrInfoModel {

 String get bankBin; String get accountNumber; String get accountName; String? get amount; String? get description;
/// Create a copy of QrInfoModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QrInfoModelCopyWith<QrInfoModel> get copyWith => _$QrInfoModelCopyWithImpl<QrInfoModel>(this as QrInfoModel, _$identity);

  /// Serializes this QrInfoModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QrInfoModel&&(identical(other.bankBin, bankBin) || other.bankBin == bankBin)&&(identical(other.accountNumber, accountNumber) || other.accountNumber == accountNumber)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bankBin,accountNumber,accountName,amount,description);

@override
String toString() {
  return 'QrInfoModel(bankBin: $bankBin, accountNumber: $accountNumber, accountName: $accountName, amount: $amount, description: $description)';
}


}

/// @nodoc
abstract mixin class $QrInfoModelCopyWith<$Res>  {
  factory $QrInfoModelCopyWith(QrInfoModel value, $Res Function(QrInfoModel) _then) = _$QrInfoModelCopyWithImpl;
@useResult
$Res call({
 String bankBin, String accountNumber, String accountName, String? amount, String? description
});




}
/// @nodoc
class _$QrInfoModelCopyWithImpl<$Res>
    implements $QrInfoModelCopyWith<$Res> {
  _$QrInfoModelCopyWithImpl(this._self, this._then);

  final QrInfoModel _self;
  final $Res Function(QrInfoModel) _then;

/// Create a copy of QrInfoModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bankBin = null,Object? accountNumber = null,Object? accountName = null,Object? amount = freezed,Object? description = freezed,}) {
  return _then(_self.copyWith(
bankBin: null == bankBin ? _self.bankBin : bankBin // ignore: cast_nullable_to_non_nullable
as String,accountNumber: null == accountNumber ? _self.accountNumber : accountNumber // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [QrInfoModel].
extension QrInfoModelPatterns on QrInfoModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QrInfoModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QrInfoModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QrInfoModel value)  $default,){
final _that = this;
switch (_that) {
case _QrInfoModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QrInfoModel value)?  $default,){
final _that = this;
switch (_that) {
case _QrInfoModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String bankBin,  String accountNumber,  String accountName,  String? amount,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QrInfoModel() when $default != null:
return $default(_that.bankBin,_that.accountNumber,_that.accountName,_that.amount,_that.description);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String bankBin,  String accountNumber,  String accountName,  String? amount,  String? description)  $default,) {final _that = this;
switch (_that) {
case _QrInfoModel():
return $default(_that.bankBin,_that.accountNumber,_that.accountName,_that.amount,_that.description);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String bankBin,  String accountNumber,  String accountName,  String? amount,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _QrInfoModel() when $default != null:
return $default(_that.bankBin,_that.accountNumber,_that.accountName,_that.amount,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QrInfoModel implements QrInfoModel {
  const _QrInfoModel({required this.bankBin, required this.accountNumber, this.accountName = 'KHACH HANG', this.amount, this.description});
  factory _QrInfoModel.fromJson(Map<String, dynamic> json) => _$QrInfoModelFromJson(json);

@override final  String bankBin;
@override final  String accountNumber;
@override@JsonKey() final  String accountName;
@override final  String? amount;
@override final  String? description;

/// Create a copy of QrInfoModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QrInfoModelCopyWith<_QrInfoModel> get copyWith => __$QrInfoModelCopyWithImpl<_QrInfoModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QrInfoModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QrInfoModel&&(identical(other.bankBin, bankBin) || other.bankBin == bankBin)&&(identical(other.accountNumber, accountNumber) || other.accountNumber == accountNumber)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bankBin,accountNumber,accountName,amount,description);

@override
String toString() {
  return 'QrInfoModel(bankBin: $bankBin, accountNumber: $accountNumber, accountName: $accountName, amount: $amount, description: $description)';
}


}

/// @nodoc
abstract mixin class _$QrInfoModelCopyWith<$Res> implements $QrInfoModelCopyWith<$Res> {
  factory _$QrInfoModelCopyWith(_QrInfoModel value, $Res Function(_QrInfoModel) _then) = __$QrInfoModelCopyWithImpl;
@override @useResult
$Res call({
 String bankBin, String accountNumber, String accountName, String? amount, String? description
});




}
/// @nodoc
class __$QrInfoModelCopyWithImpl<$Res>
    implements _$QrInfoModelCopyWith<$Res> {
  __$QrInfoModelCopyWithImpl(this._self, this._then);

  final _QrInfoModel _self;
  final $Res Function(_QrInfoModel) _then;

/// Create a copy of QrInfoModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bankBin = null,Object? accountNumber = null,Object? accountName = null,Object? amount = freezed,Object? description = freezed,}) {
  return _then(_QrInfoModel(
bankBin: null == bankBin ? _self.bankBin : bankBin // ignore: cast_nullable_to_non_nullable
as String,accountNumber: null == accountNumber ? _self.accountNumber : accountNumber // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
