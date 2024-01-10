List<String> categories = [
  '전체',
  '체육 1분과',
  '체육 2분과',
  '문화 1분과',
  '문화 2분과',
  '교양분과',
  '봉사분과',
  '학술분과',
  '종교분과',
];

class Notification {
  final String notiText;
  final String subText;
  final DateTime notiDate;

  Notification({
    required this.notiText,
    required this.subText,
    required this.notiDate,
  });
}
