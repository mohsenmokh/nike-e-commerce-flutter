// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:dio/dio.dart';
import 'package:flutter_application_2/data/comment.dart';
import 'package:flutter_application_2/data/common/http_response_validator.dart';

abstract class ICommentDataSource {
  Future<List<CommentEntity>> getAll({required int productId});
  Future<CommentEntity> insert(String title, String content, int productId);
}

class CommentRemoteDataSource
    with HttpResponseValidator
    implements ICommentDataSource {
  final Dio httpClient;

  CommentRemoteDataSource(this.httpClient);
  @override
  Future<List<CommentEntity>> getAll({required int productId}) async {
    final response = await httpClient.get('comment/list?product_id=$productId');
    validateResponse(response);
    final comments = <CommentEntity>[];
    (response.data as List).forEach((element) {
      comments.add(CommentEntity.fromJson(element));
    });
    return comments;
  }

  @override
  Future<CommentEntity> insert(
      String title, String content, int productId) async {
    final response = await httpClient.post('comment/add',
        data: {'title': title, 'content': content, 'product_id': productId});
    return CommentEntity.fromJson(response.data);
  }
}
