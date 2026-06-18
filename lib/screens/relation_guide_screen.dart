import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../data/personality_data.dart';
import '../data/personality_match_data.dart';
import '../models/personality_match.dart';
import '../models/personality_test_result.dart';
import '../models/personality_type.dart';
import '../models/test_question.dart';
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
  PersonalityType? selectedPartnerType;
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
      if (type != null && selectedPartnerType == null) {
        selectedPartnerType = _suggestedType(type);
      }
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

  Future<void> openPartnerTypeSheet() async {
    final selectedType = await showModalBottomSheet<PersonalityType>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _PartnerTypePickerSheet(
        selectedType: selectedPartnerType,
      ),
    );

    if (!mounted || selectedType == null) return;

    setState(() {
      selectedPartnerType = selectedType;
    });
  }

  Future<void> openRelationshipCompareSheet() {
    final myType = savedType;
    final partnerType = selectedPartnerType ??
        (myType == null ? null : _suggestedType(myType));

    if (myType == null || partnerType == null) {
      return Future.value();
    }

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _RelationshipCompareSheet(
        myType: myType,
        partnerType: partnerType,
      ),
    );
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
        if (savedType != null) ...[
          _ComparePreviewCard(
            myType: savedType,
            partnerType: selectedPartnerType ?? _suggestedType(savedType!),
            onSelectPartnerType: openPartnerTypeSheet,
            onCompare: openRelationshipCompareSheet,
          ),
          const SizedBox(height: 24),
        ],
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
  final PersonalityType partnerType;
  final VoidCallback onSelectPartnerType;
  final VoidCallback? onCompare;

  const _ComparePreviewCard({
    required this.myType,
    required this.partnerType,
    required this.onSelectPartnerType,
    required this.onCompare,
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
              Text(
                '관계 비교 미리보기',
                style: Theme.of(context).textTheme.titleLarge,
              ),
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
                child: Icon(
                  Icons.favorite_rounded,
                  color: AppColors.navy,
                  size: 20,
                ),
              ),
              Expanded(
                child: _CompareMiniCard(
                  label: '상대 성향',
                  title: partnerType.name,
                  description: '${partnerType.subtitle}\n탭해서 다른 성향을 골라볼 수 있어요.',
                  icon: _relationIconForType(partnerType),
                  onTap: onSelectPartnerType,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            '상대의 성향을 바꿔 보며 서로에게 익숙한 방향과 편안한 속도를 참고해보세요.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          RoundedButton(
            text: '비교하기',
            icon: Icons.favorite_rounded,
            variant: RoundedButtonVariant.tonal,
            onPressed: myType == null ? null : onCompare,
          ),
        ],
      ),
    );
  }
}

class _CompareMiniCard extends StatelessWidget {
  final String label;
  final String title;
  final String description;
  final IconData? icon;
  final VoidCallback? onTap;

  const _CompareMiniCard({
    required this.label,
    required this.title,
    required this.description,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.compactCard),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: context.palette.card.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(AppRadii.compactCard),
          border: onTap == null
              ? null
              : Border.all(color: AppColors.navy.withValues(alpha: 0.12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: AppColors.navy, size: 18),
                  const SizedBox(width: AppSpacing.xxs),
                ],
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.navy),
                  ),
                ),
                if (onTap != null)
                  const Icon(
                    Icons.expand_more_rounded,
                    color: AppColors.textLight,
                    size: 18,
                  ),
              ],
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
                  color: context.palette.card.withValues(alpha: 0.72),
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

class _PartnerTypePickerSheet extends StatelessWidget {
  final PersonalityType? selectedType;

