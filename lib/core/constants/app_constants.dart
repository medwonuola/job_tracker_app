class AppConstants {
  static const String appName = 'Jobs Tracker';
  
  static const int maxCacheEntries = 50;
  static const int connectTimeoutSeconds = 15;
  static const int receiveTimeoutSeconds = 15;
  static const int searchDelayMs = 400;
  static const int throttleDelayMs = 300;
  
  static const int maxDisplayedPerks = 4;
  static const int logoSize = 72;
  static const int companyLogoSize = 48;
  static const int largeLogoSize = 80;
  
  static const double chartHeight = 200.0;
  static const double maxSalaryRange = 400000.0;
  static const int salaryDivisions = 80;
  
  static const String storageKeyTrackedJobs = 'tracked_jobs_map';
  static const String rapidApiHost = 'hidden-job-board.p.rapidapi.com';
  static const String baseApiUrl = 'https://hidden-job-board.p.rapidapi.com';
  
  static const String defaultJobDescription = '';
  static const String defaultJobTitle = 'No Title';
  static const String defaultCompanyName = 'Unknown Company';
  static const String defaultLocation = 'Remote';
  
  static const String searchJobsEndpoint = '/search-jobs';
  static const String searchLocationEndpoint = '/search-location';
  static const String getDepartmentsEndpoint = '/get-departments';
  static const String getIndustriesEndpoint = '/get-industries';
  
  static const Map<String, String> errorMessages = {
    'networkError': 'Network connection failed. Please check your internet.',
    'rateLimitError': 'Too many requests. Please try again later.',
    'authError': 'Authentication failed. Please check your API key.',
    'serverError': 'Server error occurred. Please try again.',
    'unexpectedError': 'An unexpected error occurred.',
    'parseError': 'Failed to process server response.',
    'noResultsFound': 'No jobs found matching your criteria.',
    'searchQueryEmpty': 'Please enter a search term.',
  };
  
  static const List<String> workplaceTypes = [
    'Remote',
    'Hybrid', 
    'On-site',
  ];
  
  static const List<String> commitmentTypes = [
    'Full-time',
    'Part-time',
    'Contract',
    'Internship',
  ];
  
  static const List<String> seniorityLevels = [
    'Internship',
    'Entry level',
    'Associate',
    'Mid-Senior level',
    'Director',
    'Executive',
  ];
  
  static const List<String> frequencyOptions = ['Yearly', 'Monthly'];
  
  static const Map<String, String> perkIcons = {
    'health': 'health_insurance',
    'insurance': 'health_insurance',
    'pto': 'vacation',
    'vacation': 'vacation',
    '401k': 'retirement',
    'retirement': 'retirement',
    'gym': 'fitness',
    'fitness': 'fitness',
    'remote': 'remote_work',
    'work from home': 'remote_work',
    'meal': 'food',
    'food': 'food',
    'visa': 'visa_sponsorship',
    'sponsor': 'visa_sponsorship',
    'stock': 'equity',
    'equity': 'equity',
    'education': 'education',
    'tuition': 'education',
    'parental': 'family',
    'family': 'family',
  };
}
