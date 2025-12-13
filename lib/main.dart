import 'package:flutter/material.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moovie App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF075E54),
        // secondary: const Color(0xFF25D366),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF075E54),
          secondary: const Color(0xFF25D366),
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF075E54),
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF25D366),
          foregroundColor: Colors.white,
        ),
        useMaterial3: false, // Keeping false for classic WhatsApp look
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  
  // Global list of contacts/chats shared across the app session
  static List<Map<String, dynamic>> globalChats = [
      {'name': 'Alice', 'message': 'Hi there!', 'time': '10:00 AM', 'icon': Icons.person, 'unread': 1},
      {'name': 'Bob', 'message': '📸 Photo', 'time': '9:45 AM', 'icon': Icons.person, 'unread': 0},
      {'name': 'Charlie', 'message': '🎤 0:15', 'time': 'Yesterday', 'icon': Icons.person, 'unread': 2},
      {'name': 'Team Group', 'message': 'You: Meeting starts in 5 mins', 'time': 'Yesterday', 'icon': Icons.group, 'unread': 0},
      {'name': 'Mom', 'message': 'Call me when you are free', 'time': '2 days ago', 'icon': Icons.person, 'unread': 0},
      {'name': 'Business Account', 'message': 'Your order #1234 has shipped', 'time': '10/08/23', 'icon': Icons.store, 'unread': 0},
  ];

  @override
  void initState() {
    super.initState();
    // 4 tabs: Camera (icon only), Chats, Status, Calls
    _tabController = TabController(length: 4, vsync: this, initialIndex: 1);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {}); // Rebuild to update FAB
  }
  
  void _addChat(String name, String message) {
    setState(() {
      globalChats.insert(0, {
        'name': name,
        'message': message,
        'time': TimeOfDay.now().format(context),
        'icon': Icons.person,
        'unread': 0,
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isSearching 
        ? AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.grey),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                });
              },
            ),
            title: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: "Search...",
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.black),
            ),
          )
        : AppBar(
            title: const Text("Moovie App"),
            actions: [
              IconButton(icon: const Icon(Icons.camera_alt_outlined), onPressed: () {}),
              IconButton(
                icon: const Icon(Icons.search), 
                onPressed: () {
                  setState(() {
                    _isSearching = true;
                  });
                }
              ),
              PopupMenuButton<String>(
                onSelected: (value) {},
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem(value: "New group", child: Text("New group")),
                    const PopupMenuItem(value: "New broadcast", child: Text("New broadcast")),
                    const PopupMenuItem(value: "Linked devices", child: Text("Linked devices")),
                    const PopupMenuItem(value: "Starred messages", child: Text("Starred messages")),
                    const PopupMenuItem(value: "Settings", child: Text("Settings")),
                  ];
                },
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              tabs: const [
                Tab(icon: Icon(Icons.camera_alt, size: 20), iconMargin: EdgeInsets.zero), // Narrower tab for camera
                Tab(text: "CHATS"),
                Tab(text: "STATUS"),
                Tab(text: "CALLS"),
              ],
              labelPadding: EdgeInsets.zero,
            ),
          ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const CameraScreenPlaceholder(),
          ChatListScreen(chats: globalChats),
          const StatusScreen(),
          const CallsScreen(),
        ],
      ),
      floatingActionButton: _buildFab(),
    );
  }

  Widget? _buildFab() {
    if (_tabController.index == 0) return null; // No FAB on Camera tab

    if (_tabController.index == 1) { // Chats
      return FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const SelectContactScreen()));
          if (result != null && result is Map<String, String>) {
            // If a new contact was added and returned, add it to chat list
            _addChat(result['name']!, "Tap to start chatting");
          }
        },
        child: const Icon(Icons.message),
      );
    } else if (_tabController.index == 2) { // Status
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: "status_edit",
            onPressed: () {},
            backgroundColor: Colors.grey[200],
            elevation: 4,
            child: const Icon(Icons.edit, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: "status_camera",
            onPressed: () {},
            child: const Icon(Icons.camera_alt),
          ),
        ],
      );
    } else if (_tabController.index == 3) { // Calls
      return FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add_call),
      );
    }
    return null;
  }
}

// ------------------ CAMERA TAB ------------------