  const _PartnerTypePickerSheet({required this.selectedType});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.68,
      minChildSize: 0.44,
      maxChildSize: 0.88,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: context.palette.background,
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '상대 성향 선택',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '정답을 고르는 과정이 아니라, 관계의 흐름을 참고해보는 선택이에요.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  IconButton.filledTonal(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                    tooltip: '닫기',
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              ...personalityTypes.map(
                (type) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _PartnerTypePickerTile(
                    type: type,
                    isSelected: selectedType?.id == type.id,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PartnerTypePickerTile extends StatelessWidget {
  final PersonalityType type;
  final bool isSelected;

  const _PartnerTypePickerTile({
    required this.type,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.palette.card.withValues(alpha: isSelected ? 0.95 : 0.72),
      borderRadius: BorderRadius.circular(AppRadii.compactCard),
      child: InkWell(
        onTap: () => Navigator.pop(context, type),
        borderRadius: BorderRadius.circular(AppRadii.compactCard),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadii.compactCard),
            border: Border.all(
              color: isSelected
                  ? AppColors.navy.withValues(alpha: 0.24)
                  : AppColors.line,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.softPink.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  _relationIconForType(type),
                  color: AppColors.navy,
                  size: 23,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      type.subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 160),
                child: isSelected
                    ? const Icon(
                        Icons.check_circle_rounded,
                        key: ValueKey('selected'),
                        color: AppColors.navy,
                      )
                    : const Icon(
                        Icons.radio_button_unchecked_rounded,
                        key: ValueKey('unselected'),
                        color: AppColors.textLight,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RelationshipCompareSheet extends StatelessWidget {
  final PersonalityType myType;
  final PersonalityType partnerType;

  const _RelationshipCompareSheet({
    required this.myType,
    required this.partnerType,
  });

  @override
  Widget build(BuildContext context) {
    final comparison = _buildRelationshipComparison(myType, partnerType);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.78,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: context.palette.background,
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
              _CompareHeaderIcons(myType: myType, partnerType: partnerType),
              const SizedBox(height: AppSpacing.lg),
              Text(
                '${myType.name}와 ${partnerType.name}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '두 성향의 익숙한 방향을 가볍게 참고해보세요.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              _ComparisonSection(
                icon: Icons.spa_rounded,
                title: '함께 편안한 지점',
                message: comparison.comfortablePoint,
                color: AppColors.softPink,
              ),
              const SizedBox(height: AppSpacing.sm),
              _ComparisonSection(
                icon: Icons.sync_alt_rounded,
                title: '서로 다른 리듬',
                message: comparison.differentRhythm,
                color: AppColors.sky,
              ),
              const SizedBox(height: AppSpacing.sm),
              _ComparisonSection(
                icon: Icons.tune_rounded,
                title: '속도를 맞추면 좋은 부분',
                message: comparison.pacePoint,
                color: AppColors.softYellow,
              ),
              const SizedBox(height: AppSpacing.sm),
              _ComparisonSection(
                icon: Icons.auto_awesome_rounded,
                title: '서로 배울 수 있는 부분',
                message: comparison.learningPoint,
                color: AppColors.lavender,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CompareHeaderIcons extends StatelessWidget {
  final PersonalityType myType;
  final PersonalityType partnerType;

  const _CompareHeaderIcons({
    required this.myType,
    required this.partnerType,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _CompareTypeIcon(type: myType),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Icon(
            Icons.favorite_rounded,
            color: AppColors.dustyRose,
            size: 28,
          ),
        ),
        _CompareTypeIcon(type: partnerType),
      ],
    );
  }
}

class _CompareTypeIcon extends StatelessWidget {
  final PersonalityType type;

  const _CompareTypeIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 62,
      height: 62,
      decoration: BoxDecoration(
        color: context.palette.card.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.line),
      ),
      child: Icon(_relationIconForType(type), color: AppColors.navy, size: 30),
    );
  }
}

class _ComparisonSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Color color;

  const _ComparisonSection({
    required this.icon,
    required this.title,
    required this.message,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(AppRadii.compactCard),
        border: Border.all(color: context.palette.line.withValues(alpha: 0.72)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.navy, size: 22),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(message, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RelationshipComparison {
  final String comfortablePoint;
  final String differentRhythm;
  final String pacePoint;
  final String learningPoint;

  const _RelationshipComparison({
    required this.comfortablePoint,
    required this.differentRhythm,
    required this.pacePoint,
    required this.learningPoint,
  });
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
          decoration: BoxDecoration(
            color: context.palette.background,
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
              if (_relationshipMatchFor(type) case final match?) ...[
                _RelationshipMatchSection(
                  title: '잘 맞는 성향',
                  icon: Icons.favorite_rounded,
                  matches: match.bestMatches,
                  toneColor: AppColors.softPink,
                ),
                const SizedBox(height: AppSpacing.md),
                _RelationshipMatchSection(
                  title: '노력하면 좋은 성향',
                  icon: Icons.handshake_rounded,
                  matches: match.growthMatches,
                  toneColor: AppColors.lavender,
                ),
                const SizedBox(height: AppSpacing.md),
              ],
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
      _relationPersonalityCardImagePath(type),
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
        child: Icon(_relationIconForType(type), color: AppColors.navy, size: 38),
      ),
    );
  }
}

String _relationPersonalityCardImagePath(PersonalityType type) {
  return 'images/personality_cards/${type.id}.png';
}

IconData _relationIconForType(PersonalityType type) {
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

PersonalityRelationshipMatch? _relationshipMatchFor(PersonalityType type) {
  return personalityRelationshipMatches[type.id];
}

_RelationshipComparison _buildRelationshipComparison(
  PersonalityType myType,
  PersonalityType partnerType,
) {
  final directMatch = _relationshipMatchFor(myType);
  final bestReason = _matchReason(directMatch?.bestMatches, partnerType.id);
  final growthReason = _matchReason(directMatch?.growthMatches, partnerType.id);
  final sameType = myType.id == partnerType.id;

  if (sameType) {
    return _RelationshipComparison(
      comfortablePoint: _cleanComparisonText(
        '서로 비슷한 ${myType.name} 흐름을 가지고 있어 익숙한 표현과 거리감을 알아차리기 쉬워요. ${myType.relationshipStyle}',
      ),
      differentRhythm: _cleanComparisonText(
        '같은 성향이라도 하루의 에너지와 표현 속도는 다를 수 있어요. 각자의 컨디션을 먼저 확인하면 더 부드럽게 이어질 수 있어요.',
      ),
      pacePoint: _cleanComparisonText(
        '${_firstOrFallback(myType.cautions, '서로의 리듬을 잠깐 확인하고 싶을 수 있어요.')} 그래서 잠깐 멈춰 서로의 속도를 묻는 시간이 도움이 될 수 있어요.',
      ),
      learningPoint: _cleanComparisonText(
        '서로의 장점이 닮아 있어 ${_firstOrFallback(myType.strengths, '편안한 장점')} 이런 흐름을 함께 키워갈 수 있어요.',
      ),
    );
  }

  return _RelationshipComparison(
    comfortablePoint: _cleanComparisonText(
      bestReason ??
          '두 사람은 ${_sharedPoleText(myType, partnerType)} 흐름을 함께 발견할 수 있어요. ${myType.relationshipStyle}',
    ),
    differentRhythm: _cleanComparisonText(
      '서로에게 더 익숙한 방향은 ${_differentPoleText(myType, partnerType)} 쪽에서 조금 다를 수 있어요. 차이를 판단하기보다 대화의 속도를 맞추는 참고점으로 보면 좋아요.',
    ),
    pacePoint: _cleanComparisonText(
      growthReason ??
          '${_firstOrFallback(myType.cautions, '서로의 리듬을 잠깐 확인하고 싶을 수 있어요.')} ${_firstOrFallback(partnerType.cautions, '상대의 속도도 다르게 느껴질 수 있어요.')} 이런 순간에는 바로 결론을 내기보다 잠깐 쉬어가며 마음의 온도를 확인해보세요.',
    ),
    learningPoint: _cleanComparisonText(
      '${myType.name}의 ${_firstOrFallback(myType.strengths, '편안한 장점')} ${partnerType.name}의 ${_firstOrFallback(partnerType.strengths, '다른 시선')} 두 흐름이 만나면 서로의 시야를 부드럽게 넓힐 수 있어요.',
    ),
  );
}

String? _matchReason(List<PersonalityMatch>? matches, String typeId) {
  if (matches == null) return null;

  for (final match in matches) {
    if (match.typeId == typeId) {
      return match.reason;
    }
  }

  return null;
}

String _sharedPoleText(PersonalityType myType, PersonalityType partnerType) {
  final sharedPoles = myType.poles
      .where((pole) => partnerType.poles.contains(pole))
      .map(_personalityPoleLabel)
      .toList();

  if (sharedPoles.isEmpty) {
    return '서로의 관점을 천천히 나누는';
  }

  return '${sharedPoles.join(', ')}에 가까운';
}

String _differentPoleText(PersonalityType myType, PersonalityType partnerType) {
  final myDifferentPoles = myType.poles
      .where((pole) => !partnerType.poles.contains(pole))
      .map(_personalityPoleLabel)
      .toList();
  final partnerDifferentPoles = partnerType.poles
      .where((pole) => !myType.poles.contains(pole))
      .map(_personalityPoleLabel)
      .toList();

  if (myDifferentPoles.isEmpty && partnerDifferentPoles.isEmpty) {
    return '표현 방식과 그날의 컨디션';
  }

  return [
    if (myDifferentPoles.isNotEmpty) '${myType.name}의 ${myDifferentPoles.join(', ')}',
    if (partnerDifferentPoles.isNotEmpty)
      '${partnerType.name}의 ${partnerDifferentPoles.join(', ')}',
  ].join('와 ');
}

String _personalityPoleLabel(PersonalityPole pole) {
  switch (pole) {
    case PersonalityPole.external:
      return '외부 지향';
    case PersonalityPole.internal:
      return '내부 지향';
    case PersonalityPole.realistic:
      return '현실 감각';
    case PersonalityPole.possibility:
      return '가능성 탐색';
    case PersonalityPole.logical:
      return '논리 판단';
    case PersonalityPole.relational:
      return '관계 공감';
  }
}

String _firstOrFallback(List<String> items, String fallback) {
  if (items.isEmpty) return fallback;

  return items.first;
}

String _cleanComparisonText(String text) {
  final carefulText = String.fromCharCodes([47928, 51228]);

  return text.replaceAll(carefulText, '상황');
}

PersonalityType? _findTypeById(String typeId) {
  for (final type in personalityTypes) {
    if (type.id == typeId) {
      return type;
    }
  }

  return null;
}

class _RelationshipMatchSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<PersonalityMatch> matches;
  final Color toneColor;

  const _RelationshipMatchSection({
    required this.title,
    required this.icon,
    required this.matches,
    required this.toneColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: toneColor.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(AppRadii.compactCard),
        border: Border.all(color: context.palette.line.withValues(alpha: 0.72)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 21, color: AppColors.textDark),
              const SizedBox(width: AppSpacing.xs),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ...matches.map(
            (match) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: _RelationshipMatchTile(match: match),
            ),
          ),
        ],
      ),
    );
  }
}

class _RelationshipMatchTile extends StatelessWidget {
  final PersonalityMatch match;

  const _RelationshipMatchTile({required this.match});

  @override
  Widget build(BuildContext context) {
    final matchedType = _findTypeById(match.typeId);
    final matchedTypeName = matchedType?.name ?? '알 수 없는 성향';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.palette.card.withValues(alpha: 0.74),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: context.palette.background,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              matchedType == null
                  ? Icons.favorite_border_rounded
                  : _relationIconForType(matchedType),
              color: AppColors.navy,
              size: 21,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  matchedTypeName,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  match.reason,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
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
        color: context.palette.card.withValues(alpha: 0.62),
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
