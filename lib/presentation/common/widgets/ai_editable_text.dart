import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

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
        selection: TextSelection.collapsed(offset: selection.end + (pattern.length * 2)),
      );
    } else {
       final newText = text.replaceRange(
        selection.baseOffset,
        selection.baseOffset,
        '$pattern$pattern',
      );
      _controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: selection.baseOffset + pattern.length),
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
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          border: Border.all(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          children: [
            // Toolbar
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.format_bold, size: 20, color: isDark ? Colors.white70 : Colors.black87),
                  onPressed: () => _applyFormatting('**'),
                  tooltip: 'Bold',
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(8),
                ),
                IconButton(
                  icon: Icon(Icons.format_italic, size: 20, color: isDark ? Colors.white70 : Colors.black87),
                  onPressed: () => _applyFormatting('_'),
                  tooltip: 'Italic',
                   constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(8),
                ),
                IconButton(
                  icon: Icon(Icons.title, size: 20, color: isDark ? Colors.white70 : Colors.black87),
                  onPressed: _applyHeader,
                  tooltip: 'Header',
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
                    label: const Text('Rewrite', style: TextStyle(fontSize: 12)),
                    style: TextButton.styleFrom(foregroundColor: Colors.purple),
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
                hintText: 'Type here...',
                hintStyle: TextStyle(color: isDark ? Colors.grey[600] : Colors.grey[400]),
              ),
              style: widget.style ?? TextStyle(color: isDark ? Colors.white : Colors.black),
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
                  child: const Text('Cancel', style: TextStyle(fontSize: 12)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    minimumSize: const Size(0, 32),
                  ),
                  child: const Text('Save', style: TextStyle(fontSize: 12)),
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
                styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                   p: widget.style,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Opacity(
              opacity: 0.5,
              child: Icon(Icons.edit, size: 14, color: Colors.grey),
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
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    final List<TextSpan> children = [];
    final pattern = RegExp(r'(\*\*.*?\*\*)|(\_.*?\_)|(^\s*#.*)', multiLine: true);
    
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
           matchStyle = style?.copyWith(fontSize: (style.fontSize ?? 14) * 1.5, fontWeight: FontWeight.bold);
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
