import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tankup/blocs/fuel/fuel_cubit.dart';
import 'package:tankup/blocs/vehicle/vehicle_cubit.dart';
import 'package:tankup/models/fuel.dart';
import 'package:tankup/models/vehicle.dart';

enum _FillPhase { inserting, filling, complete, result }

class Screen3Animation extends StatefulWidget {
  const Screen3Animation({super.key});

  @override
  State<Screen3Animation> createState() => _Screen3AnimationState();
}

class _Screen3AnimationState extends State<Screen3Animation>
    with TickerProviderStateMixin {
  late final AnimationController _insertCtrl;
  late final AnimationController _fillCtrl;
  late final AnimationController _pulseCtrl;
  late final AnimationController _retractCtrl;
  late final AnimationController _celebrateCtrl;

  late final Animation<Offset> _nozzleInsert;
  late final Animation<Offset> _nozzleRetract;
  late final Animation<double> _kaChingScale;
  late final Animation<double> _nozzlePulse;

  _FillPhase _phase = _FillPhase.inserting;
  double _litreDisplay = 0.0;
  int _priceDisplay = 0;

  // Cached from BLoC so dispose doesn't need context
  late Vehicle _vehicle;
  late FuelType _fuel;
  late double _litres;
  late int _totalVND;
  late bool _isEV;

  @override
  void initState() {
    super.initState();

    // Read data from cubits before async gap
    final vehicleState = context.read<VehicleCubit>().state;
    final fuelState = context.read<FuelCubit>().state;

    _vehicle = vehicleState.selected!;
    _fuel = fuelState.selectedFuel!;
    _litres = fuelState.litres;
    _totalVND = fuelState.totalVND;
    _isEV = _vehicle.isEV;

    final fillMs = (_litres * 400).clamp(1500, 6000).toInt();

    // Controllers
    _insertCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fillCtrl =
        AnimationController(vsync: this, duration: Duration(milliseconds: fillMs));
    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _retractCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _celebrateCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    // Animations
    _nozzleInsert = Tween<Offset>(
      begin: const Offset(1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _insertCtrl, curve: Curves.easeOutBack));

    _nozzleRetract = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0),
    ).animate(CurvedAnimation(parent: _retractCtrl, curve: Curves.easeIn));

    _kaChingScale = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _celebrateCtrl, curve: Curves.elasticOut));

    _nozzlePulse = Tween<double>(begin: 1.0, end: 1.05).animate(
        CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    // Counter listener
    _fillCtrl.addListener(() {
      if (mounted) {
        setState(() {
          _litreDisplay = _fillCtrl.value * _litres;
          _priceDisplay = (_fillCtrl.value * _totalVND).round();
        });
      }
    });

    _runSequence();
  }

  String get _completionMessage {
    if (_isEV) return '⚡ Sạc xong! Xanh lắm bạn ơi!';
    if (_vehicle.tankCapacity <= 0) return 'KA-CHING! 🎉 Xong rồi!';
    final pct = _litres / _vehicle.tankCapacity;
    if (pct >= 1.0) return 'KA-CHING! 🎉 Đầy bình rồi!';
    if (pct >= 0.8) return 'KA-CHING! 🎉 Gần đầy rồi!';
    if (pct >= 0.5) return 'KA-CHING! 🎉 Được nửa bình!';
    if (pct >= 0.2) return 'KA-CHING! 🎉 Xong rồi!';
    return 'KA-CHING! 🎉 Chút xíu nhưng được rồi!';
  }

  Future<void> _runSequence() async {
    // Phase 1: Insert nozzle
    setState(() => _phase = _FillPhase.inserting);
    await _insertCtrl.forward();

    // Phase 2: Fill
    setState(() => _phase = _FillPhase.filling);
    _pulseCtrl.repeat(reverse: true);
    await _fillCtrl.forward();
    _pulseCtrl.stop();

    // Phase 3: Complete
    setState(() => _phase = _FillPhase.complete);
    _retractCtrl.forward();
    _celebrateCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 800));

    // Phase 4: Result
    if (mounted) setState(() => _phase = _FillPhase.result);
  }

  @override
  void dispose() {
    _insertCtrl.dispose();
    _fillCtrl.dispose();
    _pulseCtrl.dispose();
    _retractCtrl.dispose();
    _celebrateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fillPercent =
        _vehicle.tankCapacity > 0 ? _litres / _vehicle.tankCapacity : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TankUp'),
        centerTitle: true,
        automaticallyImplyLeading: _phase == _FillPhase.result,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ── Vehicle emoji ───────────────────────────────────────────────
            const SizedBox(height: 12),
            Text(_vehicle.emoji, style: const TextStyle(fontSize: 72)),
            Text(
              '${_vehicle.brand} ${_vehicle.name}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),

            // ── Nozzle ──────────────────────────────────────────────────────
            if (_phase != _FillPhase.result) ...[
              SlideTransition(
                position: _phase == _FillPhase.complete || _phase == _FillPhase.result
                    ? _nozzleRetract
                    : _nozzleInsert,
                child: ScaleTransition(
                  scale: _phase == _FillPhase.filling ? _nozzlePulse : const AlwaysStoppedAnimation(1.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: _fuel.color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _fuel.color, width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_isEV ? '🔌' : '⛽',
                            style: const TextStyle(fontSize: 28)),
                        const SizedBox(width: 8),
                        Text(
                          _isEV ? 'Đang sạc...' : 'Đang đổ...',
                          style: TextStyle(
                              color: _fuel.color,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // ── Tank gauge ──────────────────────────────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _isEV ? 'Pin' : 'Bình xăng',
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    Text(
                      _isEV
                          ? '${_litreDisplay.round()}%'
                          : '${_litreDisplay.toStringAsFixed(1)}L / ${_vehicle.tankCapacity.toStringAsFixed(1)}L',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: fillPercent.clamp(0.0, 1.0)),
                  duration: Duration(
                      milliseconds: (_litres * 400).clamp(1500, 6000).toInt()),
                  curve: Curves.linear,
                  builder: (context, value, _) => ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: value,
                      color: _fuel.color,
                      backgroundColor: cs.surfaceContainerHighest,
                      minHeight: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Counters ────────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _CounterCard(
                  icon: _isEV ? '⚡' : '⛽',
                  value: _isEV
                      ? '${_litreDisplay.round()}%'
                      : '${_litreDisplay.toStringAsFixed(1)} L',
                  label: _isEV ? 'Pin sạc' : 'Đã đổ',
                  color: _fuel.color,
                ),
                _CounterCard(
                  icon: '💰',
                  value: _isEV ? '—' : formatVND(_priceDisplay),
                  label: 'Tạm tính',
                  color: cs.primary,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── KA-CHING ────────────────────────────────────────────────────
            if (_phase == _FillPhase.complete ||
                _phase == _FillPhase.result) ...[
              ScaleTransition(
                scale: _kaChingScale,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      cs.primary.withValues(alpha: 0.2),
                      cs.primary.withValues(alpha: 0.05),
                    ]),
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: cs.primary.withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    _completionMessage,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],

            // ── Result card ─────────────────────────────────────────────────
            if (_phase == _FillPhase.result) ...[
              const SizedBox(height: 16),
              _ResultCard(
                vehicle: _vehicle,
                fuel: _fuel,
                litres: _litres,
                totalVND: _totalVND,
                isEV: _isEV,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Counter card ─────────────────────────────────────────────────────────────

class _CounterCard extends StatelessWidget {
  const _CounterCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });
  final String icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: color),
          ),
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  color: cs.onSurface.withValues(alpha: 0.5))),
        ],
      ),
    );
  }
}

