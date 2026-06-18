import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../models/app_settings.dart';
import '../services/local_storage_service.dart';
import '../widgets/rounded_button.dart';
import '../widgets/soft_card.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onCompleted;

  const OnboardingScreen({
    super.key,
    required this.onCompleted,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final LocalStorageService storageService = LocalStorageService();
  bool isSaving = false;

  Future<void> completeOnboarding() async {
    if (isSaving) return;

    setState(() {
      isSaving = true;
    });

    var savedSuccessfully = true;

    try {
      await storageService.saveAppSettings(
        const AppSettings(
          onboardingCompleted: true,
          disclaimerAccepted: true,
        ),
      );
    } on Object {
      savedSuccessfully = false;
    }

    if (!mounted) return;

    if (!savedSuccessfully) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('설정 저장에 실패했지만 앱은 계속 이용할 수 있어요.'),
        ),
      );
    }

    widget.onCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _ConnectionHero(),
              const SizedBox(height: 26),
              Text(
                '사람과 사람 사이,\n조금 더 다정하게 이해해요',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 12),
              Text(
                '사이해는 감정과 성향, 관계의 차이와 공통점을 부드럽게 살펴보는 관계 이해 가이드예요.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              const _OnboardingInfoCard(
                icon: Icons.favorite_rounded,
                title: '사이를 이해하고 나를 이해하기',
                description: '성향과 관계 스타일을 카드처럼 읽기 쉽게 정리해줘요.',
                color: AppColors.blush,
              ),
              const SizedBox(height: 14),
              const _OnboardingInfoCard(
                icon: Icons.edit_note_rounded,
                title: '오늘의 마음을 짧게 기록하기',
                description: '감정과 강도, 한 줄 메모를 남기며 나의 흐름을 돌아볼 수 있어요.',
                color: AppColors.sky,
              ),
              const SizedBox(height: 14),
              const _OnboardingInfoCard(
                icon: Icons.info_outline_rounded,
                title: '가볍지만 신중한 자기이해',
                description: '상담이나 진단을 대신하는 목적이 아닌 일상 속 참고용이에요. 힘든 감정이 오래 이어지면 주변 사람이나 전문 기관의 도움을 고려해 주세요.',
                color: AppColors.lavender,
              ),
              const SizedBox(height: 24),
              RoundedButton(
                text: isSaving ? '시작 준비 중...' : '사이해 시작하기',
                icon: Icons.arrow_forward_rounded,
                onPressed: isSaving ? null : completeOnboarding,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConnectionHero extends StatelessWidget {
  const _ConnectionHero();

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      backgroundColor: AppColors.warmIvory,
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        height: 210,
        child: Stack(
          children: [
            Positioned(
              left: 18,
              top: 42,
              child: _BubbleNode(
                size: 96,
                color: AppColors.softPink,
                icon: Icons.chat_bubble_rounded,
              ),
            ),
            Positioned(
              right: 14,
              bottom: 34,
              child: _BubbleNode(
                size: 104,
                color: AppColors.sky,
                icon: Icons.favorite_rounded,
              ),
            ),
            Positioned(
              left: 108,
              top: 94,
              right: 100,
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [AppColors.softPink, AppColors.lavender, AppColors.sky],
                  ),
                ),
              ),
            ),
            const Positioned(left: 26, top: 14, child: _LightDot(size: 10)),
            const Positioned(right: 42, top: 24, child: _LightDot(size: 7)),
            const Positioned(left: 132, bottom: 20, child: _LightDot(size: 8)),
            Positioned(
              left: 0,
              bottom: 0,
              child: Text(
                'SAIHAE',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.textLight,
                      letterSpacing: 3,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BubbleNode extends StatelessWidget {
  final double size;
  final Color color;
  final IconData icon;

  const _BubbleNode({required this.size, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size * 0.36),
      ),
      child: Icon(icon, color: AppColors.navy, size: size * 0.36),
    );
  }
}

class _LightDot extends StatelessWidget {
  final double size;
  const _LightDot({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.softYellow,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _OnboardingInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _OnboardingInfoCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      backgroundColor: color,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.76),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppColors.navy),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(description, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
