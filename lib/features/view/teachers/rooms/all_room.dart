import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:bca_exam_managment/core/utils/app_images.dart';
import 'package:bca_exam_managment/core/widgets/custom_fluttertoast.dart';
import 'package:bca_exam_managment/features/view/teachers/rooms/add_rooms.dart';
import 'package:bca_exam_managment/features/view/teachers/rooms/room_details.dart';
import 'package:bca_exam_managment/features/view/teachers/widget/main_frame.dart';
import 'package:bca_exam_managment/features/view_model/room_viewodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllRoomScreens extends StatefulWidget {
  const AllRoomScreens({super.key});

  @override
  State<AllRoomScreens> createState() => _AllRoomScreensState();
}

class _AllRoomScreensState extends State<AllRoomScreens> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RoomProvider>(context, listen: false).fetchRooms();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        title: Text(
          "All Rooms",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: AppColors.textColor,
          ),
        ),
      ),
      body: Consumer<RoomProvider>(
        builder: (BuildContext context, RoomProvider state, Widget? child) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // ✅ Search bar always visible
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        onChanged: state.onSearchChanged,
                        decoration: InputDecoration(
                          hintText: 'Search room...',
                          hintStyle: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            size: 19,
                            color: Colors.white,
                          ),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 5,
                          ),
                          fillColor: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 3),
                    Container(
                      height: 46,
                      width: MediaQuery.sizeOf(context).width * 0.12,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                            builder: (context) => buildBlockFilterSheet(state),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Image.asset(AppImages.filter),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ✅ Room list or empty state
              Expanded(
                child:
                    state.filteredRooms.isEmpty
                        ? Center(
                          child: Text(
                            state.searchText.isNotEmpty
                                ? "No matching rooms found"
                                : "No Room available...",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        )
                        : ListView.separated(
                          padding: const EdgeInsets.only(bottom: 12),
                          itemCount: state.filteredRooms.length,
                          itemBuilder: (context, index) {
                            final data = state.filteredRooms[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            RoomDetailScreen(roomModel: data),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RoomFrame(
                                  roomName: data.roomName!,
                                  roomNo: data.roomNo,
                                  capacity: data.capacity.toString(),
                                  layout: data.layout!,
                                  onUpdate: () {
                                    state.setRoomForUpdate(data);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                AddRoomsScreen(room: data),
                                      ),
                                    );
                                  },
                                  onDelete: () async {
                                    final success =await state.deleteRoom(data.id!);
                                    if (!success) {
                                      showCustomToast(
                                        message: "First delete the exams in room",
                                        isError: true,
                                      );

                                      return;
                                    }
                                    showCustomToast(
                                      message: "Room deleted successfully!",
                                      isError: false,
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                          separatorBuilder:
                              (context, index) => const SizedBox(height: 5),
                        ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildBlockFilterSheet(RoomProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Filter by Block",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16),

          // 🔘 Checkbox List
          ...provider.blockList.map((block) {
            return CheckboxListTile(
              title: Text(block),
              value: provider.selectedBlock == block,
              activeColor: AppColors.primary,
              onChanged: (checked) {
                provider.selectedBlock = checked == true ? block : null;
                provider.filterExams();
                Navigator.pop(context); // close sheet after selecting
              },
            );
          }).toList(),

          SizedBox(height: 10),

          // ❌ Clear Filter
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                provider.selectedBlock = null;
                provider.filterExams();
                Navigator.pop(context);
              },
              child: Text("Clear Filter", style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }
}
