import 'package:flutter/material.dart';
import 'package:walmart/widget/email_text_field.dart';
import 'package:walmart/widget/name_textfield.dart';
import 'package:walmart/widget/password_field.dart';

class FormWidgetFactory {
  static Widget createEmailTextField(TextEditingController emailController) {
    return EmailTextField(controller: emailController);
  }

  static Widget createNameTextField(TextEditingController nameController) {
    return NameTextFormWidget(
      nameController: nameController,
    );
  }

  static Widget createPasswordTextfield(
      TextEditingController passwordController) {
    return PasswordTextfield(controller: passwordController);
  }
}
