//
//  HomeViewController.swift
//  WORX
//
//  Created by Jaelhorton on 5/18/20.
//  Copyright © 2020 worx. All rights reserved.
//

import UIKit
import JGProgressHUD
import SDWebImage

protocol RefreshDataDelegateProtocol {
    func refreshViewController()
}

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, RefreshDataDelegateProtocol {

    @IBOutlet weak var noMatchesLabel: UILabel!
    
    @IBOutlet weak var dateCollectionView: UICollectionView!
    
    private let collectionHeaderIdentifier = "dateHeaderCell"
    
    private let heightHeader = 50
    private var colorHeaderActive = UIColor(hexString: "#0088FF")
    private var colorHeaderInActive = UIColor.gray
    private var colorHeaderBackground = UIColor.white
    private var tabStyle = SlidingTabStyle.flexible
    private var currentPosition = 0
    private var dateList = [DateModel]()
    
    // Match List
    
    @IBOutlet weak var matchTableView: UITableView!
    
    var matches: [MatchData] = [MatchData]()
    
    let hud = JGProgressHUD(style: .light)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshDates()
        // dateCollectionView
        
        dateCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        dateCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        dateCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        dateCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        dateCollectionView.heightAnchor.constraint(equalToConstant: CGFloat(heightHeader)).isActive = true
        (dateCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
        dateCollectionView.showsHorizontalScrollIndicator = false
        //dateCollectionView.backgroundColor = colorHeaderBackground
        dateCollectionView.register(DateHeaderCell.self, forCellWithReuseIdentifier: collectionHeaderIdentifier)
        dateCollectionView.delegate = self
        dateCollectionView.dataSource = self
        dateCollectionView.reloadData()
        
        // Match List
        matchTableView.delegate = self
        matchTableView.dataSource = self
        
        LocationManager.getSharedManager().startUpdatingLocation()

        self.setCurrentPosition(position: 0)
    }
    
    @IBAction func onSettingsPressed(_ sender: Any) {
        let vc =  self.storyboard?.instantiateViewController(identifier: "settingsViewController") as! SettingsViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func onFilterPressed(_ sender: Any) {
        let vc =  self.storyboard?.instantiateViewController(identifier: "filterViewController") as! FilterViewController
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func refreshViewController() {
        // Fetch match list
        let dateModel = dateList[currentPosition]
        self.hud.textLabel.text = "Loading"
        self.hud.show(in: self.view, animated: true)
        let start_date = WORXHelper.sharedInstance.getISO8601DateStringFromHalfShortDateString(date: dateModel.date)
        let latitude = PrefsManager.getLatitude()
        let longitude = PrefsManager.getLongitude()
        let radius = PrefsManager.getMatchDistance() * 1000;
        print("latitude: \(latitude), longitude: \(longitude), radius: \(radius)")
        WORXAPI.sharedInstance.fetchMatchList(start_time: start_date, latitude: latitude, longitude: longitude, radius: radius) { (response, err) in
            if let response = response {
                // Clear Old Matches
                self.matches.removeAll()
                let returnedMatches = response.data
                if returnedMatches != nil{
                    // Load Filter Settings
                    let matchCost = PrefsManager.getMatchCost()
                    let matchSizeList = PrefsManager.getMatchSizeList()
                    for match in returnedMatches! {
                        if(Int(match.credits) ?? 0 <= matchCost){
                            var availableMatch = false
                            for matchSize in matchSizeList {
                                if matchSize == Int(match.max_players) {
                                    availableMatch = true
                                    break
                                }
                            }
                            if(matchSizeList.isEmpty || availableMatch == true){
                                self.matches.append(match)
                            }
                        }
                    }
                }
                if(self.matches.count == 0){
                    self.noMatchesLabel.isHidden = false
                }
                else{
                    self.noMatchesLabel.isHidden = true
                }
                self.matchTableView.reloadData()
            }
            self.hud.dismiss()
        }

    }
    
    func refreshDates() {
        
        let numberOfDays: Int = 30
        let startDate = Date()
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        let calendar = Calendar.current
        var offset = DateComponents()
        
        dateList.removeAll()
        
        // Today
        dateList.append(DateModel(text: "Today", date: formatter.string(from: startDate)))
        // Tomorrow
        offset.day = 1
        let nextDay: Date? = calendar.date(byAdding: offset, to: startDate)
        let nextDayString = formatter.string(from: nextDay!)
        dateList.append(DateModel(text: "Tomorrow", date: nextDayString))
        // Next Dates
        for i in 2..<numberOfDays {
            offset.day = i
            let nextDay: Date? = calendar.date(byAdding: offset, to: startDate)
            let nextDayString = formatter.string(from: nextDay!)
            dateList.append(DateModel(text: nextDayString, date: nextDayString))
        }
    }
    func setCurrentPosition(position: Int){
        currentPosition = position
        let path = IndexPath(item: currentPosition, section: 0)
        
        DispatchQueue.main.async {
            if self.tabStyle == .flexible {
                self.dateCollectionView.scrollToItem(at: path, at: .centeredHorizontally, animated: true)
            }
            
            self.dateCollectionView.reloadData()
        }
        self.hud.textLabel.text = "Loading"
        self.hud.show(in: self.view, animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.hud.dismiss()
            self.refreshViewController()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 182
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.matches.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let match = self.matches[indexPath.row]
        let vc =  self.storyboard?.instantiateViewController(identifier: "bookPlaceViewController") as! BookPlaceViewController
        vc.setMatch(match: match)
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "matchCell", for: indexPath) as! MatchCell
        let match = self.matches[indexPath.row]
        
        cell.index = indexPath.row
        // avatar
        let host_avatar =  WORXAPI.sharedInstance.getHostURL() + "uploads/host/" + match.host_photo
        // match size
        let match_size = WORXHelper.sharedInstance.getMatchSize(with: Int(match.max_players) ?? 0)
        cell.hostProfileImageView.sd_setImage(with: URL(string: host_avatar), placeholderImage: UIImage(named: "ic_profile"))
        cell.hostProfileImageView.makeRounded()
        cell.hostNameLabel.text = match.host_name
        cell.matchTitleLabel.text = match.title
        cell.locationLabel.text = match.address
        cell.matcHSizeLabel.text = match_size
        cell.matchCostLabel.text = "£" + match.credits
        // Start Time
        cell.startTimeLabel.text = WORXHelper.sharedInstance.get12HourTimeStringFromFullTimeDate(timeString: match.start_time)
        
        if(match.players != nil){
            cell.playerView.subviews.forEach({$0.removeFromSuperview()})
            for index in 0..<match.players!.count {
                if index>3 {
                    break
                }
                let player = match.players![index]
                let height = cell.playerView.frame.height
                let player1 = UIImageView()

                var player_avatar = player.photo;
                if player_avatar.contains("http") == false {
                    player_avatar =  WORXAPI.sharedInstance.getHostURL() + "uploads/photo/" + player.photo
                }

                player1.sd_setImage(with: URL(string: player_avatar), placeholderImage: UIImage(named: "ic_profile"))
                player1.frame = CGRect(x: (height-18) * CGFloat(index), y: 0, width: height, height: height)
                player1.makeRounded()
                cell.playerView.addSubview(player1)

            }
            if(match.players!.count > 4){
                cell.playerCountLabel.isHidden = false
                cell.playerCountLabel.text = String(match.players!.count - 4) + "+"
            }
            else{
                cell.playerCountLabel.isHidden = true
            }
        }
        cell.callbackBook = { (index) in
            let vc =  self.storyboard?.instantiateViewController(identifier: "bookPlaceViewController") as! BookPlaceViewController
            vc.setMatch(match: match)
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setCurrentPosition(position: indexPath.row)
    }
}

extension HomeViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionHeaderIdentifier, for: indexPath) as! DateHeaderCell
        let dateModel = dateList[indexPath.row]
        cell.text = dateModel.text
        
        var didSelect = false
        
        if currentPosition == indexPath.row {
            didSelect = true
        }
        
        cell.select(didSelect: didSelect, activeColor: colorHeaderActive!, inActiveColor: colorHeaderInActive)
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if tabStyle == .fixed {
            let spacer = CGFloat(dateList.count)
            return CGSize(width: view.frame.width / spacer, height: CGFloat(heightHeader))
        }else{
            return CGSize(width: view.frame.width * 20 / 100, height: CGFloat(heightHeader))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

struct DateModel {
    var text: String
    var date: String
}
enum SlidingTabStyle: String {
    case fixed
    case flexible
}