class CameraScreenPlaceholder extends StatelessWidget {
  const CameraScreenPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.camera_alt, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text("Tap to take photo", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// ------------------ CHATS TAB ------------------

class ChatListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> chats;
  
  const ChatListScreen({super.key, required this.chats});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatDetailScreen(name: chat['name'], icon: chat['icon']),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey[300],
                  child: Icon(chat['icon'] as IconData, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            chat['name'] as String, 
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            chat['time'] as String,
                            style: TextStyle(
                              fontSize: 12, 
                              color: (chat['unread'] as int) > 0 ? const Color(0xFF25D366) : Colors.grey
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              chat['message'] as String, 
                              maxLines: 1, 
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                          if ((chat['unread'] as int) > 0)
                            Container(
                              width: 22,
                              height: 22,
                              decoration: const BoxDecoration(
                                color: Color(0xFF25D366),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  (chat['unread']).toString(),
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ------------------ STATUS TAB ------------------

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Stack(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF25D366),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.add, size: 16, color: Colors.white),
                  ),
                )
              ],
            ),
            title: const Text("My Status", style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text("Tap to add status update"),
            onTap: () {},
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text("Recent updates", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          _buildStatusItem("Alice", "10 minutes ago", false),
          _buildStatusItem("Bob", "Today, 8:56 AM", false),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text("Viewed updates", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          _buildStatusItem("Charlie", "Yesterday, 11:00 PM", true),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String name, String time, bool viewed) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: viewed ? Colors.grey : const Color(0xFF25D366),
            width: 2,
          ),
        ),
        child: const CircleAvatar(
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, color: Colors.white),
        ),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(time),
      onTap: () {},
    );
  }
}

// ------------------ CALLS TAB ------------------

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const ListTile(
          leading: CircleAvatar(
            backgroundColor: Color(0xFF075E54),
            child: Icon(Icons.link, color: Colors.white),
          ),
          title: Text("Create call link", style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("Share a link for your WhatsApp call"),
        ),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("Recent", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        ),
        _buildCallItem("Alice", "Today, 10:30 AM", "incoming", false),
        _buildCallItem("Bob", "Yesterday, 9:00 PM", "missed", true),
        _buildCallItem("Charlie", "August 10, 6:00 PM", "outgoing", false),
      ],
    );
  }

  Widget _buildCallItem(String name, String time, String type, bool isVideo) {
    return ListTile(
      leading: const CircleAvatar(backgroundColor: Colors.grey, child: Icon(Icons.person, color: Colors.white)),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Row(
        children: [
          Icon(
            type == 'missed' ? Icons.call_missed : (type == 'outgoing' ? Icons.call_made : Icons.call_received),
            size: 16,
            color: type == 'missed' ? Colors.red : const Color(0xFF25D366),
          ),
          const SizedBox(width: 5),
          Text(time),
        ],
      ),
      trailing: Icon(isVideo ? Icons.videocam : Icons.call, color: const Color(0xFF075E54)),
      onTap: () {},
    );
  }
}

// ------------------ SELECT CONTACT ------------------

class SelectContactScreen extends StatelessWidget {
  const SelectContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contacts = [
      {'name': 'Alice', 'status': 'Busy'},
      {'name': 'Bob', 'status': 'Available'},
      {'name': 'Charlie', 'status': 'At work'},
      {'name': 'Dad', 'status': 'Sleeping'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Select contact", style: TextStyle(fontSize: 18)),
            Text("${contacts.length} contacts", style: const TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
           IconButton(icon: const Icon(Icons.search), onPressed: () {}),
           IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: ListView(
        children: [
          const ListTile(
            leading: CircleAvatar(backgroundColor: Color(0xFF25D366), child: Icon(Icons.group_add, color: Colors.white)),
            title: Text("New group", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: const CircleAvatar(backgroundColor: Color(0xFF25D366), child: Icon(Icons.person_add, color: Colors.white)),
            title: const Text("New contact", style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.qr_code, color: Colors.grey),
            onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => const AddContactScreen())).then((result) {
                 if (result != null) {
                   Navigator.pop(context, result); // Pass result back to MainScreen
                 }
               });
            },
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Contacts on Moovie App", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          ...contacts.map((contact) => ListTile(
            leading: const CircleAvatar(backgroundColor: Colors.grey, child: Icon(Icons.person, color: Colors.white)),
            title: Text(contact['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(contact['status']!),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetailScreen(name: contact['name']!, icon: Icons.person),
                ),
              );
            },
          )),
        ],
      ),
    );
  }
}

