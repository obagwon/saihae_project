import '../models/recommendation_item.dart';

class RecommendationData {
  static const RecommendationItem defaultRecommendation = RecommendationItem(
    title: '작은 숨 고르기',
    description: '지금 할 수 있는 일을 하나만 골라 마음의 속도를 천천히 맞춰봐요.',
    actionText: '물 한 잔 마시고 3번 깊게 숨 쉬기',
  );

  static RecommendationItem buildRecommendation({
    required String emotionId,
    required int intensity,
    String? personalityTypeId,
  }) {
    final recoveryMode = intensity >= 4;
    final expandMode = intensity <= 2;
    final base = _emotionRecommendations[emotionId] ?? defaultRecommendation;
    final personalityNote = _personalityNotes[personalityTypeId];
    final safetyNote = _safetyNoteFor(emotionId, intensity);

    if (recoveryMode) {
      return RecommendationItem(
        title: '${base.title} · 회복 모드',
        description: '감정이 크게 느껴지는 날에는 무리해서 해결하기보다 몸과 마음의 부담을 먼저 낮춰봐요.',
        actionText: _recoveryActions[emotionId] ?? '10분만 쉬면서 오늘 할 일을 하나 줄여보기',
        personalityNote: personalityNote,
        safetyNote: safetyNote,
      );
    }

    if (expandMode) {
      return RecommendationItem(
        title: '${base.title} · 유지 모드',
        description: '감정의 파도가 비교적 잔잔하다면 지금의 안정감을 오래 기억할 작은 행동을 해봐요.',
        actionText: _expandActions[emotionId] ?? '오늘 괜찮았던 순간을 한 줄로 남기기',
        personalityNote: personalityNote,
        safetyNote: safetyNote,
      );
    }

    return RecommendationItem(
      title: base.title,
      description: base.description,
      actionText: base.actionText,
      personalityNote: personalityNote,
      safetyNote: safetyNote,
    );
  }

  static String? _safetyNoteFor(String emotionId, int intensity) {
    if (intensity < 4) return null;

    if (emotionId == 'anxious' || emotionId == 'lethargic') {
      return '불안이나 무기력함이 오래 이어진다면 혼자 버티기보다 믿을 만한 사람이나 전문 기관의 도움을 고려해보세요.';
    }

    return null;
  }

  static const Map<String, RecommendationItem> _emotionRecommendations = {
    'calm': RecommendationItem(
      title: '편안함 저장하기',
      description: '편안한 날의 감각은 다음에 지칠 때 꺼내볼 수 있는 작은 단서가 돼요.',
      actionText: '오늘 편안했던 장면 하나를 짧게 메모하기',
    ),
    'tired': RecommendationItem(
      title: '에너지 아끼기',
      description: '지친 날에는 더 해내는 것보다 덜어내는 선택이 도움이 될 수 있어요.',
      actionText: '오늘 할 일 중 하나를 내일로 미루기',
    ),
    'complicated': RecommendationItem(
      title: '생각 정리하기',
      description: '복잡한 마음은 머릿속에서 꺼내 적는 것만으로도 조금 가벼워질 수 있어요.',
      actionText: '떠오르는 생각 3가지를 순서 없이 적기',
    ),
    'excited': RecommendationItem(
      title: '설렘 작게 실행하기',
      description: '좋은 기대감은 아주 작은 실행으로 이어질 때 더 오래 남아요.',
      actionText: '기대되는 일과 관련된 작은 준비 하나 하기',
    ),
    'anxious': RecommendationItem(
      title: '불안 낮추기',
      description: '불안할수록 지금 당장 할 수 있는 일과 나중에 봐도 되는 일을 나누면 좋아요.',
      actionText: '지금 할 수 있는 일 1개만 동그라미 치기',
    ),
    'lethargic': RecommendationItem(
      title: '가장 쉬운 시작',
      description: '무기력한 날에는 작아 보이는 행동도 충분히 의미 있는 시작이에요.',
      actionText: '자리에서 일어나 창문 열기나 물 마시기',
    ),
  };

  static const Map<String, String> _recoveryActions = {
    'calm': '편안함을 방해하지 않도록 오늘 약속 하나를 가볍게 조정하기',
    'tired': '휴대폰을 내려놓고 10분 동안 눈 쉬게 하기',
    'complicated': '생각을 해결/보류 두 칸으로 나눠 적기',
    'excited': '설렘이 부담으로 커지지 않게 오늘 할 준비 하나만 고르기',
    'anxious': '발바닥 감각에 집중하며 천천히 5번 숨 쉬기',
    'lethargic': '완벽한 계획 대신 가장 쉬운 행동 하나만 하기',
  };

  static const Map<String, String> _expandActions = {
    'calm': '오늘의 편안함을 만든 요소 하나 기록하기',
    'tired': '회복에 도움이 된 작은 행동 하나 표시하기',
    'complicated': '정리된 생각 하나를 내일의 작은 할 일로 바꾸기',
    'excited': '기대되는 마음을 누군가에게 짧게 공유하기',
    'anxious': '괜찮았던 근거 하나를 메모하기',
    'lethargic': '부담 없는 산책이나 스트레칭 3분 해보기',
  };

  static const Map<String, String> _personalityNotes = {
    'field_captain': '지금 할 수 있는 한 가지 행동으로 좁히면 에너지를 덜 쓰고 움직일 수 있어요.',
    'warm_coordinator': '다른 사람의 마음을 살피는 만큼 내 컨디션도 함께 확인해보면 좋아요.',
    'idea_pathfinder': '떠오른 가능성을 작은 첫 단계로 바꾸면 부담 없이 시작할 수 있어요.',
    'dream_weaver': '기대와 감정이 커질 때는 현실적인 약속 하나를 곁들이면 더 편안해요.',
    'quiet_builder': '혼자 책임지기보다 필요한 범위를 작게 나누면 안정감이 커질 수 있어요.',
    'gentle_keeper': '조용히 참은 마음이 있다면 부드러운 문장으로 조금만 꺼내봐도 좋아요.',
    'inner_strategist': '생각이 길어질 때는 오늘 실행할 수 있는 가장 작은 단서를 표시해보세요.',
    'soft_lantern': '상상한 마음을 글이나 색으로 꺼내면 감정이 조금 더 선명해질 수 있어요.',
  };
}
