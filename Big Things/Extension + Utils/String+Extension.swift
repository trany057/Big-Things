//
//# Author:    Tran Ngoc Thien Kim
//# Email Id:   TRANY057
//# Description:  Big Things, IOS assignment 2
//# This is my own work as defined by the University's Academic Misconduct policy.

extension String {
    func capitalizedFirstLetter() -> String {
        guard let firstLetter = self.first else {
            return self
        }
        let capitalizedFirstLetter = String(firstLetter).uppercased()
        let remainingString = self.dropFirst()
        return capitalizedFirstLetter + remainingString
    }
}
