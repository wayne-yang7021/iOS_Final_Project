import SwiftUI
import Foundation

struct AllDiaryView: View {
    @State private var shouldShowEditSheet = false
    @State private var shouldShowCalendar = false
    @State private var selectedDate: Date? = nil
    @State private var scrollTarget: UUID? = nil
    @State var diaries: [Diaries]

    var body: some View {
        ZStack {
            // 背景色
            Color.black.ignoresSafeArea()

            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // 標題和右上角按鈕
                        HStack {
                            Text("  My Diary")
                                .font(.largeTitle.bold())
                                .foregroundColor(.white)
                            Spacer()

                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    shouldShowCalendar = true
                                }
                            }) {
                                Image(systemName: "calendar")
                                    .font(.title)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal)

                        // 日記項目
                        VStack(spacing: 24) {
                            ForEach($diaries) { diary in
                                DiaryView(diary: diary)
                                    .id(diary.id) // 為每篇日記設置唯一的 id，便於滾動
                            }
                        }
                        .padding(.horizontal)

                        Spacer()
                    }
                    .padding(.top)
                    if diaries.count == 0 {
                        Text("Go add a diary for today!")
                            .font(.custom("default", size: 24))
                            .foregroundColor(.white)
                            .frame(height: 500)
                            .padding()
                    }
                    if diaries.count > 3 {
                        Button(action: {
                            withAnimation {
                                proxy.scrollTo(diaries.first?.id, anchor: .top)
                            }
                        }) {
                            Image(systemName: "arrow.up")
                                .font(.title)
                                .foregroundColor(.black)
                                .padding()
                                .background(Circle().fill(Color.white))
                        }
                        .padding(.bottom, 16)
                    }
                    
                }
                .onChange(of: scrollTarget) { target in
                    if let target = target {
                        proxy.scrollTo(target, anchor: .top)
                    }
                }
            }
            // 新增日記按鈕
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        shouldShowEditSheet = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(.black)
                            .padding()
                            .background(Circle().fill(Color.white))
                    }
                    .transition(.opacity.combined(with: .scale))
                    .padding()
                }
            }

            // 日曆彈窗
            if shouldShowCalendar {
                CalendarView(
                    diaries: diaries,
                    selectedDate: $selectedDate,
                    shouldShowCalendar: $shouldShowCalendar,
                    scrollTarget: $scrollTarget
                )
                .transition(.opacity.combined(with: .scale)) //
                
            }
            
            if shouldShowEditSheet {
                EditDiaryView(isPresented: $shouldShowEditSheet, diaries: $diaries)
                .transition(.opacity.combined(with: .scale)) //
                
            }
            
        }
    }
}

#Preview {
    AllDiaryView(diaries: .diaries)
}
