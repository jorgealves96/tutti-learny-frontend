import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ContentViewerScreen extends StatefulWidget {
  final String url;
  final String title;

  const ContentViewerScreen({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<ContentViewerScreen> createState() => _ContentViewerScreenState();
}

class _ContentViewerScreenState extends State<ContentViewerScreen> {
  YoutubePlayerController? _youtubeController;
  WebViewController? _webViewController;
  bool _isYoutubeLink = false;

  @override
  void initState() {
    super.initState();
    // Check if the URL is a YouTube link
    final String? videoId = YoutubePlayer.convertUrlToId(widget.url);

    if (videoId != null) {
      _isYoutubeLink = true;
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );
    } else {
      // If not a YouTube link, initialize the WebView controller
      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(widget.url));
    }
  }

  @override
  void dispose() {
    // Dispose of the controllers to free up resources
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      // Conditionally build the body based on the link type
      body: _isYoutubeLink
          ? Center(
              child: YoutubePlayer(
                controller: _youtubeController!,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Theme.of(context).colorScheme.secondary,
                onReady: () {
                  // Optional: You can add logic here for when the player is ready.
                },
              ),
            )
          : WebViewWidget(controller: _webViewController!),
    );
  }
}
