AroundEgyptTask/
├── Application/
│   ├── DI/
│   │   └── AppComponent.swift      # Root Dependency Injection component
│   └── AroundEgyptTaskApp.swift           # App entry point (main struct)
│
├── DataLayer/
│   ├── Database/                   # Swift Data or local storage
│   ├── Networking/                 # API service layer
│   └── Repository/                # Interfaces to fetch data from remote/local
│
├── DomainLayer/
│   ├── Entities/                   # Business models
│   └── UseCases/                   # Application business logic
│
├── Presentation/
│   ├── Home/                       # List of Experiences view & logic
│   ├── ExperienceDetails/
│       ├── ExperienceDetailsComponent.swift  # DI for this feature
│       ├── ExperienceDetailsView.swift       # SwiftUI View
│       └── ExperienceDetailsViewModel.swift  # ViewModel for state and logic
│
├── Shared/
│   ├── Extensions                 # Custom Swift extensions
│   ├── Modifiers                 # SwiftUI view modifiers
│   ├── Theme                      # Global app theme config
│   └── Utils                      # Utilities/helpers
│
└── Generated/                     # Codegen outputs (e.g. Needle)
