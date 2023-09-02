#include "Assert.mqh"
#include "Calculations.mqh"

// Object for managing test cases  
// called once onInit, shows alert on error

class Test {
    protected:
        Calculations *calculations;
        bool isPipValue();

    public:
        bool Math();
        Test(void);
        ~Test(void);
};

Test::Test(void) { calculations = new Calculations; }
Test::~Test(void) { delete calculations; }

bool Test::Math() {
    calculations.SetValues(187.0, 188.0, 184.0, 0.5, "SZ", "BODY", "EM1 (50%)", true);
    assert(isPipValue()==true,"PIP VALUE CALCULATION IS INCORRECT")
    
    // SELL ZONE + EM1 
    // SELL ZONE + EM2
    // SELL ZONE + EM3
    
    // BUY ZONE + EM1
    // BUY ZONE + EM2
    // BUY ZONE + EM3

    return true;
}

bool Test::isPipValue() { // Check for correct pip value; general purpose
    if (!(NormalizeDouble(calculations.get_pip_value(), 4) == 3.1732)) { return false;}
        return true;
}


