import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'l10n/app_localizations.dart';
import 'models/path_report_model.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportStatusScreen extends StatefulWidget {
  final int pathTemplateId;
  const ReportStatusScreen({super.key, required this.pathTemplateId});

  @override
  State<ReportStatusScreen> createState() => _ReportStatusScreenState();
}

class _ReportStatusScreenState extends State<ReportStatusScreen> {
  late Future<PathReport?> _reportFuture;

  @override
  void initState() {
    super.initState();
    // The API call is now correctly made when the screen initializes
    _reportFuture = ApiService().fetchPathReport(widget.pathTemplateId);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          l10n.reportStatusScreen_title,
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
      body: FutureBuilder<PathReport?>(
        future: _reportFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text(l10n.reportStatusScreen_noReportFound));
          }

          final report = snapshot.data!;

          String statusText;
          switch (report.status) {
            case ReportStatus.Submitted:
              statusText = l10n.reportStatus_submitted;
              break;
            case ReportStatus.InReview:
              statusText = l10n.reportStatus_inReview;
              break;
            case ReportStatus.Resolved:
              statusText = l10n.reportStatus_resolved;
              break;
            default:
              statusText = l10n.reportStatus_unknown;
          }

          final isResolved = report.status == ReportStatus.Resolved;
          final bool isAcknowledged = report.userAcknowledged;

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.reportStatusScreen_statusLabel(statusText),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),
                Text(
                  isResolved
                      ? report.resolutionMessage ??
                            l10n.reportStatusScreen_resolvedMessageDefault
                      : l10n.reportStatusScreen_submittedMessage,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                if (isResolved && !isAcknowledged) ...[
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      await ApiService().acknowledgeReport(
                        widget.pathTemplateId,
                      );
                      Navigator.of(context).pop(true);
                    },
                    child: Text(l10n.reportStatusScreen_acknowledgeButton),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
