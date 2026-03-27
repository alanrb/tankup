// ─────────────────────────────────────────────
//  PRICE ENTRY
// ─────────────────────────────────────────────

class FuelPriceEntry {
  final String fuelId; // matches FuelType.id in fuel.dart
  final int vung1; // VND/litre — Vùng 1 (main cities)
  final int vung2; // VND/litre — Vùng 2 (remote areas)

  const FuelPriceEntry({
    required this.fuelId,
    required this.vung1,
    required this.vung2,
  });
}

