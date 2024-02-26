import 'package:mk_clean_architecture/core/core.dart';
import 'package:mk_kit/mk_kit.dart';

@LazySingleton()
final class SecureStorage extends KeyValueStorage with LoggerObject, DescriptionProvider {
  SecureStorage() : super(provider: SecureStorageProvider()) {
    onError = (error, stacktrace) {
      log('SecureStorage error', error: error);
    };
  }
}
