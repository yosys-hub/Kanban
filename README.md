# 🗂️ KanbanWidget

A minimalist Kanban board iOS/iPadOS app with interactive widget support and native iOS Reminders integration.  
Because dragging cards around on your iPad is somehow more fulfilling than dealing with your actual responsibilities.

---

## ✨ Features

- 🪄 **Drag & Drop Kanban Board**
  - Organize tasks into `To Do`, `In Progress`, and `Done` columns
  - Smooth SwiftUI-based drag-and-drop interface

- 📱 **Interactive Widget (iPadOS 17+)**
  - View task summaries directly from the home screen
  - Tap to cycle task statuses without opening the app

- ⏰ **iOS Reminders Integration**
  - Create and sync tasks with Apple Reminders
  - Automatically update reminder status when tasks change in-app

---

## 🛠️ Technologies

- SwiftUI + WidgetKit
- EventKit (Reminders API)
- App Group for data sharing
- AppIntent for widget interactions

---

## 🚀 Getting Started

1. Clone the repo (if you're reading this, congrats, you already did)
2. Open `KanbanWidget.xcodeproj`
3. Set up your App Group ID in both app and widget targets
4. Add `NSRemindersUsageDescription` to your Info.plist
5. Run it on a real device because the widget won't work in the simulator 🙃

---

## 🧠 Notes

- Widgets don't support drag-and-drop (thanks, Apple), so status changes are tap-only
- EventKit requires permission; you'll get a pop-up. Don't ignore it like all your other alerts.

---

## 📜 License

MIT – because even half-baked personal productivity ideas should be free.
