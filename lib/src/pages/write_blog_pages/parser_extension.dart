import 'package:egnimos/src/config/responsive.dart';
import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';

import 'custom_attribution/font_decoration_attribution.dart';
import 'custom_attribution/font_size_attribution.dart';
import 'custom_document_nodes/checkbox_node.dart';
import 'custom_document_nodes/html_node.dart';

const imageNode = "image_node";
const paragraphNode = "paragraph_node";
const listItemNode = "listitem_node";
const horizontalRuleNode = "horizontal_rule_node";
const checkboxNode = "checkbox_node";
const htmlNode = "html_node";

///[ImageNodeJsonParser] Json Parser For [ImageNode]
///[toJson] to convert into json object
///[fromJson] to rewind back to the [ImageNode] object
extension ImageNodeJsonParser on ImageNode {
  Map<String, dynamic> toJson(ImageNode node) {
    //print(double.infinity);
    final currentStyles = SingleColumnLayoutComponentStyles.fromMetadata(node);
    return {
      "id": node.id,
      "width": currentStyles.width,
      "is_infinity": node.metadata["is_infinity"] ?? false,
      "node": imageNode,
      "uri": node.imageUrl,
      "alt_text": node.altText,
      "metadata": {
        'blockType': (node.metadata['blockType'] as NamedAttribution).id,
      },
    };
  }

  static ImageNode fromJson(Map<String, dynamic> data) {
    final node = ImageNode(
      id: data["id"],
      imageUrl: data["uri"] ?? "",
      altText: data["alt_text"] ?? "",
      metadata: {
        'blockType': NamedAttribution(data["metadata"]['blockType']),
      },
    );
    final currentStyles = SingleColumnLayoutComponentStyles.fromMetadata(node);
    SingleColumnLayoutComponentStyles(
      width: data["is_infinity"] ?? false
          ? Responsive.widthMultiplier * 100.0
          : currentStyles.width,
      padding: currentStyles.padding,
    ).applyTo(node);
    return node;
  }
}

///[HtmlNodeJsonParser] Json Parser For [HtmlNode]
///[toJson] to convert into json object
///[fromJson] to rewind back to the [HtmlNode] object
extension HtmlNodeJsonParser on HtmlNode {
  Map<String, dynamic> toJson(HtmlNode node) {
    //print(double.infinity);
    final currentStyles = SingleColumnLayoutComponentStyles.fromMetadata(node);
    return {
      "id": node.id,
      "width": currentStyles.width,
      "is_infinity": node.metadata["is_infinity"] ?? false,
      "node": htmlNode,
      "html": node.html,
      "metadata": {
        'blockType': (node.metadata['blockType'] as NamedAttribution).id,
      },
    };
  }

  static HtmlNode fromJson(Map<String, dynamic> data) {
    final node = HtmlNode(
      id: data["id"],
      html: data["html"] ?? "",
      metadata: {
        'blockType': NamedAttribution(data["metadata"]['blockType']),
      },
    );
    final currentStyles = SingleColumnLayoutComponentStyles.fromMetadata(node);
    SingleColumnLayoutComponentStyles(
      width: data["is_infinity"] ?? false
          ? Responsive.widthMultiplier * 100.0
          : currentStyles.width,
      padding: currentStyles.padding,
    ).applyTo(node);
    return node;
  }
}

///[AttributedTextJsonParser] Json Parser For [AttributedText]
extension AttributedTextJsonParser on AttributedText {
  Map<String, dynamic> toJson(TextNode node) {
    final attributionSpans = node.text.getAttributionSpansInRange(
      attributionFilter: (_) => true,
      range: SpanRange(
        start: node.beginningPosition.offset,
        end: node.endPosition.offset,
      ),
    );
    return {
      "text": node.text.text,
      "spans": _spansToJson(attributionSpans),
    };
  }

