import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class NodeExpressRepository {
  NodeExpressRepository() {
    _client = 'https://watching-api.onrender.com/';
  }

  /// -- Fetches Public Users For the Leaderboard Feature --
  Future<List<dynamic>?> fetchAllPublicUsers() async {
    final String url = '${_client}public-users';
    try {
      final Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);

        // Ensure the decoded data is a list of maps
        if (decodedData is List) {
          // Extract the 'id' from each user, assuming 'id' is a string
          final List<dynamic> ids = decodedData
              .where((user) =>
                  user is Map<String, dynamic> && user.containsKey('id'))
              .map<dynamic>((user) => user['id'])
              .toList();

          Logger().d('Fetched public users successfully!: $ids');
          return Future.value(ids); // Wrap ids in a Future
        } else {
          Logger().d('Unexpected data format: ${decodedData.runtimeType}');
          return Future.value(null); // Return null as a Future
        }
      } else {
        Logger().d('Failed to fetch public users');
        return Future.value(null); // Return null as a Future
      }
    } catch (error) {
      Logger().d('Error fetching public users: $error');
      return Future.value(null); // Return null as a Future
    }
  }

  late final String _client;
}
