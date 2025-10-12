import WidgetKit
import SwiftUI

// Timeline Entry - data for each widget update
struct SimpleEntry: TimelineEntry {
    let date: Date
    let quote: Quote
}

// Provider - controls when and what data to show
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), quote: quotes[0])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), quote: quotes.randomElement()!)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline: new quote every hour
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, quote: quotes.randomElement()!)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

// Widget UI - the actual view (like your React component JSX)
struct DailyQuoteWidgetExtensionEntryView : View {
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
struct DailyQuoteWidgetExtension: Widget {
    let kind: String = "DailyQuoteWidgetExtension"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DailyQuoteWidgetExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("Daily Quote")
        .description("Get inspired with a daily quote.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// Preview for Xcode
#Preview(as: .systemSmall) {
    DailyQuoteWidgetExtension()
} timeline: {
    SimpleEntry(date: .now, quote: quotes[0])
}

#Preview(as: .systemMedium) {
    DailyQuoteWidgetExtension()
} timeline: {
    SimpleEntry(date: .now, quote: quotes[1])
}

#Preview(as: .systemLarge) {
    DailyQuoteWidgetExtension()
} timeline: {
    SimpleEntry(date: .now, quote: quotes[2])
}
