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
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '사이해에 오신 걸\n환영해요',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 12),
              Text(
                '사이해는 마음을 판단하기보다, 오늘의 나를 조금 더 부드럽게 이해하도록 돕는 기록 앱이에요.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              const _OnboardingInfoCard(
                icon: Icons.favorite_rounded,
                title: '사이를 이해하고 나를 이해하기',
                description: '사이해는 감정, 성향, 관계 스타일을 가볍게 돌아보는 자기이해 가이드예요.',
                color: AppColors.softPink,
              ),
              const SizedBox(height: 14),
              const _OnboardingInfoCard(
                icon: Icons.edit_note_rounded,
                title: '오늘의 마음을 짧게 기록하기',
                description: '감정과 강도, 한 줄 메모를 남기면 작은 통계와 행동 추천을 볼 수 있어요.',
                color: AppColors.softYellow,
              ),
              const SizedBox(height: 14),
              const _OnboardingInfoCard(
                icon: Icons.info_outline_rounded,
                title: '전문 심리 진단이 아니에요',
                description: '사이해의 테스트와 추천은 상담, 진단, 치료 목적이 아닌 일상 속 자기이해 참고용이에요. 힘든 감정이 오래 이어지면 주변 사람이나 전문 기관의 도움을 고려해 주세요.',
                color: AppColors.softBeige,
              ),
              const SizedBox(height: 24),
              RoundedButton(
                text: isSaving ? '시작 준비 중...' : '시작하기',
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
              color: AppColors.white.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
