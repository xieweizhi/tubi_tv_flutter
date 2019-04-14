import 'http_client.dart';
import '../models/models.dart';

class HomePageRepository {
  final apiClient =  ApiClient();

  Future<HomePageModel> getHomePageData() async {
    return apiClient.fetchHomePage();
  }
}
