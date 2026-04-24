import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/cv_template.dart';
import '../../cv/providers/cv_generation_provider.dart';
import './template_provider.dart';

class TemplateSelectionState {
  final List<CVTemplate> templates;
  final String? selectedStyleId;
  final bool isLoading;
  final String? errorMessage;

  TemplateSelectionState({
    this.templates = const [],
    this.selectedStyleId,
    this.isLoading = false,
    this.errorMessage,
  });

  TemplateSelectionState copyWith({
    List<CVTemplate>? templates,
    String? selectedStyleId,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TemplateSelectionState(
      templates: templates ?? this.templates,
      selectedStyleId: selectedStyleId ?? this.selectedStyleId,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class TemplateSelectionController extends Notifier<TemplateSelectionState> {
  @override
  TemplateSelectionState build() {
    final templatesAsync = ref.watch(templatesProvider);
    final creationState = ref.watch(cvCreationProvider);

    return templatesAsync.when(
      data: (templates) {
        final selectedStyle = creationState.selectedStyle;

        // Auto-select logic moved from build method
        if (templates.isNotEmpty &&
            !templates.any((t) => t.id == selectedStyle)) {
          // Use a microtask to avoid updating during build
          Future.microtask(() {
            ref.read(cvCreationProvider.notifier).setStyle(templates.first.id);
          });
        }

        return TemplateSelectionState(
          templates: templates,
          selectedStyleId: selectedStyle,
          isLoading: false,
        );
      },
      loading: () => TemplateSelectionState(isLoading: true),
      error: (err, stack) => TemplateSelectionState(
        isLoading: false,
        errorMessage: err.toString(),
      ),
    );
  }

  void selectStyle(String styleId) {
    ref.read(cvCreationProvider.notifier).setStyle(styleId);
  }
}

final templateSelectionControllerProvider =
    NotifierProvider<TemplateSelectionController, TemplateSelectionState>(
      TemplateSelectionController.new,
    );
