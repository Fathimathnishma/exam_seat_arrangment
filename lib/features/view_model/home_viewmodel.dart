import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeProvider extends ChangeNotifier {
String todayDate = DateFormat('dd MMMM yyyy').format(DateTime.now());

DateTime _dateTime = DateTime.now();
  DateTime get dateTime => _dateTime;
    String? selectedCategory;
  String searchText = "";

  final _dateTimeController = StreamController<DateTime>.broadcast();
String get formattedDate => DateFormat(' d MMM yyyy').format(_dateTime);
  String get formattedTime => DateFormat('h:mm a').format(_dateTime);


  Stream<DateTime> get dateTimeStream => _dateTimeController.stream;


  void startDateTimeStream() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _dateTime = DateTime.now();
      _dateTimeController.add(_dateTime);
    });
  }

   void dispose() {
    _dateTimeController.close();
    super.dispose();
  }

//  void filterByCategory(String? category) {
//     selectedCategory = category;
//     filterEvents();
//   }

//   // Handle search input change
//   void onSearchChanged(String? value) {
//     searchText = value?.trim().toLowerCase() ?? "";
//     filterEvents();
//   }

  // Core filter logic
  // void filterEvents() {
  //   filteredEvents =
  //       exam.where((event) {
  //         final matchesCategory =
  //             selectedCategory == null || selectedCategory == "All"
  //                 ? true
  //                 : (event.category?.toLowerCase() ?? "") ==
  //                     selectedCategory!.toLowerCase();

  //         final matchesSearch =
  //             searchText.isEmpty
  //                 ? true
  //                 : event.name.toLowerCase().contains(searchText) ||
  //                     (event.category?.toLowerCase() ?? "").contains(
  //                       searchText,
  //                     );

  //         return matchesCategory && matchesSearch;
  //       }).toList();

  //   notifyListeners();
  // }








}