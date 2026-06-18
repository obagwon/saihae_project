import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../data/personality_data.dart';
import '../data/test_question_data.dart';
import '../models/personality_test_result.dart';
import '../models/personality_type.dart';
import '../models/test_question.dart';
import '../services/personality_test_service.dart';
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
  late final List<int?> answers = List<int?>.filled(questions.length, null);

  final List<TestQuestion> questions = testQuestions;
  final PersonalityTestService testService = const PersonalityTestService();

  void selectAnswer(int score) {
    setState(() {
      answers[currentQuestionIndex] = score;
    });

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      final result = calculateResult();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            resultType: result.type,
            testResult: result.testResult,
          ),
        ),
      );
    }
  }

  TestCalculationResult calculateResult() {
    final testResult = testService.calculateResult(answers);
    final type = personalityTypes.firstWhere(
      (type) => type.id == testResult.typeId,
      orElse: () => personalityTypes.first,
    );

    return TestCalculationResult(
      type: type,
      testResult: testResult,
    );
  }

  void goPreviousQuestion() {
    if (currentQuestionIndex == 0) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      currentQuestionIndex--;
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex];
    final progress = (currentQuestionIndex + 1) / questions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('성향 테스트'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: goPreviousQuestion,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.softBeige,
              color: AppColors.navy,
              minHeight: 10,
              borderRadius: BorderRadius.circular(20),
            ),
            const SizedBox(height: 18),

            Text(
              '${currentQuestionIndex + 1} / ${questions.length}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 18),

            SoftCard(
              backgroundColor: AppColors.blush,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.forum_rounded,
                    color: AppColors.navy,
                    size: 38,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    question.text,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '정답은 없어요. 관계 속 평소의 나와 가장 가까운 쪽을 골라주세요.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            ...answerOptions.map((option) {
              final isSelected = answers[currentQuestionIndex] == option.score;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _AnswerButton(
                  text: option.label,
                  isSelected: isSelected,
                  onTap: () => selectAnswer(option.score),
                ),
              );
            }),

            Center(
              child: Text(
                currentQuestionIndex == questions.length - 1 ? '결과 보기' : '답변을 선택하면 다음 문항으로 이동해요',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),

            const SizedBox(height: 24),

            SoftCard(
              backgroundColor: AppColors.white,
              hasShadow: false,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.textLight,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '이 테스트는 전문 진단이 아니라 자기이해를 위한 참고용 질문이에요.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TestCalculationResult {
  final PersonalityType type;
  final PersonalityTestResult testResult;

  const TestCalculationResult({
    required this.type,
    required this.testResult,
  });
}

class _AnswerButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isSelected;

  const _AnswerButton({
    required this.text,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      text: text,
      onPressed: onTap,
      icon: isSelected ? Icons.check_circle_rounded : null,
      backgroundColor: isSelected ? AppColors.navy : AppColors.white,
      foregroundColor: isSelected ? AppColors.white : AppColors.textDark,
    );
  }
}