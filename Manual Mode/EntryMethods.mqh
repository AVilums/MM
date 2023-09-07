#include <Trade/Trade.mqh>
CTrade *trade = new CTrade;

void entry_method1(double cbase, double cextreme, double ctarget, double cvolume, 
                  string zt, double slippage) {

   double half_zone = get_half_zone(cbase, cextreme);

   if (zt == "BZ") { 
      trade.BuyLimit(cvolume, add_slippage(half_zone, slippage), NULL, subs_slippage(cextreme, slippage), ctarget, ORDER_TIME_GTC, 0, "EM1-BUY-MID");
   } else if (zt == "SZ") {
      trade.SellLimit(cvolume, subs_slippage(half_zone, slippage), NULL, add_slippage(cextreme, slippage), ctarget, ORDER_TIME_GTC, 0, "EM1-SELL-MID");
   }
}

void entry_method2(double cbase, double cextreme, double ctarget, double cvolume, 
                  string zt, string range_type, double slippage) {

   double half_zone = get_half_zone(cbase, cextreme);

   if (range_type == "WICK") { return; }
   
   cvolume = NormalizeDouble(cvolume/2, 2); 

   if (zt == "BZ") {
      trade.BuyLimit(cvolume, add_slippage(cbase, slippage), NULL, subs_slippage(cextreme, slippage), ctarget, ORDER_TIME_GTC, 0, "EM2-BUY-cbase"); 
      trade.BuyLimit(cvolume, add_slippage(half_zone, slippage), NULL, subs_slippage(cextreme, slippage), ctarget, ORDER_TIME_GTC, 0, "EM2-BUY-MID");
   } else if (zt == "SZ") {
      trade.SellLimit(cvolume, subs_slippage(cbase, slippage), NULL, add_slippage(cextreme, slippage), ctarget, ORDER_TIME_GTC, 0, "EM2-SELL-cbase");
      trade.SellLimit(cvolume, subs_slippage(half_zone, slippage), NULL, add_slippage(cextreme, slippage), ctarget, ORDER_TIME_GTC, 0, "EM2-SELL-MID");
   }
}

void entry_method3(double cbase, double cextreme, double ctarget, double cvolume, 
                  string zt, string range_type, double slippage) {

   double half_zone = get_half_zone(cbase, cextreme);

   if (range_type == "WICK") { return; }
   if (cvolume < 0.04) { return; } // CHECK IF DIVISION BY 4 IS 1

   cvolume = NormalizeDouble(cvolume/4, 2); 

   if (zt == "BZ") {

      trade.BuyLimit(cvolume, add_slippage(cbase, slippage), NULL, subs_slippage(cextreme, slippage), ctarget, ORDER_TIME_GTC, 0, "EM3-BUY-1"); 
      trade.BuyLimit(cvolume, add_slippage(half_zone/2, slippage), NULL, subs_slippage(cextreme, slippage), ctarget, ORDER_TIME_GTC, 0, "EM3-BUY-2");
      trade.BuyLimit(cvolume, add_slippage(half_zone, slippage), NULL, subs_slippage(cextreme, slippage), ctarget, ORDER_TIME_GTC, 0, "EM3-BUY-3"); 
      trade.BuyLimit(cvolume, add_slippage(half_zone*1.5, slippage), NULL, subs_slippage(cextreme, slippage), ctarget, ORDER_TIME_GTC, 0, "EM3-BUY-4");

   } else if (zt == "SZ") {
      trade.SellLimit(cvolume, subs_slippage(cbase, slippage), NULL, add_slippage(cextreme, slippage), ctarget, ORDER_TIME_GTC, 0, "EM2-SELL-cbase");
      trade.SellLimit(cvolume, subs_slippage(half_zone, slippage), NULL, add_slippage(cextreme, slippage), ctarget, ORDER_TIME_GTC, 0, "EM2-SELL-MID");
   }
}

void delete_trade_obj() {
   delete trade;
}

double get_half_zone(double base, double extreme) { return MathAbs((base + extreme) / 2); }

double add_slippage(double price, double slippage) { return price + slippage; }
double subs_slippage(double price, double slippage) { return price - slippage; }