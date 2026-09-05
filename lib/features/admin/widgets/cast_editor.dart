import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:task/core/constants/app_colors.dart';
import 'package:task/features/admin/widgets/admin_form_field.dart';
import 'package:task/features/movie_details/data/helpers/cast_model.dart';
import 'package:task/shared/custom_text.dart';

class CastEditor extends StatefulWidget {
  final List<CastModel> cast;
  final ValueChanged<List<CastModel>> onChanged;

  const CastEditor({super.key, required this.cast, required this.onChanged});

  @override
  State<CastEditor> createState() => _CastEditorState();
}

class _CastEditorState extends State<CastEditor> {
  final _nameController = TextEditingController();
  final _characterController = TextEditingController();
  final _photoController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _characterController.dispose();
    _photoController.dispose();
    super.dispose();
  }

  void _addCastMember() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final member = CastModel(
      // Negative, always-decreasing ids so admin-entered cast members can
      // never collide with real TMDB person ids (which are positive).
      id: -DateTime.now().millisecondsSinceEpoch,
      name: name,
      character: _characterController.text.trim().isEmpty
          ? null
          : _characterController.text.trim(),
      profilePath: _photoController.text.trim().isEmpty
          ? null
          : _photoController.text.trim(),
    );

    widget.onChanged([...widget.cast, member]);
    _nameController.clear();
    _characterController.clear();
    _photoController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${member.name} added — ${widget.cast.length + 1} cast member(s) staged'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _removeCastMember(int index) {
    final updated = List<CastModel>.of(widget.cast)..removeAt(index);
    widget.onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.cast.isNotEmpty) ...[
          CustomText(
            '${widget.cast.length} cast member${widget.cast.length == 1 ? '' : 's'} added',
            color: AppColors.neutral,
            size: 12,
          ),
          const Gap(8),
        ],
        for (int i = 0; i < widget.cast.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(10),
              clipBehavior: Clip.antiAlias,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF353534),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomText(
                        widget.cast[i].character == null
                            ? widget.cast[i].name
                            : '${widget.cast[i].name} as ${widget.cast[i].character}',
                        color: Colors.white,
                        size: 13,
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => _removeCastMember(i),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.close,
                          color: AppColors.neutral,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        AdminFormField(
          _nameController,
          'Actor name',
          Icons.person_outline,
          textInputAction: TextInputAction.next,
        ),
        const Gap(14),
        AdminFormField(
          _characterController,
          'Character (optional)',
          Icons.theater_comedy_outlined,
          textInputAction: TextInputAction.next,
        ),
        const Gap(14),
        AdminFormField(
          _photoController,
          'Photo URL (optional)',
          Icons.image_outlined,
          textInputAction: TextInputAction.done,
          // Lets the admin also submit by pressing "done" on the keyboard,
          // not just by tapping the button below — one less way for a tap
          // to be missed.
          onFieldSubmitted: (_) => _addCastMember(),
        ),
        const Gap(14),
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: _addCastMember,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 1.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: CustomText(
                  '+ Add Cast Member',
                  color: AppColors.primary,
                  weight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}