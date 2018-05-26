//
//  KivaLoanTableViewController.swift
//  KivaLoan
//
//  Created by Simon Ng on 4/10/2016.
//  Updated by Simon Ng on 6/12/2017.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class KivaLoanTableViewController: UITableViewController {
    
    private let kivaLoanURL = "https://api.kivaws.org/v1/loans/newest.json"
    private var loans = [Loan]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getLatestLoans()

        tableView.estimatedRowHeight = 92.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows
        return loans.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! KivaLoanTableViewCell

        // Configure the cell...
        cell.amountLabel.text = String(loans[indexPath.row].amount)
        cell.countryLabel.text = loans[indexPath.row].country
        cell.nameLabel.text = loans[indexPath.row].name
        cell.useLabel.text = loans[indexPath.row].use

        return cell
    }

}


extension KivaLoanTableViewController {
    func getLatestLoans() {
        // guard let url
        guard let loanUrl = URL(string: kivaLoanURL) else { return }
        // Request
        let request = URLRequest(url: loanUrl)
        // task
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let error = error {
                print(error)
                return
            }
            // 解析json
            if let data = data {
                self.loans = self.parseJsonData(data: data)
                OperationQueue.main.addOperation {
                    self.tableView.reloadData()
                }
            }
         }


        task.resume() // “初始化 data task"
    }
    
    func parseJsonData(data: Data) -> [Loan] {
        var loans =  [Loan]()
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
            let jsonLoans = jsonResult?["loans"] as! [AnyObject]
            for jsonLoan in jsonLoans {
                var loan = Loan()
                loan.name = jsonLoan["name"] as! String
                loan.amount = jsonLoan["loan_amount"] as! Int
                let location = jsonLoan["location"] as! [String: AnyObject]
                loan.country = location["country"] as! String
                loan.use = jsonLoan["use"] as! String

                loans.append(loan)
            }
        } catch {
            print(error)
        }
        return loans
    }
}



