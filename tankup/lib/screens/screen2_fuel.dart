import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tankup/blocs/fuel/fuel_cubit.dart';
import 'package:tankup/blocs/fuel/fuel_state.dart';
import 'package:tankup/blocs/vehicle/vehicle_cubit.dart';
import 'package:tankup/blocs/vehicle/vehicle_state.dart';
import 'package:tankup/models/fuel.dart';
import 'package:tankup/models/vehicle.dart';
import 'package:tankup/screens/screen3_animation.dart';
import 'package:tankup/services/fuel_price_service.dart';

class Screen2Fuel extends StatefulWidget {
  const Screen2Fuel({super.key});

  @override
  State<Screen2Fuel> createState() => _Screen2FuelState();
}

class _Screen2FuelState extends State<Screen2Fuel> {
  @override
  void initState() {
    super.initState();
    context.read<FuelCubit>().loadPrices();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleCubit, VehicleState>(
      builder: (context, vehicleState) {
        final vehicle = vehicleState.selected!;
        final fuels = recommendedFuels(vehicle.fuelGrades);

        return BlocBuilder<FuelCubit, FuelState>(
          builder: (context, fuelState) {
            final isEV = vehicle.isEV;
            final canProceed =
                fuelState.selectedFuel != null && fuelState.litres > 0;

            return Scaffold(
              appBar: AppBar(
                title: Text(vehicle.name),
                centerTitle: true,
              ),
              body: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Price status badge ────────────────────────────
                          _PriceStatusBadge(liveResult: fuelState.liveResult),
                          const SizedBox(height: 12),

                          // ── Fuel type cards ──────────────────────────────
                          const Text(
                            'Loại nhiên liệu',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          ...fuels.map((f) => _FuelCard(
                                fuel: f,
                                isSelected: fuelState.selectedFuel?.id == f.id,
                                effectivePricePerLitre:
                                    fuelState.effectivePrice(f.id),
                              )),
                          const SizedBox(height: 20),

                          // ── Amount section ───────────────────────────────
                          if (fuelState.selectedFuel != null) ...[
                            if (isEV)
                              _EVSection(fuelState: fuelState)
                            else
                              _FuelAmountSection(
                                vehicle: vehicle,
                                fuelState: fuelState,
                              ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // ── Summary bar + proceed button ─────────────────────────
                  _SummaryBar(
                    vehicle: vehicle,
                    fuelState: fuelState,
                    canProceed: canProceed,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// ─── Price status badge ───────────────────────────────────────────────────────

class _PriceStatusBadge extends StatelessWidget {
  const _PriceStatusBadge({required this.liveResult});
  final LivePriceResult? liveResult;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    String text;
    if (liveResult == null) {
      text = 'Đang tải giá...';
    } else {
      final t = liveResult!.fetchedAt;
      final timeStr =
          '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')} '
          '${t.day.toString().padLeft(2, '0')}/${t.month.toString().padLeft(2, '0')}/${t.year}';
      switch (liveResult!.source) {
        case PriceSource.live:
          text = 'Giá cập nhật lúc $timeStr';
        case PriceSource.cached:
          text = 'Giá lưu lúc $timeStr';
        case PriceSource.hardcoded:
          text = 'Đang dùng giá tạm thời';
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, color: cs.onSurface.withValues(alpha: 0.7)),
      ),
    );
  }
}

// ─── Fuel type card ───────────────────────────────────────────────────────────

class _FuelCard extends StatelessWidget {
  const _FuelCard({
    required this.fuel,
    required this.isSelected,
    required this.effectivePricePerLitre,
  });
  final FuelType fuel;
  final bool isSelected;
  final int effectivePricePerLitre;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FuelCubit>();

    return GestureDetector(
      onTap: () => cubit.selectFuel(fuel),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? fuel.color
              : fuel.color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? fuel.color : fuel.color.withValues(alpha: 0.4),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fuel.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isSelected ? fuel.textColor : null,
                    ),
                  ),
                  Text(
                    fuel.category == FuelCategory.electric
                        ? fuel.suitableFor
                        : '${formatVND(effectivePricePerLitre)}/L  •  ${fuel.suitableFor}',
                    style: TextStyle(
                      fontSize: 11,
                      color: isSelected
                          ? fuel.textColor.withValues(alpha: 0.8)
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle,
                  color: fuel.textColor, size: 20),
          ],
        ),
      ),
    );
  }
}

// ─── Fuel amount section ──────────────────────────────────────────────────────

class _FuelAmountSection extends StatelessWidget {
  const _FuelAmountSection({
    required this.vehicle,
    required this.fuelState,
  });
  final Vehicle vehicle;
  final FuelState fuelState;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FuelCubit>();
    final max = vehicle.tankCapacity;
    final fuel = fuelState.selectedFuel!;
    final total = calculateTotal(
        fuel: fuel, litres: fuelState.litres, isVung2: fuelState.isVung2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Mode toggle ───────────────────────────────────────────────────
        Row(
          children: [
            const Text('Bạn muốn đổ bao nhiêu?',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const Spacer(),
            _ModeToggle(isLitreMode: fuelState.isLitreMode),
          ],
        ),
        const SizedBox(height: 14),

        // ── Quick presets ─────────────────────────────────────────────────
        Builder(builder: (context) {
          final presets = vehicle.type == VehicleType.motorbike
              ? [FuelPreset.vnd20k, FuelPreset.vnd50k, FuelPreset.vnd100k]
              : [FuelPreset.vnd200k, FuelPreset.vnd500k, FuelPreset.vnd1m];
          return Row(
            children: [
              ...presets.map((p) => [
                    _PresetBtn(
                      label: p.label,
                      onTap: () => cubit.setPreset(p, vehicle),
                    ),
                    const SizedBox(width: 8),
                  ]).expand((w) => w),
              _PresetBtn(
                label: FuelPreset.full.label,
                onTap: () => cubit.setPreset(FuelPreset.full, vehicle),
                highlight: true,
              ),
            ],
          );
        }),
        const SizedBox(height: 16),

        // ── Slider ────────────────────────────────────────────────────────
        Row(
          children: [
            Text('0L',
                style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5))),
            Expanded(
              child: Slider(
                value: fuelState.litres.clamp(0.0, max),
                min: 0,
                max: max,
                divisions: (max / 0.5).round(),
                activeColor: fuel.color,
                onChanged: (v) => cubit.setLitres(v, max),
              ),
            ),
            Text('${max.toStringAsFixed(0)}L',
                style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5))),
          ],
        ),

