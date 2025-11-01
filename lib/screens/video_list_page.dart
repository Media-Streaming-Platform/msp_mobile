import 'package:flutter/material.dart';
import 'package:msp_mobile/models/media.dart';
import 'package:msp_mobile/widgets/card.dart';

class VideoListPage extends StatefulWidget {
  final String title;
  final List<Media> videos;

  const VideoListPage({
    Key? key,
    required this.title,
    required this.videos,
  }) : super(key: key);

  @override
  State<VideoListPage> createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        
      ),
      body: _buildListView(),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(5),
      itemCount: widget.videos.length,
      itemBuilder: (context, index) {
        final video = widget.videos[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: VideoThumbnailCard(
            thumbnailUrl: video.thumbnail!,
           // duration: video['duration'],
            title: video.title,
            subtitle: video.description!,
           // avatarUrl: video['avatarUrl'],
            onTap: () {
              // Handle video tap
              print('Tapped on: ${video.title}');
            },
          ),
        );
      },
    );
  }

  
}