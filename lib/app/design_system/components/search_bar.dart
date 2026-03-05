import 'dart:async';

import 'package:flutter/material.dart';

/// A search input field with debouncing support
class AppSearchBar extends StatefulWidget {
  const AppSearchBar({
    super.key,
    this.hint = 'Search products...',
    this.onChanged,
    this.debounceDuration = const Duration(milliseconds: 400),
    this.controller,
    this.focusNode,
  });

  final String hint;
  final ValueChanged<String>? onChanged;
  final Duration debounceDuration;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  @override
  State<AppSearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<AppSearchBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(widget.debounceDuration, () {
      if (mounted) widget.onChanged?.call(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return TextField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: Icon(Icons.search_rounded, color: Theme.of(context).hintColor),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: () {
                      _debounce?.cancel();
                      _controller.clear();
                      widget.onChanged?.call('');
                    },
                  )
                : null,
          ),
          onChanged: _onTextChanged,
        );
      },
    );
  }
}
