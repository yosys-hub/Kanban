import WidgetKit
import SwiftUI
import AppIntents

struct KanbanWidgetEntryView: View {
    var entry: KanbanWidgetEntry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "list.bullet.clipboard")
                    .foregroundColor(.blue)
                Text("Kanban Tasks")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            if entry.tasks.isEmpty {
                VStack {
                    Image(systemName: "plus.circle")
                        .font(.title2)
                        .foregroundColor(.gray)
                    Text("No tasks yet")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                LazyVStack(spacing: 6) {
                    ForEach(entry.tasks.prefix(family == .systemMedium ? 3 : 5)) { task in
                        TaskWidgetRow(task: task)
                    }
                }
            }
            
            Spacer()
            
            HStack {
                Text("\(entry.tasks.count) total tasks")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Spacer()
                Button(intent: CycleTaskStatusIntent()) {
                    Image(systemName: "arrow.clockwise")
                        .font(.caption)
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
    }
}

struct TaskWidgetRow: View {
    let task: Task
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: task.status.icon)
                .foregroundColor(Color(task.status.color))
                .font(.caption)
            
            Text(task.title)
                .font(.caption)
                .lineLimit(1)
            
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
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(6)
    }
}

struct KanbanWidget: Widget {
    let kind: String = "KanbanWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: KanbanWidgetProvider()) { entry in
            KanbanWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Kanban Tasks")
        .description("View and manage your Kanban tasks from the home screen.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

struct KanbanWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> KanbanWidgetEntry {
        KanbanWidgetEntry(date: Date(), tasks: [])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (KanbanWidgetEntry) -> ()) {
        let entry = KanbanWidgetEntry(date: Date(), tasks: loadTasks())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = KanbanWidgetEntry(date: Date(), tasks: loadTasks())
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
    
    private func loadTasks() -> [Task] {
        guard let data = UserDefaults(suiteName: "group.com.kanban.app")?.data(forKey: "kanban_tasks"),
              let tasks = try? JSONDecoder().decode([Task].self, from: data) else {
            return []
        }
        return tasks
    }
}

struct KanbanWidgetEntry: TimelineEntry {
    let date: Date
    let tasks: [Task]
}

// MARK: - App Intents

struct CycleTaskStatusIntent: AppIntent {
    static var title: LocalizedStringResource = "Cycle Task Status"
    static var description: LocalizedStringResource = "Cycle through task statuses"
    
    func perform() async throws -> some IntentResult {
        // This would cycle through task statuses
        // For now, we'll just refresh the widget
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}

#Preview(as: .systemMedium) {
    KanbanWidget()
} timeline: {
    KanbanWidgetEntry(date: .now, tasks: [
        Task(title: "Design UI", description: "Create wireframes", status: .todo),
        Task(title: "Implement API", description: "Backend integration", status: .inProgress),
        Task(title: "Test app", description: "QA testing", status: .done)
    ])
} 