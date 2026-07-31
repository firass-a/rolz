/// Ensures [MockData.init] has run exactly once before any provider reads
/// from the mock dataset. [MockData.init] is itself idempotent, so every
/// notifier's `build()` calling it again is harmless — but watching/reading
/// this provider once near the app root makes the bootstrap step explicit
/// and lets a splash screen gate navigation on it if desired.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../mock/mock_data.dart';

final appBootstrapProvider = Provider<bool>((ref) {
  MockData.init();
  return true;
});
