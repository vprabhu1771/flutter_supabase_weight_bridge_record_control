import 'package:intl/intl.dart';

class Vehicle {
  final int id;
  final String number_plate;
  final String driver_name;
  final String company_name;
  final String first_weight;
  final String second_weight;
  final String net_weight;
  final String amount;
  final String phone_no;
  final String? image_path;
  final String type;
  final String created_at;


  Vehicle({
    required this.id,
    required this.number_plate,
    required this.driver_name,
    required this.company_name,
    required this.first_weight,
    required this.second_weight,
    required this.net_weight,
    required this.amount,
    required this.phone_no,
    this.image_path,
    required this.type,
    required this.created_at
  });

  // ✅ Format the date properly
  String get formattedDate {
    try {
      DateTime dateTime = DateTime.parse(created_at); // Parse date
      return DateFormat('dd MMM yyyy').format(dateTime); // Format date
    } catch (e) {
      return created_at; // Return original if parsing fails
    }
  }

  // ✅ Format the time properly
  String get formattedTime {
    try {
      DateTime dateTime = DateTime.parse(created_at); // Parse date
      return DateFormat('hh:mm a').format(dateTime); // Format correctly
    } catch (e) {
      return created_at; // Return original if parsing fails
    }
  }

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
        id: json['id'],
        number_plate: json['number_plate'],
        driver_name: json['driver_name'],
        company_name: json['company_name'],
        first_weight: json['first_weight'],
        second_weight: json['second_weight'],
        net_weight: json['net_weight'],
        amount: json['amount'].toString(), // ✅ Ensure amount is always a String
        phone_no: json['phone_no'],
        image_path: json['image_path'],
        type: json['type'],
        created_at: json['created_at'] as String,
    );
  }
}