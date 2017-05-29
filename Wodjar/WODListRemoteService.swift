//
//  WODListRemoteService.swift
//  Wodjar
//
//  Created by Bogdan Costea on 4/7/17.
//  Copyright © 2017 X2Mobile. All rights reserved.
//

import Foundation
import Result

typealias GetWodsRequestCompletion = (Result<WorkoutList, NSError>) -> ()
typealias GetResultsRequestCompletion = (Result<[WODResult], NSError>) -> ()


protocol WODListRemoteService {
    func getWodsList(with completion: GetWodsRequestCompletion?)
    func getResults(for wod: Workout, with completion: GetResultsRequestCompletion?)
}

class WODListRemoteServiceTest: WODListRemoteService {
    func getWodsList(with completion: GetWodsRequestCompletion?) {
        let girl1 = Workout(id: 1, type: .girl, name: "Ana", favorite: true, completed: true)
        let girl2 = Workout(id: 2, type: .girl, name: "Lucretia", favorite: false, completed: false)
        let girl3 = Workout(id: 3, type: .girl, name: "Angie", favorite: false, completed: false)
        let girl4 = Workout(id: 4, type: .girl, name: "Sara", favorite: true, completed: true)
        girl1.set(description: "asjgfkjagskf\nlskdhglksg\nskjdg",
                  image: "https://cdn.pixabay.com/photo/2016/04/10/13/52/portrait-1319951_1280.jpg",
                  history: nil,
                  category: .weight,
                  video: "WFfke7ykgjc",
                  unit: .imperial)
        girl2.set(description: "asfasf\nasfasf",
                  image: "http://www.acclaimimages.com/_gallery/_free_images/0420-0905-2603-0613_soldiers_in_training_o.jpg",
                  history: nil,
                  category: .amrap,
                  video: "wXYApF-UosE",
                  unit: .metric)
        girl3.set(description: "<pre>* 100 Pull-ups<br>* 100 Push-ups<br>* 100 Sit-ups<br>* 100 Squats</pre>",
                  image:"https://crossfitjess.files.wordpress.com/2010/08/img_5016_0345_web.jpg",
                  history:"<p><b>Angie</b> is one of the CrossFit benchmark \"Girl\" WODs (because of the name, not because they are designed for women). It first appeared on the CrossFit website on August 18, 2003, though it had not yet been named. The workout did not appear in its current version until 26 July, 2004.</p>",
                  category: .time,
                  video: "pFpJKq2J0ow",
                  unit: .metric)
        girl4.set(description: "asfasf\nasfasf",
                  image: "http://www.acclaimimages.com/_gallery/_free_images/0420-0905-2603-0613_soldiers_in_training_o.jpg",
                  history: nil,
                  category: .amrap,
                  video: "wXYApF-UosE",
                  unit: .metric)
        
        let hero1 = Workout(id: 5, type: .hero, name: "Murph", favorite: true, completed: false)
        let hero2 = Workout(id: 6, type: .hero, name: "Joe", favorite: false, completed: true)
        let hero3 = Workout(id: 7, type: .hero, name: "Boy", favorite: false, completed: false)
        let hero4 = Workout(id: 8, type: .hero, name: "Cata", favorite: false, completed: true)
        hero1.set(description: "<pre>* 1 mile Run<br>* 100 Pull-ups<br>* 200 Push-ups<br>* 300 Squats<br>* 1 mile Run</pre>",
                  image: "https://i.ytimg.com/vi/1DhzC9Ctl-Y/maxresdefault.jpg",
                  history: "<p>In memory of Navy Lieutenant Michael Murphy, 29, of Patchogue, N.Y., who was killed in Afghanistan June 28th, 2005.</p><p>This workout was one of Mike's favorites and he'd named it \"Body Armor\". From here on it will be referred to as \"Murph\" in honor of the focused warrior and great American who wanted nothing more in life than to serve this great country and the beautiful people who make it what it is.</p><p>Partition the pull-ups, push-ups, and squats as needed. Start and finish with a mile run. If you've got a twenty pound vest or body armor, wear it.</p>",
                  category: .time,
                  video: "1DhzC9Ctl-Y",
                  unit: .imperial)
        hero2.set(description: "asfafas\nsdfsdg\n",
                  image: "http://www.acclaimimages.com/_gallery/_free_images/0420-0905-2603-0613_soldiers_in_training_o.jpg",
                  history: "sdsdg\nfdfd\ndfdfdf",
                  category: .amrap,
                  video: "5soixb2U6xM",
                  unit: .metric)
        hero3.set(description: "asfafas\nsdfsdg\n",
                  image: "http://www.acclaimimages.com/_gallery/_free_images/0420-0905-2603-0613_soldiers_in_training_o.jpg",
                  history: "sdsdg\nfdfd\ndfdfdf",
                  category: .amrap,
                  video: "5soixb2U6xM",
                  unit: .metric)
        hero4.set(description: "asfafas\nsdfsdg\n",
                  image: "http://www.acclaimimages.com/_gallery/_free_images/0420-0905-2603-0613_soldiers_in_training_o.jpg",
                  history: "sdsdg\nfdfd\ndfdfdf",
                  category: .amrap,
                  video: "5soixb2U6xM",
                  unit: .metric)
        
        let challenge1 = Workout(id: 9, type: .challenge, name: "Mineriada", favorite: false, completed: false)
        let challenge2 = Workout(id: 10, type: .challenge, name: "Revolutia", favorite: false, completed: false)
        let challenge3 = Workout(id: 11, type: .challenge, name: "Razboi", favorite: true, completed: true)
        let challenge4 = Workout(id: 12, type: .challenge, name: "Butoi", favorite: false, completed: true)
        challenge1.set(description: "asfasf",
                       image: "http://www.missgloss.net/wp-content/uploads/2017/02/images1570909_k13.jpg",
                       history: nil,
                       category: .time,
                       video: "9bZkp7q19f0",
                       unit: .metric)
        challenge2.set(description: "asfasf",
                       image: "http://www.missgloss.net/wp-content/uploads/2017/02/images1570909_k13.jpg",
                       history: nil,
                       category: .time,
                       video: "9bZkp7q19f0",
                       unit: .metric)
        challenge3.set(description: "asfasf",
                       image: "http://www.missgloss.net/wp-content/uploads/2017/02/images1570909_k13.jpg",
                       history: nil,
                       category: .time,
                       video: "9bZkp7q19f0",
                       unit: .metric)
        challenge4.set(description: "asfasf",
                       image: "http://www.missgloss.net/wp-content/uploads/2017/02/images1570909_k13.jpg",
                       history: nil,
                       category: .time,
                       video: "9bZkp7q19f0",
                       unit: .metric)
        
        let open1 = Workout(id: 13, type: .open, name: "17.1", favorite: false, completed: false)
        let open2 = Workout(id: 14, type: .open, name: "17.2", favorite: true, completed: false)
        let open3 = Workout(id: 15, type: .open, name: "17.3", favorite: false, completed: false)
        open1.set(description: "asfasf",
                       image: "http://www.missgloss.net/wp-content/uploads/2017/02/images1570909_k13.jpg",
                       history: nil,
                       category: .time,
                       video: "9bZkp7q19f0",
                       unit: .metric)
        open2.set(description: "asfasf",
                       image: "http://www.missgloss.net/wp-content/uploads/2017/02/images1570909_k13.jpg",
                       history: nil,
                       category: .time,
                       video: "9bZkp7q19f0",
                       unit: .metric)
        open3.set(description: "asfasf",
                       image: "http://www.missgloss.net/wp-content/uploads/2017/02/images1570909_k13.jpg",
                       history: nil,
                       category: .time,
                       video: "9bZkp7q19f0",
                       unit: .metric)
        
        let custom1 = Workout(id: 16, type: .custom, name: "Minge", favorite: false, completed: true)
        let custom2 = Workout(id: 17, type: .custom, name: "Ninge", favorite: true, completed: true)
        let custom3 = Workout(id: 18, type: .custom, name: "Dadada", favorite: true, completed: false)
        custom1.set(description: "asfasasgg",
                    image: nil,
                    history: nil,
                    category: .time,
                    video: nil,
                    unit: .imperial)
        custom2.set(description: "asfasasgasgasg",
                    image: "http://www.missgloss.net/wp-content/uploads/2017/02/images1570909_k13.jpg",
                    history: nil,
                    category: .weight,
                    video: nil,
                    unit: .metric)
        custom3.set(description: "faffaff\nasfasf",
                    image: nil,
                    history: nil,
                    category: .weight,
                    video: "9bZkp7q19f0",
                    unit: .imperial)
        
        
        
        if UserManager.sharedInstance.isAuthenticated() {
            let workoutList = WorkoutList(workouts: [girl1, girl2, girl3, girl4, hero1, hero2, hero3, hero4, challenge1, challenge2, challenge3, challenge4, open1, open2, open3])
            workoutList.workouts.append(contentsOf: [custom1, custom2, custom3])
            completion?(.success(workoutList))
            
            return
        }
        
        girl1.isFavorite = false
        girl1.isCompleted = false
        girl4.isCompleted = false
        girl4.isFavorite = false
        hero1.isFavorite = false
        hero2.isCompleted = false
        hero4.isCompleted = false
        challenge3.isFavorite = false
        challenge3.isCompleted = false
        challenge4.isFavorite = false
        challenge4.isCompleted = false
        open2.isFavorite = false
        
        completion?(.success(WorkoutList(workouts: [girl1, girl2, girl3, girl4, hero1, hero2, hero3, hero4, challenge1, challenge2, challenge3, challenge4, open1, open2, open3])))
    }
    
