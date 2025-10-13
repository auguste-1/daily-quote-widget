//
//  QuoteSelector.swift
//  DailyQuoteWidget
//
//  Created by Augustė Rulienė on 12/10/2025.
//

import Foundation

class QuoteSelector {
    private let quotesBySource: [UUID: [Quote]]
    
    init() {
        self.quotesBySource = QuoteParser.loadAllQuotes()
    }
    
    // Get quote of the day for a specific source
    func getQuoteOfTheDay(for sourceId: UUID, date: Date = Date()) -> Quote? {
        guard let sourceQuotes = quotesBySource[sourceId], !sourceQuotes.isEmpty else {
            return nil
        }
        
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: date) ?? 1
        let index = dayOfYear % sourceQuotes.count
        return sourceQuotes[index]
    }
    
    // Get the global quote of the day (widget quote)
    func getGlobalQuoteOfTheDay(date: Date = Date()) -> Quote? {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: date) ?? 1
        let sourceIndex = dayOfYear % allSources.count
        let winningSource = allSources[sourceIndex]
        
        return getQuoteOfTheDay(for: winningSource.id, date: date)
    }
    
    // Get all daily quotes (one per source)
    func getAllDailyQuotes(date: Date = Date()) -> [(source: SourceMetadata, quote: Quote)] {
        var results: [(SourceMetadata, Quote)] = []
        
        for source in allSources {
            if let quote = getQuoteOfTheDay(for: source.id, date: date) {
                results.append((source, quote))
            }
        }
        
        return results
    }
    
    // Get all quotes from a specific source (in order)
    func getAllQuotes(for sourceId: UUID) -> [Quote] {
        return quotesBySource[sourceId] ?? []
    }
}  // ✅ Class ends here, not before!
