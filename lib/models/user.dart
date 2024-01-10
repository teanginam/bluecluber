class Users {
  final String uid;
  final String name;
  final String department;
  final String phoneNumber;
  final String studentID;

/// loadedStatus, joinedStatus 둘다 Map 만들어서 <클럽id, bool> 값으로
  final List<String> applicationList;
// List membership;

  Users({
    required this.uid,
    required this.name,
    required this.department,
    required this.phoneNumber,
    required this.studentID,
    required this.applicationList,
  });

  factory Users.fromJson(Map<String, dynamic> json, String uid) {
    return Users(
      uid: uid,
      name: json['name'] ?? '',
      department: json['department'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      studentID: json['studentID'] ?? '',
      applicationList: List<String>.from(json['applicationList'] ?? []),
    );
  }

}

