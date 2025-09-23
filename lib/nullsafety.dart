import 'package:flutter/material.dart';

class UserModel {
  final String id;
  final String firstName;
  final String? dob; // nullable
  final String? address; // nullable
  final String? imageUrl;

  const UserModel({
    required this.id,
    required this.firstName,
    this.dob,
    this.address,
    this.imageUrl
  });
}

class Nullsafety extends StatelessWidget {
  const Nullsafety({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: MyUsers(),
    );
  }
}

class MyUsers extends StatelessWidget {
  const MyUsers({super.key});

  final List<UserModel> userList = const [
    UserModel(
      id: '12',
      firstName: "Godwin",
      dob: "10/02/2023",
      address: "Ajah",
      imageUrl: "https://randomuser.me/api/portraits/men/1.jpg",
    ),
     
    UserModel(
      id: '15',
      firstName: "Esther",
      dob: "05/08/1999",
      address: "Ikeja",
      imageUrl: "https://randomuser.me/api/portraits/women/44.jpg",
    ),
    UserModel(
      id: '16',
      firstName: "Michael",
      address: "Lekki",
      imageUrl: "https://randomuser.me/api/portraits/men/5.jpg",
    ),
    UserModel(
      id: '17',
      firstName: "Sandra",
      dob: "22/11/2001", // no address
      // no image provided
    ),
    UserModel(
      id: '18',
      firstName: "Tolu",
      dob: "14/04/1995",
      address: "Yaba",
      imageUrl: "https://randomuser.me/api/portraits/men/12.jpg",
    ),
    UserModel(
      id: '19',
      firstName: "David",
      address: "Ikorodu",
    ),
    UserModel(
      id: '20',
      firstName: "Peace",
      dob: "09/09/2000",
      address: "Surulere",
      imageUrl: "https://randomuser.me/api/portraits/women/68.jpg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: userList.map((user) => UserProfile(user: user)).toList(),
      ),
    );
  }
}

class UserProfile extends StatelessWidget {
  const UserProfile({super.key, required this.user});
  final UserModel user;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      color: Colors.blueAccent,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Container(
            //   padding:EdgeInsets.all(10),
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.white, width: 2.0,),
            //     borderRadius: BorderRadius.circular(50)
            //   ),
            //   child: Icon(Icons.person_3_sharp, color: Colors.white,)),

            user.imageUrl != null ? 
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(user.imageUrl!)
            )
            :
            CircleAvatar(
              radius: 30,
              child: Text(user.firstName[0], style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
            ),

              const SizedBox(height: 10),
            Row(
              children: [
                Text('UserName: '), Text(user.firstName, style: TextStyle(fontWeight: FontWeight.w500),)
            ],),
            const SizedBox(height: 12),
            Row(
              children: [Text('Date of birth: '), Text(user.dob ?? 'DOB not avaliable', style: TextStyle(fontWeight: FontWeight.w500),
                )],
            ),

            const SizedBox(height: 12),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(user.address != null)
                Row(children: [
                  Text('Address: '), Text(user.address!,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )
                ],)
              ],
            )
          ],
        ),
        ),
    );
  }
}
