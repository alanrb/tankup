import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tankup/data/fuel_price.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MODELS
// ─────────────────────────────────────────────────────────────────────────────

enum PriceSource {
  live,
  cached,
  hardcoded,
}

class LivePriceResult {
  final Map<String, FuelPriceEntry> prices; // fuelId → entry
  final PriceSource source;
  final DateTime fetchedAt;
  final String? errorMessage;

  const LivePriceResult({
    required this.prices,
    required this.source,
    required this.fetchedAt,
    this.errorMessage,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// SERVICE
// ─────────────────────────────────────────────────────────────────────────────

class FuelPriceService {
  FuelPriceService._();
  static final FuelPriceService instance = FuelPriceService._();

  static const _url = 'https://webgia.com/gia-xang-dau/petrolimex/';
  static const _urlFallback = 'https://webgia.com/gia-xang-dau/';
  static const _keyJson = 'fuel_prices_json';
  static const _keyFetchedAt = 'fuel_prices_fetched_at';
  static const _cacheValidDuration = Duration(hours: 4);
  static const _timeout = Duration(seconds: 10);
  static const _minValidPrice = 15000;
  static const _maxValidPrice = 100000;
  static const _minFuelsRequired = 4;

  // Row keyword → fuelId mapping
  static const _rowMap = {
    'RON 95-V':   'ron95_v',
    'RON 95-III': 'ron95_iii',
    'RON 92':     'e5_ron92',
    '0,001S':     'diesel_0001s',
    '0,05S':      'diesel_005s',
  };

  LivePriceResult? _memCache;

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Main method — returns live, cached, or hardcoded prices.
  Future<LivePriceResult> fetchLatestPrices() async {
    // Fast path: in-memory cache still fresh
    if (_memCache != null && !isCacheStale(_memCache!.fetchedAt)) {
      return _memCache!;
    }

    // Try disk cache first (avoids network if still fresh)
    final diskCached = await _loadFromPrefs();
    if (diskCached != null && !isCacheStale(diskCached.fetchedAt)) {
      _memCache = diskCached;
      return diskCached;
    }

    // Check connectivity
    final connectivity = await Connectivity().checkConnectivity();
    final hasNetwork = connectivity.any((c) => c != ConnectivityResult.none);

    if (!hasNetwork) {
      final fallback = diskCached ?? _emptyResult();
      _memCache = fallback;
      return fallback;
    }

    // Fetch live
    return _fetchLive(fallback: diskCached);
  }

  /// Force refresh — ignores cache, always fetches from network.
  Future<LivePriceResult> forceRefresh() => _fetchLive(fallback: null);

  /// Sync access to last result (null if never fetched).
  LivePriceResult? getCached() => _memCache;

  /// Returns true if the given [fetchedAt] timestamp is older than 12 hours.
  bool isCacheStale(DateTime fetchedAt) {
    return DateTime.now().difference(fetchedAt) > _cacheValidDuration;
  }

  /// Clear SharedPreferences cache.
  Future<void> clearCache() async {
    _memCache = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyJson);
    await prefs.remove(_keyFetchedAt);
  }

  // ── Private ────────────────────────────────────────────────────────────────

  Future<LivePriceResult> _fetchLive({required LivePriceResult? fallback}) async {
    for (final url in [_url, _urlFallback]) {
      try {
        final response = await http.get(Uri.parse(url)).timeout(_timeout);
        if (response.statusCode != 200) continue;

        final prices = _parseHtml(response.body);
        if (prices.length < _minFuelsRequired) continue;

        final result = LivePriceResult(
          prices: prices,
          source: PriceSource.live,
          fetchedAt: DateTime.now(),
        );
        await _saveToPrefs(prices);
        _memCache = result;
        return result;
      } catch (_) {
        continue;
      }
    }

    final fallbackResult = fallback ?? _emptyResult();
    _memCache = fallbackResult;
    return fallbackResult;
  }

  /// Parse HTML table into a fuelId → FuelPriceEntry map.
  Map<String, FuelPriceEntry> _parseHtml(String body) {
    final doc = html_parser.parse(body);
    final rows = doc.querySelectorAll('table tr');
    final result = <String, FuelPriceEntry>{};

    for (final row in rows) {
      final th = row.querySelector('th');
      final tds = row.querySelectorAll('td');
      if (th == null || tds.length < 2) continue;

      // Normalize whitespace before matching to handle encoding variations
      final productText = th.text.trim().replaceAll(RegExp(r'\s+'), ' ');
      final vung1 = _parsePrice(tds[0].text);
      final vung2 = _parsePrice(tds[1].text);
      if (vung1 == 0 || !_isPriceValid(vung1)) continue;

      for (final entry in _rowMap.entries) {
        if (productText.contains(entry.key)) {
          result[entry.value] = FuelPriceEntry(
            fuelId: entry.value,
            vung1: vung1,
            // Fall back to vung1 if vung2 is missing or invalid
            vung2: _isPriceValid(vung2) ? vung2 : vung1,
          );
          break;
        }
      }
    }

    // Electric is always 0
    result['electric'] = const FuelPriceEntry(
        fuelId: 'electric', vung1: 0, vung2: 0);

    return result;
  }

  int _parsePrice(String text) =>
      int.tryParse(text.trim().replaceAll('.', '').replaceAll(',', '')) ?? 0;

  bool _isPriceValid(int price) =>
      price >= _minValidPrice && price <= _maxValidPrice;

  // ── SharedPreferences ──────────────────────────────────────────────────────

  Future<void> _saveToPrefs(Map<String, FuelPriceEntry> prices) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonMap = prices.map((id, e) => MapEntry(id, {
          'vung1': e.vung1,
          'vung2': e.vung2,
        }));
    await prefs.setString(_keyJson, jsonEncode(jsonMap));
    await prefs.setString(_keyFetchedAt, DateTime.now().toIso8601String());
  }

  Future<LivePriceResult?> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_keyJson);
      final fetchedAtStr = prefs.getString(_keyFetchedAt);
      if (jsonStr == null || fetchedAtStr == null) return null;

      final fetchedAt = DateTime.parse(fetchedAtStr);
      final raw = jsonDecode(jsonStr) as Map<String, dynamic>;
      final prices = raw.map((id, v) {
        final m = v as Map<String, dynamic>;
        return MapEntry(
          id,
          FuelPriceEntry(
            fuelId: id,
            vung1: (m['vung1'] as num).toInt(),
            vung2: (m['vung2'] as num).toInt(),
          ),
        );
      });

      return LivePriceResult(
        prices: prices,
        source: PriceSource.cached,
        fetchedAt: fetchedAt,
      );
    } catch (_) {
      return null;
    }
  }

  LivePriceResult _emptyResult() => LivePriceResult(
        prices: const {},
        source: PriceSource.hardcoded,
        fetchedAt: DateTime.now(),
      );
}
