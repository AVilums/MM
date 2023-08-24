#include "Calculations.mqh"
#include <Trade/Trade.mqh>
CTrade *trade = new CTrade;

void entry_method1(double base, double extreme, double target, double volume, string zone_type) {
   double half_zone = get_half_zone(base, extreme);

   if (zone_type == "BZ") { 
      trade.BuyLimit(volume, add_slippage(half_zone), NULL, subs_slippage(extreme), target, ORDER_TIME_GTC, 0, "EM1-BUY-MID");
   } else if (zone_type == "SZ") {
      trade.SellLimit(volume, subs_slippage(half_zone), NULL, add_slippage(extreme), target, ORDER_TIME_GTC, 0, "EM1-SELL-MID");
   }
}

void entry_method2(double base, double extreme, double target, double volume, string zone_type, string range_type) {
   double half_zone = get_half_zone(base, extreme);

   if (range_type == "WICK") { return; }
   
   volume = get_volume_step(volume, 2); 

   if (zone_type == "BZ") {
      trade.BuyLimit(volume, add_slippage(base), NULL, subs_slippage(extreme), target, ORDER_TIME_GTC, 0, "EM2-BUY-BASE"); 
      trade.BuyLimit(volume, add_slippage(half_zone), NULL, subs_slippage(extreme), target, ORDER_TIME_GTC, 0, "EM2-BUY-MID");
   } else if (zone_type == "SZ") {
      trade.SellLimit(volume, subs_slippage(base), NULL, add_slippage(extreme), target, ORDER_TIME_GTC, 0, "EM2-SELL-BASE");
      trade.SellLimit(volume, subs_slippage(half_zone), NULL, add_slippage(extreme), target, ORDER_TIME_GTC, 0, "EM2-SELL-MID");
   }
}