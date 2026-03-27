import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tankup/blocs/fuel/fuel_cubit.dart';
import 'package:tankup/blocs/fuel/fuel_state.dart';
import 'package:tankup/blocs/vehicle/vehicle_cubit.dart';
import 'package:tankup/blocs/vehicle/vehicle_state.dart';
import 'package:tankup/models/fuel.dart';
import 'package:tankup/models/vehicle.dart';
import 'package:tankup/screens/screen2_fuel.dart';
import 'package:tankup/services/fuel_price_service.dart';

class Screen1Vehicle extends StatelessWidget {
  const Screen1Vehicle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleCubit, VehicleState>(
      builder: (context, state) {
        final groups =
            state.tabIndex == 0 ? motorbikeGroups : carGroups;

        return Scaffold(
          appBar: AppBar(
            title: const Text('TankUp'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.local_gas_station_outlined),
                tooltip: 'Giá xăng dầu',
                onPressed: () {
                  context.read<FuelCubit>().loadPrices();
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (_) => BlocProvider.value(
                      value: context.read<FuelCubit>(),
                      child: const _FuelPriceSheet(),
                    ),
                  );
                },
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: _TabBar(currentIndex: state.tabIndex),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: groups.length,
                  itemBuilder: (context, i) =>
                      _BrandTile(group: groups[i], selected: state.selected),
                ),
              ),
              _BottomBar(selected: state.selected),
            ],
          ),
        );
      },
    );
  }
}

// ─── Tab bar ─────────────────────────────────────────────────────────────────

class _TabBar extends StatelessWidget {
  const _TabBar({required this.currentIndex});
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<VehicleCubit>();
    final color = Theme.of(context).colorScheme.primary;

    return Row(
      children: [
        _Tab(label: 'Xe máy', index: 0, current: currentIndex, color: color, cubit: cubit),
        _Tab(label: 'Ô tô', index: 1, current: currentIndex, color: color, cubit: cubit),
      ],
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.index,
    required this.current,
    required this.color,
    required this.cubit,
  });

  final String label;
  final int index;
  final int current;
  final Color color;
  final VehicleCubit cubit;

  @override
  Widget build(BuildContext context) {
    final isActive = index == current;
    return Expanded(
      child: GestureDetector(
        onTap: () => cubit.switchTab(index),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? color : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? color : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Brand tile ──────────────────────────────────────────────────────────────

class _BrandTile extends StatelessWidget {
  const _BrandTile({required this.group, required this.selected});
  final VehicleBrandGroup group;
  final Vehicle? selected;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        group.brand,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      initiallyExpanded: selected != null && group.vehicles.contains(selected),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.4,
            ),
            itemCount: group.vehicles.length,
            itemBuilder: (context, i) => _VehicleCard(
              vehicle: group.vehicles[i],
              isSelected: selected == group.vehicles[i],
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

// ─── Vehicle card ─────────────────────────────────────────────────────────────

class _VehicleCard extends StatelessWidget {
  const _VehicleCard({required this.vehicle, required this.isSelected});
  final Vehicle vehicle;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<VehicleCubit>();
    final cs = Theme.of(context).colorScheme;
    final borderColor = isSelected ? cs.primary : cs.outline.withValues(alpha: 0.3);
    final bgColor = isSelected ? cs.primary.withValues(alpha: 0.15) : cs.surface;

    return GestureDetector(
      onTap: () => cubit.selectVehicle(vehicle),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          children: [
            Text(vehicle.emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          vehicle.name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (vehicle.isLegacy)
                        Container(
                          margin: const EdgeInsets.only(left: 2),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: Colors.amber.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.amber, width: 1),
                          ),
                          child: const Text(
                            '🏆',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                    ],
                  ),
                  Text(
                    vehicle.isEV
                        ? '⚡ EV'
                        : '${vehicle.tankCapacity.toStringAsFixed(1)}L',
                    style: TextStyle(
                      fontSize: 11,
                      color: cs.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Fuel price sheet ────────────────────────────────────────────────────────

class _FuelPriceSheet extends StatelessWidget {
  const _FuelPriceSheet();

  String _badgeText(LivePriceResult? result) {
    if (result == null) return 'Đang tải giá...';
    final t = result.fetchedAt;
    final ts =
        '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')} '
        '${t.day.toString().padLeft(2, '0')}/${t.month.toString().padLeft(2, '0')}/${t.year}';
    return switch (result.source) {
      PriceSource.live     => 'Giá cập nhật lúc $ts',
      PriceSource.cached   => 'Giá lưu lúc $ts',
      PriceSource.hardcoded => 'Đang dùng giá tạm thời',
    };
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final petrolDiesel =
        fuelTypes.where((f) => f.category != FuelCategory.electric).toList();

    return BlocBuilder<FuelCubit, FuelState>(
      builder: (context, fuelState) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Drag handle ───────────────────────────────────────────
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: cs.onSurface.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // ── Title row ─────────────────────────────────────────────
                Row(
                  children: [
                    const Text(
                      'Giá xăng dầu Petrolimex',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // ── Source badge ──────────────────────────────────────────
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _badgeText(fuelState.liveResult),
                    style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurface.withValues(alpha: 0.7)),
                  ),
                ),
                const SizedBox(height: 12),

                // ── Price rows ────────────────────────────────────────────
                ...petrolDiesel.map((f) {
                  final v1 = fuelState.effectivePrice(f.id);
                  final v2 = fuelState.effectivePrice(f.id, vung2Override: true);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            f.shortLabel,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${formatVND(v1)}/L',
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Vùng 2: ${formatVND(v2)}/L',
                              style: TextStyle(
                                  fontSize: 11,
                                  color:
                                      cs.onSurface.withValues(alpha: 0.5)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),

              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Bottom bar ──────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.selected});
  final Vehicle? selected;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(top: BorderSide(color: cs.outline.withValues(alpha: 0.2))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (selected != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${selected!.brand} ${selected!.name}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    selected!.isEV
                        ? '⚡ EV'
                        : '${selected!.tankCapacity.toStringAsFixed(1)}L',
                    style: TextStyle(color: cs.onSurface.withValues(alpha: 0.6), fontSize: 13),
                  ),
                ],
              ),
            ),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: selected == null
                  ? null
                  : () {
                      context.read<FuelCubit>().reset();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const Screen2Fuel()),
                      );
                    },
              label: const Text(
                'Tiếp theo →',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
