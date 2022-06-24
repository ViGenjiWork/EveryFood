//
//  Sequence+Extension.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 02.06.2022.
//

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}

