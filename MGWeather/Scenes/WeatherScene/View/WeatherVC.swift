//
//  ViewController.swift
//  MGWeather
//
//  Created by Michael Ghevondyan on 19.04.23.
//

import UIKit
import MapKit
import Lottie


class WeatherVC: BaseVC {
    
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet private weak var animationView: LottieAnimationView!
    @IBOutlet weak var weatherMinMaxLabel: UILabel!
    @IBOutlet weak var weatherMainLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    // MARK: - properties
    
    var vm: WeatherVM = WeatherVM()
    
    // MARK: - Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        self.vm.getWeather()
        self.initUI()
    }
    
    //MARK: - Override Functions

    override func dataFetched<T>(type: T.Type, data: T, observerName: String) {
        guard let model = data as? WeatherModel else { return }
         updateContent(model: model)
        setAnimation(model: model)
         ActivityIndicatorView.shared.stopAnimating()
    }
    
    // MARK: - Initialization
    
    func initUI() {
        self.initContentView()
        self.initMapView()
    }
    
    func initContentView() {
        contentView.alpha = 0.7
    }
    
    func initMapView() {
        mapView.delegate = self
    }
    
    func updateContent(model: WeatherModel) {
        self.mapDur(lat: model.coord.lat, lng: model.coord.lon)
        self.tempLabel.text = String(Int(model.main.temp - 273.15))+"°C"
        self.feelsLikeLabel.text = String(Int(model.main.feelsLike - 273.15))+"°C"
        self.locationLabel.text = model.name + ", " + model.sys.country
        self.weatherMainLabel.text = model.weather[0].main
        self.humidityLabel.text = String(Int(model.main.humidity)) + "%"
        self.visibilityLabel.text = String(model.visibility) + "m"
        self.windSpeedLabel.text = String(model.wind.speed) + "m/s"
        let minTemp = String(Int(model.main.tempMin - 273.15)) + "°"
        let maxTemp = String(Int(model.main.tempMax - 273.15)) + "°"
        self.weatherMinMaxLabel.text = "Max.: " + maxTemp + " , " + "Min.: " + minTemp
    }
    
    func setAnimation(model: WeatherModel) {
        switch WeatherMain(rawValue: model.weather[0].main) {
        case .Clouds:
            self.animationView.animation = LottieAnimation.named("cloud.json")
        case .Drizzle:
            self.animationView.animation = LottieAnimation.named("drizzle.json")
        case .Clear:
            self.animationView.animation = LottieAnimation.named("clear.json")
        case .Rain:
            self.animationView.animation = LottieAnimation.named("rain.json")
        case .none:
            self.animationView.animation = LottieAnimation.named("loadWeather.json")
        }
        animationView.animationSpeed = 0.5
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.contentMode = .scaleToFill
        self.animationView.play()
    }
}

