import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:library_management_sys/view_model/attributes/attr_publisher_view_model.dart';
import 'package:provider/provider.dart';

import '../../resource/colors.dart';

class CustomPublisher extends StatefulWidget {
  final String label;
  final double wid;
  final TextEditingController? controller;
  final Function(String?) onChanged;

  const CustomPublisher({
    super.key,
    required this.label,
    required this.wid,
    this.controller,
    required this.onChanged,
  });

  final border = const OutlineInputBorder(
    borderSide: BorderSide(
      width: 1.5,
      color: Colors.grey,
      style: BorderStyle.solid,
      strokeAlign: BorderSide.strokeAlignCenter,
    ),
    borderRadius: BorderRadius.all(Radius.circular(5)),
  );

  @override
  State<CustomPublisher> createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<CustomPublisher> {
  String? selectedpublisher;
  bool isLoad = false;



  Future<void> loadMore() async {
    if (isLoad) return; // Prevent multiple requests
    setState(() => isLoad = true);

    try {
      await Provider.of<AttrPublisherViewModel>(context, listen: false)
          .loadMorePublishers(context);
    } catch (e) {
      if (kDebugMode) {
        print("Error loading more publishers: $e");
      }
    } finally {
      setState(() => isLoad = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final publisherViewModel = context.watch<AttrPublisherViewModel>();
    final publishers = publisherViewModel.publishersList;

    if (publishers.isEmpty) {
      return const Center(child: Text('No publishers available'));
    }

    String? initialValue = selectedpublisher ??
        (widget.controller?.text.isNotEmpty == true &&
            publishers.any((g) => g.publisherId == widget.controller?.text)
            ? widget.controller?.text
            : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: widget.wid,
          child: publisherViewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : publishers.isEmpty
              ? const Center(child: Text('No publishers available'))
              : DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent &&
                      !isLoad) {
                    loadMore(); // Load more publishers when scrolled to the bottom
                  }
                  return false;
                },
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(width: 1.5, color: AppColors.primary),
                      borderRadius:
                      const BorderRadius.all(Radius.circular(5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: AppColors.primary,
                      ),
                      borderRadius:
                      const BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                  value: initialValue,
                  hint: const Text('Select a publisher'),
                  items: publishers.map((publisher) {
                    return DropdownMenuItem<String>(
                      value: publisher.publisherId,
                      child: Text(
                        (publisher.publisherName?.split(' ').take(3).join(' ') ?? '') +
                            (publisher.publisherName != null && publisher.publisherName!.split(' ').length > 3 ? '...' : ''),
                        style: const TextStyle(fontSize: 14),
                      )

                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedpublisher = newValue;
                    });
                    if (widget.controller != null) {
                      widget.controller!.text = newValue ?? '';
                    }
                    widget.onChanged(newValue);
                  },
                  menuMaxHeight: 300, // Ensure dropdown is scrollable
                  dropdownColor: Colors.white,
                ),
              ),
            ),
          ),
        ),
        if (isLoad)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
