import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:reso_coder/core/error/failures.dart';
import 'package:reso_coder/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:reso_coder/features/number_trivia/domain/repositories/number_trivia_repository.dart';

import '../../../../core/usecases/usecase.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia?, Params?> {
  final NumberTriviaRepository? repository;
  GetConcreteNumberTrivia(this.repository);
  // we can name a method 'call' and call it without specifying the name of the method, just the class object
  @override
  Future<Either<Failure?, NumberTrivia?>?> call(Params? params) async {
    return await repository!.getConcreteNumberTrivia(params!.number!)!;
  }
}

class Params extends Equatable {
  final int? number;
  const Params({required this.number});

  @override
  List<Object?> get props => [number];
}
