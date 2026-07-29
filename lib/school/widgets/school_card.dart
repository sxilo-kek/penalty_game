import 'package:flutter/material.dart';

import 'package:penalty_game/school/models/school.dart';
import 'package:penalty_game/school/school_layout.dart';
import 'package:penalty_game/school/widgets/school_detail_popup.dart';

class SchoolCard extends StatelessWidget {
  const SchoolCard({super.key, required this.school});

  final School school;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetail(context),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: SchoolLayout.surface,
            borderRadius: BorderRadius.circular(SchoolLayout.cardRadius),
            boxShadow: const [
              BoxShadow(
                color: SchoolLayout.cardShadow,
                blurRadius: 24,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(SchoolLayout.cardRadius),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildImage(),
                Padding(
                  padding: const EdgeInsets.all(SchoolLayout.cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        school.name,
                        style: const TextStyle(
                          fontSize: SchoolLayout.schoolNameSize,
                          fontWeight: FontWeight.w700,
                          color: SchoolLayout.textDark,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        school.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: SchoolLayout.schoolDescSize,
                          color: SchoolLayout.textMuted,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildChip(
                            Icons.menu_book_rounded,
                            '${school.courses.length} курс',
                          ),
                          if (school.discount != null) ...[
                            const SizedBox(width: 8),
                            _buildBadge(),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      height: SchoolLayout.cardImageHeight,
      color: SchoolLayout.primaryLight,
      child: school.image != null
          ? Image.asset(school.image!, fit: BoxFit.cover, width: double.infinity)
          : Center(
              child: Icon(
                Icons.school_rounded,
                size: 48,
                color: SchoolLayout.primary.withValues(alpha: 0.3),
              ),
            ),
    );
  }

  Widget _buildChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: SchoolLayout.primaryLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: SchoolLayout.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: SchoolLayout.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: SchoolLayout.badge,
        borderRadius: BorderRadius.circular(SchoolLayout.badgeRadius),
      ),
      child: Text(
        school.discount!,
        style: const TextStyle(
          fontSize: SchoolLayout.badgeFontSize,
          fontWeight: FontWeight.w600,
          color: SchoolLayout.badgeText,
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, __, ___) => SchoolDetailPopup(school: school),
      transitionBuilder: (_, animation, __, child) {
        final curve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return ScaleTransition(
          scale: Tween<double>(begin: 0.85, end: 1.0).animate(curve),
          child: FadeTransition(opacity: curve, child: child),
        );
      },
    );
  }
}
