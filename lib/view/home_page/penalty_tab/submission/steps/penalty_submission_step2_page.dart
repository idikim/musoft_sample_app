import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madezone_study_student_app/provider/penalty_submission_provider.dart';

class PenaltySubmissionStep2Page extends ConsumerStatefulWidget {
  const PenaltySubmissionStep2Page({super.key});

  @override
  ConsumerState<PenaltySubmissionStep2Page> createState() =>
      _PenaltySubmissionStep2PageState();
}

class _PenaltySubmissionStep2PageState
    extends ConsumerState<PenaltySubmissionStep2Page> {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(selectedImagePathsProvider.notifier).state = [];
    });
  }

  Future<void> _pickImage() async {
    final currentImages = ref.read(selectedImagePathsProvider);
    if (currentImages.length >= 3) {
      return;
    }
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      ref.read(selectedImagePathsProvider.notifier).state = [
        ...currentImages,
        image.path,
      ];
    }
  }

  void _removeImage(int index) {
    final currentImages = ref.read(selectedImagePathsProvider);
    final updatedImages = List<String>.from(currentImages);
    updatedImages.removeAt(index);
    ref.read(selectedImagePathsProvider.notifier).state = updatedImages;
  }

  @override
  Widget build(BuildContext context) {
    final imagePaths = ref.watch(selectedImagePathsProvider);

    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        Text(
          '파일 제출하기',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          '파일은 최대 3개까지 업로드 할 수 있습니다.',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '제출 목록 ${imagePaths.length}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            imagePaths.length >= 3
                ? Container()
                : GestureDetector(
                  onTap: _pickImage,
                  child: Text(
                    '추가하기',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
          ],
        ),
        Container(
          width: double.infinity,
          height: 100,
          color: imagePaths.isEmpty ? Colors.black12 : Colors.transparent,
          child:
              imagePaths.isEmpty
                  ? Center(child: Text('업로드된 파일이 없습니다'))
                  : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: imagePaths.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: 1,
                            child: Image.file(
                              File(imagePaths[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 2,
                            right: 2,
                            child: GestureDetector(
                              onTap: () {
                                _removeImage(index);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.cancel,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(width: 12);
                    },
                  ),
        ),
      ],
    );
  }
}
