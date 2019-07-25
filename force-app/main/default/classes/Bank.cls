public class Bank {
    
    public string bankName;
    public string phone;
    public string accountNumber;
    public void accountdetail(String accountHolder, string maritalStatus){
        system.debug('Account holder name is: '+accountholder);
        system.debug('Account holder mariatl status is: '+maritalStatus);
        bankName = 'Bank of Baroda';
        phone = '9990691660';
        accountNumber = 'acc-ICICI01- 21305100035046';
        system.debug('Bank name is: '+bankName);
        system.debug('Bank phone number is: '+phone);
        system.debug('Account Holder account number is : '+accountNumber);
    }
}