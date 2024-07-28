import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../controller/to_do_list_controller.dart';
import '../main.dart';

class CreateAndEditToDoListScreen extends StatefulWidget {
  const CreateAndEditToDoListScreen({super.key});

  @override
  State<CreateAndEditToDoListScreen> createState() =>
      _CreateAndEditToDoListScreenState();
}

class _CreateAndEditToDoListScreenState
    extends State<CreateAndEditToDoListScreen> {
  late ToDoListController toDoListController;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _useridController = TextEditingController();
  late bool isCreate = false;

  @override
  void initState() {
    super.initState();
    toDoListController = Get.isRegistered<ToDoListController>()
        ? Get.find<ToDoListController>()
        : Get.put(ToDoListController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initCall();
    });
  }

  void initCall() {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    setState(() {
      if (args != null) {
        final String userID = args['userID'] as String? ?? '';
        final String title = args['Title'] as String? ?? '';
        final bool completed = args['Completed'] as bool? ?? false;
        final String description = args['Description'] as String? ?? '';
        final bool isCreate = args['isCreate'] as bool? ?? false;
        this.isCreate = isCreate;
        _useridController.text = userID;
        _titleController.text = title;
        _descriptionController.text = description;
        toDoListController.setCompleted(completed);
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _useridController.dispose();
    super.dispose();
  }

  void _editTaskForm() {
    if (_formKey.currentState!.validate()) {
      String title = _titleController.text;
      String description = _descriptionController.text;
      String userid = _useridController.text;
      bool completed = toDoListController.completed;
      final Map<String, dynamic> variables = {
        'taskId': userid, // Assuming userid is the taskId here
        'Title': title,
        'Description': description,
        'Completed': completed,
      };
      MutationOptions options = MutationOptions(
        document: gql("""
        mutation UpdateTask(\$taskId: ID!, \$Title: String!, \$Description: String!, \$Completed: Boolean!) {
          updateTask(id: \$taskId, data: { Title: \$Title, Description: \$Description, Completed: \$Completed }) {
            data {
              attributes {
                Title
                Description
                Completed
              }
            }
          }
        }
      """),
        variables: variables,
        onCompleted: (dynamic resultData) {
          print('Mutation Result: $resultData');
          // Navigator.pushReplacementNamed(context, '/tasks');
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/tasks',
            (Route<dynamic> route) => false,
          );
        },
      );
      client.value.mutate(options);
    }
  }

  void _createTaskForm() {
    if (_formKey.currentState!.validate()) {
      String title = _titleController.text;
      String description = _descriptionController.text;
      bool completed = toDoListController.completed;
      final Map<String, dynamic> variables = {
        'Title': title,
        'Description': description,
        'Completed': completed,
      };
      MutationOptions options = MutationOptions(
        document: gql("""
              mutation CreateTask(\$Title: String!, \$Description: String!, \$Completed: Boolean!) {
                createTask(data: { Title: \$Title, Description: \$Description, Completed: \$Completed }) {
                  data {
                    attributes {
                      Title
                      Description
                      Completed
                    }
                  }
                }
              }
              """),
        variables: variables,
        onCompleted: (dynamic resultData) {
          print('Mutation Result: $resultData');
          // Navigator.pushNamed(context, '/tasks');
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/tasks',
            (Route<dynamic> route) => false,
          );
        },
      );
      client.value.mutate(options);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(isCreate);
    return Scaffold(
      appBar: AppBar(
        title: Text(isCreate ? 'Create Task' : 'Edit Task'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (!isCreate) ...[
                TextFormField(
                  controller: _useridController,
                  decoration: const InputDecoration(
                    labelText: 'UserID',
                  ),
                  readOnly: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your ID';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
              ],
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your title.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              CompletedCheckBox(),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: isCreate ? _createTaskForm : _editTaskForm,
                child: Text(isCreate ? 'Create Task' : 'Save Changes'),
              ),
              if (!isCreate) ...[
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    final Map<String, dynamic> variables = {
                      'id': _useridController.text,
                    };
                    MutationOptions options = MutationOptions(
                      document: gql('''
                          mutation DeleteTask(\$id: ID!) {
                            deleteTask(id: \$id) {
                              data {
                                attributes {
                                  Title
                                }
                              }
                            }
                          }
                        '''),
                      variables: variables,
                      onCompleted: (dynamic resultData) {
                        print('Mutation Result: $resultData');
                        Navigator.pushReplacementNamed(context, '/tasks');
                      },
                    );
                    client.value.mutate(options);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Delete Task'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class CompletedCheckBox extends StatelessWidget {
  CompletedCheckBox({super.key});

  final ToDoListController toDoListController =
      Get.isRegistered<ToDoListController>()
          ? Get.find<ToDoListController>()
          : Get.put(ToDoListController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Completed'),
          Checkbox(
              value: toDoListController.completed,
              onChanged: (value) {
                toDoListController.setCompleted(value ?? false);
              })
        ],
      ),
    );
  }
}
