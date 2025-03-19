import 'package:flutter/material.dart';
import 'package:flutter_supabase_weight_bridge_record_control/models/Vehicle.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'VehicleDetailScreen.dart';

class VehicleSearchScreen extends StatefulWidget {
  final String title;

  const VehicleSearchScreen({super.key, required this.title});

  @override
  _VehicleSearchScreenState createState() => _VehicleSearchScreenState();
}

class _VehicleSearchScreenState extends State<VehicleSearchScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Vehicle> filteredVehicles = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      filterSearchResults();
    });
  }

  Future<void> filterSearchResults() async {
    String query = searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        filteredVehicles = [];
      });
      return;
    }

    setState(() => isLoading = true);

    final response = await supabase
        .from('vehicles')
        .select()
        .or("driver_name.ilike.%$query%,number_plate.ilike.%$query%");

    setState(() {
      filteredVehicles = (response as List)
          .map((json) => Vehicle.fromJson(json))
          .toList(); // ✅ Properly convert JSON list to a List<Vehicle>
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search Vehicles")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search by Name or Number Plate",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : filteredVehicles.isEmpty
                ? Center(child: Text("No vehicles found"))
                : ListView.builder(
              itemCount: filteredVehicles.length,
              itemBuilder: (context, index) {
                var vehicle = filteredVehicles[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      vehicle.image_path ??
                          'https://xxllfyzeciydpjwwyeef.supabase.co/storage/v1/object/public/assets//No_Image_Available.jpg',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(vehicle.driver_name),
                    subtitle: Text("Plate: ${vehicle.number_plate}"),
                    trailing: Text(vehicle.type),
                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              VehicleDetailScreen(vehicle: vehicle),
                        ),
                      );

                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
