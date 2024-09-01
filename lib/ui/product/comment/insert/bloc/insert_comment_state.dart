part of 'insert_comment_bloc.dart';

sealed class InsertCommentState extends Equatable {
  const InsertCommentState();

  @override
  List<Object> get props => [];
}

class InsertCommentInitial extends InsertCommentState {}

class InsertCommentLoading extends InsertCommentState {}

class InsertCommentErorr extends InsertCommentState {
  final AppException exception;

  const InsertCommentErorr(this.exception);
  @override
  List<Object> get props => [exception];
}

class InsertCommentSuccess extends InsertCommentState {
  final CommentEntity commentEntity;
  final String message;

  const InsertCommentSuccess(this.commentEntity, this.message);
  @override
  List<Object> get props => [commentEntity,message];
}
