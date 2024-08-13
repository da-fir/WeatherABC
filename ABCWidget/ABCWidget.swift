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
    private var networkManager: NetworkManagerProtocol = NetworkManager()
    
    func placeholder(in context: Context) -> WidgetEntry {
        return WidgetEntry(date: Date(), icon: nil, image: resourceService.getWidgetBackgroundImage(), title: "Surabaya, Indonesia")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> ()) {
        let entry = WidgetEntry(date: Date(), icon: nil, image: resourceService.getWidgetBackgroundImage(), title: "Mumbai, India")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        locationService.requestPermissionIfNeeded()
        locationService.requestUserLocation { currentLocationResult in
            Task {
                if let response: WeatherResponse = try? await self.networkManager.asyncRequest(endpoint: .weather(currentLocationResult.location)) {
                    let mainWeatherIcon = response.weather?.first?.main?.imageName ?? "Rain"
                    let entry = WidgetEntry(date: Date(), icon: resourceService.loadLocalImage(image: mainWeatherIcon), image: resourceService.getWidgetBackgroundImage(), title: "\(currentLocationResult.city ?? ""), \(currentLocationResult.country ?? "")")
                    let refreshDate = Calendar.current.date(byAdding: .minute, value: 60, to: Date())
                    let timeline = Timeline(entries: [entry], policy: .after(refreshDate!))
                    completion(timeline)
                } else {
                    print("Failed to fetch.")
                }
            }
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
        ABCWeatherWidgetView(icon: entry.icon, image: entry.image, title: entry.title)
    }
}

struct ABCWeatherWidget: Widget {
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

struct ABCWeatherWidgetView: View {
    let icon: UIImage?
    let image: UIImage?
    let title: String?
    
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    @ViewBuilder
    var body: some View {
        ABCWeatherWidgetAllSizeView(icon: icon, image: image, title: title)
    }
}

struct ABCWeatherWidgetAllSizeView: View {
    let icon: UIImage?
    let image: UIImage?
    let title: String?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(uiImage: image ?? UIImage())
                    .resizable()
                    .aspectRatio(
                        contentMode: .fill
                    )
                    .frame(
                        maxWidth: geometry.size.width,
                        maxHeight: geometry.size.height
                    )
                
                VStack(alignment: .center) {
                    Image(uiImage: icon ?? UIImage())
                        .resizable()
                        .frame(width: 67)
                        .frame(height: 67)
                        .aspectRatio(
                            contentMode: .fill
                        )
                    
                    Text(title ?? "")
                        .padding(16)
                        .font(.headline)
                        .minimumScaleFactor(0.01)
                }
            }
        }
    }
}
