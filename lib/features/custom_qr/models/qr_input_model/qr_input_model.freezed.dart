// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qr_input_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QrInputModel {

 Bank? get selectedBank; String get accountNumber; String get merchantName; double get amount; String get description; QrType get type; String get mcc; String get merchantCity; Uint8List? get logoBytes;// Màu sắc
 Color get dataColor; Color get eyeColor; Color get bgColor;// [MỚI] Hình dáng QR (Style)
 QrDataModuleShape get qrDataShape;// Chấm dữ liệu
 QrEyeShape get qrEyeShape;
/// Create a copy of QrInputModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QrInputModelCopyWith<QrInputModel> get copyWith => _$QrInputModelCopyWithImpl<QrInputModel>(this as QrInputModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QrInputModel&&(identical(other.selectedBank, selectedBank) || other.selectedBank == selectedBank)&&(identical(other.accountNumber, accountNumber) || other.accountNumber == accountNumber)&&(identical(other.merchantName, merchantName) || other.merchantName == merchantName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type)&&(identical(other.mcc, mcc) || other.mcc == mcc)&&(identical(other.merchantCity, merchantCity) || other.merchantCity == merchantCity)&&const DeepCollectionEquality().equals(other.logoBytes, logoBytes)&&(identical(other.dataColor, dataColor) || other.dataColor == dataColor)&&(identical(other.eyeColor, eyeColor) || other.eyeColor == eyeColor)&&(identical(other.bgColor, bgColor) || other.bgColor == bgColor)&&(identical(other.qrDataShape, qrDataShape) || other.qrDataShape == qrDataShape)&&(identical(other.qrEyeShape, qrEyeShape) || other.qrEyeShape == qrEyeShape));
}


@override
int get hashCode => Object.hash(runtimeType,selectedBank,accountNumber,merchantName,amount,description,type,mcc,merchantCity,const DeepCollectionEquality().hash(logoBytes),dataColor,eyeColor,bgColor,qrDataShape,qrEyeShape);

@override
String toString() {
  return 'QrInputModel(selectedBank: $selectedBank, accountNumber: $accountNumber, merchantName: $merchantName, amount: $amount, description: $description, type: $type, mcc: $mcc, merchantCity: $merchantCity, logoBytes: $logoBytes, dataColor: $dataColor, eyeColor: $eyeColor, bgColor: $bgColor, qrDataShape: $qrDataShape, qrEyeShape: $qrEyeShape)';
}


}

/// @nodoc
abstract mixin class $QrInputModelCopyWith<$Res>  {
  factory $QrInputModelCopyWith(QrInputModel value, $Res Function(QrInputModel) _then) = _$QrInputModelCopyWithImpl;
@useResult
$Res call({
 Bank? selectedBank, String accountNumber, String merchantName, double amount, String description, QrType type, String mcc, String merchantCity, Uint8List? logoBytes, Color dataColor, Color eyeColor, Color bgColor, QrDataModuleShape qrDataShape, QrEyeShape qrEyeShape
});




}
/// @nodoc
class _$QrInputModelCopyWithImpl<$Res>
    implements $QrInputModelCopyWith<$Res> {
  _$QrInputModelCopyWithImpl(this._self, this._then);

  final QrInputModel _self;
  final $Res Function(QrInputModel) _then;

/// Create a copy of QrInputModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedBank = freezed,Object? accountNumber = null,Object? merchantName = null,Object? amount = null,Object? description = null,Object? type = null,Object? mcc = null,Object? merchantCity = null,Object? logoBytes = freezed,Object? dataColor = null,Object? eyeColor = null,Object? bgColor = null,Object? qrDataShape = null,Object? qrEyeShape = null,}) {
  return _then(_self.copyWith(
selectedBank: freezed == selectedBank ? _self.selectedBank : selectedBank // ignore: cast_nullable_to_non_nullable
as Bank?,accountNumber: null == accountNumber ? _self.accountNumber : accountNumber // ignore: cast_nullable_to_non_nullable
as String,merchantName: null == merchantName ? _self.merchantName : merchantName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as QrType,mcc: null == mcc ? _self.mcc : mcc // ignore: cast_nullable_to_non_nullable
as String,merchantCity: null == merchantCity ? _self.merchantCity : merchantCity // ignore: cast_nullable_to_non_nullable
as String,logoBytes: freezed == logoBytes ? _self.logoBytes : logoBytes // ignore: cast_nullable_to_non_nullable
as Uint8List?,dataColor: null == dataColor ? _self.dataColor : dataColor // ignore: cast_nullable_to_non_nullable
as Color,eyeColor: null == eyeColor ? _self.eyeColor : eyeColor // ignore: cast_nullable_to_non_nullable
as Color,bgColor: null == bgColor ? _self.bgColor : bgColor // ignore: cast_nullable_to_non_nullable
as Color,qrDataShape: null == qrDataShape ? _self.qrDataShape : qrDataShape // ignore: cast_nullable_to_non_nullable
as QrDataModuleShape,qrEyeShape: null == qrEyeShape ? _self.qrEyeShape : qrEyeShape // ignore: cast_nullable_to_non_nullable
as QrEyeShape,
  ));
}

}


