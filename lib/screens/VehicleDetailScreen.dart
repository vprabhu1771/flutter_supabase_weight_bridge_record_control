import 'package:flutter/material.dart';
import '../models/Vehicle.dart';

class VehicleDetailScreen extends StatefulWidget {
  final Vehicle vehicle;

  const VehicleDetailScreen({super.key, required this.vehicle});

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vehicle Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                widget.vehicle.image_path ??
                    'https://xxllfyzeciydpjwwyeef.supabase.co/storage/v1/object/public/assets//No_Image_Available.jpg',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Driver Name: ${widget.vehicle.driver_name ?? "N/A"}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("Number Plate: ${widget.vehicle.number_plate ?? "N/A"}",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text("Company: ${widget.vehicle.company_name ?? "N/A"}",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text("Vehicle Type: ${widget.vehicle.type ?? "N/A"}",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text("First Weight: ${widget.vehicle.first_weight ?? "N/A"}",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text("Second Weight: ${widget.vehicle.second_weight ?? "N/A"}",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text("Net Weight: ${widget.vehicle.net_weight ?? "N/A"}",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text("Amount: ${widget.vehicle.amount ?? "N/A"}",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text("Date: ${widget.vehicle.formattedDate ?? "N/A"}",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text("Time: ${widget.vehicle.formattedTime ?? "N/A"}",
                style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
