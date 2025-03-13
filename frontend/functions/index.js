const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendNotificationOnDetection = functions.database.ref("/Detection")
    .onUpdate(async (change, context) => {
        const detectionValue = change.after.val();
        if (detectionValue === 1) {
            const payload = {
                notification: {
                    title: "Bird detected",
                    body: "Scarecrow Moving"
                },
                topic: "detection"
            };
            return admin.messaging().send(payload);
        }
        return null;
    });
