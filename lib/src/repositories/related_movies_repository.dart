import 'package:meta/meta.dart';

import 'http_client.dart';
import '../models/models.dart';

class RelatedRepository {
  final apiClient = ApiClient();

  Future<List<Movie>> getRelatedMovies({@required String id}) async {
    return apiClient.fetchRelatedMovies(id: id);
  }
}
