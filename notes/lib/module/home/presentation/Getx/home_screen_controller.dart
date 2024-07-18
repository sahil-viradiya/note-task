import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notes/constants/app_constants.dart';
import 'package:notes/module/home/data/model/note_model.dart';
import 'package:uuid/uuid.dart';

class HomeController extends GetxController {
  var fireStore = FirebaseFirestore.instance.collection('notes');
  TextEditingController titleCtrl = TextEditingController();
  TextEditingController descCtrl = TextEditingController();

  var isLoading = false.obs;
  var notesList = <NoteModel>[].obs;
  var autoValidate = false.obs;

  late String userId;

  @override
  void onInit() {
    super.onInit();
    userId = _generateRandomUserId();
    _initNotes();
  }

  String _generateRandomUserId() {
    var uuid = const Uuid();
    return uuid.v4(); // Generates a random UUID
  }

  void _initNotes() {

    isLoading.value = true;
    fireStore.where('uid', isEqualTo: userId).snapshots().listen((snapshot) {
      List<NoteModel> newList = [];
      var notes = snapshot.docs
          .map((doc) => NoteModel.fromMap(doc.data(), doc.id))
          .toList();
      notes.map((e) {
        if (DateFormat("MM-dd-yyyy").format(e.createdAt) ==
            DateFormat("MM-dd-yyyy").format(DateTime.now())) {
          newList.add(e);
        }
      }).toList();
      newList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      notesList.value = newList;
      isLoading.value = false;
    });
  }

  void addNotes(BuildContext context) async {
    log("User ID: $userId");
    isLoading.value = true;
    final todo = NoteModel(
      name: titleCtrl.text.trim(),
      description: descCtrl.text.trim(),
      createdAt: DateTime.now(),
      uid: userId,
    );
    await fireStore.add(todo.toMap()).then((documentReference) {
      notesList.add(todo);
      _initNotes();
      isLoading.value = false;
      Navigator.pop(context);
      titleCtrl.clear();
      descCtrl.clear();
      showToast("Task added successfully!");
      log('Document added with ID: ${documentReference.id}');
    }).catchError((error) {
      isLoading.value = false;
      showToast("Something went wrong!");
    });
  }

  void updateNotes(
      String docId, bool completed, BuildContext context) async {
    isLoading.value = true;
    await fireStore.doc(docId).update({
      'description': descCtrl.text.trim(),
      'name': titleCtrl.text.trim(),
    }).then((value) {
      _initNotes(); // Refresh the todo list
      isLoading.value = false;
      showToast("Task updated");
      Navigator.pop(context);
      titleCtrl.clear();
      descCtrl.clear();
    }).catchError((error) {
      log("message: ${error.toString()}");
      isLoading.value = false;
      showToast("Something went wrong");
    });
  }

  void deleteNotes(String docId) async {
    await fireStore.doc(docId).delete().then((value) {
      notesList.removeWhere((note) => note.id == docId);
      showToast("Task deleted successfully!");
    }).catchError((error) {
      showToast("Something went wrong!");
    });
  }
}
