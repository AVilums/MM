//+------------------------------------------------------------------+
//|                                                StandardChart.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "Pointer.mqh"
//+------------------------------------------------------------------+
//| Класс для создания стандартного графика                          |
//+------------------------------------------------------------------+
class CStandardChart : public CElement
  {
private:
   //--- Объекты для создания элемента
   CSubChart         m_sub_chart[];
   CPointer          m_x_scroll;
   //--- Свойства графиков:
   long              m_sub_chart_id[];
   string            m_sub_chart_symbol[];
   ENUM_TIMEFRAMES   m_sub_chart_tf[];
   //--- Режим горизонтальной прокрутки
   bool              m_x_scroll_mode;
   //--- Переменные связанные с горизонтальной прокруткой графика
   int               m_prev_x;
   int               m_new_x_point;
   int               m_prev_new_x_point;
   //--- Режим изменения высоты подокна
   bool              m_drag_border_window_mode;
   //---
public:
                     CStandardChart(void);
                    ~CStandardChart(void);
   //--- Методы для создания стандартного графика
   bool              CreateStandardChart(const int x_gap,const int y_gap);
   //---
private:
   bool              CreateSubCharts(void);
   bool              CreateXScrollPointer(void);
   //---
public:
   //--- (1) Возвращает указатель на указатель курсора мыши, (2) возвращает размер массива графиков
   CPointer         *GetMousePointer(void)                        { return(::GetPointer(m_x_scroll)); }
   int               SubChartsTotal(void)                   const { return(::ArraySize(m_sub_chart)); }
   //--- Возвращает указатель на объект-график по указанному индексу
   CSubChart        *GetSubChartPointer(const uint index);
   //--- Режим горизонтальной прокрутки
   void              XScrollMode(const bool mode) { m_x_scroll_mode=mode; }
   //--- Добавляет график с указанными свойствами до создания
   void              AddSubChart(const string symbol,const ENUM_TIMEFRAMES tf);
   //--- Переход к указанной дате
   void              SubChartNavigate(const datetime date);
   //--- Сброс графиков
   void              ResetCharts(void);
   //---
public:
   //--- Обработчик события графика
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Перемещение элемента
   virtual void      Moving(const bool only_visible=true);
   //--- Управление
   virtual void      Show(void);
   virtual void      Hide(void);
   virtual void      Delete(void);
   //--- (1) Установка, (2) сброс приоритетов на нажатие левой кнопки мыши
   virtual void      SetZorders(void);
   virtual void      ResetZorders(void);
   //---
private:
   //--- Обработка нажатия на графике
   bool              OnClickSubChart(const string clicked_object);

   //--- Проверка символа
   bool              CheckSymbol(const string symbol);
   //--- Горизонтальная прокрутка
   void              HorizontalScroll(void);
   //--- Обнуление переменных горизонтальной прокрутки
   void              ZeroHorizontalScrollVariables(void);

   //--- Проверка режима изменения размеров подокна графика
   bool              CheckDragBorderWindowMode(void);

   //--- Изменить ширину по правому краю окна
   virtual void      ChangeWidthByRightWindowSide(void);
   //--- Изменить высоту по нижнему краю окна
   virtual void      ChangeHeightByBottomWindowSide(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CStandardChart::CStandardChart(void) : m_prev_x(0),
                                       m_new_x_point(0),
                                       m_prev_new_x_point(0),
                                       m_x_scroll_mode(false),
                                       m_drag_border_window_mode(false)
  {
//--- Сохраним имя класса элемента в базовом классе
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CStandardChart::~CStandardChart(void)
  {
  }
//+------------------------------------------------------------------+
//| Обработка событий                                                |
//+------------------------------------------------------------------+
void CStandardChart::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Обработка события перемещения курсора
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Выйти, если в режиме изменения размера подокна
      if(CheckDragBorderWindowMode())
         return;
      //--- Если есть фокус, проверим горизонтальную прокрутку графика
      if(CElementBase::MouseFocus())
         HorizontalScroll();
      //--- Если фокуса нет и левая кнопка мыши отжата
      else if(!m_mouse.LeftButtonState())
        {
         if(!m_x_scroll.IsVisible())
            return;
         //---
         m_prev_x=0;
         //--- Скрыть указатель горизонтальной прокрутки
         m_x_scroll.Hide();
         ::ChartRedraw();
         //--- Отправим сообщение на определение доступных элементов
         ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),1,"");
         //--- Отправим сообщение об изменении в графическом интерфейсе
         ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
        }
      //---
      return;
     }
