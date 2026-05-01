import Foundation

public enum PrototypeChineseLocalization {
    public static let isEnabled = true

    private static let directMap: [String: String] = [
        "Overview": "总览",
        "General": "通用",
        "Providers": "提供方",
        "Display": "显示",
        "Advanced": "高级",
        "About": "关于",
        "Debug": "调试",
        "Session": "会话",
        "Weekly": "每周",
        "Designs": "设计",
        "Daily Routines": "日常流程",
        "Code review": "代码审查",
        "Refresh": "刷新",
        "Settings...": "设置...",
        "About CodexBar": "关于 CodexBar",
        "Quit": "退出",
        "Quit CodexBar": "退出 CodexBar",
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
        "System": "系统",
        "Usage": "用量",
        "Automation": "自动化",
        "Menu bar": "菜单栏",
        "Menu content": "菜单内容",
        "Keyboard shortcut": "键盘快捷键",
        "Open menu": "打开菜单",
        "Install CLI": "安装 CLI",
        "Show Debug Settings": "显示调试设置",
        "Surprise me": "来点惊喜",
        "Weekly limit confetti": "每周重置彩带",
        "Hide personal information": "隐藏个人信息",
        "Keychain access": "钥匙串访问",
        "Disable Keychain access": "禁用钥匙串访问",
        "Start at Login": "登录时启动",
        "Show cost summary": "显示成本汇总",
        "Refresh cadence": "刷新频率",
        "Check provider status": "检查提供方状态",
        "Session quota notifications": "会话配额通知",
        "Merge Icons": "合并图标",
        "Switcher shows icons": "切换器显示图标",
        "Show most-used provider": "显示使用最多的提供方",
        "Menu bar shows percent": "菜单栏显示百分比",
        "Display mode": "显示模式",
        "Show usage as used": "按已用量显示",
        "Show reset time as clock": "按时钟显示重置时间",
        "Show credits + extra usage": "显示积分和额外用量",
        "Show all token accounts": "显示所有令牌账号",
        "Overview tab providers": "总览页提供方",
        "Configure…": "配置…",
        "No providers selected": "未选择任何提供方",
        "Use a single menu bar icon with a provider switcher.": "使用单个菜单栏图标，并通过切换器切换提供方。",
        "Show provider icons in the switcher (otherwise show a weekly progress line).": "在切换器中显示提供方图标（否则显示每周进度线）。",
        "Menu bar auto-shows the provider closest to its rate limit.": "菜单栏自动显示最接近限额的提供方。",
        "Replace critter bars with provider branding icons and a percentage.": "用提供方品牌图标和百分比替代小条形图。",
        "Choose what to show in the menu bar (Pace shows usage vs. expected).": "选择菜单栏显示内容（进度表示实际用量与预期用量的对比）。",
        "Progress bars fill as you consume quota (instead of showing remaining).": "进度条会随着配额消耗而填充（而不是显示剩余量）。",
        "Display reset times as absolute clock values instead of countdowns.": "将重置时间显示为具体时刻，而不是倒计时。",
        "Show Codex Credits and Claude Extra usage sections in the menu.": "在菜单中显示 Codex 积分和 Claude 额外用量分区。",
        "Stack token accounts in the menu (otherwise show an account switcher bar).": "在菜单中堆叠显示令牌账号（否则显示账号切换栏）。",
        "Enable Merge Icons to configure Overview tab providers.": "启用“合并图标”后才能配置总览页提供方。",
        "No enabled providers available for Overview.": "当前没有可用于总览的已启用提供方。",
        "Trigger the menu bar menu from anywhere.": "可在任意位置呼出菜单栏菜单。",
        "Symlink CodexBarCLI to /usr/local/bin and /opt/homebrew/bin as codexbar.": "将 CodexBarCLI 软链接到 /usr/local/bin 和 /opt/homebrew/bin，命令名为 codexbar。",
        "Expose troubleshooting tools in the Debug tab.": "在调试标签页中显示排障工具。",
        "Check if you like your agents having some fun up there.": "看看你是否喜欢让这些 agent 在上面玩点花样。",
        "Play full-screen confetti when weekly usage resets.": "每周用量重置时播放全屏彩带效果。",
        "Obscure email addresses in the menu bar and menu UI.": "隐藏菜单栏和菜单界面中的邮箱地址。",
        "Disable all Keychain reads and writes. Browser cookie import is unavailable; paste Cookie headers manually in Providers.": "禁用所有钥匙串读写。浏览器 Cookie 导入将不可用；请在 Providers 中手动粘贴 Cookie Header。",
        "Prevents any Keychain access while enabled.": "启用后将阻止任何钥匙串访问。",
        "May your tokens never run out—keep agent limits in view.": "愿你的令牌永不耗尽，让 agent 限额始终尽在眼前。",
        "GitHub": "GitHub",
        "Website": "网站",
        "Twitter": "Twitter",
        "Email": "邮箱",
        "Check for updates automatically": "自动检查更新",
        "Update Channel": "更新通道",
        "Check for Updates…": "检查更新…",
        "Updates unavailable in this build.": "此构建版本不支持更新。",
        "Stable": "稳定版",
        "Beta": "测试版",
        "Percent": "百分比",
        "Pace": "进度",
        "Both": "两者都显示",
        "Choose Codex workspace": "选择 Codex 工作区",
        "Add Workspace": "添加工作区",
        "Cancel": "取消",
        "Keychain Access Required": "需要钥匙串访问权限",
        "OK": "好",
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

    public static func chooseUpToProviders(_ count: Int) -> String {
        "最多选择 \(count) 个提供方"
    }

    public static func overviewOrderHint() -> String {
        "总览中的排列顺序始终跟随提供方顺序。"
    }

    public static func version(_ text: String) -> String {
        "版本 \(text)"
    }

    public static func built(_ text: String) -> String {
        "构建于 \(text)"
    }

    public static func noUsageLogsSummary() -> String {
        "读取本地用量日志，在菜单中显示今天和最近 30 天的成本。"
    }

    public static func autoRefreshHourlyTimeout() -> String {
        "自动刷新：每小时 · 超时：10 分钟"
    }

    public static func refreshCadenceHint() -> String {
        "CodexBar 在后台轮询提供方的频率。"
    }

    public static func autoRefreshOffHint() -> String {
        "自动刷新已关闭；请使用菜单里的“刷新”命令。"
    }

    public static func installed(_ dir: String) -> String {
        "已安装：\(dir)"
    }

    public static func exists(_ dir: String) -> String {
        "已存在：\(dir)"
    }

    public static func noWriteAccess(_ dir: String) -> String {
        "无写入权限：\(dir)"
    }

    public static func failed(_ dir: String) -> String {
        "失败：\(dir)"
    }

    public static func noWritableBinDirs() -> String {
        "未找到可写入的 bin 目录。"
    }

    public static func cliNotFound() -> String {
        "未在 app 包中找到 CodexBarCLI。"
    }

    public static func startAtLoginHint() -> String {
        "在 Mac 启动时自动打开 CodexBar。"
    }

    public static func providerUnsupported(_ name: String) -> String {
        "\(name)：不支持"
    }

    public static func providerFetching(_ name: String, elapsed: String) -> String {
        "\(name)：获取中…\(elapsed)"
    }

    public static func providerUpdatedCost(_ name: String, updated: String, cost: String) -> String {
        "\(name)：\(updated) · 30天 \(cost)"
    }

    public static func providerError(_ name: String, error: String) -> String {
        "\(name)：\(error)"
    }

    public static func providerLastAttempt(_ name: String, when: String) -> String {
        "\(name)：上次尝试于 \(when)"
    }

    public static func providerNoData(_ name: String) -> String {
        "\(name)：暂无数据"
    }

    public static func percentDescription() -> String {
        "显示剩余/已用百分比（例如 45%）"
    }

    public static func paceDescription() -> String {
        "显示进度指标（例如 +5%）"
    }

    public static func bothDescription() -> String {
        "同时显示百分比和进度（例如 45% · +5%）"
    }

    public static func stableDescription() -> String {
        "仅接收稳定、可正式使用的版本。"
    }

    public static func betaDescription() -> String {
        "接收稳定版本以及测试预览版。"
    }

    public static func workspacePrompt(_ email: String) -> String {
        "CodexBar 发现 \(email) 对应多个工作区。请选择要添加的那一个。"
    }

    public static func browserCookiePrompt(_ label: String) -> String {
        "CodexBar 将向 macOS 钥匙串请求“\(label)”以解密浏览器 Cookie 并验证你的账号。点击“好”继续。"
    }

    public static func keychainPrompt(_ message: String) -> String {
        message
    }

    public static func planName(_ text: String) -> String {
        guard self.isEnabled else { return text }
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return text }
        return self.planMap[trimmed.lowercased()] ?? trimmed
    }
}
