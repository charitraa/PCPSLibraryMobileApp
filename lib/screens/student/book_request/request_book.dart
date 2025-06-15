import 'package:flutter/material.dart';
import 'package:library_management_sys/resource/colors.dart';
import 'package:library_management_sys/utils/utils.dart';
import 'package:library_management_sys/view_model/book_requests/request_view_model.dart';
import 'package:provider/provider.dart';

class BookRequestBottomSheet extends StatefulWidget {
  const BookRequestBottomSheet({super.key});

  @override
  State<BookRequestBottomSheet> createState() => _BookRequestBottomSheetState();
}

class _BookRequestBottomSheetState extends State<BookRequestBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorsController = TextEditingController();
  final _publisherController = TextEditingController();
  final _publicationYearController = TextEditingController();
  final _editionStatementController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _authorsController.dispose();
    _publisherController.dispose();
    _publicationYearController.dispose();
    _editionStatementController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final bookRequest = {
        'title': _titleController.text.trim(),
        'authors': _authorsController.text.trim(),
        'publisher': _publisherController.text.trim(),
        'publicationYear': int.parse(_publicationYearController.text.trim()),
        'editionStatement': _editionStatementController.text.trim().isEmpty
            ? null
            : _editionStatementController.text.trim(),
      };

      final isSuccess = await Provider.of<BookRequestViewModel>(context, listen: false)
          .postRequests(bookRequest, context);

      if (context.mounted) {
        if (isSuccess) {
          Utils.flushBarSuccessMessage("Book Requested Successfully!", context);
          Navigator.of(context).pop(); // Close on success
        } else {
          Utils.flushBarErrorMessage("Failed to request book. Try again.", context);
          // Optionally close on failure: Navigator.of(context).pop();
        }
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6, // 60% height
      minChildSize: 0.4,
      maxChildSize: 0.95, // allows sheet to expand when keyboard appears
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Request a Book',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
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
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration('Publication Year *'),
                  validator: _validatePublicationYear,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _editionStatementController,
                  decoration: _inputDecoration('Edition Statement (Optional)'),
                  validator: _validateEditionStatement,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
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
                    'Submit Request',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Validation methods
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
}
