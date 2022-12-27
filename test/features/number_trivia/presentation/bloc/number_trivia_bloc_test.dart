import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:reso_coder/core/error/failures.dart';
import 'package:reso_coder/core/usecases/usecase.dart';
import 'package:reso_coder/core/util/input_converter.dart';
import 'package:reso_coder/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:reso_coder/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:reso_coder/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:reso_coder/mock/mock_all.mocks.dart';

void main() {
  NumberTriviaBloc? bloc;
  MockGetConcreteNumberTrivia? mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia? mockGetRandomNumberTrivia;
  MockInputConverter? mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia!,
        getRandomNumberTrivia: mockGetRandomNumberTrivia!,
        inputConverter: mockInputConverter!);
  });

  test('initialState should be Empty() ', () {
    expect(bloc!.state, equals(Empty()));
  });

  // GET TRIVIA FOR CONCRETE NUMBER
  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter!.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));

    test(
        'should call the InputConverter to validate and convert the string to an unsigned integer ',
        () async {
      //arrange - if there is an [Error: any is null and can't be assigned], a mock must be generated
      setUpMockInputConverterSuccess();
      //act
      bloc!.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter!.stringToUnsignedInteger(any));
      //assert
      verify(mockInputConverter!.stringToUnsignedInteger(tNumberString));
    });
    test('should emit [Error] when the input is invalid', () async {
      //arrange - if there is an [error: any is null and can't be assigned], a mock must be generated
      when(mockInputConverter!.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));
      //assert later - It's not necessary to add Empty() in the expected list
      List expected = [const Error(message: invalidInputMessage)];
      expectLater(bloc!.stream.asBroadcastStream(), emitsInOrder(expected));
      //act
      bloc!.add(GetTriviaForConcreteNumber(tNumberString));
    });
    test('should get data from the concrete use case', () async {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia!(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      //act
      bloc!.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia!(any));
      //assert
      verify(mockGetConcreteNumberTrivia!(Params(number: tNumberParsed)));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia!(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      //assert - later
      final expected = [Loading(), Loaded(trivia: tNumberTrivia)];
      expectLater(bloc!.stream.asBroadcastStream(), emitsInOrder(expected));
      //act
      bloc!.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should emit [Loading, Error] when getting data fails', () async {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia!(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      //assert - later
      final expected = [Loading(), const Error(message: serverFailureMessage)];
      expectLater(bloc!.stream.asBroadcastStream(), emitsInOrder(expected));
      //act
      bloc!.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test(
        'should emit [Loading, Error] with the proper message for the error when getting data fails ',
        () async {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia!(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      //assert - later
      final expected = [Loading(), const Error(message: cacheFailureMessage)];
      expectLater(bloc!.stream.asBroadcastStream(), emitsInOrder(expected));
      //act
      bloc!.add(GetTriviaForConcreteNumber(tNumberString));
    });
  });

  // GET TRIVIA FOR RANDOM NUMBER
  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test('should get data from the random use case', () async {
      //arrange
      when(mockGetRandomNumberTrivia!(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      //act
      bloc!.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia!(any));
      //assert
      verify(mockGetRandomNumberTrivia!(NoParams()));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      //arrange
      when(mockGetRandomNumberTrivia!(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      //assert - later
      final expected = [Loading(), Loaded(trivia: tNumberTrivia)];
      expectLater(bloc!.stream.asBroadcastStream(), emitsInOrder(expected));
      //act
      bloc!.add(GetTriviaForRandomNumber());
    });

    test('should emit [Loading, Error] when getting data fails', () async {
      //arrange
      when(mockGetRandomNumberTrivia!(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      //assert - later
      final expected = [Loading(), const Error(message: serverFailureMessage)];
      expectLater(bloc!.stream.asBroadcastStream(), emitsInOrder(expected));
      //act
      bloc!.add(GetTriviaForRandomNumber());
    });

    test(
        'should emit [Loading, Error] with the proper message for the error when getting data fails ',
        () async {
      //arrange

      when(mockGetRandomNumberTrivia!(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      //assert - later
      final expected = [Loading(), const Error(message: cacheFailureMessage)];
      expectLater(bloc!.stream.asBroadcastStream(), emitsInOrder(expected));
      //act
      bloc!.add(GetTriviaForRandomNumber());
    });
  });
}
