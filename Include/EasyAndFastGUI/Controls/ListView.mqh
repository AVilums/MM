//+------------------------------------------------------------------+
//|                                                     ListView.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "Scrolls.mqh"
//+------------------------------------------------------------------+
//| Класс для создания списка                                        |
//+------------------------------------------------------------------+
class CListView : public CElement
  {
private:
   //--- Объекты для создания списка
   CRectCanvas       m_listview;
   CScrollV          m_scrollv;
   //--- Массив свойств пунктов списка
   struct LVItemOptions
     {
      int               m_y;     // Y-координата верхнего края строки
      int               m_y2;    // Y-координата нижнего края строки
      string            m_value; // Текст пункта
      bool              m_state; // Состояние чек-бокса
     };
   LVItemOptions     m_items[];
   //--- Размер списка и его видимой части
   int               m_items_total;
   //--- Общий размер и размер видимой части списка
   int               m_list_y_size;
   int               m_list_visible_y_size;
   //--- Общее смещение списка
   int               m_y_offset;
   //--- Размер пунктов по оси Y
   int               m_item_y_size;
   //--- (1) Индекс и (2) текст выбранного пункта
   int               m_selected_item;
   string            m_selected_item_text;
   //--- Индекс предыдущего выделенного пункта
   int               m_prev_selected_item;
   //--- Для определения фокуса строки
   int               m_item_index_focus;
   //--- Для определение момента перехода курсора мыши с одной строки на другую
   int               m_prev_item_index_focus;
   //--- Режим списка с чек-боксами
   bool              m_checkbox_mode;
   //--- Для расчёта границ видимой части поля ввода
   int               m_y_limit;
   int               m_y2_limit;
   //--- Режим подсветки при наведении курсора
   bool              m_lights_hover;
   //--- Счётчик таймера для перемотки списка
   int               m_timer_counter;
   //--- Для определения индексов видимой части списка
   int               m_visible_list_from_index;
   int               m_visible_list_to_index;
   //---
public:
                     CListView(void);
                    ~CListView(void);
   //--- Методы для создания списка
   bool              CreateListView(const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   bool              CreateList(void);
   bool              CreateScrollV(void);
   //---
public:
   //--- Возвращает указатель на полосу прокрутки
   CScrollV         *GetScrollVPointer(void) { return(::GetPointer(m_scrollv)); }
   //--- (1) Высота пункта, возвращает (2) размер списка и (3) видимой его части
   void              ItemYSize(const int y_size)                         { m_item_y_size=y_size;         }
   int               ItemsTotal(void)                              const { return(::ArraySize(m_items)); }
   int               VisibleItemsTotal(void);
   //--- (1) Состояние полосы прокрутки, (2) режим подсветки пунктов при наведении, (3) режим списка с чек-боксами
   bool              ScrollState(void)                             const { return(m_scrollv.State());    }
   void              LightsHover(const bool state)                       { m_lights_hover=state;         }
   void              CheckBoxMode(const bool state)                      { m_checkbox_mode=state;        }
   //--- Возвращает (1) индекс и (2) текст выделенного пункта в списке
   int               SelectedItemIndex(void)                       const { return(m_selected_item);      }
   string            SelectedItemText(void)                        const { return(m_selected_item_text); }
   //--- Установка ярлыков для кнопки в нажатом состоянии (доступен/заблокирован)
   void              IconFilePressed(const string file_path);
   void              IconFilePressedLocked(const string file_path);
   //--- (1) Установка значения, (2) получение значения, (3) получение состояния
   void              SetValue(const uint item_index,const string value,const bool redraw=false);
   string            GetValue(const uint item_index);
   bool              GetState(const uint item_index);
   //--- Выделение пункта
   void              SelectItem(const uint item_index,const bool redraw=false);
   //--- Установка (1) размера списка и (2) видимой его части
   void              ListSize(const int items_total);
   //--- Реконструкция списка
   void              Rebuilding(const int items_total,const bool redraw=false);
   //--- Добавляет пункт в список
   void              AddItem(const int item_index,const string value="",const bool redraw=false);
   //--- Удаляет пункт из списка
   void              DeleteItem(const int item_index,const bool redraw=false);
   //--- Очищает список (удаление всех пунктов)
   void              Clear(const bool redraw=false);
   //--- Прокрутка списка
   void              Scrolling(const int pos=WRONG_VALUE);
   //--- Изменение размеров
   void              ChangeSize(const uint x_size,const uint y_size);
   //---
public:
   //--- Обработчик событий графика
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Таймер
   virtual void      OnEventTimer(void);
   //--- Перемещение элемента
   virtual void      Moving(const bool only_visible=true);
   //--- Управление
   virtual void      Show(void);
   virtual void      Hide(void);
   virtual void      Delete(void);
   //--- (1) Установка, (2) сброс приоритетов на нажатие левой кнопки мыши
   virtual void      SetZorders(void);
   virtual void      ResetZorders(void);
   //--- Рисует элемент
   virtual void      Draw(void);
   //--- Обновление элемента
   virtual void      Update(const bool redraw=false);
   //---
private:
   //--- Обработка нажатия на пункте списка
   bool              OnClickList(const string pressed_object);
   //--- Возвращает индекс пункта, на котором нажали
   int               PressedItemIndex(void);

   //--- Изменение цвета пунктов списка при наведении
   void              ChangeItemsColor(void);
   //--- Проверка фокуса строки списка при наведении курсора
   int               CheckItemFocus(void);
   //--- Смещение списка относительно позиции полосы прокрутки
   void              ShiftData(void);
   //--- Ускоренная перемотка списка
   void              FastSwitching(void);

   //--- Рассчитывает размер списка
   void              CalculateListYSize(void);
   //--- Изменить основные размеры элемента
   void              ChangeMainSize(const int x_size,const int y_size);
   //--- Изменить размеры списка
   void              ChangeListSize(void);
   //--- Изменить размеры полос прокрутки
   void              ChangeScrollsSize(void);

   //--- Расчёт с учётом последних изменений и изменение размеров списка
   void              RecalculateAndResizeList(const bool redraw=false);
   //--- Инициализация указанного пункта значениями по умолчанию
   void              ItemInitialize(const uint item_index);
   //--- Делает копию указанного пункта (source) в новое место (dest.)
   void              ItemCopy(const uint item_dest,const uint item_source);

   //--- Расчёт Y-координаты пункта
   int               CalculationItemY(const int item_index=0);
   //--- Расчёт ширины пунктов
   int               CalculationItemsWidth(void);
   //--- Расчёт границ поля ввода по оси Y
   void              CalculateYBoundaries(void);
   //--- Корректировка вертикальной полосы прокрутки
   void              CorrectingVerticalScrollThumb(void);
   //--- Расчёт Y-позиции ползунка полосы прокрутки
   int               CalculateScrollPosY(const bool to_down=false);
   //--- Расчёт Y-координат полосы прокрутки в верхней/нижней границе списка
   int               CalculateScrollThumbY(void);
   int               CalculateScrollThumbY2(void);
   //--- Определение индексов видимой области списка
   void              VisibleListIndexes(void);

   //--- Рисует список
   virtual void      DrawList(const bool only_visible=false);
   //--- Рисует рамку
   virtual void      DrawBorder(void);
   //--- Рисует картинки пунктов
   virtual void      DrawImages(void);
   //--- Рисует картинку
   virtual void      DrawImage(void);
   //--- Рисует текст пунктов
   virtual void      DrawText(void);

   //--- Перерисовывает указанный пункт списка
   void              RedrawItem(const int item_index);
   //--- Перерисовывает пункты списка по указанному режиму
   void              RedrawItemsByMode(const bool is_selected_row=false);
   //--- Возвращает текущий цвет фона пункта
   uint              ItemColorCurrent(const int item_index,const bool is_item_focus);
   //--- Возвращает цвет текста пункта
   uint              TextColor(const int item_index);

   //--- Изменить ширину по правому краю окна
   virtual void      ChangeWidthByRightWindowSide(void);
   //--- Изменить высоту по нижнему краю окна
   virtual void      ChangeHeightByBottomWindowSide(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CListView::CListView(void) : m_item_y_size(18),
                             m_lights_hover(false),
                             m_items_total(0),
                             m_y_offset(0),
                             m_checkbox_mode(false),
                             m_selected_item(WRONG_VALUE),
                             m_selected_item_text(""),
                             m_prev_selected_item(WRONG_VALUE),
                             m_item_index_focus(WRONG_VALUE),
                             m_prev_item_index_focus(WRONG_VALUE),
                             m_visible_list_from_index(WRONG_VALUE),
                             m_visible_list_to_index(WRONG_VALUE)
  {
//--- Сохраним имя класса элемента в базовом классе
   CElementBase::ClassName(CLASS_NAME);
//--- Установим размер списка и его видимой части
   ListSize(m_items_total);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CListView::~CListView(void)
  {
  }
//+------------------------------------------------------------------+
//| Обработчик событий                                               |
//+------------------------------------------------------------------+
void CListView::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Обработка события перемещения курсора
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Смещаем список, если управление ползунком полосы прокрутки в действии
      if(m_scrollv.ScrollBarControl())
        {
         //--- Обновить список и полосу прокрутки
         ShiftData();
         m_scrollv.Update(true);
         return;
        }
      //--- Сброс цвета
      if(!CElementBase::MouseFocus())
        {
         if(m_prev_item_index_focus==WRONG_VALUE)
            return;
         //--- Снять фокус
         m_canvas.MouseFocus(false);
         //--- Изменяет цвет строк списка при наведении
         ChangeItemsColor();
         return;
        }
      //--- Проверка фокуса над списком
      int x_offset=(m_scrollv.IsVisible())? m_scrollv.ScrollWidth() : 0;
      m_canvas.MouseFocus(m_mouse.X()>m_canvas.X() && m_mouse.X()<X2()-x_offset && 
                          m_mouse.Y()>m_canvas.Y() && m_mouse.Y()<m_canvas.Y2());
      //--- Изменяет цвет строк списка при наведении
      ChangeItemsColor();
      //--- Определим режим отслеживания прокручивания колёсика мыши
      if(m_canvas.MouseFocus())
         ::ChartSetInteger(m_chart_id,CHART_EVENT_MOUSE_WHEEL,true);
      else
         ::ChartSetInteger(m_chart_id,CHART_EVENT_MOUSE_WHEEL,false);
      return;
     }
//--- Обработка события колёсика мыши
   if(id==CHARTEVENT_MOUSE_WHEEL)
     {
      //--- Получим текущую позицию полосы прокрутки
      int pos=(m_scrollv.CurrentPos()-1<0)? 1 : m_scrollv.CurrentPos();
      //--- Если колёсико мыши сместилось вниз
      if(dparam<0)
         Scrolling(pos+1);
      //--- Если колёсико мыши сместилось вверх
      else if(dparam>0)
         Scrolling(pos-1);
      //--- Обновить полосу прокрутки
      m_scrollv.Update(true);
     }
//--- Обработка нажатия на объектах
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      //--- Если было нажатие на списке
      if(OnClickList(sparam))
         return;
     }
//--- Обработка события нажатия на кнопках полосы прокрутки 
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)
     {
      //--- Если было нажатие на кнопках полосы прокрутки списка
      if(m_scrollv.OnClickScrollInc((uint)lparam,(uint)dparam) ||
         m_scrollv.OnClickScrollDec((uint)lparam,(uint)dparam))
        {
         //--- Сдвигает список относительно полосы прокрутки
         ShiftData();
         m_scrollv.Update(true);
         return;
        }
     }
  }
