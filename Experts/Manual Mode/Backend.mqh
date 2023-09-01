#include <Math\Stat\Stat.mqh>
#include <EasyAndFastGUI\WndCreate.mqh>
#include <EasyAndFastGUI\TimeCounter.mqh>
#include "Calculations.mqh"

class CBackend : public CWndCreate {
   protected:
      Calculations *calc;
      CWindow m_window;

      CStatusBar m_status_bar;

      CTextEdit base;
      CTextEdit extreme;
      CTextEdit target;
      CTextEdit volume;
      
      CTextLabel rr;
      CTextLabel percentage;  
      CTextLabel cash;
      CTextLabel pip_value;

      CComboBox zone_type;
      CComboBox range_type;
      CComboBox entry_method;

      CButton add;
      CButton refresh;

   protected:

      void ShowRiskToReward();
      void ShowCashRisk();
      void ShowPipValue();
      void ShowPercentageRisk();
      void ShowAll();

   public:
      CBackend(void);
      ~CBackend(void);

      void OnInitEvent(void);
      void OnDeinitEvent(const int reason);
      void OnTimerEvent(void);
      
      double GetBase() { return StringToDouble(base.GetValue());}
      double GetExtreme() { return StringToDouble(extreme.GetValue());}
      double GetTarget() { return StringToDouble(target.GetValue());}
      double GetVolume() { return StringToDouble(volume.GetValue());}

      virtual void OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);

      bool CreateGUI(void);
};

#include "EntryMethods.mqh"
#include "MainWindow.mqh"

CBackend::CBackend(void) { calc = new Calculations; }
CBackend::~CBackend(void) {}

void CBackend::OnInitEvent(void) { }

void CBackend::OnDeinitEvent(const int reason) { 
   CWndEvents::Destroy();
   delete calc;
   delete_trade_obj();
}

void CBackend::OnTimerEvent(void) { }

void CBackend::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam) {   

   if (id == CHARTEVENT_CUSTOM + ON_CLICK_BUTTON) {

      ShowAll();

      if (lparam == add.Id()) {
         double cbase = StringToDouble(base.GetValue());
         double cextreme = StringToDouble(extreme.GetValue());
         double ctarget = StringToDouble(target.GetValue());
         double cvolume = StringToDouble(volume.GetValue());

         if (entry_method.GetValue() == "EM1 (50%)") {
            entry_method1(GetBase(), GetExtreme(), GetTarget(), GetVolume(),
            zone_type.GetValue(), calc.get_slippage());

         } else if (entry_method.GetValue() == "EM2 (base & 50%)") {
            entry_method2(GetBase(), GetExtreme(), GetTarget(), GetVolume(),
            zone_type.GetValue(), range_type.GetValue(), calc.get_slippage());
         }
      }
      return;
   }
}

void CBackend::ShowAll() {
   calc.SetValues(GetBase(),GetExtreme(),GetTarget(), GetVolume(), 
      zone_type.GetValue(),range_type.GetValue(), entry_method.GetValue(), false);

   ShowRiskToReward();
   ShowPipValue();
   ShowCashRisk();
   ShowPercentageRisk();
}

void CBackend::ShowRiskToReward() {
   double value = calc.risk_to_reward();

   string text = DoubleToString(value, 2);
   rr.LabelText("Risk-to-reward: " + text);
   rr.Update(true);

   ZeroMemory(text);
}

void CBackend::ShowPipValue() {
   double value = calc.get_pip_value();

   string text = DoubleToString(value, 4);
   pip_value.LabelText("Pip Value: " + text);
   pip_value.Update(true); 

   ZeroMemory(text);
}

void CBackend::ShowCashRisk() {
   double value = calc.cash_risk();

   string text = DoubleToString(value, 2);
   cash.LabelText("Risk €: " + text);
   cash.Update(true);

   ZeroMemory(text);
}

void CBackend::ShowPercentageRisk() {
   double value = calc.percentage_risk();

   string text = DoubleToString(value, 2);

   percentage.LabelText("Risk %: " + text);
   percentage.Update(true);
   ZeroMemory(text);
}
