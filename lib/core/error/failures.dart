import 'package:equatable/equatable.dart';

// Exception handling
abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]);
}

// General failures

class ServerFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class CacheFailure extends Failure {
  @override
  List<Object?> get props => [];
}
