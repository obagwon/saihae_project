import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../data/personality_data.dart';
import '../models/personality_test_result.dart';
import '../models/personality_type.dart';
import '../services/local_storage_service.dart';
import '../widgets/rounded_button.dart';
import '../widgets/section_title.dart';
import '../widgets/soft_card.dart';
import 'test_screen.dart';

class RelationGuideScreen extends StatefulWidget {
  const RelationGuideScreen({super.key});

  @override
  State<RelationGuideScreen> createState() => _RelationGuideScreenState();
}

class _RelationGuideScreenState extends State<RelationGuideScreen> {
  final LocalStorageService storageService = LocalStorageService();

  PersonalityTestResult? savedResult;
  PersonalityType? savedType;
  bool isLoading = true;
  bool isReloading = false;

  @override
  void initState() {
    super.initState();
    loadSavedResult();
  }

  Future<void> loadSavedResult() async {
    if (isReloading) return;

    isReloading = true;
    final result = await storageService.getPersonalityTestResult();
    final type = _findPersonalityType(result?.typeId);

    if (!mounted) return;

    final hasChanged = savedResult?.typeId != result?.typeId ||
        savedResult?.testedAt != result?.testedAt ||
        savedType?.id != type?.id ||
        isLoading;

    if (!hasChanged) {
      isReloading = false;
      return;
    }

    setState(() {
      savedResult = result;
      savedType = type;
      isLoading = false;
      isReloading = false;
    });
  }

  PersonalityType? _findPersonalityType(String? typeId) {
    if (typeId == null) return null;

    for (final type in personalityTypes) {
      if (type.id == typeId) {
        return type;
      }
    }

    return null;
  }

  Future<void> startTest() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TestScreen(),
      ),
    );

    if (!mounted) return;

    await loadSavedResult();
  }

  Color _getCardColor(int index) {
    final colors = [
      AppColors.softYellow,
      AppColors.softPink,
      AppColors.softPeach,
      AppColors.softBeige,
      AppColors.white,
    ];

    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      loadSavedResult();
    });

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        Text(
          '사람마다 가까워지는\n속도는 달라요',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 12),
        Text(
          '상대의 성향을 이해하면 관계를 조금 더 편안하게 시작할 수 있어요.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 22),
        if (isLoading)
          const _SavedRelationLoadingCard()
        else if (savedType != null)
          _MyRelationGuideCard(type: savedType!)
        else
          _EmptyMyRelationGuideCard(onStartTest: startTest),
        const SizedBox(height: 24),
        SectionTitle(
          title: '전체 성향별 관계 가이드',
          description: '다른 성향과 편안하게 가까워지는 방법도 함께 살펴보세요.',
        ),
        ...List.generate(personalityTypes.length, (index) {
          final type = personalityTypes[index];

          return Padding(
            padding: EdgeInsets.only(
              bottom: index == personalityTypes.length - 1 ? 0 : 16,
            ),
            child: _RelationTypeCard(
              type: type,
              backgroundColor: _getCardColor(index),
            ),
          );
        }),
      ],
    );
  }
}

class _SavedRelationLoadingCard extends StatelessWidget {
  const _SavedRelationLoadingCard();

  @override
  Widget build(BuildContext context) {
    return const SoftCard(
      backgroundColor: AppColors.white,
      hasShadow: false,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class _MyRelationGuideCard extends StatelessWidget {
  final PersonalityType type;

  const _MyRelationGuideCard({required this.type});

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      backgroundColor: AppColors.softPink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '내 성향 관계 가이드',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${type.name} · ${type.subtitle}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _MiniSection(
            icon: Icons.tips_and_updates_rounded,
            title: '친해지는 방법',
            items: type.relationTips.take(2).toList(),
          ),
          const SizedBox(height: 14),
          _MiniSection(
            icon: Icons.spa_rounded,
            title: '조심하면 좋은 부분',
            items: type.avoidTips.take(2).toList(),
          ),
        ],
      ),
    );
  }
}

class _EmptyMyRelationGuideCard extends StatelessWidget {
  final VoidCallback onStartTest;

  const _EmptyMyRelationGuideCard({required this.onStartTest});

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      backgroundColor: AppColors.softYellow.withValues(alpha: 0.75),
      hasShadow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '내 관계 가이드는 아직 비어 있어요',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '성향 테스트를 하면 내 관계 가이드를 먼저 볼 수 있어요.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          RoundedButton(
            text: '성향 테스트 시작하기',
            icon: Icons.arrow_forward_rounded,
            onPressed: onStartTest,
          ),
        ],
      ),
    );
  }
}

class _RelationTypeCard extends StatelessWidget {
  final PersonalityType type;
  final Color backgroundColor;

  const _RelationTypeCard({
    required this.type,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      backgroundColor: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            type.name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            type.subtitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),

          _MiniSection(
            icon: Icons.favorite_rounded,
            title: '이런 사람과 잘 맞아요',
            items: type.goodMatches,
          ),

          const SizedBox(height: 16),

          _MiniSection(
            icon: Icons.tips_and_updates_rounded,
            title: '친해지는 방법',
            items: type.relationTips,
          ),

          const SizedBox(height: 16),

          _MiniSection(
            icon: Icons.spa_rounded,
            title: '조심하면 좋은 부분',
            items: type.avoidTips,
          ),
        ],
      ),
    );
  }
}

class _MiniSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> items;

  const _MiniSection({
    required this.icon,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 21,
                color: AppColors.textDark,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• '),
                  Expanded(
                    child: Text(
                      item,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
