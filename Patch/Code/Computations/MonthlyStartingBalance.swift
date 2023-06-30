//
//  MonthlyStartingBalance.swift
//  Patch
//
//  Created by Nate Leake on 6/20/23.
//

import Foundation

@MainActor
class StartingBalanceStore: ObservableObject {
    @Published var balances: [MonthStartingBalance] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("balances.data")
    }
    
    func load() async throws {
        let task = Task<[MonthStartingBalance], Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return []
            }
            let monthBalances = try JSONDecoder().decode([MonthStartingBalance].self, from: data)
            return monthBalances
        }
        let balances = try await task.value
        self.balances = balances
    }
        
    func save(balances: [MonthStartingBalance]) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(balances)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        }
        _ = try await task.value
    }
    
    
}

struct MonthStartingBalance: Codable, Hashable {
    let month: Date
    var startingBalance: Int
    
    init(month: Date, startingBalance: Int) {
        self.month = month
        self.startingBalance = startingBalance
    }
}
