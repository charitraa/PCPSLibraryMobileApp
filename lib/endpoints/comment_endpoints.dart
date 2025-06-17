import 'package:library_management_sys/constant/base_url.dart';

class CommentEndpoints{
  static var comment="${BaseUrl.baseUrl}/comments";
  static var commentReply="${BaseUrl.baseUrl}/comments/reply";
  static var updateComment="${BaseUrl.baseUrl}/comments/update";
  static var deleteComment="${BaseUrl.baseUrl}/comments/delete";
  static var deleteReply="${BaseUrl.baseUrl}/comments/delete-reply";
  static var updateReply="${BaseUrl.baseUrl}/comments/update-reply";

}
