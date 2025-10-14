import WidgetKit
import SwiftUI

// Timeline Entry - data for each widget update
struct SimpleEntry: TimelineEntry {
    let date: Date
    let quote: Quote
}

// Provider - controls when and what data to show
struct Provider: TimelineProvider {
    let selector = QuoteSelector()
    
    func placeholder(in context: Context) -> SimpleEntry {
        // Use first available quote as placeholder
        if let quote = selector.getGlobalQuoteOfTheDay() {
            return SimpleEntry(date: Date(), quote: quote)
        }
        
        // Fallback if no quotes loaded
        let fallbackQuote = Quote(
            id: UUID(),
            text: "Loading quotes...",
            author: "Food for Thought",
            source: nil,
            sourceId: UUID()
        )
        return SimpleEntry(date: Date(), quote: fallbackQuote)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let quote = selector.getGlobalQuoteOfTheDay() ?? placeholder(in: context).quote
        let entry = SimpleEntry(date: Date(), quote: quote)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline: new quote each day for next 5 days
        let currentDate = Date()
        for dayOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)!
            let quoteForThisDay = selector.getGlobalQuoteOfTheDay(date: entryDate)
            
            if let quote = quoteForThisDay {
                let entry = SimpleEntry(date: entryDate, quote: quote)
                entries.append(entry)
            }
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

// Widget UI - the actual view (like your React component JSX)
struct FoodForThoughtWidgetExtensionEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family // Detects widget size
    
    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(quote: entry.quote)
        case .systemMedium:
            MediumWidgetView(quote: entry.quote)
        case .systemLarge, .systemExtraLarge:
            LargeWidgetView(quote: entry.quote)
        case .accessoryCircular:
            AccessoryCircularView(quote: entry.quote)
        case .accessoryRectangular:
            AccessoryRectangularView(quote: entry.quote)
        case .accessoryInline:
            AccessoryInlineView(quote: entry.quote)
        @unknown default:
            MediumWidgetView(quote: entry.quote)
        }
    }
}

// Small widget - minimal info
struct SmallWidgetView: View {
    let quote: Quote
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(quote.text)
                .font(.caption2)
                .fontWeight(.medium)
                .lineLimit(5)
            
            Spacer()
            
            Text("— \(quote.author)")
                .font(.system(size: 9))
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

// Medium widget - quote + author
struct MediumWidgetView: View {
    let quote: Quote
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(quote.text)
                .font(.callout)
                .fontWeight(.medium)
                .lineLimit(5)
            
            Spacer()
            
            Text("— \(quote.author)")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

// Large widget - quote + author + source
struct LargeWidgetView: View {
    let quote: Quote
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(quote.text)
                .font(.body)
                .fontWeight(.medium)
                .lineLimit(8)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 4) {
                Text("— \(quote.author)")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                if let source = quote.source {
                    Text(source)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .italic()
                }
            }
        }
        .padding()
    }
}

// Lock Screen - Circular (very small, icon-like)
struct AccessoryCircularView: View {
    let quote: Quote
    
    var body: some View {
        ZStack {
            AccessoryWidgetBackground()
            VStack(spacing: 2) {
                Image(systemName: "quote.bubble")
                    .font(.title3)
                Text(String(quote.author.prefix(1)))
                    .font(.caption2)
                    .fontWeight(.bold)
            }
        }
    }
}

// Lock Screen - Rectangular (short and wide)
struct AccessoryRectangularView: View {
    let quote: Quote
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(quote.text)
                .font(.caption2)
                .fontWeight(.semibold)
                .lineLimit(2)
            
            Text("— \(quote.author)")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}

// Lock Screen - Inline (single line of text above clock)
struct AccessoryInlineView: View {
    let quote: Quote
    
    var body: some View {
        Text("\(quote.author): \(quote.text)")
            .lineLimit(1)
    }
}

// Widget configuration
struct FoodForThoughtWidgetExtension: Widget {
    let kind: String = "FoodForThoughtWidgetExtension"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            FoodForThoughtWidgetExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("Food for Thought")
        .description("Get inspired with daily food for thought.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// Preview for Xcode
#Preview(as: .systemSmall) {
    FoodForThoughtWidgetExtension()
} timeline: {
    let selector = QuoteSelector()
    let quote = selector.getGlobalQuoteOfTheDay() ?? Quote(
        id: UUID(),
        text: "Preview quote",
        author: "Author",
        source: nil,
        sourceId: UUID()
    )
    SimpleEntry(date: .now, quote: quote)
}

#Preview(as: .systemMedium) {
    FoodForThoughtWidgetExtension()
} timeline: {
    let selector = QuoteSelector()
    let quote = selector.getGlobalQuoteOfTheDay() ?? Quote(
        id: UUID(),
        text: "Preview quote",
        author: "Author",
        source: nil,
        sourceId: UUID()
    )
    SimpleEntry(date: .now, quote: quote)
}

#Preview(as: .systemLarge) {
    FoodForThoughtWidgetExtension()
} timeline: {
    let selector = QuoteSelector()
    let quote = selector.getGlobalQuoteOfTheDay() ?? Quote(
        id: UUID(),
        text: "Preview quote",
        author: "Author",
        source: nil,
        sourceId: UUID()
    )
    SimpleEntry(date: .now, quote: quote)
}
