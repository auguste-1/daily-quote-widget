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
                            // ✅ Wrap in NavigationLink
                            NavigationLink(destination: SourceDetailView(
                                source: item.source,
                                quotes: selector.getAllQuotes(for: item.source.id)
                            )) {
                                VStack(alignment: .leading, spacing: 8) {
                                    // Quote card
                                    QuoteDetailCard(quote: item.quote, isHero: false)
                                }
                                .padding(.horizontal)
                            }
                            .buttonStyle(PlainButtonStyle())  // ✅ Keeps card styling
                        }
                    }
                }
                .padding(.bottom)
            }
            .navigationTitle("Food for Thought")
        }
    }
}

#Preview {
    ContentView()
}