    func getResults(for wod: Workout, with completion: GetResultsRequestCompletion?) {
        if wod.id! % 3 == 0 {
            let result1 = WODResult(with: 1,
                                    notes: nil,
                                    resultType: .time,
                                    time: 145,
                                    weight: nil,
                                    rounds: nil,
                                    rx: true,
                                    photoUrl: nil,
                                    date: "2010-04-10T11:53:22.249Z",
                                    updated_at: "2017-03-15T22:57:51.999")
            let result2 = WODResult(with: 2,
                                    notes: "asfasgas\nasasg\n",
                                    resultType: .weight,
                                    time: nil,
                                    weight: 143.4,
                                    rounds: nil,
                                    rx: false,
                                    photoUrl: "https://static1.squarespace.com/static/52744342e4b0a23a823b28aa/t/527965dbe4b0a1d3976126d3/1453143228095/WOD+Motivation+High-Res+copy.jpg",
                                    date: "2017-04-10T11:53:22.249Z",
                                    updated_at: "2017-01-16T22:57:51.999")
            let result3 = WODResult(with: 3,
                                    notes: "asfasgas\nasasg\n",
                                    resultType: .amrap,
                                    time: nil,
                                    weight: nil,
                                    rounds: 70,
                                    rx: false,
                                    photoUrl: "https://static1.squarespace.com/static/52744342e4b0a23a823b28aa/t/527965dbe4b0a1d3976126d3/1453143228095/WOD+Motivation+High-Res+copy.jpg",
                                    date: "2015-02-10T11:53:22.249Z",
                                    updated_at: "2017-022-16T22:57:51.999")
            let result4 = WODResult(with: 100,
                                    notes: "asfasgas\nasasg\n",
                                    resultType: .amrap,
                                    time: nil,
                                    weight: nil,
                                    rounds: 700,
                                    rx: false,
                                    photoUrl: "https://static1.squarespace.com/static/52744342e4b0a23a823b28aa/t/527965dbe4b0a1d3976126d3/1453143228095/WOD+Motivation+High-Res+copy.jpg",
                                    date: "2015-02-10T11:53:22.249Z",
                                    updated_at: "2017-04-16T22:57:51.999")
            completion?(.success([result1, result2, result3, result4]))
        } else if wod.id! % 3 == 1 {
            let result1 = WODResult(with: 4,
                                    notes: nil,
                                    resultType: .time,
                                    time: 30,
                                    weight: nil,
                                    rounds: nil,
                                    rx: true,
                                    photoUrl: nil,
                                    date: "2016-04-10T11:53:22.249Z",
                                    updated_at: "2015-05-10T11:53:22.249Z")
            let result2 = WODResult(with: 5,
                                    notes: "asfasgas\nasasg\n",
                                    resultType: .weight,
                                    time: nil,
                                    weight: 143.4,
                                    rounds: nil,
                                    rx: false,
                                    photoUrl: "https://static1.squarespace.com/static/52744342e4b0a23a823b28aa/t/527965dbe4b0a1d3976126d3/1453143228095/WOD+Motivation+High-Res+copy.jpg",
                                    date: "2017-03-15T11:51:22.249Z",
                                    updated_at: "2017-01-16T22:57:51.999")
            completion?(.success([result1, result2]))
        } else {
           completion?(.success([]))
        }
    }
}