        // ── +/- stepper ───────────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton.outlined(
              onPressed: fuelState.litres > 0 ? () => cubit.stepDown() : null,
              icon: const Icon(Icons.remove),
            ),
            const SizedBox(width: 12),
            _EditableAmount(
              vehicle: vehicle,
              fuelState: fuelState,
              isLitreMode: fuelState.isLitreMode,
              total: total,
            ),
            const SizedBox(width: 12),
            IconButton.outlined(
              onPressed:
                  fuelState.litres < max ? () => cubit.stepUp(max) : null,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // ── Live price ────────────────────────────────────────────────────
        Center(
          child: Text(
            '≈ ${formatVND(total)}',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 4),

        // ── Near-full warning ─────────────────────────────────────────────
        if (max > 0 && fuelState.litres / max > 0.95)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Center(
              child: Text(
                '⚠️ Gần đầy rồi đó! Cẩn thận tràn!',
                style: TextStyle(
                    color: Colors.orange[300],
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
      ],
    );
  }
}

// ─── Editable amount label ────────────────────────────────────────────────────

class _EditableAmount extends StatefulWidget {
  const _EditableAmount({
    required this.vehicle,
    required this.fuelState,
    required this.isLitreMode,
    required this.total,
  });
  final Vehicle vehicle;
  final FuelState fuelState;
  final bool isLitreMode;
  final int total;

  @override
  State<_EditableAmount> createState() => _EditableAmountState();
}

class _EditableAmountState extends State<_EditableAmount> {
  bool _editing = false;
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FuelCubit>();
    final display = widget.isLitreMode
        ? '${widget.fuelState.litres.toStringAsFixed(1)} L'
        : formatVND(widget.total);

    if (_editing) {
      return SizedBox(
        width: 120,
        child: TextField(
          controller: _ctrl,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            isDense: true,
            border: OutlineInputBorder(),
          ),
          onSubmitted: (v) {
            setState(() => _editing = false);
            final parsed = double.tryParse(v);
            if (parsed != null) {
              if (widget.isLitreMode) {
                cubit.setLitres(parsed, widget.vehicle.tankCapacity);
              } else {
                cubit.setFromVND(parsed.round(), widget.vehicle.tankCapacity);
              }
            }
          },
          onTapOutside: (_) => setState(() => _editing = false),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() => _editing = true);
        _ctrl.text = widget.isLitreMode
            ? widget.fuelState.litres.toStringAsFixed(1)
            : widget.total.toString();
        _ctrl.selection =
            TextSelection.fromPosition(TextPosition(offset: _ctrl.text.length));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.4)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              display,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 4),
            Icon(Icons.edit,
                size: 14,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.4)),
          ],
        ),
      ),
    );
  }
}

