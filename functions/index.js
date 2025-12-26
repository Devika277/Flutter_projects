const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

// Firestore trigger: send notification when a new chat message is created
exports.sendChatNotification = functions.firestore
    .document("chat/{messageId}")
    .onCreate(async (snapshot, context) => {
      try {
        const messageData = snapshot.data();

        if (!messageData) {
          console.log("No message data found");
          return null;
        }

        const receiverId = messageData.receiverId;
        const senderName = messageData.username || "Someone";
        const text = messageData.text || "";

        if (!receiverId) {
          console.log("No receiverId found");
          return null;
        }

        // Get receiver FCM token
        const userDoc = await admin
            .firestore()
            .collection("users")
            .doc(receiverId)
            .get();

        if (!userDoc.exists) {
          console.log(`User ${receiverId} does not exist`);
          return null;
        }

        const fcmToken = userDoc.data().fcmToken;

        if (!fcmToken) {
          console.log(`User ${receiverId} has no FCM token`);
          return null;
        }

        const payload = {
          notification: {
            title: `New message from ${senderName}`,
            body: text,
          },
          token: fcmToken,
        };

        const response = await admin.messaging().send(payload);
        console.log("Notification sent successfully:", response);

        return null; // End the function properly
      } catch (error) {
        console.error("Error sending notification:", error);
        return null;
      }
    });
