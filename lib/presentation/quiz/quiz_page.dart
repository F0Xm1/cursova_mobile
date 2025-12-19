import 'package:cours_work/core/app_colors.dart';
import 'package:cours_work/core/fonts.dart';
import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final PageController _pageController = PageController();
  final List<String> _answers = [];

  final List<QuizQuestion> _questions = [
    QuizQuestion(
      question: 'Як ви реагуєте на небезпеку?',
      options: [
        'Атакую першим',
        'Обережно оцінюю ситуацію',
        'Шукаю допомоги',
        'Намагаюся втекти',
      ],
    ),
    QuizQuestion(
      question: 'Ваш улюблений спосіб провести час?',
      options: [
        'Тренування та бій',
        'Читання книг',
        'Спілкування з друзями',
        'Спостереження за людьми',
      ],
    ),
    QuizQuestion(
      question: 'Що для вас найважливіше?',
      options: [
        'Сила та влада',
        'Знання та розум',
        'Дружба та лояльність',
        'Свобода та незалежність',
      ],
    ),
    QuizQuestion(
      question: 'Як ви ставитеся до правил?',
      options: [
        'Правила для слабких',
        'Правила важливі, але можна їх інтерпретувати',
        'Дотримуюся правил',
        'Правила — це перешкоди',
      ],
    ),
    QuizQuestion(
      question: 'Ваша реакція на конфлікт?',
      options: [
        'Вирішую силою',
        'Шукаю компроміс',
        'Намагаюся уникнути',
        'Використовую хитрощі',
      ],
    ),
  ];

  final Map<String, QuizResult> _results = {
    'Kaneki': QuizResult(
      name: 'Кен Канекі',
      description:
      'Ви інтелектуальний та співчутливий. Як Кенекі, ви постійно ростете та адаптуєтеся до нових обставин.',
      imageUrl: 'assets/images/kaneki.png',
    ),
    'Touka': QuizResult(
      name: 'Тоука Кірушима',
      description:
      'Ви сильна та незалежна особистість. Як Тоука, ви захищаєте тих, хто вам дорогий.',
      imageUrl: 'assets/images/touka.png',
    ),
    'Hide': QuizResult(
      name: 'Хідейоші Нагачіка',
      description:
      'Ви вірний друг та розумний стратег. Як Хіде, ви завжди підтримуєте близьких.',
      imageUrl: 'assets/images/hide.png',
    ),
    'Rize': QuizResult(
      name: 'Різе Камішо',
      description:
      'Ви вільна та непередбачувана. Як Різе, ви живете за власними правилами.',
      imageUrl: 'assets/images/rize.png',
    ),
  };

  void _answerQuestion(String answer) {
    setState(() {
      _answers.add(answer);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  QuizResult _calculateResult() {
    final Map<String, int> scores = {
      'Kaneki': 0,
      'Touka': 0,
      'Hide': 0,
      'Rize': 0,
    };

    for (int i = 0; i < _answers.length; i++) {
      final optionIndex =
      _questions[i].options.indexOf(_answers[i]);

      if (optionIndex == 0) scores['Kaneki'] = scores['Kaneki']! + 1;
      if (optionIndex == 1) scores['Touka'] = scores['Touka']! + 1;
      if (optionIndex == 2) scores['Hide'] = scores['Hide']! + 1;
      if (optionIndex == 3) scores['Rize'] = scores['Rize']! + 1;
    }

    final winner =
    scores.entries.reduce((a, b) => a.value > b.value ? a : b);
    return _results[winner.key]!;
  }

  void _shareResult(QuizResult result) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Результат: ${result.name}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                'Який ти персонаж з Tokyo Ghoul?',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: AppFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ..._questions.map(_buildQuestionPage),
          _buildResultPage(),
        ],
      ),
    );
  }

  Widget _buildQuestionPage(QuizQuestion question) {
    final index = _questions.indexOf(question);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Питання ${index + 1}/${_questions.length}',
                style: AppFonts.roboto(
                  fontSize: 14,
                  color: AppColors.text.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (index + 1) / _questions.length,
                    minHeight: 6,
                    backgroundColor:
                    AppColors.text.withValues(alpha: 0.15),
                    valueColor:
                    const AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          Text(
            question.question,
            style: AppFonts.playfairDisplay(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
              height: 1.25,
            ),
          ),

          const SizedBox(height: 40),

          Expanded(
            child: ListView.separated(
              itemCount: question.options.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, i) {
                final option = question.options[i];
                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _answerQuestion(option),
                  child: Card(
                    color: AppColors.background,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: AppColors.primary
                            .withValues(alpha: 0.4),
                        width: 1.2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      child: Text(
                        option,
                        style: AppFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultPage() {
    final result = _calculateResult();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            color: AppColors.background,
            elevation: 12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                      AppColors.primary.withValues(alpha: 0.1),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        result.imageUrl,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.person,
                          size: 80,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    result.name,
                    textAlign: TextAlign.center,
                    style: AppFonts.playfairDisplay(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    result.description,
                    textAlign: TextAlign.center,
                    style: AppFonts.lato(
                      fontSize: 16,
                      height: 1.6,
                      color:
                      AppColors.text.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _shareResult(result),
              icon: const Icon(Icons.share),
              label: const Text('Поділитися результатом'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          TextButton(
            onPressed: () {
              setState(() {
                _answers.clear();
                _pageController.jumpToPage(0);
              });
            },
            child: Text(
              'Пройти ще раз',
              style: AppFonts.lato(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuizQuestion {
  final String question;
  final List<String> options;

  QuizQuestion({required this.question, required this.options});
}

class QuizResult {
  final String name;
  final String description;
  final String imageUrl;

  QuizResult({
    required this.name,
    required this.description,
    required this.imageUrl,
  });
}
