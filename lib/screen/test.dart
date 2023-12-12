import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:google_fonts/google_fonts.dart';
class EntryRecord {
  final String name;
  final int age;
  final String address;

  EntryRecord({required this.name, required this.age, required this.address});
}

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final List<EntryRecord> _entryRecords = [
    EntryRecord(name: 'John Doe', age: 35, address: '123 Main St.'),
    EntryRecord(name: 'Jane Smith', age: 27, address: '456 Maple Ave.'),
    EntryRecord(name: 'Bob Johnson', age: 42, address: '789 Oak Blvd.'),
  ];
  bool _isCreatingPdf = false;
  String _pdfPath = '';

  Future<void> _generatePdf() async {
    setState(() {
      _isCreatingPdf = true;
    });

    final pdf = pw.Document();

    final headers = ['Name', 'Age', 'Address'];
    final data = _entryRecords.map((record) => [record.name, record.age, record.address]).toList();
    final font = await rootBundle.load("assets/fonts/arial.ttf");
    final ttf = pw.Font.ttf(font);
    pw.TextStyle textStyle = pw.TextStyle(font: ttf, fontSize: 12);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Header(
              level: 0,
              child: pw.Text('Entry Record Details',style: textStyle),
            ),
            pw.Table.fromTextArray(

              headerDecoration: pw.BoxDecoration(
                color: PdfColors.grey300,
              ),
              headers: headers,
              data: data,
            ),
          ];
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/entry_record_details.pdf");
    await file.writeAsBytes(await pdf.save());

    setState(() {
      _isCreatingPdf = false;
      _pdfPath = file.path;
    });



    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('PDF Saved'),
        content: Text('The PDF has been saved to $_pdfPath.'),
        actions: [
          TextButton(
            child: Text('Open PDF'),
            onPressed: () async {
              await OpenFile.open(_pdfPath);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Example'),
      ),
      body: Center(
        child:  _isCreatingPdf
            ? CircularProgressIndicator()
            : ElevatedButton(
          child: Text('Create PDF'),
          onPressed: _generatePdf,
        ),
      ),
    );
  }
}

