import 'package:flutter/material.dart';
import 'package:job_tracker_app/models/job.dart';
import 'package:job_tracker_app/theme/d3x_colors.dart';
import 'package:job_tracker_app/theme/d3x_spacing.dart';

class TrackedJobListItem extends StatelessWidget {
  final Job job;
  final VoidCallback onTap;
  final ValueChanged<ApplicationStatus?> onStatusChanged;

  const TrackedJobListItem({
    super.key,
    required this.job,
    required this.onTap,
    required this.onStatusChanged,
  });

  String _statusToString(ApplicationStatus status) {
    return status.toString().split('.').last.capitalize();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(D3XSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                job.title,
                style: textTheme.bodyLarge?.copyWith(
                  color: D3XColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: D3XSpacing.xs),
              Text(
                job.company.name,
                style:
                    textTheme.bodyMedium?.copyWith(color: D3XColors.textMuted),
              ),
              const SizedBox(height: D3XSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Status:', style: textTheme.bodyMedium),
                  DropdownButton<ApplicationStatus>(
                    value: job.status,
                    onChanged: onStatusChanged,
                    underline: Container(),
                    style: textTheme.bodyMedium
                        ?.copyWith(color: D3XColors.brandSecondary),
                    dropdownColor: D3XColors.backgroundMedium,
                    icon: const Icon(Icons.arrow_drop_down,
                        color: D3XColors.brandSecondary),
                    items: ApplicationStatus.values
                        .map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(_statusToString(status)),
                            ))
                        .toList(),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
