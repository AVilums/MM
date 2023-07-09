#define ALERT_AMNT 3

class Alert {
    private:  
        bool alertOn;
        double startingPrice;
        double priceLevels[];

    public:
        bool Init(double price1, double price2, double price3);
        bool sendMobile(string text) { return SendNotification(text); } 
        bool sendMail(string subject, string text) { return SendMail(subject, text); }
};

bool Alert::Init(double p1,double p2, double p3) {
    
    Print("HERE");

    return true;
}