enum ReportStatus { Submitted, InReview, Resolved, Unknown }

class PathReport {
  final ReportStatus status;
  final String? resolutionMessage;
  final bool userAcknowledged;

  PathReport({
    required this.status,
    this.resolutionMessage,
    required this.userAcknowledged,
  });

  factory PathReport.fromJson(Map<String, dynamic> json) {
    ReportStatus statusEnum;
    switch (json['status']) {
      case 0:
        statusEnum = ReportStatus.Submitted;
        break;
      case 1:
        statusEnum = ReportStatus.InReview;
        break;
      case 2:
        statusEnum = ReportStatus.Resolved;
        break;
      default:
        statusEnum = ReportStatus.Unknown;
    }

    return PathReport(
      status: statusEnum,
      resolutionMessage: json['resolutionMessage'],
      userAcknowledged: json['userAcknowledged'] ?? false,
    );
  }
}