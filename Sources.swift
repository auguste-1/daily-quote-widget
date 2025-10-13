//
//  Sources.swift
//  DailyQuoteWidget
//
//  Created by Augustė Rulienė on 12/10/2025.
//

import Foundation

struct SourceMetadata: Identifiable {
    let id: UUID
    let title: String
    let author: String
    let fileName: String
    let type: String
    let date: Date?
}

// Auto-load all sources from markdown files
let allSources: [SourceMetadata] = {
    var sources: [SourceMetadata] = []
    
    // Get all .md files from the bundle
    guard let fileURLs = Bundle.main.urls(forResourcesWithExtension: "md", subdirectory: nil) else {
        print("No markdown files found")
        return []
    }
    
    for fileURL in fileURLs {
        // Parse metadata from each file
        if let source = parseSourceMetadata(from: fileURL) {
            sources.append(source)
        }
    }
    
    print("Auto-detected \(sources.count) sources")
    return sources
}()

// Parse metadata from markdown file
private func parseSourceMetadata(from fileURL: URL) -> SourceMetadata? {
    
    print("Attempting to parse: \(fileURL.lastPathComponent)")
    
    guard let content = try? String(contentsOf: fileURL, encoding: .utf8) else {
        print("❌ Could not read file: \(fileURL.lastPathComponent)")
        return nil
    }
    
    print("✅ File read successfully, length: \(content.count)")
    
    
    guard let content = try? String(contentsOf: fileURL, encoding: .utf8) else {
        return nil
    }
    
    let lines = content.components(separatedBy: .newlines)
    var title = ""
    var author = ""
    var type = "Unknown"
    var date: Date?
    
    for line in lines {
        let trimmed = line.trimmingCharacters(in: .whitespaces)
        
        // Extract title (first # heading)
        if trimmed.hasPrefix("# ") && title.isEmpty {
            title = trimmed.replacingOccurrences(of: "# ", with: "")
        }
        
        // Extract author
        if trimmed.hasPrefix("**Author:**") {
            author = trimmed
                .replacingOccurrences(of: "**Author:**", with: "")
                .trimmingCharacters(in: .whitespaces)
        }
        
        // Extract type
        if trimmed.hasPrefix("**Type:**") {
            type = trimmed
                .replacingOccurrences(of: "**Type:**", with: "")
                .trimmingCharacters(in: .whitespaces)
        }
        
        // Extract date
        if trimmed.hasPrefix("**Date:**") {
            let dateString = trimmed
                .replacingOccurrences(of: "**Date:**", with: "")
                .trimmingCharacters(in: .whitespaces)
            
            // Parse date (format: YYYY-MM-DD)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            date = formatter.date(from: dateString)
        }
    }
    // Right before the guard !title.isEmpty check
    print("Parsed metadata - Title: '\(title)', Author: '\(author)', Type: '\(type)'")

    // Ensure we have at least title and author
    guard !title.isEmpty, !author.isEmpty else {
        print("❌ Skipping file - missing title or author: \(fileURL.lastPathComponent)")
        return nil
    }
    
    // Ensure we have at least title and author
    guard !title.isEmpty, !author.isEmpty else {
        print("Skipping file - missing title or author: \(fileURL.lastPathComponent)")
        return nil
    }
    
    // Get filename without extension
    let fileName = fileURL.deletingPathExtension().lastPathComponent
    
    // Generate consistent UUID from filename (so it's stable across runs)
    let uuid = UUID(uuidString: fileName.md5UUID()) ?? UUID()
    
    return SourceMetadata(
        id: uuid,
        title: title,
        author: author,
        fileName: fileName,
        type: type,
        date: date
    )
}

// Helper to generate consistent UUID from string
extension String {
    func md5UUID() -> String {
        // Simple hash-based UUID generation
        let hash = self.hash
        let uuidString = String(format: "%08x-0000-0000-0000-%012x",
                               abs(hash) % 0xFFFFFFFF,
                               abs(hash) % 0xFFFFFFFFFFFF)
        return uuidString
    }
}
