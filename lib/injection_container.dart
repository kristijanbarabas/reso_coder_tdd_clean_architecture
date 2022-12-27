import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:get_it/get_it.dart';
import 'package:reso_coder/core/network/network_info.dart';
import 'package:reso_coder/core/util/input_converter.dart';
import 'package:reso_coder/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:reso_coder/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:reso_coder/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:reso_coder/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:reso_coder/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:reso_coder/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:reso_coder/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// sl means Service locator
final sl = GetIt.instance;

Future<void> initState() async {
  //! Features - Number Trivia (repositories, usecases, datasources)
  // Bloc
  // calling sl() is a shorthand for sl.call() - type inference
  sl.registerFactory(() => NumberTriviaBloc(
      getConcreteNumberTrivia: sl(),
      getRandomNumberTrivia: sl(),
      inputConverter: sl()));
  // Register Usecases - these dependencies are a contract, not a concrete class, they depend on the contract
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));
  // Register Repository
  sl.registerLazySingleton<NumberTriviaRepository>(
      () => NumberTriviaRepositoryImpl(
            localDataSource: sl(),
            networkInfo: sl(),
            remoteDataSource: sl(),
          ));
  // Datasources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()));

  //! Core - InputConverter & NetworkInfo
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectionChecker: sl()));

  //! External dependencies (Shared preferences & Http)
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
