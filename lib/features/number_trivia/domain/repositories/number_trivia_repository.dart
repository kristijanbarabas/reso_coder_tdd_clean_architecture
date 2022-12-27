import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/number_trivia.dart';

// Contract we must fulfill
abstract class NumberTriviaRepository {
  // left side of either is for error handling and right side is success data
  // no need for try and catch
  Future<Either<Failure, NumberTrivia?>?>? getConcreteNumberTrivia(int? number);
  Future<Either<Failure, NumberTrivia?>?>? getRandomNumberTrivia();
}
