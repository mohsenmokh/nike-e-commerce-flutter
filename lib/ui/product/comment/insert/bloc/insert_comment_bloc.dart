import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_2/common/exceptions.dart';
import 'package:flutter_application_2/data/comment.dart';
import 'package:flutter_application_2/data/repo/auth_repository.dart';
import 'package:flutter_application_2/data/repo/comment_repository.dart';

part 'insert_comment_event.dart';
part 'insert_comment_state.dart';

class InsertCommentBloc extends Bloc<InsertCommentEvent, InsertCommentState> {
  final int productId;
  final ICommentRepository commentRepository;
  InsertCommentBloc(this.commentRepository, this.productId)
      : super(InsertCommentInitial()) {
    on<InsertCommentEvent>((event, emit) async {
      if (event is InsertCommentFormSubmit) {
        if (!AuthRepository.isUserLoggedIn()) {
          emit(InsertCommentErorr(
              AppException(message: 'لطفا وارد حساب کاربری خود شوید')));
        } else {
          if (event.title.isNotEmpty && event.content.isNotEmpty) {
            try {
              emit(InsertCommentLoading());
              final comment = await commentRepository.insert(
                  event.title, event.content, productId);
              emit(InsertCommentSuccess(comment,'نظر شما با موفقیت ثبت شد'));
            } catch (e) {
              emit(InsertCommentErorr(AppException()));
            }
          } else {
            emit(InsertCommentErorr(AppException(
                message: 'عنوان و متن مورد نظر خود را وارد کنید')));
          }
        }
      }
    });
  }
}
