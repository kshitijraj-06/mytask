# My Task - AffWorld Assignment (Built with FLUTTER) 

## Features

- ✅ **Task Management**: Add, edit, and delete tasks with ease
- 🎯 **Priority System**: Mark tasks as High, Medium, or Low priority
- ✔️ **Completion Tracking**: Check off completed tasks
- 🎨 **Beautiful UI**: Clean, modern interface with smooth animations
- 📱 **Responsive Design**: Works on all screen sizes
- 🔄 **Swipe Actions**: Swipe left to delete, swipe right to edit
- 📊 **Progress Tracking**: See your completion percentage

## Installation

1. **Prerequisites**:
   - Flutter SDK (latest stable version)
   - Dart SDK
   - Android Studio/Xcode (for mobile development)

2. **Clone the repository**:
   ```bash
   git clone https://github.com/kshitijraj-06/mytask.git
   cd mytask
   ```

3. **Install dependencies**:
   ```bash
   flutter pub get
   ```

4. **Run the app**:
   ```bash
   flutter run
   ```

## Dependencies

This app uses the following packages:

- `get`: ^4.6.5 (State management)
- `get_storage`: ^2.1.1 (Local storage)
- `flutter_local_notifications`: ^16.1.0 (Reminders)
- `timezone`: ^0.9.2 (Time zone support)

## Project Structure

```
lib/
├── main.dart                # App entry point
├── service.dart             # Business logic 
├── task-model.dart          # Task data model 
├── noti_service.dart        # Notification handling
└── home_page.dart           # Main UI screen
```

## Configuration

### Android Setup

Add these permissions to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

### iOS Setup (if needed)

Add this to `ios/Runner/Info.plist`:
```xml
<key>UIBackgroundModes</key>
<array>
  <string>fetch</string>
  <string>remote-notification</string>
</array>
```

## How to Use

1. **Adding a Task**:
   - Type your task in the input field
   - Press the + button or hit enter
   - Tasks default to Low priority

2. **Editing a Task**:
   - Swipe right on any task
   - OR tap directly on a task
   - Modify text and/or priority in the dialog
   - Tap "Save" to confirm

3. **Changing Priority**:
   - Edit the task
   - Select new priority (High/Medium/Low)
   - The colored dot will update immediately

4. **Marking Complete**:
   - Tap the checkbox on any task
   - Completed tasks show with stri
