import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:reso_coder/core/error/failures.dart';
import 'package:reso_coder/core/usecases/usecase.dart';
import 'package:reso_coder/core/util/input_converter.dart';
import 'package:reso_coder/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:reso_coder/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import '../../domain/entities/number_trivia.dart';
part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';
const String invalidInputMessage =
    'Invalid Input - The number must be a positive integer or zero ';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia? getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter? inputConverter;

  NumberTriviaBloc(
      {required this.getConcreteNumberTrivia,
      required this.getRandomNumberTrivia,
      required this.inputConverter})
      /* The initial State is Empty() */
      : super(Empty()) {
    on<NumberTriviaEvent>((event, emit) async {
      if (event is GetTriviaForConcreteNumber) {
        // Either handles both Failure and Succsess
        // use Emit instead of Yield
        // use async instead of async*
        final inputEither =
            inputConverter!.stringToUnsignedInteger(event.numberString!);
        await inputEither.fold((failure) async {
          emit(const Error(message: invalidInputMessage));
        }, (int? integer) async {
          emit(Loading());
          final failureOrTrivia =
              await getConcreteNumberTrivia!(Params(number: integer!));
          // check if the future is null to avoid late initialization and null check used on a null value
          if (failureOrTrivia != null) {
            // we need to await the future
            emit(await _eitherLoadedOrErrorState(failureOrTrivia));
          }
        });
      } else if (event is GetTriviaForRandomNumber) {
        emit(Loading());
        final failureOrTrivia = await getRandomNumberTrivia(NoParams());
        // we need to await the future
        emit(await _eitherLoadedOrErrorState(failureOrTrivia!));
      }
    });
  }

  Future<NumberTriviaState> _eitherLoadedOrErrorState(
      Either<Failure?, NumberTrivia?> failureOrTrivia) async {
    // Print is for testing purposes
    print(failureOrTrivia.toString());
    return await failureOrTrivia.fold(
        (failure) => Error(message: _mapFailureToMessage(failure: failure!)),
        (trivia) => Loaded(trivia: trivia!));
  }

  String _mapFailureToMessage({required Failure failure}) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return 'Unexpected error';
    }
  }
}
