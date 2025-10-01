import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

class LocationNotifier extends StateNotifier<AsyncValue<Position?>> {
  LocationNotifier() : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    await refreshLocation();
  }

  Future<void> refreshLocation() async {
    state = const AsyncValue.loading();
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        // User denied (not permanently)
        state = AsyncValue.error('Location permission denied' ,   StackTrace.current,);

        return;
      }

      if (permission == LocationPermission.deniedForever) {
        state = AsyncValue.error('Location permission permanently denied' ,  StackTrace.current,);
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      state = AsyncValue.data(pos);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }
}

final locationProvider = StateNotifierProvider<LocationNotifier, AsyncValue<Position?>>(
      (ref) => LocationNotifier(),
);
