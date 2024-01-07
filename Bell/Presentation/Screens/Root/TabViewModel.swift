//
//  TabViewModel.swift
//  Bell
//
//  Created by Yuki Okudera on 2024/01/07.
//

import Foundation

final class TabViewModel: ObservableObject {
    @Published private(set) var selectedTab: Tab = .repoSearch
    @Published private(set) var activeTabTapped: [Tab: Bool] = Tab.allCases.reduce(into: [Tab: Bool]()) { $0[$1] = false }

    func setSelectedTab(tag: Int) {
        if self.selectedTab.rawValue == tag {
            if let currentValue = self.activeTabTapped[self.selectedTab] {
                self.activeTabTapped[self.selectedTab] = !currentValue
            }
        } else {
            self.selectedTab = .init(tag: tag)
        }
    }
}
