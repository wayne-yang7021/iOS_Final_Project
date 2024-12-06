import SwiftUI


struct EditDiaryView: View {
    @Binding var isPresented: Bool
    @Binding var diaries: [Diaries]
    @State private var diaryContent: String = ""
    @State private var generatedImage: UIImage = UIImage(systemName: "photo")! // Placeholder image
    @State private var isLoading = false

    let today: Date = .now

    var body: some View {
        ZStack {
            Color.black.opacity(0.95).ignoresSafeArea()

            VStack {
                Text("Today's Diary")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .padding()
                
                Text(today, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                

//                Spacer()

                // 編輯器
                TextField("User Content", text: $diaryContent, prompt: Text("Please enter the content here ...").foregroundColor(Color.gray), axis: .vertical)
                    .padding()
                    .frame(height: 500, alignment: .top)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.2))
                    )
                    .foregroundColor(.white)
                    .font(.body)
                    .padding()
                    
                
                
                

                Spacer()

                // 按鈕欄
                buttonBar
            }
            .padding()
            
            // ProgressView 顯示在最上層
            if isLoading {
                ZStack {
                    Color.black.opacity(0.6) // 半透明背景遮罩
                        .ignoresSafeArea()
                    
                    ProgressView("Generating Image...")
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.black)
                                .opacity(0.8)
                        )
                        .foregroundColor(.white)
                }
            }
        }
        
    }

    var buttonBar: some View {
        HStack(spacing: 16) {
            Button(role: .cancel) {
                withAnimation {
                    isPresented = false
                }
            } label: {
                Text("Cancel")
                    .font(.title3.bold())
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: 150)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                    
            }

            Button("Generate 🪄") {
                Task{
                    do{
                        isLoading = true
                        generatedImage = try await generatePicture(prompt: diaryContent)
                        let newDiary = Diaries(
                            content: diaryContent,
                            picture: generatedImage,
                            createdDate: Date()
                        )
                        diaries.insert(newDiary, at: 0)
                        withAnimation {
                            isPresented = false
                        }
                    }catch{
                        print("Error generating image: \(error.localizedDescription)")
                        isLoading = false
                    }
                }
                
                    
                
            }.font(.title3.bold())
                .foregroundColor(.white)
            .padding()
            .frame(width: 150)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.purple.opacity(0.6)))
            
            
        }
        .padding(.bottom)
        
        
    }
    
    func generatePicture(prompt: String) async throws -> UIImage {
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
        let image = UIImage(data: result.data)!
        return image
    }
}

//#Preview {
//    EditDiaryView(isPresented: .constant(true), diaries: .diaries)
//}
