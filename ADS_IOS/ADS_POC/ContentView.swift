//
//  ContentView.swift
//  ADS_POC
//
//  Created by Joao Igor de Andrade Oliveira on 27/02/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var nativeViewModel = NativeAdViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    if nativeViewModel.isLoading {
                        ProgressView("Loading Ad...")
                            .padding(.top, 50)
                    } else if nativeViewModel.nativeAd != nil {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Top Image Layout")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            NativeAdViewWrapper(nativeAd: nativeViewModel.nativeAd, layout: .topImage)
                                .frame(height: 280)
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Bottom Image Layout")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            NativeAdViewWrapper(nativeAd: nativeViewModel.nativeAd, layout: .bottomImage)
                                .frame(height: 290)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Left Image Layout")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            NativeAdViewWrapper(nativeAd: nativeViewModel.nativeAd, layout: .leftImage)
                                .frame(height: 128)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Right Image Layout")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            NativeAdViewWrapper(nativeAd: nativeViewModel.nativeAd, layout: .rightImage)
                                .frame(height: 128)
                        }
                    } else {
                        Text("No Ad Loaded")
                            .foregroundColor(.secondary)
                            .padding(.top, 50)
                    }
                    
                    Button(action: {
                        nativeViewModel.refreshAd()
                    }) {
                        Text("Load Native Ad")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                }
                .padding()
            }
            .navigationTitle("Native Ads POC")
        }
        .onAppear {
            nativeViewModel.refreshAd()
        }
    }
}

#Preview {
    ContentView()
}
