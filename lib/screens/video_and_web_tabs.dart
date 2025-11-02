import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'video-player-page.dart';

class VideoAndWebTabsPage extends StatefulWidget {
  final String? videoUrl;
  final String? webUrl;
  final String? title;

  const VideoAndWebTabsPage({
    Key? key,
    this.videoUrl,
    this.webUrl,
    this.title,
  }) : super(key: key);

  @override
  State<VideoAndWebTabsPage> createState() => _VideoAndWebTabsPageState();
}

class _VideoAndWebTabsPageState extends State<VideoAndWebTabsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.webUrl ??
          'https://flutter.dev')); // default site if none given
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(widget.title ?? 'Live Stream'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.deepPurple,
          tabs: const [
            Tab(icon: Icon(Icons.videocam), text: 'Live Stream'),
            Tab(icon: Icon(Icons.web), text: 'Live Cam'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // --- Tab 1: Your existing video player ---
          VideoPlayerPage(videoUrl: widget.videoUrl),

          // --- Tab 2: WebView ---
          WebViewWidget(controller: _webViewController),
        ],
      ),
    );
  }
}
