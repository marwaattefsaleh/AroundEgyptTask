//
//  ExperienceDetailsView.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//

import SwiftUI
import Kingfisher
import AlertToast
import SwiftUI_Shimmer

struct ExperienceDetailsView: View {
    @StateObject var viewModel: ExperienceDetailsViewModel

  @Binding var experience: ExperienceEntity
    
    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                viewLoading
            } else {
                viewContent
            }
        }.onAppear {
            viewModel.getExperienceDetails(id: experience.id)
        }.toast(isPresenting: $viewModel.showToast, duration: 2) {
            AlertToast(type: .regular, title: viewModel.toastMessage)
        }
    }
    
    var viewContent: some View {
        VStack {
            KFImage(URL(string: viewModel.experienceEntity?.coverPhoto ?? ""))
                .cacheOriginalImage()
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: Theme.Sizes.pt285)
                .clipped()
                .overlay(
                    GeometryReader { geo in
                        ZStack {
                            // Gradient overlay
                            LinearGradient(
                                gradient: Gradient(colors: [Color.black.opacity(0.4), Color.clear]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .frame(width: geo.size.width, height: geo.size.height)
                            
                            HStack {
                                HStack(spacing: Theme.Sizes.pt4) {
                                    Image("eye")
                                    Text("\(String(viewModel.experienceEntity?.viewsNo ?? 0)) views")
                                        .font(.system(size: 14, weight: .regular, design: .default))
                                        .foregroundColor(.white)
                                        .shadow(radius: 1)
                                }
                                
                                Spacer()
                                
                                // Bottom trailing
                                Image("imgs")
                            }
                            .padding(8)
                            .frame(width: geo.size.width, height: geo.size.height, alignment: .bottom)
                            
                            // Center 360 icon
                            Button("EXPLORE NOW", action: {
                                
                            })
                            .foregroundColor(Color(hex: Theme.Colors.colorF18757))
                            
                            .frame(width: Theme.Sizes.pt152, height: Theme.Sizes.pt46, alignment: .center)
                            .hexBackground(Theme.Colors.colorFFFFFF, cornerRadius: Theme.Sizes.pt7)
                        }
                    }
                )
            VStack {
                HStack {
                    Text("\(viewModel.experienceEntity?.title ?? "")")
                        .font(.system(size: Theme.Sizes.pt16, weight: .bold, design: .default))
                        
                    Spacer()
                    Image("share")
                   
                    Button(action: {
                        viewModel.likeExperience(id: experience.id) {done in
                            if !done {return}
                            experience.likesNo = viewModel.experienceEntity?.likesNo ?? 0
                            experience.isLiked = viewModel.experienceEntity?.isLiked ?? false
                        }
                    }) {
                        Image(viewModel.experienceEntity?.isLiked ?? false ? "like" :"unlike")
                    }
                    Text("\(String(viewModel.experienceEntity?.likesNo ?? 0))")
                        .font(.system(size: Theme.Sizes.pt16, weight: .regular, design: .default))
                    
                }.padding(.top, Theme.Sizes.pt8)
                Text("\(viewModel.experienceEntity?.cityName ?? ""), Egypt").frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color(hex: Theme.Colors.color555555))
                Divider()
                    .background(Color.gray) // optional custom color

                Text("Description")
                    .font(.system(size: Theme.Sizes.pt22, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, Theme.Sizes.pt8)
                
                Text("\(viewModel.experienceEntity?.desc ?? "")")
                    .font(.system(size: Theme.Sizes.pt14, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
            }.padding(.horizontal, Theme.Sizes.pt16)
        }
    }
    
    var viewLoading: some View {
        VStack(alignment: .leading, spacing: Theme.Sizes.pt16) {
            Color(hex: Theme.Colors.colorDDDDDD)
                .frame(height: Theme.Sizes.pt285)
                .frame(maxWidth: .infinity)
                .clipped()
            
            Color(hex: Theme.Colors.colorDDDDDD)
                .frame(height: Theme.Sizes.pt20)
                .padding(.horizontal, Theme.Sizes.pt16)
            Color(hex: Theme.Colors.colorDDDDDD)
                .frame(height: Theme.Sizes.pt30)
                .padding(.horizontal, Theme.Sizes.pt16)
            Color(hex: Theme.Colors.colorDDDDDD)
                .frame(height: Theme.Sizes.pt20)
                .padding(.horizontal, Theme.Sizes.pt16)
            Color(hex: Theme.Colors.colorDDDDDD)
                .frame(height: Theme.Sizes.pt20)
                .padding(.horizontal, Theme.Sizes.pt16)
        }
        
        .shimmering()
    }
}
