import 'package:egnimos/src/utility/enum.dart';
import 'package:egnimos/src/widgets/create_pop_up_modal_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../theme/color_theme.dart';

class IndicatorWidget {
  BoxConstraints? constraints;
  BuildContext? context;
  String? message;

  IndicatorWidget({
    required this.context,
    required this.message,
    required this.constraints,
  });

  IndicatorWidget.showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message.toString(),
          style: GoogleFonts.poppins(
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }

  IndicatorWidget.showErrorAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(
          message,
          style: GoogleFonts.ubuntu(fontSize: 15.0),
        ),
      ),
    );
  }

  IndicatorWidget.showCreateBlogModal(
    BuildContext context, {
    Widget? child,
    bool barrierDismissible = true,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => PointerInterceptor(
        // intercepting: false,
        // debug: true,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: child ?? const CreatePopUpModalWidget(),
        ),
      ),
    );
  }

  IndicatorWidget.showPopUpModalWidget(
    BuildContext context, {
    Widget? child,
    bool barrierDismissible = true,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: child ?? const CreatePopUpModalWidget(),
      ),
    );
  }

  IndicatorWidget.callLoadingAlert(BuildContext context, String message) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          width: (constraints!.maxWidth / 100) * 80.0,
          height: 150.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              Text(
                message,
                style: GoogleFonts.ubuntu(
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IndicatorWidget.callLoadingBannerAlert(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        forceActionsBelow: true,
        backgroundColor: Colors.grey.shade800,
        leading: CircularProgressIndicator(
          color: ColorTheme.primaryColor.shade400,
        ),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            message,
            style: GoogleFonts.ubuntu(
              color: Colors.white,
              fontSize: 15.0,
            ),
          ),
        ),
        actions: const [
          Text(""),
        ],
      ),
    );
  }

  IndicatorWidget.loadingBannerAlert(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        forceActionsBelow: true,
        backgroundColor: ColorTheme.primaryColor.shade50,
        leading: const CircularProgressIndicator(
          color: ColorTheme.bgColor2,
        ),
        content: Row(
          children: [
            //message
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                message,
                style: GoogleFonts.rubik(
                  color: Colors.grey.shade700,
                  fontSize: 15.0,
                ),
              ),
            ),

            // //loading
            // const Padding(
            //   padding: EdgeInsets.all(8.0),
            //   child: CircularProgressIndicator(),
            // ),
          ],
        ),
        actions: const [
          Text(""),
        ],
      ),
    );
  }
}
