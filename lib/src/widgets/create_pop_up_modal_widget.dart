import 'package:cached_network_image/cached_network_image.dart';
import 'package:cross_file/cross_file.dart';
import 'package:egnimos/src/models/category.dart';
import 'package:egnimos/src/models/collection_file.dart';
import 'package:egnimos/src/pages/profile_page.dart';
import 'package:egnimos/src/pages/write_blog_pages/write_blog_page.dart';
import 'package:egnimos/src/providers/auth_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:super_editor/super_editor.dart';

import '../config/k.dart';
import '../pages/message_page.dart';
import '../providers/category_provider.dart';
import '../providers/collection_provider.dart';
import '../providers/upload_provider.dart';
import '../services/picker_service.dart';
import '../theme/color_theme.dart';
import '../utility/enum.dart';

class CreatePopUpModalWidget extends StatefulWidget {
  const CreatePopUpModalWidget({Key? key}) : super(key: key);

  @override
  State<CreatePopUpModalWidget> createState() => _CreatePopUpModalWidgetState();
}

class _CreatePopUpModalWidgetState extends State<CreatePopUpModalWidget> {
  WriteOptions selectedOptions = WriteOptions.blog;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width / 100) * 80.0,
      height: 350.0,
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //heading
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "Choose an Options",
              style: GoogleFonts.rubik(
                fontSize: 28.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(
            height: 18.0,
          ),

          //check box
          ListTile(
            onTap: () {
              setState(() {
                selectedOptions = WriteOptions.blog;
              });
            },
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1.7,
                color: selectedOptions == WriteOptions.blog
                    ? ColorTheme.primaryColor
                    : Colors.grey.shade400,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            leading: Radio<WriteOptions>(
              hoverColor: ColorTheme.primaryColor.shade50,
              activeColor: ColorTheme.primaryColor,
              focusColor: ColorTheme.primaryColor,
              value: WriteOptions.blog,
              groupValue: selectedOptions,
              onChanged: (__) {},
            ),
            title: Text(
              "Blog",
              style: GoogleFonts.rubik(
                fontWeight: FontWeight.w400,
                fontSize: 20.0,
              ),
            ),
            subtitle: Text(
              "write a blog to publish for every other user to see or save it as a draft for your self only",
              style: GoogleFonts.rubik(),
            ),
          ),

          const SizedBox(
            height: 18.0,
          ),

          ListTile(
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const MessagePage(
                        message: "We are working on it & it will be good 😎",
                      );
                    },
                  ),
                );
              });
            },
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1.7,
                color: selectedOptions == WriteOptions.book
                    ? ColorTheme.primaryColor
                    : Colors.grey.shade400,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            leading: Radio<WriteOptions>(
                hoverColor: ColorTheme.primaryColor.shade50,
                activeColor: ColorTheme.primaryColor,
                focusColor: ColorTheme.primaryColor,
                value: WriteOptions.book,
                groupValue: selectedOptions,
                onChanged: (val) {}),
            title: Text(
              "Book",
              style: GoogleFonts.rubik(
                fontWeight: FontWeight.w400,
                fontSize: 20.0,
              ),
            ),
            subtitle: Text(
              "write a book, documentation or manual to user information regarding any tech or product",
              style: GoogleFonts.rubik(),
            ),
          ),

          const SizedBox(
            height: 18.0,
          ),

          //start button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              //cancel
              Flexible(
                child: OutlinedButton.icon(
                  clipBehavior: Clip.antiAlias,
                  style: OutlinedButton.styleFrom(
                      primary: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      side: const BorderSide(
                        width: 1.2,
                        color: Colors.redAccent,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 16.0,
                      )),
                  onPressed: () async {
                    try {
                      Navigator.pop(context);
                    } catch (e) {
                      print(e);
                    }
                  },
                  icon: const Flexible(
                    child: Icon(
                      Icons.close,
                      color: Colors.redAccent,
                    ),
                  ),
                  label: Text(
                    "Cancel",
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: GoogleFonts.rubik(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                width: 12.0,
              ),
              Flexible(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                      primary: ColorTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      side: const BorderSide(
                        width: 1.2,
                        color: ColorTheme.primaryColor,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 16.0,
                      )),
                  onPressed: () {
                    if (selectedOptions == WriteOptions.blog) {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const WriteBlogPage();
                      }));
                    }
                  },
                  icon: const Icon(
                    Icons.start_rounded,
                    color: ColorTheme.primaryColor,
                  ),
                  label: Text(
                    "Start",
                    style: GoogleFonts.rubik(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//save pop up model
class SaveBlogPopUpModalWidget extends StatefulWidget {
  final Future<void> Function(BlogType type) onSave;
  const SaveBlogPopUpModalWidget({
    Key? key,
    required this.onSave,
  }) : super(key: key);

  @override
  State<SaveBlogPopUpModalWidget> createState() =>
      _SaveBlogPopUpModalWidgetState();
}

class _SaveBlogPopUpModalWidgetState extends State<SaveBlogPopUpModalWidget> {
  BlogType selectedOptions = BlogType.draft;

  Widget optionBox({
    required VoidCallback onTap,
    required BlogType blogType,
    required String titleText,
    required String description,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: (MediaQuery.of(context).size.width / 100) * 30.0,
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 10.0,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.7,
            color: selectedOptions == blogType
                ? ColorTheme.primaryColor
                : Colors.grey.shade400,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //row
            Row(
              children: [
                //radio
                Radio<BlogType>(
                  hoverColor: ColorTheme.primaryColor.shade50,
                  activeColor: ColorTheme.primaryColor,
                  focusColor: ColorTheme.primaryColor,
                  value: blogType,
                  groupValue: selectedOptions,
                  onChanged: (__) {},
                ),

                Text(
                  titleText,
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.w500,
                    fontSize: 21.0,
                  ),
                ),
              ],
            ),

            //description
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 6.0,
              ),
              child: Text(
                description,
                style: GoogleFonts.rubik(
                  color: selectedOptions == blogType
                      ? ColorTheme.primaryColor
                      : null,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width / 100) * 60.0,
      height: 300.0,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //heading
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "Save as/to",
              style: GoogleFonts.rubik(
                fontSize: 28.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(
            height: 18.0,
          ),

          Row(
            children: [
              //check box
              Flexible(
                child: optionBox(
                  onTap: () {
                    setState(() {
                      selectedOptions = BlogType.published;
                    });
                  },
                  blogType: BlogType.published,
                  titleText: "Save to publish",
                  description: "Publish a blog for other users",
                ),
              ),

              const SizedBox(
                width: 18.0,
              ),

              //draft
              Flexible(
                child: optionBox(
                  onTap: () {
                    setState(() {
                      selectedOptions = BlogType.draft;
                    });
                  },
                  blogType: BlogType.draft,
                  titleText: "Save to draft",
                  description: "Draft a blog for yourself only",
                ),
              ),

              const SizedBox(
                width: 18.0,
              ),
            ],
          ),

          const SizedBox(
            height: 34.0,
          ),

          //start button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              //cancel
              Flexible(
                child: OutlinedButton.icon(
                  clipBehavior: Clip.antiAlias,
                  style: OutlinedButton.styleFrom(
                      primary: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      side: const BorderSide(
                        width: 1.2,
                        color: Colors.redAccent,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 16.0,
                      )),
                  onPressed: () async {
                    try {
                      Navigator.pop(context);
                    } catch (e) {
                      print(e);
                    }
                  },
                  icon: const Flexible(
                    child: Icon(
                      Icons.close,
                      color: Colors.redAccent,
                    ),
                  ),
                  label: Text(
                    "Cancel",
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: GoogleFonts.rubik(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                width: 12.0,
              ),

              //save
              Flexible(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                      primary: ColorTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      side: const BorderSide(
                        width: 1.2,
                        color: ColorTheme.primaryColor,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 16.0,
                      )),
                  onPressed: () => widget.onSave(selectedOptions),
                  icon: const Flexible(
                    child: Icon(
                      Icons.save,
                      color: ColorTheme.primaryColor,
                    ),
                  ),
                  label: Text(
                    "Save",
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: GoogleFonts.rubik(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//create category pop model
class CreateCategoryPopupModel extends StatefulWidget {
  final BoxConstraints constraints;
  final Category? categoryInfo;
  const CreateCategoryPopupModel({
    Key? key,
    this.categoryInfo,
    required this.constraints,
  }) : super(key: key);

  @override
  State<CreateCategoryPopupModel> createState() =>
      _CreateCategoryPopupModelState();
}

class _CreateCategoryPopupModelState extends State<CreateCategoryPopupModel> {
  XFile? file;
  final PickerService _pickerService = PickerService();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  Gender selectedGender = Gender.male;
  Category category = Category(
    id: "",
    label: "",
    image: UploadOutput(
      fileName: "",
      generatedUri: "",
    ),
    description: "",
    catEnum: Cat.all,
  );
  MimeModel mimeModel = MimeModel(
    uploadType: "",
    fileExt: "",
    type: PickerType.unknown,
  );
  String initialFileName = "";
  String? initialFileUrl;
  bool _isInit = true;
  bool _isLoading = false;

  Cat? selectedCatType;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.categoryInfo?.label ?? "";
    descriptionController.text = widget.categoryInfo?.description ?? "";
    initialFileUrl = widget.categoryInfo?.image?.generatedUri;
    selectedCatType = widget.categoryInfo?.catEnum;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Widget headingWidget(String text, IconData icon) {
    return Align(
      alignment: (widget.constraints.maxWidth > K.kTableteWidth)
          ? Alignment.centerLeft
          : Alignment.center,
      child: SizedBox(
        width: (widget.constraints.maxWidth > K.kTableteWidth)
            ? (widget.constraints.maxWidth / 100) * 35.0
            : (widget.constraints.maxWidth / 100) * 75.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Colors.grey.shade800,
            ),
            const SizedBox(width: 5),
            Text(
              text,
              style: GoogleFonts.rubik(
                fontSize: 20.0,
                letterSpacing: 0.5,
                // fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? selectionErrorText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (widget.constraints.maxWidth / 100) * 40.0,
      height: (widget.constraints.maxWidth / 100) * 70.0,
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          //category info
          ListView(
            children: [
              //heading
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Save Category",
                  style: GoogleFonts.rubik(
                    fontSize: 28.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              //input
              const SizedBox(
                height: 50.0,
              ),
              //image
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () async {
                    try {
                      //pick image
                      final imgFile = await _pickerService.pick(
                        context,
                        fileType: FileType.image,
                      );
                      //print(imgFile?.extension ?? "no-extension");
                      //print(imgFile?.size ?? 0);
                      // //print(imgFile.)
                      if (imgFile != null) {
                        setState(() {
                          file = XFile.fromData(imgFile.bytes!);
                        });
                        mimeModel = MimeModel(
                          uploadType: PickerType.image.name,
                          fileExt: imgFile.extension ?? "",
                          type: PickerType.image,
                        );
                      }
                    } catch (e) {
                      //print(e.toString());
                    }
                  },
                  child: Container(
                    constraints: BoxConstraints.tight(
                      const Size.square(150.0),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                      image: file != null
                          ? DecorationImage(
                              image: CachedNetworkImageProvider(file!.path),
                              fit: BoxFit.cover,
                            )
                          : DecorationImage(
                              image: CachedNetworkImageProvider(
                                initialFileUrl == null
                                    ? "https://cdn.pixabay.com/photo/2018/11/13/21/43/avatar-3814049_960_720.png"
                                    : initialFileUrl!,
                              ),
                              fit: BoxFit.cover,
                            ),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.0),
                        color: ColorTheme.primaryColor.withOpacity(0.4),
                      ),
                      child: const Icon(
                        FontAwesomeIcons.camera,
                        color: Colors.white,
                        size: 22.0,
                      ),
                    ),
                  ),
                ),
              ),

              //name
              const SizedBox(
                height: 50.0,
              ),

              //CATEGORY NAME
              Align(
                alignment: (widget.constraints.maxWidth > K.kTableteWidth)
                    ? Alignment.center
                    : Alignment.centerLeft,
                child: SizedBox(
                  width: (widget.constraints.maxWidth > K.kTableteWidth)
                      ? (widget.constraints.maxWidth / 100) * 35.0
                      : (widget.constraints.maxWidth / 100) * 75.0,
                  child: headingWidget(
                    "Category name",
                    Icons.label,
                  ),
                ),
              ),
              Align(
                alignment: (widget.constraints.maxWidth > K.kTableteWidth)
                    ? Alignment.center
                    : Alignment.centerLeft,
                child: SizedBox(
                  width: (widget.constraints.maxWidth > K.kTableteWidth)
                      ? (widget.constraints.maxWidth / 100) * 35.0
                      : (widget.constraints.maxWidth / 100) * 75.0,
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: const BorderSide(
                          color: ColorTheme.primaryColor,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: const BorderSide(
                          color: ColorTheme.primaryColor,
                          width: 2.0,
                        ),
                      ),
                      focusColor: ColorTheme.primaryColor,
                      hoverColor: ColorTheme.primaryColor,
                      fillColor: ColorTheme.primaryColor,
                    ),
                    style: GoogleFonts.rubik(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 30.0,
              ),

              //CATEGORY TYPE
              Align(
                alignment: (widget.constraints.maxWidth > K.kTableteWidth)
                    ? Alignment.center
                    : Alignment.centerLeft,
                child: SizedBox(
                  width: (widget.constraints.maxWidth > K.kTableteWidth)
                      ? (widget.constraints.maxWidth / 100) * 35.0
                      : (widget.constraints.maxWidth / 100) * 75.0,
                  child: headingWidget(
                    "Category type",
                    Icons.category,
                  ),
                ),
              ),
              Align(
                alignment: (widget.constraints.maxWidth > K.kTableteWidth)
                    ? Alignment.center
                    : Alignment.centerLeft,
                child: SizedBox(
                  width: (widget.constraints.maxWidth > K.kTableteWidth)
                      ? (widget.constraints.maxWidth / 100) * 35.0
                      : (widget.constraints.maxWidth / 100) * 75.0,
                  child: FormField<Cat>(
                    builder: (FormFieldState<Cat> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          errorStyle: GoogleFonts.rubik(
                            color: Colors.redAccent,
                            fontSize: 16.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: const BorderSide(
                              color: ColorTheme.primaryColor,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: const BorderSide(
                              color: ColorTheme.primaryColor,
                              width: 2.0,
                            ),
                          ),
                          errorText: selectionErrorText,
                          hintText: 'Please select Category type',
                          // border: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(5.0),
                          // ),
                        ),
                        isEmpty: selectedCatType == null,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<Cat>(
                            value: selectedCatType,
                            isDense: true,
                            onChanged: (newValue) {
                              setState(() {
                                selectedCatType = newValue;
                                state.didChange(newValue);
                              });
                            },
                            items: Cat.values.map((Cat value) {
                              return DropdownMenuItem<Cat>(
                                value: value,
                                child: Text(
                                  value.name,
                                  style: GoogleFonts.rubik(
                                    fontSize: 18.0,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(
                height: 30.0,
              ),

              //DESCRIPTION
              Align(
                alignment: (widget.constraints.maxWidth > K.kTableteWidth)
                    ? Alignment.center
                    : Alignment.centerLeft,
                child: SizedBox(
                  width: (widget.constraints.maxWidth > K.kTableteWidth)
                      ? (widget.constraints.maxWidth / 100) * 35.0
                      : (widget.constraints.maxWidth / 100) * 75.0,
                  child: headingWidget(
                    "Description",
                    Icons.description,
                  ),
                ),
              ),
              Align(
                alignment: (widget.constraints.maxWidth > K.kTableteWidth)
                    ? Alignment.center
                    : Alignment.centerLeft,
                child: SizedBox(
                  width: (widget.constraints.maxWidth > K.kTableteWidth)
                      ? (widget.constraints.maxWidth / 100) * 35.0
                      : (widget.constraints.maxWidth / 100) * 75.0,
                  child: TextField(
                    controller: descriptionController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: const BorderSide(
                          color: ColorTheme.primaryColor,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: const BorderSide(
                          color: ColorTheme.primaryColor,
                          width: 2.0,
                        ),
                      ),
                      focusColor: ColorTheme.primaryColor,
                      hoverColor: ColorTheme.primaryColor,
                      fillColor: ColorTheme.primaryColor,
                    ),
                    style: GoogleFonts.rubik(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 34.0,
              ),

              //start button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //cancel
                  Flexible(
                    child: OutlinedButton.icon(
                      clipBehavior: Clip.antiAlias,
                      style: OutlinedButton.styleFrom(
                          primary: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.0),
                          ),
                          side: const BorderSide(
                            width: 1.2,
                            color: Colors.redAccent,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 16.0,
                          )),
                      onPressed: () async {
                        try {
                          Navigator.pop(context);
                        } catch (e) {
                          print(e);
                        }
                      },
                      icon: const Flexible(
                        child: Icon(
                          Icons.close,
                          color: Colors.redAccent,
                        ),
                      ),
                      label: Text(
                        "Cancel",
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: GoogleFonts.rubik(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 12.0,
                  ),
                  Flexible(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                          primary: ColorTheme.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.0),
                          ),
                          side: const BorderSide(
                            width: 1.2,
                            color: ColorTheme.primaryColor,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 16.0,
                          )),
                      onPressed: () async {
                        //validation
                        if (selectedCatType == null) {
                          selectionErrorText = "select the category type";
                          return;
                        }
                        try {
                          setState(() {
                            _isLoading = true;
                          });
                          selectionErrorText = null;
                          final catId = widget.categoryInfo?.image?.fileName ??
                              DocumentEditor.createNodeId();
                          UploadOutput? uploadOutput =
                              widget.categoryInfo?.image;
                          if (file != null) {
                            uploadOutput = await Provider.of<UploadProvider>(
                                    context,
                                    listen: false)
                                .uploadFile(file!, mimeModel.uploadType,
                                    mimeModel.fileExt,
                                    fileN: catId, childName: "cat_files");
                          }
                          final newCat = Category(
                            id: widget.categoryInfo?.id ?? catId,
                            label: nameController.text,
                            image: uploadOutput,
                            description: descriptionController.text,
                            catEnum: selectedCatType!,
                          );
                          await Provider.of<CategoryProvider>(context,
                                  listen: false)
                              .saveCategory(newCat);
                          Navigator.of(context).pushReplacementNamed(
                              ProfilePage.routeName,
                              arguments: {
                                "profile_option": ProfileOptions.category,
                              });
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                e.toString(),
                              ),
                            ),
                          );
                        } finally {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.save,
                        color: ColorTheme.primaryColor,
                      ),
                      label: Text(
                        "Save",
                        style: GoogleFonts.rubik(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          //loading info
          if (_isLoading)
            Container(
              width: (widget.constraints.maxWidth / 100) * 40.0,
              height: (widget.constraints.maxWidth / 100) * 70.0,
              color: Colors.white54,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(
                color: ColorTheme.bgColor10,
              ),
            ),
        ],
      ),
    );
  }
}

class UploadFilePopUpModel extends StatefulWidget {
  final BoxConstraints constraints;
  final CollectionFile? file;
  const UploadFilePopUpModel({
    Key? key,
    required this.constraints,
    this.file,
  }) : super(key: key);

  @override
  State<UploadFilePopUpModel> createState() => _UploadFilePopUpModelState();
}

class _UploadFilePopUpModelState extends State<UploadFilePopUpModel> {
  bool _isLoading = false;
  final PickerService _pickerService = PickerService();
  final nameController = TextEditingController();
  List<MimeModel> mimeModels = [];
  String initialFileName = "";
  String? initialFileUrl;
  String? fileNameErrorText;
  List<FileType> allowedFileTypes = [FileType.image];
  final uploadedFileId = ValueNotifier<List<String>>([]);

  @override
  void initState() {
    super.initState();
    nameController.text = widget.file?.fileName ?? "";
    initialFileUrl = widget.file?.uri;
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Widget headingWidget(String text, IconData icon) {
    return Align(
      alignment: (widget.constraints.maxWidth > K.kTableteWidth)
          ? Alignment.centerLeft
          : Alignment.center,
      child: SizedBox(
        width: (widget.constraints.maxWidth > K.kTableteWidth)
            ? (widget.constraints.maxWidth / 100) * 35.0
            : (widget.constraints.maxWidth / 100) * 75.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Colors.grey.shade800,
            ),
            const SizedBox(width: 5),
            Text(
              text,
              style: GoogleFonts.rubik(
                fontSize: 20.0,
                letterSpacing: 0.5,
                // fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //picker button based on the file type
  Widget pickFile(FileType fileType, String text) {
    return GestureDetector(
      onTap: () async {
        try {
          //pick image
          final imgFile = await _pickerService.pick(
            context,
            fileType: fileType,
          );
          //print(imgFile?.extension ?? "no-extension");
          //print(imgFile?.size ?? 0);
          // //print(imgFile.)
          if (imgFile != null) {
            mimeModels.add(MimeModel(
              fileId: DocumentEditor.createNodeId(),
              file: XFile.fromData(imgFile.bytes!),
              uploadType: PickerType.image.name,
              fileExt: imgFile.extension ?? "",
              type: PickerType.image,
            ));
            setState(() {});
          }
        } catch (e) {
          //print(e);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                e.toString(),
              ),
            ),
          );
        }
      },
      child: Container(
        width: 120.0,
        height: 120.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            width: 1.2,
            color: ColorTheme.bgColor2,
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //icon
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: icon(fileType),
            ),
            //label
            Text(
              text,
              style: GoogleFonts.rubik(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //get the icon based on the file type
  Widget icon(FileType fileType) {
    switch (fileType) {
      case FileType.image:
        return const Icon(
          Icons.image,
          size: 18.0,
          color: ColorTheme.bgColor2,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget fileWidget(
    BuildContext context, {
    required MimeModel file,
  }) {
    switch (file.type) {
      case PickerType.image:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: CachedNetworkImage(
            imageUrl: file.file!.path,
            // imageBuilder: (context, imp) {
            //   return CachedNetworkImage(
            //     imageUrl: file.file!.path,
            //     fit: BoxFit.contain,

            //   );
            // },
            errorWidget: (context, url, error) => Image.asset(
              "assets/images/png/Group_392-3.png",
              fit: BoxFit.contain,
              width: 100,
              height: 100,
            ),
            progressIndicatorBuilder: (context, value, progress) {
              return Align(
                child: SizedBox(
                  width: 100.0,
                  height: 100.0,
                  child: CircularProgressIndicator(
                    value: progress.progress,
                  ),
                ),
              );
            },
            width: 100.0,
            height: 100.0,
            fit: BoxFit.contain,
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    return Container(
      width: (widget.constraints.maxWidth > K.kTableteWidth)
          ? (widget.constraints.maxWidth / 100) * 40.0
          : (widget.constraints.maxWidth / 100) * 80.0,
      height: (widget.constraints.maxHeight / 100) * 60.0,
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          //ListView
          ListView(
            physics: const ClampingScrollPhysics(),
            children: [
              //heading
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Save Collection",
                  style: GoogleFonts.rubik(
                    fontSize: 28.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              //input
              const SizedBox(
                height: 50.0,
              ),

              //picker button
              Row(
                children: allowedFileTypes
                    .map(
                      (f) => pickFile(f, f.name),
                    )
                    .toList(),
              ),

              SizedBox(
                height: mimeModels.isEmpty ? 50.0 : 30.0,
              ),
              //IMAGES
              ListView(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Wrap(
                    children: mimeModels
                        .map(
                          (mm) => fileWidget(
                            context,
                            file: mm,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),

              //name
              SizedBox(
                height: mimeModels.isEmpty ? 50.0 : 30.0,
              ),

              //FILE NAME
              Align(
                alignment: (widget.constraints.maxWidth > K.kTableteWidth)
                    ? Alignment.center
                    : Alignment.centerLeft,
                child: SizedBox(
                  width: (widget.constraints.maxWidth > K.kTableteWidth)
                      ? (widget.constraints.maxWidth / 100) * 35.0
                      : (widget.constraints.maxWidth / 100) * 75.0,
                  child: headingWidget(
                    "File Name",
                    Icons.label,
                  ),
                ),
              ),
              Align(
                alignment: (widget.constraints.maxWidth > K.kTableteWidth)
                    ? Alignment.center
                    : Alignment.centerLeft,
                child: SizedBox(
                  width: (widget.constraints.maxWidth > K.kTableteWidth)
                      ? (widget.constraints.maxWidth / 100) * 35.0
                      : (widget.constraints.maxWidth / 100) * 75.0,
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      errorText: fileNameErrorText,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: const BorderSide(
                          color: ColorTheme.primaryColor,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: const BorderSide(
                          color: ColorTheme.primaryColor,
                          width: 2.0,
                        ),
                      ),
                      focusColor: ColorTheme.primaryColor,
                      hoverColor: ColorTheme.primaryColor,
                      fillColor: ColorTheme.primaryColor,
                    ),
                    style: GoogleFonts.rubik(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 54.0,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //cancel
                  Flexible(
                    child: OutlinedButton.icon(
                      clipBehavior: Clip.antiAlias,
                      style: OutlinedButton.styleFrom(
                          primary: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.0),
                          ),
                          side: const BorderSide(
                            width: 1.2,
                            color: Colors.redAccent,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 16.0,
                          )),
                      onPressed: () async {
                        try {
                          Navigator.pop(context);
                        } catch (e) {
                          print(e);
                        }
                      },
                      icon: const Flexible(
                        child: Icon(
                          Icons.close,
                          color: Colors.redAccent,
                        ),
                      ),
                      label: Text(
                        "Cancel",
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: GoogleFonts.rubik(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 12.0,
                  ),
                  //upload
                  Flexible(
                    child: OutlinedButton.icon(
                      clipBehavior: Clip.antiAlias,
                      style: OutlinedButton.styleFrom(
                          primary: ColorTheme.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.0),
                          ),
                          side: const BorderSide(
                            width: 1.2,
                            color: ColorTheme.primaryColor,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 16.0,
                          )),
                      onPressed: () async {
                        //validation
                        if (nameController.text.isEmpty) {
                          fileNameErrorText = "add your file name";
                          setState(() {});
                          return;
                        }
                        try {
                          setState(() {
                            _isLoading = true;
                          });
                          fileNameErrorText = null;
                          await Future.forEach<MimeModel>(mimeModels,
                              (val) async {
                            UploadOutput? uploadOutput;

                            uploadOutput = await Provider.of<UploadProvider>(
                                    context,
                                    listen: false)
                                .uploadFile(
                              val.file!,
                              val.uploadType,
                              val.fileExt,
                              fileN: val.fileId,
                              childName: "blog_collections",
                            );
                            final newCollectionFile = CollectionFile(
                              id: widget.file?.id ?? val.fileId,
                              userId: widget.file?.userId ?? user!.id,
                              fileName:
                                  "${nameController.text}-#${mimeModels.indexOf(val)}.${val.fileExt}",
                              extensionName: val.fileExt,
                              collectionName: PickerType.image.name,
                              uri: uploadOutput.generatedUri,
                              createdAt: DateTime.now().toString(),
                            );
                            await Provider.of<CollectionProvider>(context,
                                    listen: false)
                                .saveFile(newCollectionFile);
                            uploadedFileId.value.add(newCollectionFile.id);
                            setState(() {});
                          });
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                e.toString(),
                              ),
                            ),
                          );
                          //remove on the uploaded item
                          mimeModels.removeWhere(
                            (mm) => uploadedFileId.value.contains(mm.fileId),
                          );
                        } finally {
                          setState(() {
                            _isLoading = false;
                          });
                          Navigator.of(context).pushReplacementNamed(
                              ProfilePage.routeName,
                              arguments: {
                                "profile_option": ProfileOptions.collections,
                              });
                        }
                      },
                      icon: const Flexible(
                        child: Icon(
                          Icons.upload,
                          color: ColorTheme.primaryColor,
                        ),
                      ),
                      label: Text(
                        "Upload",
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: GoogleFonts.rubik(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          //loading info
          if (_isLoading)
            Container(
              width: (widget.constraints.maxWidth / 100) * 40.0,
              height: (widget.constraints.maxHeight / 100) * 60.0,
              color: Colors.white54,
              alignment: Alignment.center,
              child: ValueListenableBuilder<List<String>>(
                  valueListenable: uploadedFileId,
                  builder: (context, values, __) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          color: ColorTheme.bgColor10,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "${values.length} File's has been upload",
                          style: GoogleFonts.rubik(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    );
                  }),
            ),
        ],
      ),
    );
  }
}

class ViewPopUp extends StatefulWidget {
  final List<CollectionFile> uri;
  final int index;
  const ViewPopUp({
    Key? key,
    required this.index,
    required this.uri,
  }) : super(key: key);

  @override
  State<ViewPopUp> createState() => _ViewPopUpState();
}

class _ViewPopUpState extends State<ViewPopUp> {
  late PageController pageController;
  final index = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      initialPage: widget.index,
    );
    index.value = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: CachedNetworkImageProvider(widget.uri[index].uri),
              initialScale: PhotoViewComputedScale.contained * 0.8,
              heroAttributes:
                  PhotoViewHeroAttributes(tag: widget.uri[index].id),
            );
          },
          itemCount: widget.uri.length,
          loadingBuilder: (context, event) => Center(
            child: SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                value: event == null
                    ? 0
                    : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
              ),
            ),
          ),
          // backgroundDecoration: widget.backgroundDecoration,
          pageController: pageController,
          allowImplicitScrolling: true,
          onPageChanged: (i) {
            index.value = i;
          },
        ),

        //Close
        Positioned(
          right: 30.0,
          top: 10.0,
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.close,
              color: Colors.white,
              size: 32.0,
            ),
          ),
        ),

        //RIGHT ARROW
        ValueListenableBuilder<int>(
            valueListenable: index,
            builder: (context, value, __) {
              return value < widget.uri.length - 1
                  ? Positioned(
                      right: 30.0,
                      top: (MediaQuery.of(context).size.height / 2) - 60.0,
                      child: IconButton(
                        onPressed: () {
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        },
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 32.0,
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            }),

        //LEFT ARROW
        ValueListenableBuilder<int>(
            valueListenable: index,
            builder: (context, value, __) {
              return value > 0
                  ? Positioned(
                      left: 30.0,
                      top: (MediaQuery.of(context).size.height / 2) - 60.0,
                      child: IconButton(
                        onPressed: () {
                          pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 32.0,
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            }),
      ],
    );
  }
}
