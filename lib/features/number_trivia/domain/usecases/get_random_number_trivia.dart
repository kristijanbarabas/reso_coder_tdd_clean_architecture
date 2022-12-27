import 'package:dartz/dartz.dart';
import 'package:reso_coder/core/error/failures.dart';

import 'package:reso_coder/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:reso_coder/features/number_trivia/domain/repositories/number_trivia_repository.dart';

import '../../../../core/usecases/usecase.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;
  const GetRandomNumberTrivia(this.repository);
  @override
  Future<Either<Failure, NumberTrivia?>?> call(NoParams params) async {
    return await repository.getRandomNumberTrivia()!;
  }
}
