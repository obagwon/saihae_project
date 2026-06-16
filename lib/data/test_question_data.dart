import '../models/test_question.dart';

const List<AnswerOption> answerOptions = [
  AnswerOption(label: '매우 그렇다', score: 3),
  AnswerOption(label: '그렇다', score: 2),
  AnswerOption(label: '아니다', score: 1),
  AnswerOption(label: '전혀 아니다', score: 0),
];

const List<TestQuestion> testQuestions = [
  TestQuestion(
    id: 'q01_energy_external',
    text: '좋은 일이 생기면 혼자 간직하기보다 누군가에게 바로 이야기하고 싶어져요.',
    axis: PersonalityAxis.energy,
    positivePole: PersonalityPole.external,
    tieBreakWeight: 3,
  ),
  TestQuestion(
    id: 'q02_perception_realistic',
    text: '새로운 계획을 세울 때 먼저 실제로 가능한 일정과 준비물을 떠올리는 편이에요.',
    axis: PersonalityAxis.perception,
    positivePole: PersonalityPole.realistic,
    tieBreakWeight: 2,
  ),
  TestQuestion(
    id: 'q03_judgment_relational',
    text: '결정을 내릴 때 결과만큼이나 그 과정에서 사람들이 어떤 마음일지 살피게 돼요.',
    axis: PersonalityAxis.judgment,
    positivePole: PersonalityPole.relational,
    tieBreakWeight: 3,
  ),
  TestQuestion(
    id: 'q04_energy_internal',
    text: '바쁜 하루 뒤에는 조용히 혼자 머무는 시간이 있어야 마음이 다시 차오르는 편이에요.',
    axis: PersonalityAxis.energy,
    positivePole: PersonalityPole.internal,
    tieBreakWeight: 2,
  ),
  TestQuestion(
    id: 'q05_perception_possibility',
    text: '익숙한 길을 걷다가도 “다르게 해보면 어떨까?” 하는 생각이 자주 떠올라요.',
    axis: PersonalityAxis.perception,
    positivePole: PersonalityPole.possibility,
    tieBreakWeight: 3,
  ),
  TestQuestion(
    id: 'q06_judgment_logical',
    text: '의견이 갈릴 때는 감정보다 기준과 원칙을 먼저 정리해야 편안해져요.',
    axis: PersonalityAxis.judgment,
    positivePole: PersonalityPole.logical,
    tieBreakWeight: 2,
  ),
  TestQuestion(
    id: 'q07_energy_internal',
    text: '처음 만나는 모임에서는 바로 중심에 서기보다 분위기를 천천히 살피는 쪽이 편해요.',
    axis: PersonalityAxis.energy,
    positivePole: PersonalityPole.internal,
    tieBreakWeight: 1,
  ),
  TestQuestion(
    id: 'q08_perception_realistic',
    text: '아이디어가 멋져 보여도 지금 가진 자료와 경험으로 확인해보고 싶어요.',
    axis: PersonalityAxis.perception,
    positivePole: PersonalityPole.realistic,
    tieBreakWeight: 1,
  ),
  TestQuestion(
    id: 'q09_judgment_relational',
    text: '효율적인 방법이라도 누군가가 크게 불편해한다면 속도를 조금 늦추고 싶어요.',
    axis: PersonalityAxis.judgment,
    positivePole: PersonalityPole.relational,
    tieBreakWeight: 1,
  ),
  TestQuestion(
    id: 'q10_energy_external',
    text: '생각이 막힐 때 사람들과 가볍게 이야기하다 보면 다시 에너지가 생기는 편이에요.',
    axis: PersonalityAxis.energy,
    positivePole: PersonalityPole.external,
    tieBreakWeight: 2,
  ),
  TestQuestion(
    id: 'q11_perception_possibility',
    text: '현재의 모습보다 앞으로 펼쳐질 가능성을 상상할 때 더 마음이 움직여요.',
    axis: PersonalityAxis.perception,
    positivePole: PersonalityPole.possibility,
    tieBreakWeight: 2,
  ),
  TestQuestion(
    id: 'q12_judgment_logical',
    text: '도움을 줄 때도 먼저 문제의 원인과 가장 효과적인 방법을 찾으려 해요.',
    axis: PersonalityAxis.judgment,
    positivePole: PersonalityPole.logical,
    tieBreakWeight: 3,
  ),
];
