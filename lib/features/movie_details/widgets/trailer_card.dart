import 'package:flutter/material.dart';
import 'package:task/features/movie_details/data/helpers/video_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrailerCard extends StatefulWidget {
  final VideoModel video;

  const TrailerCard({super.key, required this.video});

  @override
  State<TrailerCard> createState() => TrailerCardState();
}

class TrailerCardState extends State<TrailerCard> {
  YoutubePlayerController? _controller;
  bool _isPlaying = false;

  void _startPlayback() {
    // youtube_player_flutter can only play YouTube videos — TMDB
    // occasionally only has a non-YouTube video as a last-resort fallback
    // (see MovieDetailsModel.trailer), so guard against that case rather
    // than handing the controller a key that isn't actually a YouTube id.
    if (!widget.video.isYoutube) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("This trailer isn't available for in-app playback"),
        ),
      );
      return;
    }

    setState(() {
      _controller = YoutubePlayerController.fromVideoId(
        videoId: widget.video.key,
        autoPlay: true,
        params: const YoutubePlayerParams(
          showFullscreenButton: true,
          mute: false,
        ),
      );
      _isPlaying = true;
    });
  }

  @override
  void dispose() {
    // v10 renamed dispose() -> close()
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Lazy-loaded: the controller (and its underlying WebView player) is
    // only created once the user actually taps play, rather than eagerly
    // for every movie details screen that happens to have a trailer.
    if (_isPlaying && _controller != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: YoutubePlayer(
          controller: _controller!,
          aspectRatio: 16 / 9,
          // Fullscreen-on-rotate and the controls overlay are both
          // built into the widget now — no YoutubePlayerBuilder needed.
          autoFullScreen: true,
        ),
      );
    }

    return GestureDetector(
      onTap: _startPlayback,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                widget.video.thumbnailUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    Container(color: const Color(0xFF1A1A1A)),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.25),
                ),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              Positioned(
                left: 12,
                bottom: 10,
                right: 12,
                child: Text(
                  widget.video.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    shadows: [Shadow(blurRadius: 6, color: Colors.black)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}