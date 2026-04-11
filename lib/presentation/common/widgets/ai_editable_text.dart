import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class AIEditableText extends StatefulWidget {
  final String initialText;
  final Function(String) onSave;
  final Future<String> Function(String) onRewrite;
  final TextStyle? style;
  final int? maxLines;

  const AIEditableText({
    super.key,
    required this.initialText,
    required this.onSave,
    required this.onRewrite,
    this.style,
    this.maxLines,
  });

  @override
  State<AIEditableText> createState() => _AIEditableTextState();
}

class _AIEditableTextState extends State<AIEditableText> {
  bool _isEditing = false;
  late TextEditingController _controller;
  bool _isRewriting = false;

  @override
  void initState() {
    super.initState();
    _controller = MarkdownSyntaxController(text: widget.initialText);
  }

  @override
  void didUpdateWidget(covariant AIEditableText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialText != oldWidget.initialText && !_isEditing) {
      _controller.text = widget.initialText;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleRewrite() async {
    setState(() => _isRewriting = true);
    try {
      final newText = await widget.onRewrite(_controller.text);
      if (mounted) {
        _controller.text = newText;
      }
    } finally {
      if (mounted) {
        setState(() => _isRewriting = false);
      }
    }
  }

  void _applyFormatting(String pattern) {
    final text = _controller.text;
    final selection = _controller.selection;

    if (selection.isValid && !selection.isCollapsed) {
      final newText = text.replaceRange(
        selection.start,
        selection.end,
        '$pattern${text.substring(selection.start, selection.end)}$pattern',
      );
      _controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset: selection.end + (pattern.length * 2),
        ),
      );
    } else {
      final newText = text.replaceRange(
        selection.baseOffset,
        selection.baseOffset,
        '$pattern$pattern',
      );
      _controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset: selection.baseOffset + pattern.length,
        ),
      );
    }
  }

  void _applyHeader() {
    final text = _controller.text;
    final selection = _controller.selection;
    final newText = text.replaceRange(
      selection.baseOffset,
      selection.baseOffset,
      '# ',
    );
    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: selection.baseOffset + 2),
    );
  }

  void _save() {
    widget.onSave(_controller.text);
    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isEditing) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Toolbar
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.format_bold,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  onPressed: () => _applyFormatting('**'),
                  tooltip: AppLocalizations.of(context)!.bold,
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(8),
                ),
                IconButton(
                  icon: Icon(
                    Icons.format_italic,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  onPressed: () => _applyFormatting('_'),
                  tooltip: AppLocalizations.of(context)!.italic,
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(8),
                ),
                IconButton(
                  icon: Icon(
                    Icons.title,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  onPressed: _applyHeader,
                  tooltip: AppLocalizations.of(context)!.header,
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(8),
                ),
                const Spacer(),
                if (_isRewriting)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  TextButton.icon(
                    onPressed: _handleRewrite,
                    icon: const Icon(Icons.auto_awesome, size: 16),
                    label: Text(
                      AppLocalizations.of(context)!.rewrite,
                      style: const TextStyle(fontSize: 12),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
              ],
            ),
            const Divider(height: 1),
            const SizedBox(height: 8),

            TextField(
              controller: _controller,
              maxLines: widget.maxLines ?? 6,
              minLines: 1,
              autofocus: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintText: AppLocalizations.of(context)!.typeHere,
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              style:
                  widget.style ??
                  TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = false;
                      _controller.text = widget.initialText; // Revert
                    });
                  },
                  child: Text(
                    AppLocalizations.of(context)!.cancel,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 0,
                    ),
                    minimumSize: const Size(0, 32),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.save,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: () => setState(() => _isEditing = true),
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: MarkdownBody(
                data: widget.initialText,
                styleSheet: MarkdownStyleSheet.fromTheme(
                  Theme.of(context),
                ).copyWith(p: widget.style),
              ),
            ),
            const SizedBox(width: 8),
            Opacity(
              opacity: 0.5,
              child: Icon(
                Icons.edit,
                size: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MarkdownSyntaxController extends TextEditingController {
  MarkdownSyntaxController({super.text});

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final List<TextSpan> children = [];
    final pattern = RegExp(
      r'(\*\*.*?\*\*)|(\_.*?\_)|(^\s*#.*)',
      multiLine: true,
    );

    String currentText = text;

    if (currentText.isEmpty) {
      return TextSpan(style: style, text: "");
    }

    text.splitMapJoin(
      pattern,
      onMatch: (Match match) {
        final matchText = match[0]!;
        TextStyle? matchStyle = style;

        if (matchText.startsWith('**')) {
          matchStyle = style?.copyWith(fontWeight: FontWeight.bold);
        } else if (matchText.startsWith('_')) {
          matchStyle = style?.copyWith(fontStyle: FontStyle.italic);
        } else if (matchText.trim().startsWith('#')) {
          matchStyle = style?.copyWith(
            fontSize: (style.fontSize ?? 14) * 1.5,
            fontWeight: FontWeight.bold,
          );
        }

        children.add(TextSpan(text: matchText, style: matchStyle));
        return matchText;
      },
      onNonMatch: (String nonMatch) {
        children.add(TextSpan(text: nonMatch, style: style));
        return nonMatch;
      },
    );

    return TextSpan(style: style, children: children);
  }
}
