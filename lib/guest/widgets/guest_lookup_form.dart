import 'package:flutter/material.dart';

import 'package:penalty_game/guest/guest_layout.dart';
import 'package:penalty_game/guest/guest_repository.dart';

class GuestLookupForm extends StatelessWidget {
  const GuestLookupForm({
    super.key,
    required this.repository,
    required this.selectedCompany,
    required this.onCompanySelected,
    required this.onNameSelected,
    required this.onCompanyCleared,
  });

  final GuestRepository repository;
  final String? selectedCompany;
  final ValueChanged<String> onCompanySelected;
  final ValueChanged<String> onNameSelected;
  final VoidCallback onCompanyCleared;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: GuestLayout.fieldWidth,
      child: Column(
        children: [
          _CompanyField(
            repository: repository,
            initialCompany: selectedCompany,
            onSelected: onCompanySelected,
            onCleared: onCompanyCleared,
          ),
          const SizedBox(height: GuestLayout.formFieldGap),
          _NameField(
            key: ValueKey(selectedCompany),
            enabled: selectedCompany != null,
            names: selectedCompany == null
                ? const []
                : repository.namesForCompany(selectedCompany!),
            onSelected: onNameSelected,
          ),
        ],
      ),
    );
  }
}

class _CompanyField extends StatelessWidget {
  const _CompanyField({
    required this.repository,
    required this.initialCompany,
    required this.onSelected,
    required this.onCleared,
  });

  final GuestRepository repository;
  final String? initialCompany;
  final ValueChanged<String> onSelected;
  final VoidCallback onCleared;

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      initialValue: TextEditingValue(text: initialCompany ?? ''),
      optionsMaxHeight: GuestLayout.suggestionMaxHeight,
      displayStringForOption: (o) => o,
      optionsBuilder: (value) => repository.searchCompanies(value.text),
      onSelected: onSelected,
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return _RedField(
          controller: controller,
          focusNode: focusNode,
          hint: 'Company',
          onChanged: (v) {
            if (v.trim().isEmpty) onCleared();
          },
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topCenter,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(GuestLayout.suggestionBorderRadius),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: GuestLayout.fieldWidth,
                maxHeight: GuestLayout.suggestionMaxHeight,
              ),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  vertical: GuestLayout.suggestionListPaddingV,
                ),
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return ListTile(
                    title: Text(
                      option,
                      style: const TextStyle(fontSize: GuestLayout.suggestionFontSize),
                    ),
                    onTap: () => onSelected(option),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField({
    super.key,
    required this.enabled,
    required this.names,
    required this.onSelected,
  });

  final bool enabled;
  final List<String> names;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsMaxHeight: GuestLayout.suggestionMaxHeight,
      displayStringForOption: (o) => o,
      optionsBuilder: (value) {
        if (!enabled) return const Iterable<String>.empty();
        final q = value.text.trim().toLowerCase();
        if (q.isEmpty) return names;
        return names.where((n) => n.toLowerCase().contains(q));
      },
      onSelected: onSelected,
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return _WhiteField(
          controller: controller,
          focusNode: focusNode,
          hint: 'Your name',
          enabled: enabled,
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topCenter,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(GuestLayout.suggestionBorderRadius),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: GuestLayout.fieldWidth,
                maxHeight: GuestLayout.suggestionMaxHeight,
              ),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  vertical: GuestLayout.suggestionListPaddingV,
                ),
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return ListTile(
                    title: Text(
                      option,
                      style: const TextStyle(fontSize: GuestLayout.suggestionFontSize),
                    ),
                    onTap: () => onSelected(option),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RedField extends StatelessWidget {
  const _RedField({
    required this.controller,
    required this.focusNode,
    required this.hint,
    this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: GuestLayout.companyFieldHeight,
      decoration: BoxDecoration(
        color: GuestLayout.cocaRed,
        borderRadius: BorderRadius.circular(GuestLayout.fieldRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: GuestLayout.fieldPaddingH),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        style: const TextStyle(
          color: Colors.white,
          fontSize: GuestLayout.fieldFontSize,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.75),
            fontSize: GuestLayout.fieldFontSize,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }
}

class _WhiteField extends StatelessWidget {
  const _WhiteField({
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.enabled,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: GuestLayout.nameFieldHeight,
      decoration: BoxDecoration(
        color: enabled ? Colors.white : Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(GuestLayout.whiteFieldRadius),
        boxShadow: enabled
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: GuestLayout.fieldPaddingH),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        enabled: enabled,
        style: TextStyle(
          color: enabled ? Colors.black87 : Colors.black38,
          fontSize: GuestLayout.fieldFontSize,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.black.withValues(alpha: 0.35),
            fontSize: GuestLayout.fieldFontSize,
          ),
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }
}
