import 'package:cached_network_image/cached_network_image.dart';
import 'package:egnimos/src/models/collection_file.dart';
import 'package:egnimos/src/theme/color_theme.dart';
import 'package:egnimos/src/widgets/create_pop_up_modal_widget.dart';
import 'package:egnimos/src/widgets/indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/collection_provider.dart';
import '../utility/enum.dart';

final enableEditingFile = ValueNotifier<String>("");

// ignore: must_be_immutable
class FileCollectionList extends StatelessWidget {
  final BoxConstraints? constraints;
  final bool disableActions;
  final void Function(List<CollectionFile> files)? selectedFiles;
  FileCollectionList({
    Key? key,
    this.constraints,
    this.disableActions = false,
    this.selectedFiles,
  }) : super(key: key);
  final stackScreen = ValueNotifier<List<CollectionFilesType>>([
    CollectionFilesType.collections,
  ]);
  String collectionName = "";
  String extensionName = "";

  Widget screens(CollectionFilesType fileType) {
    switch (fileType) {
      case CollectionFilesType.collections:
        return CollectionWidget(
          stackScreen: stackScreen,
          setCollection: (value) {
            collectionName = value;
          },
        );
      case CollectionFilesType.extensions:
        return ExtensionWidget(
          collectionName: collectionName,
          stackScreen: stackScreen,
          setExtension: (value) {
            extensionName = value;
          },
        );
      case CollectionFilesType.files:
        return CollectionFiles(
          collectionName: collectionName,
          extensionName: extensionName,
          selectedFiles: selectedFiles,
          disableActions: disableActions,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<CollectionFilesType>>(
      valueListenable: stackScreen,
      builder: (context, values, child) => ListView(
        shrinkWrap: true,
        children: [
          //navigators
          ListTile(
            leading: values.length > 1
                ? IconButton(
                    onPressed: () {
                      final stacks = <CollectionFilesType>[];
                      stacks.addAll(values);
                      stacks.removeLast();
                      stackScreen.value = stacks;
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: ColorTheme.bgColor2,
                    ),
                  )
                : null,
          ),

          const SizedBox(
            height: 20.0,
          ),

          screens(values.last),
        ],
      ),
    );
  }
}

class CollectionWidget extends StatelessWidget {
  CollectionWidget({
    Key? key,
    required this.stackScreen,
    required this.setCollection,
  }) : super(key: key);
  final void Function(String collection) setCollection;
  final isLoading = ValueNotifier<bool>(true);
  final ValueNotifier<List<CollectionFilesType>> stackScreen;

  void loadInfo(BuildContext context) async {
    try {
      isLoading.value = true;
      final user = Provider.of<AuthProvider>(context, listen: false).user;
      await Provider.of<CollectionProvider>(context, listen: false)
          .getCollections(user!.id);
      isLoading.value = false;
    } catch (e) {
      //print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  Widget collectionWidget(String collectionName) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 8.0,
      ),
      child: GestureDetector(
        onTap: () {
          setCollection(collectionName);
          stackScreen.value = [
            ...stackScreen.value,
            CollectionFilesType.extensions
          ];
        },
        child: Column(
          children: [
            if (PickerType.image.name == collectionName)
              Image.asset(
                "assets/images/png/image_collection.png",
                width: 150.0,
                height: 100.0,
              )
            else
              Image.asset(
                "assets/images/png/video_collection.png",
                width: 150.0,
                height: 100.0,
              ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              collectionName,
              style: GoogleFonts.rubik(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    loadInfo(context);
    return ValueListenableBuilder<bool>(
      valueListenable: isLoading,
      builder: (context, loading, child) {
        if (loading) {
          return const Align(
            child: CircularProgressIndicator(),
          );
        } else {
          return Consumer<CollectionProvider>(builder: (context, cp, __) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                children: cp.collectionNames
                    .map(
                      (cat) => collectionWidget(cat),
                    )
                    .toList(),
              ),
            );
          });
        }
      },
    );
  }
}

class ExtensionWidget extends StatelessWidget {
  final String collectionName;
  ExtensionWidget({
    Key? key,
    required this.collectionName,
    required this.stackScreen,
    required this.setExtension,
  }) : super(key: key);
  final void Function(String collection) setExtension;
  final isLoading = ValueNotifier<bool>(true);
  final ValueNotifier<List<CollectionFilesType>> stackScreen;

  void loadInfo(BuildContext context) async {
    try {
      final user = Provider.of<AuthProvider>(context, listen: false).user;
      await Provider.of<CollectionProvider>(context, listen: false)
          .getExtensions(user!.id, collectionName);
      isLoading.value = false;
    } catch (e) {
      //print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  Widget extensionWidget(String extension) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 8.0,
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setExtension(extension);
              stackScreen.value = [
                ...stackScreen.value,
                CollectionFilesType.files
              ];
            },
            child: Container(
              width: 130.0,
              height: 100.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  width: 1.2,
                  color: ColorTheme.bgColor2,
                ),
                color: Colors.grey.shade200,
              ),
              alignment: Alignment.center,
              child: Text(
                ".$extension",
                style: GoogleFonts.rubik(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            ".$extension",
            style: GoogleFonts.rubik(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    loadInfo(context);
    return ValueListenableBuilder<bool>(
        valueListenable: isLoading,
        builder: (context, loading, child) {
          if (loading) {
            return const Align(
              child: CircularProgressIndicator(),
            );
          } else {
            return Consumer<CollectionProvider>(builder: (context, cp, __) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  children: [
                    const SizedBox(
                      width: 20.0,
                    ),
                    ...cp.collectionExtensions
                        .map(
                          (ext) => extensionWidget(ext),
                        )
                        .toList()
                  ],
                ),
              );
            });
          }
        });
  }
}

class CollectionFiles extends StatefulWidget {
  final String collectionName;
  final String extensionName;
  final bool disableActions;
  final void Function(List<CollectionFile> files)? selectedFiles;
  const CollectionFiles({
    Key? key,
    required this.collectionName,
    required this.extensionName,
    this.disableActions = false,
    this.selectedFiles,
  }) : super(key: key);

  @override
  State<CollectionFiles> createState() => _CollectionFilesState();
}

class _CollectionFilesState extends State<CollectionFiles> {
  final isLoading = ValueNotifier<bool>(true);

  // final ValueNotifier<List<CollectionFilesType>> screenType;
  void loadInfo(BuildContext context) async {
    try {
      final user = Provider.of<AuthProvider>(context, listen: false).user;
      await Provider.of<CollectionProvider>(context, listen: false)
          .getFiles(user!.id, widget.collectionName, widget.extensionName);
      isLoading.value = false;
    } catch (e) {
      //print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  final editableFilename = TextEditingController();
  final focusNode = FocusNode();
  List<CollectionFile> selectedFiles = [];

  Widget fileWidget(
    BuildContext context, {
    required CollectionFile file,
    required List<CollectionFile> files,
  }) {
    switch (file.collectionName) {
      case "image":
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 8.0,
          ),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  //selected box
                  if (widget.selectedFiles != null)
                    if (widget.disableActions)
                      if (selectedFiles
                          .where((e) => e.id == file.id)
                          .toList()
                          .isNotEmpty)
                        Container(
                          width: 150,
                          height: 134,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              width: 2.6,
                              color: ColorTheme.bgColor18,
                            ),
                          ),
                        ),

                  //images
                  InkWell(
                    mouseCursor: SystemMouseCursors.click,
                    onTap: () {
                      if (!widget.disableActions) {
                        final index = files.indexOf(file);
                        IndicatorWidget.showCreateBlogModal(
                          context,
                          barrierDismissible: false,
                          child: ViewPopUp(
                            uri: files,
                            index: index,
                          ),
                        );
                        return;
                      }

                      final isPresent = selectedFiles
                          .where((e) => e.id == file.id)
                          .toList()
                          .isNotEmpty;
                      if (!isPresent) {
                        //store to the selected file
                        selectedFiles.add(file);
                        //update the function
                        widget.selectedFiles!(selectedFiles);
                      } else {
                        //remove the selected file
                        selectedFiles.removeWhere((f) => f.id == file.id);
                        //update the function
                        widget.selectedFiles!(selectedFiles);
                      }
                      setState(() {});
                    },
                    child: Container(
                      width: 140.0,
                      height: 124.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            file.uri,
                            // errorWidget: (context, url, error) => IntrinsicWidth(
                            //   child: IntrinsicHeight(
                            //     child: Image.asset(
                            //       "assets/images/png/Group_392-3.png",
                            //       fit: BoxFit.contain,
                            //       width: 140,
                            //       height: 120,
                            //     ),
                            //   ),
                            // ),
                            // progressIndicatorBuilder: (context, value, progress) {
                            //   return Align(
                            //     child: SizedBox(
                            //       width: 70,
                            //       height: 70,
                            //       child: CircularProgressIndicator(
                            //         value: progress.progress,
                            //       ),
                            //     ),
                            //   );
                            // },
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      // child: ,
                    ),
                  ),

                  //delete
                  if (!widget.disableActions)
                    SizedBox(
                      width: 140,
                      height: 120,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Transform.translate(
                            offset: const Offset(15.0, -25.0),
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.delete,
                                size: 32.0,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              SizedBox(
                width: 140.0,
                height: 20.0,
                child: ValueListenableBuilder<String>(
                  valueListenable: enableEditingFile,
                  builder: (context, value, child) => value != file.id
                      ? GestureDetector(
                          onDoubleTap: () {
                            if (!widget.disableActions) {
                              editableFilename.text = file.fileName;
                              enableEditingFile.value = file.id;
                              focusNode.requestFocus();
                            }
                          },
                          child: Text(
                            file.fileName,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.rubik(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : TextField(
                          controller: editableFilename,
                          focusNode: focusNode,
                          style: GoogleFonts.rubik(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(0.0),
                          ),
                          onSubmitted: (val) async {
                            final newCollectionFile = CollectionFile(
                              id: file.id,
                              userId: file.userId,
                              fileName: val,
                              extensionName: file.extensionName,
                              collectionName: file.collectionName,
                              uri: file.uri,
                              createdAt: DateTime.now().toString(),
                            );
                            Provider.of<CollectionProvider>(context,
                                    listen: false)
                                .saveFile(newCollectionFile);
                            //print(val);
                            enableEditingFile.value = "";
                          },
                          textInputAction: TextInputAction.done,
                        ),
                ),
              ),
            ],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    loadInfo(context);
    return ValueListenableBuilder<bool>(
        valueListenable: isLoading,
        builder: (context, loading, child) {
          if (loading) {
            return const Align(
              child: CircularProgressIndicator(),
            );
          } else {
            return Consumer<CollectionProvider>(builder: (context, cp, __) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  children: [
                    // const SizedBox(
                    //   width: 20.0,
                    // ),
                    ...cp.collFiles
                        .map(
                          (cf) => fileWidget(
                            context,
                            file: cf,
                            files: cp.collFiles,
                          ),
                        )
                        .toList(),
                  ],
                ),
              );
            });
          }
        });
  }
}
