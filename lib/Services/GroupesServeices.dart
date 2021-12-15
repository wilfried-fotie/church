import 'package:cloud_firestore/cloud_firestore.dart';

import '../Model/MessageModel.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // Collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('Users');
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('groups');

  // update userdata
  Future updateUserData(String fullName, String email, String password) async {
    return await userCollection.doc(uid).set({
      'fullName': fullName,
      'email': email,
      'password': password,
      'groups': [],
      'profilePic': ''
    });
  }

  Future updateGroupUser(String groupIp) async {
    await userCollection.doc(uid).update({
      'groups': FieldValue.arrayUnion([groupIp])
    });
    return await groupCollection.doc(groupIp).update({
      "members": FieldValue.arrayUnion([uid])
    });
  }

  Future updateRemoveGroupUser(String groupIp) async {
    await userCollection.doc(uid).update({
      'groups': FieldValue.arrayRemove([groupIp])
    });
    return await groupCollection.doc(groupIp).update({
      "members": FieldValue.arrayRemove([uid])
    });
  }

  // create group
  Future createGroup(
      String userName, String groupName, String? groupIcon) async {
    DocumentReference groupDocRef = await groupCollection.add({
      'groupName': groupName,
      'groupIcon': groupIcon,
      'admin': uid,
      'members': [],
      //'messages': ,
      'groupId': '',
      'recentMessage': '',
      'recentMessageSender': '',
      'recentMessageTime': DateTime.now().millisecondsSinceEpoch.toString()
    });

    await groupDocRef.update({
      'members': FieldValue.arrayUnion([uid]),
      'groupId': groupDocRef.id
    });

    DocumentReference userDocRef = userCollection.doc(uid);

    return await userDocRef.update({
      'groups': FieldValue.arrayUnion([groupDocRef.id])
    });
  }

  // toggling the user group join
  Future togglingGroupJoin(
      String groupId, String groupName, String userName) async {
    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    DocumentReference groupDocRef = groupCollection.doc(groupId);

    List<dynamic> groups = await userDocSnapshot.get("groups");

    if (groups.contains(groupId + '_' + groupName)) {
      //print('hey');
      await userDocRef.update({
        'groups': FieldValue.arrayRemove([groupId + '_' + groupName])
      });

      await groupDocRef.update({
        'members': FieldValue.arrayRemove([uid! + '_' + userName])
      });
    } else {
      //print('nay');
      await userDocRef.update({
        'groups': FieldValue.arrayUnion([groupId + '_' + groupName])
      });

      await groupDocRef.update({
        'members': FieldValue.arrayUnion([uid! + '_' + userName])
      });
    }
  }

  // has user joined the group
  Future<bool> isUserJoined(
      String groupId, String groupName, String userName) async {
    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    List<dynamic> groups = await userDocSnapshot.get("groups");

    if (groups.contains(groupId)) {
      //print('he');
      return true;
    } else {
      //print('ne');
      return false;
    }
  }

  Future updateLastReadMessages(String groupId) async {
    FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .get()
        .then((value) => value.docs.forEach((element) {
              element.reference.update({
                "reader": FieldValue.arrayUnion([uid!])
              });
            }));
  }

  // get user data
  Future getUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where('email', isEqualTo: email).get();
    print(snapshot.docs[0].data);
    return snapshot;
  }

  // get user groups
  getUserGroups() async {
    // return await FirebaseFirestore.instance.collection("users").where('email', isEqualTo: email).snapshots();
    return FirebaseFirestore.instance.collection("Users").doc(uid).snapshots();
  }

  Stream<QuerySnapshot> getGroups() {
    // return await FirebaseFirestore.instance.collection("users").where('email', isEqualTo: email).snapshots();
    return FirebaseFirestore.instance.collection("groups").snapshots();
  }

  Future<List<MessageModel>> getFutureGroups(
    String groupId,
  ) {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('date', descending: true)
        .get()
        .then((event) => event.docs
            .map((data) => MessageModel.fromJson(data.data(), data.id))
            .toList());
  }

  Stream<Map<String, dynamic>> getFutureGroup(
    String groupId,
  ) {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .snapshots()
        .map((event) => event.data()!);
  }

  Future simpleUpdateUser(Map<String, dynamic> data, String doc) async {
    await FirebaseFirestore.instance.collection('groups').doc(doc).update({
      'groupIcon': data["groupIcon"],
      'groupName': data["groupName"],
    });
  }

  // send message
  Future<void> sendMessage(String groupId, MessageModel chatMessageData) async {
    FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .add(chatMessageData.toJson());
    await FirebaseFirestore.instance.collection('groups').doc(groupId).update({
      'recentMessage': chatMessageData.message,
      'recentMessageSender': chatMessageData.name,
      'recentMessageTime': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  // get chats of a particular group
  Stream<List<MessageModel>> getChats(
    String groupId,
  ) {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('date', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((data) => MessageModel.fromJson(data.data(), data.id))
            .toList());
  }

  Stream<List<MessageModel>> readMessages(String groupId) {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .where("reader", arrayContains: uid!)
        .snapshots()
        .map((event) => event.docs.map((data) {
              return MessageModel.fromJson(data.data(), data.id);
            }).toList());
  }

  Future delete(String groupId, String id) {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .doc(id)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  Future deleteGroup(String groupId) {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  // search groups
  searchByName(String groupName) {
    return FirebaseFirestore.instance
        .collection("groups")
        .where('groupName', isEqualTo: groupName)
        .get();
  }
}
