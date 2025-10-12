//
//  QuoteParser.swift
//  DailyQuoteWidget
//
//  Created by Augustė Rulienė on 12/10/2025.
//

import Foundation

class QuoteParser {
    
    // Parse a markdown file into quotes
    static func parseQuotes(from fileName: String, sourceId: UUID) -> [Quote] {  // ✅ Changed parameter name
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "md"),
              let content = try? String(contentsOf: fileURL, encoding: .utf8) else {
            print("Error: Could not load \(fileName).md")
            return []
        }
        
        return parseMarkdownContent(content, sourceId: sourceId)  // ✅ Changed parameter name
    }
    
    private static func parseMarkdownContent(_ content: String, sourceId: UUID) -> [Quote] {  // ✅ Changed parameter name
        let lines = content.components(separatedBy: .newlines)
        var quotes: [Quote] = []
        var author = ""
        var sourceTitle = ""  // ✅ Changed from bookTitle
        
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            
            // Extract author from metadata
            if trimmed.hasPrefix("**Author:**") {
                author = trimmed
                    .replacingOccurrences(of: "**Author:**", with: "")
                    .trimmingCharacters(in: .whitespaces)
            }
            
            // Extract title
            if trimmed.hasPrefix("# ") {
                sourceTitle = trimmed  // ✅ Changed variable name
                    .replacingOccurrences(of: "# ", with: "")
                    .trimmingCharacters(in: .whitespaces)
            }
            
            // Parse bullet points as quotes
            if trimmed.hasPrefix("- ") {
                let quoteText = trimmed
                    .replacingOccurrences(of: "- ", with: "")
                    .trimmingCharacters(in: .whitespaces)
                
                // Skip empty quotes
                if !quoteText.isEmpty {
                    quotes.append(Quote(
                        id: UUID(),
                        text: quoteText,
                        author: author,
                        source: sourceTitle,  // ✅ Changed variable name
                        sourceId: sourceId  // ✅ Changed parameter name
                    ))
                }
            }
        }
        
        return quotes
    }
    
    // Load all quotes from all sources
    static func loadAllQuotes() -> [UUID: [Quote]] {
        var quotesBySource: [UUID: [Quote]] = [:]  // ✅ Changed variable name
        
        for source in allSources {  // ✅ Changed from allBooks
            let quotes = parseQuotes(from: source.fileName, sourceId: source.id)  // ✅ Changed parameter name
            quotesBySource[source.id] = quotes
            print("Loaded \(quotes.count) quotes from \(source.title)")
        }
        
        return quotesBySource
    }
}
