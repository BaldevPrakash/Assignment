import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../main.dart';

class ToDoListScreen extends StatefulWidget {
  const ToDoListScreen({super.key});

  @override
  State<ToDoListScreen> createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  final PageController pageController = PageController(initialPage: 0);
  late final int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text('Tasks'),centerTitle: true,
      ),
      body: Query(
        options: QueryOptions(
          document: gql("""
                query {
                  tasks {
                    data {
                      id
                      attributes {
                        Title
                        Description
                        Completed
                      }
                    }
                  }
                }
                """),
        ),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            // Query encountered an error
            print('Query Error: ${result.exception.toString()}');
            return const Center(
              child: Text('An error occurred'),
            );
          }
          if (result.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final List posts = result.data!['tasks']['data'];
          if (posts.isEmpty) {
            return const Center(
              child: Text('No Tasks are made.'),
            );
          } else {
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                final title = post['attributes']['Title'];
                final description = post['attributes']['Description'];
                final completed = post['attributes']['Completed'];
                return ListTile(
                  leading: Checkbox(value: completed, onChanged: null),
                  title: Text(title),
                  subtitle: Text(description),
                  trailing: SizedBox(
                    width: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/edit',
                              arguments: {
                                "userID": post['id'],
                                "Title": title,
                                "Description": description,
                                "Completed": completed,
                                'isCreate': false,
                              },
                            );
                          },
                          child: Icon(
                            Icons.edit_note,
                            size: 25,
                            color: Colors.blue.shade500,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            // Perform delete operation here
                            final Map<String, dynamic> variables = {
                              'id': post['id'],
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
                                // Mutation was completed successfully
                                print('Mutation Result: $resultData');
                                // Redirect to the profile screen after successful deletion
                                Navigator.pushReplacementNamed(
                                    context, '/tasks');
                              },
                            );
                            client.value.mutate(options);
                          },
                          child: Icon(
                            Icons.delete_outline_rounded,
                            size: 25,
                            color: Colors.red.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/edit',
            arguments: {
              'appId': '',
              'Title': '',
              'Description': '',
              'Completed': false,
              'isCreate': true,
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 5.0,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.blue,
            currentIndex: _selectedIndex,
            unselectedItemColor: Colors.blue,
            onTap: null,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
