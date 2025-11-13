
import 'dart:developer';

import 'package:bca_exam_managment/features/models/exam_model.dart';
import 'package:bca_exam_managment/features/models/room_model.dart';
import 'package:bca_exam_managment/features/models/student_model.dart';
import 'package:bca_exam_managment/features/repo/exam_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExamProvider extends ChangeNotifier {
  final ExamRepository _examRepo;
  ExamProvider(this._examRepo);

  // Controllers
  final TextEditingController examNameController = TextEditingController();
  final TextEditingController courseIdController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  // Dropdowns
  List<String> semesters = ['1', '2', '3', '4', '5', '6'];
  List<String> departments = ['CS', 'IT', 'ECE', 'ME', 'CE'];
  String? selectedDepartment;
  String? selectedSem;

  //search and filter
   String? selectedCategory;
  String searchText = "";


  // Date
  DateTime? selectedDate;
  List<ExamModel> allExams = [];
  List<RoomModel>roomofExams=[];
    List<ExamModel> todaysExams = [];   
    List<ExamModel> examinRoom = [];   
    List<ExamModel> filteredExams = [];   
    

  // Students
  List<StudentsModel> _students = [];
  List<StudentsModel> get students => _students;

  // Loading & error
  bool isLoading = false;
  String? errorMessage;

  // Update tracking
  String? updatingExamId; // ✅ null = add, not null = update

  void onTodaySearchChanged(String? value) {
  searchText = value?.trim().toLowerCase() ?? "";
  filterTodayExams();
}

void filterTodayExams() {
  final today = DateFormat('dd-MM-yyyy').format(DateTime.now());

  todaysExams = allExams.where((exam) {
    final isToday = exam.date == today;

    final matchesDepartment =
        selectedCategory == null || selectedCategory == "All"
            ? true
            : (exam.department?.toLowerCase() ?? "") ==
                selectedCategory!.toLowerCase();

    final matchesSearch = searchText.isEmpty
        ? true
        : exam.courseName.toLowerCase().contains(searchText) ||
            exam.courseId.toLowerCase().contains(searchText) ||
            (exam.department?.toLowerCase() ?? "").contains(searchText);

    return isToday && matchesDepartment && matchesSearch;
  }).toList();

  notifyListeners();
}



void getTodayExams() {
  final today = DateFormat('dd-MM-yyyy').format(DateTime.now());
  todaysExams = allExams.where((exam) => exam.date == today).toList();
  notifyListeners();
}
void onSearchChanged(String? value) {
  searchText = value?.trim().toLowerCase() ?? "";
  filterExams();
}
void filterExams() {
  
  filteredExams = allExams.where((event) {
    final matchesDepartment =
        selectedCategory == null || selectedCategory == "All"
            ? true
            : (event.department?.toLowerCase() ?? "") ==
                selectedCategory!.toLowerCase();

    final matchesSearch = searchText.isEmpty
        ? true
        : event.courseName.toLowerCase().contains(searchText) ||
            event.courseId.toLowerCase().contains(searchText) ||
            (event.date.toLowerCase().contains(searchText)) ||
            (event.department?.toLowerCase() ?? "").contains(searchText);

    return matchesDepartment && matchesSearch;
  }).toList();

  // Optional: Only reset when both filters are empty
  if (filteredExams.isEmpty && searchText.isEmpty && (selectedCategory == null || selectedCategory == "All")) {
    filteredExams = List.from(allExams);
  }

  notifyListeners();
}



  // // Handle search input change
  // void onSearchChanged(String? value) {
  //   searchText = value?.trim().toLowerCase() ?? "";
  //   filterEvents();
  // }
  /// Set exam for update (pre-fill form)
  void setExamForUpdate(ExamModel exam) {
    updatingExamId = exam.examId;
    examNameController.text = exam.courseName;
    courseIdController.text = exam.courseId;
    selectedDepartment = exam.department;
    selectedSem = exam.sem;
    selectedDate = _parseDate(exam.date);
    timeController.text =
        exam.duration.split('h')[0] +
        ":" +
        exam.duration.split(' ')[1]; // simple split
    endTimeController.text = ""; // optional: user can edit
    _students = exam.students!;
    notifyListeners();
  }

  DateTime? _parseDate(String date) {
    try {
      final parts = date.split('-');
      return DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    } catch (_) {
      return null;
    }
  }

  void addStudents(List<StudentsModel> newStudents) {
    _students.addAll(newStudents);
    notifyListeners();
  }

  void clearStudents() {
    _students.clear();
    notifyListeners();
  }

  void setSemester(String? sem) {
    selectedSem = sem;
    notifyListeners();
  }

  void setDepartment(String? dept) {
    selectedDepartment = dept;
    notifyListeners();
  }

  /// Calculate exam duration
  String getDuration() {
    if (timeController.text.isEmpty || endTimeController.text.isEmpty)
      return "";

    int parseMinutes(String t) {
      final parts = t.split(':');
      int h = int.parse(parts[0]);
      int m = int.parse(parts[1].split(' ')[0]);
      if (t.toLowerCase().contains('pm') && h != 12) h += 12;
      if (t.toLowerCase().contains('am') && h == 12) h = 0;
      return h * 60 + m;
    }

    final diff =
        parseMinutes(endTimeController.text) -
        parseMinutes(timeController.text);
    return "${diff ~/ 60}h ${diff % 60}m";
  }

  /// Save exam (add or update)
  Future<void> saveExam() async {
    if (updatingExamId == null) {
      await addExam();
    } else {
      await updateExam();
    }
  }

  /// Add Exam
  Future<void> addExam() async {
    if (examNameController.text.isEmpty ||
        courseIdController.text.isEmpty ||
        selectedDepartment == null ||
        selectedSem == null ||
        timeController.text.isEmpty ||
        endTimeController.text.isEmpty ||
        selectedDate == null) {
      errorMessage = "Please fill all fields";
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final formattedDate =
          "${selectedDate!.day.toString().padLeft(2, '0')}-"
          "${selectedDate!.month.toString().padLeft(2, '0')}-"
          "${selectedDate!.year}";
  log("1");
      final exam = ExamModel(
        examId: null,
        courseName: examNameController.text,
        courseId: courseIdController.text,
        duration: getDuration(),
        department: selectedDepartment!,
        sem: selectedSem!,
        date: formattedDate,
        createdAt: Timestamp.now(),
        students: _students,
        totalStudents: _students.length,
        duplicatestudents: _students,
        startTime: timeController.text, 
        endTime: endTimeController.text, // simpl
      );
  log("2");
      await _examRepo.addExam(exam);

      clearData();
      clearStudents();
        log("6");

      await fetchExams();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }

    isLoading = false;
    notifyListeners();
  }


