import 'package:flutter/material.dart';
import 'package:msp_mobile/models/category.dart';
import 'package:msp_mobile/models/media.dart';
import 'package:msp_mobile/repositories/category_repository.dart';
import 'package:msp_mobile/repositories/media_repository.dart';
import 'package:msp_mobile/screens/video-player-page.dart';
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
  // final List<Map<String, dynamic>> popularVideos = [
  //   {
  //     'thumbnailUrl': 'https://i.pinimg.com/1200x/67/51/ee/6751ee91b9d874d4ebf717a7c251667f.jpg',
  //     'duration': '10:30',
  //     'title': 'Flutter Tutorial - Building Beautiful UIs',
  //     'subtitle': 'Flutter Channel',
  //     'avatarUrl': 'https://example.com/avatar1.jpg',
  //   },
  //   {
  //     'thumbnailUrl': 'https://images.unsplash.com/photo-1555099962-4199c345e5dd?w=500',
  //     'duration': '15:45',
  //     'title': 'Dart Programming Masterclass',
  //     'subtitle': 'Dart Masters',
  //     'avatarUrl': 'https://example.com/avatar2.jpg',
  //   },
  //   {
  //     'thumbnailUrl': 'https://images.unsplash.com/photo-1551650975-87deedd944c3?w=500',
  //     'duration': '22:10',
  //     'title': 'Firebase Integration in Flutter',
  //     'subtitle': 'Firebase Experts',
  //     'avatarUrl': 'https://example.com/avatar3.jpg',
  //   },
  // ];

  // final List<Map<String, dynamic>> trendingVideos = [
  //   {
  //     'thumbnailUrl': 'https://images.unsplash.com/photo-1517077304055-6e89abbf09b0?w=500',
  //     'duration': '12:15',
  //     'title': 'Advanced Animations in Flutter',
  //     'subtitle': 'Animation Pro',
  //     'avatarUrl': 'https://example.com/avatar5.jpg',
  //   },
  //   {
  //     'thumbnailUrl': 'https://images.unsplash.com/photo-1547658719-da2b51169166?w=500',
  //     'duration': '25:30',
  //     'title': 'Building a Complete E-commerce App',
  //     'subtitle': 'App Builders',
  //     'avatarUrl': 'https://example.com/avatar6.jpg',
  //   },
  // ];
  //List<Category> categories = [];

  List<Category> categories = [];
List<Media> allMedia = [];

@override
void initState() {
  super.initState();
  // final categoryRepository = ;
  // final mediaRepository = MediaRepository(baseUrl: 'https://your-api.com/api');
  _fetchData();
}

Future<void> _fetchData() async {
  try {
    final categoryList = await CategoryRepository(baseUrl: 'https://msp-backend-q78f.onrender.com').fetchAllCategories();
    final mediaList = await MediaRepository(baseUrl: 'https://msp-backend-q78f.onrender.com').fetchAllMedia();

    setState(() {
      categories = categoryList;
      allMedia = mediaList;
    });
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error fetching data: $e')),
    );
  }
}

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

  void _navigateToVideoListPage(String title, List<Media> videos) {
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

List<Media> _getVideosByCategory(String categoryId) {
  return allMedia.where((media) => media.categoryId == categoryId).toList();
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
  onRefresh: _fetchData,
  child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: categories.map((category) {
              final videos = _getVideosByCategory(category.id!);
              if (videos.isEmpty) return const SizedBox(); // skip empty categories

              return _buildVideoSection(
                title: category.name,
                videos: videos,
                icon: Icons.video_library,
              );
            }).toList(),
          ),
        ),
),

      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }



  Widget _buildVideoSection({
    required String title,
    required List<Media> videos,
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
                  // Icon(icon, size: 20, color: Theme.of(context).colorScheme.background),
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
  thumbnailUrl:  video.thumbnail ?? 'https://example.com/default_thumbnail.png',
 
  title: video.title,
  subtitle: video.description?? "",
  //avatarUrl: video.ava,
  onTap: () {
    // Navigate to VideoPlayerPage when video is tapped
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerPage(
          title: video.title,
          subtitle: video.description,
          thumbnailUrl: video.thumbnail,
          videoUrl: video.filePath,
        ),
      ),
    );
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
    // Navigate to VideoPlayerPage when video is tapped
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerPage(
          title: "Live Stream",
          subtitle: "",
          thumbnailUrl: "",
          videoUrl: "https://462dx4mlqj3o-hls-live.wmncdn.net/jnvisiontv/0e1fd802947a734b3af7787436f11588.sdp/chunks.m3u8",
        ),
      ),
    );
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
                Icons.wifi_tethering,
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