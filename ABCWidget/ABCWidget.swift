//
//  ABCWidget.swift
//  ABCWidget
//
//  Created by Destriana Orchidea on 06/08/24.
//

import ABCCore
import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    private var locationService: LocationServiceProtocol = LocationService()
    private var resourceService: ResourcesServiceProtocol = ResourcesService()
    
    func placeholder(in context: Context) -> WidgetEntry {
        print("Widget", "placeholder")
        return WidgetEntry(date: Date(), icon: nil, image: resourceService.getWidgetBackgroundImage(), title: "Surabaya, Indonesia")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> ()) {
        let entry = WidgetEntry(date: Date(), icon: nil, image: resourceService.getWidgetBackgroundImage(), title: "Mumbai, India")
        completion(entry)
        print("Widget", "getSnapshoted")
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        print("Widget", "locationService")
        locationService.requestPermissionIfNeeded()
        
        print("Widget", "locationService - ED1", locationService.locationManager.authorizationStatus.rawValue)
        
        locationService.requestUserLocation { city, country, error in
            let entry = WidgetEntry(date: Date(), icon: resourceService.loadLocalImage(image: "Rain"), image: resourceService.getWidgetBackgroundImage(), title: "\(city ?? ""), \(country ?? "")")
            let refreshDate = Calendar.current.date(byAdding: .minute, value: 60, to: Date())
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate!))
            completion(timeline)
        }
    }
}

struct WidgetEntry: TimelineEntry {
    let date: Date
    let icon: UIImage?
    let image: UIImage?
    let title: String?
}

struct WeatherWidgetEntryView: View {
    var entry: Provider.Entry
    
    var body: some View {
        WeatherWidgetView(icon: entry.icon, image: entry.image, title: entry.title)
    }
}

struct WeatherWidget: Widget {
    let kind: String = "ABCWeatherWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WeatherWidgetEntryView(entry: entry)
        }
        .contentMarginsDisabled()
        .configurationDisplayName("ABC Widget")
        .description("Display a widget with a weather information on your location")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct WeatherWidgetView: View {
    let icon: UIImage?
    let image: UIImage?
    let title: String?
    
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            ABCWeatherWidgetSmallView(icon: icon, image: image, title: title)
        case .systemMedium:
            ABCWeatherWidgetMediumView(icon: icon, image: image, title: title)
        case .systemLarge:
            ABCWeatherWidgetLargeView(icon: icon, image: image, title: title)
        default:
            EmptyView()
        }
    }
}

struct ABCWeatherWidgetSmallView: View {
    let icon: UIImage?
    let image: UIImage?
    let title: String?
    
    var body: some View {
        ZStack(alignment: .top) {
            Image(uiImage: image ?? UIImage())
                .resizable()
                .aspectRatio(
                    contentMode: .fill
                )
            VStack(alignment: .center) {
                Image(uiImage: icon ?? UIImage())
                    .resizable()
                    .frame(width: 67)
                    .frame(height: 67)
                    .aspectRatio(
                        contentMode: .fit
                    )
                
                Text("\(title ?? "")")
                    .font(.system(size: 18, weight: .semibold, design: .default))
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                    .frame(maxHeight: .infinity)
                    .frame(maxWidth: .infinity)
                    .padding(.leading, 16)
            }
            .frame(maxHeight: .infinity)
            .frame(maxWidth: .infinity)
            .padding(.leading, 16)
        }
    }
}

struct ABCWeatherWidgetMediumView: View {
    let icon: UIImage?
    let image: UIImage?
    let title: String?
    
    var body: some View {
        ZStack(alignment: .top) {
            Image(uiImage: image ?? UIImage())
                .resizable()
                .aspectRatio(
                    contentMode: .fill
                )
            VStack(alignment: .center) {
                Image(uiImage: icon ?? UIImage())
                    .resizable()
                    .frame(width: 82)
                    .frame(height: 82)
                    .aspectRatio(
                        contentMode: .fit
                    )
                Text("\(title ?? "")")
                    .font(.system(size: 16, weight: .regular, design: .default))
                    .multilineTextAlignment(.center)
                Text("\(title ?? "")")
                    .font(.system(size: 24, weight: .semibold, design: .default))
                    .multilineTextAlignment(.center)
            }
            .padding(6)
        }
    }
}

struct ABCWeatherWidgetLargeView: View {
    let icon: UIImage?
    let image: UIImage?
    let title: String?
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(.white)
            GeometryReader { geometry in
                VStack(alignment: .leading) {
                    Text("\(title ?? "")")
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .multilineTextAlignment(.leading)
                    
                    Image(uiImage: image ?? UIImage())
                        .frame(height: geometry.size.width / 2)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}
