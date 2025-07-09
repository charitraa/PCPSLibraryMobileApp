import 'package:flutter/material.dart';
import 'package:library_management_sys/resource/colors.dart';
import 'package:library_management_sys/view_model/book_requests/request_view_model.dart';
import 'package:provider/provider.dart';

class EditBookRequestBottomSheet extends StatefulWidget {
  final dynamic reservationData;
  final VoidCallback onSuccess;

  const EditBookRequestBottomSheet({
    super.key,
    required this.reservationData,
    required this.onSuccess,
  });

  @override
  State<EditBookRequestBottomSheet> createState() => _EditBookRequestBottomSheetState();
}

class _EditBookRequestBottomSheetState extends State<EditBookRequestBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _authorsController;
  late TextEditingController _publisherController;
  late TextEditingController _publicationYearController;
  late TextEditingController _editionStatementController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.reservationData.title ?? '');
    _authorsController = TextEditingController(text: widget.reservationData.authors ?? '');
    _publisherController = TextEditingController(text: widget.reservationData.publisher ?? '');
    _publicationYearController =
        TextEditingController(text: widget.reservationData.publicationYear?.toString() ?? '');
    _editionStatementController =
        TextEditingController(text: widget.reservationData.editionStatement ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorsController.dispose();
    _publisherController.dispose();
    _publicationYearController.dispose();
    _editionStatementController.dispose();
    super.dispose();
  }

  String? _validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) return "Title is required";
    if (value.length > 500) return "Title cannot be longer than 500 characters";
    return null;
  }

  String? _validateAuthors(String? value) {
    if (value == null || value.trim().isEmpty) return "Author(s) is required";
    if (value.length > 255) return "Author(s) name is too long";
    return null;
  }

  String? _validatePublisher(String? value) {
    if (value == null || value.trim().isEmpty) return "Publisher is required";
    if (value.length > 255) return "Publisher name is too long";
    return null;
  }

  String? _validatePublicationYear(String? value) {
    if (value == null || value.trim().isEmpty) return "Publication year is required";
    final year = int.tryParse(value);
    if (year == null) return "Publication year must be a valid number";
    if (year < 1000) return "Publication year is not valid";
    if (year > DateTime.now().year + 1) return "Publication year cannot be in the future";
    return null;
  }

  String? _validateEditionStatement(String? value) {
    if (value != null && value.length > 100) return "Edition statement is too long";
    return null;
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final updatedData = {
        'title': _titleController.text.trim(),
        'authors': _authorsController.text.trim(),
        'publisher': _publisherController.text.trim(),
        'publicationYear': int.parse(_publicationYearController.text.trim()),
        'editionStatement': _editionStatementController.text.trim().isEmpty
            ? null
            : _editionStatementController.text.trim(),
        'status': widget.reservationData.status,
      };

      final check = await Provider.of<BookRequestViewModel>(context, listen: false)
          .update(widget.reservationData.bookRequestId ?? '', updatedData, context);
      if (check && context.mounted) {
        widget.onSuccess();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Text(
                    'Edit Book Request',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'poppins',
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _titleController,
                    decoration: _inputDecoration('Title *'),
                    validator: _validateTitle,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _authorsController,
                    decoration: _inputDecoration('Author(s) *'),
                    validator: _validateAuthors,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _publisherController,
                    decoration: _inputDecoration('Publisher *'),
                    validator: _validatePublisher,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _publicationYearController,
                    decoration: _inputDecoration('Publication Year *'),
                    keyboardType: TextInputType.number,
                    validator: _validatePublicationYear,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _editionStatementController,
                    decoration: _inputDecoration('Edition Statement (Optional)'),
                    validator: _validateEditionStatement,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Update Request',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[400]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primary),
      ),
    );
  }
}
