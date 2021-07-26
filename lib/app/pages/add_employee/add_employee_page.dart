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
  final TextEditingController _sectorController = TextEditingController();
  final TextEditingController _healthController = TextEditingController();
  Gender currentGender = Gender.Undisclosed;
  Sector currentSector = Sector.Administration;
  Set<HealthRecord> currentHealthRecord = {};
  bool isOutsourced = false;
  bool hadHealthProblem = false;
  bool agreementAccepted = false;
  double levelValue = 0.0;
  ExperienceLevel currentLevel = ExperienceLevel.Trainee;
  DateTime dateOfBirth = DateTime.now();

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _sectorController.dispose();
    _healthController.dispose();
    super.dispose();
  }

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
                      flex: 4,
                      child: DropdownButtonFormField<Gender>(
                        hint: Text('Gender'),
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
                        readOnly: true,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Date of birth',
                          hintText: 'Employee\'s date of birth...',
                          hintStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
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
              TextFormField(
                controller: _sectorController,
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

                  _sectorController.text = currentSector.toString();
                },
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
                                  text += '$healthRecord, ';
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
              Row(
                children: [
                  Row(
                    children: [
                      Text(
                        'The employee has accepted to our ',
                        maxLines: 2,
                      ),
                      TextButton(
                        child: Text(
                          'agreement terms',
                          maxLines: 2,
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Terms'),
                                  content: Text(
                                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer at neque pellentesque, aliquam lectus et, sollicitudin tortor. Curabitur id sem iaculis, tincidunt risus non, tristique urna.'),
                                  actions: [
                                    TextButton(
                                      child: Text('Close'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                      ),
                    ],
                  ),
                  Switch(
                    value: agreementAccepted,
                    onChanged: (value) {
                      setState(() {
                        agreementAccepted = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
