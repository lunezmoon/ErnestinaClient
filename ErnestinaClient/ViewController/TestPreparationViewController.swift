//
//  TestPreparationViewController.swift
//  ErnestinaClient
//
//  Created by 針谷ひろき on 2018/07/23.
//  Copyright © 2018年 test. All rights reserved.
//

import UIKit
import MBCircularProgressBar

struct Question {
    let img: UIImage
    let questionText: String
    let options: [String]
    let correctAns: Int
    var wrongAns: Int
    var isAnswered: Bool
}

class TestPreparationViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var myCollectionView: UICollectionView!
    var questionsArray = [Question]()
    var score: Int = 0
    var currentQuestionNumber = 1
    var addProgressValue = 0
    
    var window: UIWindow?
    
    var lectureDataId:String = ""
    var lectureTitle:String = ""
    var testPreparationDictionaryArray:Array<Dictionary<String,String>> = []
    var testResultsArray: Array<Dictionary<String,String>> = []
    
    let borderAlpha : CGFloat = 0.7
    
    @IBOutlet weak var testPreparationCollectionView: UICollectionView!
    @IBOutlet weak var circularProgressBar: MBCircularProgressBarView!
    
    @IBOutlet weak var circularProgressBarLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //circularProgressBar.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).cgColor
        //circularProgressBar.layer.borderWidth = 0.7
        circularProgressBar.layer.cornerRadius = 4.0;
        circularProgressBar.clipsToBounds = true;
        //circularProgressBar.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        circularProgressBar.backgroundColor = UIColor.clear
        
        /*
        let restWatsonDiscoveryConnector = RestWatsonDiscoveryConnector()
        let queryResults = restWatsonDiscoveryConnector.query(lectureDataId: lectureDataId, query: "")
        
        let enrichedText = queryResults[0]["enriched_text"] as? [String:Any]
        let concepts = enrichedText?["concepts"] as? [[String:Any]]
        
        if (concepts!.count != 0) {
            
            for i in 0..<concepts!.count {
                let restDbpediaConnector = RestDbpediaConnector()

                let concept = concepts?[i]["text"] as! String
                let conceptInformation = restDbpediaConnector.getInformation(label: concept)
                let conceptInformationResults = conceptInformation["results"] as? [String:Any]
                let conceptInformationBindings = conceptInformationResults!["bindings"] as? [[String:Any]]
                let conceptInformationLabel = conceptInformationBindings![0]["label"] as? [String:String]
                //let conceptInformationComment = conceptInformationBindings![0]["comment"] as? [String:String]
                let conceptInformationThumbnail = conceptInformationBindings![0]["thumbnail"] as? [String:String]
            
                let naturalQueryResults = restWatsonDiscoveryConnector.naturalLanguageQuery(lectureDataId: lectureDataId, query: concept)
                let passages = (naturalQueryResults["passages"] as? [[String:Any]])!
            
                var customSearchDataDictionary:Dictionary<String,String> = [:]
                customSearchDataDictionary["keyword"] = conceptInformationLabel!["value"]
                if (conceptInformationThumbnail != nil) {
                    customSearchDataDictionary["imageURL"] = conceptInformationThumbnail!["value"]
                } else {
                    customSearchDataDictionary["imageURL"] = "https://dubsism.files.wordpress.com/2017/12/image-not-found.png"
                }
                customSearchDataDictionary["passage"] = passages[0]["passage_text"] as? String
            
                testPreparationDictionaryArray.append(customSearchDataDictionary)
            }
        }
        
        self.title="Home"
        self.view.backgroundColor=UIColor.black
        let image: UIImage = UIImage(named: "Sunset_Background")!
        let imageView = UIImageView(image: image)
        imageView.frame = self.view.bounds
        imageView.alpha = 0.7
        view.addSubview(imageView)
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        myCollectionView=UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), collectionViewLayout: layout)
        myCollectionView.delegate=self
        myCollectionView.dataSource=self
        myCollectionView.register(TestPreparationCustomCell.self, forCellWithReuseIdentifier: "Cell")
        myCollectionView.showsHorizontalScrollIndicator = false
        myCollectionView.translatesAutoresizingMaskIntoConstraints=false
        myCollectionView.backgroundColor=UIColor.clear
        myCollectionView.isPagingEnabled = true
        
        self.view.addSubview(myCollectionView)
        
        for i in 0..<testPreparationDictionaryArray.count {
            var customSearchDataDictionary = testPreparationDictionaryArray[i]
            var passage = customSearchDataDictionary["passage"]!
            let keyword = customSearchDataDictionary["keyword"]!
            let imageURLString = customSearchDataDictionary["imageURL"]!
            
            let url = URL(string: imageURLString)
            let imageData = try! Data(contentsOf: url!)
            let image = UIImage(data: imageData)
            
            let range = passage.range(of: keyword)
            
            if (range != nil) {
                passage = passage.replacingCharacters(in: range!, with: "(        )")
                
                let randomNumberForAns = Int(arc4random_uniform(4))
                
                var otherAns1 = ""
                var otherAns2 = ""
                var otherAns3 = ""
                
                print("count array " + String(testPreparationDictionaryArray.count))
                
                while (otherAns1 == "") {
                    print(1)
                    let randomNumberForOtherAns = Int(arc4random_uniform(UInt32(testPreparationDictionaryArray.count)))
                    print("random number for ans1 " + String(randomNumberForOtherAns))
                    customSearchDataDictionary = testPreparationDictionaryArray[randomNumberForOtherAns]
                    if (customSearchDataDictionary["keyword"] != keyword) {
                        otherAns1 = customSearchDataDictionary["keyword"]!
                    }
                }
                
                while (otherAns2 == "") {
                    print(2)
                    let randomNumberForOtherAns = Int(arc4random_uniform(UInt32(testPreparationDictionaryArray.count)))
                    print("random number for ans2 " + String(randomNumberForOtherAns))
                    customSearchDataDictionary = testPreparationDictionaryArray[randomNumberForOtherAns]
                    if (customSearchDataDictionary["keyword"] != keyword && customSearchDataDictionary["keyword"] != otherAns1) {
                        otherAns2 = customSearchDataDictionary["keyword"]!
                    }
                    
                }
                
                while (otherAns3 == "") {
                    print(3)
                    let randomNumberForOtherAns = Int(arc4random_uniform(UInt32(testPreparationDictionaryArray.count)))
                    print("random number for ans3 " + String(randomNumberForOtherAns))
                    customSearchDataDictionary = testPreparationDictionaryArray[randomNumberForOtherAns]
                    if (customSearchDataDictionary["keyword"] != keyword &&
                        customSearchDataDictionary["keyword"] != otherAns1 &&
                        customSearchDataDictionary["keyword"] != otherAns2) {
                        otherAns3 = customSearchDataDictionary["keyword"]!
                    }
                }
                
                if (randomNumberForAns == 0) {
                    let que = Question(img: image!, questionText: passage, options: [keyword, otherAns1, otherAns2, otherAns3], correctAns: randomNumberForAns, wrongAns: -1, isAnswered: false)
                    questionsArray.append(que)
                    
                }
                else if (randomNumberForAns == 1) {
                    let que = Question(img: image!, questionText: passage, options: [otherAns1, keyword, otherAns2, otherAns3], correctAns: randomNumberForAns, wrongAns: -1, isAnswered: false)
                    questionsArray.append(que)
                }
                else if (randomNumberForAns == 2) {
                    let que = Question(img: image!, questionText: passage, options: [otherAns1, otherAns2, keyword, otherAns3], correctAns: randomNumberForAns, wrongAns: -1, isAnswered: false)
                    questionsArray.append(que)
                }
                else {
                    let que = Question(img: image!, questionText: passage, options: [otherAns1, otherAns2, otherAns3, keyword], correctAns: randomNumberForAns, wrongAns: -1, isAnswered: false)
                    questionsArray.append(que)
                }
            }
        }
        setupViews()
        */
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        DispatchQueue.global(qos: .background).async {
            
            let restWatsonDiscoveryConnector = RestWatsonDiscoveryConnector()
            let queryResults = restWatsonDiscoveryConnector.query(lectureDataId: self.lectureDataId, query: "")
            
            let enrichedText = queryResults[0]["enriched_text"] as? [String:Any]
            let concepts = enrichedText?["concepts"] as? [[String:Any]]
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1.0){
                    self.circularProgressBar.value = 30
                }
            }
            
            if (concepts!.count != 0) {
                for i in 0..<concepts!.count {
                    let restDbpediaConnector = RestDbpediaConnector()
                    
                    let concept = concepts?[i]["text"] as! String
                    let conceptInformation = restDbpediaConnector.getInformation(label: concept)
                    let conceptInformationResults = conceptInformation["results"] as? [String:Any]
                    let conceptInformationBindings = conceptInformationResults!["bindings"] as? [[String:Any]]
                    let conceptInformationLabel = conceptInformationBindings![0]["label"] as? [String:String]
                    //let conceptInformationComment = conceptInformationBindings![0]["comment"] as? [String:String]
                    let conceptInformationThumbnail = conceptInformationBindings![0]["thumbnail"] as? [String:String]
                    
                    let naturalQueryResults = restWatsonDiscoveryConnector.naturalLanguageQuery(lectureDataId: self.lectureDataId, query: concept)
                    let passages = (naturalQueryResults["passages"] as? [[String:Any]])!
                    
                    var customSearchDataDictionary:Dictionary<String,String> = [:]
                    customSearchDataDictionary["keyword"] = conceptInformationLabel!["value"]
                    if (conceptInformationThumbnail != nil) {
                        customSearchDataDictionary["imageURL"] = conceptInformationThumbnail!["value"]
                    } else {
                        customSearchDataDictionary["imageURL"] = "https://dubsism.files.wordpress.com/2017/12/image-not-found.png"
                    }
                    customSearchDataDictionary["passage"] = passages[0]["passage_text"] as? String
                    
                    self.testPreparationDictionaryArray.append(customSearchDataDictionary)
                    
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 1.0){
                            self.circularProgressBar.value = self.circularProgressBar.value + 30/CGFloat(concepts!.count)
                        }
                    }
                }
            }
            
            for i in 0..<self.testPreparationDictionaryArray.count {
                var customSearchDataDictionary = self.testPreparationDictionaryArray[i]
                var passage = customSearchDataDictionary["passage"]!
                let keyword = customSearchDataDictionary["keyword"]!
                let imageURLString = customSearchDataDictionary["imageURL"]!
                
                let url = URL(string: imageURLString)
                let imageData = try! Data(contentsOf: url!)
                let image = UIImage(data: imageData)
                
                let range = passage.range(of: keyword)
                
                if (range != nil) {
                    passage = passage.replacingCharacters(in: range!, with: "(        )")
                    
                    let randomNumberForAns = Int(arc4random_uniform(4))
                    
                    var otherAns1 = ""
                    var otherAns2 = ""
                    var otherAns3 = ""
                    
                    print("count array " + String(self.testPreparationDictionaryArray.count))
                    
                    while (otherAns1 == "") {
                        print(1)
                        let randomNumberForOtherAns = Int(arc4random_uniform(UInt32(self.testPreparationDictionaryArray.count)))
                        print("random number for ans1 " + String(randomNumberForOtherAns))
                        customSearchDataDictionary = self.testPreparationDictionaryArray[randomNumberForOtherAns]
                        if (customSearchDataDictionary["keyword"] != keyword) {
                            otherAns1 = customSearchDataDictionary["keyword"]!
                        }
                    }
                    
                    while (otherAns2 == "") {
                        print(2)
                        let randomNumberForOtherAns = Int(arc4random_uniform(UInt32(self.testPreparationDictionaryArray.count)))
                        print("random number for ans2 " + String(randomNumberForOtherAns))
                        customSearchDataDictionary = self.testPreparationDictionaryArray[randomNumberForOtherAns]
                        if (customSearchDataDictionary["keyword"] != keyword && customSearchDataDictionary["keyword"] != otherAns1) {
                            otherAns2 = customSearchDataDictionary["keyword"]!
                        }
                        
                    }
                    
                    while (otherAns3 == "") {
                        print(3)
                        let randomNumberForOtherAns = Int(arc4random_uniform(UInt32(self.testPreparationDictionaryArray.count)))
                        print("random number for ans3 " + String(randomNumberForOtherAns))
                        customSearchDataDictionary = self.testPreparationDictionaryArray[randomNumberForOtherAns]
                        if (customSearchDataDictionary["keyword"] != keyword &&
                            customSearchDataDictionary["keyword"] != otherAns1 &&
                            customSearchDataDictionary["keyword"] != otherAns2) {
                            otherAns3 = customSearchDataDictionary["keyword"]!
                        }
                    }
                    
                    if (randomNumberForAns == 0) {
                        let que = Question(img: image!, questionText: passage, options: [keyword, otherAns1, otherAns2, otherAns3], correctAns: randomNumberForAns, wrongAns: -1, isAnswered: false)
                        self.questionsArray.append(que)
                        
                    }
                    else if (randomNumberForAns == 1) {
                        let que = Question(img: image!, questionText: passage, options: [otherAns1, keyword, otherAns2, otherAns3], correctAns: randomNumberForAns, wrongAns: -1, isAnswered: false)
                        self.questionsArray.append(que)
                    }
                    else if (randomNumberForAns == 2) {
                        let que = Question(img: image!, questionText: passage, options: [otherAns1, otherAns2, keyword, otherAns3], correctAns: randomNumberForAns, wrongAns: -1, isAnswered: false)
                        self.questionsArray.append(que)
                    }
                    else {
                        let que = Question(img: image!, questionText: passage, options: [otherAns1, otherAns2, otherAns3, keyword], correctAns: randomNumberForAns, wrongAns: -1, isAnswered: false)
                        self.questionsArray.append(que)
                    }
                }
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 1.0){
                        self.circularProgressBar.value = self.circularProgressBar.value + 30/CGFloat(self.testPreparationDictionaryArray.count)
                    }
                }
            }
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1.0, animations: {
                    self.circularProgressBar.value = 100
                }, completion: {(finished:Bool) in
                    sleep(2)
                    self.circularProgressBarLabel.isHidden = true
                    self.circularProgressBar.isHidden = true
                    self.title="Home"
                    self.view.backgroundColor=UIColor.black
                    let image: UIImage = UIImage(named: "Sunset_Background")!
                    let imageView = UIImageView(image: image)
                    imageView.frame = self.view.bounds
                    imageView.alpha = 0.7
                    self.view.addSubview(imageView)
                    
                    let layout = UICollectionViewFlowLayout()
                    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                    layout.itemSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
                    layout.scrollDirection = .horizontal
                    layout.minimumLineSpacing = 1
                    layout.minimumInteritemSpacing = 1
                    
                    self.myCollectionView=UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), collectionViewLayout: layout)
                    self.myCollectionView.delegate=self
                    self.myCollectionView.dataSource=self
                    self.myCollectionView.register(TestPreparationCustomCell.self, forCellWithReuseIdentifier: "Cell")
                    self.myCollectionView.showsHorizontalScrollIndicator = false
                    self.myCollectionView.translatesAutoresizingMaskIntoConstraints=false
                    self.myCollectionView.backgroundColor=UIColor.clear
                    self.myCollectionView.isPagingEnabled = true
                    
                    self.view.addSubview(self.myCollectionView)
                    
                    self.setupViews()
                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questionsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TestPreparationCustomCell
        cell.question=questionsArray[indexPath.row]
        cell.delegate=self
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setQuestionNumber()
    }
    
    func setQuestionNumber() {
        let x = myCollectionView.contentOffset.x
        let w = myCollectionView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        if currentPage < questionsArray.count {
            lblQueNumber.text = "Question: \(currentPage+1) / \(questionsArray.count)"
            currentQuestionNumber = currentPage + 1
        }
    }
    
    @objc func btnPrevNextAction(sender: UIButton) {
        if sender == btnNext && currentQuestionNumber == questionsArray.count {
            let v = TestPreparationResultViewController()
            v.score = score
            v.totalScore = questionsArray.count
            //self.navigationController?.pushViewController(v, animated: false)
            print(testResultsArray)
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "toTestPreparationResultViewSegue", sender: sender)
            }
            return
        }
        
        let collectionBounds = self.myCollectionView.bounds
        var contentOffset: CGFloat = 0
        if sender == btnNext {
            contentOffset = CGFloat(floor(self.myCollectionView.contentOffset.x + collectionBounds.size.width))
            currentQuestionNumber += currentQuestionNumber >= questionsArray.count ? 0 : 1
        } else {
            contentOffset = CGFloat(floor(self.myCollectionView.contentOffset.x - collectionBounds.size.width))
            currentQuestionNumber -= currentQuestionNumber <= 0 ? 0 : 1
        }
        self.moveToFrame(contentOffset: contentOffset)
        lblQueNumber.text = "Question: \(currentQuestionNumber) / \(questionsArray.count)"
    }
    
    func moveToFrame(contentOffset : CGFloat) {
        let frame: CGRect = CGRect(x : contentOffset ,y : self.myCollectionView.contentOffset.y ,width : self.myCollectionView.frame.width,height : self.myCollectionView.frame.height)
        self.myCollectionView.scrollRectToVisible(frame, animated: true)
    }
    
    func setupViews() {
        myCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive=true
        myCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive=true
        myCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive=true
        myCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive=true
        
        self.view.addSubview(btnPrev)
        btnPrev.heightAnchor.constraint(equalToConstant: 50).isActive=true
        btnPrev.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive=true
        btnPrev.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive=true
        btnPrev.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive=true
        
        self.view.addSubview(btnNext)
        btnNext.heightAnchor.constraint(equalTo: btnPrev.heightAnchor).isActive=true
        btnNext.widthAnchor.constraint(equalTo: btnPrev.widthAnchor).isActive=true
        btnNext.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive=true
        btnNext.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive=true
        
        self.view.addSubview(lblQueNumber)
        lblQueNumber.heightAnchor.constraint(equalToConstant: 20).isActive=true
        lblQueNumber.widthAnchor.constraint(equalToConstant: 150).isActive=true
        lblQueNumber.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive=true
        lblQueNumber.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80).isActive=true
        lblQueNumber.text = "Question: \(1) / \(questionsArray.count)"
        
        self.view.addSubview(lblScore)
        lblScore.heightAnchor.constraint(equalTo: lblQueNumber.heightAnchor).isActive=true
        lblScore.widthAnchor.constraint(equalTo: lblQueNumber.widthAnchor).isActive=true
        lblScore.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive=true
        lblScore.bottomAnchor.constraint(equalTo: lblQueNumber.bottomAnchor).isActive=true
        lblScore.text = "Score: \(score) / \(questionsArray.count)"
    }
    
    let btnPrev: UIButton = {
        let btn=UIButton()
        btn.setTitle("< Previous", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor=UIColor.orange.withAlphaComponent(0.7)
        btn.translatesAutoresizingMaskIntoConstraints=false
        btn.addTarget(self, action: #selector(btnPrevNextAction), for: .touchUpInside)
        return btn
    }()
    
    let btnNext: UIButton = {
        let btn=UIButton()
        btn.setTitle("Next >", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor=UIColor.purple.withAlphaComponent(0.7)
        btn.translatesAutoresizingMaskIntoConstraints=false
        btn.addTarget(self, action: #selector(btnPrevNextAction), for: .touchUpInside)
        return btn
    }()
    
    let lblQueNumber: UILabel = {
        let lbl=UILabel()
        lbl.text="0 / 0"
        lbl.textColor=UIColor.gray
        lbl.textAlignment = .left
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let lblScore: UILabel = {
        let lbl=UILabel()
        lbl.text="0 / 0"
        lbl.textColor=UIColor.gray
        lbl.textAlignment = .right
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
}

extension TestPreparationViewController: TestPreparationCustomCellDelegate {
    func didChooseAnswer(btnIndex: Int) {
        let centerIndex = getCenterIndex()
        guard let index = centerIndex else { return }
        questionsArray[index.item].isAnswered=true
        if questionsArray[index.item].correctAns != btnIndex {
            questionsArray[index.item].wrongAns = btnIndex
            score -= 0
        } else {
            score += 1
        }
        lblScore.text = "Score: \(score) / \(questionsArray.count)"
        
        var testResultDictionary = [String:String]()
        testResultDictionary["option1"] = questionsArray[index.item].options[0]
        testResultDictionary["option2"] = questionsArray[index.item].options[1]
        testResultDictionary["option3"] = questionsArray[index.item].options[2]
        testResultDictionary["option4"] = questionsArray[index.item].options[3]
        testResultDictionary["passage"] = questionsArray[index.item].questionText
        testResultDictionary["correctAns"] = questionsArray[index.item].options[questionsArray[index.item].correctAns]
        testResultDictionary["selectedAns"] = questionsArray[index.item].options[btnIndex]
        testResultsArray.append(testResultDictionary)
        
        myCollectionView.reloadItems(at: [index])
    }
    
    func getCenterIndex() -> IndexPath? {
        let center = self.view.convert(self.myCollectionView.center, to: self.myCollectionView)
        let index = myCollectionView!.indexPathForItem(at: center)
        print(index ?? "index not found")
        return index
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTestPreparationResultViewSegue" {
            if let viewController = segue.destination as? TestPreparationResultViewController {
                viewController.score = score
                viewController.totalScore = questionsArray.count
                viewController.testResultsArray = testResultsArray
                viewController.lectureTitle = lectureTitle
            }
        }
    }
}
