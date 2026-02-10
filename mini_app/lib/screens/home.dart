import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import 'login_page.dart';
// import 'profile_page.dart';
import '../widgets/reel_card.dart';
import '../pages/upload_reel_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<String> reels = [
      "asset/videos/video1.mp4",
      "asset/videos/video2.mp4",
      "asset/videos/video3.mp4",
    ];

Drawer buildDrawer(BuildContext context) {
  return Drawer(
    child: Column(
      children: [
        UserAccountsDrawerHeader(
          decoration: const BoxDecoration(
            color: Color(0xFF008B8B),
          ),
          accountName: const Text("Gowtham"),
          accountEmail: const Text("gowtham@gmail.com"),
          currentAccountPicture: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 40),
          ),
        ),

        ListTile(
          leading: const Icon(Icons.home),
          title: const Text("Home"),
          onTap: () => Navigator.pop(context),
        ),

        ListTile(
          leading: const Icon(Icons.video_library),
          title: const Text("Reels"),
          onTap: () {},
        ),

        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text("Settings"),
          onTap: () {},
        ),

        const Spacer(),

        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text("Logout"),
          onTap: () async {
            await AuthService().logout();
            if (context.mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            }
          },
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
 
    drawer: buildDrawer(context),

      appBar: AppBar(
        backgroundColor: const Color(0xFF008B8B),
        title: const Text(
          "AJNAM",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),


      
      // body: Center(
      //   child: ElevatedButton(
      //     child: const Text("Go to Profile"),
      //     onPressed: () {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (_) => const ProfilePage(),
      //         ),
      //       );
      //     },
      //   ),
      // ),
        // 🔷 REELS PREVIEW LIST
      body: Column(
        children: [
          // 🔥 HALF SCREEN VIDEO SECTION
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: reels.length,
              itemBuilder: (context, index) {
                return ReelCard(videoPath: 
                  reels[index],
                  reels: reels,
                  index: index,);
              },
            ),
          ),

          // 🔽 BELOW VIDEO (YOUR FUTURE CONTENT)
          Expanded(
            child: Center(
              child: Text(
                "Other content here",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
          ),         
        ],
      ),

      // 🔹 CENTER FAB (+ ADD REEL)
    floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.black,
      onPressed: () async {
        final newVideo = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const UploadReelPage()),
        );

        if (newVideo != null) {
          setState(() {
            reels.insert(0, newVideo); // add new reel on top
          });
        }
      },
      child: const Icon(Icons.add),
    ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // 🔹 BOTTOM BAR (LIKE IMAGE)
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _bottomIcon(Icons.home, "Home"),
              _bottomIcon(Icons.shopping_cart, "Shop"),
              const SizedBox(width: 40), // space for FAB
              _bottomIcon(Icons.miscellaneous_services, "Services"),
              _bottomIcon(Icons.settings, "Settings"),
            ],
          ),
        ),
    )
    );
  }
  
  void setState(Null Function() param0) {}
}

  Widget _bottomIcon(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.black),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }