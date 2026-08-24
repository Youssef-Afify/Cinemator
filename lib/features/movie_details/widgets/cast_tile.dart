import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:task/features/movie_details/data/helpers/cast_model.dart';

class CastTile extends StatelessWidget {
  final CastModel cast;

  const CastTile({super.key, required this.cast});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: const Color(0xFF2A2A2A),
            backgroundImage: cast.profilePath != null
                ? NetworkImage(cast.profileUrl)
                : null,
            child: cast.profilePath == null
                ? const Icon(Icons.person, color: Colors.white38)
                : null,
          ),
          const Gap(6),
          Text(
            cast.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}