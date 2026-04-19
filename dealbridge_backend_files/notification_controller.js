const { sendTopicNotification } = require('../services/notification_service');

/**
 * POST /api/notifications/send
 * Body: { title, body, topic? }
 */
exports.sendNotification = async (req, res) => {
    const { title, body, topic = 'all_users' } = req.body;

    if (!title || !body) {
        return res.status(400).json({ error: 'title aur body required hain' });
    }

    try {
        const messageId = await sendTopicNotification(title, body, topic);
        res.json({ success: true, messageId });
    } catch (err) {
        console.error('❌ Notification error:', err.message);
        res.status(500).json({ success: false, error: err.message });
    }
};