/// Adds pattern-matching-related methods to [QrInputModel].
extension QrInputModelPatterns on QrInputModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QrInputModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QrInputModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QrInputModel value)  $default,){
final _that = this;
switch (_that) {
case _QrInputModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QrInputModel value)?  $default,){
final _that = this;
switch (_that) {
case _QrInputModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Bank? selectedBank,  String accountNumber,  String merchantName,  double amount,  String description,  QrType type,  String mcc,  String merchantCity,  Uint8List? logoBytes,  Color dataColor,  Color eyeColor,  Color bgColor,  QrDataModuleShape qrDataShape,  QrEyeShape qrEyeShape)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QrInputModel() when $default != null:
return $default(_that.selectedBank,_that.accountNumber,_that.merchantName,_that.amount,_that.description,_that.type,_that.mcc,_that.merchantCity,_that.logoBytes,_that.dataColor,_that.eyeColor,_that.bgColor,_that.qrDataShape,_that.qrEyeShape);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Bank? selectedBank,  String accountNumber,  String merchantName,  double amount,  String description,  QrType type,  String mcc,  String merchantCity,  Uint8List? logoBytes,  Color dataColor,  Color eyeColor,  Color bgColor,  QrDataModuleShape qrDataShape,  QrEyeShape qrEyeShape)  $default,) {final _that = this;
switch (_that) {
case _QrInputModel():
return $default(_that.selectedBank,_that.accountNumber,_that.merchantName,_that.amount,_that.description,_that.type,_that.mcc,_that.merchantCity,_that.logoBytes,_that.dataColor,_that.eyeColor,_that.bgColor,_that.qrDataShape,_that.qrEyeShape);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Bank? selectedBank,  String accountNumber,  String merchantName,  double amount,  String description,  QrType type,  String mcc,  String merchantCity,  Uint8List? logoBytes,  Color dataColor,  Color eyeColor,  Color bgColor,  QrDataModuleShape qrDataShape,  QrEyeShape qrEyeShape)?  $default,) {final _that = this;
switch (_that) {
case _QrInputModel() when $default != null:
return $default(_that.selectedBank,_that.accountNumber,_that.merchantName,_that.amount,_that.description,_that.type,_that.mcc,_that.merchantCity,_that.logoBytes,_that.dataColor,_that.eyeColor,_that.bgColor,_that.qrDataShape,_that.qrEyeShape);case _:
  return null;

}
}

}

/// @nodoc


class _QrInputModel implements QrInputModel {
  const _QrInputModel({this.selectedBank, this.accountNumber = '', this.merchantName = '', this.amount = 0, this.description = '', this.type = QrType.personal, this.mcc = '5999', this.merchantCity = 'Vietnam', this.logoBytes, this.dataColor = Colors.black, this.eyeColor = Colors.black, this.bgColor = Colors.white, this.qrDataShape = QrDataModuleShape.circle, this.qrEyeShape = QrEyeShape.square});
  

@override final  Bank? selectedBank;
@override@JsonKey() final  String accountNumber;
@override@JsonKey() final  String merchantName;
@override@JsonKey() final  double amount;
@override@JsonKey() final  String description;
@override@JsonKey() final  QrType type;
@override@JsonKey() final  String mcc;
@override@JsonKey() final  String merchantCity;
@override final  Uint8List? logoBytes;
// Màu sắc
@override@JsonKey() final  Color dataColor;
@override@JsonKey() final  Color eyeColor;
@override@JsonKey() final  Color bgColor;
// [MỚI] Hình dáng QR (Style)
@override@JsonKey() final  QrDataModuleShape qrDataShape;
// Chấm dữ liệu
@override@JsonKey() final  QrEyeShape qrEyeShape;

/// Create a copy of QrInputModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QrInputModelCopyWith<_QrInputModel> get copyWith => __$QrInputModelCopyWithImpl<_QrInputModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QrInputModel&&(identical(other.selectedBank, selectedBank) || other.selectedBank == selectedBank)&&(identical(other.accountNumber, accountNumber) || other.accountNumber == accountNumber)&&(identical(other.merchantName, merchantName) || other.merchantName == merchantName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type)&&(identical(other.mcc, mcc) || other.mcc == mcc)&&(identical(other.merchantCity, merchantCity) || other.merchantCity == merchantCity)&&const DeepCollectionEquality().equals(other.logoBytes, logoBytes)&&(identical(other.dataColor, dataColor) || other.dataColor == dataColor)&&(identical(other.eyeColor, eyeColor) || other.eyeColor == eyeColor)&&(identical(other.bgColor, bgColor) || other.bgColor == bgColor)&&(identical(other.qrDataShape, qrDataShape) || other.qrDataShape == qrDataShape)&&(identical(other.qrEyeShape, qrEyeShape) || other.qrEyeShape == qrEyeShape));
}


