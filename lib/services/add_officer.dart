import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addOfficer(
    birthdate, name, email, contactnumber, age, gender, address) async {
  final docUser = FirebaseFirestore.instance
      .collection('Officers')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  final json = {
    'birthdate': birthdate,
    'name': name,
    'email': email,
    'contactnumber': contactnumber,
    'age': age,
    'gender': gender,
    'address': address,
    'location': {
      'lat': 0.00,
      'long': 0.00,
    },
    'status': 'Active',
    'id': docUser.id,
    'profilePicture': 'https://cdn-icons-png.flaticon.com/256/149/149071.png',
  };

  await docUser.set(json);
}
