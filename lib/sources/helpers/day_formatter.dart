class DayFormatter {
  static String dateToLocal({DateTime? time}){
    switch (time!.weekday) {
      case DateTime.monday:
        return "Senin";
      case DateTime.tuesday:
        return "Selasa";
      case DateTime.wednesday:
        return "Rabu";
      case DateTime.thursday:
        return "Kamis";
      case DateTime.friday:
        return "Jum'at";
      case DateTime.saturday:
        return "Sabtu";
      case DateTime.sunday:
        return "Ahad";
      default:
        return "Kosong";
    }
  }
}