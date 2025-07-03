import 'package:flutter/material.dart';
import 'package:job_tracker_app/data/models/job.dart';

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

extension ApplicationStatusExtension on ApplicationStatus {
  String get displayName {
    return toString().split('.').last.capitalize();
  }

  IconData get icon {
    switch (this) {
      case ApplicationStatus.saved:
        return Icons.bookmark_border;
      case ApplicationStatus.applied:
        return Icons.send_outlined;
      case ApplicationStatus.interviewing:
        return Icons.people_outline;
      case ApplicationStatus.offered:
        return Icons.card_giftcard_outlined;
      case ApplicationStatus.rejected:
        return Icons.do_not_disturb_alt_outlined;
    }
  }
}
