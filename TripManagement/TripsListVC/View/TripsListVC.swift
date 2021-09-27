//
//  TripVC.swift
//  TripManagement
//
//  Created by Virtual Dusk  on 27/09/21.
//

import UIKit

class TripsListVC: UIViewController {

    let tblView : UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .singleLine
    
        return tv
    }()
    static private let cellId = "CellId"
    var viewModel : TripsListVM?
    
    convenience init(dbListOfTrips : [Trip] ) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = TripsListVM(listOfTripsDB: dbListOfTrips)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.register(UITableViewCell.self, forCellReuseIdentifier: TripsListVC.cellId)
        self.setupView()
        
        
        // Do any additional setup after loading the view.
    }
    
    func setupView(){
        self.view.addSubview(tblView)
        
        tblView.dataSource = self
        tblView.delegate = self
        tblView.tableFooterView = UIView()
        tblView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tblView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tblView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tblView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tblView.rowHeight = UITableView.automaticDimension
        self.tblView.estimatedRowHeight = 100


    }
    
}

extension TripsListVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.listOfTrips.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TripsListVC.cellId) else { return UITableViewCell() }
        if let trip = self.viewModel?.listOfTrips[indexPath.row] {
            cell.textLabel?.text = "\(trip.name)      no.of Loc :- \(trip.listOfLocations?.count ?? 0)"
        }
        return cell
    }
    
}
