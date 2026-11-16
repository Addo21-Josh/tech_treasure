import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/backup_models.dart';

/// Service implementing JSON v1.0 backup, SHA-256 validation, atomic restoration, and CSV export.
class BackupService {
  final AppDatabase db;

  BackupService(this.db);

  /// Generates complete JSON backup conforming to v1.0 spec with SHA-256 integrity checksum.
  Future<Result<String, Failure>> generateJsonBackup() async {
    try {
      final now = DateTime.now().toUtc();

      // 1. Query all tables
      final categoriesRows = await db.select(db.categories).get();
      final tagsRows = await db.select(db.tags).get();
      final treasuresRows = await db.select(db.treasures).get();
      final treasureTagsRows = await db.select(db.treasureTags).get();
      final sourcesRows = await db.select(db.sources).get();
      final testRecordsRows = await db.select(db.testRecords).get();
      final contentsRows = await db.select(db.contents).get();
      final contentMetricsRows = await db.select(db.contentMetrics).get();

      // 2. Build canonical data payload
      final data = {
        'categories': categoriesRows
            .map(
              (c) => {
                'id': c.id,
                'name': c.name,
                'description': c.description,
                'icon': c.icon,
                'isDefault': c.isDefault,
                'createdAt': c.createdAt.millisecondsSinceEpoch,
              },
            )
            .toList(),
        'tags': tagsRows
            .map(
              (t) => {
                'id': t.id,
                'name': t.name,
                'createdAt': t.createdAt.millisecondsSinceEpoch,
              },
            )
            .toList(),
        'treasures': treasuresRows
            .map(
              (t) => {
                'id': t.id,
                'title': t.title,
                'shortDescription': t.shortDescription,
                'problem': t.problem,
                'solution': t.solution,
                'whyUseful': t.whyUseful,
                'categoryId': t.categoryId,
                'status': t.status,
                'device': t.device,
                'platform': t.platform,
                'osVersion': t.osVersion,
                'requirements': t.requirements,
                'steps': t.stepsJson != null
                    ? (jsonDecode(t.stepsJson!) as List).cast<String>()
                    : <String>[],
                'limitations': t.limitations,
                'securityNotes': t.securityNotes,
                'researchStatus': t.researchStatus,
                'isVerified': t.isVerified,
                'isFavorite': t.isFavorite,
                'noAppNeeded': t.noAppNeeded,
                'contentPotential': t.contentPotential,
                'createdAt': t.createdAt.millisecondsSinceEpoch,
                'updatedAt': t.updatedAt.millisecondsSinceEpoch,
              },
            )
            .toList(),
        'treasureTags': treasureTagsRows
            .map((tt) => {'treasureId': tt.treasureId, 'tagId': tt.tagId})
            .toList(),
        'sources': sourcesRows
            .map(
              (s) => {
                'id': s.id,
                'treasureId': s.treasureId,
                'title': s.title,
                'url': s.url,
                'sourceType': s.sourceType,
                'notes': s.notes,
                'createdAt': s.createdAt.millisecondsSinceEpoch,
              },
            )
            .toList(),
        'testRecords': testRecordsRows
            .map(
              (tr) => {
                'id': tr.id,
                'treasureId': tr.treasureId,
                'device': tr.device,
                'osVersion': tr.osVersion,
                'environment': tr.environment,
                'result': tr.result,
                'notes': tr.notes,
                'testedAt': tr.testedAt.millisecondsSinceEpoch,
              },
            )
            .toList(),
        'contents': contentsRows
            .map(
              (cnt) => {
                'id': cnt.id,
                'treasureId': cnt.treasureId,
                'contentType': cnt.contentType,
                'hook': cnt.hook,
                'problem': cnt.problem,
                'demonstration': cnt.demonstration,
                'script': cnt.script,
                'cta': cnt.cta,
                'status': cnt.status,
                'platformUrl': cnt.platformUrl,
                'publishedAt': cnt.publishedAt?.millisecondsSinceEpoch,
                'createdAt': cnt.createdAt.millisecondsSinceEpoch,
                'updatedAt': cnt.updatedAt.millisecondsSinceEpoch,
              },
            )
            .toList(),
        'contentMetrics': contentMetricsRows
            .map(
              (cm) => {
                'id': cm.id,
                'contentId': cm.contentId,
                'views': cm.views,
                'likes': cm.likes,
                'comments': cm.comments,
                'shares': cm.shares,
                'saves': cm.saves,
                'followersGained': cm.followersGained,
                'performanceNotes': cm.performanceNotes,
                'recordedAt': cm.recordedAt.millisecondsSinceEpoch,
              },
            )
            .toList(),
      };

      // 3. Compute SHA-256 Checksum on UTF-8 canonical data
      final dataJsonString = json.encode(data);
      final hashBytes = sha256.convert(utf8.encode(dataJsonString));
      final checksum = 'sha256-$hashBytes';

      // 4. Construct final envelope
      final envelope = {
        'version': '1.0.0',
        'schemaVersion': 1,
        'exportedAt': now.toIso8601String(),
        'appVersion': '1.0.0+1',
        'metadata': {
          'totalTreasures': treasuresRows.length,
          'totalCategories': categoriesRows.length,
          'totalTags': tagsRows.length,
          'totalSources': sourcesRows.length,
          'totalTestRecords': testRecordsRows.length,
          'totalContents': contentsRows.length,
          'totalMetrics': contentMetricsRows.length,
          'checksum': checksum,
        },
        'data': data,
      };

      final output = const JsonEncoder.withIndent('  ').convert(envelope);
      return Success(output);
    } catch (e, st) {
      return FailureResult(
        DatabaseFailure(
          'Failed to generate JSON backup: $e',
          cause: e,
          stackTrace: st,
        ),
      );
    }
  }

