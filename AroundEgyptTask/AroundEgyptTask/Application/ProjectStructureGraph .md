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
