# FlutChat 💬

A real-time chat application built with Flutter and Firebase.

## ✨ Features

*   **Authentication:** Secure user login and registration using Firebase Auth.
*   **Real-time Chat:** Send and receive messages instantly with Cloud Firestore.
*   **Contact Management:** View and interact with contacts (Implementation details TBD based on `lib/features/contacts/`).
*   **Image Sharing:** Share images within chats (using `image_picker` and Firebase Storage).
*   **Responsive Design:** Adapts to different screen sizes using `responsive_sizer`.
*   **State Management:** Uses Riverpod for efficient state management.

## 🚀 Tech Stack

*   **Frontend:** Flutter
*   **Backend:** Firebase (Authentication, Cloud Firestore, Firebase Storage, App Check)
*   **State Management:** Flutter Riverpod
*   **UI:** Material Design, Google Fonts, Responsive Sizer
*   **Utilities:** `image_picker`, `fluttertoast`

## 📸 Screenshots



*   Login Screen
*   Home/Chat List Screen
*   Chat Screen

## ⚙️ Setup & Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/FlutChat.git
    cd FlutChat
    ```
    *(Replace `your-username` with the actual GitHub username/organization)*

2.  **Set up Firebase:**
    *   Create a new Firebase project at [https://console.firebase.google.com/](https://console.firebase.google.com/).
    *   Add an Android and/or iOS app to your Firebase project.
    *   Follow the Firebase setup instructions for Flutter: [https://firebase.google.com/docs/flutter/setup](https://firebase.google.com/docs/flutter/setup)
    *   Download the `google-services.json` file for Android and place it in `android/app/`.
    *   Download the `GoogleService-Info.plist` file for iOS and place it in `ios/Runner/`.
    *   Enable Authentication (e.g., Email/Password), Cloud Firestore, and Firebase Storage in the Firebase console.
    *   Configure Firebase App Check if needed.

3.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

## ▶️ Running the App

1.  Ensure you have a connected device (emulator or physical device).
2.  Run the app:
    ```bash
    flutter run
    ```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

*(Optional: Add more detailed contribution guidelines if needed)*

