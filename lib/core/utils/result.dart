import '../errors/failures.dart';

/// Functional result type representing either a successful [T] or a failure [E].
sealed class Result<T, E extends Failure> {
  const Result();

  /// Returns `true` if this is a [Success].
  bool get isSuccess => this is Success<T, E>;

  /// Returns `true` if this is a [FailureResult].
  bool get isFailure => this is FailureResult<T, E>;

  /// Extracts the success value if present, otherwise returns `null`.
  T? get valueOrNull => switch (this) {
    Success(data: final v) => v,
    FailureResult() => null,
  };

  /// Extracts the failure error if present, otherwise returns `null`.
  E? get failureOrNull => switch (this) {
    Success() => null,
    FailureResult(failure: final f) => f,
  };

  /// Maps success data or failure to a single output value [R].
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(E failure) onFailure,
  }) => switch (this) {
    Success(data: final v) => onSuccess(v),
    FailureResult(failure: final f) => onFailure(f),
  };

  /// Transforms the successful data value using [mapper].
  Result<R, E> map<R>(R Function(T data) mapper) => switch (this) {
    Success(data: final v) => Success(mapper(v)),
    FailureResult(failure: final f) => FailureResult(f),
  };
}

/// Represents a successful operation delivering [data].
final class Success<T, E extends Failure> extends Result<T, E> {
  final T data;
  const Success(this.data);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T, E> &&
          runtimeType == other.runtimeType &&
          data == other.data;

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'Success($data)';
}

/// Represents a failed operation holding [failure].
final class FailureResult<T, E extends Failure> extends Result<T, E> {
  final E failure;
  const FailureResult(this.failure);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FailureResult<T, E> &&
          runtimeType == other.runtimeType &&
          failure == other.failure;

  @override
  int get hashCode => failure.hashCode;

  @override
  String toString() => 'FailureResult($failure)';
}
