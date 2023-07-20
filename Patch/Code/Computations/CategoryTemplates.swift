//
//  CategoryTemplates.swift
//  Patch
//
//  Created by Nate Leake on 7/17/23.
//

import Foundation

@MainActor
class TemplatesStore: ObservableObject {
    @Published var templates: [Template] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("templates.data")
    }
    
    func load() async throws {
        let task = Task<[Template], Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return []
            }
            let monthTemplates = try JSONDecoder().decode([Template].self, from: data)
            return monthTemplates
        }
        var templates = try await task.value
        
        if templates.isEmpty {
            templates.append(Template(name: "Untitled"))
        }
        
        self.templates = templates
    }
    
    func save(templates: [Template]) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(templates)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        }
        _ = try await task.value
    }
    
    
}

struct Template: Codable, Hashable {
    var id: UUID
    var name: String
    var categories: [TemplateCategory]
    
    init(name:String, categories: [TemplateCategory] = []) {
        self.id = UUID()
        self.name = name
        self.categories = categories
    }
}

struct TemplateCategory: Codable, Hashable, Identifiable{
    var id: UUID
    var name: String
    var type: String
    var limit: Int
    var symbol: String
    
    init(name: String, type: String, limit: Int, symbol: String) {
        self.id = UUID()
        self.name = name
        self.type = type
        self.limit = limit
        self.symbol = symbol
    }
}
