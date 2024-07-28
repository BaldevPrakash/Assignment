import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ToDoListController extends GetxController {
  final List posts = [];

  final RxString _selectedTab = RxString('');

  String get selectedTab => _selectedTab.value;

  setSelectedTab(String value) {
    _selectedTab.value = value;
  }

  final RxString _userID = RxString('');

  String get userID => _userID.value;

  setUserID(String value) {
    _userID.value = value;
  }

  final RxString _title = RxString('');

  String get title => _title.value;

  setTitle(String value) {
    _title.value = value;
  }

  final RxString _description = RxString('');

  String get description => _description.value;

  setDescription(String value) {
    _description.value = value;
  }

  final RxBool _completed = RxBool(false);

  bool get completed => _completed.value;

  setCompleted(bool value) {
    _completed.value = value;
  }

  final titleController = TextEditingController();
  final emailController = TextEditingController();
  final descriptionController = TextEditingController();
  final useridController = TextEditingController();
}
