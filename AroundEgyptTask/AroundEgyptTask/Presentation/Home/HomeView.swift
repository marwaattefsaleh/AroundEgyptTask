//
//  HomeView.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//

import SwiftUI
import AlertToast
import SwiftUI_Shimmer

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @State var searchText: String = ""
    @State private var isEditing = false
    @State private var selectedExperience: ExperienceEntity?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: Theme.Sizes.pt30) {
                welcomeText
                if viewModel.recentExperienceEntityList.count == 0 && viewModel.recommendedExperienceEntityList.count == 0 && !viewModel.isLoadingRecent && !viewModel.isLoadingRecommended {
                    emptyStateView
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: Theme.Sizes.pt30) {
                            if !viewModel.isFromSearch {
                                recommendedExperiences
                            }
                                mostRecentExperiences
                        }
                    } .refreshable {
                        viewModel.getData()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Leading button
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { print("Menu tapped") }) {
                        Image("menu")
                    }
                }
                
                // Centered search field
                ToolbarItem(placement: .principal) {
                    HStack {
                        HStack {
                            Image("search")
                            TextField("search", text: $searchText, prompt: Text("Try “Luxor”")
                                .foregroundColor(Color(hex: Theme.Colors.color8E8E93)))
                            .hexForeground(Theme.Colors.color000000)
                            .submitLabel(.search) // Show search button on keyboard
                            .onSubmit {
                                viewModel.performSearch(searchText: searchText)
                                UIApplication.shared.dismissKeyboard()
                                
                            }
                            if !searchText.isEmpty {
                                Button(action: { searchText = "" }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                    
                                } .frame(width: Theme.Sizes.pt20, height: Theme.Sizes.pt20).padding(0)
                            }
                            
                        }.padding(8).hexBackground(Theme.Colors.color8E8E93, opacity: 0.12, cornerRadius: Theme.Sizes.pt10)
                        
                        if isEditing {
                            Button("Cancel") {
                                withAnimation {
                                    searchText = ""
                                    isEditing = false
                                    UIApplication.shared.dismissKeyboard()
                                }
                            }.foregroundColor(.black)
                        }
                    }.onChange(of: searchText) { _, newValue in
                        withAnimation {
                            if !newValue.isEmpty {
                                isEditing = true
                            } else {
                                viewModel.getData()
                            }
                        }
                    }
                }
                
                // Trailing buttons: Cancel + Person
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { print("Person tapped") }) {
                        Image("filter")
                    }
                }
            }.sheet(item: $selectedExperience) { experience in
                if let recommendedIndex = viewModel.recommendedExperienceEntityList.firstIndex(where: { $0.id == experience.id }) {
                    viewModel.navigateToDetail(experience: $viewModel.recommendedExperienceEntityList[recommendedIndex])

                } else if let recentIndex = viewModel.recentExperienceEntityList.firstIndex(where: { $0.id == experience.id }) {
                    viewModel.navigateToDetail(experience: $viewModel.recentExperienceEntityList[recentIndex])
                }
                
            }.onAppear {
                viewModel.getData()
            }.toast(isPresenting: $viewModel.showToast, duration: 2) {
                AlertToast(type: .regular, title: viewModel.toastMessage)
            }
        }
    }
    
    var welcomeText: some View {
        VStack(alignment: .leading) {
            Text("Welcome!")
                .font(.system(size: Theme.Sizes.pt20, weight: .bold, design: .default))
                .foregroundColor(Color(hex: Theme.Colors.color000000))
            Text("Now you can explore any experience in 360 degrees and get all the details about it all in one place.")
                .font(.system(size: Theme.Sizes.pt14, weight: .medium, design: .default))
        }.padding(.leading, Theme.Sizes.pt14)
            .padding(.trailing, Theme.Sizes.pt25)
            .padding(.top, Theme.Sizes.pt20)
    }
    
    var recommendedExperiences: some View {
        VStack(alignment: .leading, spacing: Theme.Sizes.pt8) {
            Text("Recommended Experiences")
                .font(.system(size: Theme.Sizes.pt22, weight: .bold, design: .default))
                .foregroundColor(Color(hex: Theme.Colors.color000000))
                .padding(.leading, Theme.Sizes.pt16)
            if viewModel.isLoadingRecommended {
                viewLoading
            } else {
                GeometryReader { geometry in
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            ForEach(0..<($viewModel.recommendedExperienceEntityList.wrappedValue.count), id: \.self) { ind in
                                
                                ExperienceCardView(item: $viewModel.recommendedExperienceEntityList[ind], onAction: { action in
                                    switch action {
                                    case .like(let id):
                                        viewModel.likeExperience(id: id)
                                    }
                                })
                                    .frame(width: geometry.size.width)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        selectedExperience = viewModel.recommendedExperienceEntityList[ind]
                                    }
                            }
                        }.scrollTargetLayout()
                    }.scrollTargetBehavior(.viewAligned)
                    
                }.frame(height: Theme.Sizes.pt185)
                    .safeAreaPadding(.horizontal, Theme.Sizes.pt16)
            }
        }
    }
    var mostRecentExperiences: some View {
        LazyVStack(alignment: .leading, spacing: Theme.Sizes.pt8) {
            if !viewModel.isFromSearch {
                Text("Most Recent")
                    .font(.system(size: 22, weight: .bold, design: .default))
                    .foregroundColor(Color(hex: Theme.Colors.color000000))
                    .padding(.horizontal, 16)
            }
            if viewModel.isLoadingRecent {
                viewLoading
            } else {
                ForEach(0..<($viewModel.recentExperienceEntityList.wrappedValue.count), id: \.self) { ind in
                    ExperienceCardView(item: $viewModel.recentExperienceEntityList[ind], onAction: { action in
                        switch action {
                        case .like(let id):
                            viewModel.likeExperience(id: id)
                        }
                    })
                        .padding(.bottom, Theme.Sizes.pt8).padding(.horizontal, Theme.Sizes.pt16)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedExperience = viewModel.recentExperienceEntityList[ind]
                        }
                }
            }
        }
    }
    
    var emptyStateView: some View {
        VStack(spacing: Theme.Sizes.pt8) {
            Image("empty_state")
                .resizable()
                .frame(width: Theme.Sizes.pt120, height: Theme.Sizes.pt120)
            Text("No Result Found")
                .font(.system(size: Theme.Sizes.pt22, weight: .bold, design: .default))
                .foregroundColor(Color(hex: Theme.Colors.color000000))
            Text("Adjust Filters to get better results")
                .font(.system(size: Theme.Sizes.pt16, weight: .regular, design: .default))
                .foregroundColor(Color(hex: Theme.Colors.color000000))
        }
        .padding(.bottom, Theme.Sizes.pt120)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    
    var viewLoading: some View {
        VStack {
            Color(hex: Theme.Colors.colorDDDDDD)
                .frame(height: Theme.Sizes.pt185)
                .frame(maxWidth: .infinity)
                .cornerRadius(Theme.Sizes.pt10)
                .clipped()
                .padding(.horizontal, Theme.Sizes.pt16)
        }.shimmering()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        //        HomeView()
    }
}
