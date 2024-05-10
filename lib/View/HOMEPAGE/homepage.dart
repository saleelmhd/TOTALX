import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:totalx/Controller/Provider/providerst.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  String _selectedSortOption =
      ''; // variable to hold the selected sorting option
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<FirebaseProvider>(context);
    final sortProvider = Provider.of<FirebaseProvider>(context);

    String id = _auth.currentUser!.uid;
    print(id);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          onPressed: () {
            _showDialog(context);
          },
          child: const Icon(Icons.add),
        ),
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 10),
                width: MediaQuery.of(context).size.width,
                height: 60,
                color: Colors.black,
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: Colors.white,
                      size: 11,
                    ),
                    Text(
                      ' Nilambur',
                      style: GoogleFonts.montserrat(
                          color: Colors.white, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Consumer<FirebaseProvider>(
                      builder: (context, searchProvider, _) => TextField(
                          onChanged: (value) {
                            searchProvider.setSearchName(value);
                          },
                          controller: _searchController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            hintText: 'search by name',
                            prefixIcon: Icon(
                              Icons.search,
                              size: 20,
                              color: Colors.grey[500],
                            ),
                            hintStyle: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w300, fontSize: 12),
                            enabledBorder: OutlineInputBorder(
                              // Set border color when TextField is not focused
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                width: 0.7,
                              ), // You may keep it red or change it to another color
                            ),
                          )),
                    )),
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        _showBottomSheet(context);
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(15)),
                        child: const Icon(
                          Icons.filter_list,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Users Lists',
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // StreamBuilder<List<Object?>>(
              //   stream: FirebaseProvider().getUserListStream(
              //     id,
              //     searchName: searchProvider.searchName,
              //   ),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return Center(child: CircularProgressIndicator());
              //     } else if (snapshot.hasError) {
              //       return Center(child: Text('Error: ${snapshot.error}'));
              //     } else {
              //       List<Object?> userList = snapshot.data ?? [];
              //       return Expanded(
              //         child: ListView.separated(
              //           padding: const EdgeInsets.symmetric(
              //               horizontal: 10, vertical: 10),
              //           controller: ScrollController(),
              //           itemCount: userList.length,
              //           separatorBuilder: (context, index) => const SizedBox(
              //             height: 10,
              //           ),
              //           itemBuilder: (context, index) {
              //             final userData =
              //                 userList[index] as Map<String, dynamic>;
              //             final name = userData['name'] as String?;
              //             final age = userData['age'] as int?;
              //             final imageUrl = userData['imageUrl'] as String?;
              //             return Container(
              //               padding: const EdgeInsets.symmetric(
              //                   vertical: 8, horizontal: 10),
              //               decoration:
              //                   const BoxDecoration(color: Colors.white),
              //               child: Row(
              //                 children: [
              //                   // Container(
              //                   //   width: 62,
              //                   //   height: 62,
              //                   //   decoration: const BoxDecoration(
              //                   //       shape: BoxShape.circle,
              //                   //       color: Colors.orange),
              //                   // ),
              //                   Container(
              //                     width: 62,
              //                     height: 62,
              //                     decoration: BoxDecoration(
              //                       shape: BoxShape.circle,
              //                       color: Colors.orange,
              //                       image: imageUrl != null
              //                           ? DecorationImage(
              //                               image: NetworkImage(imageUrl),
              //                               fit: BoxFit.cover,
              //                             )
              //                           : null,
              //                     ),
              //                   ),
              //                   const SizedBox(
              //                     width: 10,
              //                   ),
              //                   Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       Text(
              //                         '$name',
              //                         style: GoogleFonts.montserrat(
              //                             fontWeight: FontWeight.bold,
              //                             fontSize: 11),
              //                       ),
              //                       const SizedBox(
              //                         height: 3,
              //                       ),
              //                       Text(
              //                         'Age:$age',
              //                         style: GoogleFonts.montserrat(
              //                             fontWeight: FontWeight.bold,
              //                             fontSize: 9),
              //                       ),
              //                     ],
              //                   )
              //                 ],
              //               ),
              //             );
              //           },
              //         ),
              //       );
              //     }
              //   },
              // )
              StreamBuilder<List<Object?>>(
                stream: FirebaseProvider().getUserListStream(
                  id,
                  searchName: searchProvider.searchName,
                  sortOption: sortProvider.selectedSortOption,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    List<Object?> userList = snapshot.data ?? [];
                    return Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        controller: ScrollController(),
                        itemCount: userList.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final userData =
                              userList[index] as Map<String, dynamic>;
                          final name = userData['name'] as String?;
                          final age = userData['age'] as int?;
                          final imageUrl = userData['imageUrl'] as String?;
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: Row(
                              children: [
                                Container(
                                  width: 62,
                                  height: 62,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.orange,
                                    image: imageUrl != null
                                        ? DecorationImage(
                                            image: NetworkImage(imageUrl),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$name',
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      'Age: $age',
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 9),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),

              // StreamBuilder<List<Object?>>(
              //   stream: firebaseProvider.getUserListStream(id),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return Center(child: CircularProgressIndicator());
              //     } else if (snapshot.hasError) {
              //       return Center(child: Text('Error: ${snapshot.error}'));
              //     } else {
              //       List<Object?> userList = snapshot.data ?? [];
              //       return Expanded(
              //         child: ListView.separated(
              //           padding: const EdgeInsets.symmetric(
              //               horizontal: 10, vertical: 10),
              //           controller: ScrollController(),
              //           itemCount: userList.length,
              //           separatorBuilder: (context, index) => const SizedBox(
              //             height: 10,
              //           ),
              //           itemBuilder: (context, index) {
              //             final userData =
              //                 userList[index] as Map<String, dynamic>;
              //             final name = userData['name'] as String?;
              //             final age = userData['age'] as int?;
              //             return Container(
              //               padding: const EdgeInsets.symmetric(
              //                   vertical: 8, horizontal: 10),
              //               decoration:
              //                   const BoxDecoration(color: Colors.white),
              //               child: Row(
              //                 children: [
              //                   Container(
              //                     width: 62,
              //                     height: 62,
              //                     decoration: const BoxDecoration(
              //                         shape: BoxShape.circle,
              //                         color: Colors.orange),
              //                   ),
              //                   const SizedBox(
              //                     width: 10,
              //                   ),
              //                   Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       Text(
              //                         '$name',
              //                         style: GoogleFonts.montserrat(
              //                             fontWeight: FontWeight.bold,
              //                             fontSize: 11),
              //                       ),
              //                       const SizedBox(
              //                         height: 3,
              //                       ),
              //                       Text(
              //                         'Age:$age',
              //                         style: GoogleFonts.montserrat(
              //                             fontWeight: FontWeight.bold,
              //                             fontSize: 9),
              //                       ),
              //                     ],
              //                   )
              //                 ],
              //               ),
              //             );
              //           },
              //         ),
              //       );
              //     }
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // void _showBottomSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     backgroundColor: Colors.white,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (BuildContext context, StateSetter setState) {
  //           return Wrap(
  //             children: <Widget>[
  //               ListTile(
  //                 title: Text(
  //                   'Sort',
  //                   style: GoogleFonts.montserrat(
  //                       fontWeight: FontWeight.bold, fontSize: 14),
  //                 ),
  //               ),
  //               RadioListTile(
  //                 title: Text(
  //                   'All',
  //                   style: GoogleFonts.montserrat(
  //                       fontWeight: FontWeight.bold, fontSize: 12),
  //                 ),
  //                 value: 'All',
  //                 groupValue: _selectedSortOption,
  //                 // onChanged: (value) {
  //                 //   setState(() {
  //                 //     _selectedSortOption = value!;
  //                 //   });
  //                 //   // Handle sorting logic here
  //                 //   // Navigator.pop(context);
  //                 // },
  //                 onChanged: (value) {
  //                   Provider.of<FirebaseProvider>(context, listen: false)
  //                       .setSelectedSortOption(value!);
  //                   Navigator.pop(context);
  //                 },
  //               ),
  //               RadioListTile(
  //                 title: Text(
  //                   'Age: Elder',
  //                   style: GoogleFonts.montserrat(
  //                       fontWeight: FontWeight.bold, fontSize: 12),
  //                 ),
  //                 value: 'Elder',
  //                 groupValue: _selectedSortOption,
  //                 // onChanged: (value) {
  //                 //   setState(() {
  //                 //     _selectedSortOption = value!;
  //                 //   });
  //                 //   // Handle sorting logic here
  //                 //   // Navigator.pop(context);
  //                 // },
  //                 onChanged: (value) {
  //                   Provider.of<FirebaseProvider>(context, listen: false)
  //                       .setSelectedSortOption(value!);
  //                   Navigator.pop(context);
  //                 },
  //               ),
  //               RadioListTile(
  //                 title: Text(
  //                   'Age: Younger',
  //                   style: GoogleFonts.montserrat(
  //                       fontWeight: FontWeight.bold, fontSize: 12),
  //                 ),
  //                 value: 'Younger',
  //                 groupValue: _selectedSortOption,
  //                 // onChanged: (value) {
  //                 //   setState(() {
  //                 //     _selectedSortOption = value!;
  //                 //   });
  //                 //   // Handle sorting logic here
  //                 //   // Navigator.pop(context);
  //                 // },
  //                 onChanged: (value) {
  //                   Provider.of<FirebaseProvider>(context, listen: false)
  //                       .setSelectedSortOption(value!);
  //                   Navigator.pop(context);
  //                 },
  //                 activeColor:
  //                     _selectedSortOption == 'Younger' ? Colors.blue : null,
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Consumer<FirebaseProvider>(
              builder: (context, firebaseProvider, _) {
                return Wrap(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Sort',
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    RadioListTile(
                      title: Text(
                        'All',
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      value: 'All',
                      groupValue: firebaseProvider.selectedSortOption,
                      onChanged: (value) {
                        firebaseProvider.setSelectedSortOption(value!);
                        Navigator.pop(context);
                      },
                    ),
                    RadioListTile(
                      title: Text(
                        'Age: Elder',
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      value: 'Elder',
                      groupValue: firebaseProvider.selectedSortOption,
                      onChanged: (value) {
                        firebaseProvider.setSelectedSortOption(value!);
                        Navigator.pop(context);
                      },
                    ),
                    RadioListTile(
                      title: Text(
                        'Age: Younger',
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      value: 'Younger',
                      groupValue: firebaseProvider.selectedSortOption,
                      onChanged: (value) {
                        firebaseProvider.setSelectedSortOption(value!);
                        Navigator.pop(context);
                      },
                      // activeColor: firebaseProvider.selectedSortOption == 'Younger' ? Colors.blue : null,
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Add a new user',
            style: GoogleFonts.montserrat(
                fontSize: 12, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                    // child: Stack(
                    //   children: [
                    //     CircleAvatar(
                    //       radius: 50,
                    //       backgroundImage: AssetImage('images/user.png'),
                    //     ),
                    //     Positioned(
                    //       bottom: 0,
                    //       child: Container(
                    //         width: 100,
                    //         child: Image.asset(
                    //           'images/usercam.png',
                    //           fit: BoxFit.cover,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    child: Consumer<FirebaseProvider>(
                      builder: (context, imageProvider, _) {
                        return imageProvider.imageURL != null
                            ? InkWell(
                                onTap: () async {
                                  final imageProvider =
                                      Provider.of<FirebaseProvider>(context,
                                          listen: false);
                                  final imageFile = await getImage();
                                  if (imageFile != null) {
                                    String? imageURL =
                                        await uploadImage(imageFile);
                                    imageProvider.setImageURL(imageURL!);
                                  }
                                },
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundImage: NetworkImage(
                                        imageProvider.imageURL!,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      child: SizedBox(
                                        width: 100,
                                        child: Image.asset(
                                          'images/usercam.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : InkWell(
                                onTap: () async {
                                  final imageProvider =
                                      Provider.of<FirebaseProvider>(context,
                                          listen: false);
                                  final imageFile = await getImage();
                                  if (imageFile != null) {
                                    String? imageURL =
                                        await uploadImage(imageFile);
                                    imageProvider.setImageURL(imageURL!);
                                  }
                                },
                                child: Stack(
                                  children: [
                                    const CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                          AssetImage('images/user.png'),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      child: SizedBox(
                                        width: 100,
                                        child: Image.asset(
                                          'images/usercam.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Name',
                    style: GoogleFonts.montserrat(fontSize: 12),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Enter Name',
                      hintStyle: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w300, fontSize: 10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          width: 0.3,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Age',
                    style: GoogleFonts.montserrat(fontSize: 12),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Enter Age',
                      hintStyle: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w300, fontSize: 10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          width: 0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () {
                // Add your logic here
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () async {
                final provider =
                    Provider.of<FirebaseProvider>(context, listen: false);
                final firebaseProvider = FirebaseProvider();

// Add a user to the 'userlist' subcollection
                await firebaseProvider.addUserList(
                  _auth.currentUser!.uid,
                  _nameController.text,
                  int.tryParse(_ageController.text) ?? 0,
                  imageUrl: provider.imageURL,
                );

// Get the user list for a specific user

                _nameController.clear();
                _ageController.clear();

                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit the app?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Future<File?> getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<String?> uploadImage(File imageFile) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String fileName = DateTime.now().millisecondsSinceEpoch.toString() +
        '.jpg'; // unique filename
    Reference ref = storage
        .ref()
        .child("images/$fileName"); // path within the Firebase Storage bucket
    try {
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> saveImageUrlToFirestore(String imageURL) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!
          .uid; // You should replace this with the actual user ID
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'imageURL': imageURL,
        'createdAt': DateTime.now(),
      });
      print('Image URL saved to Firestore.');
    } catch (e) {
      print('Error saving image URL to Firestore: $e');
    }
  }
}
