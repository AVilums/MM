//+------------------------------------------------------------------+
//|                                                        Graph.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
//+------------------------------------------------------------------+
//| Класс для создания графика                                       |
//+------------------------------------------------------------------+
class CGraph : public CElement
  {
private:
   //--- Объекты для создания элемента
   CGraphic          m_graph;
   //--- Полноэкранный режим
   bool              m_is_fullscreen_mode;
   //--- Предадущие размеры и положение для режима "Полноэкранный режим"
   int               m_prev_x;
   int               m_prev_y;
   int               m_prev_width;
   int               m_prev_height;
   //---
public:
                     CGraph(void);
                    ~CGraph(void);
   //--- Методы для создания элемента
   bool              CreateGraph(const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const int x_gap,const int y_gap);
   bool              CreateGraphic(void);
   //---
public:
   //--- Возвращает указатель на график
   CGraphic         *GetGraphicPointer(void) { return(::GetPointer(m_graph)); }
   //--- Изменение размеров
   void              Resize(const int width,const int height);
   
   //--- Полноэкранный режим
   void              IsFullScreenMode(const bool mode) { m_is_fullscreen_mode=mode; };
   void              FullScreenMode(const bool mode=true);
   //---
public:
   //--- Обработчик событий графика
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Перемещение элемента
   virtual void      Moving(const bool only_visible=true);
   //--- Управление
   virtual void      Show(void);
   virtual void      Hide(void);
   virtual void      Reset(void);
   virtual void      Delete(void);
   //--- Применение последних изменений
   virtual void      Update(const bool redraw=false);
   //--- (1) Установка, (2) сброс приоритетов на нажитие левой кнопки мыши
   virtual void      SetZorders(void);
   virtual void      ResetZorders(void);
   //---
private:
   //--- Обработка нажатия на графике
   bool              OnClickGraph(const string pressed_object);

   //--- Изменить ширину по правому краю окна
   virtual void      ChangeWidthByRightWindowSide(void);
   //--- Изменить высоту по нижнему краю окна
   virtual void      ChangeHeightByBottomWindowSide(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CGraph::CGraph(void) : m_prev_x(0),
                       m_prev_y(0),
                       m_prev_width(0),
                       m_prev_height(0),
                       m_is_fullscreen_mode(true)
  {
//--- Сохраним имя класса элемента в базовом классе
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CGraph::~CGraph(void)
  {
  }
//+------------------------------------------------------------------+
//| Обработчик событий                                               |
//+------------------------------------------------------------------+
void CGraph::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Обработка события перемещения курсора
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      return;
     }
//--- Обработка события нажатия левой кнопки мыши на объекте
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      if(OnClickGraph(sparam))
         return;
      //---
      return;
     }
  }
