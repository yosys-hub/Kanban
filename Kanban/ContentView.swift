//
//  ContentView.swift
//  Kanban
//
//  Created by 荻野善祥 on 2025/07/05.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var taskManager = TaskManager()
    
    var body: some View {
        KanbanBoardView(taskManager: taskManager)
    }
}

#Preview {
    ContentView()
}
