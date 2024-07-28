import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:simple_saral_assignment/screens/create_and_edit_to_do_screen.dart';
import 'package:simple_saral_assignment/screens/to_do_list_screen.dart';

import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const ToDoListScreen(),
          '/tasks': (context) => const ToDoListScreen(),
          '/edit': (context) => const CreateAndEditToDoListScreen(),
        },
      ),
    );
  }
}
