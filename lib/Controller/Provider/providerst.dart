import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseProvider extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addUserList(String userId, String name, int age,
      {String? imageUrl}) async {
    try {
      CollectionReference userListRef =
          firestore.collection('users').doc(userId).collection('userlist');

      Map<String, dynamic> userData = {
        'name': name,
        'age': age,
        'timestamp': FieldValue.serverTimestamp(),
      };

      if (imageUrl != null) {
        userData['imageUrl'] = imageUrl;
      }

      await userListRef.add(userData);
      print('User added to userlist subcollection successfully.');
    } catch (e) {
      print('Error adding user to userlist: $e');
    }
  }

  // Stream<List<Object?>> getUserListStream(String userId,
  //     {String? searchName, String? sortOption}) {
  //   try {
  //     CollectionReference userListRef =
  //         firestore.collection('users').doc(userId).collection('userlist');

  //     Query query = userListRef;

  //     if (searchName != null && searchName.isNotEmpty) {
  //       query = query
  //           .where('name', isGreaterThanOrEqualTo: searchName)
  //           .where('name', isLessThan: searchName + '\uf8ff');
  //     }

  //     if (sortOption == 'Elder') {
  //       query = query.where('age', isGreaterThanOrEqualTo: 60);
  //     } else if (sortOption == 'Younger') {
  //       query = query.where('age', isLessThan: 60);
  //     }

  //     return query
  //         .snapshots()
  //         .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  //   } catch (e) {
  //     print('Error getting user list: $e');
  //     return Stream.empty();
  //   }
  // }
Stream<List<Object?>> getUserListStream(String userId, {String? searchName, String? sortOption}) {
  try {
    CollectionReference userListRef = firestore.collection('users').doc(userId).collection('userlist');

    Query query = userListRef;
    
    // Apply search filter
    if (searchName != null && searchName.isNotEmpty) {
      query = query.where('name', isGreaterThanOrEqualTo: searchName).where('name', isLessThan: searchName + '\uf8ff');
    }

    // Apply sorting based on age
    if (sortOption == 'Elder') {
      query = query.where('age', isGreaterThanOrEqualTo: 60);
    } else if (sortOption == 'Younger') {
      query = query.where('age', isLessThan: 60);
    }

    // Order by timestamp
    query = query.orderBy('timestamp', descending: true);

    return query.snapshots().map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  } catch (e) {
    print('Error getting user list: $e');
    return Stream.empty();
  }
}

  String _searchName = '';

  String get searchName => _searchName;
  void setSearchName(String name) {
    _searchName = name;
    notifyListeners();
  }

  String? _imageURL;

  String? get imageURL => _imageURL;

  void setImageURL(String url) {
    _imageURL = url.startsWith('http') ? url : 'https://$url';
    notifyListeners();
  }

  String _selectedSortOption = 'All';

  String get selectedSortOption => _selectedSortOption;

  void setSelectedSortOption(String option) {
    _selectedSortOption = option;
    notifyListeners();
  }
}
