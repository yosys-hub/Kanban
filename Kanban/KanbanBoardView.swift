import SwiftUI

struct KanbanBoardView: View {
    @ObservedObject var taskManager: TaskManager
    @State private var draggedTask: Task?
    @State private var showingAddTask = false
    
    var body: some View {
        NavigationView {
            HStack(spacing: 16) {
                ForEach(TaskStatus.allCases, id: \.self) { status in
                    KanbanColumnView(
                        status: status,
                        tasks: tasksForStatus(status),
                        taskManager: taskManager,
                        draggedTask: $draggedTask
                    )
                }
            }
            .padding()
            .navigationTitle("Kanban Board")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddTask = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddTask) {
                AddTaskView(taskManager: taskManager)
            }
        }
    }
    
    private func tasksForStatus(_ status: TaskStatus) -> [Task] {
        return taskManager.tasks.filter { $0.status == status }
    }
}

struct KanbanColumnView: View {
    let status: TaskStatus
    let tasks: [Task]
    let taskManager: TaskManager
    @Binding var draggedTask: Task?
    
    var body: some View {
        VStack(spacing: 12) {
            // Column Header
            HStack {
                Image(systemName: status.icon)
                    .foregroundColor(Color(status.color))
                Text(status.rawValue)
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Text("\(tasks.count)")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(status.color).opacity(0.2))
                    .cornerRadius(12)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(status.color).opacity(0.1))
            .cornerRadius(12)
            
            // Tasks
            LazyVStack(spacing: 8) {
                ForEach(tasks) { task in
                    TaskCardView(task: task, taskManager: taskManager)
                        .onDrag {
                            draggedTask = task
                            return NSItemProvider(object: task.id.uuidString as NSString)
                        }
                        .onDrop(of: [.text], delegate: DropViewDelegate(
                            task: task,
                            targetStatus: status,
                            taskManager: taskManager,
                            draggedTask: $draggedTask
                        ))
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(16)
        .onDrop(of: [.text], delegate: DropViewDelegate(
            task: nil,
            targetStatus: status,
            taskManager: taskManager,
            draggedTask: $draggedTask
        ))
    }
}

struct TaskCardView: View {
    let task: Task
    let taskManager: TaskManager
    @State private var showingDetail = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(task.title)
                    .font(.headline)
                    .lineLimit(2)
                Spacer()
                Menu {
                    Button("Edit") {
                        showingDetail = true
                    }
                    Button("Delete", role: .destructive) {
                        taskManager.deleteTask(task)
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.gray)
                }
            }
            
            if !task.description.isEmpty {
                Text(task.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
            
            HStack {
                Text(task.createdAt, style: .date)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Spacer()
                if task.priority > 0 {
                    HStack(spacing: 2) {
                        ForEach(0..<min(task.priority, 3), id: \.self) { _ in
                            Image(systemName: "exclamationmark")
                                .font(.caption2)
                                .foregroundColor(.red)
                        }
                    }
                }
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        .sheet(isPresented: $showingDetail) {
            TaskDetailView(task: task, taskManager: taskManager)
        }
    }
}

struct DropViewDelegate: DropDelegate {
    let task: Task?
    let targetStatus: TaskStatus
    let taskManager: TaskManager
    @Binding var draggedTask: Task?
    
    func performDrop(info: DropInfo) -> Bool {
        guard let draggedTask = draggedTask else { return false }
        
        if draggedTask.status != targetStatus {
            taskManager.moveTask(draggedTask, to: targetStatus)
        }
        
        self.draggedTask = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        // Optional: Add visual feedback when dragging over a column
    }
    
    func dropExited(info: DropInfo) {
        // Optional: Remove visual feedback when leaving a column
    }
}

#Preview {
    KanbanBoardView(taskManager: TaskManager())
} 