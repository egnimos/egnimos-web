import 'package:cached_network_image/cached_network_image.dart';
import 'package:cross_file/cross_file.dart';
import 'package:egnimos/src/providers/auth_provider.dart';
import 'package:egnimos/src/widgets/indicator_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../config/k.dart';
import '../models/user.dart';
import '../providers/upload_provider.dart';
import '../services/picker_service.dart';
import '../theme/color_theme.dart';
import '../utility/enum.dart';

class EditProfileWidget extends StatefulWidget {
  final BoxConstraints constraints;
  const EditProfileWidget({
    required this.constraints,
    Key? key,
  }) : super(key: key);

  @override
  State<EditProfileWidget> createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  XFile? file;
  final PickerService _pickerService = PickerService();
  final nameController = TextEditingController();
  Gender selectedGender = Gender.male;
  String dob = "";
  String age = "";
  User userInfo = User(
    id: "",
    name: "",
    email: "",
    uri: "",
    uriName: "",
    gender: Gender.male,
    dob: "",
    ageAccountType: AgeAccountType.adult,
    createdAt: DateTime.now().toString(),
    updatedAt: DateTime.now().toString(),
  );
  MimeModel mimeModel = MimeModel(
    uploadType: "",
    fileExt: "",
    type: PickerType.unknown,
  );
  String initialFileName = "";
  String initialFileUrl = "";
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final user = Provider.of<AuthProvider>(context, listen: false).user;
      //assign
      userInfo = User(
        id: user!.id,
        name: user.name,
        email: user.email,
        uri: user.uri,
        uriName: user.uriName,
        gender: user.gender,
        dob: user.dob,
        ageAccountType: user.ageAccountType,
        createdAt: user.createdAt,
        updatedAt: DateTime.now().toString(),
      );
      initialFileName = user.uriName;
      initialFileUrl = user.uri;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Row addRadioButton(
    Gender gender,
    String title,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio<Gender>(
          hoverColor: ColorTheme.primaryColor.shade50,
          activeColor: ColorTheme.primaryColor,
          focusColor: ColorTheme.primaryColor,
          value: gender,
          groupValue: selectedGender,
          onChanged: (val) {
            setState(() {
              selectedGender = val!;
            });
            userInfo = User(
              id: userInfo.id,
              name: userInfo.name,
              email: userInfo.email,
              uri: userInfo.uri,
              uriName: userInfo.uriName,
              gender: val!,
              dob: userInfo.dob,
              ageAccountType: userInfo.ageAccountType,
              createdAt: userInfo.createdAt,
              updatedAt: userInfo.updatedAt,
            );
            // widget.updatedUser(userInfo);
          },
        ),
        Text(
          title,
          style: GoogleFonts.rubik(
            fontSize: 18.5,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
      ),
      height: widget.constraints.maxHeight,
      width: widget.constraints.maxWidth,
      child: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(
            height: 50.0,
          ),
          //image
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () async {
                try {
                  //pick image
                  final imgFile = await _pickerService.pick(
                    context,
                    fileType: FileType.image,
                  );
                  print(imgFile?.extension ?? "no-extension");
                  print(imgFile?.size ?? 0);
                  // print(imgFile.)
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
                  print(e.toString());
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
                      : const DecorationImage(
                          image: CachedNetworkImageProvider(
                              "https://cdn.pixabay.com/photo/2018/11/13/21/43/avatar-3814049_960_720.png"),
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
          SizedBox(
            width: (widget.constraints.maxWidth / 100) * 30.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  FontAwesomeIcons.person,
                  color: Colors.grey.shade800,
                ),
                const SizedBox(width: 5),
                Text(
                  "Name",
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

          const SizedBox(
            height: 20.0,
          ),

          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: (widget.constraints.maxWidth / 100) * 30.0,
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
                onChanged: (val) {
                  userInfo = User(
                    id: userInfo.id,
                    name: val,
                    email: userInfo.email,
                    gender: userInfo.gender,
                    uri: userInfo.uri,
                    uriName: userInfo.uriName,
                    dob: userInfo.dob,
                    ageAccountType: userInfo.ageAccountType,
                    createdAt: userInfo.createdAt,
                    updatedAt: userInfo.updatedAt,
                  );
                  print(userInfo.toJson());
                },
              ),
            ),
          ),

          //gender
          const SizedBox(
            height: 50.0,
          ),

          SizedBox(
            width: (widget.constraints.maxWidth / 100) * 30.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  FontAwesomeIcons.genderless,
                  color: Colors.grey.shade800,
                ),
                const SizedBox(width: 5),
                Text(
                  "Gender",
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

          const SizedBox(
            height: 20.0,
          ),
          //GENDER
          Align(
            alignment: Alignment.centerLeft,
            child: Transform.translate(
              offset: widget.constraints.maxWidth < K.kTableteWidth
                  ? const Offset(-14.0, 0.0)
                  : const Offset(-4.0, 0.0),
              child: FittedBox(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  children: Gender.values
                      .map(
                        (gender) => addRadioButton(gender, gender.name),
                      )
                      .toList(),
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 60.0,
          ),

          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 26.0,
                  vertical: 22.0,
                ),
                primary: ColorTheme.bgColor2,
              ),
              onPressed: () async {
                IndicatorWidget.loadingBannerAlert(
                    context, "Please wait..... ");
                await Provider.of<AuthProvider>(context, listen: false)
                    .updateUserInfo(userInfo, file, initialFileName, mimeModel);
                ScaffoldMessenger.of(context).clearMaterialBanners();
              },
              child: Text(
                "Submit",
                style: GoogleFonts.rubik(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 100.0,
          ),
        ],
      ),
    );
  }
}
