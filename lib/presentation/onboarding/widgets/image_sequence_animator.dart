
import 'package:flutter/material.dart';

class ImageSequenceAnimator extends StatefulWidget {
  final String folderPath;
  final String fileNamePrefix;
  final String fileExtension;
  final int startFrame;
  final int frameCount;
  final int fps;
  final int? explicitFrame;

  const ImageSequenceAnimator({
    super.key,
    required this.folderPath,
    required this.fileNamePrefix,
    this.fileExtension = 'jpg',
    required this.startFrame,
    required this.frameCount,
    this.fps = 24,
    this.explicitFrame,
  });

  @override
  State<ImageSequenceAnimator> createState() => _ImageSequenceAnimatorState();
}

class _ImageSequenceAnimatorState extends State<ImageSequenceAnimator>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  int _internalFrame = 0;

  @override
  void initState() {
    super.initState();
    _internalFrame = widget.startFrame;

    if (widget.explicitFrame == null) {
      _setupInternalAnimation();
    }
  }
  
  void _setupInternalAnimation() {
      _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: (widget.frameCount * 1000 / widget.fps).round()),
      );

      _animation = Tween<double>(
        begin: widget.startFrame.toDouble(), 
        end: (widget.startFrame + widget.frameCount - 1).toDouble()
      ).animate(_controller!)
        ..addListener(() {
          final newFrame = _animation!.value.floor();
          if (newFrame != _internalFrame) {
            setState(() {
              _internalFrame = newFrame;
            });
          }
        });

      _controller!.repeat();
  }

  @override
  void didUpdateWidget(covariant ImageSequenceAnimator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.explicitFrame != null) {
       _controller?.dispose();
       _controller = null;
    } else if (widget.explicitFrame == null && _controller == null) {
       _setupInternalAnimation();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    for (int i = 0; i < widget.frameCount; i++) {
       final frameIndex = widget.startFrame + i;
       final assetName = _getAssetPath(frameIndex);
       final key = AssetImage(assetName);
       key.evict();
    }
    super.dispose();
  }

  String _getAssetPath(int frameIndex) {
    final frameStr = frameIndex.toString().padLeft(3, '0');
    return '${widget.folderPath}/${widget.fileNamePrefix}$frameStr.${widget.fileExtension}';
  }

  @override
  Widget build(BuildContext context) {
    final frameToRender = widget.explicitFrame ?? _internalFrame;
    final clampedFrame = frameToRender.clamp(
      widget.startFrame, 
      widget.startFrame + widget.frameCount - 1
    );

    return Image.asset(
      _getAssetPath(clampedFrame),
      gaplessPlayback: true,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return const SizedBox(); 
      },
    );
  }
}
