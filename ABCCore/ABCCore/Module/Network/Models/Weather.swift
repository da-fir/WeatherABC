/* 
Copyright (c) 2024 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import UIKit

public enum MainWeather: String, Codable {
    case rain = "Rain"
    case clouds = "Clouds"
    case clear = "Clear"
    case atmosphere = "Atmosphere"
    case snow = "Snow"
    case drizzle = "Drizzle"
    case thunderstorm = "Thunderstorm"
    
    public var imageName: String {
        switch self {
        case .rain, .drizzle, .thunderstorm:
            return "Rain"
        case .clouds:
            return "Cloud"
        case .clear:
            return "Sunny"
        case .atmosphere:
            return "Sun Behind Cloud"
        case .snow:
            return "Snow"
        }
    }
}

public struct Weather : Codable {
	public let id : Int?
	public let main : MainWeather?
	public let description : String?
	public let icon : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case main = "main"
		case description = "description"
		case icon = "icon"
	}

	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		main = try values.decodeIfPresent(MainWeather.self, forKey: .main)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		icon = try values.decodeIfPresent(String.self, forKey: .icon)
	}

}
