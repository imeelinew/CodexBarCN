import CodexBarCore
import Foundation

/// Controls what the menu bar displays when brand icon mode is enabled.
enum MenuBarDisplayMode: String, CaseIterable, Identifiable {
    case percent
    case pace
    case both

    var id: String {
        self.rawValue
    }

    var label: String {
        switch self {
        case .percent: PrototypeChineseLocalization.text("Percent")
        case .pace: PrototypeChineseLocalization.text("Pace")
        case .both: PrototypeChineseLocalization.text("Both")
        }
    }

    var description: String {
        switch self {
        case .percent: PrototypeChineseLocalization.percentDescription()
        case .pace: PrototypeChineseLocalization.paceDescription()
        case .both: PrototypeChineseLocalization.bothDescription()
        }
    }
}
