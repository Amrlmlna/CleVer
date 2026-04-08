import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SwipeToConfirmButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onConfirm;
  final bool isLoading;

  const SwipeToConfirmButton({
    super.key,
    required this.child,
    required this.onConfirm,
    this.isLoading = false,
  });

  @override
  State<SwipeToConfirmButton> createState() => _SwipeToConfirmButtonState();
}

class _SwipeToConfirmButtonState extends State<SwipeToConfirmButton> {
  double _dragPosition = 0.0;
  bool _isConfirmed = false;
  bool _isDragging = false;
  final double _buttonHeight = 56.0;

  @override
  void didUpdateWidget(SwipeToConfirmButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isLoading && oldWidget.isLoading) {
      setState(() {
        _isConfirmed = false;
        _dragPosition = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.onConfirm == null || widget.isLoading;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final double maxDrag = maxWidth - _buttonHeight;

        return Opacity(
          opacity: isDisabled ? 0.6 : 1.0,
          child: Container(
            height: _buttonHeight,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(_buttonHeight / 2),
            ),
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: _isDragging
                      ? Duration.zero
                      : const Duration(milliseconds: 300),
                  width: _dragPosition + _buttonHeight,
                  height: _buttonHeight,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(_buttonHeight / 2),
                  ),
                ),

                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: widget.isLoading ? 0 : _buttonHeight * 0.8,
                      right: 16,
                    ),
                    child: widget.child,
                  ),
                ),

                if (!widget.isLoading && !_isConfirmed)
                  AnimatedPositioned(
                    duration: _isDragging
                        ? Duration.zero
                        : const Duration(milliseconds: 300),
                    curve: Curves.easeOutBack,
                    left: _dragPosition,
                    top: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onHorizontalDragStart: isDisabled
                          ? null
                          : (_) => setState(() => _isDragging = true),
                      onHorizontalDragUpdate: isDisabled
                          ? null
                          : (details) {
                              setState(() {
                                _dragPosition += details.delta.dx;
                                if (_dragPosition < 0) _dragPosition = 0;
                                if (_dragPosition > maxDrag) {
                                  _dragPosition = maxDrag;
                                }
                              });
                            },
                      onHorizontalDragEnd: isDisabled
                          ? null
                          : (details) {
                              setState(() => _isDragging = false);
                              if (_dragPosition > maxDrag * 0.8) {
                                setState(() {
                                  _dragPosition = maxDrag;
                                  _isConfirmed = true;
                                });
                                widget.onConfirm?.call();
                              } else {
                                setState(() {
                                  _dragPosition = 0;
                                });
                              }
                            },
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        width: _buttonHeight - 8,
                        height: _buttonHeight - 8,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).shadowColor.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(2, 0),
                            ),
                          ],
                        ),
                        child:
                            Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  size: 18,
                                )
                                .animate(
                                  onPlay: (controller) => controller.repeat(),
                                )
                                .moveX(begin: -2, end: 4, duration: 1.seconds)
                                .fade(begin: 0.3, end: 1.0),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
