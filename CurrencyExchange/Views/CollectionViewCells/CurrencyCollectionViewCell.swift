//
//  CurrencyCollectionViewCell.swift
//  CurrencyExchange
//
//  Created by Conrado Uraga on 2019/04/13.
//  Copyright © 2019 Conrado Uraga. All rights reserved.
//

import UIKit
class CurrencyCell: UICollectionViewCell {
    //MARK: Properties
    private let nameLabel: UILabel = UILabel()
    private let currentRate: UILabel = UILabel()
    private let userInputedPrice: UILabel = UILabel()
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    //MARK: Setup views
    private func setupViews(){
        userInputedPrice.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .headline).pointSize)
        userInputedPrice.textAlignment = .center
        userInputedPrice.adjustsFontSizeToFitWidth = true
        userInputedPrice.minimumScaleFactor = 0.3
        nameLabel.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .subheadline).pointSize)
        nameLabel.textAlignment = .center
        currentRate.textAlignment = .center
        currentRate.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .caption1).pointSize)
        contentView.addSubview(nameLabel)
        contentView.addSubview(currentRate)
        contentView.addSubview(userInputedPrice)
        userInputedPrice.leftAndRightOfParent(contentView, constant: 8)
        userInputedPrice.centerY(to: contentView)
        currentRate.bottomOf(given: userInputedPrice, multiplier: 1.0, constant: 4)
        currentRate.leftAndRightOfParent(contentView, constant: 8)
        nameLabel.topToParent(given: contentView, multiplier: 1.0, constant: 5)
        nameLabel.leftAndRightOfParent(contentView, constant: 4)
    }
    //MARK: Setup cell given data.
    public func setCurrencyName(userInput: Double, quote: Quotes){
        currentRate.text = "\(quote.rate.roundTo(places: 2))"
        nameLabel.text = quote.currency
        userInputedPrice.text = "\((userInput * quote.rate).roundTo(places: 2) )"
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
extension CurrencyCell {
    //MARK: Cell identifier.
    public static var identifier: String { return  "currencyCell"}
}
