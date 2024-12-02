# FilterResult

FilterResult is an iOS application designed to provide multi-selection filter results. It follows the MVVM (Model-View-ViewModel) architecture to ensure clean separation of concerns and maintainability.

# Architecture

The application employs the MVVM pattern, comprising the following components:
	1.	Model: Represents the application’s data layer. It contains data objects and handles data-related operations.
	2.	ViewModel: Acts as an intermediary between the View and Model. It retrieves data from the Model, processes it, and provides it to the View.
	3.	View (ViewController): Manages the user interface, displays data provided by the ViewModel, and handles user interactions.

This architecture promotes a clear separation of concerns, making the application easier to maintain, test, and extend.

# Features

	•	Filtering: Select multiple criteria using the available filter options, and the app dynamically displays the filtered results.
	•	Customization: Extend filtering options and adjust filtering logic by modifying the FilterViewModel and FilterModel classes.

# Requirements

To build and run this application, ensure your development environment meets the following requirements:
	•	Xcode: Version 15.0 or later
	•	iOS SDK: Version 16.0 or later
	•	Deployment Target: iOS 15.0 or later
	•	Swift: Version 5.8 or later
