import 'package:flutter/material.dart';

class AddIncomeForm extends StatefulWidget {
  const AddIncomeForm({Key? key}) : super(key: key);

  @override
  _AddIncomeFormState createState() => _AddIncomeFormState();
}

class _AddIncomeFormState extends State<AddIncomeForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Income Name',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter name of the income";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
