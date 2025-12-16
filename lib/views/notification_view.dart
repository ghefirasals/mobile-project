import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/notification_service.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationService = Get.find<NotificationService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.notifications_active,
                size: 72,
                color: Colors.orange,
              ),
              const SizedBox(height: 24),
              const Text(
                'Tes Local Notification',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    notificationService.showLocalNotification(
                      channel: 'keranjang', 
                      title: 'Notifikasi Instan',
                      body: 'Ada makanan dikeranjang nih!',
                    );
                  },
                  icon: const Icon(Icons.notifications),
                  label: const Text('Test Local Notification Keranjang'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    notificationService.showLocalNotification(
                      channel: "", 
                      title: 'Notifikasi Instan',
                      body: 'Ini adalah notifikasi tanpa channel',
                    );
                  },
                  icon: const Icon(Icons.notifications),
                  label: const Text('Test Local Notification Normal'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
