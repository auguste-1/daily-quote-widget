import Foundation

class QuoteParser {
    
    // Parse a markdown file into quotes
    static func parseQuotes(from fileName: String, sourceId: UUID) -> [Quote] {
        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "md"),
              let content = try? String(contentsOf: fileURL, encoding: .utf8) else {
            print("Error: Could not load \(fileName).md")
            return []
        }
        
        return parseMarkdownContent(content, sourceId: sourceId)
    }
    
    private static func parseMarkdownContent(_ content: String, sourceId: UUID) -> [Quote] {
        let lines = content.components(separatedBy: .newlines)
        var quotes: [Quote] = []
        var defaultAuthor = ""
        var sourceTitle = ""
        var sourceType = ""
        
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            
            // Extract default author from metadata
            if trimmed.hasPrefix("**Author:**") || trimmed.hasPrefix("****Author:****") {
                defaultAuthor = trimmed
                    .replacingOccurrences(of: "****Author:****", with: "")
                    .replacingOccurrences(of: "**Author:**", with: "")
                    .trimmingCharacters(in: .whitespaces)
            }
            
            // Extract type
            if trimmed.hasPrefix("**Type:**") || trimmed.hasPrefix("****Type:****") {
                sourceType = trimmed
                    .replacingOccurrences(of: "****Type:****", with: "")
                    .replacingOccurrences(of: "**Type:**", with: "")
                    .trimmingCharacters(in: .whitespaces)
            }
            
            // Extract title
            if trimmed.hasPrefix("# ") && sourceTitle.isEmpty {
                sourceTitle = trimmed.replacingOccurrences(of: "# ", with: "")
            }
            
            // Parse blockquotes as quotes
            if trimmed.hasPrefix(">") {
                let quoteContent = trimmed
                    .replacingOccurrences(of: ">", with: "")
                    .trimmingCharacters(in: .whitespaces)
                
                // Skip empty quotes
                guard !quoteContent.isEmpty else { continue }
                
                // Check if this is a "quotes" type with inline citation
                if sourceType.lowercased() == "quotes" {
                    // Parse: "Text" – Author, Source, Location
                    if let parsedQuote = parseInlineCitation(quoteContent, defaultSource: sourceTitle, sourceId: sourceId) {
                        quotes.append(parsedQuote)
                    }
                } else {
                    // Regular quote without inline citation
                    quotes.append(Quote(
                        id: UUID(),
                        text: quoteContent,
                        author: defaultAuthor,
                        source: sourceTitle,
                        sourceId: sourceId,
                        location: nil
                    ))
                }
            }
        }
        
        return quotes
    }
    
    // Parse inline citation format: "Text" – Author, Source, Location
    private static func parseInlineCitation(_ text: String, defaultSource: String, sourceId: UUID) -> Quote? {
        // Look for em dash or regular dash separating quote from citation
        let separators = ["–", "—", " - "]
        
        for separator in separators {
            if let range = text.range(of: separator) {
                let quoteText = String(text[..<range.lowerBound])
                    .trimmingCharacters(in: .whitespaces)
                    .trimmingCharacters(in: CharacterSet(charactersIn: "\"'"))  // Just straight quotes

                let citation = String(text[range.upperBound...])
                    .trimmingCharacters(in: .whitespaces)
                
                // Parse citation: "Author, Source, MetaInfo"
                let parts = citation.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                
                let author = parts.first ?? ""
                let source = parts.count > 1 ? parts[1] : defaultSource
                let location = parts.count > 2 ? parts[2] : nil
                
                return Quote(
                    id: UUID(),
                    text: quoteText,
                    author: author,
                    source: source,
                    sourceId: sourceId,
                    location: location
                )
            }
        }
        
        // If no separator found, return as-is with default author
        return nil
    }
    
    // Load all quotes from all sources
    static func loadAllQuotes() -> [UUID: [Quote]] {
        var quotesBySource: [UUID: [Quote]] = [:]
        
        for source in allSources {
            let quotes = parseQuotes(from: source.fileName, sourceId: source.id)
            quotesBySource[source.id] = quotes
            print("Loaded \(quotes.count) quotes from \(source.title)")
        }
        
        return quotesBySource
    }
}