//+------------------------------------------------------------------+
//| Создаёт график                                                   |
//+------------------------------------------------------------------+
bool CGraph::CreateGraph(const int x_gap,const int y_gap)
  {
//--- Выйти, если нет указателя на главный элемент
   if(!CElement::CheckMainPointer())
      return(false);
//--- Инициализация свойств
   InitializeProperties(x_gap,y_gap);
//--- Создание элемента
   if(!CreateGraphic())
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Инициализация свойств                                            |
//+------------------------------------------------------------------+
void CGraph::InitializeProperties(const int x_gap,const int y_gap)
  {
   m_x  =CElement::CalculateX(x_gap);
   m_y  =CElement::CalculateY(y_gap);
//--- Рассчитаем размеры
   m_x_size =(m_x_size<1 || m_auto_xresize_mode)? m_main.X2()-m_x-m_auto_xresize_right_offset : m_x_size;
   m_y_size =(m_y_size<1 || m_auto_yresize_mode)? m_main.Y2()-m_y-m_auto_yresize_bottom_offset : m_y_size;
   m_prev_width  =m_x_size;
   m_prev_height =m_y_size;
//--- Сохраним размеры
   CElementBase::XSize(m_x_size);
   CElementBase::YSize(m_y_size);
//--- Отступы от крайней точки
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
  }
//+------------------------------------------------------------------+
//| Создаёт объект                                                   |
//+------------------------------------------------------------------+
bool CGraph::CreateGraphic(void)
  {
//--- Корректировка размеров
   m_x_size =(m_x_size<1)? 50 : m_x_size;
   m_y_size =(m_y_size<1)? 20 : m_y_size;
//--- Формирование имени объекта
   string name=CElementBase::ElementName("graph");
//--- Координаты
   int x2=m_x+m_x_size;
   int y2=m_y+m_y_size;
//--- Удалим объект, если он есть
   if(::ObjectFind(m_chart_id,name)>=0)
     {
      ::ObjectDelete(m_chart_id,name);
     }
//--- Создание объекта
   if(!m_graph.Create(m_chart_id,name,m_subwin,m_x,m_y,x2,y2))
      return(false);
//--- Свойства
   ::ObjectSetString(m_chart_id,m_graph.ChartObjectName(),OBJPROP_TOOLTIP,"\n");
//--- У всех элементов, кроме формы, приоритет больше, чем у главного элемента
   Z_Order(m_main.Z_Order()+1);
   ::ObjectSetInteger(m_chart_id,m_graph.ChartObjectName(),OBJPROP_ZORDER,m_zorder);
   return(true);
  }
//+------------------------------------------------------------------+
//| Перемещение                                                      |
//+------------------------------------------------------------------+
void CGraph::Moving(const bool only_visible=true)
  {
//--- Выйти, если элемент скрыт
   if(only_visible)
      if(!CElementBase::IsVisible())
         return;
//--- Если привязка справа
   if(m_anchor_right_window_side)
     {
      //--- Сохранение координат в полях элемента
      CElementBase::X(m_main.X2()-XGap());
     }
   else
     {
      CElementBase::X(m_main.X()+XGap());
     }
//--- Если привязка снизу
   if(m_anchor_bottom_window_side)
     {
      CElementBase::Y(m_main.Y2()-YGap());
     }
   else
     {
      CElementBase::Y(m_main.Y()+YGap());
     }
//--- Обновление координат графических объектов
   ::ObjectSetInteger(m_chart_id,m_graph.ChartObjectName(),OBJPROP_XDISTANCE,X());
   ::ObjectSetInteger(m_chart_id,m_graph.ChartObjectName(),OBJPROP_YDISTANCE,Y());
  }
//+------------------------------------------------------------------+
//| Показывает пункт меню                                            |
//+------------------------------------------------------------------+
void CGraph::Show(void)
  {
//--- Выйти, если элемент уже видим
   if(CElementBase::IsVisible())
      return;
//--- Сделать видимыми все объекты
   ::ObjectSetInteger(m_chart_id,m_graph.ChartObjectName(),OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
//--- Состояние видимости
   CElementBase::IsVisible(true);
//--- Обновить положение объектов
   Moving();
  }
//+------------------------------------------------------------------+
//| Скрывает пункт меню                                              |
//+------------------------------------------------------------------+
void CGraph::Hide(void)
  {
//--- Выйти, если элемент скрыт
   if(!CElementBase::IsVisible())
      return;
//--- Скрыть все объекты
   ::ObjectSetInteger(m_chart_id,m_graph.ChartObjectName(),OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
//--- Состояние видимости
   CElementBase::IsVisible(false);
  }
//+------------------------------------------------------------------+
//| Перерисовка                                                      |
//+------------------------------------------------------------------+
void CGraph::Reset(void)
  {
//--- Выйдем, если элемент выпадающий
   if(CElementBase::IsDropdown())
      return;
//--- Скрыть и показать
   Hide();
   Show();
  }
//+------------------------------------------------------------------+
//| Удаление                                                         |
//+------------------------------------------------------------------+
void CGraph::Delete(void)
  {
//--- Удалить объекты серий
   int total=m_graph.CurvesTotal();
   for(int i=total-1; i>=0; i--)
      m_graph.CurveRemoveByIndex(i);
//--- Удалить объект графика
   m_graph.Destroy();
//--- Инициализация переменных значениями по умолчанию
   CElementBase::IsVisible(true);
  }
//+------------------------------------------------------------------+
//| Обновление элемента                                              |
//+------------------------------------------------------------------+
void CGraph::Update(const bool redraw=false)
  {
//--- Применить
   m_graph.Update();
  }
//+------------------------------------------------------------------+
//| Установка приоритетов                                            |
//+------------------------------------------------------------------+
void CGraph::SetZorders(void)
  {
   ::ObjectSetInteger(m_chart_id,m_graph.ChartObjectName(),OBJPROP_ZORDER,m_zorder);
  }
//+------------------------------------------------------------------+
//| Сброс приоритетов                                                |
//+------------------------------------------------------------------+
void CGraph::ResetZorders(void)
  {
   ::ObjectSetInteger(m_chart_id,m_graph.ChartObjectName(),OBJPROP_ZORDER,WRONG_VALUE);
  }
//+------------------------------------------------------------------+
//| Изменение размеров                                               |
//+------------------------------------------------------------------+
void CGraph::Resize(const int width,const int height)
  {
   m_x_size=width;
   m_y_size=height;
//--- Удалить объект
   ::ObjectDelete(m_chart_id,m_graph.ChartObjectName());
//--- Создать график
   CreateGraphic();
//--- Скрыть все объекты
   if(!CElementBase::IsVisible())
      ::ObjectSetInteger(m_chart_id,m_graph.ChartObjectName(),OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
  }
//+------------------------------------------------------------------+
//| Управление полноэкранным режимом графика                         |
//+------------------------------------------------------------------+
void CGraph::FullScreenMode(const bool mode)
  {
//--- Изменить размеры
   int chart_width  =m_chart.WidthInPixels();
   int chart_height =m_chart.HeightInPixels(0);
//---
   if(chart_width-1==m_x_size && chart_height-1==m_y_size)
     {
      Resize(m_prev_width,m_prev_height);
      ::ObjectSetInteger(m_chart_id,m_graph.ChartObjectName(),OBJPROP_XDISTANCE,m_prev_x);
      ::ObjectSetInteger(m_chart_id,m_graph.ChartObjectName(),OBJPROP_YDISTANCE,m_prev_y);
     }
   else
     {
      m_prev_x      =m_x;
      m_prev_y      =m_y;
      m_prev_width  =m_x_size;
      m_prev_height =m_y_size;
      Resize(chart_width-1,chart_height-1);
      ::ObjectSetInteger(m_chart_id,m_graph.ChartObjectName(),OBJPROP_XDISTANCE,1);
      ::ObjectSetInteger(m_chart_id,m_graph.ChartObjectName(),OBJPROP_YDISTANCE,1);
     }
//---
   m_graph.Redraw(true);
   m_graph.Update();
   m_chart.Redraw();
  }
//+------------------------------------------------------------------+
//| Нажатие на график                                                |
//+------------------------------------------------------------------+
bool CGraph::OnClickGraph(const string pressed_object)
  {
//--- Выйдем, если (1) чужое имя объекта или (2) выключен полноэкранный режим
   if(m_graph.ChartObjectName()!=pressed_object || !m_is_fullscreen_mode)
      return(false);
//--- Изменить размеры
   FullScreenMode();
   return(true);
  }
//+------------------------------------------------------------------+
//| Изменить ширину по правому краю формы                            |
//+------------------------------------------------------------------+
void CGraph::ChangeWidthByRightWindowSide(void)
  {
//--- Выйти, если включен режим фиксации к правому краю формы
   if(m_anchor_right_window_side)
      return;
//--- Размеры
   int x_size=0;
//--- Рассчитать размер
   x_size=m_main.X2()-X()-m_auto_xresize_right_offset;
//--- Не изменять размер, если меньше установленного ограничения
   if(x_size<200 || x_size==m_x_size)
      return;
//---
   m_prev_width=x_size;
//--- Установить новый размер
   CElementBase::XSize(x_size);
   Resize(x_size,m_graph.Height());
//--- Обновить данные на графике
   m_graph.Redraw(true);
  }
//+------------------------------------------------------------------+
//| Изменить высоту по нижнему краю окна                             |
//+------------------------------------------------------------------+
void CGraph::ChangeHeightByBottomWindowSide(void)
  {
//--- Выйти, если включен режим фиксации к нижнему краю формы
   if(m_anchor_bottom_window_side)
      return;
//--- Размеры
   int y_size=0;
//--- Рассчитать размер
   y_size=m_main.Y2()-Y()-m_auto_yresize_bottom_offset;
//--- Не изменять размер, если меньше установленного ограничения
   if(y_size<200 || y_size==m_y_size)
      return;
//---
   m_prev_height=y_size;
//--- Установить новый размер
   CElementBase::YSize(y_size);
   Resize(m_graph.Width(),y_size);
//--- Обновить данные на графике
   m_graph.Redraw(true);
  }
//+------------------------------------------------------------------+