//--- Обработка события нажатия левой кнопки мыши на объекте
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      if(OnClickSubChart(sparam))
         return;
     }
  }
//+------------------------------------------------------------------+
//| Создаёт элемент "Стандартный график"                             |
//+------------------------------------------------------------------+
bool CStandardChart::CreateStandardChart(const int x_gap,const int y_gap)
  {
//--- Выйти, если нет указателя на главный элемент
   if(!CElement::CheckMainPointer())
      return(false);
//--- Инициализация свойств
   m_x        =CElement::CalculateX(x_gap);
   m_y        =CElement::CalculateY(y_gap);
   m_x_size   =(m_x_size<1 || m_auto_xresize_mode)? m_main.X2()-m_x-m_auto_xresize_right_offset : m_x_size;
   m_y_size   =(m_y_size<1 || m_auto_yresize_mode)? m_main.Y2()-m_y-m_auto_yresize_bottom_offset : m_y_size;
//--- Отступы от крайней точки
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
//--- Приоритет, как у главного элемента, так как элемент не имеет своей области для нажатия
   CElement::Z_Order(m_main.Z_Order());
//--- Создание графика
   if(!CreateSubCharts())
      return(false);
   if(!CreateXScrollPointer())
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт графики                                                  |
//+------------------------------------------------------------------+
bool CStandardChart::CreateSubCharts(void)
  {
//--- Получим количество графиков
   int sub_charts_total=SubChartsTotal();
//--- Если нет ни одного графика в группе, сообщить об этом
   if(sub_charts_total<1)
     {
      ::Print(__FUNCTION__," > This method must be called when there is at least one graph in the group! "
              "Use the method CStandardChart::AddSubChart()");
      return(false);
     }
//--- Рассчитаем координаты и размер
   int x=m_x;
   int x_size=(sub_charts_total>1)? m_x_size/sub_charts_total : m_x_size;
//--- Создадим указанное количество графиков
   for(int i=0; i<sub_charts_total; i++)
     {
      //--- Формирование имени объекта
      string name=CElementBase::ProgramName()+"_sub_chart_"+(string)i+"__"+(string)CElementBase::Id();
      //--- Расчёт координаты X
      x=(i>0)? x+x_size-1 : x;
      //--- Корректировка ширины последнего графика
      if(i+1>=sub_charts_total)
         x_size=m_x_size-(x_size*(sub_charts_total-1)-(sub_charts_total-1));
      //--- Установим кнопку
      if(!m_sub_chart[i].Create(m_chart_id,name,m_subwin,x,m_y,x_size,m_y_size))
         return(false);
      //--- Скрыть
      m_sub_chart[i].Timeframes(OBJ_NO_PERIODS);
      //--- Получим и сохраним идентификатор созданного графика
      m_sub_chart_id[i]=m_sub_chart[i].GetInteger(OBJPROP_CHART_ID);
      //--- Установим свойства
      m_sub_chart[i].Symbol(m_sub_chart_symbol[i]);
      m_sub_chart[i].Period(m_sub_chart_tf[i]);
      m_sub_chart[i].Z_Order(m_zorder+1);
      m_sub_chart[i].Tooltip("\n");
      //--- Режим фиксированного масштаба
      //::ChartSetInteger(m_sub_chart_id[i],CHART_SCALEFIX,true);
      //--- Максимум и минимум
      //::ChartSetDouble(m_sub_chart_id[i],CHART_FIXED_MAX,2.0);
      //::ChartSetDouble(m_sub_chart_id[i],CHART_FIXED_MIN,1.0);
      //--- Сохраним размеры
      m_sub_chart[i].XSize(x_size);
      m_sub_chart[i].YSize(m_y_size);
      //--- Отступы от крайней точки
      m_sub_chart[i].XGap(CElement::CalculateXGap(x));
      m_sub_chart[i].YGap(CElement::CalculateYGap(m_y));
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт указатель курсора горизонтальной прокрутки               |
//+------------------------------------------------------------------+
bool CStandardChart::CreateXScrollPointer(void)
  {
//--- Выйти, если горизонтальная прокрутка не нужна
   if(!m_x_scroll_mode)
      return(true);
//--- Установка свойств
   m_x_scroll.XGap(0);
   m_x_scroll.YGap(-20);
   m_x_scroll.Id(CElementBase::Id());
   m_x_scroll.Type(MP_X_SCROLL);
//--- Создание элемента
   if(!m_x_scroll.CreatePointer(m_chart_id,m_subwin))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Возвращает указатель на график по указанному индексу             |
//+------------------------------------------------------------------+
CSubChart *CStandardChart::GetSubChartPointer(const uint index)
  {
   uint array_size=::ArraySize(m_sub_chart);
//--- Если нет ни одного графика, сообщить об этом
   if(array_size<1)
     {
      ::Print(__FUNCTION__," > This method must be called when there is at least one graph in the group!");
      return(NULL);
     }
//--- Корректировка в случае выхода из диапазона
   uint i=(index>=array_size)? array_size-1 : index;
//--- Вернуть указатель
   return(::GetPointer(m_sub_chart[i]));
  }
//+------------------------------------------------------------------+
//| Добавляет график                                                 |
//+------------------------------------------------------------------+
void CStandardChart::AddSubChart(const string symbol,const ENUM_TIMEFRAMES tf)
  {
//--- Проверим, есть ли такой символ на сервере
   if(!CheckSymbol(symbol))
     {
      ::Print(__FUNCTION__," > The symbol "+symbol+" is not on the server!");
      return;
     }
//---
   int reserve=10;
//--- Увеличим размер массивов на один элемент
   int array_size=::ArraySize(m_sub_chart);
   int new_size=array_size+1;
   ::ArrayResize(m_sub_chart,new_size,reserve);
   ::ArrayResize(m_sub_chart_id,new_size,reserve);
   ::ArrayResize(m_sub_chart_symbol,new_size,reserve);
   ::ArrayResize(m_sub_chart_tf,new_size,reserve);
//--- Сохраним значения переданных параметров
   m_sub_chart_symbol[array_size] =symbol;
   m_sub_chart_tf[array_size]     =tf;
  }
//+------------------------------------------------------------------+
//| Переход к указанной дате                                         |
//+------------------------------------------------------------------+
void CStandardChart::SubChartNavigate(const datetime date)
  {
//--- (1) Текущая дата на графике и (2) только что выбранная в календаре
   datetime current_date  =::StringToTime(::TimeToString(::TimeCurrent(),TIME_DATE));
   datetime selected_date =date;
//--- Отключим автопрокрутку и сдвиг от правого края
   ::ChartSetInteger(m_chart_id,CHART_AUTOSCROLL,false);
   ::ChartSetInteger(m_chart_id,CHART_SHIFT,false);
//--- Если выбранная в календаре дата больше, чем текущая
   if(selected_date>=current_date)
     {
      //--- Перейти к текущей дате на всех графиках
      ::ChartNavigate(m_chart_id,CHART_END);
      ResetCharts();
      return;
     }
//--- Получим количество баров от указанной даты
   int  bars_total    =::Bars(::Symbol(),::Period(),selected_date,current_date);
   int  visible_bars  =(int)::ChartGetInteger(m_chart_id,CHART_VISIBLE_BARS);
   long seconds_today =::TimeCurrent()-current_date;
   int  bars_today    =int(seconds_today/::PeriodSeconds())+2;
//--- Установим отступ от правого края всех графиков
   m_prev_new_x_point=m_new_x_point=-((bars_total-visible_bars)+bars_today);
   ::ChartNavigate(m_chart_id,CHART_END,m_new_x_point);
//---
   int sub_charts_total=SubChartsTotal();
   for(int i=0; i<sub_charts_total; i++)
     {
      //--- Отключим автопрокрутку и сдвиг от правого края
      ::ChartSetInteger(m_sub_chart_id[i],CHART_AUTOSCROLL,false);
      ::ChartSetInteger(m_sub_chart_id[i],CHART_SHIFT,false);
      //--- Получим количество баров от указанной даты
      bars_total   =::Bars(m_sub_chart[i].Symbol(),(ENUM_TIMEFRAMES)m_sub_chart[i].Period(),selected_date,current_date);
      visible_bars =(int)::ChartGetInteger(m_sub_chart_id[i],CHART_VISIBLE_BARS);
      bars_today   =int(seconds_today/::PeriodSeconds((ENUM_TIMEFRAMES)m_sub_chart[i].Period()))+2;
      //--- Отступ от правого края графика
      m_prev_new_x_point=m_new_x_point=-((bars_total-visible_bars)+bars_today);
      ::ChartNavigate(m_sub_chart_id[i],CHART_END,m_new_x_point);
     }
  }
//+------------------------------------------------------------------+
//| Сброс графиков                                                   |
//+------------------------------------------------------------------+
void CStandardChart::ResetCharts(void)
  {
   int sub_charts_total=SubChartsTotal();
   for(int i=0; i<sub_charts_total; i++)
      ::ChartNavigate(m_sub_chart_id[i],CHART_END);
//--- Обнулить вспомогательные переменные для горизонтальной прокрутки графиков
   ZeroHorizontalScrollVariables();
  }
//+------------------------------------------------------------------+
//| Перемещение элементов                                            |
//+------------------------------------------------------------------+
void CStandardChart::Moving(const bool only_visible=true)
  {
//--- Выйти, если элемент скрыт
   if(only_visible)
      if(!CElementBase::IsVisible())
         return;
//--- Обновить положение
   CElement::Moving();
//---
   int sub_charts_total=SubChartsTotal();
   for(int i=0; i<sub_charts_total; i++)
     {
      //--- Если привязка справа
      if(m_anchor_right_window_side)
        {
         //--- Сохранение координат в полях элемента
         CElementBase::X(m_main.X2()-XGap());
         //--- Сохранение координат в полях объектов
         m_sub_chart[i].X(m_main.X2()-m_sub_chart[i].XGap());
        }
      //--- Если привязка слева
      else
        {
         CElementBase::X(m_main.X()+XGap());
         m_sub_chart[i].X(m_main.X()+m_sub_chart[i].XGap());
        }
      //--- Если привязка снизу
      if(m_anchor_bottom_window_side)
        {
         CElementBase::Y(m_main.Y2()-YGap());
         m_sub_chart[i].Y(m_main.Y2()-m_sub_chart[i].YGap());
        }
      //--- Если привязка сверху
      else
        {
         CElementBase::Y(m_main.Y()+YGap());
         m_sub_chart[i].Y(m_main.Y()+m_sub_chart[i].YGap());
        }
      //--- Обновление координат графических объектов
      m_sub_chart[i].X_Distance(m_sub_chart[i].X());
      m_sub_chart[i].Y_Distance(m_sub_chart[i].Y());
     }
//--- Обнулить вспомогательные переменные для горизонтальной прокрутки графиков
   ZeroHorizontalScrollVariables();
  }
//+------------------------------------------------------------------+
//| Показывает кнопку                                                |
//+------------------------------------------------------------------+
void CStandardChart::Show(void)
  {
//--- Выйти, если элемент уже видим
   if(CElementBase::IsVisible())
      return;
//--- Состояние видимости
   CElementBase::IsVisible(true);
//--- Обновить положение объектов
   Moving();
//--- Сделать видимыми все объекты
   int sub_charts_total=SubChartsTotal();
   for(int i=0; i<sub_charts_total; i++)
      m_sub_chart[i].Timeframes(OBJ_ALL_PERIODS);
  }
//+------------------------------------------------------------------+
//| Скрывает кнопку                                                  |
//+------------------------------------------------------------------+
void CStandardChart::Hide(void)
  {
//--- Выйти, если элемент скрыт
   if(!CElementBase::IsVisible())
      return;
//--- Скрыть указатель горизонтальной прокрутки
   m_x_scroll.Hide();
//--- Скрыть все объекты
   int sub_charts_total=SubChartsTotal();
   for(int i=0; i<sub_charts_total; i++)
      m_sub_chart[i].Timeframes(OBJ_NO_PERIODS);
//--- Состояние видимости
   CElementBase::IsVisible(false);
  }
//+------------------------------------------------------------------+
//| Удаление                                                         |
//+------------------------------------------------------------------+
void CStandardChart::Delete(void)
  {
   m_x_scroll.Delete();
//--- Удаление объектов
   int sub_charts_total=SubChartsTotal();
   for(int i=0; i<sub_charts_total; i++)
      m_sub_chart[i].Delete();
//--- Освобождение массивов элемента
   ::ArrayFree(m_sub_chart);
//--- Инициализация переменных значениями по умолчанию
   CElementBase::MouseFocus(false);
   CElementBase::IsVisible(true);
  }
//+------------------------------------------------------------------+
//| Установка приоритетов                                            |
//+------------------------------------------------------------------+
void CStandardChart::SetZorders(void)
  {
   int sub_charts_total=SubChartsTotal();
   for(int i=0; i<sub_charts_total; i++)
      m_sub_chart[i].Z_Order(m_zorder);
  }
//+------------------------------------------------------------------+
//| Сброс приоритетов                                                |
//+------------------------------------------------------------------+
void CStandardChart::ResetZorders(void)
  {
   int sub_charts_total=SubChartsTotal();
   for(int i=0; i<sub_charts_total; i++)
      m_sub_chart[i].Z_Order(WRONG_VALUE);
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на кнопку                                      |
//+------------------------------------------------------------------+
bool CStandardChart::OnClickSubChart(const string clicked_object)
  {
//--- Выйдем, если нажатие было не на пункте меню
   if(::StringFind(clicked_object,CElementBase::ProgramName()+"_sub_chart_",0)<0)
      return(false);
//--- Получим идентификатор и индекс из имени объекта
   int id=CElementBase::IdFromObjectName(clicked_object);
//--- Выйти, если идентификатор не совпадает
   if(id!=CElementBase::Id())
      return(false);
//--- Получим индекс
   int group_index=CElementBase::IndexFromObjectName(clicked_object);
//--- Отправить сигнал об этом
   ::EventChartCustom(m_chart_id,ON_CLICK_SUB_CHART,CElementBase::Id(),group_index,m_sub_chart_symbol[group_index]);
   return(true);
  }
//+------------------------------------------------------------------+
//| Проверка наличия символа                                         |
//+------------------------------------------------------------------+
bool CStandardChart::CheckSymbol(const string symbol)
  {
   bool flag=false;
//--- Проверим символ в окне "Обзор рынка"
   int symbols_total=::SymbolsTotal(true);
   for(int i=0; i<symbols_total; i++)
     {
      //--- Если такой символ есть, остановим цикл
      if(::SymbolName(i,true)==symbol)
        {
         flag=true;
         break;
        }
     }
//--- Если символа нет в окне "Обзор рынка", то ...
   if(!flag)
     {
      //--- ... попробуем найти его в общем списке
      symbols_total=::SymbolsTotal(false);
      for(int i=0; i<symbols_total; i++)
        {
         //--- Если такой символ есть, то...
         if(::SymbolName(i,false)==symbol)
           {
            //--- ... поместим его в окно "Обзор рынка" и остановим цикл
            ::SymbolSelect(symbol,true);
            flag=true;
            break;
           }
        }
     }
//--- Вернуть результат поиска
   return(flag);
  }
//+------------------------------------------------------------------+
//| Горизонтальная прокрутка графика                                 |
//+------------------------------------------------------------------+
void CStandardChart::HorizontalScroll(void)
  {
//--- Выйти, если отключена горизонтальная прокрутка графиков
   if(!m_x_scroll_mode)
      return;
//--- Если кнопка мыши нажата
   if(m_mouse.LeftButtonState())
     {
      //--- Запомним текущие координаты X курсора
      if(m_prev_x==0)
        {
         m_prev_x      =m_mouse.X()+m_prev_new_x_point;
         m_new_x_point =m_prev_new_x_point;
         //--- Обновить координаты указателя и сделать его видимым
         m_x_scroll.Moving(m_mouse.X(),m_mouse.Y());
         m_x_scroll.Reset();
         //--- Отправим сообщение на определение доступных элементов
         ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),0,"");
         //--- Отправим сообщение об изменении в графическом интерфейсе
         ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
        }
      else
         m_new_x_point=m_prev_x-m_mouse.X();
      //--- Обновить координаты указателя
      m_x_scroll.Moving(m_mouse.X(),m_mouse.Y());
     }
   else
     {
      if(m_prev_x==0)
         return;
      //---
      m_prev_x=0;
      //--- Скрыть указатель
      m_x_scroll.Hide();
      m_chart.Redraw();
      //--- Отправим сообщение на определение доступных элементов
      ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),1,"");
      //--- Отправим сообщение об изменении в графическом интерфейсе
      ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
      return;
     }
//--- Выйти, если положительное значение
   if(m_new_x_point>0)
      return;
//--- Запомнить текущее положение
   m_prev_new_x_point=m_new_x_point;
//--- Применить ко всем графикам
   int symbols_total=SubChartsTotal();
//--- Отключим автопрокрутку и сдвиг от правого края
   for(int i=0; i<symbols_total; i++)
     {
      if(::ChartGetInteger(m_sub_chart_id[i],CHART_AUTOSCROLL))
         ::ChartSetInteger(m_sub_chart_id[i],CHART_AUTOSCROLL,false);
      if(::ChartGetInteger(m_sub_chart_id[i],CHART_SHIFT))
         ::ChartSetInteger(m_sub_chart_id[i],CHART_SHIFT,false);
     }
//--- Сброс последней ошибки
   ResetLastError();
//--- Сместим графики
   for(int i=0; i<symbols_total; i++)
      if(!::ChartNavigate(m_sub_chart_id[i],CHART_END,m_new_x_point))
         ::Print(__FUNCTION__," > error: ",::GetLastError());
//--- Обновить график
   ::ChartRedraw();
  }
//+------------------------------------------------------------------+
//| Обнуление переменных горизонтальной прокрутки                    |
//+------------------------------------------------------------------+
void CStandardChart::ZeroHorizontalScrollVariables(void)
  {
   m_prev_x           =0;
   m_new_x_point      =0;
   m_prev_new_x_point =0;
  }
//+------------------------------------------------------------------+
//| Проверка режима изменения размеров подокна графика               |
//+------------------------------------------------------------------+
bool CStandardChart::CheckDragBorderWindowMode(void)
  {
//--- Получим высоту главного графика
   int chart_y_size=(int)ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS);
//--- Если левая кнопка мыши нажата
   if(m_mouse.LeftButtonState())
     {
      //--- Если режим отключен
      if(!m_drag_border_window_mode)
        {
         //--- Запомним состояние, если курсор мыши в зоне захвата границы для изменения высоты подокна
         if((m_mouse.SubWindowNumber()==m_subwin && m_mouse.Y()<2) ||
            (m_mouse.SubWindowNumber()==m_subwin && m_mouse.Y()==chart_y_size+1) ||
            (m_mouse.SubWindowNumber()==m_subwin-1 && m_mouse.Y()>=chart_y_size-2))
           {
            m_drag_border_window_mode=true;
            return(false);
           }
        }
     }
//--- Сбросим состояние отключенного режима
   else
      m_drag_border_window_mode=false;
//--- Вернём результат включенного режима
   if(m_drag_border_window_mode)
      return(true);
//---
   return(false);
  }
