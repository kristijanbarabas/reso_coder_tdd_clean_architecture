import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reso_coder/core/error/exceptions.dart';
import 'package:reso_coder/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:reso_coder/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:reso_coder/mock/mock_all.mocks.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  NumberTriviaLocalDataSourceImpl? dataSource;
  MockSharedPreferences? mockSharedPreferneces;

  setUp(() {
    mockSharedPreferneces = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferneces!);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test(
        'should return NumberTriviaModel from SharedPreferences when there is one in the cache',
        () async {
//arrange
      when(mockSharedPreferneces!.getString(any))
          .thenReturn(fixture('trivia_cached.json'));
//act
      final result = await dataSource!.getLastNumberTrivia();
//assert
      verify(mockSharedPreferneces!.getString('CACHED_NUMBER_TRIVIA'));
      expect(result, tNumberTriviaModel);
    });

    test('should throw cache when there is no cached value', () async {
//arrange
      when(mockSharedPreferneces!.getString(any)).thenReturn(null);
//act
      final call = dataSource!.getLastNumberTrivia;
//assert
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: 1);
    test('should call SharedPreferences to cache the data', () async {
//act
      dataSource!.cacheNumberTrivia(tNumberTriviaModel);
//assert
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(mockSharedPreferneces!
          .setString('CACHED_NUMBER_TRIVIA', expectedJsonString));
    });
  });
}
