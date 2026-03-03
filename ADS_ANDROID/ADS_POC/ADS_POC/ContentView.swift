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
            VStack(spacing: 20) {
                if nativeViewModel.isLoading {
                    Spacer()
                    ProgressView("Loading Ad...")
                } else if nativeViewModel.nativeAd != nil {
                    NativeAdViewWrapper(nativeAd: nativeViewModel.nativeAd)
                        .padding()
                } else {
                    Text("No Ad Loaded")
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
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
