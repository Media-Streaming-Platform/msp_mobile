// [file name]: audio_player_page.dart
// [file content begin]
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class AudioPlayerPage extends StatefulWidget {
  final String? audioUrl;
  final String? title;
  final String? subtitle;
  final String? description;
  final String? thumbnailUrl;

  const AudioPlayerPage({
    Key? key,
    this.audioUrl,
    this.title,
    this.subtitle,
    this.description,
    this.thumbnailUrl,
  }) : super(key: key);

  @override
  State<AudioPlayerPage> createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  VideoPlayerController? _audioPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  bool _hasError = false;
  double _playbackRate = 1.0;

  @override
  void initState() {
    super.initState();
    _initializeAudioPlayer();
  }

  Future<void> _initializeAudioPlayer() async {
    try {
      // Use provided audio URL or fallback to a sample audio stream
      final audioUrl = widget.audioUrl ?? 
          'https://pub-e0bdd32b9eeb4a6d8a15fb9bf208a93e.r2.dev/08_28/index.m3u8';
      
      print('Initializing audio player with URL: $audioUrl');
      
      _audioPlayerController = VideoPlayerController.network(audioUrl);
      
      // Wait for initialization
      await _audioPlayerController!.initialize();
      
      print('Audio initialized: ${_audioPlayerController!.value.isInitialized}');

      _chewieController = ChewieController(
        videoPlayerController: _audioPlayerController!,
        autoPlay: true,
        looping: false,
        allowFullScreen: false, // No fullscreen for audio
        allowMuting: true,
        showControls: true,
        // Hide playback speed options since we'll handle it separately
        additionalOptions: (context) => [],
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.deepPurple,
          handleColor: Colors.deepPurple,
          backgroundColor: Colors.grey.shade600,
          bufferedColor: Colors.grey.shade400,
        ),
        // Custom placeholder for audio
        placeholder: _buildAudioPlaceholder(),
        // Custom overlay for audio
        overlay: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.audiotrack,
                size: 80,
                color: Colors.white.withOpacity(0.8),
              ),
              const SizedBox(height: 16),
              if (widget.title != null)
                Text(
                  widget.title!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
        // Error handling
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, color: Colors.red, size: 64),
                SizedBox(height: 16),
                Text(
                  'Error loading audio',
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
      print('Error initializing audio player: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Widget _buildAudioPlaceholder() {
    return Container(
      color: Colors.deepPurple.withOpacity(0.1),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.audiotrack,
              size: 100,
              color: Colors.deepPurple.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Audio Stream',
              style: TextStyle(
                color: Colors.deepPurple.withOpacity(0.7),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (widget.title != null)
              Text(
                widget.title!,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }

  void _changePlaybackRate(double rate) {
    setState(() {
      _playbackRate = rate;
    });
    _audioPlayerController?.setPlaybackSpeed(rate);
  }

  @override
  void dispose() {
    _audioPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: widget.title != null
            ? Text(
                widget.title!,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : const Text('Audio Player'),
      ),
      body: _buildAudioContent(),
    );
  }

  Widget _buildAudioContent() {
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
              'Loading audio...',
              style: TextStyle(
                color: Colors.grey[600],
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
              'Failed to load audio',
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your connection and try again',
              style: TextStyle(
                color: Colors.grey[600],
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
                _initializeAudioPlayer();
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

    return Column(
      children: [
        // Audio Player Section (Top Half)
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.deepPurple.withOpacity(0.05),
            child: Column(
              children: [
                // Audio Visualizer/Placeholder
                Expanded(
                  flex: 2,
                  child: _chewieController != null && 
                         _audioPlayerController != null &&
                         _audioPlayerController!.value.isInitialized
                      ? Chewie(
                          controller: _chewieController!,
                        )
                      : _buildAudioPlaceholder(),
                ),
                
                // Custom Audio Controls
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Playback Speed Controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Speed:',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildSpeedButton(0.5, '0.5x'),
                          _buildSpeedButton(0.75, '0.75x'),
                          _buildSpeedButton(1.0, '1.0x'),
                          _buildSpeedButton(1.25, '1.25x'),
                          _buildSpeedButton(1.5, '1.5x'),
                          _buildSpeedButton(2.0, '2.0x'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Current Playback Rate
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Current speed: ${_playbackRate}x',
                          style: const TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Description Section (Bottom Half)
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.title != null)
                  Text(
                    widget.title!,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                
                if (widget.subtitle != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    widget.subtitle!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                
                const SizedBox(height: 20),
                
                // Description Title
                Text(
                  'About this audio',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Description Content
                Text(
                  widget.description ?? 
                  'This audio content is streamed using HLS (HTTP Live Streaming) format with AAC audio codec. The .m3u8 playlist contains segments of .aac files that provide efficient streaming and adaptive bitrate support for optimal playback quality.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                    height: 1.6,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Audio Info
                _buildInfoItem('Format', 'HLS/AAC'),
                _buildInfoItem('Stream Type', 'Adaptive Bitrate'),
                _buildInfoItem('Quality', 'High Quality Audio'),
                
                const SizedBox(height: 20),
                
                // Action Buttons
               
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpeedButton(double rate, String label) {
    final isSelected = _playbackRate == rate;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: () => _changePlaybackRate(rate),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.deepPurple : Colors.grey[200],
          foregroundColor: isSelected ? Colors.white : Colors.grey[700],
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          minimumSize: Size.zero,
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

}
// [file content end]