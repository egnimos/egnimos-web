import 'package:egnimos/src/pages/write_blog_pages/command_based_actions/command_constants.dart';
import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';

import '../custom_attribution/named_attributions.dart';

class CheckboxNode extends TextNode {
  CheckboxNode({
    required String id,
    required AttributedText text,
    Map<String, dynamic>? metadata,
    int indent = 0,
    required bool isComplete,
  })  : _isComplete = isComplete,
        _indent = indent,
        super(id: id, text: text, metadata: metadata) {
    // Set a block type so that TaskNode's can be styled by
    // StyleRule's.
    putMetadataValue("blockType", checkboxAttribution);
  }

  //check whether the task is complete or not
  bool get isComplete => _isComplete;
  bool _isComplete;
  set isComplete(bool newValue) {
    if (newValue == _isComplete) {
      return;
    }

    _isComplete = newValue;
    notifyListeners();
  }

  //change the index when press enter
  int get indent => _indent;
  int _indent;
  set indent(int newValue) {
    if (_indent == newValue) return;
    _indent = newValue;
    notifyListeners();
  }

  //has equivalent content
  @override
  bool hasEquivalentContent(DocumentNode other) {
    return other is CheckboxNode &&
        isComplete == other.isComplete &&
        text == other.text &&
        indent == other.indent;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is CheckboxNode &&
          runtimeType == other.runtimeType &&
          _indent == other.indent &&
          _isComplete == other.isComplete;

  @override
  int get hashCode => super.hashCode ^ _indent.hashCode ^ _isComplete.hashCode;
}

/// Builds [CheckboxComponentViewModel]s and
/// [CheckboxComponent]s for every
/// [CheckboxNode] in a document.
class CheckBoxComponentBuilder implements ComponentBuilder {
  CheckBoxComponentBuilder(this._editor);
  final DocumentEditor _editor;

  @override
  CheckboxComponentViewModel? createViewModel(
      Document document, DocumentNode node) {
    if (node is! CheckboxNode) {
      return null;
    }

    //get the ordinal or index value
    int? ordinalValue;
    ordinalValue = 1;
    //get the above node
    DocumentNode? nodeAbove = document.getNodeBefore(node);
    while (nodeAbove != null &&
        nodeAbove is CheckboxNode &&
        nodeAbove.indent >= node.indent) {
      if (nodeAbove.indent == node.indent) {
        ordinalValue = ordinalValue! + 1;
      }
      nodeAbove = document.getNodeBefore(nodeAbove);
    }

    return CheckboxComponentViewModel(
      nodeId: node.id,
      padding: EdgeInsets.zero,
      isComplete: node.isComplete,
      setComplete: (bool isComplete) {
        _editor.executeCommand(EditorCommandFunction((document, transaction) {
          // Technically, this line could be called without the editor, but
          // that's only because Super Editor hasn't fully separated document
          // queries from document edits. In the future, all edits will have
          // to go through a dedicated editing interface.
          node.isComplete = isComplete;
        }));
      },
      text: node.text,
      textStyleBuilder: noStyleBuilder,
      selectionColor: const Color(0x00000000),
      indent: node.indent,
      ordinalValue: ordinalValue,
    );
  }