  List<Map<String, dynamic>> _spansToJson(Set<AttributionSpan> spans) {
    List<Map<String, dynamic>> data = [];
    // ignore: invalid_use_of_visible_for_testing_member
    for (var span in spans) {
      Map<String, dynamic> spanJson = {
        "attribution_id": span.attribution.id,
        "start": span.start,
        "end": span.end,
      };
      final attribution = span.attribution;
      if (attribution == boldAttribution) {
      } else if (attribution == italicsAttribution) {
      } else if (attribution == underlineAttribution) {
      } else if (attribution == strikethroughAttribution) {
      } else if (attribution is LinkAttribution) {
        spanJson["decoration_data"] = {
          "url": attribution.url.toString(),
        };
      } else if (attribution is FontSizeDecorationAttribution) {
        spanJson["decoration_data"] = {
          "size": attribution.fontSize,
        };
      } else if (attribution is FontColorDecorationAttribution) {
        spanJson["decoration_data"] = {
          "color": attribution.fontColor.value,
        };
      } else if (attribution is FontBackgroundColorDecorationAttribution) {
        spanJson["decoration_data"] = {
          "color": attribution.fontBackgroundColor.value,
        };
      } else if (attribution is FontDecorationColorDecorationAttribution) {
        spanJson["decoration_data"] = {
          "color": attribution.fontDecorationColor.value,
        };
      } else if (attribution is FontDecorationStyleAttribution) {
        spanJson["decoration_data"] = {
          "decoration_style": attribution.fontDecorationStyle.name,
        };
      }
      data.add(spanJson);
    }
    return data;
  }

  Set<AttributionSpan> _spansFromJson(List<Map<String, dynamic>> datas) {
    Set<AttributionSpan> attributionSpans = {};

    for (var data in datas) {
      String attributionId = data["attribution_id"];
      Attribution attribution = boldAttribution;
      int start = data["start"];
      int end = data["end"];
      if (attributionId == boldAttribution.id) {
        attribution = boldAttribution;
      } else if (attributionId == italicsAttribution.id) {
        attribution = italicsAttribution;
      } else if (attributionId == underlineAttribution.id) {
        attribution = underlineAttribution;
      } else if (attributionId == strikethroughAttribution.id) {
        attribution = strikethroughAttribution;
      } else if (attributionId == LinkAttribution(url: Uri.parse("")).id) {
        attribution = LinkAttribution(
          url: Uri.parse(data["decoration_data"]["url"].toString()),
        );
      } else if (attributionId ==
          FontSizeDecorationAttribution(fontSize: 0).id) {
        attribution = FontSizeDecorationAttribution(
          fontSize: data["decoration_data"]["size"],
        );
      } else if (attributionId ==
          FontColorDecorationAttribution(fontColor: Colors.white).id) {
        attribution = FontColorDecorationAttribution(
          fontColor:
              Color(int.parse(data["decoration_data"]["color"].toString())),
        );
      } else if (attributionId ==
          FontBackgroundColorDecorationAttribution(
                  fontBackgroundColor: Colors.white)
              .id) {
        attribution = FontBackgroundColorDecorationAttribution(
          fontBackgroundColor:
              Color(int.parse(data["decoration_data"]["color"].toString())),
        );
      } else if (attributionId ==
          FontDecorationColorDecorationAttribution(
            fontDecorationColor: Colors.white,
          ).id) {
        attribution = FontDecorationColorDecorationAttribution(
          fontDecorationColor:
              Color(int.parse(data["decoration_data"]["color"].toString())),
        );
      } else if (attributionId ==
          FontDecorationStyleAttribution(
            fontDecorationStyle: TextDecorationStyle.solid,
          ).id) {
        attribution = FontDecorationStyleAttribution(
          fontDecorationStyle: TextDecorationStyle.values.firstWhere(
            (val) => val.name == data["decoration_data"]["decoration_style"],
            orElse: () => TextDecorationStyle.solid,
          ),
        );
      }
      attributionSpans.add(
        AttributionSpan(
          attribution: attribution,
          start: start,
          end: end,
        ),
      );
    }
    return attributionSpans;
  }

