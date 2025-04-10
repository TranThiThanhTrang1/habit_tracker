import 'package:flutter/material.dart';
import 'add_habit_screen.dart';

class HabitTrackerScreen extends StatefulWidget {
  final String username;

  const HabitTrackerScreen({super.key, required this.username});

  @override
  _HabitTrackerScreenState createState() => _HabitTrackerScreenState();
}

class _HabitTrackerScreenState extends State<HabitTrackerScreen> {
  Map<String, String> selectedHabitsMap = {};
  Map<String, String> completedHabitsMap = {};
  String name = '';

  @override
  void initState() {
    super.initState();
    name = widget.username; // Gán tên người dùng
  }

  Future<void> _saveHabits() async {
    // Lưu thói quen vào preferences trong tương lai
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor'; // Thêm độ mờ nếu chưa có
    }
    return Color(int.parse('0x$hexColor'));
  }

  Color _getHabitColor(String habit, Map<String, String> habitsMap) {
    String? colorHex = habitsMap[habit];
    if (colorHex != null) {
      try {
        return _getColorFromHex(colorHex);
      } catch (e) {
        print('Error parsing color for $habit: $e');
      }
    }
    return Colors.blue; // Màu mặc định trong trường hợp lỗi
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Text(
          name.isNotEmpty ? name : 'Loading...',
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Configure'),
              onTap: () {
                // Xử lý sự kiện khi chọn mục
              },
            ),
            ListTile(
              title: Text('Personal Info'),
              onTap: () {
                // Xử lý sự kiện khi chọn mục
              },
            ),
            ListTile(
              title: Text('Reports'),
              onTap: () {
                // Xử lý sự kiện khi chọn mục
              },
            ),
            ListTile(
              title: Text('Notifications'),
              onTap: () {
                // Xử lý sự kiện khi chọn mục
              },
            ),
            ListTile(
              title: Text('Sign Out'),
              onTap: () {
                // Xử lý sự kiện khi chọn mục
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'To Do 📝',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          selectedHabitsMap.isEmpty
              ? const Expanded(
                  child: Center(
                    child: Text(
                      'Use the + button to create some habits!',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: selectedHabitsMap.length,
                    itemBuilder: (context, index) {
                      String habit = selectedHabitsMap.keys.elementAt(index);
                      Color habitColor =
                          _getHabitColor(habit, selectedHabitsMap);
                      return Dismissible(
                        key: Key(habit),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          setState(() {
                            String color = selectedHabitsMap.remove(habit)!;
                            completedHabitsMap[habit] = color;
                            _saveHabits();
                          });
                        },
                        background: Container(
                          color: Colors.green,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Swipe to Complete',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.check, color: Colors.white),
                            ],
                          ),
                        ),
                        child: _buildHabitCard(habit, habitColor),
                      );
                    },
                  ),
                ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Done ✅🎉',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          completedHabitsMap.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Swipe right on an activity to mark as done.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: completedHabitsMap.length,
                    itemBuilder: (context, index) {
                      String habit = completedHabitsMap.keys.elementAt(index);
                      Color habitColor =
                          _getHabitColor(habit, completedHabitsMap);
                      return Dismissible(
                        key: Key(habit),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (direction) {
                          setState(() {
                            String color = completedHabitsMap.remove(habit)!;
                            selectedHabitsMap[habit] = color;
                            _saveHabits();
                          });
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Row(
                            children: [
                              Icon(Icons.undo, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                'Swipe to Undo',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        child: _buildHabitCard(habit, habitColor,
                            isCompleted: true),
                      );
                    },
                  ),
                ),
        ],
      ),
      floatingActionButton: selectedHabitsMap.isEmpty
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddHabitScreen(),
                  ),
                );
              },
              child: const Icon(Icons.add),
              backgroundColor: Colors.blue.shade700,
              tooltip: 'Add Habits',
            )
          : null,
    );
  }

  Widget _buildHabitCard(String title, Color color,
      {bool isCompleted = false}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: color,
      child: Container(
        height: 60, // Điều chỉnh chiều cao cho các thẻ dày hơn.
        child: ListTile(
          title: Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          trailing: isCompleted
              ? const Icon(Icons.check_circle, color: Colors.green, size: 28)
              : null,
        ),
      ),
    );
  }
}