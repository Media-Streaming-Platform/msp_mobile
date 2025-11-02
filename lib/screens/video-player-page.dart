// [file name]: video_player_page.dart
// [file content begin]
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerPage extends StatefulWidget {
  final String? videoUrl;
  final String? title;
  final String? subtitle;
  final String? thumbnailUrl;

  const VideoPlayerPage({
    Key? key,
    this.videoUrl,
    this.title,
    this.subtitle,
    this.thumbnailUrl,
  }) : super(key: key);

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  bool _hasError = false;
  bool _showTitleOverlay = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      // Use provided video URL or fallback to a sample video
      final videoUrl = widget.videoUrl ?? 
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';
      
      print('Initializing video player with URL: $videoUrl');
      
      _videoPlayerController = VideoPlayerController.network(videoUrl);
      
      // Wait for initialization
      await _videoPlayerController!.initialize();
      
      print('Video initialized: ${_videoPlayerController!.value.isInitialized}');

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        // Remove playback speed options
        additionalOptions: (context) => [], // Empty list removes additional options
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.deepPurple,
          handleColor: Colors.deepPurple,
          backgroundColor: Colors.grey.shade600,
          bufferedColor: Colors.grey.shade400,
        ),
        placeholder: Container(
          color: Colors.grey[900],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_circle_filled, size: 64, color: Colors.grey[400]),
                SizedBox(height: 8),
                Text(
                  'Loading video...',
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ],
            ),
          ),
        ),
        // Error handling for Chewie
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, color: Colors.red, size: 64),
                SizedBox(height: 16),
                Text(
                  'Error loading video',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      );

      setState(() {
        _isLoading = false;
        _hasError = false;
      });
    } catch (e) {
      print('Error initializing video player: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _toggleTitleOverlay() {
    setState(() {
      _showTitleOverlay = !_showTitleOverlay;
    });
    
    // Auto hide after 3 seconds
    if (_showTitleOverlay) {
      Future.delayed(Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showTitleOverlay = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   backgroundColor: Colors.black,
      //   foregroundColor: Colors.white,
      //   elevation: 0,
      //   title: widget.title != null
      //       ? Text(
      //           widget.title!,
      //           style: const TextStyle(
      //             color: Colors.white,
      //             fontSize: 16,
      //           ),
      //           maxLines: 1,
      //           overflow: TextOverflow.ellipsis,
      //         )
      //       : const Text('Video Player'),
      // ),
      body: Stack(
        children: [
          _buildVideoContent(),
          
          // Title overlay that appears on tap
          if (widget.title != null && _chewieController != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: _toggleTitleOverlay,
                child: AnimatedOpacity(
                  opacity: _showTitleOverlay ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 300),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 8, 16, 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.black.withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Text(
                      widget.title!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVideoContent() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading video...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load video',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your connection and try again',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _hasError = false;
                });
                _initializeVideoPlayer();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: _toggleTitleOverlay,
      child: Column(
        children: [
          // Video Player
          Expanded(
            child: _chewieController != null && 
                   _videoPlayerController != null &&
                   _videoPlayerController!.value.isInitialized
                ? Chewie(
                    controller: _chewieController!,
                  )
                : Center(
                    child: Text(
                      'Video not available',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          ),
        
        ],
      ),
    );
  }
}
// [file content end]