//
//  ViewController.swift
//  StretchySnacks
//
//  Created by Luiz on 6/13/19.
//  Copyright © 2019 Luiz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var menuHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var snackTableView: UITableView!
    @IBOutlet weak var menuView: UIView!
    
    //MARK: - Properties
    let snacksMenu :[Snack] = [Snack(For: "Oreos", imageName: "oreos"),
                               Snack(For: "Pizza pockets", imageName: "pizza_pockets"),
                               Snack(For: "Pop tarts", imageName: "pop_tarts"),
                               Snack(For: "Popsicle", imageName: "popsicle"),
                               Snack(For: "Ramen", imageName: "ramen")]

    var snackList : [Snack] = []
    var isMenuOpen = false
    var imageViewArray = [UIImageView]()
    var stackView : UIStackView! = nil

    //MARK: - ViewDidLoad Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        for snack in snacksMenu {
            let menuItem = UIImageView(image: snack.image)
            self.imageViewArray.append(menuItem)
        }
        createStackView()
    }


    func createStackView() {
        stackView = UIStackView(arrangedSubviews: imageViewArray)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5
        let gestureRecognize = UITapGestureRecognizer(target: self, action: #selector(addSnackIntoTableView(_:)) )
        stackView.addGestureRecognizer(gestureRecognize)
        menuView.addSubview(stackView)


        let trainling = stackView.trailingAnchor.constraint(equalTo: menuView.trailingAnchor)
        let leading = stackView.leadingAnchor.constraint(equalTo: menuView.leadingAnchor)
        let bottom = stackView.bottomAnchor.constraint(equalTo: menuView.bottomAnchor)
        let height = stackView.heightAnchor.constraint(equalToConstant: 100.0)
        trainling.isActive = true
        leading.isActive = true
        bottom.isActive = true
        height.isActive = true

        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.isHidden = true
    }


    //MARK: - Actions
    @IBAction func toggleMenu(_ sender: UIButton) {

        isMenuOpen = !isMenuOpen
        if isMenuOpen {
            stackView.isHidden = false
        } else {
            stackView.isHidden = true
        }

        animateMenu()
    }


    //MARK: -Methods
    private func animateMenu() {
        menuHeightConstraint.constant = isMenuOpen ? 200 : 64
        titleLabel.text = isMenuOpen ? "Add a Snack" : "SNACKS"
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 4.0,
                       options: .curveEaseIn,
                       animations: {
                        self.view.layoutIfNeeded()
                        let angle = self.isMenuOpen ? CGFloat.pi/4 : 0.0
                        self.addButton.transform = CGAffineTransform(rotationAngle: angle)
                        if self.isMenuOpen {

                            self.titleLabel.transform = CGAffineTransform(translationX: 0, y: -40.0)
                        } else {
                            self.titleLabel.transform = CGAffineTransform.identity
                        }
        }, completion: nil)
    }

    @objc func addSnackIntoTableView(_ sender: UITapGestureRecognizer) {
        let stackView = sender.view as! UIStackView
        let point = sender.location(in: stackView)
        var tappedView: UIView? = nil
        for subview in stackView.arrangedSubviews {
            if subview.frame.contains(point) {
                tappedView = subview
                break
            }
        }
        if let tapped = tappedView as? UIImageView {
            if  let index = imageViewArray.firstIndex(of: tapped){
                let snack = snacksMenu[index]
                self.snackList.append(snack)
                self.snackTableView.reloadData()
            }


        }

    }


}

//MARK: - Extensions

//MARK: TableViewDelegate
extension ViewController: UITableViewDelegate {

}

//MARK: TableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snackList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let snack = snackList[indexPath.row]
        cell.imageView?.image = snack.image
        cell.textLabel?.text = snack.name
        return cell
    }

    
}
