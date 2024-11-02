//
//# Author:    Tran Ngoc Thien Kim
//# Email Id:   TRANY057
//# Description:  Big Things, IOS assignment 2
//# This is my own work as defined by the University's Academic Misconduct policy.

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.navigateToNextScreen()
        }
    }

    private func navigateToNextScreen() {
        performSegue(withIdentifier: "pushToMainView", sender: self)
    }
}
