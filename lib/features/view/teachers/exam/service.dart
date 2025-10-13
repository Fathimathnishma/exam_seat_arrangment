import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:bca_exam_managment/features/models/student_model.dart';  // Your model import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';  // For compute
import 'package:flutter/material.dart';

/// -------------------- Service / Parser --------------------
class StudentFileParser {
  // Expected fields with possible header variations (added more variants if needed)
  static final Map<String, List<String>> expectedFields = {
    'name': ['name', 'studentname', 'student_name', 'full_name'],
    'regno': ['regno', 'id', 'studentid', 'registration', 'reg_number', 'register number'],
    'email': ['email', 'mail', 'student_email'],  // Optional
    'department': ['dep', 'department', 'dept', 'depart', 'dpt'],
    'semester': ['sem', 'semester', 'sems', 's', 'sem1', 'semester1'],  // Maps to 'sem'
  };

  // Map actual headers to expected keys
  static Map<String, String> mapHeaders(List<String> headers) {
    Map<String, String> mapped = {};
    final lowerHeaders = headers.map((e) => e.toLowerCase().trim()).toList();

    expectedFields.forEach((key, variants) {
      for (var variant in variants) {
        final index = lowerHeaders.indexOf(variant.toLowerCase());
        if (index != -1) {
          mapped[key] = headers[index];
          break;
        }
      }
    });

    return mapped;
  }

  // CSV parser (updated: require name, regno, department, sem)
  static Future<List<StudentsModel>> parseCsv(String path) async {
    List<StudentsModel> students = [];
    try {
      final file = File(path);
      if (!await file.exists()) {
        print('CSV file not found: $path');
        return [];
      }
      final raw = await file.readAsString(encoding: utf8);
      final rows = const CsvToListConverter(shouldParseNumbers: false).convert(raw);

      if (rows.isEmpty) {
        print('CSV: No rows found in $path');
        return [];
      }

      final headers = rows.first.map((e) => e.toString().trim()).toList();
      final headerMap = mapHeaders(headers);
      print('CSV headers mapped: $headerMap');  // Debug: Check if required headers found

      // Check if required headers are present
      if (!headerMap.containsKey('name') || !headerMap.containsKey('regno') ||
          !headerMap.containsKey('department') || !headerMap.containsKey('semester')) {
        print('CSV missing required headers: $path');
        return [];  // Early exit if file lacks required columns
      }

      for (var row in rows.skip(1)) {
        final rowValues = row.map((e) => e?.toString().trim() ?? '');
        final rowMap = Map.fromIterables(headers, rowValues);

        final name = rowMap[headerMap['name']] ?? '';
        final regno = rowMap[headerMap['regno']] ?? '';
        // final email = headerMap.containsKey('email') ? rowMap[headerMap['email']] ?? '' : '';
        final department = rowMap[headerMap['department']] ?? '';
        final semester = rowMap[headerMap['semester']] ?? '';

        // Require ALL: name, regno, department, sem (non-empty)
        if ([name, regno, department, semester].any((v) => v.isEmpty)) {
          print('CSV row skipped (missing required fields): $row');  // Debug
          continue;
        }

        students.add(StudentsModel(
          name: name,
          regNo: regno,
          department: department,
          sem: semester,  // Use 'sem' field in model
          createdAt: Timestamp.now(),
        ));
      }
      print('CSV parsed: ${students.length} valid students from $path');
    } catch (e) {
      print('CSV parse error for $path: $e');
    }
    return students;
  }

  // Excel parser (updated: require name, regno, department, sem)
  static Future<List<StudentsModel>> parseExcel(String path) async {
    List<StudentsModel> students = [];
    try {
      final file = File(path);
      if (!await file.exists()) {
        print('Excel file not found: $path');
        return [];
      }
      final bytes = await file.readAsBytes();  // Binary read – prevents UTF-8 decode errors
      final excel = Excel.decodeBytes(bytes);

      if (excel.tables == null || excel.tables!.isEmpty) {
        print('Excel: No sheets found in $path');
        return [];
      }

      // Parse only the FIRST non-empty sheet
      final firstSheetKey = excel.tables!.keys.firstWhere(
        (key) => excel.tables![key]?.rows.isNotEmpty ?? false,
        orElse: () => '',
      );
      if (firstSheetKey.isEmpty) {
        print('Excel: No data in sheets of $path');
        return [];
      }

      final sheet = excel.tables![firstSheetKey];
      final headers = sheet?.rows.first.map((e) => e?.value?.toString().trim() ?? '').toList();
      final headerMap = mapHeaders(headers!);
      print('Excel headers mapped (sheet: $firstSheetKey): $headerMap');  // Debug

      // Check if required headers are present
      if (!headerMap.containsKey('name') || !headerMap.containsKey('regno') ||
          !headerMap.containsKey('department') || !headerMap.containsKey('semester')) {
        print('Excel missing required headers: $path');
        return [];  // Early exit if file lacks required columns
      }

      for (var row in sheet!.rows.skip(1)) {
        final rowValues = row.map((e) => e?.value?.toString().trim() ?? '');
        final rowMap = Map.fromIterables(headers, rowValues);

        final name = rowMap[headerMap['name']] ?? '';
        final regno = rowMap[headerMap['regno']] ?? '';
        // final email = headerMap.containsKey('email') ? rowMap[headerMap['email']] ?? '' : '';
        final department = rowMap[headerMap['department']] ?? '';
        final semester = rowMap[headerMap['semester']] ?? '';

        // Require ALL: name, regno, department, sem (non-empty)
        if ([name, regno, department, semester].any((v) => v.isEmpty)) {
          print('Excel row skipped (missing required fields): $rowValues');  // Debug
          continue;
        }

        students.add(StudentsModel(
          name: name,
          regNo: regno,
          department: department,
          sem: semester,  // Use 'sem' field in model
          createdAt: Timestamp.now(),
        ));
      }
      print('Excel parsed: ${students.length} valid students from $path');
    } catch (e) {
      print('Excel parse error for $path: $e');  // No UTF-8 issues here
    }
    return students;
  }

