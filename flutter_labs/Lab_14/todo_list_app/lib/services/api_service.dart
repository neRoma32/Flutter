import 'package:http/http.dart' as http;

class ApiService {
  final http.Client client;
  ApiService(this.client);

  Future<String> fetchData() async {
    final response = await client.get(Uri.parse('https://api.example.com/data'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  }
}