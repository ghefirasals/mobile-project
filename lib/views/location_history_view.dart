import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/location_controller.dart';
import '../controllers/network_location_controller.dart';
import '../models/gps_location.dart';
import '../models/network_location.dart';

/// View untuk menampilkan history lokasi
class LocationHistoryView extends StatefulWidget {
  const LocationHistoryView({super.key});

  @override
  State<LocationHistoryView> createState() => _LocationHistoryViewState();
}

class _LocationHistoryViewState extends State<LocationHistoryView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location History'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.gps_fixed), text: 'GPS'),
            Tab(icon: Icon(Icons.wifi), text: 'Network'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGpsHistoryTab(),
          _buildNetworkHistoryTab(),
        ],
      ),
    );
  }

  Widget _buildGpsHistoryTab() {
    return GetBuilder<LocationController>(
      init: Get.find<LocationController>(),
      builder: (controller) {
        final history = controller.getLocationHistory();
        final count = controller.getLocationHistoryCount();

        if (history.isEmpty) {
          return _buildEmptyState('GPS');
        }

        return Column(
          children: [
            _buildHeaderCard(count, 'GPS', controller.clearLocationHistory),
            Expanded(
              child: ListView.builder(
                itemCount: history.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final location = history[index];
                  return _buildGpsLocationCard(location);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNetworkHistoryTab() {
    return GetBuilder<NetworkLocationController>(
      init: Get.find<NetworkLocationController>(),
      builder: (controller) {
        final history = controller.getLocationHistory();
        final count = controller.getLocationHistoryCount();

        if (history.isEmpty) {
          return _buildEmptyState('Network');
        }

        return Column(
          children: [
            _buildHeaderCard(count, 'Network', controller.clearLocationHistory),
            Expanded(
              child: ListView.builder(
                itemCount: history.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final location = history[index];
                  return _buildNetworkLocationCard(location);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(String type) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            type == 'GPS' ? Icons.gps_off : Icons.wifi_off,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada history $type location',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            'Mulai tracking untuk menyimpan history',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(int count, String type, VoidCallback onClear) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$type Locations',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Total: $count records',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: () {
                _showClearConfirmDialog(type, onClear);
              },
              icon: const Icon(Icons.delete_outline),
              label: const Text('Clear'),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGpsLocationCard(GpsLocation location) {
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm:ss');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        leading: const Icon(Icons.gps_fixed, color: Colors.blue),
        title: Text(
          '${location.latitude.toStringAsFixed(6)}, ${location.longitude.toStringAsFixed(6)}',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(dateFormat.format(location.timestamp)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Latitude', location.latitude.toString()),
                _buildInfoRow('Longitude', location.longitude.toString()),
                if (location.accuracy != null)
                  _buildInfoRow('Accuracy', '${location.accuracy!.toStringAsFixed(2)} m'),
                if (location.altitude != null)
                  _buildInfoRow('Altitude', '${location.altitude!.toStringAsFixed(2)} m'),
                if (location.speed != null)
                  _buildInfoRow('Speed', '${location.speed!.toStringAsFixed(2)} m/s'),
                _buildInfoRow('Provider', location.providerType),
                _buildInfoRow('Timestamp', dateFormat.format(location.timestamp)),
                if (location.isMocked)
                  const Chip(
                    label: Text('Mocked Location'),
                    backgroundColor: Colors.orange,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkLocationCard(NetworkLocation location) {
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm:ss');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        leading: const Icon(Icons.wifi, color: Colors.green),
        title: Text(
          '${location.latitude.toStringAsFixed(6)}, ${location.longitude.toStringAsFixed(6)}',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(dateFormat.format(location.timestamp)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Latitude', location.latitude.toString()),
                _buildInfoRow('Longitude', location.longitude.toString()),
                if (location.accuracy != null)
                  _buildInfoRow('Accuracy', '${location.accuracy!.toStringAsFixed(2)} m'),
                _buildInfoRow('Provider', location.providerType),
                if (location.networkProvider != null)
                  _buildInfoRow('Network Type', location.networkProvider!),
                _buildInfoRow('Timestamp', dateFormat.format(location.timestamp)),
                if (location.isMocked)
                  const Chip(
                    label: Text('Mocked Location'),
                    backgroundColor: Colors.orange,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearConfirmDialog(String type, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear $type History?'),
        content: Text(
          'Apakah Anda yakin ingin menghapus semua history $type location? '
          'Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              onConfirm();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$type history cleared'),
                  backgroundColor: Colors.green,
                ),
              );
              setState(() {});
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
