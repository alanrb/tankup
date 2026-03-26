import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tankup/screens/screen1_vehicle.dart';

class DisclaimerScreen extends StatelessWidget {
  const DisclaimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 56,
                  color: Colors.amber,
                ),
                const SizedBox(height: 16),
                Text(
                  'Lưu ý quan trọng',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 20),
                _BulletItem(
                  'Giá xăng dầu trong app được lấy từ nguồn '
                  'KHÔNG chính thức.',
                ),
                const SizedBox(height: 12),
                _BulletItem(
                  'Số liệu chỉ mang tính tham khảo và có thể '
                  'không chính xác.',
                ),
                const SizedBox(height: 12),
                _BulletItem(
                  'App này chỉ để vui chơi, không dùng cho '
                  'mục đích tài chính.',
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red.shade700, width: 1),
                  ),
                  child: const Text(
                    'Chúng tôi KHÔNG chịu trách nhiệm về bất kỳ '
                    'quyết định hay tổn thất nào phát sinh từ việc '
                    'sử dụng thông tin trong app này.',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => SystemNavigator.pop(),
                        child: const Text('Thoát'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const Screen1Vehicle(),
                            ),
                          );
                        },
                        child: const Text('Tiếp tục →'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BulletItem extends StatelessWidget {
  const _BulletItem(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('• ', style: TextStyle(fontSize: 16)),
        Expanded(
          child: Text(text, style: const TextStyle(fontSize: 15, height: 1.5)),
        ),
      ],
    );
  }
}
