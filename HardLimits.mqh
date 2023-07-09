#define TRADE_AMT 3

class HardLimits {
    private:
        int allowedTrades;
        int currentTrades;
        bool limitsSet;

    public:
        bool Init();
        bool CheckLimit();
        bool ExitPosition();
};

bool HardLimits::Init() {
    allowedTrades = TRADE_AMT;
    currentTrades = 0;
    limitsSet = true;

    return true;
}

bool HardLimits::CheckLimit() {
    // If t_current == t_allowed
    //      ExitPosition()

    // If loss_current >= loss_allowed 
    //      ExitPosition()

    return true;
}

bool HardLimits::ExitPosition() {
    // Get current deal
    // Close     
    return true;
}


