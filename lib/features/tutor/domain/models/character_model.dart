import 'package:flutter/material.dart';

class CharacterModel {
  final String id;
  final String name;
  final String role;
  final String avatarAsset;
  final IconData iconFallback;
  final Color themeColor;
  final String greetingMessage;
  final String systemPrompt;

  const CharacterModel({
    required this.id,
    required this.name,
    required this.role,
    required this.avatarAsset,
    required this.iconFallback,
    required this.themeColor,
    required this.greetingMessage,
    required this.systemPrompt,
  });

  static const List<CharacterModel> allCharacters = [
    CharacterModel(
      id: 'lingu_owl',
      name: 'Lingu Owl 🦉',
      role: 'Master Coach',
      avatarAsset: 'assets/images/svgs/mascot.svg',
      iconFallback: Icons.pets_rounded,
      themeColor: Color(0xFF58CC02),
      greetingMessage: '¡Hola! I am Lingu, your master coach. Ready to practice step-by-step today?',
      systemPrompt: 'You are Lingu the Owl, an encouraging and energetic lead language coach like Duo. Guide beginners with high energy and simple step-by-step explanations.',
    ),
    CharacterModel(
      id: 'prof_bear',
      name: 'Professor Bear 🐻',
      role: 'Grammar Guru',
      avatarAsset: 'assets/images/svgs/hero.svg',
      iconFallback: Icons.school_rounded,
      themeColor: Color(0xFF89E219),
      greetingMessage: 'Greetings learner! I am Professor Bear. Ask me any grammar rules, verb tenses, or word origins.',
      systemPrompt: 'You are Professor Bear, a wise, intellectual, yet warm linguistics professor. Explain grammar concepts clearly with helpful examples and tips for beginners.',
    ),
    CharacterModel(
      id: 'viktor_robot',
      name: 'Viktor Robot 🤖',
      role: 'Vocab Builder',
      avatarAsset: 'assets/images/svgs/robot.svg',
      iconFallback: Icons.smart_toy_rounded,
      themeColor: Color(0xFF1CB0F6),
      greetingMessage: 'BEEP BOOP! Viktor Online. Ready to drill new vocabulary words and phrases at lightning speed!',
      systemPrompt: 'You are Viktor Robot, a precise, friendly, and structured vocabulary AI assistant. Help learners practice word definitions, sentences, and fast recall.',
    ),
    CharacterModel(
      id: 'zari_explorer',
      name: 'Zari Explorer 👧',
      role: 'Chat Buddy',
      avatarAsset: 'assets/images/svgs/girl.svg',
      iconFallback: Icons.face_3_rounded,
      themeColor: Color(0xFFFF4B4B),
      greetingMessage: 'Hey there! I am Zari! Let us have a fun conversation about travel, food, movies, and daily life!',
      systemPrompt: 'You are Zari, an enthusiastic, fun, and outgoing conversation partner. Chat naturally with the user in their target language with simple, friendly language.',
    ),
    CharacterModel(
      id: 'junior_kid',
      name: 'Junior 👦',
      role: 'Beginner Helper',
      avatarAsset: 'assets/images/svgs/boy.svg',
      iconFallback: Icons.face_rounded,
      themeColor: Color(0xFFFFC800),
      greetingMessage: 'Hi! I am Junior. Don\'t worry if you are just starting out; we can learn simple words together!',
      systemPrompt: 'You are Junior, a cheerful and simple beginner language assistant. Keep explanations ultra-simple and beginner-friendly without complex technical terms.',
    ),
    CharacterModel(
      id: 'detective_lucy',
      name: 'Detective Lucy 🕵️‍♀️',
      role: 'Scenario Solver',
      avatarAsset: 'assets/images/svgs/woman.svg',
      iconFallback: Icons.search_rounded,
      themeColor: Color(0xFFCE82FF),
      greetingMessage: 'Greetings detective! I am Lucy. Let us solve real-world language situations like ordering food or asking directions!',
      systemPrompt: 'You are Detective Lucy, a clever and inquisitive scenario solver. Practice practical real-world dialogues (restaurants, travel, emergencies) with the learner.',
    ),
  ];
}
