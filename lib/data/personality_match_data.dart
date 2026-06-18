import '../models/personality_match.dart';

const Map<String, PersonalityRelationshipMatch> personalityRelationshipMatches = {
  'field_captain': PersonalityRelationshipMatch(
    bestMatches: [
      PersonalityMatch(
        typeId: 'warm_coordinator',
        reason: '둘 다 현실적인 감각이 좋아 함께 움직일 때 편안한 흐름을 만들기 쉬워요. 실행력과 배려가 만나면 관계 안에서 자연스럽게 균형이 생겨요.',
      ),
      PersonalityMatch(
        typeId: 'quiet_builder',
        reason: '실용적인 기준을 중요하게 여기는 점이 닮아 서로의 판단을 신뢰하기 좋아요. 한쪽은 빠르게 움직이고, 한쪽은 차분히 다듬어 관계를 안정적으로 만들어줘요.',
      ),
    ],
    growthMatches: [
      PersonalityMatch(
        typeId: 'dream_weaver',
        reason: '속도를 맞추면 실행 중심의 에너지에 더 부드러운 상상력과 감정의 온기가 더해질 수 있어요. 서로의 표현 방식을 이해하면 관계가 한층 풍성해져요.',
      ),
      PersonalityMatch(
        typeId: 'soft_lantern',
        reason: '서로의 리듬을 천천히 맞추면 빠른 결정과 깊은 감성이 좋은 보완점이 될 수 있어요. 말로 드러나는 속도보다 마음의 방향을 살피면 더 편안해져요.',
      ),
    ],
  ),
  'warm_coordinator': PersonalityRelationshipMatch(
    bestMatches: [
      PersonalityMatch(
        typeId: 'field_captain',
        reason: '현실적인 상황 판단이 잘 맞아 함께할 때 결정과 행동이 자연스럽게 이어져요. 한쪽의 추진력과 한쪽의 배려가 관계를 편안하게 받쳐줘요.',
      ),
      PersonalityMatch(
        typeId: 'gentle_keeper',
        reason: '둘 다 구체적인 챙김과 관계의 온기를 중요하게 여겨 안정감을 주고받기 좋아요. 표현 방식은 다르지만 마음을 살피는 방향이 비슷해요.',
      ),
    ],
    growthMatches: [
      PersonalityMatch(
        typeId: 'idea_pathfinder',
        reason: '서로의 기준을 이해하면 현실적인 배려와 새로운 가능성이 좋은 균형을 이룰 수 있어요. 대화 속에서 감정과 아이디어를 함께 넓혀갈 수 있어요.',
      ),
      PersonalityMatch(
        typeId: 'inner_strategist',
        reason: '표현 속도를 조율하면 따뜻한 관계 감각과 깊은 사고가 서로에게 배울 점이 될 수 있어요. 마음을 챙기는 방식과 생각을 정리하는 방식이 서로를 보완해줘요.',
      ),
    ],
  ),
  'idea_pathfinder': PersonalityRelationshipMatch(
    bestMatches: [
      PersonalityMatch(
        typeId: 'dream_weaver',
        reason: '둘 다 새로운 가능성에서 에너지를 얻어 대화가 활발하게 확장되기 좋아요. 아이디어와 감성이 만나면 관계 안에 즐거운 기대감이 생겨요.',
      ),
      PersonalityMatch(
        typeId: 'field_captain',
        reason: '새로운 방향을 떠올리는 힘과 실제로 움직이는 힘이 잘 어울려요. 생각을 현실로 옮기는 과정에서 서로에게 든든한 자극이 될 수 있어요.',
      ),
    ],
    growthMatches: [
      PersonalityMatch(
        typeId: 'gentle_keeper',
        reason: '속도를 맞추면 빠르게 확장되는 생각에 섬세한 안정감이 더해질 수 있어요. 서로의 생활 리듬과 마음의 온도를 존중하면 더 편안한 관계가 돼요.',
      ),
      PersonalityMatch(
        typeId: 'quiet_builder',
        reason: '표현 방식을 조율하면 가능성을 넓히는 힘과 현실적으로 다듬는 힘이 좋은 조합이 될 수 있어요. 서로의 판단 기준을 이해하면 더 단단한 방향을 찾기 쉬워요.',
      ),
    ],
  ),
  'dream_weaver': PersonalityRelationshipMatch(
    bestMatches: [
      PersonalityMatch(
        typeId: 'soft_lantern',
        reason: '둘 다 사람의 마음과 가능성을 섬세하게 바라보는 점이 닮아 있어요. 표현의 크기는 달라도 서로의 감정 세계를 따뜻하게 이해하기 좋아요.',
      ),
      PersonalityMatch(
        typeId: 'idea_pathfinder',
        reason: '새로운 가능성을 함께 이야기하며 관계에 활기를 만들기 쉬워요. 한쪽의 감성적인 기대와 한쪽의 논리적인 방향성이 서로를 넓혀줘요.',
      ),
    ],
    growthMatches: [
      PersonalityMatch(
        typeId: 'quiet_builder',
        reason: '서로의 기준을 이해하면 풍부한 상상력과 차분한 현실 감각이 균형을 이룰 수 있어요. 감정의 흐름과 안정적인 판단이 만나 관계를 더 단단하게 해줘요.',
      ),
      PersonalityMatch(
        typeId: 'field_captain',
        reason: '속도를 맞추면 마음속 가능성이 실제 행동으로 이어지는 데 도움을 받을 수 있어요. 표현의 온도와 실행의 리듬을 조율하면 서로에게 좋은 자극이 돼요.',
      ),
    ],
  ),
  'quiet_builder': PersonalityRelationshipMatch(
    bestMatches: [
      PersonalityMatch(
        typeId: 'gentle_keeper',
        reason: '둘 다 차분한 방식으로 신뢰를 쌓아가는 편이라 관계가 안정적으로 느껴지기 쉬워요. 현실적인 기준과 조용한 배려가 서로에게 편안함을 줘요.',
      ),
      PersonalityMatch(
        typeId: 'field_captain',
        reason: '현실을 보는 감각과 실용적인 판단이 잘 맞아 서로를 믿고 의지하기 좋아요. 한쪽의 신중함과 한쪽의 실행력이 좋은 균형을 만들 수 있어요.',
      ),
    ],
    growthMatches: [
      PersonalityMatch(
        typeId: 'dream_weaver',
        reason: '표현 방식을 조율하면 차분한 기준에 따뜻한 가능성이 더해질 수 있어요. 서로의 감정 표현과 사고 방식을 이해하면 관계의 폭이 넓어져요.',
      ),
      PersonalityMatch(
        typeId: 'warm_coordinator',
        reason: '속도를 맞추면 조용한 신뢰와 적극적인 배려가 서로를 보완할 수 있어요. 마음을 표현하는 방식이 다르다는 점을 이해하면 더 편안해져요.',
      ),
    ],
  ),
  'gentle_keeper': PersonalityRelationshipMatch(
    bestMatches: [
      PersonalityMatch(
        typeId: 'warm_coordinator',
        reason: '둘 다 관계의 온도와 현실적인 챙김을 중요하게 여겨 서로에게 안정감을 주기 좋아요. 한쪽은 자연스럽게 이어주고, 한쪽은 조용히 지켜주는 흐름이 잘 어울려요.',
      ),
      PersonalityMatch(
        typeId: 'quiet_builder',
        reason: '차분하고 꾸준한 관계 방식을 편안하게 느낄 가능성이 높아요. 서로의 생활 리듬을 존중하며 안정적인 신뢰를 쌓아갈 수 있어요.',
      ),
    ],
    growthMatches: [
      PersonalityMatch(
        typeId: 'idea_pathfinder',
        reason: '서로의 리듬을 맞추면 조용한 안정감과 새로운 시도가 좋은 균형을 만들 수 있어요. 낯선 가능성을 천천히 나누면 관계가 더 생기 있게 넓어져요.',
      ),
      PersonalityMatch(
        typeId: 'field_captain',
        reason: '표현 속도를 조율하면 섬세한 배려와 빠른 실행력이 서로에게 든든한 힘이 될 수 있어요. 마음을 확인하는 시간을 함께 가지면 더 편안해져요.',
      ),
    ],
  ),
  'inner_strategist': PersonalityRelationshipMatch(
    bestMatches: [
      PersonalityMatch(
        typeId: 'quiet_builder',
        reason: '둘 다 혼자 생각을 정리하는 시간을 존중해주기 쉬워요. 깊은 사고와 차분한 기준이 만나 안정적인 대화를 만들 수 있어요.',
      ),
      PersonalityMatch(
        typeId: 'idea_pathfinder',
        reason: '가능성을 논리적으로 바라보는 점이 닮아 생각을 나누는 시간이 즐거울 수 있어요. 한쪽은 깊이를 더하고, 한쪽은 확장을 도와줘요.',
      ),
    ],
    growthMatches: [
      PersonalityMatch(
        typeId: 'warm_coordinator',
        reason: '표현 방식을 조율하면 깊은 사고와 현실적인 배려가 서로에게 좋은 배움이 될 수 있어요. 생각을 나누는 속도와 마음을 챙기는 방식을 함께 맞춰가면 좋아요.',
      ),
      PersonalityMatch(
        typeId: 'dream_weaver',
        reason: '서로의 감정 표현과 사고 리듬을 이해하면 논리적인 깊이와 따뜻한 영감이 잘 어우러질 수 있어요. 다른 방식의 가능성을 보며 관계가 부드럽게 넓어져요.',
      ),
    ],
  ),
  'soft_lantern': PersonalityRelationshipMatch(
    bestMatches: [
      PersonalityMatch(
        typeId: 'dream_weaver',
        reason: '둘 다 마음의 의미와 가능성을 섬세하게 바라보는 성향이라 정서적으로 통하는 느낌을 받기 쉬워요. 한쪽의 표현력과 한쪽의 깊이가 따뜻하게 이어져요.',
      ),
      PersonalityMatch(
        typeId: 'gentle_keeper',
        reason: '조용한 배려와 섬세한 감정 감각이 서로에게 편안한 안정감을 줄 수 있어요. 가까운 관계에서 천천히 마음을 나누기 좋은 조합이에요.',
      ),
    ],
    growthMatches: [
      PersonalityMatch(
        typeId: 'field_captain',
        reason: '속도를 맞추면 깊은 감성과 현실적인 실행력이 서로를 보완할 수 있어요. 마음의 의미와 실제 행동 사이의 균형을 함께 배워갈 수 있어요.',
      ),
      PersonalityMatch(
        typeId: 'idea_pathfinder',
        reason: '표현 방식을 조율하면 조용한 상상력과 활발한 아이디어가 좋은 자극이 될 수 있어요. 서로의 생각을 천천히 나누면 새로운 가능성을 더 편안하게 발견할 수 있어요.',
      ),
    ],
  ),
};
