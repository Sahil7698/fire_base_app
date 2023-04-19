import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_base_app/helper/fire_base_datahelper.dart';
import 'package:fire_base_app/helper/fire_base_helper.dart';
import 'package:flutter/material.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({Key? key}) : super(key: key);

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  final GlobalKey<FormState> insertFormKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController courseController = TextEditingController();

  String? name;
  int? age;
  String? course;

  @override
  Widget build(BuildContext context) {
    //Map<String,dynamic> data = ModelRoute.of(context)!.settings.arguments as Map<String,dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "HomePage",
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuthHelper.firebaseAuthHelper.logOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('login_page', (route) => false);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("students").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error : ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            QuerySnapshot<Map<String, dynamic>>? data = snapshot.data;

            if (data == null) {
              return const Center(
                child: Text("No any data available"),
              );
            } else {
              List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs =
                  data.docs;

              return ListView.builder(
                  itemCount: allDocs.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      isThreeLine: true,
                      leading: Text(allDocs[i].id),
                      title: Text("${allDocs[i].data()['name']}"),
                      subtitle: Text(
                          "${allDocs[i].data()['course']}\nAge: ${allDocs[i].data()['age']}"),
                      trailing: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () async {
                                Map<String, dynamic> updatedRecord = {
                                  "name": "Rahul",
                                  "age": 23,
                                  "course": "PHP"
                                };
                                await FirestoreHelper.firestoreHelper
                                    .updateRecord(
                                        id: allDocs[i].id, data: updatedRecord);
                              },
                              icon: const Icon(Icons.edit)),
                          IconButton(
                              onPressed: () async {
                                await FirestoreHelper.firestoreHelper
                                    .deleteRecord(id: allDocs[i].id);
                              },
                              icon: const Icon(Icons.delete)),
                        ],
                      ),
                    );
                  });
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: validateAndInsert,
        child: const Icon(Icons.add),
      ),
    );
  }

  void validateAndInsert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(
          child: Text("Add Record"),
        ),
        content: Form(
          key: insertFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Enter name First...";
                  }
                  return null;
                },
                onSaved: (val) {
                  name = val;
                },
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter name here...",
                  labelText: "Name",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: ageController,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Enter age First...";
                  } else if (val.length > 2) {
                    return "Enter valid age..";
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                onSaved: (val) {
                  age = int.parse(val!);
                },
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter age here...",
                  labelText: "Age",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: courseController,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Enter course First...";
                  }
                  return null;
                },
                onSaved: (val) {
                  course = val;
                },
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter course here...",
                  labelText: "Course",
                ),
              ),
            ],
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () async {
              if (insertFormKey.currentState!.validate()) {
                insertFormKey.currentState!.save();

                Map<String, dynamic> record = {
                  "name": name,
                  "age": age,
                  "course": course,
                };

                await FirestoreHelper.firestoreHelper
                    .insertRecord(data: record);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    content: Text("Record inserted Successfully.."),
                  ),
                );

                nameController.clear();
                ageController.clear();
                courseController.clear();

                setState(() {
                  name = null;
                  age = null;
                  course = null;
                });

                Navigator.of(context).pop();
              }
            },
            child: const Text("Add"),
          ),
          OutlinedButton(
            onPressed: () {
              nameController.clear();
              ageController.clear();
              courseController.clear();

              setState(() {
                name = null;
                age = null;
                course = null;
              });

              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }
}
