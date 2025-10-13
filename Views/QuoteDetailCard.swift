//
//  QuoteDetailCard.swift
//  DailyQuoteWidget
//
//  Created by Augustė Rulienė on 13/10/2025.
//

// Individual quote card with full details

import SwiftUI

struct QuoteDetailCard: View {
    let quote: Quote
    let isHero: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Quote text
            Text(quote.text)
                .font(isHero ? .title3 : .body)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            // Author and Source combined
            HStack(spacing: 4) {
                Text("—")
                Text(quote.author)
                    .fontWeight(.semibold)
                    .italic()
                if let source = quote.source {
                    Text("·")
                    Text(source)
                        .italic()
                }
            }
            .font(isHero ? .caption : .caption2)
            .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(isHero ? Color(.systemBackground) : Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: isHero ? .black.opacity(0.1) : .clear, radius: 8, x: 0, y: 2)
    }
}
