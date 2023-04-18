import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  FirestoreHelper._();

  static final FirestoreHelper firestoreHelper = FirestoreHelper._();

  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllRecords() {
    return db.collection("students").snapshots();
  }

  Future<void> insertRecord({required Map<String, dynamic> data}) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await db.collection("counter").doc("student_counter").get();

    Map<String, dynamic>? counterData = documentSnapshot.data();

    int counter = counterData!['counter'];
    int length = counterData!['length'];

    counter++;
    length++;

    await db.collection("students").doc("$counter").set(data);

    await db
        .collection("counter")
        .doc("student_counter")
        .update({"counter": counter, "length": length});
  }

  Future<void> deleteRecord({required String id}) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await db.collection("counter").doc("student_counter").get();

    Map<String, dynamic>? counterData = documentSnapshot.data();

    int length = counterData!['length'];

    await db.collection("students").doc(id).delete();

    length--;

    await db
        .collection("counter")
        .doc("student_counter")
        .update({"length": length});
  }

  Future<void> updateRecord(
      {required String id, required Map<String, dynamic> data}) async {
    await db.collection("students").doc(id).update(data);
  }
}
