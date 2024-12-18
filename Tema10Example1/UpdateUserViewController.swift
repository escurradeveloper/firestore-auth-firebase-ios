//
//  UpdateUserViewController.swift
//  Tema10Example1
//
import UIKit //importamos la UI
import Firebase //importamos a Firebase para la base de datos fire store

//Creamos un protocolo para recargar la tabla al actualizar los datos y va hacer de tipo AnyObject es decir de cualquier objeto. Que quiere decir con eso: que este protocol lo vamos a llamar en esta clase.
//Protocol.- es un contrato en el cual se presenta variables y funciones para luego implementar su lógica.
protocol UpdateUserViewControllerDelegate: AnyObject {
    func reloadData() //función para recargar los datos
}

//clase padre
class UpdateUserViewController: UIViewController {
    //componentes de la UI
    @IBOutlet weak var nameEditTextField: UITextField! //nombre
    @IBOutlet weak var phoneEditTextField: UITextField! //celular
    
    //variables
    var ref: DocumentReference? //lo que viene del firebase
    var id: String = "" // id de tipo string
    var updateUser: User? //para actualizar los datos del usuario
    weak var delegate: UpdateUserViewControllerDelegate? //creamos la variable para llamar a sus funciones del protocolo. ¿Por qué weak? Porque es un requisito ponerlo asi cuando se usa los protocolos en las clases.
    
    //carga en memoria
    override func viewDidLoad() {
        super.viewDidLoad()
        configureData() //llamamos a la función para la configuración de los datos
    }
    
    //funciones
    //función para configurar los datos
    func configureData() {
        nameEditTextField.text = updateUser?.name ?? "" //le pasamos el nombre que viene de la pantalla anterior al textField
        phoneEditTextField.text = updateUser?.phone ?? "" //le pasamos el cellular que viene de la pantalla anterior al textField
        id = updateUser?.id ?? "" //le pasamos el id que viene de firebase a la variable id de tipo string
        ref = Firestore.firestore().collection("users").document(id) //llamamos a la base de datos que se ha creado en firebase
    }
    
    //función para editar a los usuarios
    func editUserFirebase() {
        let fields: [String: Any] = ["name": nameEditTextField.text ?? "", "phone": phoneEditTextField.text ?? ""] //campos a escribir en el teclado de IOS: nombre y celular en la base de datos de firebase
        ref?.setData(fields) { (error) in //le pasamos la información
            if let error = error?.localizedDescription { //si se presenta algún error
                print("Fallo al actualizar: \(error)") //imprimimos en consola
            } else {
                print("Se actualizó") //print correcto
                self.delegate?.reloadData() //acá llamamos a la función del protocolo a implementar
                self.dismiss(animated: true, completion: nil) //hacemos un retorno a la vista anterior
            }
        }
    }
    
    //accciones
    //acción del botón actualizar
    @IBAction func didTapUpdate(_ sender: UIButton) {
        editUserFirebase() //llamamos a la función para actualizar a los usuarios
    }
    
    //acción del botón cancelar
    @IBAction func didTapCancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil) //hacemos un retorno a la vista anterior
    }
}
