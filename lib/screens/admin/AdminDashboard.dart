import 'package:flutter/material.dart';
import 'package:flutter_supabase_weight_bridge_record_control/screens/admin/vehicle/VehicleManagementScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../widgets/CustomDrawer.dart';

class AdminDashboard extends StatefulWidget {
  final String title;
  const AdminDashboard({super.key, required this.title});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final SupabaseClient supabase = Supabase.instance.client;
  String? userId;
  int vehicleCount = 0;
  double earnings = 0;
  int autoCounts = 0;
  int tempoCounts = 0;
  int eicherCounts = 0;
  int tractorCounts = 0;
  int lorryCounts = 0;
  int taurusCounts = 0;

  @override
  void initState() {
    super.initState();
    userId = supabase.auth.currentUser?.id;
    if (userId != null) {
      listenToEarnings();
      listenToVehicleCounts();
      listenToVehicleCountsByType();
    }
  }

  void listenToEarnings() {
    supabase.from('vehicles').stream(primaryKey: ['id', 'amount']).listen((data) {
      double totalEarnings = data.fold<double>(0.0, (sum, booking) {
        final amount = booking['amount'];
        if (amount != null) {
          return sum + (double.tryParse(amount.toString()) ?? 0.0);
        }
        return sum;
      });

      setState(() => earnings = totalEarnings);
    });
  }

  void listenToVehicleCounts() {
    supabase.from('vehicles').stream(primaryKey: ['id']).listen((data) {
      setState(() => vehicleCount = data.length);
    });
  }

  void listenToVehicleCountsByType() {
    supabase.from('vehicles').stream(primaryKey: ['id', 'type']).listen((data) {
      setState(() {
        autoCounts = data.where((b) => b['type'] == 'Auto').length;
        tempoCounts = data.where((b) => b['type'] == 'Tempo').length;
        eicherCounts = data.where((b) => b['type'] == 'Eicher').length;
        tractorCounts = data.where((b) => b['type'] == 'Tractor').length;
        lorryCounts = data.where((b) => b['type'] == 'Lorry').length;
        taurusCounts = data.where((b) => b['type'] == 'Taurus').length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(parentContext: context),
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    icon: Icons.attach_money,
                    title: 'Earnings',
                    value: '₹ ${earnings.toStringAsFixed(2)}',
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    icon: Icons.fire_truck,
                    title: 'Total Vehicles',
                    value: vehicleCount.toString(),
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(child: _buildVehiclesOverview()),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color, size: 28),
            ),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehiclesOverview() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vehicle Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.0,
                children: [
                  _buildVehicleStatus(label: 'Auto', count: autoCounts, color: Colors.orange, icon: Icons.directions_car),
                  _buildVehicleStatus(label: 'Tempo', count: tempoCounts, color: Colors.green, icon: Icons.directions_bus),
                  _buildVehicleStatus(label: 'Eicher', count: eicherCounts, color: Colors.red, icon: Icons.local_shipping),
                  _buildVehicleStatus(label: 'Tractor', count: tractorCounts, color: Colors.blue, icon: Icons.agriculture),
                  _buildVehicleStatus(label: 'Lorry', count: lorryCounts, color: Colors.purple, icon: Icons.fire_truck),
                  _buildVehicleStatus(label: 'Taurus', count: taurusCounts, color: Colors.teal, icon: Icons.local_shipping),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleStatus({
    required String label,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () {

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VehicleManagementScreen(
              title: '$label Vehicles',
              vehicleTypeFilter: label, // Pass the vehicle type
            ),
          ),
        );

      }, // Handle tap action
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 6.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 30),
              SizedBox(height: 8),
              Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(count.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
