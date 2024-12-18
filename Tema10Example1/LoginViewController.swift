//
//  LoginViewController.swift
//  Tema10Example1
//

import UIKit //importamos la UI
import FirebaseAuth //importamos la libería de firebase para autenticarnos

//clase padre
class LoginViewController: UIViewController {
    //componentes de la UI
    @IBOutlet weak var emailTextField: UITextField! //email
    @IBOutlet weak var passwordTextField: UITextField! //contraseña
    
    //carga en memoria
    override func viewDidLoad() {
        super.viewDidLoad()
        getUser() //llamamos a la función para ver si estamos logueados o no
    }
    
    //funciones
    //función para navegar al HomeViewController
    func goToPush() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main) //llamamos al storyboard
        let viewcontroller = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController //llamamos e instanciamos al HomeViewController
        viewcontroller?.modalPresentationStyle = .overFullScreen //ponemos una presentación a la vista
        self.present(viewcontroller ?? ViewController(), animated: true, completion: nil) //presentamos la vista del viewController
    }
    
    //función para crear una alerta
    func configureAlert() {
        //creamos una alerta simple pasandole título y mensajes
        let alertController = UIAlertController(title: "Mensaje de error", message: "Email o contraseña incorrecto", preferredStyle: .alert)
        //agregamos los botones a la alerta
        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
        //presentamos la alerta
        self.present(alertController, animated: true, completion: nil)
    }
    
    //función para ver si estamos logueados o no
    func getUser() {
        //llamamos a la librería de firebase que se encarga de eso
        let _ = Auth.auth().addStateDidChangeListener { auth, user in
            //si no estamos loguedos que presenta una impresión por consola
            if user == nil {
                print("no login")
            } else {
                //si es que esta logueado
                self.goToPush() //llamamos la función para navegar a la otra vista
            }
        }
    }
    
    //función de login en firebase
    func loginWithFirebase(email: String, password: String) {
        //llamamos a la librería de Firebase para hacer login
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return } //opcional
            //si es que hay un error
            if error != nil {
                configureAlert() //llamamos a la función de alerta
            } else {
                self.goToPush() //llamamos la función para navegar a la otra vista
            }
        }
    }
    
    //función para el registro de usuario en firebase
    func registerWithFirebase(email: String, password: String) {
        //llamamos a la librería de Firebase para crear al usuario
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return } //opcional
            //si es que hay un error
            if error != nil {
                configureAlert() //llamamos a la función de alerta
            } else {
                self.goToPush() //llamamos la función para navegar a la otra vista
            }
        }
    }
    
    //función de login
    func loginUser() {
        let email = emailTextField.text ?? "" //email
        let password = passwordTextField.text ?? "" //contraseña
        loginWithFirebase(email: email, password: password) //llamamos a la función de login de firebase
    }
    
    //función de registro
    func registerUser() {
        let email = emailTextField.text ?? "" //email
        let password = passwordTextField.text ?? "" //contraseña
        registerWithFirebase(email: email, password: password) //llamamos a la función de registro de firebase
    }
    
    //acciones
    //login
    @IBAction func didTapLogin(_ sender: UIButton) {
        loginUser() //llamamos a la función de login
    }
    
    //registro
    @IBAction func didTapRegister(_ sender: UIButton) {
        registerUser() //llamamos a la función de registro
    }
}
