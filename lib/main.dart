import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:simple_saral_assignment/screens/home_screen.dart';

final HttpLink httpLink = HttpLink("http://10.0.2.2:1337/graphql");
final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
  GraphQLClient(
    link: httpLink,
    cache: GraphQLCache(),
  ),
);

void main() async {
  await initHiveForFlutter();
  final HttpLink httpLink = HttpLink(
    'https://api.github.com/graphql',
  );
  final AuthLink authLink = AuthLink(
    getToken: () async => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
    // OR
    // getToken: () => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
  );
  final Link link = authLink.concat(httpLink);
  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: link,
      // The default store is the InMemoryStore, which does NOT persist to disk
      cache: GraphQLCache(store: HiveStore()),
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}
