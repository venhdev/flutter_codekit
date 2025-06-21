import 'dart:async';

/// Retries an async operation with configurable retry logic.
///
/// [operation] The function to execute and retry if it fails.
/// [maxAttempts] Maximum retry attempts (including first try). Defaults to 3.
/// [delay] Initial delay before first retry. Defaults to [Duration.zero].
/// [backoffStrategy] Calculates delay between retries. Uses exponential backoff by default.
/// [retryIf] Optional predicate to determine if an error should trigger a retry.
/// [onRetry] Optional callback before each retry attempt.
/// [timeout] Optional maximum duration for the entire retry process.
/// [onTimeout] Optional callback when the timeout is reached.
/// Returns a [Future<T>] with the operation's result or throws if all retries fail.
Future<T> retry<T>(
  Future<T> Function() operation, {
  int maxAttempts = 3,
  Duration delay = Duration.zero,
  Duration Function(int attempt)? backoffStrategy,
  bool Function(Object error)? retryIf,
  void Function(Object error, int attempt)? onRetry,
  Duration? timeout,
  FutureOr<T> Function()? onTimeout,
}) async {
  int currentAttempt = 0;
  while (currentAttempt < maxAttempts) {
    currentAttempt++;
    try {
      if (timeout != null) {
        return await operation().timeout(timeout, onTimeout: onTimeout);
      } else {
        return await operation();
      }
    } catch (e, _) {
      if (retryIf != null && !retryIf(e)) {
        // Don't retry if retryIf returns false
        rethrow;
      }

      onRetry?.call(e, currentAttempt);

      if (currentAttempt < maxAttempts) {
        final actualDelay = backoffStrategy?.call(currentAttempt) ?? delay;
        if (actualDelay > Duration.zero) {
          await Future.delayed(actualDelay);
        }
      } else {
        // Max attempts reached, rethrow the last error
        rethrow;
      }
    }
  }
  // Should theoretically not be reached if maxAttempts is handled correctly within the loop
  throw StateError('Retry loop failed unexpectedly.');
}
