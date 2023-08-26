#include "Backend.mqh"
CBackend backend;

int OnInit(void) {
  backend.OnInitEvent();

  if(!backend.CreateGUI()) { return(INIT_FAILED); }
    return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason) { backend.OnDeinitEvent(reason); }

void OnTick(void) { }

void OnTimer(void) { backend.OnTimerEvent(); }

void OnTrade(void) { }

void OnChartEvent(const int    id,
                  const long   &lparam,
                  const double &dparam,
                  const string &sparam)
  {
   backend.ChartEvent(id,lparam,dparam,sparam);
  }