@override
int get hashCode => Object.hash(runtimeType,selectedBank,accountNumber,merchantName,amount,description,type,mcc,merchantCity,const DeepCollectionEquality().hash(logoBytes),dataColor,eyeColor,bgColor,qrDataShape,qrEyeShape);

@override
String toString() {
  return 'QrInputModel(selectedBank: $selectedBank, accountNumber: $accountNumber, merchantName: $merchantName, amount: $amount, description: $description, type: $type, mcc: $mcc, merchantCity: $merchantCity, logoBytes: $logoBytes, dataColor: $dataColor, eyeColor: $eyeColor, bgColor: $bgColor, qrDataShape: $qrDataShape, qrEyeShape: $qrEyeShape)';
}


}

/// @nodoc
abstract mixin class _$QrInputModelCopyWith<$Res> implements $QrInputModelCopyWith<$Res> {
  factory _$QrInputModelCopyWith(_QrInputModel value, $Res Function(_QrInputModel) _then) = __$QrInputModelCopyWithImpl;
@override @useResult
$Res call({
 Bank? selectedBank, String accountNumber, String merchantName, double amount, String description, QrType type, String mcc, String merchantCity, Uint8List? logoBytes, Color dataColor, Color eyeColor, Color bgColor, QrDataModuleShape qrDataShape, QrEyeShape qrEyeShape
});




}
/// @nodoc
class __$QrInputModelCopyWithImpl<$Res>
    implements _$QrInputModelCopyWith<$Res> {
  __$QrInputModelCopyWithImpl(this._self, this._then);

  final _QrInputModel _self;
  final $Res Function(_QrInputModel) _then;

/// Create a copy of QrInputModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedBank = freezed,Object? accountNumber = null,Object? merchantName = null,Object? amount = null,Object? description = null,Object? type = null,Object? mcc = null,Object? merchantCity = null,Object? logoBytes = freezed,Object? dataColor = null,Object? eyeColor = null,Object? bgColor = null,Object? qrDataShape = null,Object? qrEyeShape = null,}) {
  return _then(_QrInputModel(
selectedBank: freezed == selectedBank ? _self.selectedBank : selectedBank // ignore: cast_nullable_to_non_nullable
as Bank?,accountNumber: null == accountNumber ? _self.accountNumber : accountNumber // ignore: cast_nullable_to_non_nullable
as String,merchantName: null == merchantName ? _self.merchantName : merchantName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as QrType,mcc: null == mcc ? _self.mcc : mcc // ignore: cast_nullable_to_non_nullable
as String,merchantCity: null == merchantCity ? _self.merchantCity : merchantCity // ignore: cast_nullable_to_non_nullable
as String,logoBytes: freezed == logoBytes ? _self.logoBytes : logoBytes // ignore: cast_nullable_to_non_nullable
as Uint8List?,dataColor: null == dataColor ? _self.dataColor : dataColor // ignore: cast_nullable_to_non_nullable
as Color,eyeColor: null == eyeColor ? _self.eyeColor : eyeColor // ignore: cast_nullable_to_non_nullable
as Color,bgColor: null == bgColor ? _self.bgColor : bgColor // ignore: cast_nullable_to_non_nullable
as Color,qrDataShape: null == qrDataShape ? _self.qrDataShape : qrDataShape // ignore: cast_nullable_to_non_nullable
as QrDataModuleShape,qrEyeShape: null == qrEyeShape ? _self.qrEyeShape : qrEyeShape // ignore: cast_nullable_to_non_nullable
as QrEyeShape,
  ));
}


}

// dart format on