  /// Validates a backup JSON string and returns a dry-run summary. Does NOT touch database.
  Future<Result<BackupSummary, Failure>> validateBackup(
    String jsonString,
  ) async {
    try {
      final dynamic raw = json.decode(jsonString);
      if (raw is! Map<String, dynamic>) {
        return FailureResult(
          const ValidationFailure('Invalid backup: Root is not a JSON object.'),
        );
      }

      final version = raw['version'] as String? ?? '';
      if (!version.startsWith('1.')) {
        return FailureResult(
          ValidationFailure(
            'Incompatible backup version: "$version". App supports 1.x.',
          ),
        );
      }

      final schemaVersion = raw['schemaVersion'] as int? ?? 0;
      if (schemaVersion < 1) {
        return FailureResult(
          const ValidationFailure('Invalid schema version.'),
        );
      }

      final metadata = raw['metadata'] as Map<String, dynamic>?;
      final data = raw['data'] as Map<String, dynamic>?;

      if (metadata == null || data == null) {
        return FailureResult(
          const ValidationFailure('Backup missing metadata or data section.'),
        );
      }

      final expectedChecksum = metadata['checksum'] as String? ?? '';
      if (expectedChecksum.isEmpty) {
        return FailureResult(
          const ValidationFailure('Missing SHA-256 checksum in metadata.'),
        );
      }

      // Re-compute SHA-256 hash over data
      final actualDataString = json.encode(data);
      final actualHash =
          'sha256-${sha256.convert(utf8.encode(actualDataString))}';

      if (expectedChecksum != actualHash) {
        return FailureResult(
          ValidationFailure(
            'SHA-256 integrity verification failed. File may be corrupted or modified.\nExpected: $expectedChecksum\nComputed: $actualHash',
          ),
        );
      }

      final treasures = (data['treasures'] as List?) ?? [];
      final categories = (data['categories'] as List?) ?? [];
      final tags = (data['tags'] as List?) ?? [];
      final sources = (data['sources'] as List?) ?? [];
      final testRecords = (data['testRecords'] as List?) ?? [];
      final contents = (data['contents'] as List?) ?? [];
      final contentMetrics = (data['contentMetrics'] as List?) ?? [];

      final summary = BackupSummary(
        version: version,
        schemaVersion: schemaVersion,
        exportedAt:
            DateTime.tryParse(raw['exportedAt'] as String? ?? '') ??
            DateTime.now(),
        appVersion: raw['appVersion'] as String? ?? '',
        totalTreasures: treasures.length,
        totalCategories: categories.length,
        totalTags: tags.length,
        totalSources: sources.length,
        totalTestRecords: testRecords.length,
        totalContents: contents.length,
        totalMetrics: contentMetrics.length,
        checksum: expectedChecksum,
        isValid: true,
      );

      return Success(summary);
    } catch (e, st) {
      return FailureResult(
        ValidationFailure(
          'Failed to parse or validate backup: $e',
          cause: e,
          stackTrace: st,
        ),
      );
    }
  }

