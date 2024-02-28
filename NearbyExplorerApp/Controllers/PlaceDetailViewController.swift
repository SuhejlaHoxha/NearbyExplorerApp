//
//  PlaceDetailViewController.swift
//  NearbyExplorerApp
//
//  Created by Lediona Kadiri on 24.2.24.
//

import Foundation
import UIKit

//when we click a place on the table to show information

class PlaceDetailViewController: UIViewController{

    let place: PlaceAnnotation

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()

    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.alpha = 0.4
        return label
    }()

    var directionsButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Directions", for: .normal)
        return button
    }()

    var callButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Call", for: .normal)
        return button
    }()


    init (place: PlaceAnnotation){
        self.place = place
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func directionsButtonTapped(_ sender: UIButton){
        let coordinate = place.location.coordinate
        guard let url = URL(string: "https://maps.apple.com/?daddr=\(coordinate.latitude),\(coordinate.longitude)") else {return}

        UIApplication.shared.open(url)
    }

//    @objc func callButtonTapped(_ sender: UIButton){
//        //place.phone = +(512)-435-2345
//        // what we need = 5124352345
//        guard let url = URL(string: "tel://\(place.phone.formatPhoneForCall)")
//        else { return }
//        UIApplication.shared.open(url)
//
//    }
    
    @objc func callButtonTapped(_ sender: UIButton){
        // Remove non-numeric characters from the phone number
        let allowedCharacters = CharacterSet.decimalDigits
        let formattedPhoneNumber = place.phone.components(separatedBy: allowedCharacters.inverted).joined()
        
        guard let url = URL(string: "tel://\(formattedPhoneNumber)") else {
            print("Invalid phone number or URL")
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            print("Failed to open URL")
        }
    }


    private func setupUI(){
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)

        nameLabel.text = place.name
        addressLabel.text = place.address

        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(addressLabel)

        nameLabel.widthAnchor.constraint(equalToConstant: view.bounds.width - 20).isActive = true

        let contactStackView = UIStackView()
        contactStackView.translatesAutoresizingMaskIntoConstraints = false
        contactStackView.axis = .horizontal
        contactStackView.spacing = UIStackView.spacingUseSystem

        directionsButton.addTarget(self, action: #selector(directionsButtonTapped), for: .touchUpInside)
        callButton.addTarget(self, action: #selector(callButtonTapped), for: .touchUpInside)

        contactStackView.addArrangedSubview(directionsButton)
        contactStackView.addArrangedSubview(callButton)

        stackView.addArrangedSubview(contactStackView)


        view.addSubview(stackView)

    }
}