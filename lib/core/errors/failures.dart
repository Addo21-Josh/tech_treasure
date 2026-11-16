/// Core domain failure hierarchy for functional error handling.
abstract class Failure {
  final String message;
  final Object? cause;
  final StackTrace? stackTrace;

  const Failure(this.message, {this.cause, this.stackTrace});

  @override
  String toString() => '$runtimeType: $message';
}

/// Failure related to local SQLite / Drift database operations.
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, {super.cause, super.stackTrace});
}

/// Failure occurring when user input fails domain validation rules.
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.cause, super.stackTrace});
}

/// Failure occurring when a requested record (e.g. Treasure, Category) does not exist.
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message, {super.cause, super.stackTrace});
}

/// Failure when parsing or restoring an invalid/corrupt JSON backup.
class BackupCorruptFailure extends Failure {
  const BackupCorruptFailure(super.message, {super.cause, super.stackTrace});
}

/// Fallback for unexpected runtime exceptions.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message, {super.cause, super.stackTrace});
}

