// lib/providers/trip_provider.dart

import 'package:flutter/foundation.dart'; // For ChangeNotifier
import 'package:hive_flutter/hive_flutter.dart'; // For Hive database integration
import 'package:app_cassa_comune/models/trip.dart'; // Trip data model

/// Manages the collection of [Trip] objects and their persistence using Hive.
///
/// Notifies listeners (UI widgets) on data changes.
class TripProvider with ChangeNotifier {
  late Box<Trip> _tripsBox; // Hive box for Trip objects.
  List<Trip> _trips = []; // In-memory list of trips.

  /// Provides read-only access to the current list of trips.
  List<Trip> get trips => _trips;

  /// Initializes the provider by setting up Hive and loading existing trips.
  TripProvider() {
    _initHive();
  }

  /// Registers the [TripAdapter] and opens the Hive box.
  Future<void> _initHive() async {
    if (!Hive.isAdapterRegistered(TripAdapter().typeId)) {
      Hive.registerAdapter(TripAdapter());
    }
    _tripsBox = await Hive.openBox<Trip>('tripsBox');
    _loadTrips();
  }

  /// Loads all [Trip] objects from Hive into the in-memory list and notifies listeners.
  void _loadTrips() {
    _trips = _tripsBox.values.toList();
    notifyListeners();
  }

  /// Adds a new [Trip] to the collection and persists it to Hive.
  ///
  /// [id] is the Avventure nel Mondo trip code.
  Future<void> addTrip(String id, String name, {DateTime? startDate, DateTime? endDate}) async {
    final newTrip = Trip(
      id: id,
      name: name,
      startDate: startDate,
      endDate: endDate,
    );
    await _tripsBox.put(newTrip.id, newTrip);
    _trips.add(newTrip);
    notifyListeners();
  }

  /// Updates an existing [Trip] object and persists changes to Hive.
  Future<void> updateTrip(Trip trip) async {
    await trip.save(); // Inherited from HiveObject
    _loadTrips(); // Reloads list and notifies listeners
  }

  /// Deletes a [Trip] by its [id] from the collection and Hive.
  Future<void> deleteTrip(String id) async {
    await _tripsBox.delete(id);
    _trips.removeWhere((trip) => trip.id == id);
    notifyListeners();
  }

  /// Retrieves a single [Trip] object by its unique [id] from Hive.
  ///
  /// Returns `null` if no trip with the given [id] is found.
  Trip? getTripById(String id) {
    return _tripsBox.get(id);
  }
}