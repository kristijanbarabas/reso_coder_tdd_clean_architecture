// Contract that check network connectivity based on the OS of the device
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';

abstract class NetworkInfo {
  Future<bool>? get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final DataConnectionChecker? connectionChecker;

  NetworkInfoImpl({required this.connectionChecker});

  @override
  Future<bool>? get isConnected => connectionChecker!.hasConnection;
}
