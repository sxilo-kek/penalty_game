import 'package:flutter/material.dart';

import 'package:penalty_game/school/models/school.dart';
import 'package:penalty_game/school/school_layout.dart';

class SchoolDetailPopup extends StatelessWidget {
  const SchoolDetailPopup({super.key, required this.school});

  final School school;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Material(
            color: SchoolLayout.surface,
            borderRadius: BorderRadius.circular(24),
            clipBehavior: Clip.antiAlias,
            elevation: 24,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHero(),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          school.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: SchoolLayout.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          school.description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: SchoolLayout.textMuted,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildMeta(Icons.location_on_outlined, school.address),
                        const SizedBox(height: 8),
                        _buildMeta(Icons.phone_outlined, school.phone),
                        if (school.discount != null) ...[
                          const SizedBox(height: 8),
                          _buildMeta(Icons.local_offer_outlined, school.discount!),
                        ],
                        const SizedBox(height: 24),
                        const Text(
                          'КУРСУУД',
                          style: TextStyle(
                            fontSize: SchoolLayout.sectionLabelSize,
                            fontWeight: FontWeight.w700,
                            color: SchoolLayout.textMuted,
                            letterSpacing: 1.4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...school.courses.map(_buildCourseRow),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: FilledButton.styleFrom(
                              backgroundColor: SchoolLayout.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Хаах',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      height: 160,
      color: SchoolLayout.primaryLight,
      child: school.image != null
          ? Image.asset(school.image!, fit: BoxFit.cover, width: double.infinity)
          : Center(
              child: Icon(
                Icons.school_rounded,
                size: 56,
                color: SchoolLayout.primary.withValues(alpha: 0.3),
              ),
            ),
    );
  }

  Widget _buildMeta(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: SchoolLayout.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: SchoolLayout.metaSize,
              color: SchoolLayout.textDark,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseRow(Course course) {
    final hasDiscount = course.discountPrice != null;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(SchoolLayout.courseRowPad),
      decoration: BoxDecoration(
        color: SchoolLayout.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.name,
                  style: const TextStyle(
                    fontSize: SchoolLayout.courseTitleSize,
                    fontWeight: FontWeight.w600,
                    color: SchoolLayout.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  course.duration,
                  style: const TextStyle(
                    fontSize: 12,
                    color: SchoolLayout.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (hasDiscount)
                Text(
                  _formatPrice(course.price),
                  style: const TextStyle(
                    fontSize: SchoolLayout.priceSizeSmall,
                    color: SchoolLayout.priceStrike,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              Text(
                _formatPrice(
                  hasDiscount ? course.discountPrice! : course.price,
                ),
                style: TextStyle(
                  fontSize: SchoolLayout.priceSize,
                  fontWeight: FontWeight.w800,
                  color: hasDiscount ? SchoolLayout.discountPrice : SchoolLayout.textDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatPrice(int price) {
    final s = price.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return '${buf}₮';
  }
}