class WODListRemoteServiceImpl: WODListRemoteService {
    func getWodsList(with completion: GetWodsRequestCompletion?) {
        if UserManager.sharedInstance.isAuthenticated() {
            getUserWods(with: completion)
            return
        }
        
        getDefaultWods(with: completion)
    }
    
    func getResults(for wod: Workout, with completion: GetResultsRequestCompletion?) {
        if !UserManager.sharedInstance.isAuthenticated() {
            completion?(.success([WODResult]()))
            return
        }
        let request = GetWodResultRequest(with: wod.id!)
        
        request.success = { _, result in
            guard let resultDict = result as? [String: Any] else {
                completion?(.success([]))
                return
            }

            guard let resultsArray = resultDict["wod_results"] as? [[String: Any]] else {
                completion?(.success([]))
                return
            }
            
            var results = [WODResult]()
            for resultDict in resultsArray {
                let wodResult = WODResult(from: resultDict, with: wod.category)
                results.append(wodResult)
            }
            
            completion?(.success(results))
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        request.runRequest()
    }
    
    // MARK: - Private Methods
    
    private func getUserWods(with completion: GetWodsRequestCompletion?) {
        let request = GetWodsRequest()
        
        request.success = { _, recvResponse in
            guard let response = recvResponse as? [String: Any] else {
                completion?(.success(WorkoutList()))
                return
            }
            
            guard let wods = response["wods"] as? [[String: Any]] else {
                completion?(.success(WorkoutList()))
                return
            }
            
            let workouts = self.createWorkoutArray(from: wods)
            
            completion?(.success(WorkoutList(workouts: workouts)))
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        request.runRequest()
    }
    
    private func getDefaultWods(with completion: GetWodsRequestCompletion?) {
        let request = GetDefaultWodsRequest()
        
        request.success = { _, response in
            guard let response = response as? [String: Any] else {
                completion?(.success(WorkoutList()))
                return
            }
            
            guard let defaultWods = response["default_wods"] as? [[String: Any]] else {
                completion?(.success(WorkoutList()))
                return
            }
            
            let workouts = self.createWorkoutArray(from: defaultWods)
            
            completion?(.success(WorkoutList(workouts: workouts)))
        }
        
        request.error = { _, error in
            completion?(.failure(error))
        }
        
        request.runRequest()
    }
    
    private func createWorkoutArray(from wodsArray: [[String: Any]]) -> [Workout] {
        var workouts = [Workout]()
        for wodDict in wodsArray {
            let newWorkout = Workout(from: wodDict)
            workouts.append(newWorkout)
        }
        
        return workouts
    }
}
