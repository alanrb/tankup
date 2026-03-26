// ⛽ FUEL PRICE REGISTRY — TankUp
//
// 🔔 HOW TO UPDATE PRICES:
//   1. Check latest announcement at petrolimex.com.vn
//   2. Update [currentPrices] below
//   3. Move old prices to [priceHistory]
//   4. Run the app — all screens pick up the new prices automatically
//
// Source: Petrolimex (petrolimex.com.vn)

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

// ─────────────────────────────────────────────
//  PRICE SNAPSHOT (one full update cycle)
// ─────────────────────────────────────────────

class FuelPriceSnapshot {
  final String effectiveFrom; // e.g. '23:00 ngày 24/03/2026'
  final String announcedDate; // e.g. '24/03/2026'
  final String decisionNo; // e.g. '208/PLX-QĐ-TGĐ'
  final String source; // URL or reference
  final List<FuelPriceEntry> prices;

  const FuelPriceSnapshot({
    required this.effectiveFrom,
    required this.announcedDate,
    required this.decisionNo,
    required this.source,
    required this.prices,
  });
}

// ─────────────────────────────────────────────
//  ✅ CURRENT PRICES  ← UPDATE THIS SECTION
// ─────────────────────────────────────────────

const FuelPriceSnapshot currentPrices = FuelPriceSnapshot(
  effectiveFrom: '23:00 ngày 24/03/2026',
  announcedDate: '24/03/2026',
  decisionNo: '208/PLX-QĐ-TGĐ',
  source: 'https://petrolimex.com.vn/ndi/thong-cao-bao-chi',
  prices: [
    FuelPriceEntry(fuelId: 'e5_ron92',     vung1: 28070, vung2: 28630),
    FuelPriceEntry(fuelId: 'ron95_iii',    vung1: 29950, vung2: 30540),
    FuelPriceEntry(fuelId: 'ron95_v',      vung1: 30350, vung2: 30950),
    FuelPriceEntry(fuelId: 'diesel_005s',  vung1: 37890, vung2: 38640),
    FuelPriceEntry(fuelId: 'diesel_0001s', vung1: 38090, vung2: 38850),
    FuelPriceEntry(fuelId: 'electric',     vung1: 0,     vung2: 0),
  ],
);

// ─────────────────────────────────────────────
//  📜 PRICE HISTORY  ← APPEND OLD PRICES HERE
// ─────────────────────────────────────────────

