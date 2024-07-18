import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:notes/constants/app_color.dart';
import 'package:notes/module/home/presentation/Getx/home_screen_controller.dart';
import 'package:notes/routes/routes.dart';
import 'package:notes/utils/navigator_service.dart';
import 'package:notes/utils/size_utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.sectionText,
        title: const Text("Notes"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.exit_to_app_rounded,
              color: AppColors.blackFont,
            ),
          ),
        ],
      ),
      body: GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) {
          return todoListView(controller);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: floatingActionBtn(),
    );
  }

  Widget floatingActionBtn() {
    return FloatingActionButton(
      shape: const StadiumBorder(),
      backgroundColor: AppColors.sectionText,
      onPressed: () {
        NavigatorService.pushNamed(AppRoutes.todoForm);
      },
      child: const Icon(Icons.add),
    );
  }

  Widget todoListView(HomeController controller) {
    return Obx(() {
      if (controller.notesList.isEmpty) {
        return const Center(child: Text("No Data Found!"));
      } else {
        return Column(
          children: [
            if (controller.notesList.isNotEmpty) todayNotesCount(controller),
            Expanded(
              child: ListView.builder(
                itemCount: controller.notesList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var todoDetails = controller.notesList[index];
                  return Padding(
                    padding: getPadding(all: 8),
                    child: Dismissible(
                      key: UniqueKey(),
                      background: Container(
                        color: Colors.red,
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      direction: DismissDirection.endToStart,
                      secondaryBackground: Container(
                        color: Colors.red,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: getPadding(right: 20),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onDismissed: (direction) {
                        if (direction == DismissDirection.endToStart) {
                          controller.deleteNotes(todoDetails.id);
                        }
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    todoDetails.name ?? "",
                                    style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      log("doc ID====> ${todoDetails.id}");
                                      NavigatorService.pushNamed(
                                          AppRoutes.todoForm,
                                          arguments: {
                                            'isEdit': true,
                                            'title': todoDetails.name,
                                            'docId': todoDetails.id,
                                            'description':
                                                todoDetails.description,
                                          });
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),
                                ],
                              ),
                              if (todoDetails.description.isNotEmpty)
                                Text(
                                  todoDetails.description,
                                  maxLines: 20,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }
    });
  }

  Widget todayNotesCount(HomeController controller) {
    return Padding(
      padding: getPadding(all: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Notes",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: getPadding(all: 10),
                decoration: const BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "${controller.notesList.length}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
