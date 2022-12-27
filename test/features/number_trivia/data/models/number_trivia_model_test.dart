import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:reso_coder/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:reso_coder/features/number_trivia/domain/entities/number_trivia.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  // model extends the entity
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text');
  test('should be subclass of number trivia entity', () async {
// arrange
    expect(tNumberTriviaModel, isA<NumberTrivia>());
//act

//assert
  });

  group('fromJson', () {
    test(
      'should return a valid model when the JSON number is an integer',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia.json'));
        // act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // assert
        expect(result, tNumberTriviaModel);
      },
    );
    test(
      'should return a valid model when the JSON number is regarded as a double',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia_double.json'));
        // act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // assert
        expect(result, tNumberTriviaModel);
      },
    );
  });

  group('toJson', () {
    test('should return a jsonMap containing the proper data', () async {
      //arrange

      //act
      final result = tNumberTriviaModel.toJson();
      //assert
      final expectedMap = {
        "text": "Test Text",
        "number": 1,
      };
      expect(result, expectedMap);
    });
  });
}
