import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bca_exam_managment/core/utils/app_colors.dart';
import 'package:bca_exam_managment/features/view_model/auth_viewmodel.dart';

// Reuse your existing showLogoutDialog
Future<void> showLogoutDialog(
  BuildContext context, {
  required VoidCallback onConfirm,
  required String text,
}) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text('Are you sure you want to $text?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: Text(text),
          ),
        ],
      );
    },
  );
}

/// 🧾 Page showing all users with delete option


class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({super.key});

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).fetchusers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
        backgroundColor: 
        Colors.white,
      ),
      body: Builder(
        builder: (_) {
          // 🔹 Show loading indicator
          if (authProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // 🔹 Handle empty user list
          if (authProvider.users.isEmpty) {
            return const Center(
              child: Text(
                'No users found',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          // 🔹 Display user list
          return ListView.builder(
            itemCount: authProvider.users.length,
            itemBuilder: (context, index) {
              final user = authProvider.users[index];
              final firstLetter =
                  (user.name ?? "Unknown").substring(0, 1).toUpperCase();

              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.primary.withOpacity(0.2),
                    child: Text(
                      firstLetter,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    user.name ?? "No Name",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(
                    '${user.email ?? "No Email"}\nRole: ${user.role ?? "Unknown"}',
                    style: const TextStyle(height: 1.4),
                  ),
                  isThreeLine: true,
                  trailing: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'delete') {
                        showLogoutDialog(
                          context,
                          text: 'Delete User',
                          onConfirm: () async {
                            await authProvider.deleteAccount(userId: user.id!);
                          },
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
