class DateFormatter {
  static String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
  
  static String formatDateShort(DateTime dateTime) {
    return '${dateTime.month}/${dateTime.day}';
  }
  
  static String formatSalary(double amount) {
    if (amount >= 1000) {
      return '\$${(amount / 1000).round()}k';
    }
    return '\$${amount.round()}';
  }
  
  static String formatSalaryWithCommas(double amount) {
    return '\$${amount.round().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), 
      (m) => '${m[1]},',
    )}';
  }
}