  AttributedText _fromJson(Map<String, dynamic> data) {
    return AttributedText(
      text: data["text"],
    );
  }

  //set the decorations to the given attributed text
  AttributedText setGetDecorations(Map<String, dynamic> data) {
    final attributedText = _fromJson(data["attributed_text"]);
    final List spans = data["attributed_text"]["spans"];
    final setSpans = _spansFromJson(
      List<Map<String, dynamic>>.from(
        spans,
      ),
    );

    for (var span in setSpans) {
      final attribution = span.attribution;
      attributedText.addAttribution(
        attribution,
        SpanRange(
          start: span.start,
          end: span.end,
        ),
      );
    }

    return attributedText;
  }
}

///[ParagraphNodeJsonParser] Json Parser For [ParagraphNode]
///[toJson] to convert into json object
///[fromJson] to rewind back to the [ParagraphNode] object
extension ParagraphNodeJsonParser on ParagraphNode {
  Map<String, dynamic> toJson(ParagraphNode node) {
    return {
      "id": node.id,
      "node": paragraphNode,
      "attributed_text": node.text.toJson(node),
      "metadata": {
        'blockType': (node.metadata['blockType'] as NamedAttribution).id,
      },
    };
  }

  static ParagraphNode fromJson(Map<String, dynamic> data) {
    return ParagraphNode(
      id: data["id"],
      text: AttributedText().setGetDecorations(data),
      metadata: {
        'blockType': NamedAttribution(data["metadata"]['blockType']),
      },
    );
  }
}

///[ListItemNodeJsonParser] Json Parser For [ListItemNode]
///[toJson] to convert into json object
///[fromJson] to rewind back to the [ListItemNode] object
extension ListItemNodeJsonParser on ListItemNode {
  Map<String, dynamic> toJson(ListItemNode node) {
    return {
      "id": node.id,
      "node": listItemNode,
      "list_item_type": node.type.name,
      "attributed_text": node.text.toJson(node),
      "indent": node.indent,
      "metadata": {
        'blockType': (node.metadata['blockType'] as NamedAttribution).id,
      },
    };
  }

  static ListItemNode fromJson(Map<String, dynamic> data) {
    return ListItemNode(
      id: data["id"],
      itemType: ListItemType.values.firstWhere(
        (element) => element.name == data["list_item_type"],
        orElse: () => ListItemType.ordered,
      ),
      indent: data["indent"],
      text: AttributedText().setGetDecorations(data),
      metadata: {
        'blockType': NamedAttribution(data["metadata"]['blockType']),
      },
    );
  }
}

///[CheckboxNodeJsonParser] Json Parser For [CheckboxNode]
///[toJson] to convert into json object
///[fromJson] to rewind back to the [CheckboxNode] object
extension CheckboxNodeJsonParser on CheckboxNode {
  Map<String, dynamic> toJson(CheckboxNode node) {
    return {
      "id": node.id,
      "node": checkboxNode,
      "attributed_text": node.text.toJson(node),
      "indent": node.indent,
      "metadata": {
        'blockType': (node.metadata['blockType'] as NamedAttribution).id,
      },
    };
  }

  static CheckboxNode fromJson(Map<String, dynamic> data) {
    return CheckboxNode(
      id: data["id"],
      isComplete: false,
      indent: data["indent"],
      text: AttributedText().setGetDecorations(data),
      metadata: {
        'blockType': NamedAttribution(data["metadata"]['blockType']),
      },
    );
  }
}

///[HorizontalRuleNodeJsonParser] Json Parser For [HorizontalRuleNode]
///[toJson] to convert into json object
///[fromJson] to rewind back to the [HorizontalRuleNode] object
extension HorizontalRuleNodeJsonParser on HorizontalRuleNode {
  Map<String, dynamic> toJson(HorizontalRuleNode node) {
    return {
      "id": node.id,
      "node": horizontalRuleNode,
    };
  }

