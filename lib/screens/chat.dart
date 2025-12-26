import 'package:chat_app/widgets/chat_message.dart';
import 'package:chat_app/widgets/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:chat_app/services/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  void initState() {
    super.initState();
    setupPushNotifications();
    listenForegroundMessages();
  }

  // 🔔 Setup FCM
  Future<void> setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;

    // Request permission (Android 13+)
    await fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get token
    final token = await fcm.getToken();
    print('FCM Token: $token');

    await saveTokenToFirestore(token);

    // Listen for token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      saveTokenToFirestore(newToken);
    });
  }

  // 💾 Save token in Firestore
  Future<void> saveTokenToFirestore(String? token) async {
    if (token == null) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
      

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set(
      {
        'fcmToken': token,
        'updatedAt': Timestamp.now()
      },
      SetOptions(merge: true),
    );

    print('✅ FCM token saved for user: ${user.uid}');
  }

  // 📩 Foreground notification
  void listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;

      if (notification != null) {
        NotificationService.showNotification(
          title: notification.title ?? 'New Message',
          body: notification.body ?? '',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterChat'),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: Column(
        children: const [
          Expanded(
            child: ChatMessages(),
          ),
          NewMessage(),
        ],
      ),
    );
  }
}
