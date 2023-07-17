#property copyright "Copyright 2023, Critiq"
#property version   "1.00"

#include <Critiq/manual mode/Alert.mqh>
#include <Critiq/manual mode/HardLimits.mqh>

input double alert_1;
input double alert_2;
input double alert_3;

// Alert alert;
// HardLimits hardLimits;

int OnInit() { // INITILIASE ALL BLOCKS

                            // Create GUI 
                            // | execution | risk indicators | profit system | alert managm. |
    // gui.Init();

                            // Upon call sets or waits for appropriate entry type  
                            // (last n candlestick range + slippage)  
    // execution.Init();

                            // Upon call sets appropriate alert (input price -> send alert to mobile / email(?))  
                            // Possible to delete limit  
    // alert.Init(); 
                            // Sets max. loss limits | Overall drawdown 
    // failsafe.Init();
    
    return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason) { }  // Delete all objects 

void OnTick() {
    // execution.listen();
    // alert.listen();
    // risk_indicators.update();
}

void OnChartEvent() { }     // Handles GUI

void OnTrade() { }          // Handles failsafe

