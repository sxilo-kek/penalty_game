import 'package:flutter/material.dart';

import 'package:penalty_game/school/models/school.dart';
import 'package:penalty_game/school/school_layout.dart';

class SchoolCard extends StatefulWidget {
  const SchoolCard({super.key, required this.school});

  final School school;

  @override
  State<SchoolCard> createState() => _SchoolCardState();
}

class _SchoolCardState extends State<SchoolCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: SchoolLayout.surface,
          borderRadius: BorderRadius.circular(SchoolLayout.cardRadius),
          boxShadow: const [
            BoxShadow(
              color: SchoolLayout.cardShadow,
              blurRadius: 20,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(SchoolLayout.cardRadius),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              AnimatedSize(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOut,
                child: _expanded ? _buildDetails() : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(SchoolLayout.cardPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.school.name,
                        style: const TextStyle(
                          fontSize: SchoolLayout.schoolNameSize,
                          fontWeight: FontWeight.w700,
                          color: SchoolLayout.textDark,
                          height: 1.2,
                        ),
                      ),
                    ),
                    if (widget.school.discount != null) _buildBadge(),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  widget.school.description,
                  maxLines: _expanded ? 100 : 2,
                  overflow: _expanded ? TextOverflow.clip : TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: SchoolLayout.schoolDescSize,
                    color: SchoolLayout.textMuted,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.book_outlined,
                      size: SchoolLayout.iconSize,
                      color: SchoolLayout.accent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.school.courses.length} курс',
                      style: const TextStyle(
                        fontSize: SchoolLayout.metaSize,
                        color: SchoolLayout.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 16),
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 22,
                        color: SchoolLayout.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: SchoolLayout.avatarSize,
      height: SchoolLayout.avatarSize,
      decoration: BoxDecoration(
        color: SchoolLayout.iconBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: widget.school.image != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(widget.school.image!, fit: BoxFit.cover),
            )
          : Center(
              child: Text(
                widget.school.name.isNotEmpty
                    ? widget.school.name[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: SchoolLayout.accent,
                ),
              ),
            ),
    );
  }

  Widget _buildBadge() {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: SchoolLayout.badge,
        borderRadius: BorderRadius.circular(SchoolLayout.badgeRadius),
      ),
      child: Text(
        widget.school.discount!,
        style: const TextStyle(
          fontSize: SchoolLayout.badgeFontSize,
          fontWeight: FontWeight.w600,
          color: SchoolLayout.badgeText,
        ),
      ),
    );
  }

  Widget _buildDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Divider(height: 1, color: SchoolLayout.divider),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            SchoolLayout.cardPadding,
            16,
            SchoolLayout.cardPadding,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMeta(Icons.location_on_outlined, widget.school.address),
              const SizedBox(height: 8),
              _buildMeta(Icons.phone_outlined, widget.school.phone),
              const SizedBox(height: 20),
              const Text(
                'КУРСУУД',
                style: TextStyle(
                  fontSize: SchoolLayout.sectionLabelSize,
                  fontWeight: FontWeight.w700,
                  color: SchoolLayout.textMuted,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 10),
              ...widget.school.courses.map(_buildCourseRow),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMeta(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: SchoolLayout.iconSize, color: SchoolLayout.accent),
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
        color: SchoolLayout.accentLight,
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
                  color: hasDiscount ? SchoolLayout.accent : SchoolLayout.textDark,
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
