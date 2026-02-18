import 'package:drift/drift.dart';
import 'package:Self.Tube/common/data/services/database/database_service.dart';
part 'settings_dao.g.dart';

@DriftAccessor(tables: [KeyValueEntries])
class SettingsDao extends DatabaseAccessor<AppDatabase> with _$SettingsDaoMixin {
  SettingsDao(AppDatabase db) : super(db);

  Future<void> write(String key, String? value) {
    return into(keyValueEntries).insertOnConflictUpdate(
      KeyValueEntriesCompanion.insert(
        key: key,
        value: Value(value),
      ),
    );
  }

  Future<Map<String, String?>> readAll() async {
    final rows = await select(keyValueEntries).get();
    return {for (final row in rows) row.key: row.value};
  }

  Future<void> remove(String key) {
    return (delete(keyValueEntries)..where((t) => t.key.equals(key))).go();
  }
}
