const admin = require('firebase-admin');
const path = require('path');

// Firebase Admin initialize (service account key chahiye)
// Download from: Firebase Console → Project Settings → Service Accounts → Generate new private key
let initialized = false;

function initFirebase() {
    if (initialized) return;
    try {
        const serviceAccountPath = process.env.FIREBASE_SERVICE_ACCOUNT_PATH
            || path.join(__dirname, '../config/firebase-service-account.json');

        admin.initializeApp({
            credential: admin.credential.cert(require(serviceAccountPath)),
        });
        initialized = true;
        console.log('✅ Firebase Admin initialized');
    } catch (e) {
        console.error('❌ Firebase Admin init error:', e.message);
    }
}

/**
 * Topic-based push notification (sabhi subscribed users ko)
 * @param {string} title
 * @param {string} body
 * @param {string} topic - default: 'all_users'
 */
async function sendTopicNotification(title, body, topic = 'all_users') {
    initFirebase();

    const message = {
        notification: { title, body },
        android: {
            notification: {
                sound: 'default',
                priority: 'high',
                channelId: 'deals_channel',
            },
        },
        apns: {
            payload: {
                aps: { sound: 'default', badge: 1 },
            },
        },
        topic,
    };

    const response = await admin.messaging().send(message);
    console.log(`✅ Notification sent! MessageId: ${response}`);
    return response;
}

module.exports = { sendTopicNotification };
