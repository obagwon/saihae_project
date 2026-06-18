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

  PersonalityType _suggestedType(PersonalityType type) {
    final index = personalityTypes.indexWhere((item) => item.id == type.id);
    return personalityTypes[(index + 1) % personalityTypes.length];
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
      padding: AppSpacing.screenPadding,
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
        _ComparePreviewCard(
          myType: savedType,
          suggestedType: savedType == null ? personalityTypes.first : _suggestedType(savedType!),
          onStartTest: startTest,
        ),
        const SizedBox(height: 24),
        SectionTitle(
          title: '전체 성향별 관계 카드',
          description: '다른 성향과 편안하게 가까워지는 방법도 함께 살펴보세요.',
        ),
        const SizedBox(height: AppSpacing.md),
        _RelationTypeGrid(
          types: personalityTypes,
          cardColorForIndex: _getCardColor,
        ),
      ],
    );
  }
}

class _ComparePreviewCard extends StatelessWidget {
  final PersonalityType? myType;
  final PersonalityType suggestedType;
  final VoidCallback onStartTest;

  const _ComparePreviewCard({
    required this.myType,
    required this.suggestedType,
    required this.onStartTest,
  });

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      tone: SoftCardTone.sky,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.compare_arrows_rounded, color: AppColors.navy),
              const SizedBox(width: AppSpacing.xs),
              Text('관계 비교 미리보기', style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _CompareMiniCard(
                  label: '나',
                  title: myType?.name ?? '아직 비어 있어요',
                  description: myType?.subtitle ?? '테스트 후 내 카드를 자동으로 불러와요.',
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: Icon(Icons.favorite_rounded, color: AppColors.navy, size: 20),
              ),
              Expanded(
                child: _CompareMiniCard(
                  label: '상대 예시',
                  title: suggestedType.name,
                  description: suggestedType.subtitle,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            myType == null
                ? '먼저 내 관계 성향 카드를 만들면 공통점, 차이점, 관계 팁을 더 자연스럽게 볼 수 있어요.'
                : '두 유형의 공통점과 차이를 카드처럼 비교해 관계의 속도를 맞춰보세요.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (myType == null) ...[
            const SizedBox(height: AppSpacing.md),
            RoundedButton(
              text: '내 카드 만들기',
              icon: Icons.arrow_forward_rounded,
              onPressed: onStartTest,
            ),
          ],
        ],
      ),
    );
  }
}

class _CompareMiniCard extends StatelessWidget {
  final String label;
  final String title;
  final String description;

  const _CompareMiniCard({
    required this.label,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(AppRadii.compactCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.navy),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
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

class _RelationTypeGrid extends StatelessWidget {
  final List<PersonalityType> types;
  final Color Function(int index) cardColorForIndex;

  const _RelationTypeGrid({
    required this.types,
    required this.cardColorForIndex,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: types.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
        mainAxisExtent: 236,
      ),
      itemBuilder: (context, index) {
        final type = types[index];

        return _RelationTypePreviewCard(
          type: type,
          backgroundColor: cardColorForIndex(index),
          onTap: () => _showRelationTypeDetailSheet(context, type),
        );
      },
    );
  }
}

class _RelationTypePreviewCard extends StatelessWidget {
  final PersonalityType type;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _RelationTypePreviewCard({
    required this.type,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      backgroundColor: backgroundColor,
      borderRadius: AppRadii.compactCard,
      padding: const EdgeInsets.all(AppSpacing.sm),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: _PersonalityTypeImage(
                type: type,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            type.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            type.subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

Future<void> _showRelationTypeDetailSheet(
  BuildContext context,
  PersonalityType type,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _RelationTypeDetailSheet(type: type),
  );
}

class _RelationTypeDetailSheet extends StatelessWidget {
  final PersonalityType type;

  const _RelationTypeDetailSheet({required this.type});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.78,
      minChildSize: 0.48,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenHorizontal,
              AppSpacing.sm,
              AppSpacing.screenHorizontal,
              AppSpacing.xl,
            ),
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.line,
                    borderRadius: BorderRadius.circular(AppRadii.chip),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton.filledTonal(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                  tooltip: '닫기',
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadii.card),
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: _PersonalityTypeImage(
                    type: type,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                type.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                type.subtitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              _MiniSection(
                icon: Icons.favorite_rounded,
                title: '이런 사람과 잘 맞아요',
                items: type.goodMatches,
              ),
              const SizedBox(height: AppSpacing.md),
              _MiniSection(
                icon: Icons.tips_and_updates_rounded,
                title: '친해지는 방법',
                items: type.relationTips,
              ),
              const SizedBox(height: AppSpacing.md),
              _MiniSection(
                icon: Icons.spa_rounded,
                title: '조심하면 좋은 부분',
                items: type.avoidTips,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PersonalityTypeImage extends StatelessWidget {
  final PersonalityType type;
  final BoxFit fit;
  final double width;
  final double height;

  const _PersonalityTypeImage({
    required this.type,
    required this.fit,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _personalityCardImagePath(type),
      fit: fit,
      width: width,
      height: height,
      semanticLabel: '${type.name} 관계 카드 이미지',
      errorBuilder: (context, error, stackTrace) {
        return _PersonalityTypeImageFallback(type: type);
      },
    );
  }
}

class _PersonalityTypeImageFallback extends StatelessWidget {
  final PersonalityType type;

  const _PersonalityTypeImageFallback({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.white.withValues(alpha: 0.62),
      child: Center(
        child: Icon(_iconForType(type), color: AppColors.navy, size: 38),
      ),
    );
  }
}

String _personalityCardImagePath(PersonalityType type) {
  return 'images/personality_cards/${type.id}.png';
}

IconData _iconForType(PersonalityType type) {
  switch (type.icon) {
    case IconDataCode.compass:
      return Icons.explore_rounded;
    case IconDataCode.heart:
      return Icons.favorite_rounded;
    case IconDataCode.spark:
      return Icons.auto_awesome_rounded;
    case IconDataCode.rainbow:
      return Icons.wb_sunny_rounded;
    case IconDataCode.anchor:
      return Icons.anchor_rounded;
    case IconDataCode.nest:
      return Icons.spa_rounded;
    case IconDataCode.moon:
      return Icons.nightlight_round;
    case IconDataCode.lantern:
      return Icons.emoji_objects_rounded;
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
