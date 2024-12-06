//
//  GeneratePictureView.swift
//  iOSClubChatBot
//
//  Created by 吳承翰 on 2024/12/2.
//
import SwiftUI

//let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiYmFjYjFlODQtNTg4Yi00MDA5LWFhNjctY2RkOWMzZjNhNDliIiwidHlwZSI6ImFwaV90b2tlbiJ9.AJpv7rRYcgbF5j964uQGBfxiMvtDgxReExFGY-JZOfE"
//let workflow_id = "f2550a3e-ab7c-45ed-8ecf-2c279039c011"

struct GeneratePictureView: View {
    @State private var generatedImage: Image = Image(systemName: "photo") // Placeholder image
    @State private var isLoading = false
    @State private var diaryContent = "Today, I went to ChingMai in Thailand to see the elephant, and we help them take a bath."

    var body: some View {
        NavigationStack {
            VStack {
                if isLoading {
                    ProgressView() // Loading indicator
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    generatedImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .padding()
                }

                Button(action: {
                    Task {
                        isLoading = true
                        if (diaryContent != "") {
                            try await generatedImage  = generatePicture(prompt: diaryContent)
                        }
                        isLoading = false
                    }
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundStyle(.white)
                        .padding(8)
                        .background(Color.blue, in: .capsule)
                }
            }
            .navigationTitle("Generate Picture")
        }
    }

    func generatePicture(prompt: String) async throws -> Image {
        let url = URL(string:"https://image.pollinations.ai/prompt/" + prompt)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
//        let url = URL(string: "https://api.edenai.run/v2/workflow/\(workflow_id)/execution/")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        
//        let resolution = "1920*1080"
//        let data =
//        try JSONEncoder().encode(generateRequest(prompt: prompt, resolution: resolution))
//        
//        request.httpBody = data

        let session: URLSession = {
            let config = URLSessionConfiguration.default
            var header = config.httpAdditionalHeaders ?? [:]
//              header["Accept"] = "application/json"
              header["Content-Type"] = "application/json"
//              header["Authorization"] = "Bearer \(apiKey)"
            config.httpAdditionalHeaders = header
            
            return URLSession(configuration: config)
        }()
        
        
        let result = try await session.sendHTTPRequest(request)
        
//        let response = String(decoding: result.data, as: UTF8.self)
//        print(response)
//        let image = Image(uiImage: UIImage(data: Data(base64Encoded: response)!)!)
        let image = Image(uiImage: UIImage(data: result.data)!)
        return image
    }
}

#Preview("Generate Picture View") {
    GeneratePictureView()
}

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//

import Foundation


struct generateRequest: Codable {
    let prompt: String
    let resolution: String
}
struct generateResponse: Codable {
    let output: String
}
