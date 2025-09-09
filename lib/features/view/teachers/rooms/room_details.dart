import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:bca_exam_managment/features/view/local/localdata.dart';
import 'package:bca_exam_managment/features/view/teachers/select_students.dart';
import 'package:bca_exam_managment/features/view/teachers/widget/main_frame.dart';
import 'package:flutter/material.dart';

class RoomDetailSrcen extends StatefulWidget {
  const RoomDetailSrcen({super.key});

  @override
  State<RoomDetailSrcen> createState() => _RoomDetailSrcenState();
}

class _RoomDetailSrcenState extends State<RoomDetailSrcen> {
  final List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Exam details",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: AppColors.textColor,
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(6),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(color: AppColors.textColor, blurRadius: 1),
                ],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(Icons.arrow_back, color: AppColors.textColor),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SelectStudentsScreen()),
          );
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.primary),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Room Name:ca23s',
                    style: TextStyle(color: AppColors.textColor, fontSize: 14),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'capacity',
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.primary),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Availability',
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          ' Room no:AD123',
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16), // spacing between dropdowns
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          ' matrix',
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [Text("Rooms", style: TextStyle(fontSize: 20))],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 2,
                itemBuilder: (context, index) {
                  return MainFrame(
                    examName: "room 1",
                    examCode: exams[index]["examCode"]!,
                    time: exams[index]["time"]!,
                    sem: exams[index]["sem"]!,
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 15),
              ),
            ),
            Text(
              "Seat Arrangment",
              style: TextStyle(color: AppColors.textColor, fontSize: 20),
            ),
            Container(
              color: AppColors.white,

              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(backgroundColor: AppColors.red, radius: 9),
                        Text("exam name"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.yellow,
                          radius: 9,
                        ),
                        Text("exam name"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.green,
                          radius: 9,
                        ),
                        Text("exam name"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.grey,
                          radius: 9,
                        ),
                        Text("exam name"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 4 columns
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              physics: NeverScrollableScrollPhysics(),
              itemCount: colors.length,
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: colors[index % colors.length],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      "Item ${index + 1}",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
