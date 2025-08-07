import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportProblemScreen extends StatefulWidget {
  final int pathTemplateId;

  const ReportProblemScreen({super.key, required this.pathTemplateId});

  @override
  State<ReportProblemScreen> createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends State<ReportProblemScreen> {
  ReportType _selectedType = ReportType.InaccurateContent;
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    setState(() => _isLoading = true);
    final l10n = AppLocalizations.of(context)!;

    try {
      await ApiService().submitPathReport(
        widget.pathTemplateId,
        _selectedType,
        _descriptionController.text,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.reportScreen_submitSuccess)),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst("Exception: ", ""))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Define the report types using the l10n object
    final reportTypes = {
      ReportType.InaccurateContent: l10n.reportScreen_typeInaccurate,
      ReportType.BrokenLinks: l10n.reportScreen_typeBrokenLinks,
      ReportType.InappropriateContent: l10n.reportScreen_typeInappropriate,
      ReportType.Other: l10n.reportScreen_typeOther,
    };

    final bool isOtherAndEmpty =
        _selectedType == ReportType.Other &&
        _descriptionController.text.trim().isEmpty;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          l10n.reportScreen_title,
          style: GoogleFonts.lora(
            // Use the Lora font
            fontWeight: FontWeight.bold,
            // Set color based on light/dark mode
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.reportScreen_question,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...reportTypes.entries.map((entry) {
              return RadioListTile<ReportType>(
                title: Text(entry.value),
                value: entry.key,
                groupValue: _selectedType,
                onChanged: (ReportType? value) {
                  if (value != null) {
                    setState(() {
                      _selectedType = value;
                    });
                  }
                },
              );
            }).toList(),
            const SizedBox(height: 24),
            Text(
              l10n.reportScreen_optionalDetails,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              maxLength: 500,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: l10n.reportScreen_detailsHint,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_isLoading || isOtherAndEmpty)
                    ? null
                    : _submitReport,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Text(l10n.reportScreen_submitButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
