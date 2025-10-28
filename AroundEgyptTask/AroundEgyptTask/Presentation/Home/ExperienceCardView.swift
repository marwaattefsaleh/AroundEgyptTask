//
//  ExperienceCardView.swift
//  AroundEgyptTask
//
//  Created by Marwa Attef on 28/10/2025.
//
import SwiftUI
import Kingfisher

struct ExperienceCardView: View {
    @Binding var item: ExperienceEntity
    let onAction: (ExperienceCardViewAction) -> Void

    var body: some View {
        VStack(spacing: Theme.Sizes.pt8) {
            KFImage(URL(string: item.coverPhoto ?? ""))
                .resizable()
                .cacheOriginalImage()
                .onFailure { e in
                    print("Image loading failed: \(e)")
                }
                .placeholder {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        )
                }
                .scaledToFill()
                .frame(height: Theme.Sizes.pt154)
                .overlay(
                    ZStack {
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black, Color.black.opacity(0.0001), Color.clear]),
                            startPoint: .bottom,
                            endPoint: .top
                        )
                        HStack {
                            if item.isRecommended {
                                HStack {
                                    Image("star")
                                    Text("RECOMMENDED")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                                .padding(.vertical, Theme.Sizes.pt2)
                                .padding(.horizontal, Theme.Sizes.pt4)
                                .hexBackground(Theme.Colors.color000000, opacity: 0.4975, cornerRadius: 8.75)
                            }
                            Spacer()
                            Image("info")
                               
                        }  // Top trailing info
                     
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .padding(Theme.Sizes.pt8)
                        
                        // Bottom trailing imgs
                        Image("imgs")
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                            .padding()
                        
                        // Bottom leading eye + text
                        HStack {
                            Image("eye")
                            Text("\(String(item.viewsNo))")
                                .font(.caption)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                        .padding(Theme.Sizes.pt8)
                        
                        Image("360")
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: Theme.Sizes.pt10))
            
            HStack {
                Text(item.title)
                    .font(.system(size: 14, weight: .medium, design: .default))
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Text("\(String(item.likesNo))")
                    .font(.system(size: Theme.Sizes.pt16, weight: .regular, design: .default))
                    Button(action: {
                        if !item.isLiked {
                            onAction(.like(item.id))
                        }
                    }) {
                        Image(item.isLiked ? "like" :"unlike")
                    }.buttonStyle(.plain)
                        .frame(width: 30, height: 30)
                }.padding(.trailing, Theme.Sizes.pt8)
            
        }
        .padding(.horizontal, 0)
        .onAppear {
        }
    }
}

enum ExperienceCardViewAction {
    case like(String)
  // Add More actions in card
   
}
