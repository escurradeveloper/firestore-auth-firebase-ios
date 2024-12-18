//
//  ListTableViewCell.swift
//  Tema10Example1
//

//Para hacer el diseño y segue en modal revisar este video de muestra:
//https://www.udemy.com/course/aprende-swift-4-para-ios-11-y-lo-mejor-en-bases-de-datos/learn/lecture/8302047#overview


import UIKit

//clase de la celda
class ListTableViewCell: UITableViewCell {
    //componentes de la UI
    @IBOutlet weak var nameLabel: UILabel! //nombre
    @IBOutlet weak var phoneLabel: UILabel! //celular
    @IBOutlet weak var generalView: UIView! //vista general
    
    //funcion que se crea por defecto
    //es para inicializar valores
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    //funcion que se crea por defecto
    //si algo se selecciona
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //función para configurar la View
    func configureView() {
        // Initialization code
        generalView?.layer.shadowOffset = CGSize.zero //el generalView para que ocupe la posición 0
        generalView?.layer.shadowRadius = 1 //el generalView tenga una sombra con tamaño 1
        generalView?.layer.shadowOpacity = 1 //el generalView tenga una opacidad de 1
        generalView?.layer.cornerRadius = 40 //le ponemos de tamaño 20 al círculo de la view
    }
}
