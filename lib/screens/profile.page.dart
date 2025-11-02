// [file name]: profile_page.dart
// [file content begin]
import 'package:flutter/material.dart';
import 'package:msp_mobile/screens/video-player-page.dart';
import 'package:msp_mobile/widgets/card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Sample user data
  final Map<String, dynamic> _userData = {
    'name': 'John Doe',
    'email': 'john.doe@example.com',
    'joinDate': 'Joined January 2024',
    'avatarUrl': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
    'stats': {
      'videosWatched': 42,
      'watchlist': 8,
      'following': 24,
    },
  };

  // Sample watchlist data
  final List<Map<String, dynamic>> _watchlistVideos = [
    {
      'thumbnailUrl': 'https://i.pinimg.com/1200x/67/51/ee/6751ee91b9d874d4ebf717a7c251667f.jpg',
      'duration': '10:30',
      'title': 'Flutter Tutorial - Building Beautiful UIs',
      'subtitle': 'Flutter Channel',
      'avatarUrl': 'https://example.com/avatar1.jpg',
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    },
    {
      'thumbnailUrl': 'https://images.unsplash.com/photo-1555099962-4199c345e5dd?w=500',
      'duration': '15:45',
      'title': 'Dart Programming Masterclass',
      'subtitle': 'Dart Masters',
      'avatarUrl': 'https://example.com/avatar2.jpg',
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
    },
    {
      'thumbnailUrl': 'https://images.unsplash.com/photo-1551650975-87deedd944c3?w=500',
      'duration': '22:10',
      'title': 'Firebase Integration in Flutter',
      'subtitle': 'Firebase Experts',
      'avatarUrl': 'https://example.com/avatar3.jpg',
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    },
    {
      'thumbnailUrl': 'https://images.unsplash.com/photo-1517077304055-6e89abbf09b0?w=500',
      'duration': '12:15',
      'title': 'Advanced Animations in Flutter',
      'subtitle': 'Animation Pro',
      'avatarUrl': 'https://example.com/avatar5.jpg',
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
    },
  ];

  void _navigateToVideoPlayer(Map<String, dynamic> video) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerPage(
          title: video['title'],
          subtitle: video['subtitle'],
          thumbnailUrl: video['thumbnailUrl'],
          videoUrl: video['videoUrl'],
        ),
      ),
    );
  }

  void _removeFromWatchlist(int index) {
    setState(() {
      _watchlistVideos.removeAt(index);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed from watchlist'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined),
            onPressed: () {
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Simulate refresh
          await Future.delayed(Duration(seconds: 1));
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // User Info Section
              _buildUserInfoSection(),
              
              // Stats Section
              _buildStatsSection(),
              
              // Watchlist Section
              _buildWatchlistSection(),
              
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoSection() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.deepPurple,
                width: 3,
              ),
            ),
            child: ClipOval(
              child: _userData['avatarUrl'].isNotEmpty
                  ? Image.network(
                      _userData['avatarUrl'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildAvatarPlaceholder();
                      },
                    )
                  : _buildAvatarPlaceholder(),
            ),
          ),
          
          SizedBox(width: 16),
          
          // User Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userData['name'],
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  _userData['email'],
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  _userData['joinDate'],
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Edit Profile'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarPlaceholder() {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Icon(
          Icons.person,
          size: 40,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.play_circle_filled,
            value: _userData['stats']['videosWatched'].toString(),
            label: 'Videos Watched',
          ),
          _buildStatItem(
            icon: Icons.bookmark,
            value: _userData['stats']['watchlist'].toString(),
            label: 'Watchlist',
          ),
          _buildStatItem(
            icon: Icons.people,
            value: _userData['stats']['following'].toString(),
            label: 'Following',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.deepPurple.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.deepPurple,
            size: 24,
          ),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildWatchlistSection() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.bookmark, size: 20, color: Colors.deepPurple),
                  SizedBox(width: 8),
                  Text(
                    'Watchlist',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (_watchlistVideos.isNotEmpty)
                Text(
                  '${_watchlistVideos.length} items',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
          
          SizedBox(height: 16),
          
          _watchlistVideos.isEmpty ? _buildEmptyWatchlist() : _buildWatchlistGrid(),
        ],
      ),
    );
  }

  Widget _buildEmptyWatchlist() {
    return Container(
      padding: EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.bookmark_border,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'Your watchlist is empty',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Save videos to watch later by tapping the bookmark icon',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigate to home to browse videos
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            child: Text('Browse Videos'),
          ),
        ],
      ),
    );
  }

  Widget _buildWatchlistGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemCount: _watchlistVideos.length,
      itemBuilder: (context, index) {
        final video = _watchlistVideos[index];
        return _buildWatchlistItem(video, index);
      },
    );
  }

  Widget _buildWatchlistItem(Map<String, dynamic> video, int index) {
    return Stack(
      children: [
        VideoThumbnailCard(
          thumbnailUrl: video['thumbnailUrl'],
         // duration: video['duration'],
          title: video['title'],
          subtitle: video['subtitle'],
         // avatarUrl: video['avatarUrl'],
          onTap: () => _navigateToVideoPlayer(video),
        ),
        
        // Remove button
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () => _removeFromWatchlist(index),
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.bookmark_remove,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
// [file content end]