class BedtimeQuestionData {
  static String buildQuestion({
    String? emotionId,
    int? intensity,
    String? personalityTypeId,
    DateTime? now,
  }) {
    final normalizedIntensity = intensity?.clamp(1, 5).toInt();

    if (normalizedIntensity != null && normalizedIntensity >= 4) {
      return _highIntensityQuestions[emotionId] ??
          '오늘 내가 너무 오래 붙잡고 있었던 감정은 무엇인가요?';
    }

    if (normalizedIntensity != null && normalizedIntensity <= 2) {
      return _lowIntensityQuestions[emotionId] ??
          '오늘 무덤덤하게 지나갔지만 은근히 남아 있는 장면은 무엇인가요?';
    }

    final personalityQuestion = _personalityQuestions[personalityTypeId];
    if (personalityQuestion != null) {
      return personalityQuestion;
    }

    final emotionQuestion = _emotionQuestions[emotionId];
    if (emotionQuestion != null) {
      return emotionQuestion;
    }

    final date = now ?? DateTime.now();
    return _defaultQuestions[date.day % _defaultQuestions.length];
  }

  static const Map<String, String> _highIntensityQuestions = {
    'calm': '오늘의 편안함을 오래 느끼게 해준 작은 이유는 무엇인가요?',
    'tired': '오늘 내가 생각보다 잘 버틴 순간은 언제였나요?',
    'complicated': '오늘 내가 너무 오래 붙잡고 있었던 생각은 무엇인가요?',
    'excited': '오늘 설레는 마음을 부담 없이 간직하려면 무엇을 덜어내면 좋을까요?',
    'anxious': '오늘 걱정 속에서도 내가 해낸 작은 선택은 무엇인가요?',
    'lethargic': '오늘 아주 작게라도 나를 움직이게 한 순간은 무엇인가요?',
  };

  static const Map<String, String> _lowIntensityQuestions = {
    'calm': '오늘 다시 떠올리고 싶은 따뜻한 장면은 무엇인가요?',
    'tired': '오늘 내 몸이 조용히 쉬고 싶다고 알려준 순간은 언제였나요?',
    'complicated': '오늘 생각보다 가볍게 지나간 일은 무엇인가요?',
    'excited': '오늘 작게 기대됐던 장면을 하나만 고른다면 무엇인가요?',
    'anxious': '오늘 괜찮았다고 느낀 근거를 하나만 떠올린다면 무엇인가요?',
    'lethargic': '오늘 무리하지 않고 지나온 나에게 어떤 말을 건네고 싶나요?',
  };

  static const Map<String, String> _emotionQuestions = {
    'calm': '오늘의 잔잔함을 내일도 조금 남기려면 무엇을 기억하면 좋을까요?',
    'tired': '오늘 나에게 가장 필요했던 쉼은 어떤 모습이었나요?',
    'complicated': '오늘 마음속에서 가장 먼저 내려놓아도 될 생각은 무엇인가요?',
    'excited': '오늘의 기대감이 알려준 나의 바람은 무엇인가요?',
    'anxious': '오늘 나를 안심시킨 작고 현실적인 단서는 무엇인가요?',
    'lethargic': '오늘 아무것도 아닌 듯해도 지나온 나에게 고마운 점은 무엇인가요?',
  };

  static const Map<String, String> _personalityQuestions = {
    'field_captain': '오늘 내가 해낸 일 중 내일의 나에게 힘이 될 한 가지는 무엇인가요?',
    'warm_coordinator': '오늘 다른 사람을 살핀 만큼 나에게도 건네고 싶은 말은 무엇인가요?',
    'idea_pathfinder': '오늘 떠오른 생각 중 내일 작게 시도해보고 싶은 것은 무엇인가요?',
    'dream_weaver': '오늘 마음에 남은 가능성이나 기대는 어떤 장면이었나요?',
    'quiet_builder': '오늘 차분히 지켜낸 나만의 기준은 무엇인가요?',
    'gentle_keeper': '오늘 조용히 애쓴 나를 알아준다면 어떤 부분을 말해주고 싶나요?',
    'inner_strategist': '오늘 머릿속에서 오래 머문 생각은 나에게 무엇을 알려줬나요?',
    'soft_lantern': '오늘 마음속에 은은하게 남은 감정의 색은 무엇인가요?',
  };

  static const List<String> _defaultQuestions = [
    '오늘 내가 너무 오래 붙잡고 있었던 감정은 무엇인가요?',
    '오늘 생각보다 잘 버틴 순간은 언제였나요?',
    '오늘 다시 떠올리고 싶은 따뜻한 장면은 무엇인가요?',
  ];
}
