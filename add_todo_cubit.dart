import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/cubit/todo_event.dart';
import 'package:login/cubit/common_state.dart';
import 'package:login/repository/inote_repository.dart';

class AddTodoCubit extends Bloc<TodoEvent,CommonState> {
  final INoteRepository repository;
  AddTodoCubit({required this.repository}) : super(CommonInitialState()){
    on<AddTodoEvent>((event, emit) async{
      emit(CommonLoadingState());
    final res = await repository.addTodo(title:event.title ,description:event.description);
    res.fold((err) => emit(CommonErrorState(message: err)),
        (data) => emit(CommonSuccessState(data: data)));
    },
    transformer: droppable()
    );
  }
}
