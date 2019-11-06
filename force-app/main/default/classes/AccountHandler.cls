public class AccountHandler {
    public static Account insertNewAccount(String accValue){
        
        Account newAcc = new Account(Name=accValue);
        try{
            insert newAcc;
        }
       catch (DmlException e) {
            return null;
        }
    return newAcc;
    }
}