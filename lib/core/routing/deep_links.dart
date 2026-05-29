import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DeepLinkHandler {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _subscription;

  void initialize(GlobalKey<NavigatorState> navigatorKey) {
    _subscription = _appLinks.uriLinkStream.listen((uri) {
      _handleUri(uri, navigatorKey);
    });
  }

  void dispose() {
    _subscription?.cancel();
  }

  void _handleUri(Uri uri, GlobalKey<NavigatorState> navigatorKey) {
    final segments = uri.pathSegments;
    if (segments.isEmpty) return;

    final context = navigatorKey.currentContext;
    if (context == null) return;

    if (segments.length > 1 && segments[segments.length - 2] == 'movie') {
      final id = int.tryParse(segments.last);
      if (id != null) {
        context.push('/movie/$id');
        return;
      }
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open: ${uri.toString()}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
