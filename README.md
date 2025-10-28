# AroundEgyptTask


<img width="200" height="500" alt="Simulator Screenshot" src="https://github.com/user-attachments/assets/a7c8f894-67a0-4025-a47b-22fa73efccb2" /> <img width="200" height="500" alt="Simulator Screenshot" src="https://github.com/user-attachments/assets/8335dbb8-2366-4021-9f83-5ce257fbbe3b" />
---

## 🏗️ Architecture
The app follows **Clean Architecture** with the **MVVM pattern** and **Dependency Injection** using **NeedleFoundation**.

**Architecture Flow:**

View → ViewModel → UseCase → Repository → Data Sources (Remote / Local)

## 📁 Project Structure
```
AroundEgyptTask/
├── Application/
│ ├── DI/
│ │ ├── AppComponent.swift
│ │ └── NeedleGenerated/
│ ├── AppDelegate.swift
│ ├── AroundEgyptTaskApp.swift
│ └── NetworkMonitor.swift
├── DataLayer/
│ ├── Database/
│ │ ├── ExperienceLocalDataSource.swift
│ │ ├── ExperienceModelActor.swift
│ │ └── DatabaseError.swift
│ ├── Models/
│ │ ├── Experience.swift
│ │ └── BaseResponse.swift
│ ├── Networking/
│ │ ├── Base/
│ │ └── ExperienceRemoteDataSource.swift
│ └── Repository/
│ └── ExperienceRepository.swift
├── DomainLayer/
│ ├── Entities/
│ │ └── ExperienceEntity.swift
│ └── UseCases/
│ ├── ExperienceUseCase.swift
│ └── ExperienceUseCaseComponent.swift
└── Presentation/
├── Home/
│ ├── HomeView.swift
│ ├── HomeViewModel.swift
│ ├── HomeComponent.swift
│ └── ExperienceCardView.swift
└── ExperienceDetails/
├── ExperienceDetailsView.swift
├── ExperienceDetailsViewModel.swift
└── ExperienceDetailsComponent.swift
```

---

## ⚙️ Frameworks & Libraries

**Podfile dependencies:**

```ruby
pod 'Alamofire'                    # Networking
pod 'Firebase/Crashlytics'         # Crash reporting
pod 'SwiftLint'                    # Code style enforcement
pod 'NeedleFoundation'             # Dependency Injection
pod 'Kingfisher'                   # Image loading & caching
pod 'SwiftUI-Shimmer', :git => 'https://github.com/markiv/SwiftUI-Shimmer.git' # Loading animations
pod 'AlertToast'                   # Toast notifications
```

**Core Technologies:**
- SwiftUI – Declarative UI framework
- SwiftData – Local data persistence
- Async/Await – Modern concurrency
- MVVM – Architecture pattern
- Clean Architecture – Separation of concerns
- Needle – Compile-time safe Dependency Injection

## 📂 Layer Details

**Application Layer**
- AppComponent: Root dependency injection component
- NetworkMonitor: Real-time network connectivity monitoring
- AppDelegate: Firebase setup and app lifecycle management

**Domain Layer**
- Entities: Business model objects
- UseCases: Application business rules and operations

**Data Layer**
- Repository: Single source of truth for data
- RemoteDataSource: API communication layer
- LocalDataSource: SwiftData persistence layer
- ModelActor: Thread-safe SwiftData operations

**Presentation Layer**
- Views: SwiftUI screens and components
- ViewModels: Presentation logic and state management
- Components: Needle dependency components

## 🚀 Features
- Home screen with recommended and recent experiences
- Experience details view
- Offline support via SwiftData
- Image caching with Kingfisher
- Toast notifications for errors
