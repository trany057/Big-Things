//
//# Author:    Tran Ngoc Thien Kim
//# Email Id:   TRANY057
//# Description:  Big Things, IOS assignment 2
//# This is my own work as defined by the University's Academic Misconduct policy.

import UIKit

class CustomDialogView: UIView {

    private let textView = UITextView()
    private let closeButton = UIButton()
    var onClose: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4

        textView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        textView.font = UIFont.systemFont(ofSize: 17)
        textView.isEditable = false
        textView.textAlignment = .justified
        addSubview(textView)

        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.backgroundColor = .mainTheme
        closeButton.layer.cornerRadius = 5
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        addSubview(closeButton)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),

            closeButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20),
            closeButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            closeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }

    @objc private func closeTapped() {
        onClose?()
        self.removeFromSuperview()
    }

    func configure(text: String) {
        textView.text = text
    }
}
