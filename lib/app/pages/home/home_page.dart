import 'package:estudo_form/app/pages/add_employee/add_employee_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add employee'),
      ),
      body: AddEmployeePage(),
    );
  }
}
