double slippage = 0.015;

string risk_to_reward(double base, double extreme, double target, string em) {
   double mid_price = get_half_zone(base, extreme);
   double mid_stop_range = MathAbs(mid_price - extreme - slippage * 2);
   double mid_reward_ratio = MathAbs((mid_price - target - slippage)/mid_stop_range);

   if (em == "EM1 (50%)") {
      return DoubleToString(mid_reward_ratio, 2);
   
   } else if (em == "EM2 (base & 50%)") {
      double base_stop_range = MathAbs(base - extreme - slippage * 2);
      double base_reward_ratio = MathAbs((base - target - slippage)/base_stop_range);

      return DoubleToString((mid_reward_ratio+base_reward_ratio)/2, 2);
   
   } else return "null";
}

double get_pip_value(double volume) {
   // PIP VALUE = (PIP * TRADE SIZE) / EXCHANGE RATE
   double pip = SymbolInfoDouble(Symbol(), SYMBOL_POINT) * 10;
   double trade_size = (volume*100) * 1000;
   double exchange_rate = SymbolInfoDouble(Symbol(), SYMBOL_BID);
   double pip_val = (pip * trade_size) / exchange_rate;
   
   double eur_gbp_bid = SymbolInfoDouble("EURGBP", SYMBOL_BID);
   pip_val = pip_val * (2 - eur_gbp_bid);

   return pip_val;
}

string cash_risk(double base, double extreme, double volume, string em) {
   double mid_stop_range = MathAbs((base - extreme)) / 2 * 100;
   double pip_val = get_pip_value(volume);

   if (em == "EM1 (50%)") {
      return DoubleToString(pip_val * mid_stop_range, 2);

   } else if (em == "EM2 (base & 50%)") {
      double risk_cash = pip_val/2 * mid_stop_range;      
      mid_stop_range = MathAbs((base - extreme)) * 100;

      return DoubleToString(risk_cash + ((pip_val/2) * mid_stop_range), 2);

   } else return "null";
}

string precentage_risk(double base, double extreme, double volume, string em) {
   double acct_balance = AccountInfoDouble(ACCOUNT_BALANCE);
   double mid_stop_range = MathAbs((base - extreme)) / 2 * 100;
   double pip_val = get_pip_value(volume);
   
   if (em == "EM1 (50%)") {
      return DoubleToString(MathAbs(((pip_val * mid_stop_range) / acct_balance)) * 100, 2);

   } else if (em == "EM2 (base & 50%)") {
      double risk_cash = pip_val * mid_stop_range;
      double mid_pos_risk = ((risk_cash/2) / acct_balance) * 100;      
      
      double base_stop_range = MathAbs(base - extreme) * 100;
      risk_cash = pip_val * base_stop_range;
      double base_pos_risk = ((risk_cash/2) / acct_balance) * 100;

      return DoubleToString(mid_pos_risk + base_pos_risk, 2);

   } else return "null";
}

double get_half_zone(double base, double extreme) { return MathAbs((base + extreme) / 2); }

double add_slippage(double price) { return price + slippage; }

double subs_slippage(double price) { return price - slippage; }