import 'package:flutter/material.dart';
import 'package:job_tracker_app/core/theme/app_colors.dart';
import 'package:job_tracker_app/core/utils/extensions.dart';
import 'package:job_tracker_app/core/widgets/bordered_card.dart';
import 'package:job_tracker_app/data/models/job.dart';
import 'package:job_tracker_app/data/providers/application_tracker_provider.dart';
import 'package:provider/provider.dart';

class TrackedJobListItem extends StatelessWidget {
  final Job job;
  final VoidCallback onTap;

  const TrackedJobListItem({
    super.key,
    required this.job,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final provider =
        Provider.of<ApplicationTrackerProvider>(context, listen: false);

    return BorderedCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      style: textTheme.labelLarge
                          ?.copyWith(color: ContextColors.textPrimary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      job.company.name,
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              PopupMenuButton<ApplicationStatus>(
                onSelected: (ApplicationStatus newStatus) {
                  provider.updateJobStatus(job.id, newStatus);
                },
                itemBuilder: (BuildContext context) {
                  return ApplicationStatus.values.map((ApplicationStatus s) {
                    return PopupMenuItem<ApplicationStatus>(
                      value: s,
                      child: Row(
                        children: [
                          Icon(s.icon,
                              color: s == job.status
                                  ? ContextColors.accentHover
                                  : ContextColors.textSecondary),
                          const SizedBox(width: 8),
                          Text(s.displayName),
                        ],
                      ),
                    );
                  }).toList();
                },
                icon: const Icon(Icons.more_vert,
                    color: ContextColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
