import 'package:estudo_form/app/shared/employee.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AddEmployeePage extends StatefulWidget {
  const AddEmployeePage({Key? key}) : super(key: key);

  @override
  _AddEmployeePageState createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _sectorController = TextEditingController();
  final TextEditingController _healthController = TextEditingController();
  final TextEditingController _workStartController = TextEditingController();
  final TextEditingController _workEndController = TextEditingController();
  final TapGestureRecognizer _tapRecognizer = TapGestureRecognizer();
  final String url = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ';
  Gender currentGender = Gender.Undisclosed;
  Sector currentSector = Sector.Administration;
  Set<HealthRecord> currentHealthRecord = {};
  bool hadHealthProblem = false;
  bool agreementAccepted = false;
  double levelValue = 0.0;
  ExperienceLevel currentLevel = ExperienceLevel.Trainee;
  DateTime dateOfBirth = DateTime.now();
  TimeOfDay workStartTime = TimeOfDay.now();
  TimeOfDay workEndTime = TimeOfDay.now();

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _sectorController.dispose();
    _healthController.dispose();
    _workStartController.dispose();
    _workEndController.dispose();
    _tapRecognizer.dispose();
    super.dispose();
  }

  void _setEmployeeLevel(double value) {
    setState(() {
      levelValue = value;
      final int levelIndex = int.parse(levelValue.toString()[0]);
      currentLevel = ExperienceLevel.values[levelIndex];
    });
  }

  void _openAgreementUrl() async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      }
    } catch (e) {
      print(e);
    }
  }

  String? _validateTextField(String? inputText) {
    if ((inputText == null) || (inputText.isEmpty)) {
      return 'This field can\'t be left blank';
    }

    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && agreementAccepted) {
      final Employee employee = _createEmployee();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('$employee'),
          );
        },
      );
    }
  }

  Employee _createEmployee() {
    Employee employee = Employee();
    employee.name = _nameController.text;
    employee.gender = currentGender;
    employee.dateOfBirth = dateOfBirth;
    employee.sector = currentSector;
    employee.workingHoursStart = workStartTime;
    employee.workingHoursEnd = workEndTime;
    employee.healthRecord = hadHealthProblem ? currentHealthRecord : {};
    employee.level = currentLevel;
    employee.agreementAccepted = agreementAccepted;
    employee.agreementDate = DateTime.now();
    return employee;
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
                controller: _nameController,
                validator: _validateTextField,
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
                      flex: 4,
                      child: DropdownButtonFormField<Gender>(
                        items: Gender.values
                            .map<DropdownMenuItem<Gender>>(
                              (gender) => DropdownMenuItem(
                                child: Text(gender.toString().split('.').last),
                                value: gender,
                              ),
                            )
                            .toList(),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Gender',
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
                        validator: _validateTextField,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Date of birth',
                        ),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          setState(() {
                            try {
                              _dateController.text =
                                  '${date!.month}/${date.day}/${date.year}';
                            } catch (e) {
                              _dateController.text = '';
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _sectorController,
                validator: _validateTextField,
                readOnly: true,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Sector',
                  hintText: 'Employee\'s sector...',
                  hintStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        title: Text('Select the employee\' sector:'),
                        children: [
                          StatefulBuilder(
                            builder: (context, setState) {
                              return SingleChildScrollView(
                                child: Column(
                                  children: Sector.values
                                      .map<RadioListTile<Sector>>(
                                        (sector) => RadioListTile<Sector>(
                                          title: Text(sector.toString()),
                                          value: sector,
                                          groupValue: currentSector,
                                          onChanged: (Sector? sector) {
                                            setState(() {
                                              currentSector = sector!;
                                              Navigator.pop(context);
                                            });
                                          },
                                        ),
                                      )
                                      .toList(),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );

                  _sectorController.text =
                      currentSector.toString().split('.').last;
                },
              ),
              SizedBox(height: 16.0),
              SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        validator: _validateTextField,
                        controller: _workStartController,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Working hours start',
                        ),
                        onTap: () async {
                          final TimeOfDay? time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );

                          if (time != null) {
                            workStartTime = time;
                            _workStartController.text =
                                '${time.hour}:${time.minute}';
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 32.0,
                    ),
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        controller: _workEndController,
                        validator: _validateTextField,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Working hours end',
                        ),
                        onTap: () async {
                          final TimeOfDay? time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );

                          if (time != null) {
                            workEndTime = time;
                            _workEndController.text =
                                '${time.hour}:${time.minute}';
                          }
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
                  Checkbox(
                    value: hadHealthProblem,
                    onChanged: (bool? value) {
                      setState(() {
                        hadHealthProblem = value!;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      'Does the employee have any health problems?',
                      maxLines: 2,
                      // style: TextStyle(fontSize: 12.0),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: hadHealthProblem,
                child: TextFormField(
                  controller: _healthController,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Health record',
                    hintText: 'Employee\'s health record...',
                    hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: StatefulBuilder(
                            builder: (context, setState) {
                              return SingleChildScrollView(
                                child: Column(
                                  children: HealthRecord.values
                                      .map<CheckboxListTile>((healthRecord) {
                                    return CheckboxListTile(
                                        title: Text(healthRecord.toString()),
                                        value: currentHealthRecord
                                            .contains(healthRecord),
                                        onChanged: (value) {
                                          setState(() {
                                            value!
                                                ? currentHealthRecord
                                                    .add(healthRecord)
                                                : currentHealthRecord
                                                    .remove(healthRecord);
                                          });
                                        });
                                  }).toList(),
                                ),
                              );
                            },
                          ),
                          actions: [
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                String text = '';
                                currentHealthRecord.forEach((healthRecord) {
                                  text +=
                                      '${healthRecord.toString().split('.').last}, ';
                                });
                                _healthController.text = text;
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );

                    _sectorController.text = currentSector.toString();
                  },
                ),
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
              Row(
                children: [
                  Flexible(
                    flex: 5,
                    child: RichText(
                      maxLines: 3,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'The employee has accepted our ',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: 'agreement terms',
                            style: TextStyle(
                              color: Colors.blue[300],
                            ),
                            recognizer: _tapRecognizer
                              ..onTap = _openAgreementUrl,
                          ),
                          TextSpan(
                            text: '.',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Switch(
                      value: agreementAccepted,
                      onChanged: (value) {
                        setState(() {
                          agreementAccepted = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(),
                    onPressed: _submitForm,
                    child: Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
