import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class NodeExpressRepository {
  NodeExpressRepository() {
    this._client = dotenv.env['nodeEndpoint']!;
    this._token = dotenv.env['secretToken']!;
  }

  /// -- Fetches Public Users For the Leaderboard Feature --
  Future<List<dynamic>?> fetchAllPublicUsers() async {
    final String url = '$_client$_token/public-users';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        return decodedData is List
            ? decodedData
                .whereType<Map<String, dynamic>>()
                .map((user) => user['id'])
                .toList()
            : null;
      }
    } catch (error) {}
    return null;
  }

  late final String _client;
  late final String _token;
}
