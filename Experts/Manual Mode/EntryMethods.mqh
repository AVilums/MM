#include "Calculations.mqh"
#include <Trade/Trade.mqh>
CTrade *trade = new CTrade;

void entry_method1(double base, double extreme, double target, double volume, string zone_type) {
   double half_zone = get_half_zone(base, extreme);
   double slippage = 0.015;

   if (zone_type == "BZ") { 
      trade.BuyLimit(volume, half_zone+slippage, NULL, extreme-slippage, target, ORDER_TIME_GTC, 0, "EM1-BUY-MID");
   } else if (zone_type == "SZ") {
      trade.SellLimit(volume, half_zone-slippage, NULL, extreme+slippage, target, ORDER_TIME_GTC, 0, "EM1-SELL-MID");
   }
}

void entry_method2(double base, double extreme, double target, double volume, string zone_type, string range_type) {
   double half_zone = get_half_zone(base, extreme);
   double slippage = 0.015;

   if (range_type == "WICK") { return; }
   
   volume = MathRound(volume/2, 2); 

   if (zone_type == "BZ") {
      trade.BuyLimit(volume, base+slippage, NULL, extreme-slippage, target, ORDER_TIME_GTC, 0, "EM2-BUY-BASE"); 
      trade.BuyLimit(volume, half_zone+slippage, NULL, extreme-slippage, target, ORDER_TIME_GTC, 0, "EM2-BUY-MID");
   } else if (zone_type == "SZ") {
      trade.SellLimit(volume, base-slippage, NULL, extreme+slippage, target, ORDER_TIME_GTC, 0, "EM2-SELL-BASE");
      trade.SellLimit(volume, half_zone-slippage, NULL, extreme+slippage, target, ORDER_TIME_GTC, 0, "EM2-SELL-MID");
   }
}