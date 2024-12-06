////
////  Diaries.swift
////  Final_project
////
////  Created by 楊東韋 on 2024/12/2.
////
import Foundation
import SwiftUI

struct Diaries: Identifiable {
    var id: UUID = UUID()
    var content: String
    var picture: UIImage
    var createdDate: Date = .now
}
//
//
//var allDiaries: [Diaries] = [
//    Diaries(content: "Today is a good day", picture: UIImage(systemName: "sun.max.fill")!, createdDate: .now),
//]
//
//// 用於新增日記的全局函數
//func addDiary(content: String, picture: UIImage, createdDate: Date = .now) {
//    let newDiary = Diaries(content: content, picture: picture, createdDate: createdDate)
//    allDiaries.insert(newDiary, at: 0) // 在開頭插入新日記
//}
//
//// 用於新增日記的全局函數
//func getDiary() -> [Diaries]{
//    return allDiaries;
//}
extension [Diaries] {
    static let diaries: [Diaries] = [
//        Diaries(content: "Today is a good day", picture: .image, createdDate: .now),
    ]
}
//
