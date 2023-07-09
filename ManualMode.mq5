#property copyright "Copyright 2023, Critiq"
#property version   "1.00"

#include <Critiq/common/Alert.mqh>
#include <Critiq/common/HardLimits.mqh>

input double alert_1;
input double alert_2;
input double alert_3;

// Alert alert;
HardLimits hardLimits;

int OnInit() {

    hardLimits.Init();
    // alert.Init(alert_1, alert_2, alert_3);

    return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason) {

}

void OnTick() {

}