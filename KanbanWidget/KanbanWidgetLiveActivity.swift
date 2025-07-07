//
//  KanbanWidgetLiveActivity.swift
//  KanbanWidget
//
//  Created by 荻野善祥 on 2025/07/05.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct KanbanWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct KanbanWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: KanbanWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension KanbanWidgetAttributes {
    fileprivate static var preview: KanbanWidgetAttributes {
        KanbanWidgetAttributes(name: "World")
    }
}

extension KanbanWidgetAttributes.ContentState {
    fileprivate static var smiley: KanbanWidgetAttributes.ContentState {
        KanbanWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: KanbanWidgetAttributes.ContentState {
         KanbanWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: KanbanWidgetAttributes.preview) {
   KanbanWidgetLiveActivity()
} contentStates: {
    KanbanWidgetAttributes.ContentState.smiley
    KanbanWidgetAttributes.ContentState.starEyes
}
