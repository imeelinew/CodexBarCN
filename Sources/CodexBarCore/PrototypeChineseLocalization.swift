import Foundation

public enum PrototypeChineseLocalization {
    public static let isEnabled = true

    private static let directMap: [String: String] = [
        "Overview": "总览",
        "Session": "会话",
        "Weekly": "每周",
        "Designs": "设计",
        "Daily Routines": "日常流程",
        "Code review": "代码审查",
        "Refresh": "刷新",
        "Settings...": "设置...",
        "About CodexBar": "关于 CodexBar",
        "Quit": "退出",
        "Account": "账号",
        "Plan": "套餐",
        "Usage Dashboard": "用量面板",
        "Status Page": "状态页面",
        "No usage yet": "暂无用量",
        "No usage configured.": "尚未配置用量",
        "Refreshing...": "刷新中...",
        "Not fetched yet": "尚未获取",
        "Cost": "成本",
        "Quota": "配额",
        "left": "剩余",
        "used": "已用",
        "Update ready, restart now?": "更新已就绪，立即重启？",
        "Add Account...": "添加账号...",
        "Switch Account...": "切换账号...",
        "On pace": "进度正常",
        "Lasts until reset": "可撑到重置",
        "Runs out now": "现在耗尽",
    ]

    private static let planMap: [String: String] = [
        "free": "免费版",
        "plus": "Plus",
        "pro": "Pro",
        "max": "Max",
        "team": "团队版",
        "enterprise": "企业版",
    ]

    public static func text(_ text: String) -> String {
        guard self.isEnabled else { return text }
        return self.directMap[text] ?? text
    }

    public static func labelValue(_ label: String, value: String) -> String {
        "\(self.text(label))：\(value)"
    }

    public static func percentLabel(_ percent: Double, showUsed: Bool) -> String {
        String(format: "%.0f%% %@", percent, self.text(showUsed ? "used" : "left"))
    }

    public static func accessibilityUsageLabel(showUsed: Bool) -> String {
        showUsed ? "已用用量" : "剩余用量"
    }

    public static func providerCostAccessibilityLabel() -> String {
        "额外用量消耗"
    }

    public static func paceDeficit(_ percent: Int) -> String {
        "超支 \(percent)%"
    }

    public static func paceReserve(_ percent: Int) -> String {
        "预留 \(percent)%"
    }

    public static func runOutIn(_ text: String) -> String {
        "预计 \(text) 后耗尽"
    }

    public static func runOutRisk(_ percent: Int) -> String {
        "约 \(percent)% 耗尽风险"
    }

    public static func planName(_ text: String) -> String {
        guard self.isEnabled else { return text }
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return text }
        return self.planMap[trimmed.lowercased()] ?? trimmed
    }
}