//+------------------------------------------------------------------+
//| Таймер                                                           |
//+------------------------------------------------------------------+
void CListView::OnEventTimer(void)
  {
//--- Ускоренная перемотка значений
   FastSwitching();
  }
//+------------------------------------------------------------------+
//| Создаёт список                                                   |
//+------------------------------------------------------------------+
bool CListView::CreateListView(const int x_gap,const int y_gap)
  {
//--- Выйти, если нет указателя на главный элемент
   if(!CElement::CheckMainPointer())
      return(false);
//--- Инициализация свойств
   InitializeProperties(x_gap,y_gap);
//--- Рассчитаем размеры списка
   CalculateListYSize();
//--- Создание списка
   if(!CreateCanvas())
      return(false);
   if(!CreateList())
      return(false);
   if(!CreateScrollV())
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Инициализация свойств                                            |
//+------------------------------------------------------------------+
void CListView::InitializeProperties(const int x_gap,const int y_gap)
  {
   m_x             =CElement::CalculateX(x_gap);
   m_y             =CElement::CalculateY(y_gap);
   m_x_size        =(m_x_size<0 || m_auto_xresize_mode)? m_main.X2()-CElementBase::X()-m_auto_xresize_right_offset : m_x_size;
   m_y_size        =(m_y_size<0 || m_auto_yresize_mode)? m_main.Y2()-CElementBase::Y()-m_auto_yresize_bottom_offset : m_y_size;
   m_selected_item =(m_selected_item==WRONG_VALUE && !m_checkbox_mode) ? 0 : m_selected_item;
//--- Цвета пунктов в различных состояниях
   m_back_color          =(m_back_color!=clrNONE)? m_back_color : clrWhite;
   m_back_color_hover    =(m_back_color_hover!=clrNONE)? m_back_color_hover : C'229,243,255';
   m_back_color_pressed  =(m_back_color_pressed!=clrNONE)? m_back_color_pressed : C'51,153,255';
   m_label_color         =(m_label_color!=clrNONE)? m_label_color : clrBlack;
   m_label_color_hover   =(m_label_color_hover!=clrNONE)? m_label_color_hover : clrBlack;
   m_label_color_pressed =(m_label_color_pressed!=clrNONE)? m_label_color_pressed : clrWhite;
   m_border_color        =(m_border_color!=clrNONE)? m_border_color : C'150,170,180';
//--- Отступы для картинок и текста от краёв ячеек
   m_icon_x_gap  =(m_icon_x_gap>0)? m_icon_x_gap : 7;
   m_icon_y_gap  =(m_icon_y_gap>0)? m_icon_y_gap : 4;
   m_label_x_gap =(m_label_x_gap>0)? m_label_x_gap : 5;
   m_label_y_gap =(m_label_y_gap>0)? m_label_y_gap : 4;
//--- Отступы от крайней точки
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
  }
//+------------------------------------------------------------------+
//| Создаёт фон для списка                                           |
//+------------------------------------------------------------------+
bool CListView::CreateCanvas(void)
  {
//--- Формирование имени объекта
   string name=CElementBase::ElementName("listview");
//--- Создание объекта
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт объект для рисования                                     |
//+------------------------------------------------------------------+
bool CListView::CreateList(void)
  {
//--- Формирование имени объекта
   string name=CElementBase::ProgramName()+"_"+"listview_array"+"_"+(string)CElementBase::Id();
//--- Размер
   int x_size=m_x_size-2;
//--- Координаты
   int x =m_x+1;
   int y =m_y+1;
//--- Создание объекта
   ::ResetLastError();
   if(!m_listview.CreateBitmapLabel(m_chart_id,m_subwin,name,x,y,x_size,m_list_y_size,COLOR_FORMAT_ARGB_NORMALIZE))
     {
      ::Print(__FUNCTION__," > Не удалось создать холст для рисования списка: ",::GetLastError());
      return(false);
     }
//--- Прикрепить к графику
   if(!m_listview.Attach(m_chart_id,name,COLOR_FORMAT_ARGB_NORMALIZE))
     {
      ::Print(__FUNCTION__," > Не удалось присоединить холст для рисования к графику: ",::GetLastError());
      return(false);
     }
//--- Свойства
   ::ObjectSetInteger(m_chart_id,m_listview.ChartObjectName(),OBJPROP_ZORDER,m_zorder+1);
   ::ObjectSetString(m_chart_id,m_listview.ChartObjectName(),OBJPROP_TOOLTIP,"\n");
//--- Если нужен список с чек-боксами
   if(m_checkbox_mode)
     {
      IconFile(RESOURCE_CHECKBOX_OFF);
      IconFileLocked(RESOURCE_CHECKBOX_OFF_LOCKED);
      CElement::IconFilePressed(RESOURCE_CHECKBOX_ON);
      CElement::IconFilePressedLocked(RESOURCE_CHECKBOX_ON_LOCKED);
     }
//--- Координаты
   m_listview.X(x);
   m_listview.Y(y);
//--- Сохраним размеры
   m_listview.XSize(x_size);
   m_listview.YSize(m_list_y_size);
   m_listview.Resize(x_size,m_list_y_size);
//--- Отступы от крайней точки панели
   m_listview.XGap(CElement::CalculateXGap(x));
   m_listview.YGap(CElement::CalculateYGap(y));
//--- Установим размеры видимой области
   ::ObjectSetInteger(m_chart_id,m_listview.ChartObjectName(),OBJPROP_XSIZE,x_size);
   ::ObjectSetInteger(m_chart_id,m_listview.ChartObjectName(),OBJPROP_YSIZE,m_list_visible_y_size);
//--- Зададим смещение фрейма внутри изображения по осям X и Y
   ::ObjectSetInteger(m_chart_id,m_listview.ChartObjectName(),OBJPROP_XOFFSET,0);
   ::ObjectSetInteger(m_chart_id,m_listview.ChartObjectName(),OBJPROP_YOFFSET,0);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт вертикальный скролл                                      |
//+------------------------------------------------------------------+
bool CListView::CreateScrollV(void)
  {
//--- Сохранить указатель на главный элемент
   m_scrollv.MainPointer(this);
//--- Координаты
   int x=16,y=1;
//--- Свойства
   m_scrollv.Index((m_scrollv.Index()!=WRONG_VALUE)? m_scrollv.Index() : 0);
   m_scrollv.XSize(15);
   m_scrollv.YSize(CElementBase::YSize()-2);
   m_scrollv.IsDropdown(CElementBase::IsDropdown());
   m_scrollv.AnchorRightWindowSide(true);
//--- Расчёт количества шагов для смещения
   uint items_total         =ItemsTotal();
   uint visible_items_total =VisibleItemsTotal();
//--- Создание полосы прокрутки
   if(!m_scrollv.CreateScroll(x,y,items_total,visible_items_total))
      return(false);
//--- Скрыть полосу прокрутки, если видимая часть больше, чем размер списка
   if(m_list_visible_y_size>m_list_y_size)
      m_scrollv.Hide();
//--- Добавить элемент в массив
   CElement::AddToArray(m_scrollv);
   return(true);
  }
//+------------------------------------------------------------------+
//| Выделяет указанный пункт                                         |
//+------------------------------------------------------------------+
void CListView::SelectItem(const uint item_index,const bool redraw=false)
  {
//--- Выйти, если нет пунктов в списке
   if(ItemsTotal()<1)
      return;
//--- Корректировка в случае выхода из диапазона
   int checked_index=(item_index>=(uint)m_items_total)? m_items_total-1 :(int)item_index;
//--- Если это список с чек-боксами
   if(m_checkbox_mode)
     {
      m_selected_item      =WRONG_VALUE;
      m_selected_item_text ="";
      //--- Установим противоположное значение чек-боксу
      m_items[checked_index].m_state=!m_items[checked_index].m_state;
      //--- Перерисовать пункт, если указано
      if(redraw)
         RedrawItem(item_index);
      //---
      return;
     }
//--- Сохраним индекс и текст выделенного пункта
   m_selected_item      =checked_index;
   m_selected_item_text =m_items[m_selected_item].m_value;
//--- Перерисовать список, если указано
   if(redraw)
      Update(true);
  }
//+------------------------------------------------------------------+
//| Возвращает количество видимых пунктов                            |
//+------------------------------------------------------------------+
int CListView::VisibleItemsTotal(void)
  {
   double visible_items_total =m_list_visible_y_size/m_item_y_size;
   double check_y_size        =visible_items_total*m_item_y_size;
//---
   visible_items_total=(check_y_size<m_list_visible_y_size+(m_y_offset*2)+1)? visible_items_total : visible_items_total;
   return((int)visible_items_total);
  }
//+------------------------------------------------------------------+
//| Установка картинки для нажатого состояния (доступен)             |
//+------------------------------------------------------------------+
void CListView::IconFilePressed(const string file_path)
  {
//--- Выйти, если режим списка с чек-боксами отключен
   if(!m_checkbox_mode)
      return;
//--- Добавить место для изображения, если его ещё нет
   while(!CElement::CheckOutOfRange(0,2))
      AddImage(0,"");
//--- Установить картинку
   CElement::SetImage(0,2,file_path);
  }
//+------------------------------------------------------------------+
//| Установка картинки для нажатого состояния (заблокирован)         |
//+------------------------------------------------------------------+
void CListView::IconFilePressedLocked(const string file_path)
  {
//--- Выйти, если режим списка с чек-боксами отключен
   if(!m_checkbox_mode)
      return;
//--- Добавить место для изображения, если его ещё нет
   while(!CElement::CheckOutOfRange(0,3))
      AddImage(0,"");
//--- Установить картинку
   CElement::SetImage(0,3,file_path);
  }
//+------------------------------------------------------------------+
//| Установка значения в списке по указанному индексу                |
//+------------------------------------------------------------------+
void CListView::SetValue(const uint item_index,const string value,const bool redraw=false)
  {
   uint array_size=ItemsTotal();
//--- Если нет ни одного пункта в списке, сообщить об этом
   if(array_size<1)
      ::Print(__FUNCTION__," > Вызов этого метода нужно осуществлять, когда в списке есть хотя бы один пункт!");
//--- Корректировка в случае выхода из диапазона
   uint i=(item_index>=array_size)? array_size-1 : item_index;
//--- Сохраним значение в списке
   m_items[i].m_value=value;
//--- Перерисовать пункт, если указано
   if(redraw)
      RedrawItem(item_index);
  }
//+------------------------------------------------------------------+
//| Получение значения в списке по указанному индексу                |
//+------------------------------------------------------------------+
string CListView::GetValue(const uint item_index)
  {
   uint array_size=ItemsTotal();
//--- Если нет ни одного пункта в списке, сообщить об этом
   if(array_size<1)
      ::Print(__FUNCTION__," > Вызов этого метода нужно осуществлять, когда в списке есть хотя бы один пункт!");
//--- Корректировка в случае выхода из диапазона
   uint i=(item_index>=array_size)? array_size-1 : item_index;
//--- Сохраним значение в списке
   return(m_items[i].m_value);
  }
//+------------------------------------------------------------------+
//| Получение состояния чек-бокса по указанному индексу              |
//+------------------------------------------------------------------+
bool CListView::GetState(const uint item_index)
  {
   uint array_size=ItemsTotal();
//--- Если нет ни одного пункта в списке, сообщить об этом
   if(array_size<1)
      ::Print(__FUNCTION__," > Вызов этого метода нужно осуществлять, когда в списке есть хотя бы один пункт!");
//--- Корректировка в случае выхода из диапазона
   uint i=(item_index>=array_size)? array_size-1 : item_index;
//--- Сохраним значение в списке
   return(m_items[i].m_state);
  }
//+------------------------------------------------------------------+
//| Устанавливает размер списка                                      |
//+------------------------------------------------------------------+
void CListView::ListSize(const int items_total)
  {
//--- Не имеет смысла делать список менее двух пунктов
   m_items_total=(items_total<1) ? 0 : items_total;
   ::ArrayResize(m_items,m_items_total);
//--- Инициализация пунктов значениями по умолчанию
   for(int i=0; i<m_items_total; i++)
      ItemInitialize(i);
  }
//+------------------------------------------------------------------+
//| Реконструкция списка                                             |
//+------------------------------------------------------------------+
void CListView::Rebuilding(const int items_total,const bool redraw=false)
  {
//--- Установим нулевой размер
   ListSize(items_total);
//--- Рассчитать и установить новые размеры списка
   RecalculateAndResizeList(redraw);
  }
//+------------------------------------------------------------------+
//| Добавляет пункт в список                                         |
//+------------------------------------------------------------------+
void CListView::AddItem(const int item_index,const string value="",const bool redraw=false)
  {
//--- Резервное количество
   int reserve=100;
//--- Увеличим размер массива на один элемент
   int array_size=ItemsTotal();
   m_items_total=array_size+1;
   ::ArrayResize(m_items,m_items_total,reserve);
//--- Корректировка индекса в случае выхода из диапазона
   int checked_item_index=(item_index>=m_items_total)? m_items_total-1 : item_index;
//--- Сместить другие пункты (двигаемся от конца массива к индексу добавляемого пункта)
   for(int i=array_size; i>=checked_item_index; i--)
     {
      //--- Инициализация нового пункта значениями по умолчанию
      if(i==checked_item_index)
        {
         ItemInitialize(i);
         m_items[i].m_value=value;
         continue;
        }
      //--- Индекс предыдущего пункта
      uint prev_i=i-1;
      //--- Перемещаем данные из предыдущего пункта в текущий
      ItemCopy(i,prev_i);
     }
//--- Рассчитать и установить новые размеры списка
   RecalculateAndResizeList(redraw);
  }
//+------------------------------------------------------------------+
//| Удаляет пункт из списка                                          |
//+------------------------------------------------------------------+
void CListView::DeleteItem(const int item_index,const bool redraw=false)
  {
//--- Увеличим размер массива на один элемент
   int array_size=ItemsTotal();
//--- Корректировка индекса в случае выхода из диапазона
   int checked_item_index=(item_index>=m_items_total)? m_items_total-1 : item_index;
//--- Сместить другие пункты (двигаемся от указанного индекса к последнему пункту)
   for(int i=checked_item_index; i<array_size-1; i++)
     {
      //--- Индекс следующего пункта
      uint next_i=i+1;
      //--- Перемещаем данные из следующего пункта в текущий
      ItemCopy(i,next_i);
     }
//--- Уменьшим размер массива на один элемент
   m_items_total=array_size-1;
   ::ArrayResize(m_items,m_items_total);
//--- Рассчитать и установить новые размеры списка
   RecalculateAndResizeList(redraw);
  }
//+------------------------------------------------------------------+
//| Очищает список (удаление всех пунктов)                           |
//+------------------------------------------------------------------+
void CListView::Clear(const bool redraw=false)
  {
//--- Обнулить вспомогательные поля
   m_item_index_focus      =WRONG_VALUE;
   m_prev_selected_item    =WRONG_VALUE;
   m_prev_item_index_focus =WRONG_VALUE;
//--- Установим нулевой размер
   ListSize(0);
//--- Рассчитать и установить новые размеры списка
   RecalculateAndResizeList(redraw);
  }
//+------------------------------------------------------------------+
//| Прокрутка списка                                                 |
//+------------------------------------------------------------------+
void CListView::Scrolling(const int pos=WRONG_VALUE)
  {
//--- Выйти, если полоса прокрутки не нужна
   if(m_list_y_size<=m_list_visible_y_size)
      return;
//--- Для определения позиции ползунка
   int index=0;
//--- Индекс последней позиции
   int last_pos_index=m_list_y_size-m_list_visible_y_size;
//--- Корректировка в случае выхода из диапазона
   if(pos<0)
      index=last_pos_index;
   else
      index=(pos>last_pos_index)? last_pos_index : pos;
//--- Сдвигаем ползунок полосы прокрутки
   m_scrollv.MovingThumb(index);
//--- Сдвигаем список
   ShiftData();
  }
//+------------------------------------------------------------------+
//| Изменение размеров                                               |
//+------------------------------------------------------------------+
void CListView::ChangeSize(const uint x_size,const uint y_size)
  {
//--- Установить новый размер
   CElementBase::XSize(x_size);
   CElementBase::YSize(y_size);
   m_canvas.XSize(m_x_size);
   m_canvas.YSize(m_y_size);
   m_canvas.Resize(m_x_size,m_y_size);
  }
//+------------------------------------------------------------------+
//| Изменение цвета строки списка при наведении курсора              |
//+------------------------------------------------------------------+
void CListView::ChangeItemsColor(void)
  {
//--- Выйдем, если отключена подсветка при наведении курсора или прокрутка списка активна
   if(!m_lights_hover || m_scrollv.State())
      return;
//--- Выйдем, если элемент не выпадающий и форма заблокирована
   if(!CElementBase::IsDropdown() && m_main.CElementBase::IsLocked())
      return;
//--- Если не в фокусе
   if(!m_canvas.MouseFocus())
     {
      //--- Если ещё не отмечено, что не в фокусе
      if(m_prev_item_index_focus!=WRONG_VALUE)
        {
         m_item_index_focus=WRONG_VALUE;
         //--- Изменить цвет
         RedrawItemsByMode();
         //--- Сбросить фокус
         m_prev_item_index_focus=WRONG_VALUE;
        }
     }
//--- Если в фокусе
   else
     {
      //--- Проверить фокус над строками
      if(m_item_index_focus==WRONG_VALUE)
        {
         //--- Получим индекс строки в фокусе
         m_item_index_focus=CheckItemFocus();
         //--- Изменить цвет строки
         RedrawItemsByMode();
         //--- Сохранить как предыдущий индекс в фокусе
         m_prev_item_index_focus=m_item_index_focus;
         return;
        }
      //--- Получим относительную Y-координату под курсором мыши
      int y=m_mouse.RelativeY(m_listview);
      //--- Проверка фокуса
      bool condition=(y>m_items[m_item_index_focus].m_y && y<=m_items[m_item_index_focus].m_y2);
      //--- Если фокус изменился
      if(!condition)
        {
         //--- Получим индекс строки в фокусе
         m_item_index_focus=CheckItemFocus();
         //--- Выйти, если вышли из области списка
         if(m_item_index_focus<0)
            return;
         //--- Изменить цвет строки
         RedrawItemsByMode();
         //--- Сохранить как предыдущий индекс в фокусе
         m_prev_item_index_focus=m_item_index_focus;
        }
     }
  }
//+------------------------------------------------------------------+
//| Проверка фокуса строки списка при наведении курсора              |
//+------------------------------------------------------------------+
int CListView::CheckItemFocus(void)
  {
   int item_index_focus=WRONG_VALUE;
//--- Получим относительную Y-координату под курсором мыши
   int y=m_mouse.RelativeY(m_listview);
///--- Получим индексы локальной области таблицы
   VisibleListIndexes();
//--- Ищем фокус
   for(int i=m_visible_list_from_index; i<m_visible_list_to_index; i++)
     {
      //--- Если фокус строки изменился
      if(y>m_items[i].m_y && y<=m_items[i].m_y2)
        {
         item_index_focus=(int)i;
         break;
        }
     }
//--- Вернём индекс строки в фокусе
   return(item_index_focus);
  }
//+------------------------------------------------------------------+
//| Смещение списка относительно позиции полосы прокрутки            |
//+------------------------------------------------------------------+
void CListView::ShiftData(void)
  {
//--- Сохраним ограничение по смещению
   int shift_y2_limit=m_list_y_size-m_list_visible_y_size;
//--- Получим текущую позицию ползунка полосы прокрутки
   int v_offset=(m_scrollv.CurrentPos()*m_item_y_size);
//--- Рассчитаем отступы для смещения
   int y_offset=(v_offset<m_y_offset)? 0 :(v_offset>=shift_y2_limit-(m_y_offset*2+1))? shift_y2_limit : v_offset;
//--- Первая позиция, если полосы прокрутки нет
   long y=(!m_scrollv.IsVisible())? 0 : y_offset;
//--- Смещение данных
   ::ObjectSetInteger(m_chart_id,m_listview.ChartObjectName(),OBJPROP_YOFFSET,y);
  }
//+------------------------------------------------------------------+
//| Перемещение элемента                                             |
//+------------------------------------------------------------------+
void CListView::Moving(const bool only_visible=true)
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
      //--- Сохранение координат в полях объектов
      m_listview.X(m_main.X2()-m_listview.XGap());
     }
   else
     {
      CElementBase::X(m_main.X()+XGap());
      m_listview.X(m_main.X()+m_listview.XGap());
     }
//--- Если привязка снизу
   if(m_anchor_bottom_window_side)
     {
      CElementBase::Y(m_main.Y2()-YGap());
      m_listview.Y(m_main.Y2()-m_listview.YGap());
     }
   else
     {
      CElementBase::Y(m_main.Y()+YGap());
      m_listview.Y(m_main.Y()+m_listview.YGap());
     }
//--- Обновление координат графических объектов
   ::ObjectSetInteger(m_chart_id,m_listview.ChartObjectName(),OBJPROP_XDISTANCE,m_listview.X());
   ::ObjectSetInteger(m_chart_id,m_listview.ChartObjectName(),OBJPROP_YDISTANCE,m_listview.Y());
//--- Обновить положение объектов
   CElement::Moving(only_visible);
  }
//+------------------------------------------------------------------+
//| Показывает список                                                |
//+------------------------------------------------------------------+
void CListView::Show(void)
  {
//--- Выйти, если элемент уже видим
   if(CElementBase::IsVisible())
      return;
//--- Показать элемент
   ::ObjectSetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
   ::ObjectSetInteger(m_chart_id,m_listview.ChartObjectName(),OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
//--- Состояние видимости
   CElementBase::IsVisible(true);
//--- Обновить положение объектов
   Moving();
//--- Показать полосу прокрутки
   if(m_scrollv.IsScroll())
      m_scrollv.Show();
  }
//+------------------------------------------------------------------+
//| Скрывает список                                                  |
//+------------------------------------------------------------------+
void CListView::Hide(void)
  {
   if(!CElementBase::IsVisible())
      return;
//--- Скрыть элемент
   ::ObjectSetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   ::ObjectSetInteger(m_chart_id,m_listview.ChartObjectName(),OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
//--- Скрыть полосу прокрутки
   m_scrollv.Hide();
//--- Состояние видимости
   CElementBase::IsVisible(false);
  }
//+------------------------------------------------------------------+
//| Удаление                                                         |
//+------------------------------------------------------------------+
void CListView::Delete(void)
  {
   CElement::Delete();
   m_listview.Destroy();
//--- Освободить массив
   ::ArrayFree(m_items);
  }
//+------------------------------------------------------------------+
//| Установка приоритетов                                            |
//+------------------------------------------------------------------+
void CListView::SetZorders(void)
  {
   CElement::SetZorders();
   ::ObjectSetInteger(m_chart_id,m_listview.ChartObjectName(),OBJPROP_ZORDER,m_zorder+1);
  }
//+------------------------------------------------------------------+
//| Сброс приоритетов                                                |
//+------------------------------------------------------------------+
void CListView::ResetZorders(void)
  {
   CElement::ResetZorders();
   ::ObjectSetInteger(m_chart_id,m_listview.ChartObjectName(),OBJPROP_ZORDER,WRONG_VALUE);
  }
//+------------------------------------------------------------------+
//| Рисует элемент                                                   |
//+------------------------------------------------------------------+
void CListView::Draw(void)
  {
   DrawList();
  }
//+------------------------------------------------------------------+
//| Обновление элемента                                              |
//+------------------------------------------------------------------+
void CListView::Update(const bool redraw=false)
  {
//--- Перерисовать таблицу, если указано
   if(redraw)
     {
      //--- Рассчитать размеры
      CalculateListYSize();
      //--- Установить новый размер
      ChangeListSize();
      //--- Нарисовать
      Draw();
      //--- Применить
      m_canvas.Update();
      m_listview.Update();
      return;
     }
//--- Применить
   m_canvas.Update();
   m_listview.Update();
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на пункте списка                               |
//+------------------------------------------------------------------+
bool CListView::OnClickList(const string pressed_object)
  {
//--- Выйти, если (1) список не в фокусе или (2) полоса прокрутки в активном режиме
   if(!CElementBase::MouseFocus() || m_scrollv.State())
      return(false);
//--- Выйдем, если (1) чужое имя объекта или (2) список чист
   if(m_listview.ChartObjectName()!=pressed_object || ItemsTotal()<1)
      return(false);
//--- Определим пункт, на котором нажали
   int index=PressedItemIndex();
//--- Если список без чек-боксов
   if(!m_checkbox_mode)
     {
      //--- Скорректируем вертикальную полосу прокрутки
      CorrectingVerticalScrollThumb();
      //--- Изменить цвет пункта
      RedrawItemsByMode(true);
     }
   else
     {
      //--- Изменим состояние чек-бокса на противоположное
      m_items[index].m_state=!m_items[index].m_state;
      //--- Обновить список
      RedrawItem(index);
     }
//--- Отправим сообщение об этом
   ::EventChartCustom(m_chart_id,ON_CLICK_LIST_ITEM,CElementBase::Id(),m_selected_item,"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Возвращает индекс пункта, на котором нажали                      |
//+------------------------------------------------------------------+
int CListView::PressedItemIndex(void)
  {
   int index=0;
//--- Получим относительную Y-координату под курсором мыши
   int y=m_mouse.RelativeY(m_listview);
//--- Определим ряд, на котором нажали
   for(int i=0; i<m_items_total; i++)
     {
      //--- Если нажатие было не на этом ряде, перейти к следующему
      if(!(y>=m_items[i].m_y && y<=m_items[i].m_y2))
         continue;
      //--- Запомним индекс
      index=i;
      //--- Если список без чек-боксов
      if(!m_checkbox_mode)
        {
         //--- Сохраним индекс ряда и строку первой ячейки
         m_prev_selected_item =(m_selected_item==WRONG_VALUE)? index : m_selected_item;
         m_selected_item      =index;
         m_selected_item_text =m_items[index].m_value;
        }
      break;
     }
//--- Вернуть индекс
   return(index);
  }
//+------------------------------------------------------------------+
//| Ускоренная перемотка списка                                      |
//+------------------------------------------------------------------+
void CListView::FastSwitching(void)
  {
//--- Выйдем, если нет фокуса на списке
   if(!CElementBase::MouseFocus())
      return;
//--- Вернём счётчик к первоначальному значению, если кнопка мыши отжата
   if(!m_mouse.LeftButtonState())
      m_timer_counter=SPIN_DELAY_MSC;
//--- Если же кнопка мыши нажата
   else
     {
      //--- Увеличим счётчик на установленный интервал
      m_timer_counter+=TIMER_STEP_MSC;
      //--- Выйдем, если меньше нуля
      if(m_timer_counter<0)
         return;
      //--- Флаг перемотки
      bool scroll_v=false;
      //--- Если прокрутка вверх
      if(m_scrollv.GetIncButtonPointer().MouseFocus())
        {
         m_scrollv.OnClickScrollInc((uint)Id(),0);
         scroll_v=true;
        }
      //--- Если прокрутка вниз
      else if(m_scrollv.GetDecButtonPointer().MouseFocus())
        {
         m_scrollv.OnClickScrollDec((uint)Id(),1);
         scroll_v=true;
        }
      //--- Выйти, если кнопки не нажаты
      if(!scroll_v)
         return;
      //--- Обновить список
      ShiftData();
      m_scrollv.Update(true);
     }
  }
//+------------------------------------------------------------------+
//| Рассчитывает полный размер списка по оси Y                       |
//+------------------------------------------------------------------+
void CListView::CalculateListYSize(void)
  {
//--- Рассчитаем общую высоту таблицы
   int y_size    =(m_item_y_size*m_items_total)+(m_y_offset*2)+1;
   m_list_y_size =(y_size<=m_y_size)? m_y_size-2 : y_size;
//--- Зададим высоту фрейма для показа фрагмента изображения (видимой части таблицы таблицы)
   m_list_visible_y_size=m_y_size-2;
//--- Корректировка размера видимой части по оси Y
   m_list_visible_y_size=(m_list_visible_y_size>=m_list_y_size)? m_list_y_size : m_list_visible_y_size;
//--- Расчёт координат
   for(int i=0; i<m_items_total; i++)
     {
      //--- Рассчитаем Y-координаты
      m_items[i].m_y  =(i<1)? m_y_offset : m_items[i-1].m_y2;
      m_items[i].m_y2 =m_items[i].m_y+m_item_y_size;
     }
  }
//+------------------------------------------------------------------+
//| Изменить основные размеры элемента                               |
//+------------------------------------------------------------------+
void CListView::ChangeMainSize(const int x_size,const int y_size)
  {
//--- Установить новый размер
   CElementBase::XSize(x_size);
   CElementBase::YSize(y_size);
  }
//+------------------------------------------------------------------+
//| Изменить размеры поля ввода                                      |
//+------------------------------------------------------------------+
void CListView::ChangeListSize(void)
  {
   int x_size=m_x_size-2;
//--- Установить новый размер таблице
   m_canvas.XSize(m_x_size);
   m_canvas.YSize(m_y_size);
   m_canvas.Resize(m_x_size,m_y_size);
   m_listview.XSize(x_size);
   m_listview.YSize(m_list_y_size);
   m_listview.Resize(x_size,m_list_y_size);
//--- Установим размеры видимой области
   ::ObjectSetInteger(m_chart_id,m_listview.ChartObjectName(),OBJPROP_XSIZE,x_size);
   ::ObjectSetInteger(m_chart_id,m_listview.ChartObjectName(),OBJPROP_YSIZE,m_list_visible_y_size);
//--- Изменить размеры полос прокрутки
   ChangeScrollsSize();
//--- Корректировка данных
   ShiftData();
  }
//+------------------------------------------------------------------+
//| Изменить размеры полос прокрутки                                 |
//+------------------------------------------------------------------+
void CListView::ChangeScrollsSize(void)
  {
//--- Расчёт количества шагов для смещения
   uint y_size_total         =ItemsTotal();
   uint visible_y_size_total =VisibleItemsTotal();
//--- Рассчитать размеры полос прокрутки
   m_scrollv.Reinit(y_size_total,visible_y_size_total);
//--- Установить новый размер
   m_scrollv.ChangeYSize(CElementBase::YSize()-2);
//--- Если вертикальная полоса прокрутки не нужна
   if(!m_scrollv.IsScroll())
     {
      //--- Скрыть вертикальную полосу прокрутки
      m_scrollv.Hide();
     }
   else
     {
      //--- Показать вертикальную полосу прокрутки
      if(CElementBase::IsVisible())
         m_scrollv.Show();
     }
  }
//+------------------------------------------------------------------+
//| Расчёт с учётом последних изменений и изменение размеров списка  |
//+------------------------------------------------------------------+
void CListView::RecalculateAndResizeList(const bool redraw=false)
  {
//--- Рассчитать размеры списка
   CalculateListYSize();
//--- Установить новый размер
   ChangeListSize();
//--- Обновить
   Update(redraw);
  }
//+------------------------------------------------------------------+
//| Инициализация указанного пункта значениями по умолчанию          |
//+------------------------------------------------------------------+
void CListView::ItemInitialize(const uint item_index)
  {
   m_items[item_index].m_y     =0;
   m_items[item_index].m_y2    =0;
   m_items[item_index].m_value ="";
   m_items[item_index].m_state =false;
  }
//+------------------------------------------------------------------+
//| Делает копию указанного пункта (source) в новое место (dest.)    |
//+------------------------------------------------------------------+
void CListView::ItemCopy(const uint item_dest,const uint item_source)
  {
   m_items[item_dest].m_value =m_items[item_source].m_value;
   m_items[item_dest].m_state =m_items[item_source].m_state;
  }
//+------------------------------------------------------------------+
//| Расчёт ширины пунктов                                            |
//+------------------------------------------------------------------+
int CListView::CalculationItemsWidth(void)
  {
   return((m_scrollv.IsScroll()) ? CElementBase::XSize()-m_scrollv.ScrollWidth()-3 : CElementBase::XSize()-3);
  }
//+------------------------------------------------------------------+
//| Расчёт границ элемента по оси Y                                  |
//+------------------------------------------------------------------+
void CListView::CalculateYBoundaries(void)
  {
//--- Выйти, если полосы прокрутки нет
   if(!m_scrollv.IsVisible())
      return;
//--- Получим Y-координату и смещение по оси Y
   int y       =(int)::ObjectGetInteger(m_chart_id,m_listview.ChartObjectName(),OBJPROP_YDISTANCE);
   int yoffset =(int)::ObjectGetInteger(m_chart_id,m_listview.ChartObjectName(),OBJPROP_YOFFSET);
//--- Рассчитаем границы видимой части поля ввода
   m_y_limit  =(y+yoffset)-y;
   m_y2_limit =(y+yoffset+m_y_size)-y;
  }
//+------------------------------------------------------------------+
//| Корректировка вертикальной полосы прокрутки                      |
//+------------------------------------------------------------------+
void CListView::CorrectingVerticalScrollThumb(void)
  {
//--- Получим границы видимой части поля ввода
   CalculateYBoundaries();
//--- Если текстовый курсор вышел из поля видимости вверх
   if(m_items[m_selected_item].m_y<=m_y_limit)
     {
      Scrolling(CalculateScrollPosY());
     }
//--- Если текстовый курсор вышел из поля видимости вниз
   else if(m_items[m_selected_item].m_y2>=m_y2_limit)
     {
      Scrolling(CalculateScrollPosY(true));
     }
  }
//+------------------------------------------------------------------+
//| Расчёт Y-позиции ползунка полосы прокрутки                       |
//+------------------------------------------------------------------+
int CListView::CalculateScrollPosY(const bool to_down=false)
  {
   int    calc_y      =(!to_down)? CalculateScrollThumbY() : CalculateScrollThumbY2();
   double pos_y_value =(calc_y-::fmod((double)calc_y,(double)m_item_y_size))/m_item_y_size+((!to_down)? 0 : 1);
//---
   return((int)pos_y_value);
  }
//+------------------------------------------------------------------+
//| Расчёт Y-координаты полосы прокрутки в верхней границе списка    |
//+------------------------------------------------------------------+
int CListView::CalculateScrollThumbY(void)
  {
   return(m_items[m_selected_item].m_y-m_y_offset);
  }
//+------------------------------------------------------------------+
//| Расчёт Y-координаты полосы прокрутки в нижней границе списка     |
//+------------------------------------------------------------------+
int CListView::CalculateScrollThumbY2(void)
  {
//--- Рассчитать и вернуть значение
   return(m_items[m_selected_item].m_y-m_y_size+m_item_y_size);
  }
//+------------------------------------------------------------------+
//| Определение индексов видимой области списка                      |
//+------------------------------------------------------------------+
void CListView::VisibleListIndexes(void)
  {
//--- Определяем границы с учётом смещения видимой области таблицы
   int yoffset1 =(int)::ObjectGetInteger(m_chart_id,m_listview.ChartObjectName(),OBJPROP_YOFFSET);
   int yoffset2 =yoffset1+m_list_visible_y_size;
//--- Определяем первый и последний индексы видимой области таблицы
   m_visible_list_from_index =int(double(yoffset1/m_item_y_size));
   m_visible_list_to_index   =int(double(yoffset2/m_item_y_size));
//--- Нижний индекс на один больше, если не выходим из диапазона
   m_visible_list_to_index=(m_visible_list_to_index+1>m_items_total)? m_items_total : m_visible_list_to_index+1;
  }
//+------------------------------------------------------------------+
//| Рисует список                                                    |
//+------------------------------------------------------------------+
void CListView::DrawList(const bool only_visible=false)
  {
//--- Если не указано перерисовать только видимую часть списка
   if(!only_visible)
     {
      //--- Установим индексы строк всего списка от самого начала и до конца
      m_visible_list_from_index =0;
      m_visible_list_to_index   =m_items_total;
     }
//--- Получим индексы строк видимой части списка
   else
      VisibleListIndexes();
//--- Нарисовать фон
   DrawBackground();
   m_listview.Erase(::ColorToARGB(m_back_color,m_alpha));
//--- Нарисовать картинки
   DrawImages();
//--- Нарисовать текст
   DrawText();
//--- Нарисовать рамку
   DrawBorder();
  }
//+------------------------------------------------------------------+
//| Рисует рамку поля ввода                                          |
//+------------------------------------------------------------------+
void CListView::DrawBorder(void)
  {
//--- Получим смещение по оси X
   int x_offset =(int)::ObjectGetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_XOFFSET);
   int y_offset =(int)::ObjectGetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_YOFFSET);
//--- Границы
   int x_size =(int)::ObjectGetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_XSIZE);
   int y_size =(int)::ObjectGetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_YSIZE);
//--- Координаты
   int x1 =x_offset;
   int y1 =y_offset;
   int x2 =x_offset+x_size;
   int y2 =y_offset+y_size;
//--- Рисуем прямоугольник без заливки
   m_canvas.Rectangle(x1,y1,x2-1,y2-1,::ColorToARGB(m_border_color));
  }
//+------------------------------------------------------------------+
//| Рисует картинки                                                  |
//+------------------------------------------------------------------+
void CListView::DrawImages(void)
  {
//--- Выйти, если чек-боксы отключены
   if(!m_checkbox_mode)
      return;
//--- Рисуем чек-боксы в пунктах
   for(int i=m_visible_list_from_index; i<m_visible_list_to_index; i++)
     {
      //--- Расчёт координат
      m_images_group[0].m_y_gap=m_items[i].m_y+m_icon_y_gap;
      //--- Установить соответствующую картинку
      CElement::ChangeImage(0,(m_items[i].m_state)? 2 : 0);
      CListView::DrawImage();
     }
  }
//+------------------------------------------------------------------+
//| Рисует картинку                                                  |
//+------------------------------------------------------------------+
void CListView::DrawImage(void)
  {
//--- Индекс изображения
   int i=SelectedImage();
//--- Если нет изображений
   if(i==WRONG_VALUE)
      return;
//--- Координаты
   int x =m_images_group[0].m_x_gap;
   int y =m_images_group[0].m_y_gap;
//--- Размеры
   uint height =m_images_group[0].m_image[i].Height();
   uint width  =m_images_group[0].m_image[i].Width();
//--- Рисуем
   for(uint ly=0,p=0; ly<height; ly++)
     {
      for(uint lx=0; lx<width; lx++,p++)
        {
         //--- Если нет цвета, перейти к следующему пикселю
         if(m_images_group[0].m_image[i].Data(p)<1)
            continue;
         //--- Получаем цвет нижнего слоя (фона ячейки) и цвет указанного пикселя картинки
         uint background  =::ColorToARGB(m_listview.PixelGet(x+lx,y+ly));
         uint pixel_color =m_images_group[0].m_image[i].Data(p);
         //--- Смешиваем цвета
         uint foreground=::ColorToARGB(m_clr.BlendColors(background,pixel_color));
         //--- Рисуем пиксель наслаиваемого изображения
         m_listview.PixelSet(x+lx,y+ly,foreground);
        }
     }
  }
//+------------------------------------------------------------------+
//| Рисует картинку                                                  |
//+------------------------------------------------------------------+
void CListView::DrawText(void)
  {
//--- Для расчёта координат и отступов
   int x=0,y=0;
//--- Свойства шрифта
   m_listview.FontSet(CElement::Font(),-CElement::FontSize()*10,FW_NORMAL);
//--- Ряды
   for(int i=m_visible_list_from_index; i<m_visible_list_to_index; i++)
     {
      //--- Нарисовать фон строки
      int x1 =0;
      int x2 =CalculationItemsWidth();
      int y1 =m_items[i].m_y;
      int y2 =m_items[i].m_y2;
      //---
      if(i==m_selected_item)
        {
         m_listview.FillRectangle(x1,y1,x2,y2,ItemColorCurrent(i,false));
         m_listview.Rectangle(x1,y1,x2,y2,::ColorToARGB(m_back_color,m_alpha));
        }
      //--- Нарисовать текст
      x =m_label_x_gap;
      y =m_items[i].m_y+m_label_y_gap;
      m_listview.TextOut(x,y,m_items[i].m_value,TextColor(i),TA_LEFT|TA_TOP);
     }
  }
//+------------------------------------------------------------------+
//| Перерисовывает указанный пункт списка                            |
//+------------------------------------------------------------------+
void CListView::RedrawItem(const int item_index)
  {
//--- Координаты
   int x1 =0;
   int x2 =CalculationItemsWidth();
   int y1 =m_items[item_index].m_y;
   int y2 =m_items[item_index].m_y2;
//--- Для расчёта координат
   int x=0,y=0;
//--- Для проверки фокуса
   bool is_item_focus=false;
//--- Если включен режим подсветки строк списка
   if(m_lights_hover)
     {
      //--- (1) Получим относительную Y-координату курсора мыши и (2) фокус на указанной строке таблицы
      y=m_mouse.RelativeY(m_listview);
      is_item_focus=(y>m_items[item_index].m_y && y<=m_items[item_index].m_y2);
     }
//--- Нарисовать пункт
   m_listview.FillRectangle(x1,y1,x2,y2,ItemColorCurrent(item_index,is_item_focus));
//--- Нарисовать рамку
   m_listview.Rectangle(x1,y1,x2,y2,::ColorToARGB(m_back_color,m_alpha));
//--- Рисуем картинки, если список с чек-боксами
   if(m_checkbox_mode)
     {
      //--- Расчёт координат
      m_images_group[0].m_y_gap=m_items[item_index].m_y+m_icon_y_gap;
      //--- Установить соответствующую картинку
      CElement::ChangeImage(0,(m_items[item_index].m_state)? 2 : 0);
      CListView::DrawImage();
     }
//--- Нарисовать текст
   x1 =m_label_x_gap;
   y1 =m_items[item_index].m_y+m_label_y_gap;
   m_listview.TextOut(x1,y1,m_items[item_index].m_value,TextColor(item_index),TA_LEFT|TA_TOP);
//--- Обновить холст
   m_listview.Update();
  }
//+------------------------------------------------------------------+
//| Перерисовывает пункты списка по указанному режиму                |
//+------------------------------------------------------------------+
void CListView::RedrawItemsByMode(const bool is_selected_item=false)
  {
//--- Текущий и предыдущий индексы строк
   int item_index      =WRONG_VALUE;
   int prev_item_index =WRONG_VALUE;
//--- Инициализиция индексов строк относительного указанного режима
   if(is_selected_item)
     {
      item_index      =m_selected_item;
      prev_item_index =m_prev_selected_item;
     }
   else
     {
      item_index      =m_item_index_focus;
      prev_item_index =m_prev_item_index_focus;
     }
//--- Выйти, если индексы не определены
   if(prev_item_index==WRONG_VALUE && item_index==WRONG_VALUE)
      return;
//--- Количество пунктов для рисования
   uint items_total=(item_index!=WRONG_VALUE && prev_item_index!=WRONG_VALUE && item_index!=prev_item_index)? 2 : 1;
//--- Координаты
   int x1=0;
   int x2=CalculationItemsWidth();
   int y1[2]={0},y2[2]={0};
//--- Массив для значений в определённой последовательности
   int indexes[2];
//--- Если (1) курсор мыши сдвинулся вниз или (2) в первый раз здесь
   if(item_index>m_prev_item_index_focus || item_index==WRONG_VALUE)
     {
      indexes[0]=(item_index==WRONG_VALUE || prev_item_index!=WRONG_VALUE)? prev_item_index : item_index;
      indexes[1]=item_index;
     }
//--- Если курсор мыши сдвинулся вверх
   else
     {
      indexes[0]=item_index;
      indexes[1]=prev_item_index;
     }
//--- Рисуем фон пунктов
   for(uint i=0; i<items_total; i++)
     {
      //--- Расчёт координат верхней и нижней границ строки
      y1[i] =m_items[indexes[i]].m_y;
      y2[i] =m_items[indexes[i]].m_y2;
      //--- Определим фокус на строке относительно режима подсветки
      bool is_item_focus=false;
      if(!m_lights_hover)
         is_item_focus=(indexes[i]==item_index && item_index!=WRONG_VALUE);
      else
         is_item_focus=(item_index==WRONG_VALUE)?(indexes[i]==prev_item_index) :(indexes[i]==item_index);
      //--- Нарисовать пункт
      m_listview.FillRectangle(x1,y1[i],x2,y2[i],ItemColorCurrent(indexes[i],is_item_focus));
      //--- Нарисовать рамку
      m_listview.Rectangle(x1,y1[i],x2,y2[i],::ColorToARGB(m_back_color,m_alpha));
     }
//--- Рисуем картинки, если список с чек-боксами
   if(m_checkbox_mode)
     {
      for(uint i=0; i<items_total; i++)
        {
         //--- Расчёт координат
         m_images_group[0].m_y_gap=m_items[indexes[i]].m_y+m_icon_y_gap;
         //--- Установить соответствующую картинку
         CElement::ChangeImage(0,(m_items[indexes[i]].m_state)? 2 : 0);
         CListView::DrawImage();
        }
     }
//--- Для расчёта координат
   int x=0,y=0;
//--- Получим X-координату текста
   x=m_label_x_gap;
//--- Рисуем текст
   for(uint i=0; i<items_total; i++)
     {
      //--- (1) Рассчитать координату и (2) нарисовать текст
      y=m_items[indexes[i]].m_y+m_label_y_gap;
      m_listview.TextOut(x,y,m_items[indexes[i]].m_value,TextColor(indexes[i]),TA_TOP|TA_LEFT);
     }
//--- Применить
   m_listview.Update();
  }
//+------------------------------------------------------------------+
//| Возвращает текущий цвет фона пункта                              |
//+------------------------------------------------------------------+
uint CListView::ItemColorCurrent(const int item_index,const bool is_item_focus)
  {
//--- Если выделенная строка
   if(item_index==m_selected_item)
      return(::ColorToARGB(m_back_color_pressed,m_alpha));
//--- Цвет пункта
   uint clr=m_back_color;
//--- Если (1) нет фокуса или (2) форма заблокирована
   bool condition=(!is_item_focus || !m_canvas.MouseFocus() || m_main.CElementBase::IsLocked());
//---
   clr=(condition)? m_back_color : m_back_color_hover;
//--- Вернуть цвет
   return(::ColorToARGB(clr,m_alpha));
  }
//+------------------------------------------------------------------+
//| Возвращает цвет текста пункта                                    |
//+------------------------------------------------------------------+
uint CListView::TextColor(const int item_index)
  {
   uint clr=(item_index==m_selected_item)? m_label_color_pressed : m_label_color;
//--- Вернуть цвет заголовка
   return(::ColorToARGB(clr));
  }
//+------------------------------------------------------------------+
//| Изменить ширину по правому краю формы                            |
//+------------------------------------------------------------------+
void CListView::ChangeWidthByRightWindowSide(void)
  {
//--- Выйти, если включен режим фиксации к правому краю формы
   if(m_anchor_right_window_side)
      return;
//--- Размеры
   int x_size =m_main.X2()-CElementBase::X()-m_auto_xresize_right_offset;
   int y_size =(m_auto_yresize_mode)? m_main.Y2()-CElementBase::Y()-m_auto_yresize_bottom_offset : m_y_size;
//--- Установить новый размер
   ChangeMainSize(x_size,y_size);
//--- Рассчитать размеры поля ввода
   CalculateListYSize();
//--- Установить новый размер полю ввода
   ChangeListSize();
//--- Нарисовать элемент
   Draw();
   Update();
   if(m_scrollv.IsScroll())
      m_scrollv.Update(true);
  }
//+------------------------------------------------------------------+
//| Изменить высоту по нижнему краю окна                             |
//+------------------------------------------------------------------+
void CListView::ChangeHeightByBottomWindowSide(void)
  {
//--- Выйти, если включен режим фиксации к нижнему краю формы  
   if(m_anchor_bottom_window_side)
      return;
//--- Размеры
   int x_size =(m_auto_xresize_mode)? m_main.X2()-CElementBase::X()-m_auto_xresize_right_offset : m_x_size;
   int y_size =m_main.Y2()-CElementBase::Y()-m_auto_yresize_bottom_offset;
//--- Установить новый размер
   ChangeMainSize(x_size,y_size);
//--- Рассчитать размеры списка
   CalculateListYSize();
//--- Установить новый размер полю ввода
   ChangeListSize();
//--- Нарисовать элемент
   Draw();
   Update();
   if(m_scrollv.IsScroll())
      m_scrollv.Update(true);
  }
//+------------------------------------------------------------------+
