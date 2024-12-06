import SwiftUI

struct CalendarView: View {
    @State var diaries: [Diaries]
    @Binding var selectedDate: Date?
    @Binding var shouldShowCalendar: Bool
    @Binding var scrollTarget: UUID?

    var body: some View {
        ZStack {
            // 背景半透明黑色覆蓋
            Color.black.opacity(0.8)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        shouldShowCalendar = false
                    }
                }

            // 中心彈出日曆
            VStack {
                Text("Select a Date")
                    .font(.title.bold())
                    .foregroundColor(.black)
                    .padding()

                // 真實日曆
                DatePicker(
                    "",
                    selection: Binding<Date>(
                        get: { selectedDate ?? Date() },
                        set: { date in
                            selectedDate = date
                            if let diary = diaries.first(where: { Calendar.current.isDate($0.createdDate, inSameDayAs: date) }) {
                                scrollTarget = diary.id
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    shouldShowCalendar = false
                                }
                            }
                        }
                    ),
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.8))
                )
                
                .accentColor(.gray)

                // 顯示頭貼
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 16) {
//                        ForEach(diaries, id: \.id) { diary in
//                            if Calendar.current.isDate(diary.createdDate, inSameDayAs: selectedDate ?? Date()) {
//                                ZStack {
//                                    Circle()
//                                        .fill(Color.white)
//                                        .frame(width: 60, height: 60) // 背景圓形
//                                    Image(diary.picture)
//                                        .resizable()
//                                        .scaledToFill()
//                                        .frame(width: 60, height: 60) // 填滿圓形
//                                        .clipShape(Circle())
//                                }
//                            }
//                        }
//                    }
//                }
//                .padding(.top, 16)

                // Spacer()

                // 關閉按鈕
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        shouldShowCalendar = false
                    }
                }) {
                    Text("Close")
                        .font(.title2.bold())
                        .foregroundColor(.black)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.black.opacity(0.1)))
                }
                .padding()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
            )
            .padding()
        }
        .transition(.opacity.combined(with: .scale)) // 添加輕柔的日曆彈出動畫
    }
}

#Preview {
    CalendarView(
        diaries: .diaries,
        selectedDate: .constant(nil),
        shouldShowCalendar: .constant(true),
        scrollTarget: .constant(nil)
    )
}
