
class NoteModel {
  final String id; // Document ID (optional)
  final String name;
  final String description;
  final DateTime createdAt;
  final String uid; // User ID

  NoteModel({
    required this.name,
    required this.description,
    required this.createdAt,
    this.id = '',
    required this.uid,
  });

  // You can also add methods for converting to/from Map representation
  // for easier interaction with Firestore

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'createdAt': createdAt.millisecondsSinceEpoch,
      // Store timestamps in milliseconds
      'uid': uid,
    };
  }

  static NoteModel fromMap(Map<String, dynamic> map, dynamic id) {
    return NoteModel(
      id: id,
      name: map['name'] ?? "",
      description: map['description'] ?? "",

      createdAt: map['createdAt'] == null
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      uid: map['uid'] ?? "",
    );
  }
}
