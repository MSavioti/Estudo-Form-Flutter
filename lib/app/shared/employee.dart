import 'package:flutter/material.dart';

enum Gender { Masculine, Feminine, NonBinary, Undisclosed }

enum Sector {
  Administration,
  Cleaning,
  Communication,
  Development,
  Management,
  HumanResources,
  Maintenance,
  Finances,
  Marketing,
  Legal,
  Tutoring,
}

enum HealthRecord {
  Fracture,
  BackPain,
  HeatBurn,
  Allergy,
  MusculoskeletalDisorder,
  Anxiety,
  Depression,
  RSI,
  Other,
}

enum ExperienceLevel { Trainee, Junior, Middle, Senior }

class Employee {
  String name = ''; // text field
  Gender gender = Gender.Undisclosed; // dropdown menu
  Sector sector = Sector.Administration; // radio
  DateTime dateOfBirth = DateTime.now(); // date
  ExperienceLevel level = ExperienceLevel.Trainee; // slider
  // bool hadHealthProblem = false; // conditional showing
  Set<HealthRecord> healthRecord = {}; // checkbox group
  TimeOfDay workingHoursStart = TimeOfDay(hour: 0, minute: 0); // time picker
  TimeOfDay workingHoursEnd = TimeOfDay(hour: 0, minute: 0); // time picker
  bool agreementAccepted = false; // switch toggle
  DateTime agreementDate = DateTime.now();

  @override
  String toString() {
    String text = '';
    final genderString = gender.toString().split('.').last;
    text += 'Employee: $name\n\nGender: $genderString\n\nDate of Birth: ';
    text += '${dateOfBirth.month}/${dateOfBirth.day}/${dateOfBirth.year}\n\n';
    final sectorString = sector.toString().split('.').last;
    text += 'Sector: $sectorString\n\n';
    text += 'Works from: ${workingHoursStart.hour}:${workingHoursStart.minute}';
    text += ' to: ${workingHoursEnd.hour}:${workingHoursEnd.minute}\n\n';

    if (healthRecord.length > 0) {
      text += 'Current or past health problems: ';
      healthRecord.forEach((record) {
        text += '${record.toString().split('.').last}, ';
      });
    } else {
      text += 'No health problems.';
    }

    text += '\n\n';
    text += 'Level of experience: ${level.toString().split('.').last}\n\n';
    text += 'Has agreed to our terms on $agreementDate';
    return text;
  }
}
