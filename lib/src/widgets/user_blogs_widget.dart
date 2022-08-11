import 'package:egnimos/src/config/responsive.dart';
import 'package:egnimos/src/models/user.dart';
import 'package:egnimos/src/utility/enum.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/blog_provider.dart';
import 'blog_post_card.dart';

class UserBlogsWidget extends StatefulWidget {
  final BoxConstraints constraints;
  final BlogType blogType;
  const UserBlogsWidget({
    required this.blogType,
    Key? key,
    required this.constraints,
  }) : super(key: key);

  @override
  State<UserBlogsWidget> createState() => _UserBlogsWidgetState();
}

class _UserBlogsWidgetState extends State<UserBlogsWidget> {
  bool _isInit = true;
  bool isLoading = true;
  User? user;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      user = Provider.of<AuthProvider>(context, listen: false).user;
      widget.blogType == BlogType.published
          ? Provider.of<BlogProvider>(context, listen: false)
              .getUserPublishedBlogSnaps(Cat.all, user!.id)
              .then(
                (value) => setState(
                  () => isLoading = false,
                ),
              )
          : Provider.of<BlogProvider>(context, listen: false)
              .getDraftBlogSnaps(Cat.all, user!.id)
              .then(
                (value) => setState(
                  () => isLoading = false,
                ),
              );
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Align(
        child: CircularProgressIndicator(),
      );
    } else {
      return Consumer<BlogProvider>(builder: (context, bp, __) {
        final isEmpty = widget.blogType == BlogType.published
            ? bp.userPublishedBlogSnaps.isEmpty
            : bp.draftBlogSnaps.isEmpty;

        return isEmpty
            ? Container(
                width: double.infinity,
                height: 250.0,
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Flexible(
                      child: Lottie.asset(
                        "assets/json/not-found.json",
                        reverse: true,
                        width: Responsive.imageSizeMultiplier * 30.0,
                        height: Responsive.imageSizeMultiplier * 30.0,
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "no ${widget.blogType.name} blogs post available",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //blogs
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      children: widget.blogType == BlogType.published
                          ? bp.userPublishedBlogSnaps
                              .map((bo) => BlogPostCard(
                                    blog: bo,
                                    blogType: widget.blogType,
                                  ))
                              .toList()
                          : bp.draftBlogSnaps
                              .map((bo) => BlogPostCard(
                                    blog: bo,
                                    blogType: widget.blogType,
                                  ))
                              .toList(),
                    ),
                  ),
                ],
              );
      });
    }
  }
}
