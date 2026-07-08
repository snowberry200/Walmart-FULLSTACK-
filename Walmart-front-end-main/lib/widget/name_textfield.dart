import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walmart/bloc/auth_bloc.dart' show AuthBloc;
import 'package:walmart/bloc/auth_state.dart';

class NameTextFormWidget extends StatefulWidget {
  final TextEditingController? nameController;

  const NameTextFormWidget({
    Key? key,
    required this.nameController,
  }) : super(key: key);

  @override
  State<NameTextFormWidget> createState() => NameTextFormWidgetState();
}

class NameTextFormWidgetState extends State<NameTextFormWidget> {
  late TextEditingController nameController;

  @override
  void initState() {
    nameController = widget.nameController ?? TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return TextFormField(
          validator: (name) {
            if (name == null || name.trim().isEmpty) {
              return 'Please enter your name';
            }
            if (name.trim().length < 3) {
              return 'Name must be at least 3 characters';
            }
            if (name.trim().length > 50) {
              return 'Name must be less than 50 characters';
            }
            // Check for invalid characters
            if (!RegExp(r'^[a-zA-Z\s\-\.]+$').hasMatch(name.trim())) {
              return 'Name contains invalid characters';
            }
            return null;
          },
          textAlign: TextAlign.start,
          controller: nameController,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide()),
              labelText: 'name',
              labelStyle: const TextStyle(
                fontSize: 16,
              )),
          keyboardType: TextInputType.name,
          autofillHints: const [AutofillHints.name],
        );
      },
    );
  }
}
