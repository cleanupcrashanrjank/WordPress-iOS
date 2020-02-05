class ActionButton: UIView {

    private enum Constants {
        static let size: CGFloat = 56
        static let spacing: CGFloat = 8
        static let borderColor = UIColor.secondaryButtonBorder
        static let backgroundColor = UIColor.secondaryButtonBackground
        static let selectedBackgroundColor = UIColor.secondaryButtonDownBackground
        static let iconColor = UIColor.text
    }

    private let button: UIButton = {
        let button = RoundedButton(type: .custom)
        button.borderColor = Constants.borderColor
        button.borderWidth = 1
        button.backgroundColor = Constants.backgroundColor
        button.selectedBackgroundColor = Constants.selectedBackgroundColor
        button.tintColor = Constants.iconColor
        button.imageView?.contentMode = .scaleAspectFill
        button.cornerRadius = Constants.size/2
        return button
    }()

    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontForContentSizeCategory = true
        return titleLabel
    }()

    private var callback: (() -> Void)?

    convenience init(image: UIImage, title: String, tapped: @escaping () -> Void) {

        self.init(frame: .zero)

        button.setImage(image, for: .normal)
        titleLabel.text = title

        let stackView = UIStackView(arrangedSubviews: [
            button,
            titleLabel
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = Constants.spacing
        stackView.axis = .vertical

        callback = tapped
        button.addTarget(self, action: #selector(ActionButton.tapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: Constants.size),
            button.widthAnchor.constraint(equalToConstant: Constants.size)
        ])

        addSubview(stackView)

        pinSubviewToAllEdges(stackView)
    }

    @objc func tapped() {
        callback?()
    }
}

class ActionRow: UIStackView {

    struct Item {
        let image: UIImage
        let title: String
        let tapped: () -> Void
    }

    convenience init(items: [Item]) {

        let buttons = items.map({ item in
            return ActionButton(image: item.image, title: item.title, tapped: item.tapped)
        })

        self.init(arrangedSubviews: buttons)

        distribution = .equalSpacing
        translatesAutoresizingMaskIntoConstraints = false
    }
}
