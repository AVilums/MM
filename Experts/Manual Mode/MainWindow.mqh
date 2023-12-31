#include "Backend.mqh"

// Definition of CreateGUI func. in backend

bool Backend::CreateGUI(void) {

   if(!CWndCreate::CreateWindow(m_window,"MANUAL MODE",1,1,275,275,true,false,true,false))
      return(false);

   m_window.BackColor(clrLightSteelBlue);
   m_window.BorderColor(clrMidnightBlue);

   string text_items[2];
   text_items[0]="For Traders, By Traders";
   text_items[1]="Keep at it...";
   int width_items[]={0,130};

   if(!CWndCreate::CreateStatusBar(m_status_bar,m_window,1,23,22,text_items,width_items))
      return(false);

   if(!CWndCreate::CreateTextEdit(base,"Base:",m_window,0,false,7,25,125,70,100000,1,0.001,3,SymbolInfoDouble(Symbol(), SYMBOL_BID)))
      return(false);

   if(!CWndCreate::CreateTextEdit(extreme,"Extreme:",m_window,0,false,7,50,125,70,100000,1,0.001,3,SymbolInfoDouble(Symbol(), SYMBOL_BID)))
      return(false);

   if(!CWndCreate::CreateTextEdit(target,"Target:",m_window,0,false,7,75,125,70,100000,1,0.001,3,SymbolInfoDouble(Symbol(), SYMBOL_BID)))
      return(false);

   if(!CWndCreate::CreateTextEdit(volume,"Volume:",m_window,0,false,7,100,125,70,100000,0.01,0.01,2,0.01))
      return(false);   

   string items1[]={"SZ", "BZ"};
   if(!CWndCreate::CreateCombobox(zone_type,"Zone type:",m_window,0,false,7,125,215,130,items1,40,0))
      return(false);

   string items2[]= { "BODY","WICK"};
   if(!CWndCreate::CreateCombobox(range_type,"Range type:",m_window,0,false,7,150,215,130,items2,40,0))
      return(false);

   string items3[]= { "EM1 (50%)","EM2 (base & 50%)", "EM3"};
   if(!CWndCreate::CreateCombobox(entry_method,"Entry method:",m_window,0,false,7,175,215,130,items3,40,0))
      return(false);

   if(!CWndCreate::CreateTextLabel(rr,"Risk-to-reward:",m_window,0,150,25,100))
      return(false);

   if(!CWndCreate::CreateTextLabel(percentage,"Risk %:",m_window,0,150,50,100))
      return(false);

   if(!CWndCreate::CreateTextLabel(cash,"Risk €:",m_window,0,150,75,100))
      return(false);
   
   if(!CWndCreate::CreateTextLabel(pip_value,"Pip Value:",m_window,0,150,100,100))
      return(false);
   
   if(!CWndCreate::CreateButton(add,"Add",m_window,0,7,225,100))
      return(false);

   if(!CWndCreate::CreateButton(refresh,"Refresh",m_window,0,150,225,100))
      return(false);

   CWndEvents::CompletedGUI();
      return(true);
}
