//
//  ListOfCurrencies.swift
//  CurrencyExchange
//
//  Created by Conrado Uraga on 2019/04/14.
//  Copyright © 2019 Conrado Uraga. All rights reserved.
//

import UIKit
//Tableview that shows the list of currencies to the user.
class ListOfCurrencies: UITableViewController {
    private var currencyViewModel: CurrencyViewModel!
    //MARK: Initialization
    init(currencies: CurrencyViewModel){
        super.init(style: .plain)
        self.currencyViewModel = currencies
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: .done, target: self, action: #selector(dismissController(_:)))
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuse")
    }
    //MARK: Dismiss controller
    @objc private func dismissController(_ barButton: Any?){
        navigationController?.popViewController(animated: true)
    }

    //MARK: Tableview delegates and data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return currencyViewModel.numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyViewModel.numberOfItemsInSection
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuse", for: indexPath)
        let currency = currencyViewModel.currencyAt(index: indexPath.row)
        cell.textLabel?.text = currency.fullName
        cell.accessoryType  = currency.shortName == currencyViewModel.currentSelected.shortName ?  .checkmark : .none
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currencyViewModel.currentSelected = currencyViewModel.currencyAt(index: indexPath.row)
        dismissController(nil)
    }
}
