import 'dart:developer';
import 'dart:io';
import 'package:bca_exam_managment/features/models/student_model.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart' as xls;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Required headers
const requiredHeaders = ["Name", "RegNo", "Department", "Sem"];

/// Helper to log + toast
void logToast(String msg) {
  log(msg);
  Fluttertoast.showToast(msg: msg);
}

/// Pick and parse (CSV / Excel)
Future<List<Students>> pickFileAndParse(BuildContext context) async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['csv', 'xlsx'],
  );
  if (result == null) {
    logToast("No file selected");
    return [];
  }

  final file = File(result.files.single.path!);
  final ext = file.path.split('.').last.toLowerCase();

  try {
    if (ext == 'csv') return await _parseCsv(file);
    if (ext == 'xlsx') return await _parseExcel(file);
    logToast("Unsupported file type: $ext");
  } catch (e) {
    logToast("Error reading file: $e");
  }
  return [];
}

/// Parse CSV file
Future<List<Students>> _parseCsv(File file) async {
  final content = await file.readAsString();
  final rows = const CsvToListConverter().convert(content);
  return _rowsToStudents(rows);
}

/// Parse Excel file
Future<List<Students>> _parseExcel(File file) async {
  final bytes = await file.readAsBytes();
  final excel = xls.Excel.decodeBytes(bytes);
  final rows = excel.tables[excel.tables.keys.first]?.rows ?? [];
  final mapped =
      rows
          .map((r) => r.map((c) => c?.value.toString().trim() ?? '').toList())
          .toList();
  return _rowsToStudents(mapped);
}

List<Students> _rowsToStudents(List<List<dynamic>> rows) {
  if (rows.isEmpty) return [];
  final headers = rows.first.map((e) => e.toString().trim()).toList();

  for (var h in requiredHeaders) {
    if (!headers.contains(h)) {
      logToast(
        "Missing required header: $h. Expected: ${requiredHeaders.join(', ')}",
      );
      return [];
    }
  }

  final students = <Students>[];
  final errors = <String>[];

  for (var i = 1; i < rows.length; i++) {
    final rowMap = {
      for (var j = 0; j < headers.length; j++)
        headers[j]: j < rows[i].length ? rows[i][j].toString().trim() : '',
    };

    if (requiredHeaders.any((h) => rowMap[h]!.isEmpty)) {
      errors.add("Row ${i + 1} missing required data");
      continue;
    }

    students.add(
      Students(
        name: rowMap["Name"]!,
        regNo: rowMap["RegNo"]!,
        department: rowMap["Department"]!,
        sem: rowMap["Sem"]!,
        createdAt: Timestamp.now(),
      ),
    );
    log(
      "[log] Added student: ${rowMap["Name"]}, ${rowMap["RegNo"]}, ${rowMap["Department"]}, ${rowMap["Sem"]}",
    );
  }

  if (errors.isNotEmpty) logToast("Skipped ${errors.length} invalid rows");
  logToast("${students.length} students added successfully");
  return students;
}
