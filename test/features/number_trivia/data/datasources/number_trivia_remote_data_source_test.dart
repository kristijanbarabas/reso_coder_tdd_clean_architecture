import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:reso_coder/core/error/exceptions.dart';
import 'package:reso_coder/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:reso_coder/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:reso_coder/mock/mock_all.mocks.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  NumberTriviaRemoteDataSourceImpl? dataSourceImpl;
  MockClient? mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSourceImpl = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient!);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient!.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttClientFailure404() {
    when(mockHttpClient!.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
        '''should perform a GET request on a URL with number being the endpoint and with application/json header.''',
        () async {
//arrange
      setUpMockHttpClientSuccess200();
//act
      dataSourceImpl!.getConcreteNumberTrivia(tNumber);
//assert
      verify(mockHttpClient!.get(Uri.parse('http://numbersapi.com/$tNumber'),
          headers: {'Content-Type': 'application/json'}));
    });

    test('''should return NumberTrivia when the response code is 200.''',
        () async {
//arrange
      setUpMockHttpClientSuccess200();
//act
      final result = await dataSourceImpl!.getConcreteNumberTrivia(tNumber);
//assert
      expect(result, equals(tNumberTriviaModel));
    });

    test('''should throw a ServerException when the response is 404 or other''',
        () async {
//arrange
      setUpMockHttClientFailure404();
//act
      final call = dataSourceImpl!.getConcreteNumberTrivia;
//assert
      expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
        '''should perform a GET request on a URL with number being the endpoint and with application/json header.''',
        () async {
//arrange
      setUpMockHttpClientSuccess200();
//act
      dataSourceImpl!.getRandomNumberTrivia();
//assert
      verify(mockHttpClient!.get(Uri.parse('http://numbersapi.com/random'),
          headers: {'Content-Type': 'application/json'}));
    });

    test('''should return NumberTrivia when the response code is 200.''',
        () async {
//arrange
      setUpMockHttpClientSuccess200();
//act
      final result = await dataSourceImpl!.getRandomNumberTrivia();
//assert
      expect(result, equals(tNumberTriviaModel));
    });

    test('''should throw a ServerException when the response is 404 or other''',
        () async {
//arrange
      setUpMockHttClientFailure404();
//act
      final call = dataSourceImpl!.getRandomNumberTrivia;
//assert
      expect(() => call(), throwsA(TypeMatcher<ServerException>()));
    });
  });
}
