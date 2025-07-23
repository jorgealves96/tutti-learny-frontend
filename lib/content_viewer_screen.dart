import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(widget.url));
    }
  }

  // --- 2. Add the function to launch the URL externally ---
  Future<void> _launchUrl() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      // This mode tries to open the URL in an external app (like YouTube)
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch ${widget.url}')),
        );
      }
    }
  }

  @override
  void dispose() {
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
        // --- 3. Add the button to the AppBar's actions ---
        actions: [
          // Conditionally add the button only for YouTube videos
          if (_isYoutubeLink)
            IconButton(
              icon: const Icon(Icons.open_in_new),
              tooltip: 'Open in YouTube',
              onPressed: _launchUrl,
            ),
        ],
      ),
      body: _isYoutubeLink
          ? Center(
              child: YoutubePlayer(
                controller: _youtubeController!,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Theme.of(context).colorScheme.secondary,
                onReady: () {},
              ),
            )
          : WebViewWidget(controller: _webViewController!),
    );
  }
}