#include <Trade/Trade.mqh>

class Failsafe {
    protected: 
        CTrade *trade;

        double dailyLossCurrent;
        double weeklyLossCurrent;

        double dailyLossLimit;
        double weeklyLossLimit;

    public:
        Failsafe(void);
        ~Failsafe(void);

        void setLossLimits(double cDailyLoss, double cWeeklyLoss) {
            dailyLossLimit = cDailyLoss;
            weeklyLossLimit = cWeeklyLoss;
        }

        bool Update();
    
        bool isDailyLoss();
        bool isWeeklyLoss();
};

extern Failsafe *failsafe = new Failsafe;

Failsafe::Failsafe(void) :  dailyLossCurrent(0),
                            weeklyLossCurrent(0),
                            dailyLossLimit(0),
                            weeklyLossLimit(0) {}

Failsafe::~Failsafe(void) {}

bool Failsafe::Update() {

    return true;
}



