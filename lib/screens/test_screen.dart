import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../data/personality_data.dart';
import '../models/personality_type.dart';
import '../widgets/decorative.dart';
import '../widgets/rounded_button.dart';
import '../widgets/soft_card.dart';
import 'result_screen.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int currentQuestionIndex = 0;
  final List<int> answers = [];

  final List<TestQuestion> questions = const [
    TestQuestion(
      text: '새로운 사람을 만나는 자리가 생기면 기대되는 편이다.',
      typeScores: {
        'sunny_empath': 2,
        'free_explorer': 2,
        'quiet_observer': 0,
        'steady_realist': 1,
        'balanced_sensitive': 1,
      },
    ),
    TestQuestion(
      text: '스트레스를 받으면 혼자 조용히 정리할 시간이 필요하다.',
      typeScores: {
        'quiet_observer': 2,
        'balanced_sensitive': 2,
        'sunny_empath': 1,
        'steady_realist': 1,
        'free_explorer': 0,
      },
    ),
    TestQuestion(
      text: '친구가 고민을 말하면 해결책보다 공감을 먼저 해주는 편이다.',
      typeScores: {
        'sunny_empath': 2,
        'balanced_sensitive': 2,
        'quiet_observer': 1,
        'steady_realist': 0,
        'free_explorer': 1,
      },
    ),
    TestQuestion(
      text: '약속이나 계획이 갑자기 바뀌면 조금 불편하게 느껴진다.',
      typeScores: {
        'steady_realist': 2,
        'quiet_observer': 1,
        'balanced_sensitive': 1,
        'sunny_empath': 0,
        'free_explorer': 0,
      },
    ),
    TestQuestion(
      text: '반복되는 일상보다 새로운 경험을 해보는 게 더 끌린다.',
      typeScores: {
        'free_explorer': 2,
        'sunny_empath': 1,
        'balanced_sensitive': 1,
        'quiet_observer': 0,
        'steady_realist': 0,
      },
    ),
    TestQuestion(
      text: '갈등이 생기면 한쪽 편을 들기보다 양쪽 입장을 같이 보려 한다.',
      typeScores: {
        'balanced_sensitive': 2,
        'sunny_empath': 1,
        'steady_realist': 1,
        'quiet_observer': 1,
        'free_explorer': 0,
      },
    ),
    TestQuestion(
      text: '말뿐인 위로보다 실제로 도움이 되는 행동이 더 중요하다고 느낀다.',
      typeScores: {
        'steady_realist': 2,
        'balanced_sensitive': 1,
        'quiet_observer': 1,
        'sunny_empath': 0,
        'free_explorer': 0,
      },
    ),
    TestQuestion(
      text: '친해지는 데 시간이 조금 걸리더라도 깊고 오래가는 관계가 좋다.',
      typeScores: {
        'quiet_observer': 2,
        'balanced_sensitive': 1,
        'steady_realist': 1,
        'sunny_empath': 1,
        'free_explorer': 0,
      },
    ),
  ];

  void selectAnswer(int score) {
    answers.add(score);

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      final result = calculateResult();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(resultType: result),
        ),
      );
    }
  }

  PersonalityType calculateResult() {
    final Map<String, int> totalScores = {
      'sunny_empath': 0,
      'quiet_observer': 0,
      'steady_realist': 0,
      'free_explorer': 0,
      'balanced_sensitive': 0,
    };

    for (int i = 0; i < answers.length; i++) {
      final answerWeight = answers[i];
      final question = questions[i];

      question.typeScores.forEach((typeId, score) {
        totalScores[typeId] = totalScores[typeId]! + (score * answerWeight);
      });
    }

    String bestTypeId = totalScores.entries.first.key;
    int bestScore = totalScores.entries.first.value;

    totalScores.forEach((typeId, score) {
      if (score > bestScore) {
        bestTypeId = typeId;
        bestScore = score;
      }
    });

    return personalityTypes.firstWhere(
          (type) => type.id == bestTypeId,
      orElse: () => personalityTypes.first,
    );
  }

  void goPreviousQuestion() {
    if (currentQuestionIndex == 0) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      currentQuestionIndex--;
      answers.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex];
    final progress = (currentQuestionIndex + 1) / questions.length;

    return Scaffold(
      body: WarmGradientBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 19),
                    onPressed: goPreviousQuestion,
                  ),
                  Expanded(
                    child: Text(
                      '나의 사이해 유형 알아보기',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 12),
              Text('전문 진단이 아닌 참고용 자기이해 콘텐츠', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 24),
              Text('Q${currentQuestionIndex + 1} / ${questions.length}', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                borderRadius: BorderRadius.circular(99),
                backgroundColor: AppColors.softBeige.withOpacity(.75),
                color: AppColors.blush,
              ),
              const SizedBox(height: 26),
              SoftCard(
                padding: const EdgeInsets.fromLTRB(16, 30, 16, 18),
                child: Column(
                  children: [
                    const SpeechLogo(size: 58, compact: true),
                    const SizedBox(height: 14),
                    Text(
                      question.text,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(height: 1.45),
                    ),
                    const SizedBox(height: 26),
                    _AnswerButton(text: '전혀 그렇지 않아요', onTap: () => selectAnswer(0)),
                    const SizedBox(height: 10),
                    _AnswerButton(text: '조금 아닌 편이에요', onTap: () => selectAnswer(1)),
                    const SizedBox(height: 10),
                    _AnswerButton(text: '조금 그런 편이에요', isPrimary: true, onTap: () => selectAnswer(2)),
                    const SizedBox(height: 10),
                    _AnswerButton(text: '매우 그래요', onTap: () => selectAnswer(3)),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Text(
                '답변을 누르면 바로 다음 질문으로 넘어가요.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class TestQuestion {
  final String text;
  final Map<String, int> typeScores;

  const TestQuestion({
    required this.text,
    required this.typeScores,
  });
}

class _AnswerButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isPrimary;

  const _AnswerButton({
    required this.text,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      text: text,
      onPressed: onTap,
      backgroundColor: isPrimary ? AppColors.softPink : AppColors.white,
      foregroundColor: AppColors.textDark,
      outlined: !isPrimary,
    );
  }
}