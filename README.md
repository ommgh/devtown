# Devtown

## Features
- Sign Up With Email, Password
- Sign In With Email, Password
- Posting Text
- Posting Image
- Posting Link
- Hashtag identification & storage
- Displaying posts
- Liking posts
- Commenting/Replying
- Follow user
- Search users
- Display followers, following, recent tweets
- Edit User Profile
- Show tweets that have 1 hashtag
- Dev Green
- Notifications tab (replied to you, followed you, like your pic)

## Prerequisites

Before setting up the project locally, ensure that you have the following installed:

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Dart: [Install Dart](https://dart.dev/get-dart)
- Appwrite server: [Install Appwrite](https://appwrite.io/docs/installation)

## Setup

Follow these steps to set up the project locally:

1. Clone the repository:

```bash
git clone https://github.com/IamOm775/social-media-app
```
2. Navigate to the project directory:

```bash
cd social-media-app
```
3. Install the project dependencies:
```bash
flutter pub get
```
4. Create your Appwrite Cloud account from https://appwrite.io/

5. Configure the Appwrite SDK in the Flutter project:

- Open the lib/constants/appwrite_dependency.dart file.
- Enter the required IDs for the placeholders.
```dart
class AppwriteContants {
  static const String databaseID = " ";
  static const String projectID = " ";
  static const String endPoint = "https://cloud.appwrite.io/v1";
  static const String userCollection = " ";
  static const String postCollection = " ";
  static const String imagesBucket = " ";
  static String imageurl(String imageId) =>
      "$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectID&mode=admin";
}
```
6. Run the app on your preferred device or emulator:
```bash
flutter run
```
## License
This project is licensed under the MIT License.

## Tech Stack

- Flutter: https://flutter.dev/
- Appwrite: https://appwrite.io/
- Riverpod: https://riverpod.dev/

## Contact 

If you have any questions or suggestions, feel free to reach out to me at:-
om.works01@gmail.com .





