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
}

enum ExperienceLevel { Trainee, Junior, Middle, Senior }

class Employee {
  String name = ''; // text field
  Gender gender = Gender.Undisclosed; // dropdown menu
  bool isOutsourced = false; // checkbox
  Sector sector = Sector.Administration; // radio
  DateTime dateOfBirth = DateTime.now(); // date
  ExperienceLevel level = ExperienceLevel.Trainee; // slider
}