//+------------------------------------------------------------------+
//| Изменить ширину по правому краю формы                            |
//+------------------------------------------------------------------+
void CStandardChart::ChangeWidthByRightWindowSide(void)
  {
//--- Координаты
   int x=0;
//--- Размеры
   int x_size=0;
//--- Рассчитать новый размер
   x_size=m_main.X2()-m_sub_chart[0].X()-m_auto_xresize_right_offset;
//--- Не изменять размер, если меньше установленного ограничения
   if(x_size<80)
      return;
//--- Установить новый общий размер
   CElementBase::XSize(x_size);
//--- Получим количество графиков в группе
   int sub_charts_total=SubChartsTotal();
//--- Расчёт координат и размера
   x=m_x;
   x_size=(sub_charts_total>1)? x_size/sub_charts_total : x_size;
//--- Если более одного графика
   if(sub_charts_total>1)
     {
      for(int i=0; i<sub_charts_total; i++)
        {
         //--- Расчёт координаты X
         x=(i>0)? x+x_size-1 : x;
         //--- Корректировка ширины последнего графика
         if(i+1>=sub_charts_total)
            x_size=m_x_size-(x_size*(sub_charts_total-1)-(sub_charts_total-1));
         //---
         m_sub_chart[i].X(x);
         m_sub_chart[i].X_Distance(x);
         //---
         m_sub_chart[i].XSize(x_size);
         m_sub_chart[i].X_Size(x_size);
         //--- Отступы от крайней точки
         m_sub_chart[i].XGap(CElement::CalculateXGap(x));
        }
     }
   else
     {
      //--- Установить новый размер
      CElementBase::XSize(x_size);
      m_sub_chart[0].XSize(x_size);
      m_sub_chart[0].X_Size(x_size);
     }
//--- Обновить положение объектов
   Moving();
  }
//+------------------------------------------------------------------+
//| Изменить высоту по нижнему краю окна                             |
//+------------------------------------------------------------------+
void CStandardChart::ChangeHeightByBottomWindowSide(void)
  {
//--- Координаты
   int y=0;
//--- Размеры
   int y_size=0;
//--- Рассчитать новый размер
   y_size=m_main.Y2()-m_y-m_auto_yresize_bottom_offset;
//--- Не изменять размер, если меньше установленного ограничения
   if(y_size<50)
      return;
//--- Получим количество графиков в группе
   int sub_charts_total=SubChartsTotal();
//--- Если более одного графика
   if(sub_charts_total>1)
     {
      //--- Установить новый размер
      CElementBase::YSize(y_size);
      for(int i=0; i<sub_charts_total; i++)
        {
         m_sub_chart[i].YSize(y_size);
         m_sub_chart[i].Y_Size(y_size);
        }
     }
   else
     {
      //--- Установить новый размер
      CElementBase::YSize(y_size);
      m_sub_chart[0].YSize(y_size);
      m_sub_chart[0].Y_Size(y_size);
     }
//--- Обновить положение объектов
   Moving();
  }
//+------------------------------------------------------------------+