///FETCH TODAY EXAM

   void fetchTodaysExams() {
    final now = DateTime.now();
    todaysExams = allExams.where((exam) {
      final examDate = DateTime.fromMillisecondsSinceEpoch(int.parse(exam.date)); // adjust if your field is different
      return examDate.year == now.year &&
          examDate.month == now.month &&
          examDate.day == now.day;
    }).toList();
    notifyListeners();
  }


  /// Fetch all exams
  Future<void> fetchExams() async {
    isLoading = true;
    notifyListeners();

    try {
      allExams=[];
      allExams = await _examRepo.fetchExam();
       filteredExams= List.from(allExams);
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
 
 Future<void> fetchExamsbyId(List<String> examIds) async {
    isLoading = true;
    notifyListeners();
    examinRoom=[];

    examinRoom = await _examRepo.fetchExamsByIds(examIds);

    isLoading = false;
    notifyListeners();
  }
  /// Fetch rooms for  exams
  Future<void> getRoomsByExamId(String examId) async {
    isLoading = true;
    notifyListeners();

    try {
      roomofExams = await _examRepo.getRoomsByExamId(examId);
      log("mmmmmm12 function called");
      log(roomofExams.length.toString());
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  /// Update exam
  Future<void> updateExam() async {
    if (updatingExamId == null) {
      errorMessage = "Exam ID is null";
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final updatedExam = ExamModel(
        examId: updatingExamId,
        courseName: examNameController.text,
        courseId: courseIdController.text,
        duration: getDuration(),
        department: selectedDepartment!,
        sem: selectedSem!,
        date:
            selectedDate != null
                ? "${selectedDate!.day.toString().padLeft(2, '0')}-"
                    "${selectedDate!.month.toString().padLeft(2, '0')}-"
                    "${selectedDate!.year}"
                : "",
        createdAt: Timestamp.now(),
        students: _students,
        startTime: timeController.text,
         endTime: endTimeController.text,
      );

      await _examRepo.updateExam(updatedExam);

      clearData();
      clearStudents();
      updatingExamId = null;
      await fetchExams();
      filterExams();

    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }

    isLoading = false;
    notifyListeners();
  }

  void deleteExamFromRoom(String roomId, String examId) async {
  isLoading = true;
  notifyListeners();

  try {
     log("1");
    // Call the service function
    await _examRepo.deleteExamFromRoom(roomId, examId);
    log("1");
    // Update local state
    final roomIndex = roomofExams.indexWhere((r) => r.id == roomId);
    if (roomIndex != -1) {
      roomofExams[roomIndex].exams.remove(examId);
    }

    examinRoom.removeWhere((exam) => exam.examId == examId);

  } catch (e) {
    errorMessage = e.toString();
  } finally {
    isLoading = false;
    notifyListeners();
  }
}


  /// Delete exam
  Future<void> deleteExam(String examId) async {
    isLoading = true;
    notifyListeners();

    try {
      await _examRepo.deleteExam(examId);
      allExams.removeWhere((exam) => exam.examId == examId);
     filterExams();

    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }

    isLoading = false;
    notifyListeners();
  }

  /// Clear all form data
  void clearData() {
    examNameController.clear();
    courseIdController.clear();
    timeController.clear();
    endTimeController.clear();
    dateController.clear();
    selectedDepartment = null;
    selectedSem = null;
    selectedDate = null;
    updatingExamId = null;
    notifyListeners();
  }
}
