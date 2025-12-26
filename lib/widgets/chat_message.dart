import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/message_bubbles.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshots) {
        // 🔄 Loading
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // ❌ Error
        if (chatSnapshots.hasError) {
          return const Center(child: Text('Something went wrong...'));
        }

        // 📭 No messages
        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          return const Center(child: Text('No messages found'));
        }

        final loadedMessages = chatSnapshots.data!.docs;

        return ListView.builder(
          reverse: true,
          itemCount: loadedMessages.length,
          itemBuilder: (ctx, index) {
            final currentMessage =
                loadedMessages[index].data() as Map<String, dynamic>;

            final nextChatMessage = index + 1 < loadedMessages.length
                ? loadedMessages[index + 1].data() as Map<String, dynamic>
                : null;

            final currentMessageUserId = currentMessage['userId'];
            final nextMessageUserId =
                nextChatMessage != null ? nextChatMessage['userId'] : null;

            final nextUserIsSame =
                nextMessageUserId == currentMessageUserId;

            if (nextUserIsSame) {
              return MessageBubble.next(
                message: currentMessage['text'],
                isMe: authenticatedUser.uid == currentMessageUserId,
              );
            }

            return MessageBubble.first(
              username: currentMessage['username'],
              userImage: currentMessage['userImage'],
              message: currentMessage['text'],
              isMe: authenticatedUser.uid == currentMessageUserId,
            );
          },
        );
      },
    );
  }
}
