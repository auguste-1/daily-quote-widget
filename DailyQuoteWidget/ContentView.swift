import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List(quotes.indices, id: \.self) { index in
                QuoteDetailCard(quote: quotes[index])
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            }
            .listStyle(.plain)
            .navigationTitle("Daily Quotes")
        }
    }
}

// Individual quote card with full details
struct QuoteDetailCard: View {
    let quote: Quote
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Quote text
            Text(quote.text)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            // Author
            Text("— \(quote.author)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            // Source (if exists)
            if let source = quote.source {
                Text(source)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .italic()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

#Preview {
    ContentView()
}
