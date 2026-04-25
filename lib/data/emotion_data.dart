class EmotionGuide {
  final String name;
  final String emoji;
  final String message;
  final String tip;

  const EmotionGuide({
    required this.name,
    required this.emoji,
    required this.message,
    required this.tip,
  });
}

const List<EmotionGuide> emotionGuides = [
  EmotionGuide(
    name: '편안해요',
    emoji: '🌿',
    message: '오늘은 마음의 속도가 비교적 안정적인 날일 수 있어요.',
    tip: '이 편안함을 오래 기억할 수 있도록 짧게 기록해보세요.',
  ),
  EmotionGuide(
    name: '지쳤어요',
    emoji: '☁️',
    message: '해야 할 일이 많거나 마음을 오래 쓰느라 에너지가 줄어든 상태일 수 있어요.',
    tip: '큰 계획보다 물 마시기, 씻기, 10분 쉬기처럼 작은 회복부터 시작해보세요.',
  ),
  EmotionGuide(
    name: '복잡해요',
    emoji: '🫧',
    message: '생각이 많아져서 마음이 한곳에 머무르기 어려운 상태일 수 있어요.',
    tip: '머릿속에 있는 생각을 좋고 나쁨 없이 한 줄씩 적어보세요.',
  ),
  EmotionGuide(
    name: '설레요',
    emoji: '✨',
    message: '기대되는 일이나 새로운 가능성에 마음이 반응하고 있을 수 있어요.',
    tip: '이 감정을 잘 살려서 오늘 해보고 싶은 작은 행동 하나를 정해보세요.',
  ),
  EmotionGuide(
    name: '불안해요',
    emoji: '🌙',
    message: '아직 일어나지 않은 일까지 미리 걱정하고 있을 수 있어요.',
    tip: '지금 당장 할 수 있는 일과 나중에 생각해도 되는 일을 나눠보세요.',
  ),
  EmotionGuide(
    name: '무기력해요',
    emoji: '🪑',
    message: '마음과 몸이 잠시 멈추고 싶어 하는 상태일 수 있어요.',
    tip: '완벽하게 해내려고 하기보다 가장 쉬운 행동 하나만 골라보세요.',
  ),
];