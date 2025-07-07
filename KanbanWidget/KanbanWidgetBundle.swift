//
//  KanbanWidgetBundle.swift
//  KanbanWidget
//
//  Created by 荻野善祥 on 2025/07/05.
//

import WidgetKit
import SwiftUI

@main
struct KanbanWidgetBundle: WidgetBundle {
    var body: some Widget {
        KanbanWidget()
        KanbanWidgetControl()
        KanbanWidgetLiveActivity()
    }
}
