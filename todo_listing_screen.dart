import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:login/create_todo_screen.dart';
import 'package:login/cubit/common_state.dart';
import 'package:login/cubit/delete_todo_cubit.dart';
import 'package:login/cubit/fetch_todo_cubit.dart';
import 'package:login/cubit/todo_event.dart';
import 'package:login/to_do/todo.dart';

class TodoListingScreen extends StatefulWidget {
  const TodoListingScreen({super.key});
  @override
  State<TodoListingScreen> createState() => _TodoListingScreenState();
}

class _TodoListingScreenState extends State<TodoListingScreen> {
  navigateToCreateTodo({Todo? todo}) async {
    final result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return CreateTodoScreen(todo: todo);
      },
    ));
    if (result == true) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange.shade50,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Notes",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepOrange,
      ),
      floatingActionButton: DraggableFab(
        child: FloatingActionButton(
          onPressed: () {
            navigateToCreateTodo();
          },
          child: Icon(Icons.add),
        ),
      ),
      body: BlocBuilder<FetchTodoCubit, CommonState>(
        builder: (context, state) {
          if (state is CommonSuccessState<List<Todo>>) {
            if (state.data.isNotEmpty) {
              return ListView.builder(
                  itemCount: state.data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Slidable(
                        endActionPane: ActionPane(
                          motion: ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                setState(() {
                                  context.read<DeleteTodoCubit>().add(
                                      DeleteTodoEvent(
                                          id: state.data[index].id));
                                });
                              },
                              icon: Icons.delete,
                              backgroundColor: Colors.deepOrange.shade100,
                              foregroundColor: Colors.red,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                navigateToCreateTodo(todo: state.data[index]);
                              },
                              icon: Icons.edit,
                              backgroundColor: Colors.deepOrange.shade100,
                              foregroundColor: Colors.red,
                            )
                          ],
                        ),
                        child: Card(
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            tileColor: Colors.deepOrange.shade100,
                            title: Text(
                              state.data[index].title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.deepOrange),
                            ),
                            subtitle: Text(
                              state.data[index].description,
                              style:
                                  TextStyle(color: Colors.deepOrange.shade500),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              return Center(
                child: Text("No Data Found"),
              );
            }
          } else if (state is CommonErrorState) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
        },
      ),
    );
  }
}
