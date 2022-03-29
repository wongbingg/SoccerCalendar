//
//  ViewController.swift
//  CalendarT
//
//  Created by 이원빈 on 2022/02/22.
//

import UIKit
import FSCalendar

class ViewController: UIViewController,SportManagerDelegate { //FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var choiceTeam: UIPickerView!
    
    var sportManager = SportManager() //test
    
    var teamId:String = ""
    let teamList = ["Arsenal","Brentford","Chelsea","Internacional Tirana"] // 좋아하는 팀으로 등록한 팀들이 여기 저장되게!
    let teamDiction = ["Arsenal":"42","Brentford":"55","Chelsea":"49","Internacional Tirana":"10716"] // 전체 팀id정보가 들어간 대용량 딕셔너리 필요..
                                                                                                      
    let calendar = Calendar.current
    var dateComponents = DateComponents()
    let dateFormatter = DateFormatter()
    var dateInfo:String?
    
    //  getData()에서 받아온 값들을 저장해주고,
    var events = [Date]()
    var eventsDetail = [String]()
    var leagueName = [String]()
    var logoimagestring = [String]()
    var homeLogo = [String]()
    var homeTeam = [String]()
    var awayLogo = [String]()
    var awayTeam = [String]()
    //  NextVC로 그대로 넘겨준다
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        sportManager.delegate = self
        choiceTeam.dataSource = self
        choiceTeam.delegate = self
        setUpDesign()
    }
    
    func didUpdateSport(_ sportManager: SportManager, sport: SportModel) {
        
        DispatchQueue.main.async {
        
            self.events = sport.datelist.map{self.dateFormatter.date(from: $0)!}
            self.leagueName = sport.leagueName
            self.logoimagestring = sport.logoimagestring
            self.homeLogo = sport.homeLogo
            self.homeTeam = sport.homeTeam
            self.awayLogo = sport.awayLogo
            self.awayTeam = sport.awayTeam
            self.eventsDetail = sport.timestamplist
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    // MARK: Navigation 데이터 넘겨주기
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "gotoNext" {
            
            let destinationVC = segue.destination as! NextVC
            destinationVC.currentDate = dateInfo
            destinationVC.currentTeamId = teamId
            destinationVC.leagueName = leagueName
            destinationVC.logoimagestring = logoimagestring
            destinationVC.hometeam = homeTeam
            destinationVC.homeLogo = homeLogo
            destinationVC.awayteam = awayTeam
            destinationVC.awayLogo = awayLogo
            destinationVC.events = events
            destinationVC.eventsDetail = eventsDetail
        }
    }
}

//MARK: - FSCalendar

extension ViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func setUpDesign() {
        
        calendarView.scope = .month
        dateFormatter.dateFormat = "yyyy-MM-dd"
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0 // 양쪽의 흐릿한 헤더 없애기
        calendarView.appearance.headerDateFormat = "YYYY년 MM월"
        calendarView.appearance.titleWeekendColor = .red
    }
    
    // 캘린더의 event도트 표시
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        if self.events.contains(date) {
            return 1
        } else {
            return 0
        }
    }
    
    // 달력 수동 이동
    @IBAction func moveToNext(_ sender: UIButton) {
        self.moveCurrentPage(moveUp: true)
    }
    
    @IBAction func moveToPrev(_ sender: UIButton) {
        self.moveCurrentPage(moveUp: false)
    }
    
    private func moveCurrentPage(moveUp: Bool) {
        dateComponents.month = moveUp ? 1 : -1
        calendarView.currentPage = calendar.date(byAdding: dateComponents, to: calendarView.currentPage)!
        self.calendarView.setCurrentPage(calendarView.currentPage, animated: true)
    }
    
    // 캘린더의 날짜 클릭 시 Action
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        dateInfo = dateFormatter.string(from: date)
        print(dateInfo! , "날짜가 선택 되었습니다.") // dateInfo 값을 기준으로 경기일정 전반내용 을 출력하는 것이 목적!!
        if events.contains(date) {
            self.performSegue(withIdentifier: "gotoNext", sender: self)
        }
    }
}

// MARK: - UIPickerView

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return teamList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print(row)
        return teamList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedTeam = self.teamList[row]
        print(selectedTeam)
        teamId = teamDiction[selectedTeam]!
        sportManager.getData(season: "2021", teamid: teamId)
    }
}

