import SwiftUI

struct SourceDetailView: View {
    let source: SourceMetadata
    let quotes: [Quote]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header info - no card, just text
                VStack(alignment: .leading, spacing: 8) {
                    Text(source.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 12) {
                        Text("by \(source.author)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        if let date = source.date {
                            Text("·")
                                .foregroundColor(.secondary)
                            Text(formatDate(date))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Text("·")
                            .foregroundColor(.secondary)
                        Text("\(quotes.count) quotes")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                Divider()
                
                // All quotes in cards
                VStack(spacing: 16) {
                    ForEach(quotes) { quote in
                        QuoteDetailCard(quote: quote, isHero: false)
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    NavigationView {
        SourceDetailView(
            source: allSources[0],
            quotes: QuoteSelector().getAllQuotes(for: allSources[0].id)
        )
    }
}