  static HorizontalRuleNode fromJson(Map<String, dynamic> data) {
    return HorizontalRuleNode(
      id: data["id"],
    );
  }
}

///[DocumentJsonParser] Json Parser For [Document]
///[toJson] to convert into json object
///[fromJson] to rewind back to the [Document] object
extension DocumentJsonParser on MutableDocument {
  Map<String, dynamic> toJson(List<DocumentNode> nodes) {
    List<Map<String, dynamic>> jsonList = [];
    for (var node in nodes) {
      Map<String, dynamic> data = {};
      if (node is ImageNode) {
        data = node.toJson(node);
      }
      if (node is CheckboxNode) {
        data = node.toJson(node);
      }
      if (node is HtmlNode) {
        data = node.toJson(node);
      }
      if (node is ParagraphNode) {
        data = node.toJson(node);
      }
      if (node is ListItemNode) {
        data = node.toJson(node);
      }
      if (node is HorizontalRuleNode) {
        data = node.toJson(node);
      }
      jsonList.add(data);
    }
    return {
      "doc": jsonList,
    };
  }

  //get the title description
  Map<String, dynamic> getBlogSnaps(List<DocumentNode> nodes) {
    String? title;
    String? description;
    String? imageUri;
    List<String> tags = [];
    List<String> searchChars = [];
    num readingTime = 0;
    int wordCount = 0;
    for (var node in nodes) {
      //get the word count
      if (node is TextNode) {
        //get the length
        wordCount += node.text.text.split(" ").length;
      }
      //get the image
      if (node is ImageNode) {
        if (imageUri != null) {
          continue;
        }
        imageUri = node.imageUrl;
      }
      //get the description info
      if (node is ParagraphNode) {
        //get the tags value
        final rex = RegExp(r'\B(\#[a-zA-Z]+\b)(?!;)');
        if (rex.hasMatch(node.text.text)) {
          final values = rex
              .allMatches(node.text.text)
              .map((e) => e.input.substring(e.start, e.end))
              .toList();
          tags.addAll(values);
        }
        //check the blocktype
        final type = node.metadata['blockType'] as NamedAttribution;
        //h1
        if (type == header1Attribution) {
          if (title != null) {
            continue;
          }
          title = node.text.text;
        }
        //paragraph
        if (type.id == const NamedAttribution("paragraph").id) {
          if (description != null) {
            continue;
          }
          description = node.text.text;
        }
      }
    }
    //get the reading time in minutes
    readingTime = (wordCount / 200);
    //print("READING TIME :: $readingTime");
    //get the search chars
    if (title != null) {
      for (int i = 1; i <= title.length; i++) {
        // if (i <= 1) {
        //   searchChars.add(title.substring(0));
        //   continue;
        // }
        searchChars.add(title.substring(0, i).toLowerCase());
      }
      //print("SEARCH CHARS :: $searchChars");
    }
    return {
      "title": title,
      "description": description,
      "tags": tags,
      "image_uri": imageUri,
      "reading_time": readingTime,
      "search_chars": searchChars,
    };
  }

  static MutableDocument fromJson(Map<String, dynamic> data) {
    final List jsonList = data["doc"];
    List<DocumentNode> nodes = [];
    //get the nodes
    for (var doc in jsonList) {
      switch (doc["node"]) {
        case listItemNode:
          nodes.add(ListItemNodeJsonParser.fromJson(doc));
          break;
        case paragraphNode:
          nodes.add(ParagraphNodeJsonParser.fromJson(doc));
          break;
        case checkboxNode:
          nodes.add(CheckboxNodeJsonParser.fromJson(doc));
          break;
        case imageNode:
          nodes.add(ImageNodeJsonParser.fromJson(doc));
          break;
        case htmlNode:
          nodes.add(HtmlNodeJsonParser.fromJson(doc));
          break;
        case horizontalRuleNode:
          nodes.add(HorizontalRuleNodeJsonParser.fromJson(doc));
          break;
        default:
      }
    }
    return MutableDocument(
      nodes: nodes,
    );
  }
}
