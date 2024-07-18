import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/constants/app_color.dart';
import 'package:notes/custom_widgets/app_button.dart';
import 'package:notes/custom_widgets/app_textfield_with_label.dart';
import 'package:notes/module/home/presentation/Getx/home_screen_controller.dart';
import 'package:notes/utils/size_utils.dart';

class NoteForm extends StatelessWidget {
  NoteForm({super.key});

  final formKey = GlobalKey<FormState>();
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    print(arguments["docId"]);

    if (arguments['isEdit'] == true) {
      controller.titleCtrl.text = arguments['title'];
      controller.descCtrl.text = arguments['description'];
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.sectionText,
        title: const Text("Create Note"),
        centerTitle: true,
      ),
      body: Obx(() {
        return Padding(
          padding: getPadding(all: 20),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              autovalidateMode: controller.autoValidate.value
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: Column(
                children: [
                  AppTextFieldWithLabel(
                    maxLength: 80,
                    controller: controller.titleCtrl,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        controller.titleCtrl.text = value.trim();
                        return 'Title is required.';
                      }
                      return null;
                    },
                    labelText: 'Title',
                    hintText: 'Enter title',
                    onChanged: (string) {},
                  ),
                  AppTextFieldWithLabel(
                    maxLength: 250,
                    controller: controller.descCtrl,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        controller.descCtrl.text = value.trim();
                        return 'Description is required.';
                      }
                      return null;
                    },
                    labelText: 'Description',
                    minLines: 3,
                    maxLines: 7,
                    hintText: 'Enter description',
                    onChanged: (string) {},
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  AppButton(
                    color: AppColors.sectionText,
                    onTap: () {
                      controller.autoValidate.value = true;
                      if (arguments['isEdit'] == true) {
                        if (formKey.currentState!.validate()) {
                          log("doc Is=====>>> ${arguments['docId']}");
                          controller.updateNotes(
                              arguments['docId'], true, context);
                        }
                      } else {
                        if (formKey.currentState!.validate()) {
                          controller.addNotes(context);
                        }
                      }
                    },
                    textColor: AppColors.blackFont,
                    buttonText:
                        arguments['isEdit'] == true ? 'Update' : 'Submit',
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
