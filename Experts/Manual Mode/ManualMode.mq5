#include "Backend.mqh"
#include "Test.mqh"

Backend backend;

int OnInit(void) { 
  // init backend 
  backend.OnInitEvent();  
  
  // creates window
  if(!backend.CreateGUI()) {  
    return(INIT_FAILED);
  }

  // run unit tests 
  UnitTest();

  return(INIT_SUCCEEDED);
} 

void OnDeinit(const int reason) { 
  // delete all remaining objects 
  backend.OnDeinitEvent(reason); 
}

void UnitTest() {
  Test *test = new Test;
  test.Math();
  delete test; 
  test = NULL;
}

//
void OnTick(void) { }

// GUI calls 
void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
{  
  backend.ChartEvent(id,lparam,dparam,sparam);
}
