import SwiftUI

struct AddTaskView: View {
    let taskManager: TaskManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var description = ""
    @State private var status: TaskStatus = .todo
    @State private var priority = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section("Task Details") {
                    TextField("Task Title", text: $title)
                    
                    TextField("Description (Optional)", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Status") {
                    Picker("Status", selection: $status) {
                        ForEach(TaskStatus.allCases, id: \.self) { status in
                            HStack {
                                Image(systemName: status.icon)
                                    .foregroundColor(Color(status.color))
                                Text(status.rawValue)
                            }
                            .tag(status)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Priority") {
                    HStack {
                        Text("Priority Level")
                        Spacer()
                        HStack(spacing: 4) {
                            ForEach(1...3, id: \.self) { level in
                                Button(action: {
                                    priority = priority == level ? 0 : level
                                }) {
                                    Image(systemName: level <= priority ? "exclamationmark.fill" : "exclamationmark")
                                        .foregroundColor(level <= priority ? .red : .gray)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        addTask()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func addTask() {
        let task = Task(title: title, description: description, status: status)
        var newTask = task
        newTask.priority = priority
        taskManager.addTask(newTask)
        dismiss()
    }
}

struct TaskDetailView: View {
    let task: Task
    let taskManager: TaskManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String
    @State private var description: String
    @State private var status: TaskStatus
    @State private var priority: Int
    
    init(task: Task, taskManager: TaskManager) {
        self.task = task
        self.taskManager = taskManager
        self._title = State(initialValue: task.title)
        self._description = State(initialValue: task.description)
        self._status = State(initialValue: task.status)
        self._priority = State(initialValue: task.priority)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Task Details") {
                    TextField("Task Title", text: $title)
                    
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Status") {
                    Picker("Status", selection: $status) {
                        ForEach(TaskStatus.allCases, id: \.self) { status in
                            HStack {
                                Image(systemName: status.icon)
                                    .foregroundColor(Color(status.color))
                                Text(status.rawValue)
                            }
                            .tag(status)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Priority") {
                    HStack {
                        Text("Priority Level")
                        Spacer()
                        HStack(spacing: 4) {
                            ForEach(1...3, id: \.self) { level in
                                Button(action: {
                                    priority = priority == level ? 0 : level
                                }) {
                                    Image(systemName: level <= priority ? "exclamationmark.fill" : "exclamationmark")
                                        .foregroundColor(level <= priority ? .red : .gray)
                                }
                            }
                        }
                    }
                }
                
                Section("Created") {
                    Text(task.createdAt, style: .date)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Edit Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveTask()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func saveTask() {
        var updatedTask = task
        updatedTask.title = title
        updatedTask.description = description
        updatedTask.status = status
        updatedTask.priority = priority
        
        taskManager.updateTask(updatedTask)
        dismiss()
    }
}

#Preview {
    AddTaskView(taskManager: TaskManager())
} 