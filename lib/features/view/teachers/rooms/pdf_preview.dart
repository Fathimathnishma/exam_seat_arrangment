import 'dart:io';
import 'dart:typed_data';
import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:bca_exam_managment/features/models/room_model.dart';
import 'package:bca_exam_managment/features/models/student_model.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';

class RoomPdfScreen extends StatelessWidget {
  final RoomModel room;

  const RoomPdfScreen({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Room PDF Preview"),
      ),
      body: PdfPreview(
        actionBarTheme: PdfActionBarTheme(backgroundColor: AppColors.primary),
        build: (format) => _generatePdf(),
        allowPrinting: true,
        allowSharing: true,
        canChangeOrientation: false,
        canChangePageFormat: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _downloadPdf,
        child: const Icon(Icons.download),
      ),
    );
  }

  // ---------------------------------------------------------
  // GENERATE PDF
  // ---------------------------------------------------------
  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return [
            pw.SizedBox(height: 10),

            pw.Text("Room No: ${room.roomNo}",
                style: pw.TextStyle(
                    fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.Text("Room Name: ${room.roomName}",
                style: pw.TextStyle(
                    fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),

            // ---------------------------------------------------------
            // TABLE
            // ---------------------------------------------------------
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: {
                0: const pw.FixedColumnWidth(50),
                1: const pw.FixedColumnWidth(80),
                2: const pw.FlexColumnWidth(),
                3: const pw.FixedColumnWidth(80),
                4: const pw.FixedColumnWidth(50),
              },
              children: [
                // HEADER ROW
                pw.TableRow(
                  decoration:
                      const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    _headerCell("Seat"),
                    _headerCell("Reg No"),
                    _headerCell("Name"),
                    _headerCell("Dept"),
                    _headerCell("Sem"),
                  ],
                ),

                // DATA ROWS
                ...List.generate(room.allSeats.length, (i) {
                  final seat = room.allSeats[i];

                  final student = seat["student"] is StudentsModel
                      ? seat["student"] as StudentsModel
                      : null;

                  return pw.TableRow(
                    children: [
                      _cell((i + 1).toString()), // Auto seat number
                      _cell(student?.regNo ?? "-"),
                      _cell(student?.name ?? "-"),
                      _cell(student?.department ?? "-"),
                      _cell(student?.sem?.toString() ?? "-"),
                    ],
                  );
                }),
              ],
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  // ---------------------------------------------------------
  // DOWNLOAD PDF
  // ---------------------------------------------------------
  Future<void> _downloadPdf() async {
    if (await Permission.storage.request().isDenied) {
      return;
    }

    final bytes = await _generatePdf();
    final directory = await getDownloadsDirectory();

    final file = File("${directory!.path}/Room_${room.roomNo}.pdf");
    await file.writeAsBytes(bytes);

    debugPrint("PDF Saved at: ${file.path}");
  }

  // ---------------------------------------------------------
  // TABLE CELL WIDGETS
  // ---------------------------------------------------------
  pw.Widget _headerCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  pw.Widget _cell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(text, style: const pw.TextStyle(fontSize: 11)),
    );
  }
}
