import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String type;
  final bool read;
  final DateTime createdAt;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.read,
    required this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) => NotificationItem(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    message: json['message'] ?? '',
    type: json['type'] ?? 'ITINERARY_CHANGE',
    read: json['read'] ?? false,
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
  );
}

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock notifications (real: GET /api/notifications)
  List<NotificationItem> _notifications = [
    NotificationItem(id: '1', title: '⏰ Activity Reminder', message: 'Your visit to El Djem starts in 1 hour. Don\'t forget!', type: 'ACTIVITY_REMINDER', read: false, createdAt: DateTime.now().subtract(const Duration(minutes: 15))),
    NotificationItem(id: '2', title: '🌤️ Weather Update', message: 'Partly cloudy today in Tunis. A light jacket recommended.', type: 'WEATHER', read: false, createdAt: DateTime.now().subtract(const Duration(hours: 1))),
    NotificationItem(id: '3', title: '✈️ Flight Reminder', message: 'Your departure from Tunis Carthage is in 48 hours.', type: 'DEPARTURE', read: true, createdAt: DateTime.now().subtract(const Duration(hours: 3))),
    NotificationItem(id: '4', title: '💰 Budget Alert', message: 'You\'ve spent 80% of your daily budget. Only \$40 remaining.', type: 'BUDGET_ALERT', read: true, createdAt: DateTime.now().subtract(const Duration(hours: 5))),
    NotificationItem(id: '5', title: '📍 Nearby Gem', message: 'Sidi Bou Said is only 2km from your hotel. A must-see!', type: 'NEARBY', read: true, createdAt: DateTime.now().subtract(const Duration(days: 1))),
  ];

  // Preference states (real: GET/PUT /api/notifications/preferences)
  bool _activityReminders = true;
  bool _departureReminders = true;
  bool _weatherAlerts = true;
  bool _budgetAlerts = true;
  bool _nearbyRecs = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _markAllRead() {
    setState(() {
      _notifications = _notifications.map((n) => NotificationItem(
        id: n.id, title: n.title, message: n.message,
        type: n.type, read: true, createdAt: n.createdAt,
      )).toList();
    });
    // PUT /api/notifications/read-all
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.read).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F4F6),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new), onPressed: () => context.pop()),
        title: Text('Notifications', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child: Text('Mark all read',
                  style: GoogleFonts.inter(color: const Color(0xFF1E1E1E), fontWeight: FontWeight.w600, fontSize: 13)),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF1E1E1E),
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: const Color(0xFF1E1E1E),
          unselectedLabelColor: Colors.grey,
          labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
          tabs: [
            Tab(text: 'Activity${unreadCount > 0 ? ' ($unreadCount)' : ''}'),
            const Tab(text: 'Preferences'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNotificationsList(),
          _buildPreferencesPanel(),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    return _notifications.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🔔', style: TextStyle(fontSize: 56)),
                const SizedBox(height: 12),
                Text('No notifications yet', style: GoogleFonts.inter(color: Colors.grey, fontSize: 16)),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: _notifications.length,
            itemBuilder: (context, index) => _buildNotificationTile(_notifications[index], index),
          );
  }

  Widget _buildNotificationTile(NotificationItem n, int index) {
    final iconMap = {
      'ACTIVITY_REMINDER': (Icons.alarm, Colors.orange),
      'WEATHER': (Icons.wb_cloudy_outlined, Colors.blue),
      'DEPARTURE': (Icons.flight_takeoff, Colors.purple),
      'BUDGET_ALERT': (Icons.account_balance_wallet_outlined, Colors.red),
      'NEARBY': (Icons.place_outlined, Colors.green),
      'ITINERARY_CHANGE': (Icons.edit_calendar, Colors.teal),
    };
    final data = iconMap[n.type] ?? (Icons.notifications, Colors.grey);

    return Dismissible(
      key: Key(n.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        setState(() => _notifications.removeAt(index));
        // DELETE /api/notifications/${n.id}
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(20)),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _notifications[index] = NotificationItem(
              id: n.id, title: n.title, message: n.message,
              type: n.type, read: true, createdAt: n.createdAt,
            );
          });
          // PUT /api/notifications/${n.id}/read
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: n.read ? Colors.white : const Color(0xFFECF0FF),
            borderRadius: BorderRadius.circular(20),
            border: n.read ? null : Border.all(color: Colors.blue.shade100),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: data.$2.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(data.$1, color: data.$2, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(n.title,
                              style: GoogleFonts.inter(
                                  fontWeight: n.read ? FontWeight.w500 : FontWeight.bold, fontSize: 14)),
                        ),
                        if (!n.read)
                          Container(
                            width: 8, height: 8,
                            decoration: const BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(n.message, style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 12, height: 1.4)),
                    const SizedBox(height: 6),
                    Text(_formatTime(n.createdAt), style: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreferencesPanel() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Notification Types', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
        const SizedBox(height: 12),
        _buildPrefToggle('Activity Reminders', 'Get reminded before each activity', Icons.alarm, _activityReminders, (v) {
          setState(() => _activityReminders = v);
          // PUT /api/notifications/preferences
        }),
        _buildPrefToggle('Departure Reminders', 'Flight and transport alerts', Icons.flight_takeoff, _departureReminders, (v) => setState(() => _departureReminders = v)),
        _buildPrefToggle('Weather Alerts', 'Daily weather forecasts for your trip', Icons.wb_cloudy_outlined, _weatherAlerts, (v) => setState(() => _weatherAlerts = v)),
        _buildPrefToggle('Budget Alerts', 'Notify when nearing budget limit', Icons.account_balance_wallet_outlined, _budgetAlerts, (v) => setState(() => _budgetAlerts = v)),
        _buildPrefToggle('Nearby Recommendations', 'Discover places as you move', Icons.place_outlined, _nearbyRecs, (v) => setState(() => _nearbyRecs = v)),
      ],
    );
  }

  Widget _buildPrefToggle(String title, String subtitle, IconData icon, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1E1E1E), size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14)),
                Text(subtitle, style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 12)),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF1E1E1E),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
