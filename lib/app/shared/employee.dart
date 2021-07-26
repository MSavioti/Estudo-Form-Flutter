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
  bool isOutsourced = false; // checkbox
  Sector sector = Sector.Administration; // radio
  DateTime dateOfBirth = DateTime.now(); // date
  ExperienceLevel level = ExperienceLevel.Trainee; // slider
  bool hadHealthProblem = false; // conditional showing
  Set<HealthRecord> healthRecord = {}; // checkbox group
  TimeOfDay workingHoursStart = TimeOfDay(hour: 0, minute: 0); // time picker
  TimeOfDay workingHoursEnd = TimeOfDay(hour: 0, minute: 0); // time picker
  bool agreementAccepted = false; // switch toggle
}
