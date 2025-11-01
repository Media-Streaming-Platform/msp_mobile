// [file name]: home_screen.dart
// [file content begin]
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
          videos: items,
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
                onPressed: () => _navigateToVideoListPage(title, items),
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
            itemCount: items.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              return SizedBox(
                width: 280,
                child: VideoThumbnailCard(
  thumbnailUrl: video.thumbnail!,
  title: video.title,
  subtitle: video.description!,
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

  Widget _buildAudioCard(Map<String, dynamic> audio) {
    return Card(
      elevation: 2,
      color: Theme.of(context).cardTheme.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToPlayer(audio),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Audio thumbnail placeholder - smaller and centered
              Container(
                width: double.infinity,
                height: 60, // Reduced height
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.audiotrack,
                      size: 30, // Smaller icon
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'AUDIO',
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 10, // Smaller font
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Title with better overflow handling
              Expanded(
                child: Text(
                  audio['title'],
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13, // Smaller font for better fit
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              
              const SizedBox(height: 4),
              
              // Subtitle and duration
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      audio['subtitle'],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      audio['duration'],
                      style: const TextStyle(
                        fontSize: 10, // Smaller font
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 90,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main Navigation Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: NavigationBar(
              height: 60,
              selectedIndex: 0,
              onDestinationSelected: (index) {
                if (index == 1) {
                  print('Profile button tapped');
                }
              },
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
          
          // Floating Middle Button
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 35,
            top: -5,
            child: GestureDetector(
              onTap: () {
                _navigateToPlayer({
                  'title': 'Live Streaming',
                  'subtitle': 'Special content just for you',
                  'type': 'video',
                  'videoUrl': 'https://pub-e0bdd32b9eeb4a6d8a15fb9bf208a93e.r2.dev/08_28/index.m3u8',
                });
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
// [file content end]// // [file name]: home_screen.dart
// // [file content begin]
// import 'package:flutter/material.dart';
// import 'package:msp_mobile/screens/video-player-page.dart';
// import 'package:msp_mobile/screens/video_list_page.dart';
// import 'package:msp_mobile/widgets/card.dart';
// import 'package:theme_provider/theme_provider.dart';

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   int _currentTabIndex = 0; // 0 for Video, 1 for Audio

//   // Sample data for different sections - VIDEO
//   final List<Map<String, dynamic>> popularVideos = [
//     {
//       'thumbnailUrl': 'https://i.pinimg.com/1200x/67/51/ee/6751ee91b9d874d4ebf717a7c251667f.jpg',
//       'duration': '10:30',
//       'title': 'Flutter Tutorial - Building Beautiful UIs',
//       'subtitle': 'Flutter Channel',
//       'avatarUrl': 'https://example.com/avatar1.jpg',
//       'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
//       'type': 'video',
//     },
//     {
//       'thumbnailUrl': 'https://images.unsplash.com/photo-1555099962-4199c345e5dd?w=500',
//       'duration': '15:45',
//       'title': 'Dart Programming Masterclass',
//       'subtitle': 'Dart Masters',
//       'avatarUrl': 'https://example.com/avatar2.jpg',
//       'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
//       'type': 'video',
//     },
//     {
//       'thumbnailUrl': 'https://images.unsplash.com/photo-1551650975-87deedd944c3?w=500',
//       'duration': '22:10',
//       'title': 'Firebase Integration in Flutter',
//       'subtitle': 'Firebase Experts',
//       'avatarUrl': 'https://example.com/avatar3.jpg',
//       'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
//       'type': 'video',
//     },
//   ];

//   final List<Map<String, dynamic>> trendingVideos = [
//     {
//       'thumbnailUrl': 'https://images.unsplash.com/photo-1517077304055-6e89abbf09b0?w=500',
//       'duration': '12:15',
//       'title': 'Advanced Animations in Flutter',
//       'subtitle': 'Animation Pro',
//       'avatarUrl': 'https://example.com/avatar5.jpg',
//       'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
//       'type': 'video',
//     },
//     {
//       'thumbnailUrl': 'https://images.unsplash.com/photo-1547658719-da2b51169166?w=500',
//       'duration': '25:30',
//       'title': 'Building a Complete E-commerce App',
//       'subtitle': 'App Builders',
//       'avatarUrl': 'https://example.com/avatar6.jpg',
//       'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
//       'type': 'video',
//     },
//   ];

//   // Sample data for different sections - AUDIO
//   final List<Map<String, dynamic>> popularAudios = [
//     {
//       'duration': '23:45',
//       'title': 'Flutter Podcast: State Management',
//       'subtitle': 'Flutter Dev Channel',
//       'avatarUrl': 'https://example.com/avatar1.jpg',
//       'audioUrl': 'https://example.com/audio1.mp3',
//       'type': 'audio',
//     },
//     {
//       'duration': '18:30',
//       'title': 'Dart Language Deep Dive',
//       'subtitle': 'Dart Masters Podcast',
//       'avatarUrl': 'https://example.com/avatar2.jpg',
//       'audioUrl': 'https://example.com/audio2.mp3',
//       'type': 'audio',
//     },
//     {
//       'duration': '32:15',
//       'title': 'Mobile App Architecture Patterns',
//       'subtitle': 'App Architecture Podcast',
//       'avatarUrl': 'https://example.com/avatar3.jpg',
//       'audioUrl': 'https://example.com/audio3.mp3',
//       'type': 'audio',
//     },
//   ];

//   final List<Map<String, dynamic>> trendingAudios = [
//     {
//       'duration': '15:20',
//       'title': 'UI/UX Design for Developers',
//       'subtitle': 'Design Talks',
//       'avatarUrl': 'https://example.com/avatar4.jpg',
//       'audioUrl': 'https://example.com/audio4.mp3',
//       'type': 'audio',
//     },
//     {
//       'duration': '28:45',
//       'title': 'Backend Integration Best Practices',
//       'subtitle': 'Full Stack Radio',
//       'avatarUrl': 'https://example.com/avatar5.jpg',
//       'audioUrl': 'https://example.com/audio5.mp3',
//       'type': 'audio',
//     },
//   ];

//   // TODO: Replace with actual backend API calls
//   // Future<void> _fetchVideoData() async {
//   //   try {
//   //     // Example API call for videos
//   //     // final response = await http.get(Uri.parse('https://api.example.com/videos'));
//   //     // if (response.statusCode == 200) {
//   //     //   setState(() {
//   //     //     popularVideos = parseVideos(response.body);
//   //     //   });
//   //     // }
//   //   } catch (e) {
//   //     print('Error fetching video data: $e');
//   //   }
//   // }

//   // Future<void> _fetchAudioData() async {
//   //   try {
//   //     // Example API call for audios
//   //     // final response = await http.get(Uri.parse('https://api.example.com/audios'));
//   //     // if (response.statusCode == 200) {
//   //     //   setState(() {
//   //     //     popularAudios = parseAudios(response.body);
//   //     //   });
//   //     // }
//   //   } catch (e) {
//   //     print('Error fetching audio data: $e');
//   //   }
//   // }

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     // _tabController.addListener(() {
//     //   setState(() {
//     //     _currentTabIndex = _tabController.index;
//     //   });
//     // });

//     // TODO: Uncomment when backend is ready
//     // _fetchVideoData();
//     // _fetchAudioData();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   Future<void> _refreshData() async {
//     await Future.delayed(const Duration(seconds: 2));
//     setState(() {});
    
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Content updated'),
//         duration: Duration(seconds: 1),
//       ),
//     );
//   }

//   void _navigateToVideoListPage(String title, List<Map<String, dynamic>> items) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => VideoListPage(
//           title: title,
//           videos: items,
//         ),
//       ),
//     );
//   }

//   void _navigateToPlayer(Map<String, dynamic> item) {
//     if (item['type'] == 'video') {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => VideoPlayerPage(
//             title: item['title'],
//             subtitle: item['subtitle'],
//             thumbnailUrl: item['thumbnailUrl'],
//             videoUrl: item['videoUrl'] ?? 'https://pub-e0bdd32b9eeb4a6d8a15fb9bf208a93e.r2.dev/08_28/index.m3u8',
//           ),
//         ),
//       );
//     } else {
//       // TODO: Navigate to Audio Player Page
//       print('Audio tapped: ${item['title']}');
//       // Navigator.push(
//       //   context,
//       //   MaterialPageRoute(
//       //     builder: (context) => AudioPlayerPage(
//       //       title: item['title'],
//       //       subtitle: item['subtitle'],
//       //       audioUrl: item['audioUrl'],
//       //     ),
//       //   ),
//       // );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         elevation: 0,
//         backgroundColor: Theme.of(context).colorScheme.background,
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: const [
//             Tab(
//               icon: Icon(Icons.video_library),
//               text: 'Video',
//             ),
//             Tab(
//               icon: Icon(Icons.audiotrack),
//               text: 'Audio',
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.brightness_6),
//             onPressed: () {
//               ThemeProvider.controllerOf(context).nextTheme();
//             },
//           ),
//         ],
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           // Video Tab
//           RefreshIndicator(
//             onRefresh: _refreshData,
//             child: SingleChildScrollView(
//               physics: const AlwaysScrollableScrollPhysics(),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildMediaSection(
//                     title: 'Popular Videos',
//                     items: popularVideos,
//                     icon: Icons.trending_up,
//                     isAudio: false,
//                   ),
//                   _buildMediaSection(
//                     title: 'Trending Now',
//                     items: trendingVideos,
//                     icon: Icons.local_fire_department,
//                     isAudio: false,
//                   ),
//                   _buildMediaSection(
//                     title: 'Recommended For You',
//                     items: popularVideos,
//                     icon: Icons.recommend,
//                     isAudio: false,
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
          
//           // Audio Tab
//           RefreshIndicator(
//             onRefresh: _refreshData,
//             child: SingleChildScrollView(
//               physics: const AlwaysScrollableScrollPhysics(),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildMediaSection(
//                     title: 'Popular Audio',
//                     items: popularAudios,
//                     icon: Icons.trending_up,
//                     isAudio: true,
//                   ),
//                   _buildMediaSection(
//                     title: 'Trending Podcasts',
//                     items: trendingAudios,
//                     icon: Icons.local_fire_department,
//                     isAudio: true,
//                   ),
//                   _buildMediaSection(
//                     title: 'Recommended For You',
//                     items: popularAudios,
//                     icon: Icons.recommend,
//                     isAudio: true,
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: _buildBottomNavigationBar(),
//     );
//   }

//   Widget _buildMediaSection({
//     required String title,
//     required List<Map<String, dynamic>> items,
//     required IconData icon,
//     required bool isAudio,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   Icon(icon, size: 20, color: Colors.deepPurple),
//                   const SizedBox(width: 8),
//                   Text(
//                     title,
//                     style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//               TextButton(
//                 onPressed: () => _navigateToVideoListPage(title, items),
//                 child: const Text('See All'),
//               ),
//             ],
//           ),
//         ),
        
//         SizedBox(
//           height: isAudio ? 180 : 220, // Slightly smaller for audio cards
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             itemCount: items.length,
//             itemBuilder: (context, index) {
//               final item = items[index];
//               return SizedBox(
//                 width: isAudio ? 200 : 280, // Narrower for audio cards
//                 child: isAudio 
//                     ? _buildAudioCard(item)
//                     : VideoThumbnailCard(
//                         thumbnailUrl: item['thumbnailUrl'],
//                         duration: item['duration'],
//                         title: item['title'],
//                         subtitle: item['subtitle'],
//                         avatarUrl: item['avatarUrl'],
//                         onTap: () => _navigateToPlayer(item),
//                       ),
//               );
//             },
//           ),
//         ),
        
//         const SizedBox(height: 8),
//       ],
//     );
//   }

//   Widget _buildAudioCard(Map<String, dynamic> audio) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       child: Card(
//         elevation: 2,
//         color: Theme.of(context).cardTheme.color,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: InkWell(
//           borderRadius: BorderRadius.circular(12),
//           onTap: () => _navigateToPlayer(audio),
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Audio thumbnail placeholder
//                 Container(
//                   width: double.infinity,
//                   height: 80,
//                   decoration: BoxDecoration(
//                     color: Colors.deepPurple.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.audiotrack,
//                         size: 40,
//                         color: Colors.deepPurple,
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         'AUDIO',
//                         style: TextStyle(
//                           color: Colors.deepPurple,
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
                
//                 const SizedBox(height: 12),
                
//                 // Title
//                 Text(
//                   audio['title'],
//                   style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 14,
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
                
//                 const SizedBox(height: 4),
                
//                 // Subtitle and duration
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: Text(
//                         audio['subtitle'],
//                         style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                           color: Colors.grey[600],
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[200],
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: Text(
//                         audio['duration'],
//                         style: const TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBottomNavigationBar() {
//     return Container(
//       height: 90,
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           // Main Navigation Bar
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: NavigationBar(
//               height: 60,
//               selectedIndex: 0, // Home is selected by default
//               onDestinationSelected: (index) {
//                 // TODO: Implement navigation to other pages
//                 if (index == 1) {
//                   // Navigate to Profile page
//                   print('Profile button tapped');
//                 }
//               },
//               destinations: const [
//                 NavigationDestination(
//                   icon: Icon(Icons.home_outlined),
//                   selectedIcon: Icon(Icons.home),
//                   label: 'Home',
//                 ),
//                 NavigationDestination(
//                   icon: Icon(Icons.person_outline),
//                   selectedIcon: Icon(Icons.person),
//                   label: 'Profile',
//                 ),
//               ],
//             ),
//           ),
          
//           // Floating Middle Button
//           Positioned(
//             left: MediaQuery.of(context).size.width / 2 - 35,
//             top: -5,
//             child: GestureDetector(
//               onTap: () {
//                 // Navigate to live streaming or featured content
//                 _navigateToPlayer({
//                   'title': 'Live Streaming',
//                   'subtitle': 'Special content just for you',
//                   'type': 'video',
//                   'videoUrl': 'https://pub-e0bdd32b9eeb4a6d8a15fb9bf208a93e.r2.dev/08_28/index.m3u8',
//                 });
//               },
//               child: Container(
//                 width: 70,
//                 height: 70,
//                 decoration: BoxDecoration(
//                   color: Colors.deepPurple,
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.deepPurple.withOpacity(0.4),
//                       blurRadius: 12,
//                       offset: const Offset(0, 6),
//                     ),
//                   ],
//                 ),
//                 child: const Icon(
//                   Icons.wifi_tethering,
//                   color: Colors.white,
//                   size: 32,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// // [file content end]
// //
// //// import 'package:flutter/material.dart';
// // import 'package:msp_mobile/screens/video-player-page.dart';
// // import 'package:msp_mobile/screens/video_list_page.dart';
// // import 'package:msp_mobile/widgets/card.dart';
// // import 'package:theme_provider/theme_provider.dart';

// // class MyHomePage extends StatefulWidget {
// //   const MyHomePage({super.key, required this.title});

// //   final String title;

// //   @override
// //   State<MyHomePage> createState() => _MyHomePageState();
// // }

// // class _MyHomePageState extends State<MyHomePage> {
// //   // Sample data for different sections
// //   final List<Map<String, dynamic>> popularVideos = [
// //     {
// //       'thumbnailUrl': 'https://i.pinimg.com/1200x/67/51/ee/6751ee91b9d874d4ebf717a7c251667f.jpg',
// //       'duration': '10:30',
// //       'title': 'Flutter Tutorial - Building Beautiful UIs',
// //       'subtitle': 'Flutter Channel',
// //       'avatarUrl': 'https://example.com/avatar1.jpg',
// //     },
// //     {
// //       'thumbnailUrl': 'https://images.unsplash.com/photo-1555099962-4199c345e5dd?w=500',
// //       'duration': '15:45',
// //       'title': 'Dart Programming Masterclass',
// //       'subtitle': 'Dart Masters',
// //       'avatarUrl': 'https://example.com/avatar2.jpg',
// //     },
// //     {
// //       'thumbnailUrl': 'https://images.unsplash.com/photo-1551650975-87deedd944c3?w=500',
// //       'duration': '22:10',
// //       'title': 'Firebase Integration in Flutter',
// //       'subtitle': 'Firebase Experts',
// //       'avatarUrl': 'https://example.com/avatar3.jpg',
// //     },
// //   ];

// //   final List<Map<String, dynamic>> trendingVideos = [
// //     {
// //       'thumbnailUrl': 'https://images.unsplash.com/photo-1517077304055-6e89abbf09b0?w=500',
// //       'duration': '12:15',
// //       'title': 'Advanced Animations in Flutter',
// //       'subtitle': 'Animation Pro',
// //       'avatarUrl': 'https://example.com/avatar5.jpg',
// //     },
// //     {
// //       'thumbnailUrl': 'https://images.unsplash.com/photo-1547658719-da2b51169166?w=500',
// //       'duration': '25:30',
// //       'title': 'Building a Complete E-commerce App',
// //       'subtitle': 'App Builders',
// //       'avatarUrl': 'https://example.com/avatar6.jpg',
// //     },
// //   ];

// //   Future<void> _refreshData() async {
// //     await Future.delayed(const Duration(seconds: 2));
// //     setState(() {});
    
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       const SnackBar(
// //         content: Text('Content updated'),
// //         duration: Duration(seconds: 1),
// //       ),
// //     );
// //   }

// //   void _navigateToVideoListPage(String title, List<Map<String, dynamic>> videos) {
// //     Navigator.push(
// //       context,
// //       MaterialPageRoute(
// //         builder: (context) => VideoListPage(
// //           title: title,
// //           videos: videos,
// //         ),
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(widget.title),
// //         elevation: 0,
// //         backgroundColor: Theme.of(context).colorScheme.background,
// //         actions: [
// //           IconButton(
// //   icon: const Icon(Icons.brightness_6),
// //   onPressed: () {
// //     ThemeProvider.controllerOf(context).nextTheme();
// //   },
// // ),
// //           // IconButton(
// //           //   icon: const Icon(Icons.notifications_outlined),
// //           //   onPressed: () {},
// //           // ),
// //         ],
// //       ),
// //       body: RefreshIndicator(
// //         onRefresh: _refreshData,
// //         child: SingleChildScrollView(
// //           physics: const AlwaysScrollableScrollPhysics(),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
              
// //               // Video sections
// //               _buildVideoSection(
// //                 title: 'Popular Videos',
// //                 videos: popularVideos,
// //                 icon: Icons.trending_up,
// //               ),
// //               _buildVideoSection(
// //                 title: 'Trending Now',
// //                 videos: trendingVideos,
// //                 icon: Icons.local_fire_department,
// //               ),
// //               _buildVideoSection(
// //                 title: 'Recommended For You',
// //                 videos: popularVideos,
// //                 icon: Icons.recommend,
// //               ),
              
// //               const SizedBox(height: 20),
// //             ],
// //           ),
// //         ),
// //       ),
// //       bottomNavigationBar: _buildBottomNavigationBar(),
// //     );
// //   }



// //   Widget _buildVideoSection({
// //     required String title,
// //     required List<Map<String, dynamic>> videos,
// //     required IconData icon,
// //   }) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Padding(
// //           padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
// //           child: Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               Row(
// //                 children: [
// //                   Icon(icon, size: 20, color: Colors.deepPurple),
// //                   const SizedBox(width: 8),
// //                   Text(
// //                     title,
// //                     style: Theme.of(context).textTheme.titleLarge?.copyWith(
// //                       fontWeight: FontWeight.w600,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               TextButton(
// //                 onPressed: () => _navigateToVideoListPage(title, videos),
// //                 child: const Text('See All'),
// //               ),
// //             ],
// //           ),
// //         ),
        
// //         SizedBox(
// //           height: 220,
// //           child: ListView.builder(
// //             scrollDirection: Axis.horizontal,
// //             padding: const EdgeInsets.symmetric(horizontal: 8),
// //             itemCount: videos.length,
// //             itemBuilder: (context, index) {
// //               final video = videos[index];
// //               return SizedBox(
// //                 width: 280,
// //                 child: VideoThumbnailCard(
// //   thumbnailUrl: video['thumbnailUrl'],
// //   duration: video['duration'],
// //   title: video['title'],
// //   subtitle: video['subtitle'],
// //   avatarUrl: video['avatarUrl'],
// //   onTap: () {
// //     // Navigate to VideoPlayerPage when video is tapped
// //     Navigator.push(
// //       context,
// //       MaterialPageRoute(
// //         builder: (context) => VideoPlayerPage(
// //           title: video['title'],
// //           subtitle: video['subtitle'],
// //           thumbnailUrl: video['thumbnailUrl'],
// //           // Add videoUrl to your video data structure
// //           videoUrl: video['videoUrl'] ?? 'https://pub-e0bdd32b9eeb4a6d8a15fb9bf208a93e.r2.dev/08_28/index.m3u8',
// //         ),
// //       ),
// //     );
// //   },
// // ),
// //               );
// //             },
// //           ),
// //         ),
        
// //         const SizedBox(height: 8),
// //       ],
// //     );
// //   }

  
// //   Widget _buildBottomNavigationBar() {
// //   return Container(
// //     height: 90, // Increased height to give more space for floating
// //     child: Stack(
// //       clipBehavior: Clip.none, // Important: allows elements to draw outside the container
// //       children: [
// //         // Main Navigation Bar
// //         Positioned(
// //           bottom: 0,
// //           left: 0,
// //           right: 0,
// //           child: NavigationBar(
// //             height: 60,
// //             destinations: const [
// //               NavigationDestination(
// //                 icon: Icon(Icons.home_outlined),
// //                 selectedIcon: Icon(Icons.home),
// //                 label: 'Home',
// //               ),
// //               NavigationDestination(
// //                 icon: Icon(Icons.person_outline),
// //                 selectedIcon: Icon(Icons.person),
// //                 label: 'Profile',
// //               ),
// //             ],
// //           ),
// //         ),
        
// //         // Floating Middle Button - Positioned much higher
// //         Positioned(
// //           left: MediaQuery.of(context).size.width / 2 - 35, // Center horizontally
// //           top: -5, // Much higher positioning
// //           child: GestureDetector(
// //             onTap: () {
// //               // Handle the middle button tap
// //               print('Middle button tapped!');
// //               // Add your functionality here
// //             },
// //             child: Container(
// //               width: 70,
// //               height: 70,
// //               decoration: BoxDecoration(
// //                 color: Colors.deepPurple,
// //                 shape: BoxShape.circle,
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: Colors.deepPurple.withOpacity(0.4),
// //                     blurRadius: 12,
// //                     offset: const Offset(0, 6),
// //                   ),
// //                 ],
// //               ),
// //               child: const Icon(
// //                 Icons.wifi_tethering,
// //                 color: Colors.white,
// //                 size: 32,
// //               ),
// //             ),
// //           ),
// //         ),
// //       ],
// //     ),
// //   );
// // }
// // }
  