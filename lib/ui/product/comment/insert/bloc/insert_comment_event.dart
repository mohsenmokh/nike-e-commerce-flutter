part of 'insert_comment_bloc.dart';

sealed class InsertCommentEvent extends Equatable {
  const InsertCommentEvent();

  @override
  List<Object> get props => [];
}

class InsertCommentFormSubmit extends InsertCommentEvent {
  final String title;
  final String content;

  const InsertCommentFormSubmit(this.title, this.content);
  @override
  List<Object> get props => [title, content];
}
