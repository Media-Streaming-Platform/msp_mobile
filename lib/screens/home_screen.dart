import 'package:flutter/material.dart';
import 'package:msp_mobile/screens/video_list_page.dart';
import 'package:msp_mobile/widgets/card.dart';
import 'package:theme_provider/theme_provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Sample data for different sections
  final List<Map<String, dynamic>> popularVideos = [
    {
      'thumbnailUrl': 'https://i.pinimg.com/1200x/67/51/ee/6751ee91b9d874d4ebf717a7c251667f.jpg',
      'duration': '10:30',
      'title': 'Flutter Tutorial - Building Beautiful UIs',
      'subtitle': 'Flutter Channel',
      'avatarUrl': 'https://example.com/avatar1.jpg',
    },
    {
      'thumbnailUrl': 'https://images.unsplash.com/photo-1555099962-4199c345e5dd?w=500',
      'duration': '15:45',
      'title': 'Dart Programming Masterclass',
      'subtitle': 'Dart Masters',
      'avatarUrl': 'https://example.com/avatar2.jpg',
    },
    {
      'thumbnailUrl': 'https://images.unsplash.com/photo-1551650975-87deedd944c3?w=500',
      'duration': '22:10',
      'title': 'Firebase Integration in Flutter',
      'subtitle': 'Firebase Experts',
      'avatarUrl': 'https://example.com/avatar3.jpg',
    },
  ];

  final List<Map<String, dynamic>> trendingVideos = [
    {
      'thumbnailUrl': 'https://images.unsplash.com/photo-1517077304055-6e89abbf09b0?w=500',
      'duration': '12:15',
      'title': 'Advanced Animations in Flutter',
      'subtitle': 'Animation Pro',
      'avatarUrl': 'https://example.com/avatar5.jpg',
    },
    {
      'thumbnailUrl': 'https://images.unsplash.com/photo-1547658719-da2b51169166?w=500',
      'duration': '25:30',
      'title': 'Building a Complete E-commerce App',
      'subtitle': 'App Builders',
      'avatarUrl': 'https://example.com/avatar6.jpg',
    },
  ];

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {});
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Content updated'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _navigateToVideoListPage(String title, List<Map<String, dynamic>> videos) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoListPage(
          title: title,
          videos: videos,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          IconButton(
  icon: const Icon(Icons.brightness_6),
  onPressed: () {
    ThemeProvider.controllerOf(context).nextTheme();
  },
),
          // IconButton(
          //   icon: const Icon(Icons.notifications_outlined),
          //   onPressed: () {},
          // ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              // Video sections
              _buildVideoSection(
                title: 'Popular Videos',
                videos: popularVideos,
                icon: Icons.trending_up,
              ),
              _buildVideoSection(
                title: 'Trending Now',
                videos: trendingVideos,
                icon: Icons.local_fire_department,
              ),
              _buildVideoSection(
                title: 'Recommended For You',
                videos: popularVideos,
                icon: Icons.recommend,
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }



  Widget _buildVideoSection({
    required String title,
    required List<Map<String, dynamic>> videos,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 20, color: Colors.deepPurple),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => _navigateToVideoListPage(title, videos),
                child: const Text('See All'),
              ),
            ],
          ),
        ),
        
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              return SizedBox(
                width: 280,
                child: VideoThumbnailCard(
                  thumbnailUrl: video['thumbnailUrl'],
                  duration: video['duration'],
                  title: video['title'],
                  subtitle: video['subtitle'],
                  avatarUrl: video['avatarUrl'],
                  onTap: () {
                    // Handle video tap
                    print('Tapped on: ${video['title']}');
                  },
                ),
              );
            },
          ),
        ),
        
        const SizedBox(height: 8),
      ],
    );
  }

  
  Widget _buildBottomNavigationBar() {
  return Container(
    height: 90, // Increased height to give more space for floating
    child: Stack(
      clipBehavior: Clip.none, // Important: allows elements to draw outside the container
      children: [
        // Main Navigation Bar
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: NavigationBar(
            height: 60,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
        
        // Floating Middle Button - Positioned much higher
        Positioned(
          left: MediaQuery.of(context).size.width / 2 - 35, // Center horizontally
          top: -5, // Much higher positioning
          child: GestureDetector(
            onTap: () {
              // Handle the middle button tap
              print('Middle button tapped!');
              // Add your functionality here
            },
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.tv_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
}