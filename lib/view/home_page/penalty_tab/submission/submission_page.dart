import 'package:flutter/material.dart';

class SubmissionPage extends StatelessWidget {
  const SubmissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('사유 제출'), centerTitle: true),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            spacing: 24,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _StepIndicatorBar(),
              const _ReasonSelection(),
              const _DateSelection(),
              const _TimeSelection(),
              const _ReasonInput(),
              const _SubmissionFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepIndicatorBar extends StatelessWidget {
  const _StepIndicatorBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: _StepIndicator(
            text: '1단계 사유작성',
            backgroundColor: Colors.red,
            textColor: Colors.white,
          ),
        ),
        Expanded(
          child: _StepIndicator(
            text: '2단계 파일 업로드',
            backgroundColor: Colors.black26,
            textColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const _StepIndicator({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _ReasonSelection extends StatelessWidget {
  const _ReasonSelection();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '사유 선택',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Row(
          spacing: 4,
          children: [
            _ReasonChip(text: '결석', isSelected: true),
            _ReasonChip(text: '지각', isSelected: false),
            _ReasonChip(text: '외출', isSelected: false),
            _ReasonChip(text: '조퇴', isSelected: false),
            _ReasonChip(text: '학습태도', isSelected: false),
          ],
        ),
      ],
    );
  }
}

class _ReasonChip extends StatelessWidget {
  final String text;
  final bool isSelected;

  const _ReasonChip({required this.text, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: isSelected ? Colors.black : Colors.transparent,
        border: Border.all(color: Colors.black),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _DateSelection extends StatelessWidget {
  const _DateSelection();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('날짜', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(border: Border.all()),
          child: Text('2025-07-22 목요일', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}

class _TimeSelection extends StatelessWidget {
  const _TimeSelection();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('시간', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Row(
          spacing: 8,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(border: Border.all()),
              child: Text('00:00', style: TextStyle(fontSize: 16)),
            ),
            Text('-'),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(border: Border.all()),
              child: Text('00:00', style: TextStyle(fontSize: 16)),
            ),
            Text('N시간 N분', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}

class _ReasonInput extends StatefulWidget {
  const _ReasonInput({super.key});

  @override
  State<_ReasonInput> createState() => _ReasonInputState();
}

class _ReasonInputState extends State<_ReasonInput> {
  final TextEditingController _controller = TextEditingController();
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateCharCount);
  }

  void _updateCharCount() {
    setState(() {
      _charCount = _controller.text.length;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 8,
          children: [
            Text(
              '벌점 사유',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('(100자 이하)', style: TextStyle(color: Colors.grey)),
          ],
        ),
        TextField(
          controller: _controller,
          maxLines: 5,
          maxLength: 100,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: '사유를 자세하게 작성해주세요',
            counterText: '',
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '$_charCount/100',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}

class _SubmissionFooter extends StatelessWidget {
  const _SubmissionFooter();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(
            '* 제출 시 부모님께 알림톡이 전송되며, 승인이 완료 되어야 합니다.',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            width: double.infinity,
            color: Colors.black,
            child: Text(
              '다음',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
