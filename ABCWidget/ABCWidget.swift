//
//  ABCWidget.swift
//  ABCWidget
//
//  Created by Destriana Orchidea on 06/08/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    private var locationService: LocationServiceProtocol = LocationService()
    func placeholder(in context: Context) -> WidgetEntry {
        WidgetEntry(date: Date(), imageURL: nil, title: "Surabaya, Indonesia")
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> ()) {
        let entry = WidgetEntry(date: Date(), imageURL: nil, title: "Mumbai, India")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [WidgetEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = WidgetEntry(date: entryDate, imageURL: nil, title: "India")
            entries.append(entry)
        }
    }
    
//    locationService.requestUserLocation { city, country, error in
//        var entries: [WidgetEntry] = []
//
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = WidgetEntry(date: entryDate, imageURL: nil, title: "\(city), \(country)")
//            entries.append(entry)
//        }
//
//        let timeline = Timeline(entries: entries, policy: .atEnd)
//        completion(timeline)
//    }
}

struct WidgetEntry: TimelineEntry {
    let date: Date
    let imageURL: String?
    let title: String?
}

struct WeatherWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        WeatherWidgetView(imageURL: entry.imageURL, title: entry.title)
    }
}

struct WeatherWidget: Widget {
    let kind: String = "HeartyRecipeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WeatherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Hearty Recipe Widget")
        .description("Display a widget with a random recipe that is updated every 1 hour.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct WeatherWidgetView: View {
    let imageURL: String?
    let title: String?
    
    @Environment(\.widgetFamily) var family: WidgetFamily

    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            HeartyRecipeWidgetSmallView(imageURL: imageURL, title: title)
        case .systemMedium:
            HeartyRecipeWidgetMediumView(imageURL: imageURL, title: title)
        case .systemLarge:
            HeartyRecipeWidgetLargeView(imageURL: imageURL, title: title)
        @unknown default:
            EmptyView()
        }
    }
}

struct HeartyRecipeWidgetSmallView: View {
    let imageURL: String?
    let title: String?
    
    var body: some View {
        ZStack(alignment: .top) {
            AsyncImage(url: URL(string: imageURL ?? ""))
            VStack(alignment: .leading) {
                AsyncImage(url: URL(string: imageURL ?? ""))
                    .frame(height: 64)
                    .cornerRadius(10)
                
                Text(title ?? "")
                    .font(.system(size: 10, weight: .regular, design: .default))
            }
            .padding()
        }
//        .widgetURL(recipe?.widgetURL)
    }
}

struct HeartyRecipeWidgetMediumView: View {
    let imageURL: String?
    let title: String?
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(.white)
            GeometryReader {
                geometry in
                HStack(alignment: .top) {
                    AsyncImage(url: URL(string: imageURL ?? ""))
                        .frame(width: geometry.size.height)
                        .cornerRadius(10)
                
                    VStack(alignment: .leading) {
                        Text(title ?? "")
                            .font(.system(size: 10, weight: .regular, design: .default))
                    }
                }
            }
            .padding()
        }
    }
}

struct HeartyRecipeWidgetLargeView: View {
    let imageURL: String?
    let title: String?
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(.white)
            GeometryReader { geometry in
                VStack(alignment: .leading) {
                    AsyncImage(url: URL(string: imageURL ?? ""))
                        .frame(height: geometry.size.width/2)
                        .cornerRadius(10)
                        
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title ?? "")
                            .font(.system(size: 10, weight: .regular, design: .default))
                    }
                }
            }
            .padding()
        }
    }
}