  // General pick file & parse function (updated: better feedback for missing fields)
  static Future<List<StudentsModel>> pickAndParseFile(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'xlsx', 'xls'],  // Only CSV & Excel
      );

      if (result == null || result.files.isEmpty) {
        print('No file picked');
        return [];
      }

      final singleFile = result.files.single;
      final path = singleFile.path;
      if (path == null) {
        print('File path is null – fallback not implemented');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid file selection')),
          );
        }
        return [];
      }

      final extension = path.toLowerCase();
      List<StudentsModel> loaded;
      if (extension.endsWith('.csv')) {
        loaded = await compute((p) => parseCsv(p), path);
      } else if (extension.endsWith('.xlsx') || extension.endsWith('.xls')) {
        loaded = await compute((p) => parseExcel(p), path);
      } else {
        print('Unsupported file: $extension');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Unsupported file type: $extension. Use CSV or XLSX.')),
          );
        }
        return [];
      }

      // Feedback for 0 students (likely missing required fields)
      if (loaded.isEmpty && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No valid students found. Ensure file has required columns: Name, RegNo, Department, Semester.'),
            backgroundColor: Colors.orange,
          ),
        );
      }

      return loaded;
    } catch (e) {
      print('File picker error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking/parsing file: $e')),
        );
      }
      return [];
    }
  }
}

// /// -------------------- UI --------------------
// class FilePickerScreen extends StatefulWidget {
//   @override
//   _FilePickerScreenState createState() => _FilePickerScreenState();
// }

// class _FilePickerScreenState extends State<FilePickerScreen> {
//   bool _isLoading = false;
//   List<StudentsModel> students = [];

//   void loadFile() async {
//     setState(() => _isLoading = true);
//     final loaded = await StudentFileParser.pickAndParseFile(context);
//     if (mounted) {
//       setState(() {
//         students = loaded;
//         _isLoading = false;
//       });

//       if (students.isNotEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('${students.length} students loaded successfully!')),
//         );
//       }
//       // Empty feedback handled in parser
//     }
//   }

//   void clearList() {
//     setState(() => students = []);
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('List cleared')),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Upload Students')),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // Instructions for required fields
//             Card(
//               child: Padding(
//                 padding: EdgeInsets.all(12),
//                 child: Text(
//                   'Required columns in file: Name, RegNo, Department, Semester. All must be filled.',
//                   style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: _isLoading ? null : loadFile,
//                     icon: Icon(Icons.file_upload),
//                     label: Text('Pick CSV/XLS/XLSX File'),
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 ElevatedButton.icon(
//                   onPressed: students.isEmpty ? null : clearList,
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                   icon: Icon(Icons.clear),
//                   label: Text('Clear'),
//                 ),
//               ],
//             ),
//             if (_isLoading) Padding(
//               padding: EdgeInsets.all(16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [CircularProgressIndicator(), SizedBox(width: 8), Text('Parsing file...')],
//               ),
//             ),
//             SizedBox(height: 16),
//             Text('${students.length} students loaded', style: Theme.of(context).textTheme.titleMedium),
//             if (students.isEmpty && !_isLoading) ...[
//               Padding(
//                 padding: EdgeInsets.all(32),
//                 child: Column(
//                   children: [
//                     Icon(Icons.list_alt, size: 64, color: Colors.grey),
//                     SizedBox(height: 8),
//                     Text('No students yet. Pick a file with complete data.', textAlign: TextAlign.center),
//                   ],
//                 ),
//               ),
//             ],
//             Expanded(
//               child: students.isEmpty
//                   ? SizedBox.shrink()  // Hide empty list
//                   : ListView.builder(
//                       itemCount: students.length,
//                       itemBuilder: (_, i) {
//                         final s = students[i];
//                         return Card(
//                           margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                           child: ListTile(
//                             leading: CircleAvatar(child: Text('${i + 1}')),  // Row number
//                             title: Text(s.name, style: TextStyle(fontWeight: FontWeight.bold)),
//                             subtitle: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text('Reg No: ${s.regNo}'),
//                                 Text('Department: ${s.department}'),
//                                 Text('Semester: ${s.sem}'),
//                                 // If email added: Text('Email: ${s.email ?? 'N/A'}'),
//                               ],
//                             ),
//                             trailing: Icon(Icons.person),  // Visual icon
//                           ),
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }