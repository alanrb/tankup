import 'package:flutter/material.dart';
import 'package:tankup/models/vehicle.dart';

enum FuelCategory { petrol, diesel, electric }

class FuelType {
  final String id;
  final String name;
  final String shortLabel;
  final String description;
  final FuelCategory category;
  final String emoji;
  final Color color;
  final Color textColor;
  final String suitableFor;

  const FuelType({
    required this.id,
    required this.name,
    required this.shortLabel,
    required this.description,
    required this.category,
    required this.emoji,
    required this.color,
    required this.textColor,
    required this.suitableFor,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// FUEL DATA — prices fetched live from fuel_price_service.dart
// ─────────────────────────────────────────────────────────────────────────────

final List<FuelType> fuelTypes = [
  FuelType(
    id: 'e5_ron92',
    name: 'Xăng E5 RON 92-II',
    shortLabel: 'E5 RON 92',
    description: 'Xăng phổ thông, tỉ số nén 7:1–10:1',
    category: FuelCategory.petrol,
    emoji: '🟢',
    color: const Color(0xFF2E7D32),
    textColor: Colors.white,
    suitableFor: 'Xe máy & ô tô động cơ tỉ số nén thấp',
  ),
  FuelType(
    id: 'ron95_iii',
    name: 'Xăng RON 95-III',
    shortLabel: 'RON 95-III',
    description: 'Xăng cao cấp, tỉ số nén > 10:1',
    category: FuelCategory.petrol,
    emoji: '🔵',
    color: const Color(0xFF1565C0),
    textColor: Colors.white,
    suitableFor: 'Xe máy & ô tô động cơ tỉ số nén cao',
  ),
  FuelType(
    id: 'ron95_v',
    name: 'Xăng RON 95-V',
    shortLabel: 'RON 95-V',
    description: 'Xăng premium Euro 5 tiêu chuẩn cao',
    category: FuelCategory.petrol,
    emoji: '🔷',
    color: const Color(0xFF0D47A1),
    textColor: Colors.white,
    suitableFor: 'Xe cao cấp, động cơ Euro 5',
  ),
  FuelType(
    id: 'diesel_005s',
    name: 'Dầu Diesel DO 0,05S-II',
    shortLabel: 'Diesel 0,05S',
    description: 'Dầu diesel tiêu chuẩn phổ thông',
    category: FuelCategory.diesel,
    emoji: '⚫',
    color: const Color(0xFF212121),
    textColor: Colors.white,
    suitableFor: 'Ô tô diesel (Fortuner, Everest, Ranger…)',
  ),
  FuelType(
    id: 'diesel_0001s',
    name: 'Dầu Diesel DO 0,001S-V',
    shortLabel: 'Diesel 0,001S',
    description: 'Dầu diesel premium Euro 5',
    category: FuelCategory.diesel,
    emoji: '🖤',
    color: const Color(0xFF37474F),
    textColor: Colors.white,
    suitableFor: 'Ô tô diesel cao cấp Euro 5',
  ),
  FuelType(
    id: 'electric',
    name: 'Điện (EV)',
    shortLabel: 'Điện EV',
    description: 'Sạc điện cho xe VinFast',
    category: FuelCategory.electric,
    emoji: '⚡',
    color: const Color(0xFFF9A825),
    textColor: Colors.black,
    suitableFor: 'VinFast EV (VF 3, VF 5, VF 6, VF 7)',
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────────────────────────────────────

/// Returns fuels recommended for the given vehicle fuel grades.
List<FuelType> recommendedFuels(List<VehicleFuelGrade> grades) {
  final ids = <String>{};
  for (final g in grades) {
    switch (g) {
      case VehicleFuelGrade.ron92:
        ids.add('e5_ron92');
      case VehicleFuelGrade.ron95:
        ids.addAll(['e5_ron92', 'ron95_iii', 'ron95_v']);
      case VehicleFuelGrade.diesel:
        ids.addAll(['diesel_005s', 'diesel_0001s']);
      case VehicleFuelGrade.electric:
        ids.add('electric');
    }
  }
  if (ids.isEmpty) {
    return fuelTypes.where((f) => f.category != FuelCategory.electric).toList();
  }
  return fuelTypes.where((f) => ids.contains(f.id)).toList();
}

/// Formats an integer VND amount with dot separators: 28070 → '28.070₫'
String formatVND(int amount) {
  if (amount == 0) return 'N/A';
  final s = amount.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return '${buf.toString()}₫';
}


// ─────────────────────────────────────────────────────────────────────────────
// FUEL PRESET ENUM
// ─────────────────────────────────────────────────────────────────────────────

enum FuelPreset {
  vnd20k, vnd50k, vnd100k,  // motorbike presets
  vnd200k, vnd500k, vnd1m,  // car presets
  full;                      // fill to capacity (both)

  String get label => switch (this) {
    vnd20k  => '20K₫',
    vnd50k  => '50K₫',
    vnd100k => '100K₫',
    vnd200k => '200K₫',
    vnd500k => '500K₫',
    vnd1m   => '1 Triệu',
    full    => '🚀 Đầy',
  };

  /// VND amount for this preset. `null` means fill to full tank.
  int? get vndAmount => switch (this) {
    vnd20k  => 20000,
    vnd50k  => 50000,
    vnd100k => 100000,
    vnd200k => 200000,
    vnd500k => 500000,
    vnd1m   => 1000000,
    full    => null,
  };
}
