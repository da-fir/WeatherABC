//
//  ABCWidget.swift
//  ABCWidget
//
//  Created by Destriana Orchidea on 06/08/24.
//

import WidgetKit
import SwiftUI

var lastUpdateTime = Date()
struct Provider: TimelineProvider {
    private var locationService: LocationServiceProtocol = LocationService()
    func placeholder(in context: Context) -> WidgetEntry {
        print("Widget", "placeholder")
        return WidgetEntry(date: Date(), imageURL: nil, title: "Surabaya, Indonesia")
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> ()) {
        let entry = WidgetEntry(date: Date(), imageURL: nil, title: "Mumbai, India")
        completion(entry)
        print("Widget", "getSnapshoted")
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        print("Widget", "locationService")
        if !locationService.locationManager.isAuthorizedForWidgetUpdates {
            locationService.requestPermissionIfNeeded()
        }
        
        print("Widget", "locationService - ED1", locationService.locationManager.authorizationStatus.rawValue)
        
        let differenceInSeconds = Int(Date().timeIntervalSince(lastUpdateTime))
        if differenceInSeconds < 5 {
            print("Widget", "locationService - ED2")
            locationService.requestUserLocation { city, country, error in
                print("Widget", "requestUserLocationed")
                let entry = WidgetEntry(date: Date(), imageURL: nil, title: "\(city), \(country)")
                // make sure that we get refreshed
                // to be really usefull to the user it would be better to do this more like
                // every 15 minutes. But, that would be more api calls per day than we get
                let refreshDate = Calendar.current.date(byAdding: .minute, value: 60, to: Date())
                let timeline = Timeline(entries: [entry], policy: .after(refreshDate!))
                completion(timeline)
            }
        }
        lastUpdateTime = Date()
    }
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
        default:
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
