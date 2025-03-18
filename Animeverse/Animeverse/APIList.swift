
struct APIList
{
    static let baseURL = "http://localhost/Animeverse_Backend/"

    static let login = baseURL + "login.php"
    static let signUp = baseURL + "register.php"
    static let forgotPassword = baseURL + "forgotpassword.php"
    static let ViewProfile = baseURL + "view.php"
    static let ChangeProfile = baseURL + "changeprofile.php"
    static let AddFavorite = baseURL + "addfavourite.php"
    static let RemoveFavorite = baseURL + "removefavourite.php"
    static let GetFavorites = baseURL + "getfavourite.php"
    
}

class Constants {
    static var loginResponse: LoginResponse?
}
