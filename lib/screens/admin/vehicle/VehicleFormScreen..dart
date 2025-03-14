import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/Vehicle.dart';

class VehicleFormScreen extends StatefulWidget {
  final String title;
  final Vehicle? vehicle;

  const VehicleFormScreen({super.key, required this.title, this.vehicle});

  @override
  _VehicleFormScreenState createState() => _VehicleFormScreenState();
}

class _VehicleFormScreenState extends State<VehicleFormScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController driverNameController;
  late TextEditingController numberPlateController;
  late TextEditingController companyNameController;
  late TextEditingController firstWeightController;
  late TextEditingController secondWeightController;
  late TextEditingController netWeightController;
  late TextEditingController amountController;
  late TextEditingController phoneNoController;

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? imageUrl;

  // Vehicle Type Dropdown
  final List<String> vehicleTypes = ['Auto', 'Tempo', 'Eicher', 'Tractor', 'Lorry', 'Taurus'];
  String? selectedVehicleType;

  @override
  void initState() {
    super.initState();
    driverNameController = TextEditingController(text: widget.vehicle?.driver_name ?? '');
    numberPlateController = TextEditingController(text: widget.vehicle?.number_plate ?? '');
    companyNameController = TextEditingController(text: widget.vehicle?.company_name ?? '');
    firstWeightController = TextEditingController(text: widget.vehicle?.first_weight.toString() ?? '');
    secondWeightController = TextEditingController(text: widget.vehicle?.second_weight.toString() ?? '');
    netWeightController = TextEditingController(text: widget.vehicle?.net_weight.toString() ?? '');
    amountController = TextEditingController(text: widget.vehicle?.amount.toString() ?? '');
    phoneNoController = TextEditingController(text: widget.vehicle?.phone_no ?? '');

    selectedVehicleType = widget.vehicle?.type ?? vehicleTypes.first;
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      final String fileName = 'vehicles/${DateTime.now().millisecondsSinceEpoch}.jpg';
      await supabase.storage.from('assets').upload(fileName, imageFile);
      return supabase.storage.from('assets').getPublicUrl(fileName);
    } catch (e) {
      print('Image upload failed: $e');
      return null;
    }
  }

  void _saveVehicle() async {
    if (_formKey.currentState!.validate()) {
      if (_imageFile != null) {
        imageUrl = await _uploadImage(_imageFile!);
      }

      final vehicleData = {
        'driver_name': driverNameController.text,
        'number_plate': numberPlateController.text,
        'company_name': companyNameController.text,
        'first_weight': firstWeightController.text,
        'second_weight': secondWeightController.text,
        'net_weight': netWeightController.text,
        'amount': amountController.text,
        'phone_no': phoneNoController.text,

        'type': selectedVehicleType, // Store selected type

        if (imageUrl != null) 'image_path': imageUrl,
      };

      try {
        if (widget.vehicle == null) {
          await supabase.from('vehicles').insert(vehicleData);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('New Vehicle Added'), backgroundColor: Colors.green),
          );
        } else {
          await supabase.from('vehicles').update(vehicleData).eq('id', widget.vehicle!.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Update Success'), backgroundColor: Colors.blue),
          );
        }
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(onPressed: _saveVehicle, icon: Icon(Icons.save)),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(driverNameController, 'Driver Name', (value) {}, TextInputType.text), // Numeric keyboard),
                _buildTextField(numberPlateController, 'Number Plate', (value) {}, TextInputType.text),
                _buildTextField(companyNameController, 'Company Name', (value) {}, TextInputType.text),
                _buildTextField(firstWeightController, 'First Weight', (value) => _calculateNetWeight(), TextInputType.number),
                _buildTextField(secondWeightController, 'Second Weight', (value) => _calculateNetWeight(), TextInputType.number),
                _buildTextField(netWeightController, 'Net Weight', (value) {}, TextInputType.number), // Read-only field
                _buildTextField(amountController, 'Amount', (value) {}, TextInputType.number),
                _buildTextField(phoneNoController, 'Phone No', (value) {}, TextInputType.number),

                _buildDropdownField(), // Vehicle Type Dropdown

                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Pick Image (optional)'),
                ),
                if (imageUrl != null)
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Image.network(imageUrl!, height: 50, width: 50,),
                  ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveVehicle,
                  child: Text(widget.vehicle == null ? 'Add Vehicle' : 'Update Vehicle'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedVehicleType,
        decoration: InputDecoration(labelText: 'Vehicle Type'),
        items: vehicleTypes.map((type) {
          return DropdownMenuItem(value: type, child: Text(type));
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedVehicleType = value;
          });
        },
        validator: (value) => value == null ? 'Please select a vehicle type' : null,
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      Function(String) onChanged,
      TextInputType keyboardType
    ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        validator: (value) => value!.isEmpty ? 'Enter $label' : null,
        onChanged: onChanged,
        keyboardType: keyboardType, // Set the keyboard type
      ),
    );
  }

  void _calculateNetWeight() {
    double firstWeight = double.tryParse(firstWeightController.text) ?? 0;
    double secondWeight = double.tryParse(secondWeightController.text) ?? 0;
    double netWeight = firstWeight - secondWeight;

    netWeightController.text = netWeight.toStringAsFixed(2);
  }
}
