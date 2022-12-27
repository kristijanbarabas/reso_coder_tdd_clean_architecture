import 'package:reso_coder/core/network/network_info.dart';
import 'package:reso_coder/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:reso_coder/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:reso_coder/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:reso_coder/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:reso_coder/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import '../../../../core/error/exceptions.dart';
import '../models/number_trivia_model.dart';

typedef _ConcreteOrRandomChooser = Future<NumberTriviaModel>? Function();

// connecting to the contract in the domain > repositories
class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource? remoteDataSource;
  final NumberTriviaLocalDataSource? localDataSource;
  final NetworkInfo? networkInfo;
  const NumberTriviaRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});
  @override
  Future<Either<Failure, NumberTrivia?>?>? getConcreteNumberTrivia(
      int? number) async {
    return await _getTrivia(() {
      return remoteDataSource!.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia?>?>? getRandomNumberTrivia() async {
    // check if the device is connected
    // if it's connected get the remote data
    // return a failure if there is no connection to the server
    return await _getTrivia(() {
      return remoteDataSource!.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTrivia?>>? _getTrivia(
      _ConcreteOrRandomChooser getConcreteOrRandom) async {
    // check if the device is connected
    // if it's connected get the remote data
    // return a failure if there is no connection to the server
    if (await networkInfo!.isConnected!) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localDataSource!.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
      // if the device is offline get the local (cached) data
      // return a failure if there is no cached data
    } else {
      try {
        final localTrivia = await localDataSource!.getLastNumberTrivia();
        return Right(localTrivia!);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
