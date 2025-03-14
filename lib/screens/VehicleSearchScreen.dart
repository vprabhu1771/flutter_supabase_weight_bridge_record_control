import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VehicleSearchScreen extends StatefulWidget {

  final String title;

  const VehicleSearchScreen({super.key, required this.title});

  @override
  _VehicleSearchScreenState createState() => _VehicleSearchScreenState();
}

class _VehicleSearchScreenState extends State<VehicleSearchScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> vehicles = [];
  List<Map<String, dynamic>> filteredVehicles = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchVehicles();
    searchController.addListener(() {
      filterSearchResults();
    });
  }

  Future<void> fetchVehicles() async {
    final response = await supabase.from('vehicles').select();
    setState(() {
      vehicles = List<Map<String, dynamic>>.from(response);
      filteredVehicles = vehicles;
    });
  }

  void filterSearchResults() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredVehicles = vehicles.where((vehicle) {
        return vehicle["driver_name"].toLowerCase().contains(query) ||
            vehicle["number_plate"].toLowerCase().contains(query);
      }).toList();
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
            child: ListView.builder(
              itemCount: filteredVehicles.length,
              itemBuilder: (context, index) {
                var vehicle = filteredVehicles[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      vehicle["image_path"] ?? 'https://xxllfyzeciydpjwwyeef.supabase.co/storage/v1/object/public/assets//No_Image_Available.jpg',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(vehicle["driver_name"]),
                    subtitle: Text("Plate: ${vehicle["number_plate"]}"),
                    trailing: Text(vehicle["type"]),
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
