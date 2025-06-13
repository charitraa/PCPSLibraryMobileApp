import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:library_management_sys/model/comment_model.dart';
import 'package:library_management_sys/repository/comments_repository.dart';
import '../../data/response/api_response.dart';
import '../../utils/utils.dart';

class CommentViewModel with ChangeNotifier {
  final List<CommentModel> _commentList = [];
  final CommentsRepository _commentsRepo = CommentsRepository();
  ApiResponse<CommentModel> commentsData = ApiResponse.loading();
  CommentModel? get currentUser => commentsData.data;
  void setUser(ApiResponse<CommentModel> response) {
    commentsData = response;
    Future.microtask(() => notifyListeners());
  }

  bool _isLoading = false;
  String _filter = '';
 

  int _currentPage = 1;
  int _limit = 10;

  bool get isLoading => _isLoading;
  List<CommentModel> get commentsList => _commentList;
  String get filter => _filter;

  int get currentPage => _currentPage;

  void setLoading(bool value) {
    _isLoading = value;
    Future.microtask(() => notifyListeners());
  }

  String _searchValue = '';
  String get searchValue => _searchValue;

  void setFilter(String value, BuildContext context) {
    if (_filter != value) {
      _filter = value;
      _searchValue = value;
      // fetchComments(context);
      notifyListeners();
    }
  }


  Future<void> fetchComments(String uid,BuildContext context) async {
    if (_isLoading) return;
    setLoading(true);
    try {
      _currentPage = 1;
      _commentList.clear();
      final Map<String, dynamic> response = await _commentsRepo.fetchComments(uid,
          _filter, 1, _limit, context);

      _commentList.addAll(response['comments']);
      if (response['next'] != null) {
        _currentPage++;
      }
      notifyListeners();
    } catch (error) {
      Utils.flushBarErrorMessage("Error fetching comments: $error", context);
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadMore(String uid,BuildContext context) async {
    try {
      final Map<String, dynamic> response = await _commentsRepo.fetchComments(uid,_filter,
          _currentPage, _limit, context);
      if (_currentPage != null) {
        print("${response['next']}=$_currentPage");
        _commentList.addAll(response['comments']);
        _currentPage++;
      }
      notifyListeners();
    } catch (error) {
      Utils.flushBarErrorMessage("Error fetching comments: $error", context);
    }
  }



  Future<bool> postComment(String uid, dynamic body,BuildContext context) async {
    try {
      final user = await _commentsRepo.postComments(uid,body, context);
      if(user){
        Utils.flushBarSuccessMessage('You have successfully commented!!', context);
      }
      return user;
    } catch (e) {
      Utils.flushBarErrorMessage("Error: $e", context);
      return false;
    }
  }
  Future<bool> replyComment(String uid, dynamic body,BuildContext context) async {
    try {
      final user = await _commentsRepo.replyComment(uid,body, context);
      if(user){
        Utils.flushBarSuccessMessage('You have replied on this comment!!', context);
      }
      return user;
    } catch (e) {
      Utils.flushBarErrorMessage("Error: $e", context);
      return false;
    }
  }
  Future<bool> deleteComment(String uid,BuildContext context) async {
    try {
      final user = await _commentsRepo.deleteComment(uid, context);
      if(user){
        Utils.flushBarSuccessMessage('You have replied on this comment!!', context);
      }
      return user;
    } catch (e) {
      Utils.flushBarErrorMessage("Error: $e", context);
      return false;
    }
  }

  Future<bool> updateComment(String uid,dynamic body,BuildContext context) async {
    try {
      final user = await _commentsRepo.updateComments(uid,body, context);
      if(user){
        Utils.flushBarSuccessMessage('You have updated your comment!!', context);
      }
      return user;
    } catch (e) {
      Utils.flushBarErrorMessage("Error: $e", context);
      return false;
    }
  }

}
