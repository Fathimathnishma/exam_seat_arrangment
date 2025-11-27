import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:bca_exam_managment/features/models/room_model.dart';
import 'package:bca_exam_managment/features/view_model/room_viewodel.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart'; // ✅ Import Flutter Toast

class AddRoomsScreen extends StatefulWidget {
  final RoomModel? room; // null = add, not null = update

  const AddRoomsScreen({Key? key, this.room}) : super(key: key);

  @override
  State<AddRoomsScreen> createState() => _AddRoomsScreenState();
}

class _AddRoomsScreenState extends State<AddRoomsScreen> {
  final _formKey = GlobalKey<FormState>();

  final OutlineInputBorder blueBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(6),
    borderSide: const BorderSide(color: Colors.blue, width: 1.5),
  );

  @override
 @override
void initState() {
  super.initState();
  final provider = Provider.of<RoomProvider>(context, listen: false);

  // Defer execution until after first frame
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (widget.room != null) {
      provider.setRoomForUpdate(widget.room!);
    } else {
      provider.clearControllers();
    }
  });
}


  @override
  Widget build(BuildContext context) {
    return Consumer<RoomProvider>(
      builder: (context, state, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            title: Center(
              child: Text(
                widget.room == null ? "Add Rooms" : "Update Room",
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
                child: Icon(Icons.arrow_back, color: AppColors.textColor),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        
                  
                    // Room Name
                   DropdownButtonFormField<String>(
                    value:  (state.roomName != null &&
                            ['Auditorium Block', 'Library Block', 'PG Block', 'Main Block']
                                .contains(state.roomName))
                        ? state.roomName
                        : null, // your controller variable
                    decoration: InputDecoration(
                      hintText: 'Block Name:',
                      hintStyle: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 14,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      border: blueBorder,
                      enabledBorder: blueBorder,
                      focusedBorder: blueBorder,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Auditorium Block',
                        child: Text('Auditorium Block'),
                      ),
                      DropdownMenuItem(
                        value: 'Library Block',
                        child: Text('Library Block'),
                      ),
                      DropdownMenuItem(
                        value: 'PG Block',
                        child: Text('PG Block'),
                      ),
                      DropdownMenuItem(
                        value: 'Main Block',
                        child: Text('Main Block'),
                      ),
                    ],
                    onChanged: (value) {
                      state.roomName= value; // update selected block
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please select a block name';
                      }
                      return null;
                    },
                  ),
                  
                  
                    // Room Code
                    TextFormField(
                      controller: state.roomCode,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        hintText: 'Room Code:',
                        hintStyle: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 14,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        border: blueBorder,
                        enabledBorder: blueBorder,
                        focusedBorder: blueBorder,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Room code cannot be empty';
                        }
                        return null;
                      },
                    ),
                  
                    // Layout & Capacity
                    Row(
                      children: [
                        // Seating Layout Dropdown
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: context.watch<RoomProvider>().selectedLayout,
                            hint: const Text("Layout"),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              border: blueBorder,
                              enabledBorder: blueBorder,
                              focusedBorder: blueBorder,
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: "2",
                                child: Text("2 per bench"),
                              ),
                              DropdownMenuItem(
                                value: "3",
                                child: Text("3 per bench"),
                              ),
                            ],
                            onChanged: (value) {
                              context.read<RoomProvider>().selectedLayout = value;
                              context.read<RoomProvider>().notifyListeners();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Select a layout';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                      
                        // Capacity Input
                        Expanded(
                          child: TextFormField(
                            controller: context.read<RoomProvider>().capacity,
                            decoration: InputDecoration(
                              hintText: "Room Capacity",
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              border: blueBorder,
                              enabledBorder: blueBorder,
                              focusedBorder: blueBorder,
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Enter capacity';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Capacity must be a number';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  
                    ],
                  ),
                ),
                 Gap(10),
                 Gap(10),
                  // Submit Button
                  InkWell(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        await state.saveRoom();
              
                        // ✅ Show toast message after successful add/update
                        Fluttertoast.showToast(
                          msg: widget.room == null
                              ? "Room Added Successfully ✅"
                              : "Room Updated Successfully ✅",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
              
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 45,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        widget.room == null ? 'Add Room' : 'Update Room',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                 
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
