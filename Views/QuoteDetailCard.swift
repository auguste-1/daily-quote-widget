import SwiftUI

struct QuoteDetailCard: View {
    let quote: Quote
    let isHero: Bool
    let sourceType: String?  // ✅ Added to know if it's "quotes" type
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Quote text
            Text(quote.text)
                .font(isHero ? .title3 : .body)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            // Author, Source, and Location
            HStack(spacing: 4) {
                Text("—")
                Text(quote.author)
                    .fontWeight(.semibold)
                    .italic()
                
                // Only show source if NOT a "quotes" type
                if let source = quote.source, sourceType?.lowercased() != "quotes" {
                    Text("·")
                    Text(source)
                        .italic()
                }
                
                if let location = quote.location {
                    Text("·")
                    Text(location)
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

#Preview {
    QuoteDetailCard(
        quote: Quote(
            id: UUID(),
            text: "This is a preview quote",
            author: "Preview Author",
            source: "Preview Source",
            sourceId: UUID(),
            location: "8.35"
        ),
        isHero: false,
        sourceType: "Book"
    )
}