const List<FuelPriceSnapshot> priceHistory = [

  FuelPriceSnapshot(
    effectiveFrom: '23:00 ngày 19/03/2026',
    announcedDate: '19/03/2026',
    decisionNo: '196/PLX-QĐ-TGĐ',
    source: 'https://petrolimex.com.vn/ndi/thong-cao-bao-chi',
    prices: [
      FuelPriceEntry(fuelId: 'e5_ron92',     vung1: 28420, vung2: 28990),
      FuelPriceEntry(fuelId: 'ron95_iii',    vung1: 30310, vung2: 30910),
      FuelPriceEntry(fuelId: 'ron95_v',      vung1: 30720, vung2: 31330),
      FuelPriceEntry(fuelId: 'diesel_005s',  vung1: 38400, vung2: 39160),
      FuelPriceEntry(fuelId: 'diesel_0001s', vung1: 38620, vung2: 39390),
      FuelPriceEntry(fuelId: 'electric',     vung1: 0,     vung2: 0),
    ],
  ),

  FuelPriceSnapshot(
    effectiveFrom: '22:00 ngày 12/03/2026',
    announcedDate: '12/03/2026',
    decisionNo: '176/PLX-QĐ-TGĐ',
    source: 'https://petrolimex.com.vn/ndi/thong-cao-bao-chi',
    prices: [
      FuelPriceEntry(fuelId: 'e5_ron92',     vung1: 28780, vung2: 29360),
      FuelPriceEntry(fuelId: 'ron95_iii',    vung1: 30690, vung2: 31300),
      FuelPriceEntry(fuelId: 'ron95_v',      vung1: 31110, vung2: 31730),
      FuelPriceEntry(fuelId: 'diesel_005s',  vung1: 38940, vung2: 39710),
      FuelPriceEntry(fuelId: 'diesel_0001s', vung1: 39150, vung2: 39930),
      FuelPriceEntry(fuelId: 'electric',     vung1: 0,     vung2: 0),
    ],
  ),

  FuelPriceSnapshot(
    effectiveFrom: '22:00 ngày 11/03/2026',
    announcedDate: '11/03/2026',
    decisionNo: '175/PLX-QĐ-TGĐ',
    source: 'https://petrolimex.com.vn/ndi/thong-cao-bao-chi',
    prices: [
      FuelPriceEntry(fuelId: 'e5_ron92',     vung1: 29060, vung2: 29640),
      FuelPriceEntry(fuelId: 'ron95_iii',    vung1: 30990, vung2: 31600),
      FuelPriceEntry(fuelId: 'ron95_v',      vung1: 31410, vung2: 32040),
      FuelPriceEntry(fuelId: 'diesel_005s',  vung1: 39300, vung2: 40080),
      FuelPriceEntry(fuelId: 'diesel_0001s', vung1: 39520, vung2: 40310),
      FuelPriceEntry(fuelId: 'electric',     vung1: 0,     vung2: 0),
    ],
  ),

  FuelPriceSnapshot(
    effectiveFrom: '23:45 ngày 10/03/2026',
    announcedDate: '10/03/2026',
    decisionNo: '170/PLX-QĐ-TGĐ',
    source: 'https://petrolimex.com.vn/ndi/thong-cao-bao-chi',
    prices: [
      FuelPriceEntry(fuelId: 'e5_ron92',     vung1: 29420, vung2: 30010),
      FuelPriceEntry(fuelId: 'ron95_iii',    vung1: 31370, vung2: 31990),
      FuelPriceEntry(fuelId: 'ron95_v',      vung1: 31800, vung2: 32430),
      FuelPriceEntry(fuelId: 'diesel_005s',  vung1: 39780, vung2: 40560),
      FuelPriceEntry(fuelId: 'diesel_0001s', vung1: 40000, vung2: 40790),
      FuelPriceEntry(fuelId: 'electric',     vung1: 0,     vung2: 0),
    ],
  ),

  FuelPriceSnapshot(
    effectiveFrom: '15:00 ngày 07/03/2026',
    announcedDate: '07/03/2026',
    decisionNo: '162/PLX-QĐ-TGĐ',
    source: 'https://petrolimex.com.vn/ndi/thong-cao-bao-chi',
    prices: [
      FuelPriceEntry(fuelId: 'e5_ron92',     vung1: 20060, vung2: 20590),
      FuelPriceEntry(fuelId: 'ron95_iii',    vung1: 20890, vung2: 21450),
      FuelPriceEntry(fuelId: 'ron95_v',      vung1: 21260, vung2: 21820),
      FuelPriceEntry(fuelId: 'diesel_005s',  vung1: 17690, vung2: 18340),
      FuelPriceEntry(fuelId: 'diesel_0001s', vung1: 17880, vung2: 18540),
      FuelPriceEntry(fuelId: 'electric',     vung1: 0,     vung2: 0),
    ],
  ),

];

// ─────────────────────────────────────────────
//  HELPERS
// ─────────────────────────────────────────────

/// Get current price for a fuel ID. Returns Vùng 1 price by default.
int getPriceForFuel(String fuelId, {bool isVung2 = false}) {
  final entry = currentPrices.prices.firstWhere(
    (e) => e.fuelId == fuelId,
    orElse: () => const FuelPriceEntry(fuelId: '', vung1: 0, vung2: 0),
  );
  return isVung2 ? entry.vung2 : entry.vung1;
}

/// Calculate total fill cost in VND.
int calcTotal({
  required String fuelId,
  required double litres,
  bool isVung2 = false,
}) {
  final price = getPriceForFuel(fuelId, isVung2: isVung2);
  return (price * litres).round();
}

/// Convert VND amount → litres for a given fuel.
double vndToLitres({
  required String fuelId,
  required int vnd,
  bool isVung2 = false,
}) {
  final price = getPriceForFuel(fuelId, isVung2: isVung2);
  if (price == 0) return 0;
  return vnd / price;
}

/// Format int as VND string: 28070 → '28.070₫'
String fmtVND(int amount) {
  if (amount == 0) return 'N/A';
  final s = amount.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return '${buf.toString()}₫';
}
