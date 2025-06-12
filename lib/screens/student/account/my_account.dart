import 'dart:io';
import 'package:flutter/material.dart';
import 'package:library_management_sys/view_model/auth_view_model.dart';
import 'package:provider/provider.dart';

import '../../../constant/base_url.dart';
import '../../../data/response/status.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Account",
          style: TextStyle(fontFamily: 'poppins-black', color: Colors.black),
        ),
        actions: const [
          Image(
            image: AssetImage('assets/images/pcpsLogo.png'),
            width: 56,
            height: 24,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 18)
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            width: deviceWidth,
            height: deviceHeight,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Consumer<AuthViewModel>(
                  builder: (context, userDataViewModel, child) {
                    final user = userDataViewModel.currentUser;
                    if (userDataViewModel.userData.status == Status.ERROR) {
                      return const Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundImage:
                                    AssetImage('assets/images/profile.jpg'),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Text(
                            '',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      );
                    } else if (user != null) {
                      return Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 70,
                                backgroundImage: user.data?.profilePicUrl != null
                                    ? NetworkImage(
                                        "${BaseUrl.imageDisplay}/${user.data?.profilePicUrl}")
                                    : const AssetImage(
                                        'assets/images/pcps.jpg'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            user.data?.fullName ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            user.data?.cardId ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),const SizedBox(height: 5),

                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              const CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    AssetImage('assets/images/pcps.jpg'),
                              ),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                child: GestureDetector(
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Unkown name',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Unknown email",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(height: 30),
                Center(
                  child: Column(
                    children: [
                      buildProfileOption(Icons.logout, 'Logout', () async {
                        try {
                          await Provider.of<AuthViewModel>(context,
                                  listen: false)
                              .logout(context);
                        } catch (e) {
                          print("Logout failed: $e");
                        }
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProfileOption(
      IconData icon, String title, VoidCallback? callback) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: callback,
    );
  }
}
