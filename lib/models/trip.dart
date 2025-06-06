// lib/models/trip.dart

import 'package:hive/hive.dart'; // Import Hive for local database persistence

// This part directive links the Trip class to its generated Hive adapter.
// The 'trip.g.dart' file is created by running `build_runner`.
part 'trip.g.dart';

/// Represents a single travel trip in the Cassa Comune application.
///
/// This class is configured for local storage using the Hive database.
@HiveType(typeId: 0) // Unique type ID for Hive serialization.
class Trip extends HiveObject {
  /// The unique Avventure nel Mondo trip code, provided by the user.
  @HiveField(0) // Unique field ID for Hive serialization.
  String id;

  /// The human-readable name of the trip.
  @HiveField(1)
  String name;

  /// The optional start date of the trip.
  @HiveField(2)
  DateTime? startDate;

  /// The optional end date of the trip.
  @HiveField(3)
  DateTime? endDate;

  /// Creates a [Trip] instance.
  ///
  /// Uses named parameters for clarity. [id] and [name] are required.
  Trip({
    required this.id,
    required this.name,
    this.startDate,
    this.endDate,
  });
}