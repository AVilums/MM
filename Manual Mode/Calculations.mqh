class Calculations {
   protected:
      double slippage;

      double base, extreme, target, volume;
      string zone_type, range_type, entry_method;
      
      double PIP;
      double EURJPY_BID;
      double ACCT_BALANCE;

   public:
      Calculations(void);
      ~Calculations(void);    

      double SlippageSide() { if (zone_type == "SZ") { return 1; } else { return -1; } }
      double HalfZone() { return MathAbs((base + extreme) / 2); }
      
      // TODO Place slippage additio inside 
      double add_slippage(double price) { return price + slippage; }

      void SetValues(double cbase, double cextreme, double ctarget, double cvolume,
                     string zt, string rt, string em, bool test);

      double getSlippage() { return slippage; }

      // TODO Rename functions
      double risk_to_reward();
      double get_pip_value();
      double cash_risk();
      double percentage_risk();
};  

Calculations::Calculations(void) { slippage = 0.015; }
Calculations::~Calculations(void) { }

void Calculations::SetValues(double cbase, double cextreme, double ctarget, double cvolume, string zt, string rt, string em, bool test_mode) {
   base = cbase;
   extreme = cextreme;
   target = ctarget;
   volume = cvolume;
   zone_type = zt;
   range_type = rt;
   entry_method = em;

   // FOR UNIT TEST STATIC VALUES ARE SET 
   if (test_mode == true) { 
      PIP = 0.01;
      EURJPY_BID = 157.569;
      ACCT_BALANCE = 10000;
   } else { 
      PIP = SymbolInfoDouble(Symbol(), SYMBOL_POINT) * 10;
      EURJPY_BID = SymbolInfoDouble("EURJPY", SYMBOL_BID);
      ACCT_BALANCE = AccountInfoDouble(ACCOUNT_BALANCE);
   }

}

double Calculations::risk_to_reward() {

   double mid_stop_range = MathAbs(HalfZone() - extreme - slippage*SlippageSide() * 2);
   double mid_reward_ratio = MathAbs((HalfZone() - target - slippage*SlippageSide()) / mid_stop_range);
   
   if (entry_method == "EM1 (50%)") {
      return mid_reward_ratio;
   
   } else if (entry_method == "EM2 (base & 50%)") {
      double base_stop_range = MathAbs(base - extreme - slippage*SlippageSide() * 2);
      double base_reward_ratio = MathAbs((base - target - slippage*SlippageSide()) / base_stop_range);

      return (mid_reward_ratio+base_reward_ratio)/2;

   } else return false;
}

double Calculations::get_pip_value() {
   // PIP VALUE = (PIP * TRADE SIZE) / EXCHANGE RATE
   double trade_size = (volume*100) * 1000;
   double pip_val = (PIP * trade_size) / EURJPY_BID;
      
   return pip_val;
}

double Calculations::cash_risk() {
   double mid_stop_range = MathAbs(HalfZone() - extreme - slippage * SlippageSide() * 2);
   double pip_val = get_pip_value();

   if (entry_method == "EM1 (50%)") {
      return NormalizeDouble(pip_val * mid_stop_range * 100, 2); 

   } else if (entry_method == "EM2 (base & 50%)") {
      double mid_cash_risk = pip_val/2 * (mid_stop_range * 100);
      double base_stop_range = MathAbs((base - extreme - slippage * SlippageSide() * 2)) * 100;

      return NormalizeDouble(mid_cash_risk + ((pip_val/2) * base_stop_range), 2);

   } else return false;
}

double Calculations::percentage_risk() {
   
   double mid_stop_range = MathAbs((HalfZone() - extreme - slippage * SlippageSide() * 2));
   double pip_val = get_pip_value();
   
   if (entry_method == "EM1 (50%)") {
      return NormalizeDouble(MathAbs(((pip_val * mid_stop_range * 100) / ACCT_BALANCE)) * 100, 2);

   } else if (entry_method == "EM2 (base & 50%)") {
      double risk_cash = pip_val * mid_stop_range * 100;
      double mid_pos_risk = ((risk_cash/2) / ACCT_BALANCE) * 100;      
      
      double base_stop_range = MathAbs(base - extreme - slippage * SlippageSide() * 2);
      risk_cash = pip_val * base_stop_range * 100;
      double base_pos_risk = ((risk_cash/2) / ACCT_BALANCE) * 100;

      return NormalizeDouble(mid_pos_risk + base_pos_risk, 2);

   } else return false;
}