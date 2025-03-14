import 'package:flutter/material.dart';
import '../../models/Vehicle.dart';

import 'package:url_launcher/url_launcher.dart';

class VehicleDetailScreen extends StatefulWidget {

  final String title;

  final Vehicle vehicle;

  const VehicleDetailScreen({super.key, required this.title, required this.vehicle});

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {

  void _sendSMS() async {
    final String message = Uri.encodeComponent(
        '''
        Dear Customer
        
        Weight Details:
        Driver: ${widget.vehicle.driver_name}
        Vehicle No: ${widget.vehicle.number_plate}
        Company: ${widget.vehicle.company_name}
        First Weight: ${widget.vehicle.first_weight}
        Second Weight: ${widget.vehicle.second_weight}
        Net Weight: ${widget.vehicle.net_weight}
        Amount: ${widget.vehicle.amount}
        Date: ${widget.vehicle.formattedDate}
        Time: ${widget.vehicle.formattedTime}
        
        Thank You Visit Again
      '''
    );

    final Uri smsUri = Uri.parse("sms:${widget.vehicle.phone_no}?body=$message");

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to send SMS")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Driver Name', widget.vehicle.driver_name),
            _buildDetailRow('Vehicle No', widget.vehicle.number_plate),
            _buildDetailRow('Company Name', widget.vehicle.company_name),
            _buildDetailRow('First Weight', widget.vehicle.first_weight),
            _buildDetailRow('Second Weight', widget.vehicle.second_weight),
            _buildDetailRow('Net Weight', widget.vehicle.net_weight),
            _buildDetailRow('Amount', widget.vehicle.amount),
            _buildDetailRow('Phone No', widget.vehicle.phone_no),
            _buildDetailRow('Date', widget.vehicle.formattedDate),
            _buildDetailRow('Time', widget.vehicle.formattedTime),
            if (widget.vehicle.image_path != null && widget.vehicle.image_path!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Image.network(widget.vehicle.image_path!, height: 150, width: 150),
              ),

            SizedBox(height: 20,),
            Center(
              child: ElevatedButton(
                  onPressed: _sendSMS,
                  child: Text("Send Message")
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}