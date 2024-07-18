import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/constants/app_color.dart';
import 'package:notes/constants/app_string.dart';
import 'package:notes/custom_widgets/app_textfield_with_label.dart';
import 'package:notes/custom_widgets/icon_custom_button.dart';
import 'package:notes/custom_widgets/progress_button.dart';
import 'package:notes/module/Auth/presentation/pages/login_screen.dart';
import 'package:notes/module/home/presentation/pages/home_screen.dart';
import 'package:notes/utils/global_value.dart';
import 'package:notes/utils/size_utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool autoValidate = false;
  ButtonState signInButtonState = ButtonState.idle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: getPadding(all: 20),
          child: Column(
            children: [
              _buildForm(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      autovalidateMode:
          autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
      key: formKey,
      child: Padding(
        padding: getPadding(left: 8, right: 8, top: 70, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: Text(
                AppStrings.register,
                style: TextStyle(
                  color: AppColors.blackFont,
                  fontSize: getSize(27),
                ),
              ),
            ),
            SizedBox(
              height: getVerticalSize(10),
            ),
            AppTextFieldWithLabel(
              validator: (value) {
                if (GlobalValue.regexForEmail.hasMatch(value!.trim())) {
                  // return valid
                } else if (value.trim().isEmpty) {
                  return AppStrings.emailRequired;
                } else {
                  return AppStrings.notValidEmail;
                }
                return null;
              },
              textCapitalization: TextCapitalization.none,
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              textInputAction: TextInputAction.next,
              onChanged: (p0) {},
              labelText: "Email",
              hintText: "Enter email",
            ),
            SizedBox(
              height: getVerticalSize(10),
            ),
            AppTextFieldWithLabel(
              validator: (value) {
                if (GlobalValue.regexForPass.hasMatch(value!)) {
                  // return valid
                } else if (value.trim().isEmpty) {
                  return 'Password is required.';
                }
                return null;
              },
              controller: passwordController,
              textCapitalization: TextCapitalization.none,
              textInputAction: TextInputAction.done,
              onChanged: (p0) {},
              suffixIcon: InkWell(
                onTap: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
                child: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.grey,
                ),
              ),
              obscureText: !isPasswordVisible,
              labelText: AppStrings.password,
              hintText: AppStrings.enterPassword,
            ),
            SizedBox(
              height: getVerticalSize(20),
            ),
            signInCustomButton(context, onPressed: () {
              hideKeyboard(context);
              setState(() {
                autoValidate = true;
              });
              _validateForm(
                  context, emailController.text, passwordController.text);
            }),
            SizedBox(
              height: getVerticalSize(10),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                InkWell(
                  onTap: () {
                    Get.offAll(() => const LoginScreen());
                  },
                  child: Text(
                    'Sign in',
                    style: TextStyle(color: AppColors.brickButtonBG),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget signInCustomButton(BuildContext context, {Function? onPressed}) {
    return ProgressButton.icon(
      maxWidth: size.width,
      minWidth: getHorizontalSize(55.0),
      radius: signInButtonState == ButtonState.idle ? 5.0 : 100.0,
      textStyle: TextStyle(
          fontSize: getFontSize(20),
          letterSpacing: 0.2,
          color: AppColors.white),
      iconCustomButton: {
        ButtonState.idle: IconCustomButton(
            text: 'Sign UP',
            icon: const Icon(
              Icons.send,
              color: Colors.transparent,
              size: 0,
            ),
            color: AppColors.sectionText),
        ButtonState.loading:
            IconCustomButton(text: "Loading", color: AppColors.sectionText),
        ButtonState.fail: const IconCustomButton(
            text: "Failed",
            icon: Icon(Icons.cancel, color: Colors.white),
            color: Colors.red),
        ButtonState.success: const IconCustomButton(
            text: 'Login Successful',
            icon: Icon(
              Icons.send,
              color: Colors.transparent,
              size: 0,
            ),
            color: Colors.green),
      },
      onPressed: onPressed as void Function()?,
      state: signInButtonState,
    );
  }

  void _validateForm(BuildContext context, String email, String pass) {
    if (formKey.currentState!.validate()) {
      if (FocusScope.of(context).hasFocus) {
        FocusScope.of(context).unfocus();
      }
      Get.offAll(() => const HomeScreen());
    }
  }

  void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
