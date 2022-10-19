//
//  ContentView.swift
//  PhotoPickerInSwiftUI
//
//  Created by Ramill Ibragimov on 19.10.2022.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var imageData: Data?
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        VStack {
            PhotosPicker(selection: $selectedItem, matching: .images) {
                Label("Select a photo", systemImage: "plus.app")
            }
            .onChange(of: selectedItem) { newSelectedItem in
                Task {
                    if let data = try? await newSelectedItem?.loadTransferable(type: Data.self) {
                        await MainActor.run {
                            imageData = data
                        }
                    }
                }
            }
            Divider()
            if let imageData, let uiIMage = UIImage(data: imageData) {
                Image(uiImage: uiIMage)
                    .resizable()
                    .scaledToFit()
            }
            Spacer()
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