  /// Restores complete database from a backup JSON string in an atomic transaction.
  Future<Result<void, Failure>> restoreBackup(String jsonString) async {
    final validation = await validateBackup(jsonString);
    if (validation.isFailure) {
      return FailureResult(validation.failureOrNull!);
    }

    try {
      final parsed = json.decode(jsonString) as Map<String, dynamic>;
      final data = parsed['data'] as Map<String, dynamic>;

      await db.transaction(() async {
        // 1. Wipe existing tables in reverse dependency order
        await db.delete(db.contentMetrics).go();
        await db.delete(db.contents).go();
        await db.delete(db.testRecords).go();
        await db.delete(db.sources).go();
        await db.delete(db.treasureTags).go();
        await db.delete(db.treasures).go();
        await db.delete(db.tags).go();
        await db.delete(db.categories).go();

        // 2. Insert Categories
        final categories = (data['categories'] as List?) ?? [];
        for (final item in categories) {
          final m = item as Map<String, dynamic>;
          await db
              .into(db.categories)
              .insert(
                CategoriesCompanion.insert(
                  id: m['id'] as String,
                  name: m['name'] as String,
                  description: Value(m['description'] as String?),
                  icon: m['icon'] as String,
                  isDefault: Value(m['isDefault'] as bool? ?? false),
                  createdAt: DateTime.fromMillisecondsSinceEpoch(
                    m['createdAt'] as int,
                  ),
                ),
              );
        }

        // 3. Insert Tags
        final tags = (data['tags'] as List?) ?? [];
        for (final item in tags) {
          final m = item as Map<String, dynamic>;
          await db
              .into(db.tags)
              .insert(
                TagsCompanion.insert(
                  id: m['id'] as String,
                  name: m['name'] as String,
                  createdAt: DateTime.fromMillisecondsSinceEpoch(
                    m['createdAt'] as int,
                  ),
                ),
              );
        }

        // 4. Insert Treasures
        final treasures = (data['treasures'] as List?) ?? [];
        for (final item in treasures) {
          final m = item as Map<String, dynamic>;
          final stepsRaw = m['steps'];
          final String? stepsJsonStr = stepsRaw is List
              ? jsonEncode(stepsRaw)
              : (stepsRaw is String ? stepsRaw : null);

          await db
              .into(db.treasures)
              .insert(
                TreasuresCompanion.insert(
                  id: m['id'] as String,
                  title: m['title'] as String,
                  shortDescription: m['shortDescription'] as String,
                  problem: Value(m['problem'] as String?),
                  solution: Value(m['solution'] as String?),
                  whyUseful: Value(m['whyUseful'] as String?),
                  categoryId: m['categoryId'] as String,
                  status: Value(m['status'] as String? ?? 'idea'),
                  device: Value(m['device'] as String?),
                  platform: Value(m['platform'] as String?),
                  osVersion: Value(m['osVersion'] as String?),
                  requirements: Value(m['requirements'] as String?),
                  stepsJson: Value(stepsJsonStr),
                  limitations: Value(m['limitations'] as String?),
                  securityNotes: Value(m['securityNotes'] as String?),
                  researchStatus: Value(
                    m['researchStatus'] as String? ?? 'notResearched',
                  ),
                  isVerified: Value(m['isVerified'] as bool? ?? false),
                  isFavorite: Value(m['isFavorite'] as bool? ?? false),
                  noAppNeeded: Value(m['noAppNeeded'] as bool? ?? false),
                  contentPotential: Value(m['contentPotential'] as int? ?? 3),
                  createdAt: DateTime.fromMillisecondsSinceEpoch(
                    m['createdAt'] as int,
                  ),
                  updatedAt: DateTime.fromMillisecondsSinceEpoch(
                    m['updatedAt'] as int,
                  ),
                ),
              );
        }

        // 5. Insert TreasureTags
        final treasureTags = (data['treasureTags'] as List?) ?? [];
        for (final item in treasureTags) {
          final m = item as Map<String, dynamic>;
          await db
              .into(db.treasureTags)
              .insert(
                TreasureTagsCompanion.insert(
                  treasureId: m['treasureId'] as String,
                  tagId: m['tagId'] as String,
                ),
              );
        }

        // 6. Insert Sources
        final sources = (data['sources'] as List?) ?? [];
        for (final item in sources) {
          final m = item as Map<String, dynamic>;
          await db
              .into(db.sources)
              .insert(
                SourcesCompanion.insert(
                  id: m['id'] as String,
                  treasureId: m['treasureId'] as String,
                  title: m['title'] as String,
                  url: Value(m['url'] as String?),
                  sourceType: m['sourceType'] as String,
                  notes: Value(m['notes'] as String?),
                  createdAt: DateTime.fromMillisecondsSinceEpoch(
                    m['createdAt'] as int,
                  ),
                ),
              );
        }

        // 7. Insert TestRecords
        final testRecords = (data['testRecords'] as List?) ?? [];
        for (final item in testRecords) {
          final m = item as Map<String, dynamic>;
          await db
              .into(db.testRecords)
              .insert(
                TestRecordsCompanion.insert(
                  id: m['id'] as String,
                  treasureId: m['treasureId'] as String,
                  device: m['device'] as String,
                  osVersion: m['osVersion'] as String,
                  environment: Value(m['environment'] as String?),
                  result: m['result'] as String,
                  notes: Value(m['notes'] as String?),
                  testedAt: DateTime.fromMillisecondsSinceEpoch(
                    m['testedAt'] as int,
                  ),
                ),
              );
        }

        // 8. Insert Contents
        final contents = (data['contents'] as List?) ?? [];
        for (final item in contents) {
          final m = item as Map<String, dynamic>;
          final pubMs = m['publishedAt'] as int?;
          await db
              .into(db.contents)
              .insert(
                ContentsCompanion.insert(
                  id: m['id'] as String,
                  treasureId: m['treasureId'] as String,
                  contentType: m['contentType'] as String,
                  hook: Value(m['hook'] as String?),
                  problem: Value(m['problem'] as String?),
                  demonstration: Value(m['demonstration'] as String?),
                  script: Value(m['script'] as String?),
                  cta: Value(m['cta'] as String?),
                  status: Value(m['status'] as String? ?? 'idea'),
                  platformUrl: Value(m['platformUrl'] as String?),
                  publishedAt: Value(
                    pubMs != null
                        ? DateTime.fromMillisecondsSinceEpoch(pubMs)
                        : null,
                  ),
                  createdAt: DateTime.fromMillisecondsSinceEpoch(
                    m['createdAt'] as int,
                  ),
                  updatedAt: DateTime.fromMillisecondsSinceEpoch(
                    m['updatedAt'] as int,
                  ),
                ),
              );
        }

        // 9. Insert ContentMetrics
        final contentMetrics = (data['contentMetrics'] as List?) ?? [];
        for (final item in contentMetrics) {
          final m = item as Map<String, dynamic>;
          await db
              .into(db.contentMetrics)
              .insert(
                ContentMetricsCompanion.insert(
                  id: m['id'] as String,
                  contentId: m['contentId'] as String,
                  views: Value(m['views'] as int? ?? 0),
                  likes: Value(m['likes'] as int? ?? 0),
                  comments: Value(m['comments'] as int? ?? 0),
                  shares: Value(m['shares'] as int? ?? 0),
                  saves: Value(m['saves'] as int? ?? 0),
                  followersGained: Value(m['followersGained'] as int? ?? 0),
                  performanceNotes: Value(m['performanceNotes'] as String?),
                  recordedAt: DateTime.fromMillisecondsSinceEpoch(
                    m['recordedAt'] as int,
                  ),
                ),
              );
        }
      });

      return const Success(null);
    } catch (e, st) {
      return FailureResult(
        DatabaseFailure(
          'Atomic database restoration failed: $e',
          cause: e,
          stackTrace: st,
        ),
      );
    }
  }

