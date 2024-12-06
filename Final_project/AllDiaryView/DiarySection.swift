////
////  DiarySection.swift
////  Final_project
////
////  Created by 楊東韋 on 2024/12/2.
////
//
//
//import Foundation
//
//// MARK: ⚠️ 這頁內容不需要閱讀。除非你已經有開發經驗且想往工程師發展。
//// MARK: 這一頁是 Array<Todo> 的分組和排序邏輯。
//
//struct TodoSection: Identifiable, Equatable {
//    var id: String { date }
//    let date: String
//    var diaries: [Diaries]
//}
//
//extension [Diaries] {
//    func sectioned() -> [TodoSection] {
//        self
//            .reduce(into: [TodoSectionTitle: [Todo]]()) { dict, todo in
//                dict[TodoSectionTitle(todo), default: []].append(todo)
//            }
//            .sorted { a, b in
//                return a.key < b.key
//            }
//            .map {
//                TodoSection(title: $0.key.description, todos: $0.value)
//            }
//    }
//    
//    
//    private enum TodoSectionTitle: Hashable, Comparable {
//        case done
//        case noDueDate
//        case hasDueDate(Date)
//        
//        init(_ todo: Todo) {
//            if todo.isDone {
//                self = .done
//            } else if let dueDate = todo.dueDate {
//                self = .hasDueDate(Calendar.autoupdatingCurrent.startOfDay(for: dueDate))
//            } else {
//                self = .noDueDate
//            }
//        }
//        
//        var description: String {
//            switch self {
//                case .done: "已完成"
//                case .noDueDate: "未排定時間"
//                case .hasDueDate(let date): date.relativeDateDescription
//            }
//        }
//        
//        // 未完成、日期小的比較小
//        static func <(lhs: Self, rhs: Self) -> Bool {
//            switch (lhs, rhs) {
//                case (.done, _): false
//                case (_, .done): true
//                case (_, .noDueDate): true
//                case (.noDueDate, _): false
//                case (.hasDueDate(let a), .hasDueDate(let b)): a < b
//            }
//        }
//    }
//}
