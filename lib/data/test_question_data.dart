import '../models/test_question.dart';

const List<TestQuestion> testQuestions = [
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