  @override
  Widget? createComponent(SingleColumnDocumentComponentContext componentContext,
      SingleColumnLayoutComponentViewModel componentViewModel) {
    if (componentViewModel is! CheckboxComponentViewModel) {
      return null;
    }

    return CheckboxComponent(
      textKey: componentContext.componentKey,
      viewModel: componentViewModel,
    );
  }
}

/// View model that configures the appearance of a [CheckboxComponent].
/// View models move through various style phases, which fill out
/// various properties in the view model. For example, one phase applies
/// all [StyleRule]s, and another phase configures content selection
/// and caret appearance.
class CheckboxComponentViewModel extends SingleColumnLayoutComponentViewModel
    with TextComponentViewModel {
  CheckboxComponentViewModel({
    required String nodeId,
    double? maxWidth,
    this.ordinalValue,
    required this.indent,
    required EdgeInsetsGeometry padding,
    required this.isComplete,
    required this.setComplete,
    required this.text,
    required this.textStyleBuilder,
    this.textDirection = TextDirection.ltr,
    this.textAlignment = TextAlign.left,
    this.selection,
    required this.selectionColor,
    this.highlightWhenEmpty = false,
  }) : super(
          nodeId: nodeId,
          padding: padding,
          maxWidth: maxWidth,
        );

  bool isComplete;
  int indent;
  int? ordinalValue;
  void Function(bool) setComplete;
  AttributedText text;

  @override
  bool highlightWhenEmpty;

  @override
  TextSelection? selection;

  @override
  Color selectionColor;

  @override
  TextAlign textAlignment;

  @override
  TextDirection textDirection;

  @override
  AttributionStyleBuilder textStyleBuilder;

  @override
  CheckboxComponentViewModel copy() {
    return CheckboxComponentViewModel(
      nodeId: nodeId,
      maxWidth: maxWidth,
      padding: padding,
      isComplete: isComplete,
      indent: indent,
      setComplete: setComplete,
      ordinalValue: ordinalValue,
      text: text,
      textStyleBuilder: textStyleBuilder,
      textDirection: textDirection,
      selection: selection,
      selectionColor: selectionColor,
      highlightWhenEmpty: highlightWhenEmpty,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is CheckboxComponentViewModel &&
          runtimeType == other.runtimeType &&
          isComplete == other.isComplete &&
          setComplete == other.setComplete &&
          ordinalValue == other.ordinalValue &&
          indent == other.indent &&
          text == other.text &&
          textStyleBuilder == other.textStyleBuilder &&
          textDirection == other.textDirection &&
          textAlignment == other.textAlignment &&
          selection == other.selection &&
          selectionColor == other.selectionColor &&
          highlightWhenEmpty == other.highlightWhenEmpty;

  @override
  int get hashCode =>
      super.hashCode ^
      isComplete.hashCode ^
      setComplete.hashCode ^
      text.hashCode ^
      ordinalValue.hashCode ^
      indent.hashCode ^
      textStyleBuilder.hashCode ^
      textDirection.hashCode ^
      textAlignment.hashCode ^
      selection.hashCode ^
      selectionColor.hashCode ^
      highlightWhenEmpty.hashCode;
}

/// A document component that displays a complete-able task.
///
/// This is the widget that appears in the document layout for
/// an individual task. This widget includes a checkbox that the
/// user can tap to toggle the completeness of the task.
///
/// The appearance of a [CheckboxListComponent] is configured by the given
/// [viewModel].
class CheckboxComponent extends StatelessWidget {
  const CheckboxComponent({
    Key? key,
    required this.textKey,
    required this.viewModel,
    this.indentCalculator = _defaultIndentCalculator,
    this.showDebugPaint = false,
  }) : super(key: key);

  final GlobalKey textKey;
  final CheckboxComponentViewModel viewModel;
  final double Function(TextStyle, int indent) indentCalculator;
  final bool showDebugPaint;

  @override
  Widget build(BuildContext context) {
    final textStyle = viewModel.textStyleBuilder({});
    final indentSpace = indentCalculator(textStyle, viewModel.indent);
    final lineHeight = textStyle.fontSize! * (textStyle.height ?? 1.0);
    const manualVerticalAdjustment = 3.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: indentSpace,
          margin: const EdgeInsets.only(top: manualVerticalAdjustment),
          decoration: BoxDecoration(
            border: showDebugPaint ? Border.all(width: 1, color: Colors.grey) : null,
          ),
          child: SizedBox(
            height: lineHeight,
            child: Checkbox(
              value: viewModel.isComplete,
              onChanged: (newValue) {
                viewModel.setComplete(newValue!);
              },
            ),
          ),
        ),
        Expanded(
          child: TextComponent(
            key: textKey,
            text: viewModel.text,
            textStyleBuilder: (attributions) {
              // Show a strikethrough across the entire task if it's complete.
              final style = textStyle.merge(textStyle);
              return viewModel.isComplete
                  ? style.copyWith(
                      decoration: style.decoration == null
                          ? TextDecoration.lineThrough
                          : TextDecoration.combine(
                              [TextDecoration.lineThrough, style.decoration!]),
                    )
                  : style;
            },
            textSelection: viewModel.selection,
            selectionColor: viewModel.selectionColor,
            highlightWhenEmpty: viewModel.highlightWhenEmpty,
            showDebugPaint: showDebugPaint,
          ),
        ),
      ],
    );
  }
}


double _defaultIndentCalculator(TextStyle textStyle, int indent) {
  return (textStyle.fontSize! * 0.60) * 4 * (indent + 1);
}