// ─── Result card ──────────────────────────────────────────────────────────────

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.vehicle,
    required this.fuel,
    required this.litres,
    required this.totalVND,
    required this.isEV,
  });
  final Vehicle vehicle;
  final FuelType fuel;
  final double litres;
  final int totalVND;
  final bool isEV;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final today = DateTime.now();
    final dateStr =
        '${today.day.toString().padLeft(2, '0')}/${today.month.toString().padLeft(2, '0')}/${today.year}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ResultRow( label: 'Trạng thái', value: 'Đổ xăng thành công!'),
          _ResultRow( label: 'Xe', value: '${vehicle.brand} ${vehicle.name}'),
          _ResultRow( label: 'Loại xăng', value: fuel.shortLabel),
          _ResultRow(

            label: 'Đã đổ',
            value: isEV
                ? '${litres.round()}% pin'
                : '${litres.toStringAsFixed(1)} L / ${vehicle.tankCapacity.toStringAsFixed(1)} L',
          ),
          if (!isEV)
            _ResultRow( label: 'Tổng tiền', value: formatVND(totalVND)),
          _ResultRow( label: 'Ngày', value: dateStr),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      Navigator.popUntil(context, (r) => r.isFirst),
                  label: const Text('Đổ tiếp'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () =>
                      Navigator.popUntil(context, (r) => r.isFirst),
                  label: const Text('Trang chủ'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow(
      { required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Text(label,
              style: TextStyle(
                  fontSize: 13,
                  color: cs.onSurface.withValues(alpha: 0.6))),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