// ------------------ ADD CONTACT SCREEN ------------------

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: const Text("New contact"),
        actions: [
           TextButton(
             onPressed: () {
               if (_nameController.text.isNotEmpty && _phoneController.text.isNotEmpty) {
                  // Pass data back to previous screen
                  Navigator.pop(context, {'name': _nameController.text, 'phone': _phoneController.text});
               }
             }, 
             child: const Text("SAVE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
           ),
           IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Save to Google", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person, color: Colors.grey),
                labelText: "First name",
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                prefixIcon: SizedBox(width: 24), // Empty space to align
                labelText: "Last name",
              ),
            ),
            const SizedBox(height: 20),
             TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.phone, color: Colors.grey),
                labelText: "Phone",
                hintText: "Mobile",
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ------------------ CHAT DETAIL (MESSAGING) ------------------

class ChatDetailScreen extends StatefulWidget {
  final String name;
  final IconData icon;

  const ChatDetailScreen({super.key, required this.name, required this.icon});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Initial messages
  final List<Map<String, dynamic>> _messages = [
    {'text': 'Hi there!', 'isMe': false, 'time': '10:00 AM'},
    {'text': 'Hello! How are you?', 'isMe': true, 'time': '10:05 AM'},
  ];

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({
          'text': _controller.text,
          'isMe': true,
          'time': TimeOfDay.now().format(context),
        });
        _controller.clear();
      });
      // Scroll to bottom
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background pattern (simulated)
      backgroundColor: const Color(0xFFE5DDD5),
      appBar: AppBar(
        leadingWidth: 20,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey[300],
              child: Icon(widget.icon, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name, style: const TextStyle(fontSize: 16)),
                  const Text("online", style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.videocam), onPressed: () {}),
          IconButton(icon: const Icon(Icons.call), onPressed: () {}),
          PopupMenuButton<String>(
            onSelected: (value) {},
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(value: "View contact", child: Text("View contact")),
                const PopupMenuItem(value: "Media, links, and docs", child: Text("Media, links, and docs")),
                const PopupMenuItem(value: "Search", child: Text("Search")),
                const PopupMenuItem(value: "Mute notifications", child: Text("Mute notifications")),
                const PopupMenuItem(value: "Wallpaper", child: Text("Wallpaper")),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg['isMe'] as bool;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      color: isMe ? const Color(0xFFDCF8C6) : Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Text(
                                msg['text'] as String,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Row(
                                children: [
                                  Text(
                                    msg['time'] as String,
                                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                                  ),
                                  if (isMe) ...[
                                    const SizedBox(width: 5),
                                    const Icon(Icons.done_all, size: 14, color: Colors.blue),
                                  ]
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.all(5),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [BoxShadow(color: Colors.black12, offset: Offset(0, 1), blurRadius: 1)]
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.grey), 
                          onPressed: () {}
                        ),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: const InputDecoration(
                              hintText: "Message",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.attach_file, color: Colors.grey), 
                          onPressed: () {
                             showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context, 
                              builder: (context) => _buildAttachmentSheet()
                            );
                          }
                        ),
                        IconButton(
                          icon: const Icon(Icons.camera_alt, color: Colors.grey), 
                          onPressed: () {}
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: _sendMessage,
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: const Color(0xFF075E54),
                    child: const Icon(Icons.mic, color: Colors.white), // Changes to send icon when typing usually
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentSheet() {
    return Container(
      height: 280,
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _iconCreation(Icons.insert_drive_file, Colors.indigo, "Document"),
                  _iconCreation(Icons.camera_alt, Colors.pink, "Camera"),
                  _iconCreation(Icons.insert_photo, Colors.purple, "Gallery"),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _iconCreation(Icons.headset, Colors.orange, "Audio"),
                  _iconCreation(Icons.location_pin, Colors.teal, "Location"),
                  _iconCreation(Icons.person, Colors.blue, "Contact"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconCreation(IconData icon, Color color, String text) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color,
          child: Icon(icon, size: 29, color: Colors.white),
        ),
        const SizedBox(height: 5),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
