import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addOfficer(name, username, contactnumber) async {
  final docUser = FirebaseFirestore.instance
      .collection('Officers')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  final json = {
    'name': name,
    'email': username,
    'contactnumber': contactnumber,
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
