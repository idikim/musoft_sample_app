import 'package:flutter/material.dart';
import 'package:madezone_study_student_app/model/schedule_sample.dart';

final List<ScheduleSample> sampleScheduleSamples = [
  ScheduleSample(
    startHour: 6,
    startMinute: 10,
    endHour: 6,
    endMinute: 20,
    title: '지각 (10분)',
    subtitle: '06:10',
    color: Colors.red.shade100,
  ),
  ScheduleSample(
    startHour: 6,
    startMinute: 0,
    endHour: 7,
    endMinute: 20,
    title: '국어 (1시간 20분)',
    subtitle: '06:00 - 07:20',
    details: ['3단원: 한국 문학의 흐름', '- 공부, 메모', '- 테스트'],
    color: Colors.green.shade100,
  ),
  ScheduleSample(
    startHour: 8,
    startMinute: 0,
    endHour: 9,
    endMinute: 20,
    title: '수학 (1시간 20분)',
    subtitle: '08:00 - 09:20',
    details: ['3단원: 한국 문학의 흐름', '- 공부, 메모', '- 테스트'],
    color: Colors.green.shade100,
  ),
  ScheduleSample(
    startHour: 10,
    startMinute: 0,
    endHour: 11,
    endMinute: 20,
    title: '영어 (1시간 20분)',
    subtitle: '10:00 - 11:20',
    details: ['3단원: 한국 문학의 흐름', '- 공부, 메모', '- 테스트'],
    color: Colors.green.shade100,
  ),
  ScheduleSample(
    startHour: 12,
    startMinute: 0,
    endHour: 15,
    endMinute: 20,
    title: '외출 (3시간 20분)',
    subtitle: '12:00 - 15:20',
    details: ['사유: 은행 방문, 문제집 구매 목적 서점 방문, 대중교통 이용시간까지 계산'],
    color: Colors.red.shade100,
  ),
];
