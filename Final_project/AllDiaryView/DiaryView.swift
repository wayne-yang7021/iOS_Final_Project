import SwiftUI

struct DiaryView: View {
    @Binding var diary: Diaries
    @State private var shouldShowDetails = false

    var body: some View {
        VStack(spacing: 16) {
            // 封面圖片
            ZStack(alignment: .topTrailing) {
                Button(action: {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        shouldShowDetails.toggle()
                    }
                }) {
                    ZStack(alignment: .bottomTrailing) {
                        Image(uiImage: diary.picture)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(lineWidth: 1)
                            )
                        // 日期標籤
                        Text(diary.createdDate, style: .date)
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(6)
                            .background(Color.black.opacity(0.7))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .padding(8)
                    }
                }
                .buttonStyle(.plain)

                // 分享按鈕
                Button(action: shareDiary) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.black)
                        .imageScale(.large)
                        .padding(8)
                        .background(Color.white.opacity(0.8))
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 0)
                        .padding()
                }
            }

            // 展開的內容
            if shouldShowDetails {
                VStack(alignment: .leading, spacing: 8) {
                    TextEditor(text: .constant(diary.content))
                        .font(.custom("PingFangTC-Regular", size: 16)) // 使用蘋方正體
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .padding()
                        .background(Color.clear) // 透明背景
                        .disabled(true) // 禁止編輯
                }
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.3))
                        .shadow(color: .white.opacity(0.1), radius: 4, x: 2, y: 2)
                )
                .transition(.opacity.combined(with: .symbolEffect))
            }
        }
        .padding(.horizontal)
    }

    // 分享日記的功能
    private func shareDiary() {
        guard let image = diary.picture.pngData() else { return }
        
        let diaryText = "\(diary.content)\n\(diary.createdDate)"
        let activityItems: [Any] = [UIImage(data: image) ?? UIImage(), diaryText]
        
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        // 限制某些社交媒體應用的分享選項
        activityVC.excludedActivityTypes = [
            .addToReadingList,
            .print
        ]
        
        // 獲取頂層控制器並呈現分享選項
        if let rootVC = UIApplication.shared.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true, completion: nil)
        }
    }
}

#Preview {
    AllDiaryView(diaries: .diaries)
}
