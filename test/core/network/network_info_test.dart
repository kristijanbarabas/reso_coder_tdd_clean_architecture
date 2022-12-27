import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reso_coder/core/network/network_info.dart';
import 'package:reso_coder/mock/mock_all.mocks.dart';

void main() {
  MockDataConnectionChecker? mockDataConnectionChecker;
  NetworkInfoImpl? networkInfo;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfo = NetworkInfoImpl(connectionChecker: mockDataConnectionChecker);
  });

  group('isConnected', () {
    test('should forward the call to DataConnectionChecker.hasConnection',
        () async {
      // arrange
      final tHasConnectionFuture = Future.value(true);
      when(mockDataConnectionChecker!.hasConnection)
          .thenAnswer((_) => tHasConnectionFuture);
      // act
      final result = networkInfo!.isConnected;
      //assert
      verify(mockDataConnectionChecker!.hasConnection);
      expect(result, tHasConnectionFuture);
    });
  });
}
