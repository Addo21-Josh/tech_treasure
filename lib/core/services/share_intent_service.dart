import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

/// Handler for system share sheet intents (URLs & text from Chrome, YouTube, X, Reddit).
class ShareIntentService {
  StreamSubscription<List<SharedMediaFile>>? _intentSub;
  final ValueNotifier<String?> sharedTextNotifier = ValueNotifier<String?>(
    null,
  );

  /// Initializes listeners for both background resumption and cold startup intents.
  void initialize({required Function(String text) onTextReceived}) {
    // Only execute on mobile platforms supporting share intents
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
      return;
    }

    try {
      // 1. Listen to incoming intents while the app is in memory
      _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen(
        (List<SharedMediaFile> value) {
          if (value.isNotEmpty) {
            final text = value.first.path;
            if (text.isNotEmpty) {
              sharedTextNotifier.value = text;
              onTextReceived(text);
              ReceiveSharingIntent.instance.reset();
            }
          }
        },
        onError: (err) {
          debugPrint('ReceiveSharingIntent stream error: $err');
        },
      );

      // 2. Query initial intent if app was closed and opened via Share Sheet
      ReceiveSharingIntent.instance
          .getInitialMedia()
          .then((List<SharedMediaFile> value) {
            if (value.isNotEmpty) {
              final text = value.first.path;
              if (text.isNotEmpty) {
                sharedTextNotifier.value = text;
                onTextReceived(text);
                ReceiveSharingIntent.instance.reset();
              }
            }
          })
          .catchError((err) {
            debugPrint('ReceiveSharingIntent getInitialMedia error: $err');
          });
    } catch (e) {
      debugPrint('ShareIntentService initialization skipped: $e');
    }
  }

  void dispose() {
    _intentSub?.cancel();
    sharedTextNotifier.dispose();
  }
}
