import 'package:cached_network_image/cached_network_image.dart';
import 'package:cross_file/cross_file.dart';
import 'package:egnimos/src/services/picker_service.dart';
import 'package:egnimos/src/theme/color_theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../config/k.dart';
import '../../utility/enum.dart';

class AuthForm extends StatefulWidget {
  final BoxConstraints constraints;
  const AuthForm({
    required this.constraints,
    Key? key,
  }) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  XFile? file;
  final PickerService _pickerService = PickerService();
  Gender selectedGender = Gender.male;
  String dob = "";
  String age = "";

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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(1900),
        lastDate: DateTime(3000),
        builder: (context, child) {
          return Theme(
            data: ThemeData(
              primarySwatch: Colors.teal,
            ),
            child: child!,
          );
        });

    //format the date
    if (picked != null) {
      setState(() {
        dob = DateFormat().addPattern("yyyy-MM-dd").format(picked);
        //year of picked date
        final year = DateFormat().addPattern(DateFormat.YEAR).format(picked);
        //year of the current date
        final currYear =
            DateFormat().addPattern(DateFormat.YEAR).format(DateTime.now());
        age = (int.parse(currYear) - int.parse(year)).toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: widget.constraints.maxWidth < K.kTableteWidth
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            //image
            GestureDetector(
              onTap: () async {
                try {
                  //pick image
                  final imgFile = await _pickerService.pick(
                    context,
                    fileType: FileType.image,
                  );
                  if (imgFile != null) {
                    setState(() {
                      file = XFile.fromData(imgFile.bytes!);
                    });
                  }
                } catch (e) {
                  print(e.toString());
                }
              },
              child: Container(
                constraints: BoxConstraints.tight(
                  const Size.square(100.0),
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

            //name
            const SizedBox(
              height: 30.0,
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

            SizedBox(
              width: (widget.constraints.maxWidth / 100) * 30.0,
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(
                      color: ColorTheme.primaryColor,
                      width: 2,
                    ),
                  ),
                  // enabledBorder: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(16.0),
                  //   borderSide: const BorderSide(
                  //     color: ColorTheme.primaryColor,
                  //     width: 2.5,
                  //   ),
                  // ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(
                      color: ColorTheme.primaryColor,
                      width: 2.0,
                    ),
                  ),
                  // errorBorder: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(16.0),
                  //   borderSide: const BorderSide(
                  //     color: Colors.redAccent,
                  //     width: 2.0,
                  //   ),
                  // ),
                  // focusedErrorBorder: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(16.0),
                  //   borderSide: const BorderSide(
                  //     color: Colors.redAccent,
                  //     width: 2.0,
                  //   ),
                  // ),
                  // disabledBorder: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(16.0),
                  //   borderSide: BorderSide(
                  //     color: Colors.grey.shade400,
                  //     width: 2.0,
                  //   ),
                  // ),
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

            //gender
            const SizedBox(
              height: 40.0,
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
            Transform.translate(
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

            //date of birth & age
            const SizedBox(
              height: 40.0,
            ),
            SizedBox(
              width: (widget.constraints.maxWidth / 100) * 30.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    FontAwesomeIcons.calendar,
                    color: Colors.grey.shade800,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "Date Of Birth : $age",
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

            //DOB
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                  height: 50.0,
                  width: (widget.constraints.maxWidth / 100) * 25.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade500,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  padding: const EdgeInsets.all(
                    10.0,
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    dob,
                    style: GoogleFonts.rubik(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                    ),
                  )),
            ),
          ],
        ));
  }
}
