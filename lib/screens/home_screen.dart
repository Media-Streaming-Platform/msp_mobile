// [file name]: home_screen.dart
// [file content begin]
import 'package:flutter/material.dart';
import 'package:msp_mobile/models/category.dart';
import 'package:msp_mobile/models/media.dart';
import 'package:msp_mobile/repositories/category_repository.dart';
import 'package:msp_mobile/repositories/media_repository.dart';
//import 'package:msp_mobile/screens/audio_player.dart';
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

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
//final TabController _tabController = TabController(length: 2, vsync: this);
List<Category> categories = [];
List<Media> allMedia = [];

 late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error fetching data: $e')),
    );
  }
}

  // Future<void> _refreshData() async {
  //   await Future.delayed(const Duration(seconds: 2));
  //   setState(() {});
    
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text('Content updated'),
  //       duration: Duration(seconds: 1),
  //     ),
  //   );
  // }

  void _navigateToVideoListPage(String title, List<Media> videos) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoListPage(
          title: title,
          videos: allMedia,
        ),
      ),
    );
  }

//   void _navigateToPlayer(Map<String, dynamic> item) {
//   if (item['type'] == 'video') {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => VideoPlayerPage(
//           title: item['title'],
//           subtitle: item['subtitle'],
//           thumbnailUrl: item['thumbnailUrl'],
//           videoUrl: item['videoUrl'] ?? 'https://pub-e0bdd32b9eeb4a6d8a15fb9bf208a93e.r2.dev/08_28/index.m3u8',
//         ),
//       ),
//     );
//   } else {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => AudioPlayerPage(
//           title: item['title'],
//           subtitle: item['subtitle'],
//           description: 'This is a detailed description of the audio content. '
//               'It provides information about the topic, duration, and other relevant details '
//               'that users might find interesting before listening to the audio.',
//           audioUrl: 'https://pub-e0bdd32b9eeb4a6d8a15fb9bf208a93e.r2.dev/08_28/index.m3u8',
//         ),
//       ),
//     );
//   }
// }

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
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.video_library),
              text: 'Video',
            ),
            Tab(
              icon: Icon(Icons.audiotrack),
              text: 'Audio',
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              ThemeProvider.controllerOf(context).nextTheme();
            },
          ),
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

              return _buildMediaSection(
                title: category.name,
                videos: videos,
                icon: Icons.video_library,
                isAudio: false,
              );
            }).toList(),
          ),
        ),
),

      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildMediaSection({
    required String title,
    required List<Media> videos,
    required IconData icon,
    required bool isAudio,
  }) {
    // Calculate responsive height based on screen size
    final screenHeight = MediaQuery.of(context).size.height;
    final cardHeight = screenHeight * (isAudio ? 0.22 : 0.28); // 22% for audio, 28% for video
    
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
                    
                    Icon(icon, size: 20, color: Color(0xFFE7000B)),
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
                onPressed: () => _navigateToVideoListPage(title, allMedia),
                child: const Text('See All'),
              ),
            ],
          ),
        ),
        
        // Use ConstrainedBox instead of SizedBox for better overflow handling
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: cardHeight,
            minHeight: isAudio ? 150 : 180, // Minimum heights
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: allMedia.length,
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

  // Widget _buildAudioCard(Map<String, dynamic> audio) {
  //   return Card(
  //     elevation: 2,
  //     color: Theme.of(context).cardTheme.color,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: InkWell(
  //       borderRadius: BorderRadius.circular(12),
  //       onTap: () => _navigateToPlayer(audio),
  //       child: Padding(
  //         padding: const EdgeInsets.all(12),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             // Audio thumbnail placeholder - smaller and centered
  //             Container(
  //               width: double.infinity,
  //               height: 60, // Reduced height
  //               decoration: BoxDecoration(
  //                 color: Colors.deepPurple.withOpacity(0.1),
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Icon(
  //                     Icons.audiotrack,
  //                     size: 30, // Smaller icon
  //                     color: Colors.deepPurple,
  //                   ),
  //                   const SizedBox(height: 4),
  //                   Text(
  //                     'AUDIO',
  //                     style: TextStyle(
  //                       color: Colors.deepPurple,
  //                       fontSize: 10, // Smaller font
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
              
  //             const SizedBox(height: 8),
              
  //             // Title with better overflow handling
  //             Expanded(
  //               child: Text(
  //                 audio['title'],
  //                 style: Theme.of(context).textTheme.titleMedium?.copyWith(
  //                   fontWeight: FontWeight.w600,
  //                   fontSize: 13, // Smaller font for better fit
  //                 ),
  //                 maxLines: 2,
  //                 overflow: TextOverflow.ellipsis,
  //               ),
  //             ),
              
  //             const SizedBox(height: 4),
              
  //             // Subtitle and duration
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Expanded(
  //                   child: Text(
  //                     audio['subtitle'],
  //                     style: Theme.of(context).textTheme.bodySmall?.copyWith(
  //                       color: Colors.grey[600],
  //                     ),
  //                     maxLines: 1,
  //                     overflow: TextOverflow.ellipsis,
  //                   ),
  //                 ),
  //                 Container(
  //                   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
  //                   decoration: BoxDecoration(
  //                     color: Colors.grey[200],
  //                     borderRadius: BorderRadius.circular(4),
  //                   ),
  //                   child: Text(
  //                     audio['duration'],
  //                     style: const TextStyle(
  //                       fontSize: 10, // Smaller font
  //                       fontWeight: FontWeight.w500,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
               // selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
               // selectedIcon: Icon(Icons.person),
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
          title: "",
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
                color: Color(0xFFE7000B),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFE7000B).withOpacity(0.4),
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
