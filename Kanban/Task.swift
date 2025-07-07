import Foundation
import EventKit

enum TaskStatus: String, CaseIterable, Codable {
    case todo = "To Do"
    case inProgress = "In Progress"
    case done = "Done"
    
    var icon: String {
        switch self {
        case .todo: return "circle"
        case .inProgress: return "clock"
        case .done: return "checkmark.circle.fill"
        }
    }
    
    var color: String {
        switch self {
        case .todo: return "blue"
        case .inProgress: return "orange"
        case .done: return "green"
        }
    }
}

struct Task: Identifiable, Codable {
    let id = UUID()
    var title: String
    var description: String
    var status: TaskStatus
    var createdAt: Date
    var reminderID: String?
    var priority: Int = 0
    
    init(title: String, description: String = "", status: TaskStatus = .todo) {
        self.title = title
        self.description = description
        self.status = status
        self.createdAt = Date()
    }
}

class TaskManager: ObservableObject {
    @Published var tasks: [Task] = []
    private let eventStore = EKEventStore()
    
    init() {
        loadTasks()
        requestRemindersPermission()
    }
    
    func addTask(_ task: Task) {
        tasks.append(task)
        saveTasks()
        createReminder(for: task)
    }
    
    func updateTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
            saveTasks()
            updateReminder(for: task)
        }
    }
    
    func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
        saveTasks()
        deleteReminder(for: task)
    }
    
    func moveTask(_ task: Task, to status: TaskStatus) {
        var updatedTask = task
        updatedTask.status = status
        updateTask(updatedTask)
    }
    
    private func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "kanban_tasks")
            // Also save to App Group for widget access
            UserDefaults(suiteName: "group.com.kanban.app")?.set(encoded, forKey: "kanban_tasks")
        }
    }
    
    private func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: "kanban_tasks"),
           let decoded = try? JSONDecoder().decode([Task].self, from: data) {
            tasks = decoded
        }
    }
    
    // MARK: - Reminders Integration
    
    private func requestRemindersPermission() {
        switch EKEventStore.authorizationStatus(for: .reminder) {
        case .notDetermined:
            eventStore.requestAccess(to: .reminder) { granted, error in
                DispatchQueue.main.async {
                    if granted {
                        print("Reminders access granted")
                    } else {
                        print("Reminders access denied: \(error?.localizedDescription ?? "")")
                    }
                }
            }
        case .authorized:
            print("Reminders access already granted")
        case .denied, .restricted:
            print("Reminders access denied or restricted")
        @unknown default:
            print("Unknown authorization status")
        }
    }
    
    private func createReminder(for task: Task) {
        guard EKEventStore.authorizationStatus(for: .reminder) == .authorized else { return }
        
        let reminder = EKReminder(eventStore: eventStore)
        reminder.title = task.title
        reminder.notes = task.description
        reminder.calendar = eventStore.defaultCalendarForNewReminders()
        reminder.priority = task.priority
        
        do {
            try eventStore.save(reminder, commit: true)
            var updatedTask = task
            updatedTask.reminderID = reminder.calendarItemIdentifier
            updateTask(updatedTask)
        } catch {
            print("Failed to create reminder: \(error)")
        }
    }
    
    private func updateReminder(for task: Task) {
        guard let reminderID = task.reminderID,
              let reminder = eventStore.calendarItem(withIdentifier: reminderID) as? EKReminder else { return }
        
        reminder.title = task.title
        reminder.notes = task.description
        reminder.priority = task.priority
        
        do {
            try eventStore.save(reminder, commit: true)
        } catch {
            print("Failed to update reminder: \(error)")
        }
    }
    
    private func deleteReminder(for task: Task) {
        guard let reminderID = task.reminderID,
              let reminder = eventStore.calendarItem(withIdentifier: reminderID) as? EKReminder else { return }
        
        do {
            try eventStore.remove(reminder, commit: true)
        } catch {
            print("Failed to delete reminder: \(error)")
        }
    }
} 