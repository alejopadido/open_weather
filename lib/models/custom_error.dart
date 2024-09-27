import 'package:equatable/equatable.dart';

class CustomError extends Equatable {
  final String errorMsg;
  CustomError({
    this.errorMsg = '',
  });

  @override
  List<Object> get props => [errorMsg];

  @override
  bool get stringify => true;
}
