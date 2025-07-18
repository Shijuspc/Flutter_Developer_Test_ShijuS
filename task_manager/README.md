# Task Manager App - Flutter Developer Test


## 🛠 Tech Stack

- Flutter 3.22
- GetX (state management)
- Firebase Firestore
- REST API (`https://jsonplaceholder.typicode.com/todos`)
- GetStorage (local caching)

---

##  Features

- Responsive UI with GetX
- Task List & Detail screens
- Firestore CRUD (realtime updates)
- Import tasks from REST API → Save to Firebase
- Offline fallback using cache
- Error handling with snackbars

---

##  Screenshots

 Replace below with actual screenshots  
- `screenshots/task_list_android.png`  
- `screenshots/task_detail_android.png`  
- `screenshots/firestore_data.png`  

# apk added
- `screenshots/taskmanager.apk` 

# API DATA
[
  {
    "userId": 1,
    "id": 1,
    "title": "delectus aut autem",
    "completed": false
  },
  ]

# Install Dependencies
flutter pub get

# Firebase Setup

Download google-services.json and place it in:
android/app/

Download GoogleService-Info.plist and place it in:
ios/Runner/

# API Configuration
No API key required. Uses:
https://jsonplaceholder.typicode.com/todos

# Run the App
flutter clean
flutter run
flutter build apk --no-tree-shake-icons


##  Tasks Summary


 Task 1 UI with GetX, Task List & Detail 
 Task 2  Firestore integration (CRUD) 
 Task 3  API integration with caching 
 Task 4  Optimizations (Obx, cache, indexed query) 

