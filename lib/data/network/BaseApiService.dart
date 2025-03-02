abstract class BaseApiServices{
  Future<dynamic> getApiResponse(String url);
  Future<dynamic> getPostApiResponse(String url,dynamic body);
  Future<dynamic> getDeleteApiResponse(String url);
  Future<dynamic> postUrlResponse(String url);
}