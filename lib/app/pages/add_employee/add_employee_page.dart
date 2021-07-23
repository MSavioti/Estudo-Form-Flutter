import 'package:estudo_form/app/shared/employee.dart';
import 'package:flutter/material.dart';

class AddEmployeePage extends StatefulWidget {
  const AddEmployeePage({Key? key}) : super(key: key);

  @override
  _AddEmployeePageState createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  Gender currentGender = Gender.Undisclosed;
  Sector currentSector = Sector.Administration;
  bool isOutsourced = false;
  double levelValue = 0.0;
  ExperienceLevel currentLevel = ExperienceLevel.Trainee;
  DateTime dateOfBirth = DateTime.now();

  void _setEmployeeLevel(double value) {
    setState(() {
      levelValue = value;
      final int levelIndex = int.parse(levelValue.toString()[0]);
      currentLevel = ExperienceLevel.values[levelIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Name',
                  hintText: 'Employee\'s name...',
                  hintStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Flexible(
                      flex: 5,
                      child: DropdownButtonFormField<Gender>(
                        items: Gender.values
                            .map<DropdownMenuItem<Gender>>(
                              (gender) => DropdownMenuItem(
                                child: Text(gender.toString()),
                                value: gender,
                              ),
                            )
                            .toList(),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: 'Employee\'s gender...',
                          hintStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        onChanged: (Gender? gender) {
                          currentGender = gender!;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 32.0,
                    ),
                    Flexible(
                      flex: 3,
                      child: TextFormField(
                        controller: _dateController,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Date of birth',
                          hintText: 'Date of birth',
                          hintStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now(),
                          );
                          setState(() {
                            try {
                              _dateController.text =
                                  date.toString().substring(0, 10);
                            } catch (e) {}
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Sector'),
                ],
              ),
              Column(
                children: Sector.values
                    .map<RadioListTile<Sector>>(
                      (sector) => RadioListTile<Sector>(
                        title: Text(sector.toString()),
                        value: sector,
                        groupValue: currentSector,
                        onChanged: (Sector? sector) {
                          setState(() {
                            currentSector = sector!;
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: isOutsourced,
                    onChanged: (bool? value) {
                      setState(() {
                        isOutsourced = value!;
                      });
                    },
                  ),
                  Text('Is the employee outsourced?'),
                ],
              ),
              SizedBox(height: 16.0),
              Text('Level: $currentLevel'),
              Slider(
                max: ExperienceLevel.values.length - 1,
                divisions: ExperienceLevel.values.length - 1,
                value: levelValue,
                onChanged: _setEmployeeLevel,
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
