import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/Vehicle.dart';
import './VehicleDetailScreen.dart';
import './VehicleFormScreen..dart';

class VehicleManagementScreen extends StatefulWidget {
  final String title;
  final String? vehicleTypeFilter; // Accept vehicle type as filter

  const VehicleManagementScreen({
    super.key,
    required this.title,
    required this.vehicleTypeFilter
  });

  @override
  State<VehicleManagementScreen> createState() => _VehicleManagementScreenState();
}

class _VehicleManagementScreenState extends State<VehicleManagementScreen> {
  final SupabaseClient supabase = Supabase.instance.client;

  String? driverNameFilter;
  String? vehicleNoFilter;
  DateTime? selectedDate;

  String? vehicleTypeFilter;

  @override
  void initState() {
    super.initState();
    vehicleTypeFilter = widget.vehicleTypeFilter; // Set initial filter if passed
  }

  // Fetch vehicle data from Supabase in real-time with filtering
  Stream<List<Vehicle>> _fetchVehicles() {
    var query = supabase.from('vehicles').stream(primaryKey: ['id']);

    return query.map((data) {
      try {
        List<Vehicle> vehicles = data.map((vehicle) => Vehicle.fromJson(vehicle)).toList();

        // Apply filters
        if (driverNameFilter != null && driverNameFilter!.isNotEmpty) {
          vehicles = vehicles
              .where((vehicle) => vehicle.driver_name
              .toLowerCase()
              .contains(driverNameFilter!.toLowerCase()))
              .toList();
        }
        if (vehicleNoFilter != null && vehicleNoFilter!.isNotEmpty) {
          vehicles = vehicles
              .where((vehicle) => vehicle.number_plate
              .toLowerCase()
              .contains(vehicleNoFilter!.toLowerCase()))
              .toList();
        }

        if (vehicleTypeFilter != null && vehicleTypeFilter!.isNotEmpty) {
          print("Filtering by vehicle type: ${vehicleTypeFilter}"); // Debugging
          vehicles = vehicles
              .where((vehicle) =>
          vehicle.type != null && // Null check
              vehicle.type.toLowerCase() == vehicleTypeFilter!.toLowerCase() // Exact match
          ).toList();
        }

        return vehicles;
      } catch (e) {
        print('Error parsing vehicle data: $e');
        return [];
      }
    });
  }

  void _deleteVehicle(int id) async {

      final response = await supabase.from('vehicles').delete().eq('id', id);

    // print(response.toString());
    // print("delete success");

    if (response == null)
    {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Deleted'),
          backgroundColor: Colors.red,
        ),
      );
    }

  }

  void _addVehicle() {
    // Implement add vehicle functionality
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VehicleFormScreen(title: 'Vehicle Form',),
      ),
    );
  }

  void _editVehicle(Vehicle vehicle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VehicleFormScreen(
          title: 'Edit Vehicle',
          vehicle: vehicle, // Pass the vehicle object
        ),
      ),
    );
  }

  void _navigateToDetail(Vehicle vehicle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VehicleDetailScreen(
          title: 'Vehicle Details',
          vehicle: vehicle, // Pass the vehicle object
        ),
      ),
    );
  }

  void _openFilterDialog() {
    TextEditingController driverController = TextEditingController(text: driverNameFilter);
    TextEditingController vehicleController = TextEditingController(text: vehicleNoFilter);

    String? selectedVehicleType = vehicleTypeFilter; // Ensure it retains previous selection
    List<String> vehicleTypes = ['Auto', 'Tempo', 'Eicher', 'Tractor', 'Lorry', 'Taurus'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom, top: 16, left: 16, right: 16),
            child: Wrap(
              children: [
                Text("Filter Vehicles", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),

                // Driver Name Filter
                TextField(
                  controller: driverController,
                  decoration: InputDecoration(labelText: 'Driver Name', prefixIcon: Icon(Icons.person)),
                ),
                SizedBox(height: 10),

                // Vehicle Number Filter
                TextField(
                  controller: vehicleController,
                  decoration: InputDecoration(labelText: 'Number Plate', prefixIcon: Icon(Icons.directions_car)),
                ),
                SizedBox(height: 10),

                // Vehicle Type Filter (Dropdown)
                DropdownButtonFormField<String>(
                  // value: selectedVehicleType,
                  value: vehicleTypes.contains(selectedVehicleType) ? selectedVehicleType : null,
                  decoration: InputDecoration(labelText: 'Vehicle Type', prefixIcon: Icon(Icons.local_shipping)),
                  items: vehicleTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setModalState(() {
                      selectedVehicleType = newValue; // Update inside modal
                    });
                  },
                ),
                SizedBox(height: 10),

                // Date Filter
                ListTile(
                  title: Text("Select Date"),
                  subtitle: Text(selectedDate != null
                      ? DateFormat('dd-MM-yyyy').format(selectedDate!)
                      : 'No Date Selected'),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                      Navigator.pop(context);
                      _openFilterDialog();
                    }
                  },
                ),

                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          driverNameFilter = null;
                          vehicleNoFilter = null;
                          selectedDate = null;
                          vehicleTypeFilter = null;
                        });
                        Navigator.pop(context);
                      },
                      child: Text("Clear Filters"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          driverNameFilter = driverController.text;
                          vehicleNoFilter = vehicleController.text;
                          vehicleTypeFilter = selectedVehicleType; // Correctly update here
                        });
                        Navigator.pop(context);
                      },
                      child: Text("Apply Filters"),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _openFilterDialog,
          ),
        ],
      ),
      body: StreamBuilder<List<Vehicle>>(
        stream: _fetchVehicles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading vehicles'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No vehicles available'));
          }

          final vehicles = snapshot.data!;

          return ListView.builder(
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              return Slidable(
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [

                  ],
                ),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    // SlidableAction(
                    //   onPressed: (context) => _navigateToDetail(vehicle),
                    //   backgroundColor: Colors.orange,
                    //   icon: Icons.document_scanner,
                    //   label: 'View',
                    // ),
                    SlidableAction(
                      onPressed: (context) => _editVehicle(vehicle),
                      backgroundColor: Colors.blue,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                    SlidableAction(
                      onPressed: (context) => _deleteVehicle(vehicle.id),
                      backgroundColor: Colors.red,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: ListTile(
                  leading: CircleAvatar(child: Text(vehicle.driver_name[0])),
                  title: Text(vehicle.driver_name),
                  subtitle: Text("${vehicle.number_plate} - ${vehicle.formattedDate} - ${vehicle.formattedTime}"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () => _navigateToDetail(vehicle),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addVehicle,
        child: Icon(Icons.add),
      ),
    );
  }
}
