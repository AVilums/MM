#include <Trade/Trade.mqh>

#define TRADE_AMT 3
#define DAILY_LOSS 2

class HardLimits {
    private:
        int allowedTrades;
        int currentTrades;
        double allowedLoss;
        double currentLoss;
        bool limitsSet;
        CTrade *cTrade;

    public:
        void Init();
        bool CheckLimit();
        void CloseDeal();

};

void HardLimits::Init() {
    allowedTrades = TRADE_AMT;
    currentTrades = 0;
    allowedLoss = DAILY_LOSS;
    currentLoss = 0.0;
    limitsSet = true;
}

bool HardLimits::CheckLimit() {
    // If t_current == t_allowed
    //      CloseDeal()

    // If loss_current >= loss_allowed 
    //      CloseDeal()

    return true;
}

void HardLimits::CloseDeal() {
    ulong oticket = PositionGetTicket(0);
    cTrade.PositionClose(oticket, ULONG_MAX);     
}


