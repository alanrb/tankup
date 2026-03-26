enum VehicleType { motorbike, car }

enum VehicleFuelGrade { ron92, ron95, diesel, electric }

class Vehicle {
  final String name;
  final String brand;
  final double tankCapacity; // litres; 0.0 for EV
  final String emoji;
  final String description;
  final VehicleType type;
  final double? engineCC;
  final int? priceVND;
  final String? transmission;
  final List<VehicleFuelGrade> fuelGrades;
  final int? year;
  final bool isLegacy;

  const Vehicle({
    required this.name,
    required this.brand,
    required this.tankCapacity,
    required this.emoji,
    required this.description,
    required this.type,
    this.engineCC,
    this.priceVND,
    this.transmission,
    this.fuelGrades = const [VehicleFuelGrade.ron92],
    this.year,
    this.isLegacy = false,
  });

  bool get isEV => fuelGrades.contains(VehicleFuelGrade.electric);
}

class VehicleBrandGroup {
  final String brand;
  final VehicleType type;
  final List<Vehicle> vehicles;

  const VehicleBrandGroup({
    required this.brand,
    required this.type,
    required this.vehicles,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// MOTORBIKE DATA
// ─────────────────────────────────────────────────────────────────────────────

final _honda = VehicleBrandGroup(
  brand: 'Honda',
  type: VehicleType.motorbike,
  vehicles: [
    Vehicle(
      name: 'Future 1',
      brand: 'Honda',
      tankCapacity: 3.7,
      emoji: '🏍️',
      description: 'Xe số huyền thoại 2001',
      type: VehicleType.motorbike,
      engineCC: 108.9,
      transmission: '4 cấp bán tự động',
      fuelGrades: [VehicleFuelGrade.ron92],
      year: 2001,
      isLegacy: true,
    ),
    Vehicle(
      name: 'Future 125',
      brand: 'Honda',
      tankCapacity: 4.6,
      emoji: '🏍️',
      description: 'Xe số phổ thông bền bỉ',
      type: VehicleType.motorbike,
      engineCC: 124.8,
      transmission: '4 cấp bán tự động',
      fuelGrades: [VehicleFuelGrade.ron92, VehicleFuelGrade.ron95],
      priceVND: 30490000,
    ),
    Vehicle(
      name: 'Wave Alpha',
      brand: 'Honda',
      tankCapacity: 3.7,
      emoji: '🏍️',
      description: 'Xe số tiết kiệm kinh điển',
      type: VehicleType.motorbike,
      engineCC: 109.1,
      fuelGrades: [VehicleFuelGrade.ron92],
      priceVND: 18790000,
    ),
    Vehicle(
      name: 'Wave RSX',
      brand: 'Honda',
      tankCapacity: 3.7,
      emoji: '🏍️',
      description: 'Xe số phong cách trẻ',
      type: VehicleType.motorbike,
      engineCC: 109.1,
      fuelGrades: [VehicleFuelGrade.ron92],
      priceVND: 21990000,
    ),
    Vehicle(
      name: 'Vision',
      brand: 'Honda',
      tankCapacity: 5.5,
      emoji: '🛵',
      description: 'Xe ga đô thị thanh lịch',
      type: VehicleType.motorbike,
      engineCC: 109.5,
      fuelGrades: [VehicleFuelGrade.ron92, VehicleFuelGrade.ron95],
      priceVND: 32990000,
    ),
    Vehicle(
      name: 'Air Blade',
      brand: 'Honda',
      tankCapacity: 5.5,
      emoji: '🛵',
      description: 'Xe ga thể thao năng động',
      type: VehicleType.motorbike,
      engineCC: 124.8,
      fuelGrades: [VehicleFuelGrade.ron92, VehicleFuelGrade.ron95],
      priceVND: 52900000,
    ),
    Vehicle(
      name: 'SH 125i',
      brand: 'Honda',
      tankCapacity: 8.5,
      emoji: '🛵',
      description: 'Xe ga cao cấp sang trọng',
      type: VehicleType.motorbike,
      engineCC: 124.8,
      fuelGrades: [VehicleFuelGrade.ron95],
      priceVND: 79990000,
    ),
    Vehicle(
      name: 'Lead 125',
      brand: 'Honda',
      tankCapacity: 6.0,
      emoji: '🛵',
      description: 'Xe ga cốp rộng tiện dụng',
      type: VehicleType.motorbike,
      engineCC: 124.8,
      fuelGrades: [VehicleFuelGrade.ron92, VehicleFuelGrade.ron95],
      priceVND: 39990000,
    ),
    Vehicle(
      name: 'Winner X',
      brand: 'Honda',
      tankCapacity: 4.6,
      emoji: '🏍️',
      description: 'Xe côn thể thao mạnh mẽ',
      type: VehicleType.motorbike,
      engineCC: 149.8,
      fuelGrades: [VehicleFuelGrade.ron95],
      priceVND: 46990000,
    ),
  ],
);

final _yamaha = VehicleBrandGroup(
  brand: 'Yamaha',
  type: VehicleType.motorbike,
  vehicles: [
    Vehicle(
      name: 'Sirius',
      brand: 'Yamaha',
      tankCapacity: 4.2,
      emoji: '🏍️',
      description: 'Xe số tiết kiệm truyền thống',
      type: VehicleType.motorbike,
      engineCC: 113.7,
      fuelGrades: [VehicleFuelGrade.ron92],
      priceVND: 22490000,
    ),
    Vehicle(
      name: 'Exciter 155',
      brand: 'Yamaha',
      tankCapacity: 4.8,
      emoji: '🏍️',
      description: 'Xe côn thể thao mạnh nhất phân khúc',
      type: VehicleType.motorbike,
      engineCC: 155.0,
      fuelGrades: [VehicleFuelGrade.ron95],
      priceVND: 55900000,
    ),
    Vehicle(
      name: 'Janus',
      brand: 'Yamaha',
      tankCapacity: 5.0,
      emoji: '🛵',
      description: 'Xe ga dành cho nữ',
      type: VehicleType.motorbike,
      engineCC: 124.8,
      fuelGrades: [VehicleFuelGrade.ron92, VehicleFuelGrade.ron95],
      priceVND: 30700000,
    ),
    Vehicle(
      name: 'NVX 155',
      brand: 'Yamaha',
      tankCapacity: 6.8,
      emoji: '🛵',
      description: 'Xe ga thể thao cao cấp',
      type: VehicleType.motorbike,
      engineCC: 155.0,
      fuelGrades: [VehicleFuelGrade.ron95],
      priceVND: 55900000,
    ),
    Vehicle(
      name: 'Grande',
      brand: 'Yamaha',
      tankCapacity: 5.1,
      emoji: '🛵',
      description: 'Xe ga thanh lịch cho nữ',
      type: VehicleType.motorbike,
      engineCC: 124.8,
      fuelGrades: [VehicleFuelGrade.ron92, VehicleFuelGrade.ron95],
      priceVND: 49900000,
    ),
    Vehicle(
      name: 'FreeGo',
      brand: 'Yamaha',
      tankCapacity: 5.1,
      emoji: '🛵',
      description: 'Xe ga kết nối thông minh',
      type: VehicleType.motorbike,
      engineCC: 124.8,
      fuelGrades: [VehicleFuelGrade.ron92, VehicleFuelGrade.ron95],
      priceVND: 38990000,
    ),
  ],
);

final _suzuki = VehicleBrandGroup(
  brand: 'Suzuki',
  type: VehicleType.motorbike,
  vehicles: [
    Vehicle(
      name: 'Raider R150',
      brand: 'Suzuki',
      tankCapacity: 4.5,
      emoji: '🏍️',
      description: 'Xe côn thể thao độc đáo',
      type: VehicleType.motorbike,
      engineCC: 147.3,
      fuelGrades: [VehicleFuelGrade.ron95],
      priceVND: 49990000,
    ),
    Vehicle(
      name: 'Address',
      brand: 'Suzuki',
      tankCapacity: 5.2,
      emoji: '🛵',
      description: 'Xe ga đô thị tiết kiệm',
      type: VehicleType.motorbike,
      engineCC: 112.8,
      fuelGrades: [VehicleFuelGrade.ron92, VehicleFuelGrade.ron95],
      priceVND: 28990000,
    ),
  ],
);

final _sym = VehicleBrandGroup(
  brand: 'SYM',
  type: VehicleType.motorbike,
  vehicles: [
    Vehicle(
      name: 'Attila Elizabeth',
      brand: 'SYM',
      tankCapacity: 5.0,
      emoji: '🛵',
      description: 'Xe ga nữ hoàng đường phố',
      type: VehicleType.motorbike,
      engineCC: 124.6,
      fuelGrades: [VehicleFuelGrade.ron92, VehicleFuelGrade.ron95],
      priceVND: 29900000,
    ),
    Vehicle(
      name: 'Star SR',
      brand: 'SYM',
      tankCapacity: 5.5,
      emoji: '🛵',
      description: 'Xe ga phổ thông bền bỉ',
      type: VehicleType.motorbike,
      engineCC: 124.6,
      fuelGrades: [VehicleFuelGrade.ron92, VehicleFuelGrade.ron95],
      priceVND: 26900000,
    ),
  ],
);

// ─────────────────────────────────────────────────────────────────────────────
// CAR DATA
// ─────────────────────────────────────────────────────────────────────────────

final _toyota = VehicleBrandGroup(
  brand: 'Toyota',
  type: VehicleType.car,
  vehicles: [
    Vehicle(
      name: 'Vios',
      brand: 'Toyota',
      tankCapacity: 42.0,
      emoji: '🚗',
      description: 'Sedan phổ thông tiết kiệm',
      type: VehicleType.car,
      engineCC: 1496,
      transmission: 'CVT tự động',
      fuelGrades: [VehicleFuelGrade.ron95],
      priceVND: 479000000,
    ),
    Vehicle(
      name: 'Corolla Cross',
      brand: 'Toyota',
      tankCapacity: 43.0,
      emoji: '🚙',
      description: 'Crossover hybrid tiết kiệm',
      type: VehicleType.car,
      engineCC: 1798,
      transmission: 'e-CVT hybrid',
      fuelGrades: [VehicleFuelGrade.ron95],
      priceVND: 820000000,
    ),
    Vehicle(
      name: 'Innova Cross',
      brand: 'Toyota',
      tankCapacity: 52.0,
      emoji: '🚐',
      description: 'MPV 7 chỗ hybrid cao cấp',
      type: VehicleType.car,
      engineCC: 1987,
      transmission: 'e-CVT hybrid',
      fuelGrades: [VehicleFuelGrade.ron95],
      priceVND: 990000000,
    ),
    Vehicle(
      name: 'Fortuner',
      brand: 'Toyota',
      tankCapacity: 80.0,
      emoji: '🚙',
      description: 'SUV 7 chỗ off-road mạnh mẽ',
      type: VehicleType.car,
      engineCC: 2755,
      transmission: '6 cấp tự động',
      fuelGrades: [VehicleFuelGrade.diesel],
      priceVND: 1060000000,
    ),
    Vehicle(
      name: 'Raize',
      brand: 'Toyota',
      tankCapacity: 36.0,
      emoji: '🚗',
      description: 'Mini SUV đô thị năng động',
      type: VehicleType.car,
      engineCC: 998,
      transmission: 'CVT tự động',
      fuelGrades: [VehicleFuelGrade.ron92, VehicleFuelGrade.ron95],
      priceVND: 527000000,
    ),
  ],
);

final _hyundai = VehicleBrandGroup(
  brand: 'Hyundai',
  type: VehicleType.car,
  vehicles: [
    Vehicle(
      name: 'Accent',
      brand: 'Hyundai',
      tankCapacity: 45.0,
      emoji: '🚗',
      description: 'Sedan hạng B thực dụng',
      type: VehicleType.car,
      engineCC: 1368,
      transmission: '6 cấp tự động',
      fuelGrades: [VehicleFuelGrade.ron92, VehicleFuelGrade.ron95],
      priceVND: 439000000,
    ),
    Vehicle(
      name: 'Creta',
      brand: 'Hyundai',
      tankCapacity: 50.0,
      emoji: '🚙',
      description: 'B-SUV trẻ trung năng động',
      type: VehicleType.car,
      engineCC: 1482,
      transmission: 'IVT tự động',
      fuelGrades: [VehicleFuelGrade.ron95],
      priceVND: 620000000,
    ),
    Vehicle(
      name: 'Tucson',
      brand: 'Hyundai',
      tankCapacity: 54.0,
      emoji: '🚙',
      description: 'C-SUV thiết kế đẹp',
      type: VehicleType.car,
      engineCC: 1598,
      transmission: '7 cấp DCT',
      fuelGrades: [VehicleFuelGrade.ron95],
      priceVND: 825000000,
    ),
    Vehicle(
      name: 'Santa Fe',
      brand: 'Hyundai',
      tankCapacity: 67.0,
      emoji: '🚙',
      description: 'SUV 7 chỗ sang trọng',
      type: VehicleType.car,
      engineCC: 1999,
      transmission: '8 cấp tự động',
      fuelGrades: [VehicleFuelGrade.ron95],
      priceVND: 1075000000,
    ),
  ],
);

final _kia = VehicleBrandGroup(
  brand: 'Kia',
  type: VehicleType.car,
  vehicles: [
    Vehicle(
      name: 'Morning',
      brand: 'Kia',
      tankCapacity: 35.0,
      emoji: '🚗',
      description: 'City car nhỏ gọn kinh tế',
      type: VehicleType.car,
      engineCC: 998,
      transmission: '4 cấp tự động',
      fuelGrades: [VehicleFuelGrade.ron92, VehicleFuelGrade.ron95],
      priceVND: 369000000,
    ),
    Vehicle(
      name: 'Seltos',
      brand: 'Kia',
      tankCapacity: 50.0,
      emoji: '🚙',
      description: 'B-SUV phong cách hiện đại',
      type: VehicleType.car,
      engineCC: 1482,
      transmission: '7 cấp DCT',
      fuelGrades: [VehicleFuelGrade.ron95],
      priceVND: 649000000,
    ),
    Vehicle(
      name: 'Sorento',
      brand: 'Kia',
      tankCapacity: 67.0,
      emoji: '🚙',
      description: 'SUV 7 chỗ đẳng cấp',
      type: VehicleType.car,
      engineCC: 1598,
      transmission: '6 cấp tự động',
      fuelGrades: [VehicleFuelGrade.ron95],
      priceVND: 1059000000,
    ),
  ],
);

final _mazda = VehicleBrandGroup(
  brand: 'Mazda',
  type: VehicleType.car,
  vehicles: [
    Vehicle(
      name: 'Mazda2',
      brand: 'Mazda',
      tankCapacity: 44.0,
      emoji: '🚗',
      description: 'Sedan hạng B thiết kế Nhật',
      type: VehicleType.car,
      engineCC: 1496,
      transmission: '6 cấp tự động',
      fuelGrades: [VehicleFuelGrade.ron95],
      priceVND: 509000000,
    ),
    Vehicle(
      name: 'CX-5',
      brand: 'Mazda',
      tankCapacity: 56.0,
      emoji: '🚙',
      description: 'C-SUV sang trọng bán chạy nhất',
      type: VehicleType.car,
      engineCC: 1998,
      transmission: '6 cấp tự động',
      fuelGrades: [VehicleFuelGrade.ron95],
      priceVND: 789000000,
    ),
    Vehicle(
      name: 'CX-8',
      brand: 'Mazda',
      tankCapacity: 58.0,
      emoji: '🚙',
      description: 'SUV 7 chỗ sang trọng',
      type: VehicleType.car,
      engineCC: 2488,
      transmission: '6 cấp tự động',
      fuelGrades: [VehicleFuelGrade.ron95],
      priceVND: 1029000000,
    ),
  ],
);

final _mitsubishi = VehicleBrandGroup(
  brand: 'Mitsubishi',
  type: VehicleType.car,
  vehicles: [
    Vehicle(
      name: 'Xpander',
      brand: 'Mitsubishi',
      tankCapacity: 45.0,
      emoji: '🚐',
      description: 'MPV 7 chỗ đa dụng',
      type: VehicleType.car,
      engineCC: 1499,
      transmission: '4 cấp tự động',
      fuelGrades: [VehicleFuelGrade.ron92, VehicleFuelGrade.ron95],
      priceVND: 599000000,
    ),
    Vehicle(
      name: 'Xforce',
      brand: 'Mitsubishi',
      tankCapacity: 48.0,
      emoji: '🚙',
      description: 'B-SUV thể thao mới nhất',
      type: VehicleType.car,
      engineCC: 1499,
      transmission: 'CVT tự động',
      fuelGrades: [VehicleFuelGrade.ron95],
      priceVND: 669000000,
    ),
    Vehicle(
      name: 'Outlander',
      brand: 'Mitsubishi',
      tankCapacity: 60.0,
      emoji: '🚙',
      description: 'SUV PHEV tiết kiệm',
      type: VehicleType.car,
      engineCC: 2360,
      transmission: 'CVT tự động',
      fuelGrades: [VehicleFuelGrade.ron95],
      priceVND: 1095000000,
    ),
  ],
);

final _ford = VehicleBrandGroup(
  brand: 'Ford',
  type: VehicleType.car,
  vehicles: [
    Vehicle(
      name: 'Territory',
      brand: 'Ford',
      tankCapacity: 53.0,
      emoji: '🚙',
      description: 'SUV 5 chỗ công nghệ cao',
      type: VehicleType.car,
      engineCC: 1499,
      transmission: '7 cấp DCT',
      fuelGrades: [VehicleFuelGrade.ron95],
      priceVND: 822000000,
    ),
    Vehicle(
      name: 'Everest',
      brand: 'Ford',
      tankCapacity: 80.0,
      emoji: '🚙',
      description: 'SUV 7 chỗ địa hình mạnh mẽ',
      type: VehicleType.car,
      engineCC: 1996,
      transmission: '10 cấp tự động',
      fuelGrades: [VehicleFuelGrade.diesel],
      priceVND: 1219000000,
    ),
    Vehicle(
      name: 'Ranger',
      brand: 'Ford',
      tankCapacity: 80.0,
      emoji: '🛻',
      description: 'Bán tải bán chạy số 1 Việt Nam',
      type: VehicleType.car,
      engineCC: 1996,
      transmission: '10 cấp tự động',
      fuelGrades: [VehicleFuelGrade.diesel],
      priceVND: 659000000,
    ),
  ],
);

final _vinfast = VehicleBrandGroup(
  brand: 'VinFast',
  type: VehicleType.car,
  vehicles: [
    Vehicle(
      name: 'VF 3',
      brand: 'VinFast',
      tankCapacity: 0.0,
      emoji: '⚡',
      description: 'Mini SUV điện ~210km/sạc',
      type: VehicleType.car,
      fuelGrades: [VehicleFuelGrade.electric],
      priceVND: 235000000,
    ),
    Vehicle(
      name: 'VF 5',
      brand: 'VinFast',
      tankCapacity: 0.0,
      emoji: '⚡',
      description: 'A-SUV điện ~326km/sạc',
      type: VehicleType.car,
      fuelGrades: [VehicleFuelGrade.electric],
      priceVND: 458000000,
    ),
    Vehicle(
      name: 'VF 6',
      brand: 'VinFast',
      tankCapacity: 0.0,
      emoji: '⚡',
      description: 'B-SUV điện ~381km/sạc',
      type: VehicleType.car,
      fuelGrades: [VehicleFuelGrade.electric],
      priceVND: 675000000,
    ),
    Vehicle(
      name: 'VF 7',
      brand: 'VinFast',
      tankCapacity: 0.0,
      emoji: '⚡',
      description: 'C-SUV điện ~431km/sạc',
      type: VehicleType.car,
      fuelGrades: [VehicleFuelGrade.electric],
      priceVND: 850000000,
    ),
  ],
);

// ─────────────────────────────────────────────────────────────────────────────
// EXPORTED LISTS
// ─────────────────────────────────────────────────────────────────────────────

final List<VehicleBrandGroup> motorbikeGroups = [
  _honda,
  _yamaha,
  _suzuki,
  _sym,
];

final List<VehicleBrandGroup> carGroups = [
  _toyota,
  _hyundai,
  _kia,
  _mazda,
  _mitsubishi,
  _ford,
  _vinfast,
];
