import SwiftUI

struct ContentView: View {
    let selector = QuoteSelector()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Quote of the Day (Global Winner)
                    if let globalQuote = selector.getGlobalQuoteOfTheDay() {
                        // Find the source to get its type
                        let sourceType = allSources.first(where: { $0.id == globalQuote.sourceId })?.type
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Quote of the Day")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .textCase(.uppercase)
                                .tracking(1)
                            
                            Text(globalQuote.text)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                                .lineSpacing(4)
                            
                            HStack(spacing: 4) {
                                Text("—")
                                Text(globalQuote.author)
                                    .fontWeight(.semibold)
                                    .italic()
                                
                                // Only show source if NOT quotes type
                                if let source = globalQuote.source, sourceType?.lowercased() != "quotes" {
                                    Text("·")
                                    Text(source)
                                        .italic()
                                }
                                
                                if let location = globalQuote.location {
                                    Text("·")
                                    Text(location)
                                        .italic()
                                }
                            }
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        }
                        .padding()
                        .padding(.vertical, 8)
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
                            NavigationLink(destination: SourceDetailView(
                                source: item.source,
                                quotes: selector.getAllQuotes(for: item.source.id)
                            )) {
                                VStack(alignment: .leading, spacing: 8) {
                                    QuoteDetailCard(quote: item.quote, isHero: false, sourceType: item.source.type)
                                }
                                .padding(.horizontal)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .padding(.bottom)
            }
            .navigationTitle("Inspiration of the Day")
        }
    }
}

#Preview {
    ContentView()
}
