import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReportScreen extends StatefulWidget {

  final String title;

  const ReportScreen({
    super.key,
    required this.title
  });

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> vehicles = [];

  @override
  void initState() {
    super.initState();
    fetchVehicles();
    generatePDFReport();
  }

  Future<void> fetchVehicles() async {
    final response = await supabase.from('vehicles').select();
    setState(() {
      vehicles = List<Map<String, dynamic>>.from(response);
    });
  }

  Future<void> generatePDFReport() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Vehicle Report", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ["Number Plate", "Driver", "Company", "Net Weight", "Amount", "Type"],
                data: vehicles.map((vehicle) => [
                  vehicle["number_plate"],
                  vehicle["driver_name"],
                  vehicle["company_name"],
                  vehicle["net_weight"],
                  vehicle["amount"],
                  vehicle["type"]
                ]).toList(),
              ),
            ],
          );
        },
      ),
    );

    final output = await getExternalStorageDirectory();
    final file = File("${output!.path}/vehicle_report.pdf");
    await file.writeAsBytes(await pdf.save());

    OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Vehicle Report")),
      body: Center(
        child: ElevatedButton(
          onPressed: generatePDFReport,
          child: Text("Generate Report"),
        ),
      ),
    );
  }
}
