import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:todo_list_app/services/api_service.dart';

@GenerateMocks([http.Client])
import 'api_service_test.mocks.dart';

void main() {
  group('ApiService Mock Tests', () {
    late MockClient mockClient;
    late ApiService apiService;

    setUp(() {
      mockClient = MockClient();
      apiService = ApiService(mockClient);
    });

    test('returns data if the http call completes successfully', () async {
      when(mockClient.get(Uri.parse('https://api.example.com/data')))
          .thenAnswer((_) async => http.Response('{"success": true}', 200));

      expect(await apiService.fetchData(), '{"success": true}');
    });

    test('throws an exception if the http call completes with an error', () {
      when(mockClient.get(Uri.parse('https://api.example.com/data')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(() => apiService.fetchData(), throwsException);
    });
  });
}