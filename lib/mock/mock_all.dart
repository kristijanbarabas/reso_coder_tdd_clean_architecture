import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import '../core/network/network_info.dart';
import '../core/util/input_converter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reso_coder/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:reso_coder/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

@GenerateNiceMocks([MockSpec<GetConcreteNumberTrivia>()])
@GenerateNiceMocks([MockSpec<GetRandomNumberTrivia>()])
@GenerateNiceMocks([MockSpec<Client>()])
@GenerateNiceMocks([MockSpec<InputConverter>()])
@GenerateNiceMocks([MockSpec<NetworkInfo>()])
@GenerateNiceMocks([MockSpec<DataConnectionChecker>()])
@GenerateNiceMocks([MockSpec<SharedPreferences>()])
import 'mock_all.mocks.dart';
