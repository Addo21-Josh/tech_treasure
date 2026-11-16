import '../../../../core/constants/app_enums.dart';

/// Pure domain entity representing an empirical multi-device test record.
class TestRecordEntity {
  final String id;
  final String treasureId;
  final String device;
  final String osVersion;
  final String? environment;
  final TestResult result;
  final String? notes;
  final DateTime testedAt;

  const TestRecordEntity({
    required this.id,
    required this.treasureId,
    required this.device,
    required this.osVersion,
    this.environment,
    this.result = TestResult.works,
    this.notes,
    required this.testedAt,
  });

  TestRecordEntity copyWith({
    String? id,
    String? treasureId,
    String? device,
    String? osVersion,
    String? environment,
    TestResult? result,
    String? notes,
    DateTime? testedAt,
  }) {
    return TestRecordEntity(
      id: id ?? this.id,
      treasureId: treasureId ?? this.treasureId,
      device: device ?? this.device,
      osVersion: osVersion ?? this.osVersion,
      environment: environment ?? this.environment,
      result: result ?? this.result,
      notes: notes ?? this.notes,
      testedAt: testedAt ?? this.testedAt,
    );
  }
}

