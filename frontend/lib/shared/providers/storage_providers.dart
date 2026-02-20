import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/storage/secure_storage_service.dart';
import '../../core/storage/local_storage_service.dart';

final secureStorageProvider = Provider<SecureStorageService>(
  (ref) => SecureStorageService(),
);

final localStorageProvider = Provider<LocalStorageService>(
  (ref) => throw UnimplementedError(
    'localStorageProvider must be overridden with the initialized instance.',
  ),
);