  /// Exports all treasures as an RFC 4180 compliant CSV string for external spreadsheets.
  Future<Result<String, Failure>> generateCsvExport() async {
    try {
      final treasures = await db.select(db.treasures).get();
      final categories = await db.select(db.categories).get();
      final categoryMap = {for (final c in categories) c.id: c.name};

      final sources = await db.select(db.sources).get();
      final sourcesCountMap = <String, int>{};
      for (final s in sources) {
        sourcesCountMap[s.treasureId] =
            (sourcesCountMap[s.treasureId] ?? 0) + 1;
      }

      final tests = await db.select(db.testRecords).get();
      final testsCountMap = <String, int>{};
      for (final t in tests) {
        testsCountMap[t.treasureId] = (testsCountMap[t.treasureId] ?? 0) + 1;
      }

      final contents = await db.select(db.contents).get();
      final contentMap = {for (final c in contents) c.treasureId: c};

      final metrics = await db.select(db.contentMetrics).get();
      final metricsViewsMap = <String, int>{};
      final metricsSavesMap = <String, int>{};
      for (final m in metrics) {
        metricsViewsMap[m.contentId] =
            (metricsViewsMap[m.contentId] ?? 0) + m.views;
        metricsSavesMap[m.contentId] =
            (metricsSavesMap[m.contentId] ?? 0) + m.saves;
      }

      final buffer = StringBuffer();
      // RFC 4180 CSV Header
      buffer.writeln(
        'id,title,category,status,is_verified,is_favorite,no_app_needed,content_potential,device,platform,os_version,sources_count,tests_count,has_content,published_date,total_views,total_saves,created_at,updated_at',
      );

      for (final t in treasures) {
        final catName = categoryMap[t.categoryId] ?? 'Uncategorized';
        final sourcesCount = sourcesCountMap[t.id] ?? 0;
        final testsCount = testsCountMap[t.id] ?? 0;
        final content = contentMap[t.id];
        final hasContent = content != null;
        final publishedDate = content?.publishedAt?.toIso8601String() ?? '';
        final totalViews = content != null
            ? (metricsViewsMap[content.id] ?? 0)
            : 0;
        final totalSaves = content != null
            ? (metricsSavesMap[content.id] ?? 0)
            : 0;

        final row = [
          _escapeCsv(t.id),
          _escapeCsv(t.title),
          _escapeCsv(catName),
          _escapeCsv(t.status),
          t.isVerified ? 'Yes' : 'No',
          t.isFavorite ? 'Yes' : 'No',
          t.noAppNeeded ? 'Yes' : 'No',
          t.contentPotential.toString(),
          _escapeCsv(t.device ?? ''),
          _escapeCsv(t.platform ?? ''),
          _escapeCsv(t.osVersion ?? ''),
          sourcesCount.toString(),
          testsCount.toString(),
          hasContent ? 'Yes' : 'No',
          _escapeCsv(publishedDate),
          totalViews.toString(),
          totalSaves.toString(),
          _escapeCsv(t.createdAt.toIso8601String()),
          _escapeCsv(t.updatedAt.toIso8601String()),
        ];

        buffer.writeln(row.join(','));
      }

      return Success(buffer.toString());
    } catch (e, st) {
      return FailureResult(
        DatabaseFailure(
          'Failed to generate CSV export: $e',
          cause: e,
          stackTrace: st,
        ),
      );
    }
  }

  String _escapeCsv(String val) {
    if (val.contains(',') ||
        val.contains('"') ||
        val.contains('\n') ||
        val.contains('\r')) {
      final escaped = val.replaceAll('"', '""');
      return '"$escaped"';
    }
    return val;
  }
}
