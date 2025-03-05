import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:library_management_sys/screens/student/in_app_notification/notification_skeleton.dart';
import 'package:library_management_sys/utils/format_date.dart';
import 'package:library_management_sys/view_model/notifications/notification_view_model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../../constant/base_url.dart';
import '../../../resource/colors.dart';
import '../../../widgets/notification/notification_header.dart';
import '../../../widgets/notification/notification_item.dart';

class NotificationPage extends StatefulWidget {
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool isLoading = false;
  late ScrollController _scrollController;
  bool isLoad = false;
  String message = '';

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !isLoad) {
      loadMore();
    }
  }

  Future<void> loadMore() async {
    if (isLoad) return;
    setState(() => isLoad = true);
    try {
      await Provider.of<NotificationViewModel>(context, listen: false)
          .loadMoreNotifications(context);
    } catch (e) {
      if (kDebugMode) print("Error loading notifications: $e");
    } finally {
      setState(() => isLoad = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Notification",
          style: TextStyle(fontFamily: 'poppins-black', color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () {
            Navigator.pop(context);
          },
          iconSize: 18,
        ),
        actions: const [
          Image(
            image: AssetImage('assets/images/pcpsLogo.png'),
            width: 56,
            height: 24,
            fit: BoxFit.cover,
          ),
          SizedBox(
            width: 18,
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: isLoading
              ? Center(
                  child: LoadingAnimationWidget.twistingDots(
                    leftDotColor: Colors.red,
                    rightDotColor: AppColors.primary,
                    size: 40,
                  ),
                )
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const NotificationHeader(title: "Today"),
                        InkWell(
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              await Provider.of<NotificationViewModel>(context,
                                      listen: false)
                                  .markNotifications(context);
                              setState(() {
                                isLoading = false;
                              });
                            } catch (e) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              "Mark as read",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: Consumer<NotificationViewModel>(
                        builder: (context, viewModel, child) {
                          if (viewModel.isLoading) {
                            return const NotificationItemSkeleton();
                          } else if (viewModel.notificationList.isEmpty) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'Oops! Looks like you dont have any notification!!',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            );
                          }
                          return ListView.builder(
                            controller: _scrollController,
                            physics: const BouncingScrollPhysics(),
                            itemCount: viewModel.notificationList.length,
                            itemBuilder: (context, index) {
                              final notify = viewModel.notificationList[index];
                              String image = notify.icon != null
                                  ? "${BaseUrl.imageDisplay}${notify.icon}"
                                  : "";
                              print(image);
                              return NotificationItem(
                                  image: image,
                                  title: notify.title ?? '',
                                  subtitle: notify.body,
                                  time: notify.createdAt != null
                                      ? formatDate(notify.createdAt.toString())
                                      : '');
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
