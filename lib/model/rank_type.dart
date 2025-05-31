import 'package:dilidili/pages/trend/zone/view.dart';
import 'package:flutter/material.dart';

enum RandType {
  all,
  creation,
  animation,
  music,
  dance,
  game,
  knowledge,
  technology,
  sport,
  car,
  life,
  food,
  animal,
  madness,
  fashion,
  entertainment,
  film,
  origin,
  rookie
}

extension RankTypeDesc on RandType {
  String get description => [
        '全站',
        '国创相关',
        '动画',
        '音乐',
        '舞蹈',
        '游戏',
        '知识',
        '科技',
        '运动',
        '汽车',
        '生活',
        '美食',
        '动物圈',
        '鬼畜',
        '时尚',
        '娱乐',
        '影视'
      ][index];

  String get id => [
        'all',
        'creation',
        'animation',
        'music',
        'dance',
        'game',
        'knowledge',
        'technology',
        'sport',
        'car',
        'life',
        'food',
        'animal',
        'madness',
        'fashion',
        'entertainment',
        'film'
      ][index];
}

List tabsConfig = [
  {
    'label': '全站',
    'type': RandType.all,
    'page': const ZonePage(rid: 0),
  },
  {
    'label': '国创相关',
    'type': RandType.creation,
    'page': const ZonePage(rid: 168),
  },
  {
    'label': '动画',
    'type': RandType.animation,
    'page': const ZonePage(rid: 1),
  },
  {
    'label': '音乐',
    'type': RandType.music,
    'page': const ZonePage(rid: 3),
  },
  {
    'label': '舞蹈',
    'type': RandType.dance,
    'page': const ZonePage(rid: 129),
  },
  {
    'label': '游戏',
    'type': RandType.game,
    'page': const ZonePage(rid: 4),
  },
  {
    'label': '知识',
    'type': RandType.knowledge,
    'page': const ZonePage(rid: 36),
  },
  {
    'label': '科技',
    'type': RandType.technology,
    'page': const ZonePage(rid: 188),
  },
  {
    'label': '运动',
    'type': RandType.sport,
    'page': const ZonePage(rid: 234),
  },
  {
    'label': '汽车',
    'type': RandType.car,
    'page': const ZonePage(rid: 223),
  },
  {
    'label': '生活',
    'type': RandType.life,
    'page': const ZonePage(rid: 160),
  },
  {
    'label': '美食',
    'type': RandType.food,
    'page': const ZonePage(rid: 211),
  },
  {
    'label': '动物圈',
    'type': RandType.animal,
    'page': const ZonePage(rid: 217),
  },
  {
    'label': '鬼畜',
    'type': RandType.madness,
    'page': const ZonePage(rid: 119),
  },
  {
    'label': '时尚',
    'type': RandType.fashion,
    'page': const ZonePage(rid: 155),
  },
  {
    'label': '娱乐',
    'type': RandType.entertainment,
    'page': const ZonePage(rid: 5),
  },
  {
    'label': '影视',
    'type': RandType.film,
    'page': const ZonePage(rid: 181),
  }
];
