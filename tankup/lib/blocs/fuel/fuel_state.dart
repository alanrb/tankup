import 'package:tankup/models/fuel.dart';
import 'package:tankup/services/fuel_price_service.dart';

class FuelState {
  final FuelType? selectedFuel;
  final double litres;
  final bool isLitreMode; // true = input in L, false = input in ₫
  final bool isVung2;
  final LivePriceResult? liveResult;

  const FuelState({
    this.selectedFuel,
    this.litres = 0.0,
    this.isLitreMode = true,
    this.isVung2 = false,
    this.liveResult,
  });

  FuelState copyWith({
    FuelType? selectedFuel,
    double? litres,
    bool? isLitreMode,
    bool? isVung2,
    LivePriceResult? liveResult,
    bool clearFuel = false,
    bool clearLiveResult = false,
  }) {
    return FuelState(
      selectedFuel: clearFuel ? null : (selectedFuel ?? this.selectedFuel),
      litres: litres ?? this.litres,
      isLitreMode: isLitreMode ?? this.isLitreMode,
      isVung2: isVung2 ?? this.isVung2,
      liveResult: clearLiveResult ? null : (liveResult ?? this.liveResult),
    );
  }

  /// Returns the effective price per litre for [fuelId].
  /// Prefers live/cached result, falls back to hardcoded fuel_price.dart values.
  int effectivePrice(String fuelId, {bool? vung2Override}) {
    final useVung2 = vung2Override ?? isVung2;
    final live = liveResult?.prices[fuelId];
    if (live != null) return useVung2 ? live.vung2 : live.vung1;
    return 0;
  }

  int get totalVND {
    if (selectedFuel == null || selectedFuel!.category == FuelCategory.electric) {
      return 0;
    }
    final price = effectivePrice(selectedFuel!.id);
    return (price * litres).round();
  }
}
