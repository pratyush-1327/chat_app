import 'package:chat_app/providers/chat_provider.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/search_screen.dart';
import 'package:chat_app/screens/widgets/chat_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;

  User? loggedInUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        loggedInUser = user;
      });
    }
  }

  Future<Map<String, dynamic>> _fetchChatData(String chatId) async {
    final chatDoc =
        await FirebaseFirestore.instance.collection('chats').doc(chatId).get();
    final chatData = chatDoc.data();
    final users = chatData!['users'] as List<dynamic>;
    final receiverId = users.firstWhere((id) => id != loggedInUser)!.uid;
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .get();
    final userData = userDoc.data();
    return {
      'chatId': chatId,
      'lastMessage': chatData['lastMessage'] ?? '',
      'timestamp': chatData['timestamp']?.toDate() ?? DateTime.now(),
      'userData': userData
    };
  }

  @override
  Widget build(BuildContext context) {
    final _chatProvider = Provider.of<ChatProvider>(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceDim,
        appBar: AppBar(
          title: Text("FlutChat"),
          actions: [
            IconButton(
              onPressed: () {
                _auth.signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              icon: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: _chatProvider.getChats(loggedInUser!.uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final chatDocs = snapshot.data!.docs;
                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: Future.wait(
                      chatDocs.map((chatDoc) => _fetchChatData(chatDoc.id))),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final chatDataList = snapshot.data!;
                    return ListView.builder(
                      itemCount: chatDataList.length,
                      itemBuilder: (context, index) {
                        final chatData = chatDataList[index];
                        return ChatTile(
                            chatId: chatData['chatId'],
                            lastMessage: chatData['lastMessage'],
                            timestamp: chatData['timestamp'],
                            receiverData: chatData['userData']);
                      },
                    );
                  },
                );
              },
            ))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    SearchScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const beginOffset = Offset(1.0, 0.0);
                  const endOffset = Offset.zero;
                  const curve = Curves.easeInOut;

                  var tweenOffset = Tween(begin: beginOffset, end: endOffset)
                      .chain(CurveTween(curve: curve));
                  var slideAnimation = animation.drive(tweenOffset);

                  var fadeAnimation =
                      Tween(begin: 0.0, end: 1.0).animate(animation);

                  return SlideTransition(
                    position: slideAnimation,
                    child: FadeTransition(
                      opacity: fadeAnimation,
                      child: child,
                    ),
                  );
                },
              ),
            );
          },
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.surfaceBright,
          child: Icon(Icons.search_rounded),
        ),
      ),
    );
  }
}
