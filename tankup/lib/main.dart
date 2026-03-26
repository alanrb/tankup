import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tankup/blocs/fuel/fuel_cubit.dart';
import 'package:tankup/blocs/vehicle/vehicle_cubit.dart';
import 'package:tankup/screens/screen_disclaimer.dart';

void main() {
  runApp(const TankUpApp());
}

class TankUpApp extends StatelessWidget {
  const TankUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => VehicleCubit()),
        BlocProvider(create: (_) => FuelCubit()),
      ],
      child: MaterialApp(
        title: 'TankUp ⛽',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFF6B00),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const DisclaimerScreen(),
      ),
    );
  }
}
