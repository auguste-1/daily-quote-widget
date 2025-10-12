import SwiftUI

struct ContentView: View {
    let selector = QuoteSelector()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Quote of the Day (Global Winner)
                    if let globalQuote = selector.getGlobalQuoteOfTheDay() {
                        VStack(alignment: .leading, spacing: 12) {
    
                            QuoteDetailCard(quote: globalQuote, isHero: true)
                        }
                        .padding(.horizontal)
                        .padding(.top)
                    }
                    
                    // Divider
                    Divider()
                        .padding(.vertical, 8)
                    
                    // All Sources with Their Daily Quotes
                    VStack(alignment: .leading, spacing: 16) {
                        Text("From Your Notes")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                        
                        ForEach(selector.getAllDailyQuotes(), id: \.source.id) { item in
                            VStack(alignment: .leading, spacing: 8) {
                                                              
                                // Quote card
                                QuoteDetailCard(quote: item.quote, isHero: false)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.bottom)
            }
            .navigationTitle("Inspiration of the Day")
        }
    }
}

// Individual quote card with full details
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
                        .foregroundColor(.secondary)
                    Text(source)
                        .italic()
                }
            }
            .font(isHero ? .callout : .subheadline)
            .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(isHero ? Color(.systemBackground) : Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: isHero ? .black.opacity(0.1) : .clear, radius: 8, x: 0, y: 2)
    }
}

#Preview {
    ContentView()
}
