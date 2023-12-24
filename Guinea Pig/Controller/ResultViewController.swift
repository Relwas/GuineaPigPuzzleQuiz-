//
//  ResultViewController.swift
//  Guinea Pig
//
//  Created by relwas on 24/12/23.
//

import UIKit

class ResultViewController: UIViewController {
    private let correctAnswers: Int
    var completion: (() -> Void)?
    var tryAgainCallback: (() -> Void)?

    init(correctAnswers: Int) {
        self.correctAnswers = correctAnswers
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
