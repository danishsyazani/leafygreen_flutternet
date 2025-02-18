import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:leafygreen_flutternet/screens/groups/groups_page.dart';
import 'package:leafygreen_flutternet/screens/groups/widgets/widgets.dart';
import 'database_services.dart';

class GroupInfo extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;
  const GroupInfo(
      {Key? key,
      required this.adminName,
      required this.groupName,
      required this.groupId})
      : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;
  String userName = "";
  @override
  void initState() {
    getMembers();
    super.initState();
  }

  getMembers() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((val) {
      setState(() {
        members = val;
      });
    });
  }

  getCurrentUserIdandName() async {
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .gettingUserName()
        .then((value) {
      setState(() {
        userName = value!;
      });
    });
  }

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 76, 175, 80),
        title: const Text("Group Info",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontFamily: 'Poppins')),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Exit",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: 'Sf')),
                        content: const Text("Are you sure you exit the group? ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'Sf')),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              DatabaseService(
                                      uid: FirebaseAuth
                                          .instance.currentUser!.uid)
                                  .toggleGroupJoin(
                                      widget.groupId, widget.groupName)
                                  .whenComplete(() {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const GroupsPage()),
                                    (route) => false);
                              });
                            },
                            icon: const Icon(
                              Icons.done,
                              color: Color.fromARGB(255, 76, 175, 80),
                            ),
                          ),
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color.fromARGB(255, 76, 175, 80)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Color.fromARGB(255, 103, 184, 106),
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontFamily: 'Sf'),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Group: ${widget.groupName}",
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontFamily: 'Sf'),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Admin: ${getName(widget.adminName)}",
                        style: const TextStyle(fontFamily: 'Sf'),
                      ),
                    ],
                  )
                ],
              ),
            ),
            memberList(),
          ],
        ),
      ),
    );
  }

  memberList() {
    return StreamBuilder(
      stream: members,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['members'] != null) {
            if (snapshot.data['members'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['members'].length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Color.fromARGB(255, 76, 175, 80),
                        child: Text(
                          getName(snapshot.data['members'][index]),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Sf'),
                        ),
                      ),
                      title: Text(
                        getName(snapshot.data['members'][index]),
                        style: const TextStyle(fontFamily: 'Sf'),
                        //subtitle: Text(getId(snapshot.data['members'][index])),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text(
                  "NO MEMBERS",
                  style: TextStyle(fontFamily: 'Sf'),
                ),
              );
            }
          } else {
            return const Center(
              child: Text(
                "NO MEMBERS",
                style: TextStyle(fontFamily: 'Sf'),
              ),
            );
          }
        } else {
          return Center(
              child: CircularProgressIndicator(
            color: Colors.green[200],
          ));
        }
      },
    );
  }
}
