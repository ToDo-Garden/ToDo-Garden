//
//  ManageGroupMockData.swift
//
//
//  Created by SONG on 8/2/24.
//

import Foundation

import ManageGroupSceneEntity
import ToDoGardenUIResource

struct ManageGroupMockData {
  
  static let guideSceneData: [ManageGroup.ToDoGroup] = [
    ManageGroup.ToDoGroup(groupName: "영어 독해", progressColor: .toDoGardenYellow, progressRate: 0.5),
    ManageGroup.ToDoGroup(groupName: "역사와 문화 이해", progressColor: .toDoGardenRed, progressRate: 0.5),
    ManageGroup.ToDoGroup(groupName: "디자인 창작", progressColor: .toDoGardenOlive, progressRate: 0.5)
  ]
  
  static let fetchedData: [ManageGroup.ToDoGroup] = [
    ManageGroup.ToDoGroup(groupName: "수학 공부", progressColor: .red, progressRate: 0.5),
    ManageGroup.ToDoGroup(groupName: "영어 학습 및 연습", progressColor: .blue, progressRate: 0.3),
    ManageGroup.ToDoGroup(groupName: "과학과 기술 분야 탐구", progressColor: .green, progressRate: 0.7),
    ManageGroup.ToDoGroup(groupName: "프로그래밍과 코딩 도전", progressColor: .purple, progressRate: 0.2),
    ManageGroup.ToDoGroup(groupName: "역사와 문화 이해", progressColor: .orange, progressRate: 0.9),
    ManageGroup.ToDoGroup(groupName: "음악과 예술 감상", progressColor: .yellow, progressRate: 0.4),
    ManageGroup.ToDoGroup(groupName: "미술과 디자인 창작", progressColor: .cyan, progressRate: 0.6),
    ManageGroup.ToDoGroup(groupName: "체육 운동과 스포츠", progressColor: .magenta, progressRate: 0.8),
    ManageGroup.ToDoGroup(groupName: "경제와 금융의 기초 이해", progressColor: .brown, progressRate: 0.3),
    ManageGroup.ToDoGroup(groupName: "사회 문제 탐구", progressColor: .black, progressRate: 0.7),
    ManageGroup.ToDoGroup(groupName: "컴퓨터 과학의 기본 개념", progressColor: .systemPink, progressRate: 0.5),
    ManageGroup.ToDoGroup(groupName: "문학과 시 이해와 해석", progressColor: .systemIndigo, progressRate: 0.2),
    ManageGroup.ToDoGroup(groupName: "요리와 조리 기술 연마", progressColor: .systemBrown, progressRate: 0.9),
    ManageGroup.ToDoGroup(groupName: "자동차 수리와 정비", progressColor: .systemPurple, progressRate: 0.6),
    ManageGroup.ToDoGroup(groupName: "정치와 법의 기본 개념", progressColor: .systemOrange, progressRate: 0.4),
    ManageGroup.ToDoGroup(groupName: "화학 실험과 실험실 작업", progressColor: .red, progressRate: 0.3),
    ManageGroup.ToDoGroup(groupName: "언어 학습과 외국어 구사", progressColor: .blue, progressRate: 0.6),
    ManageGroup.ToDoGroup(groupName: "생물학 연구와 생명 과학", progressColor: .green, progressRate: 0.8),
    ManageGroup.ToDoGroup(groupName: "디지털 아트와 그래픽 디자인", progressColor: .purple, progressRate: 0.1),
    ManageGroup.ToDoGroup(groupName: "건강과 웰빙의 기본 지식", progressColor: .orange, progressRate: 0.5)
  ]
}
