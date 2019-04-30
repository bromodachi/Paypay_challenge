//
//  ViewController.swift
//  CurrencyExchange
//
//  Created by Conrado Uraga on 2019/04/13.
//  Copyright © 2019 Conrado Uraga. All rights reserved.
//

import UIKit
// The parent view controller.
class CurrencyCheckerVC: UIViewController {
    //MARK: Properties(views)
    private var collectionView: UICollectionView!
    private var userInput: UITextField!
    private var currentSelectedCurrency: UILabel!
    private var reloadButton: UIBarButtonItem!
    //MARK: View models
    private var currencyViewModel: CurrencyViewModel!
    private var quotesViewModel: QuotesViewModel = QuotesViewModel(quotes: [Quotes]()) {
        didSet {
            collectionView.reloadData()
        }
    }
    //TODO: This should actually be inside a model. But for simplicity sakes, I've added this in the controller.
    private var userInputedPrice: Double = 1
    
    //MARK: Setup views.
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor.white
        setupTopPortion()
        setupCollectionView()
        setupRightNavigationBarButton()
        showReloadButton(false)
    }
    
    private func setupTopPortion(){
        userInput = PaddingOnTextField()
        userInput.inputAccessoryView = getToolBar()
        userInput.placeholder = "Enter the amount you wish to exchange to."
        userInput.textAlignment = .center
        userInput.keyboardType = .numberPad
        userInput.delegate = self
        view.addSubview(userInput)
        userInput.layer.borderColor = UIColor.black.cgColor
        userInput.layer.borderWidth = 1
        userInput.setHeight(50)
        userInput.setTopToLayoutGuide(controller: self, distance: 8)
        userInput.leftAndRightOfParent(self.view, constant: 8)
        
        // top right label underneath the user input. displays the currenctly selected text
        let container = UIView()
        view.addSubview(container)
        container.bottomOf(given: userInput, multiplier: 1.0, constant: 5)
        container.setHeight(30)
        container.leftAndRightOfParent(self.view, constant: 0)
        let tableViewCell = UITableViewCell()
        container.addSubview(tableViewCell)
        tableViewCell.accessoryType = .disclosureIndicator
        tableViewCell.leftAndRightOfParent(container, constant: 0)
        tableViewCell.topAndBottomOfParent(container, constant: 0)
        
        currentSelectedCurrency = UILabel()
        createLongPresssRecognizer(forview: currentSelectedCurrency, selector: #selector(showList(_:)))
        currentSelectedCurrency.backgroundColor = UIColor.clear
        currentSelectedCurrency.textAlignment = .right
        container.addSubview(currentSelectedCurrency)
        currentSelectedCurrency.centerY(to: container)
        currentSelectedCurrency.leftAndRightOfParent(container, constant: 20)
    }
    
    private func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(CurrencyCell.self, forCellWithReuseIdentifier: CurrencyCell.identifier)
        view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bottomOf(given: currentSelectedCurrency, multiplier: 1.0, constant: 5)
        collectionView.leftAndRightOfParent(self.view, constant: 0)
        collectionView.bottomToParent(given: self.view, multiplier: 1.0, constant: 8)
    }
    private func setupRightNavigationBarButton(){
        reloadButton = UIBarButtonItem.init(title: "Reload", style: .done, target: self, action: #selector(loadCurrencies(_:)))
        self.navigationItem.rightBarButtonItem = reloadButton
    }
    private func getToolBar()->UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let rightBarButton = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(dismissTextField))
        toolbar.items = [flexSpace, rightBarButton]
        return toolbar
    }
    //MARK: Selector related functions and helpers for the selectors
    private func showReloadButton(_ bool: Bool){
        reloadButton.isEnabled = bool
    }
    private func changeColorBackForCurrentselected() {
         self.currentSelectedCurrency.backgroundColor = UIColor.white
    }
    @objc private func showList(_ longPress: UILongPressGestureRecognizer) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.currentSelectedCurrency.backgroundColor =  UIColor.white.darker(amount: 0.05)
        }
        if isValid(longPress: longPress, self.changeColorBackForCurrentselected) {
            // create a controller with a new currency view model that points to set currency so we can update THIS view model.
            let controller = ListOfCurrencies(currencies: CurrencyViewModel(currencies: self.currencyViewModel.currencies, currentSelected: self.currencyViewModel.currentSelected, didSetNotify: self.setCurrency))
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    @objc private func dismissTextField(){
        userInput.resignFirstResponder()
    }
    
    //MARK: View finish loading
    //After view creation, call to API.
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCurrencies(nil)
    }
    
    // reload when we actually set the currency.
    private func reloadCurrencies(_ currency: Currency){
        currentSelectedCurrency.text = currency.fullName
        getQuoteFor(currency: currency)
    }
    // set the currency to the view model.
    private func setCurrency(_ currency: Currency){
        self.currencyViewModel.currentSelected = currency
    }

    
    //MARK: API CALLS
    /// Grab all available currencies
    @objc private func loadCurrencies(_ any: Any?){
        APIBaseController.load(Currency.getCurrencies) { [weak self] (currencies, bool, errorString) in
            guard let currencies = currencies, bool,  let strongSelf = self else {
                self?.showAlert(title: "Error", message: "Please try pressing the reload button to attempt to get data again.")
                self?.showReloadButton(true)
                return
            }
            self?.showReloadButton(false)
            let defaultCurrency = Currency(keyValue: ("USD", "United States Dollar"))
            // create the currency view model and set the delgate to reload currency.
            self?.currencyViewModel = CurrencyViewModel.init(currencies: currencies, currentSelected: defaultCurrency, didSetNotify: strongSelf.reloadCurrencies)
            self?.reloadCurrencies(defaultCurrency)
        }
    }
    
    /// Get live updates of its exchange rate for a given single currency.
    ///
    /// - Parameter currency:
    private func getQuoteFor(currency: Currency){
        let wasSuccessful = quotesViewModel.loadFromDisk(currency: currency)
        if !wasSuccessful {
            APIBaseController.load(Quotes.getQuoteFor(currency: currency)) { [weak self] (quotes, bool, erorrString) in
                guard let quote = quotes, bool else {
                    self?.showAlert(title: "Error", message: erorrString ?? "Please try pressing the reload button to attemp to get data again.")
                    return
                }
                self?.quotesViewModel = QuotesViewModel.init(quotes: quote)
                self?.quotesViewModel.writeToDisk()
            }
        }
    }
    
    //MARK: Alert view controller
    private func showAlert(title: String, message: String){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
extension CurrencyCheckerVC: UITextFieldDelegate {
    //MARK: TextField delegates
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, let price = Double(text) else { return }
        userInputedPrice = price
        reloadVisibleCells()
    }
}
extension CurrencyCheckerVC: UICollectionViewDelegate {
    
}
extension CurrencyCheckerVC: UICollectionViewDataSource {
    //MARK: CollectionView data source
    func reloadVisibleCells(){
        let cells = self.collectionView.indexPathsForVisibleItems
        self.collectionView.reloadItems(at: cells)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quotesViewModel.numberOfItemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrencyCell.identifier, for: indexPath) as! CurrencyCell
        cell.setCurrencyName(userInput: userInputedPrice, quote: quotesViewModel.currencyAt(index: indexPath.row))
        return cell
    }
}

extension CurrencyCheckerVC: UICollectionViewDelegateFlowLayout {
    //MARK: UICollectionViewDelegateFlowLayout
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 4, height: 80)
    }
}
extension CurrencyCheckerVC: AddLongPressToSimulateTouchUpInside {}