// ─── Mode toggle ──────────────────────────────────────────────────────────────

class _ModeToggle extends StatelessWidget {
  const _ModeToggle({required this.isLitreMode});
  final bool isLitreMode;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FuelCubit>();
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: cubit.toggleMode,
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ModeChip(label: 'L', active: isLitreMode),
            _ModeChip(label: '₫', active: !isLitreMode),
          ],
        ),
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({required this.label, required this.active});
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: active ? cs.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: active ? cs.onPrimary : cs.onSurface.withValues(alpha: 0.6),
          fontWeight: active ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
        ),
      ),
    );
  }
}

// ─── Preset button ────────────────────────────────────────────────────────────

class _PresetBtn extends StatelessWidget {
  const _PresetBtn({required this.label, required this.onTap, this.highlight = false});
  final String label;
  final VoidCallback onTap;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: highlight
                ? cs.primary.withValues(alpha: 0.15)
                : cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: highlight
                ? Border.all(color: cs.primary.withValues(alpha: 0.5))
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: highlight ? cs.primary : null,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── EV section ───────────────────────────────────────────────────────────────

class _EVSection extends StatelessWidget {
  const _EVSection({required this.fuelState});
  final FuelState fuelState;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FuelCubit>();
    final percent = fuelState.litres.round().clamp(0, 100);
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '⚡ Sạc bao nhiêu %?',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            '$percent%',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFF9A825),
            ),
          ),
        ),
        Slider(
          value: fuelState.litres.clamp(0.0, 100.0),
          min: 0,
          max: 100,
          divisions: 100,
          activeColor: const Color(0xFFF9A825),
          onChanged: (v) => cubit.setBatteryPercent(v.round()),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            '⚡ Cắm điện thôi bạn ơi, không cần ra cây xăng!',
            style: TextStyle(
                fontSize: 13, color: cs.onSurface.withValues(alpha: 0.7)),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

// ─── Summary bar ──────────────────────────────────────────────────────────────

class _SummaryBar extends StatelessWidget {
  const _SummaryBar({
    required this.vehicle,
    required this.fuelState,
    required this.canProceed,
  });
  final Vehicle vehicle;
  final FuelState fuelState;
  final bool canProceed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fuel = fuelState.selectedFuel;
    final isEV = vehicle.isEV;
    final litres = fuelState.litres;
    final total = fuelState.totalVND;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(top: BorderSide(color: cs.outline.withValues(alpha: 0.2))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (fuel != null)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _SummaryItem(
                    icon: '',
                    label: isEV
                        ? '100%'
                        : '${vehicle.tankCapacity.toStringAsFixed(1)}L',
                    sub: 'Bình',
                  ),
                  Container(width: 1, height: 32, color: cs.outline.withValues(alpha: 0.2)),
                  _SummaryItem(
                    icon: '',
                    label: isEV
                        ? '${litres.round()}%'
                        : '${litres.toStringAsFixed(1)}L',
                    sub: 'Đổ',
                  ),
                  Container(width: 1, height: 32, color: cs.outline.withValues(alpha: 0.2)),
                  _SummaryItem(
                    icon: '',
                    label: isEV ? '—' : formatVND(total),
                    sub: 'Tổng',
                  ),
                ],
              ),
            ),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: canProceed
                  ? () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const Screen3Animation()),
                      )
                  : null,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  'Đổ xăng thôi!',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.icon, required this.label, required this.sub});
  final String icon;
  final String label;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(sub,
            style: TextStyle(
                fontSize: 10,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.5))),
        const SizedBox(height: 2),
        Text('$icon $label',
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
