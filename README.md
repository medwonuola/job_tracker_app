# Flutter Jobs Tracker App

A modern Flutter application for searching, tracking, and analyzing job applications. This app provides a seamless experience for job seekers to find opportunities from a hidden job board, save them for later, track their application status, and gain insights into their job-seeking journey through a detailed analytics dashboard.


## Table of Contents

- [Features](#features)
- [Screenshots](#screenshots)
- [Technical Stack & Architecture](#technical-stack--architecture)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [API Reference](#api-reference)
- [Contributing](#contributing)
- [License](#license)

## Features

-   **🔍 Powerful Job Search**:
    -   Search for jobs using keywords.
    -   Advanced filtering system including location, workplace type (Remote, Hybrid, On-site), commitment, experience level, salary range, perks, and quick apply options.
    -   View results in a clean, interactive list with custom-designed `JobListItem` cards.
    -   Debounced and throttled inputs for a smooth user experience.

-   **📄 Detailed Job View**:
    -   In-depth job details including a full description rendered from HTML.
    -   Company information, logo, and industry tags.
    -   A visually appealing row of perks and benefits.
    -   Direct link to the external application page via the device's browser.

-   **📊 Application Tracker**:
    -   Bookmark/save jobs from the search or detail screen.
    -   View all tracked applications in a central location.
    -   Update application status: `Saved`, `Applied`, `Interviewing`, `Offered`, `Rejected`.
    -   Filter tracked jobs by status with dynamic count badges.
    -   All tracked data is persisted locally using `SharedPreferences`.

-   **📈 Analytics Dashboard**:
    -   Get a high-level overview with key metrics like "Total Applications" and "Weekly Average".
    -   **Status Distribution Chart**: A pie chart visualizing the proportion of jobs in each status.
    -   **Time in Status Chart**: A bar chart showing the average number of days an application spends in each stage.
    -   **Application Trend Chart**: A line chart showing the cumulative number of applications over time.

-   **✨ Modern UI/UX**:
    -   Custom, consistent theme with defined colors, typography (`Manrope` font), and spacing.
    -   A suite of reusable core widgets like `AppButton`, `BorderedCard`, `ErrorStateWidget`, and `LoadingStateWidget`.
    -   Smooth animations and hover effects on interactive elements.
    -   Clear, intuitive navigation using a bottom navigation bar.

## Screenshots

| Job Search | Job Detail |
| :--------: | :--------: |
|  |  |

| Application Tracker | Analytics Dashboard |
| :-----------------: | :-----------------: |
|  |  |

## Technical Stack & Architecture

This project is built with a modern, scalable architecture, focusing on separation of concerns and reusability.

-   **Framework**: [**Flutter**](https://flutter.dev/)
-   **Language**: [**Dart**](https://dart.dev/)
-   **State Management**: [**Provider**](https://pub.dev/packages/provider) - For dependency injection and managing state across the app.
    -   `JobSearchProvider`: Manages state for the job search feature.
    -   `ApplicationTrackerProvider`: Manages the state of tracked jobs, including local persistence.
    -   `StatsProvider`: Computes and caches analytics data based on the `ApplicationTrackerProvider`.
-   **Networking**: [**Dio**](https://pub.dev/packages/dio) - A powerful HTTP client for making API requests, configured with timeouts and headers.
-   **Data Serialization**: [**json_serializable**](https://pub.dev/packages/json_serializable) & [**build_runner**](https://pub.dev/packages/build_runner) - For generating `fromJson`/`toJson` boilerplate for model classes.
-   **Local Storage**: [**shared_preferences**](https://pub.dev/packages/shared_preferences) - To persist the user's tracked job applications.
-   **UI & Components**:
    -   [**fl_chart**](https://pub.dev/packages/fl_chart): For creating beautiful and interactive charts in the analytics dashboard.
    -   [**flutter_html**](https://pub.dev/packages/flutter_html): To render job descriptions from HTML content.
    -   [**cached_network_image**](https://pub.dev/packages/cached_network_image): To efficiently load and cache company logos.
    -   [**google_fonts**](https://pub.dev/packages/google_fonts): For loading and using the `Manrope` font family.
-   **Environment Variables**: [**flutter_dotenv**](https://pub.dev/packages/flutter_dotenv) - To securely manage the RapidAPI key.
-   **Architecture**: The app follows a feature-first approach, with a clear separation between the data, feature (UI), and core layers.

## Project Structure

The project is organized into logical directories to ensure maintainability and scalability.

```txt
lib
├── api/                  # Handles communication with the external API.
│   └── api_service.dart
├── core/                 # Shared components, constants, and utilities.
│   ├── constants/
│   ├── exceptions/
│   ├── theme/
│   ├── utils/
│   └── widgets/
├── data/                 # Data models and state management (providers).
│   ├── models/
│   └── providers/
├── features/             # Individual screens and features of the app.
│   ├── home/
│   ├── job_detail/
│   ├── job_search/
│   ├── stats/
│   └── tracker/
└── main.dart             # App entry point and provider setup.
```

-   **`api`**: Contains the `ApiService` class responsible for all HTTP requests to the Hidden Job Board API.
-   **`core`**: Holds all the shared and reusable code, including themes, custom exceptions, utility functions (`Debouncer`, `DateFormatter`), and common widgets (`AppButton`, `BorderedCard`).
-   **`data`**: Home to data models (`Job`, `SearchFilters`) and the application's state managers (`...Provider`).
-   **`features`**: Contains the UI and feature-specific logic for each screen of the application (e.g., `JobSearchScreen`, `StatsScreen`).

## Getting Started

Follow these instructions to get the project up and running on your local machine.

### Prerequisites

-   Flutter SDK (version 3.6.1 or higher)
-   An editor like VS Code or Android Studio
-   A RapidAPI account to get an API key.

### Installation

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/your-username/job-tracker-app.git
    cd job-tracker-app
    ```

2.  **Set up the API Key:**
    -   Sign up on [RapidAPI](https://rapidapi.com).
    -   Subscribe to the [**Hidden Job Board API**](https://rapidapi.com/Cosmx/api/hidden-job-board).
    -   You will be provided with an `X-RapidAPI-Key`.
    -   Create a file named `.env` in the root of the project.
    -   Add your API key to the `.env` file:
        ```env
        RAPIDAPI_KEY=your_api_key_here
        ```

3.  **Install dependencies:**
    ```sh
    flutter pub get
    ```

4.  **Run the code generator:**
    This step is necessary to generate the `*.g.dart` files for your data models.
    ```sh
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

5.  **Run the app:**
    Connect a device or start an emulator and run the following command:
    ```sh
    flutter run
    ```

## API Reference

This project uses the **Hidden Job Board API** available on the RapidAPI Hub.

-   **API Provider**: Cosmx
-   **API Link**: [https://rapidapi.com/Cosmx/api/hidden-job-board](https://rapidapi.com/Cosmx/api/hidden-job-board)

The `api/api_service.dart` file handles the following endpoints:
-   `GET /search-jobs`: To search for jobs with various filters.
-   `GET /search-location`: To get location suggestions for the search filter.
-   `GET /get-departments`: To populate department filter options.
-   `GET /get-industries`: To populate industry filter options.

The service includes robust error handling for different HTTP status codes (e.g., 401, 429) and normalizes inconsistent API responses into a clean `Job` model.

## Contributing

Contributions are welcome! If you have suggestions for improvements or want to add new features, please feel free to:

1.  Fork the repository.
2.  Create a new branch (`git checkout -b feature/your-feature-name`).
3.  Make your changes.
4.  Commit your changes (`git commit -m 'Add some feature'`).
5.  Push to the branch (`git push origin feature/your-feature-name`).
6.  Open a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.