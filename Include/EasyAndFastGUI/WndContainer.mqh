//+------------------------------------------------------------------+
//|                                                 WndContainer.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property strict
#include "Controls\Button.mqh"
#include "Controls\ButtonsGroup.mqh"
#include "Controls\Calendar.mqh"
#include "Controls\CheckBox.mqh"
#include "Controls\ColorButton.mqh"
#include "Controls\ColorPicker.mqh"
#include "Controls\ComboBox.mqh"
#include "Controls\ContextMenu.mqh"
#include "Controls\DropCalendar.mqh"
#include "Controls\FileNavigator.mqh"
#include "Controls\Frame.mqh"
#include "Controls\Graph.mqh"
#include "Controls\ListView.mqh"
#include "Controls\MenuBar.mqh"
#include "Controls\MenuItem.mqh"
#include "Controls\Picture.mqh"
#include "Controls\PicturesSlider.mqh"
#include "Controls\ProgressBar.mqh"
#include "Controls\SeparateLine.mqh"
#include "Controls\Slider.mqh"
#include "Controls\SplitButton.mqh"
#include "Controls\StandardChart.mqh"
#include "Controls\StatusBar.mqh"
#include "Controls\Table.mqh"
#include "Controls\Tabs.mqh"
#include "Controls\TextBox.mqh"
#include "Controls\TextEdit.mqh"
#include "Controls\TextLabel.mqh"
#include "Controls\TimeEdit.mqh"
#include "Controls\Tooltip.mqh"
#include "Controls\TreeItem.mqh"
#include "Controls\TreeView.mqh"
#include "Controls\Window.mqh"
//--- Резервный размер массивов
#define RESERVE_SIZE_ARRAY 1000
//+------------------------------------------------------------------+
//| Класс для хранения всех объектов интерфейса                      |
//+------------------------------------------------------------------+
class CWndContainer
  {
private:
   //--- Счётчик элементов
   int               m_counter_element_id;
   //---
protected:
   //--- Экземпляр класса для получения параметров мыши
   CMouse            m_mouse;
   //--- Массив окон
   CWindow          *m_windows[];
   //--- Структура массивов элементов
   struct WindowElements
     {
      //--- Общий массив всех элементов
      CElement         *m_elements[];
      //--- Массив главных элементов
      CElement         *m_main_elements[];
      //--- Элементы с таймером
      CElement         *m_timer_elements[];
      //--- Видимые и доступные в данный момент элементы
      CElement         *m_available_elements[];
      //--- Элементы с авто-изменением размеров по оси X
      CElement         *m_auto_x_resize_elements[];
      //--- Элементы с авто-изменением размеров по оси Y
      CElement         *m_auto_y_resize_elements[];
      //--- Персональные массивы элементов:
      CContextMenu     *m_context_menus[];    // Контекстные меню
      CComboBox        *m_combo_boxes[];      // Комбо-боксы
      CSplitButton     *m_split_buttons[];    // Сдвоенные кнопки
      CMenuBar         *m_menu_bars[];        // Главные меню
      CMenuItem        *m_menu_items[];       // Пункты меню
      CElementBase     *m_drop_lists[];       // Выпадающие списки
      CElementBase     *m_scrolls[];          // Полосы прокрутки
      CElementBase     *m_tables[];           // Таблицы
      CTabs            *m_tabs[];             // Вкладки
      CSlider          *m_sliders[];          // Слайдеры
      CCalendar        *m_calendars[];        // Календари
      CDropCalendar    *m_drop_calendars[];   // Выпадающие календари
      CStandardChart   *m_sub_charts[];       // Стандартные графики
      CTimeEdit        *m_time_edits[];       // Элементы "Время"
      CTextBox         *m_text_boxes[];       // Многострочные поля ввода
      CTreeView        *m_treeview_lists[];   // Древовидные списки
      CFileNavigator   *m_file_navigators[];  // Файловые навигаторы
      CTooltip         *m_tooltips[];         // Всплывающие подсказки
      CPicturesSlider  *m_pictures_slider[];  // Слайдеры картинок
      CFrame           *m_frames[];           // Области
     };
   //--- Массив массивов элементов для каждого окна
   WindowElements    m_wnd[];
   
//  void PrintContainer(void) {
//    string out = 
//      " > m_elements (" + (string)ArraySize(m_wnd[0].m_elements) + ")\n" +
//      " > m_main_elements (" + (string)ArraySize(m_wnd[0].m_main_elements) + ")\n" +
//      
//      " > m_menu_bars (" + (string)ArraySize(m_wnd[0].m_menu_bars) + ")\n" +
//      " > m_menu_items (" + (string)ArraySize(m_wnd[0].m_menu_items) + ")\n" +
//      " > m_context_menus (" + (string)ArraySize(m_wnd[0].m_context_menus) + ")\n";
//      
//    Print(__FUNCTION__, ":");
//    Print(out);
//  }
   //---
public:
                     CWndContainer(void);
                    ~CWndContainer(void);
   //---
public:
   //--- Количество окон в интерфейсе
   int               WindowsTotal(void) { return(::ArraySize(m_windows)); }
   //--- Количество всех элементов
   int               ElementsTotal(const int window_index);
   //--- Количество главных элементов
   int               MainElementsTotal(const int window_index);
   //--- Количество элементов с таймерами
   int               TimerElementsTotal(const int window_index);
   //--- Количество элементов с авто-ресайзом по оси X
   int               AutoXResizeElementsTotal(const int window_index);
   //--- Количество элементов с авто-ресайзом по оси Y
   int               AutoYResizeElementsTotal(const int window_index);
   //--- Количество доступных в данный момент элементов
   int               AvailableElementsTotal(const int window_index);
   //--- Количество элементов указанного типа
   int               ElementsTotal(const int window_index,const ENUM_ELEMENT_TYPE type);
   //---
protected:
   //--- Добавляет указатель окна в базу элементов интерфейса
   void              AddWindow(CWindow &object);
   //--- Добавляет указатель в массив элементов
   void              AddToElementsArray(const int window_index,CElementBase &object);
   //--- Добавляет указатель в массив элементов с таймерами
   void              AddTimerElement(const int window_index,CElement &object);
   //--- Добавляет указатель в массив элементов с авто-ресайзом по оси X
   void              AddAutoXResizeElement(const int window_index,CElement &object);
   //--- Добавляет указатель в массив элементов с авто-ресайзом по оси Y
   void              AddAutoYResizeElement(const int window_index,CElement &object);
   //--- Добавляет указатель в массив доступных на данный элементов
   void              AddAvailableElement(const int window_index,CElement &object);
   //---
private:
   //--- Увеличивает массив на один элемент и возвращает последний индекс
   template<typename T>
   int               ResizeArray(T &array[]);
   //--- Шаблонный метод для добавления указателей в переданный по ссылке массив
   template<typename T1,typename T2>
   void              AddToPersonalArray(T1 &object,T2 &array[]);
   //---
private:
   //--- Проверка выхода из диапазона
   int               CheckOutOfRange(const int window_index);
   //--- Сохраняет указатели на объекты окна
   bool              AddWindowElements(const int window_index,CElementBase &object);
   //--- Сохраняет указатели на элементы контекстного меню
   bool              AddContextMenuElements(const int window_index,CElementBase &object);
   //--- Сохраняет указатели на элементы главного меню
   bool              AddMenuBarElements(const int window_index,CElementBase &object);
   //--- Сохраняет указатели на элементы пункта меню
   bool              AddMenuItemElements(const int window_index,CElementBase &object);
   //--- Сохраняет указатели на элементы статусной строки
   bool              AddStatusBarElements(const int window_index,CElementBase &object);
   //--- Сохраняет указатели на элементы сдвоенной кнопки
   bool              AddSplitButtonElements(const int window_index,CElementBase &object);
   //--- Сохраняет указатели на элементы группы вкладок
   bool              AddButtonsGroupElements(const int window_index,CElementBase &object);
   //--- Сохраняет указатели на объекты списка
   bool              AddListViewElements(const int window_index,CElementBase &object);
   //--- Сохраняет указатели на объекты полосы прокрутки в базу
   bool              AddScrollElements(const int window_index,CElementBase &object);
   //--- Сохраняет указатели на элементы выпадающих списков (комбо-бокс)
   bool              AddComboBoxElements(const int window_index,CElementBase &object);
   //--- Сохраняет указатели на элементы кнопок для вызова цветовой палитры
   bool              AddColorButtonElements(const int window_index,CElementBase &object);
   //--- Сохраняет указатели на элементы таблицы
   bool              AddTableElements(const int window_index,CElementBase &object);
   //--- Сохраняет указатели на вкладки в персональный массив
   bool              AddTabsElements(const int window_index,CElementBase &object);
   //--- Сохраняет указатели на элементы календаря
   bool              AddCalendarElements(const int window_index,CElementBase &object);
   //--- Сохраняет указатели на элементы выпадающего календаря
   bool              AddDropCalendarElements(const int window_index,CElementBase &object);
   //--- Сохраняет указатели на элементы цветовой палитры
   bool              AddColorPickersElements(const int window_index,CElementBase &object);
   //--- Сохраняет указатели на элементы объектов-графиков
   bool              AddSubChartsElements(const int window_index,CElementBase &object);
   //--- Сохраняет указатели на элементы слайдеров картинок
   bool              AddPicturesSliderElements(const int window_index,CElementBase &object);
   //--- Сохраняет указатели на элементы "Время"
   bool              AddTimeEditsElements(const int window_index,CElementBase &object);
   //--- Сохраняет указатели на объекты многострочного поля ввода
   bool              AddTextBoxElements(const int window_index,CElementBase &object);
   //--- Сохраняет указатели на объекты текстового поля ввода
   bool              AddTextEditElements(const int window_index,CElementBase &object);
   //--- Сохраняет указатели на объекты слайдера
   bool              AddSliderElements(const int window_index,CElementBase &object);
   //--- Сохраняет указатели на элементы древовидных списков
   bool              AddTreeViewListsElements(const int window_index,CElementBase &object);
   //--- Сохраняет указатели на элементы навигатора
   bool              AddFileNavigatorElements(const int window_index,CElementBase &object);
   //--- Сохраняет указатели на элементы всплывающих подсказок
   bool              AddTooltipElements(const int window_index,CElementBase &object);
   //--- Сохраняет указатели на элементы областей
   bool              AddFrameElements(const int window_index,CElementBase &object);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CWndContainer::CWndContainer(void) : m_counter_element_id(0)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CWndContainer::~CWndContainer(void)
  {
  }
//+------------------------------------------------------------------+
//| Кол-во элементов по указанному индексу окна                      |
//+------------------------------------------------------------------+
int CWndContainer::ElementsTotal(const int window_index)
  {
   int index=CheckOutOfRange(window_index);
   return((index!=WRONG_VALUE)? ::ArraySize(m_wnd[index].m_elements) : WRONG_VALUE);
  }
//+------------------------------------------------------------------+
//| Кол-во главных элементов по указанному индексу окна              |
//+------------------------------------------------------------------+
int CWndContainer::MainElementsTotal(const int window_index)
  {
   int index=CheckOutOfRange(window_index);
   return((index!=WRONG_VALUE)? ::ArraySize(m_wnd[index].m_main_elements) : WRONG_VALUE);
  }
//+------------------------------------------------------------------+
//| Кол-во элементов с таймерами по указанному индексу окна          |
//+------------------------------------------------------------------+
int CWndContainer::TimerElementsTotal(const int window_index)
  {
   int index=CheckOutOfRange(window_index);
   return((index!=WRONG_VALUE)? ::ArraySize(m_wnd[index].m_timer_elements) : WRONG_VALUE);
  }
//+------------------------------------------------------------------+
//| Количество доступных в данный момент элементов                   |
//+------------------------------------------------------------------+
int CWndContainer::AvailableElementsTotal(const int window_index)
  {
   int index=CheckOutOfRange(window_index);
   return((index!=WRONG_VALUE)? ::ArraySize(m_wnd[index].m_available_elements) : WRONG_VALUE);
  }
//+------------------------------------------------------------------+
//| Кол-во элементов с авто-ресайзом (X) по указанному индексу окна  |
//+------------------------------------------------------------------+
int CWndContainer::AutoXResizeElementsTotal(const int window_index)
  {
   int index=CheckOutOfRange(window_index);
   return((index!=WRONG_VALUE)? ::ArraySize(m_wnd[index].m_auto_x_resize_elements) : WRONG_VALUE);
  }
//+------------------------------------------------------------------+
//| Кол-во элементов с авто-ресайзом (Y) по указанному индексу окна  |
//+------------------------------------------------------------------+
int CWndContainer::AutoYResizeElementsTotal(const int window_index)
  {
   int index=CheckOutOfRange(window_index);
   return((index!=WRONG_VALUE)? ::ArraySize(m_wnd[index].m_auto_y_resize_elements) : WRONG_VALUE);
  }
//+------------------------------------------------------------------+
//| Кол-во элементов по указанному индексу окна указанного типа      |
//+------------------------------------------------------------------+
int CWndContainer::ElementsTotal(const int window_index,const ENUM_ELEMENT_TYPE type)
  {
//--- Проверка на выход из диапазона
   int index=CheckOutOfRange(window_index);
   if(index==WRONG_VALUE)
      return(WRONG_VALUE);
//---
   int elements_total=0;
//---
   switch(type)
     {
      case E_CONTEXT_MENU    : elements_total=::ArraySize(m_wnd[index].m_context_menus);   break;
      case E_COMBO_BOX       : elements_total=::ArraySize(m_wnd[index].m_combo_boxes);     break;
      case E_SPLIT_BUTTON    : elements_total=::ArraySize(m_wnd[index].m_split_buttons);   break;
      case E_MENU_BAR        : elements_total=::ArraySize(m_wnd[index].m_menu_bars);       break;
      case E_MENU_ITEM       : elements_total=::ArraySize(m_wnd[index].m_menu_items);      break;
      case E_DROP_LIST       : elements_total=::ArraySize(m_wnd[index].m_drop_lists);      break;
      case E_SCROLL          : elements_total=::ArraySize(m_wnd[index].m_scrolls);         break;
      case E_TABLE           : elements_total=::ArraySize(m_wnd[index].m_tables);          break;
      case E_TABS            : elements_total=::ArraySize(m_wnd[index].m_tabs);            break;
      case E_SLIDER          : elements_total=::ArraySize(m_wnd[index].m_sliders);         break;
      case E_CALENDAR        : elements_total=::ArraySize(m_wnd[index].m_calendars);       break;
      case E_DROP_CALENDAR   : elements_total=::ArraySize(m_wnd[index].m_drop_calendars);  break;
      case E_SUB_CHART       : elements_total=::ArraySize(m_wnd[index].m_sub_charts);      break;
      case E_PICTURES_SLIDER : elements_total=::ArraySize(m_wnd[index].m_pictures_slider); break;
      case E_TIME_EDIT       : elements_total=::ArraySize(m_wnd[index].m_time_edits);      break;
      case E_TEXT_BOX        : elements_total=::ArraySize(m_wnd[index].m_text_boxes);      break;
      case E_TREE_VIEW       : elements_total=::ArraySize(m_wnd[index].m_treeview_lists);  break;
      case E_FILE_NAVIGATOR  : elements_total=::ArraySize(m_wnd[index].m_file_navigators); break;
      case E_TOOLTIP         : elements_total=::ArraySize(m_wnd[index].m_tooltips);        break;
      case E_FRAME           : elements_total=::ArraySize(m_wnd[index].m_frames);          break;
     }
//--- Вернуть количество элементов указанного типа
   return(elements_total);
  }
//+------------------------------------------------------------------+
//| Добавляет указатель окна в базу элементов интерфейса             |
//+------------------------------------------------------------------+
void CWndContainer::AddWindow(CWindow &object)
  {
   int windows_total=::ArraySize(m_windows);
//--- Если окон ещё нет, обнулим счётчик элементов
   if(windows_total<1)
     {
      m_counter_element_id=0;
      ::Comment("Loading. Please wait...");
     }
//--- Добавим указатель в массив окон
   int new_size=windows_total+1;
   ::ArrayResize(m_wnd,new_size);
   ::ArrayResize(m_windows,new_size);
   m_windows[windows_total]=::GetPointer(object);
//--- Добавим указатель в общий массив элементов
   int last_index=ResizeArray(m_wnd[windows_total].m_elements);
   m_wnd[windows_total].m_elements[last_index]=::GetPointer(object);
//--- Добавим в базу указатели кнопок окна
   AddWindowElements(windows_total,object);
//--- Установим идентификатор и запомним id последнего элемента
   m_windows[windows_total].Id(m_counter_element_id);
   m_windows[windows_total].LastId(m_counter_element_id);
//--- Увеличим счётчик идентификаторов элементов
   m_counter_element_id++;
  }
//+------------------------------------------------------------------+
//| Добавляет указатель в массив элементов                           |
//+------------------------------------------------------------------+
void CWndContainer::AddToElementsArray(const int window_index,CElementBase &object)
  {
   int windows_total=::ArraySize(m_windows);
//--- Если в базе нет форм для элементов управления
   if(windows_total<1)
     {
      ::Print(__FUNCTION__," > Перед созданием элемента управления нужно создать форму "
              "и добавить её в базу с помощью метода CWndContainer::AddWindow(CWindow &object).");
      return;
     }
//--- Если запрос на несуществующую форму
   if(window_index>=windows_total)
     {
      ::Print(PREVENTING_OUT_OF_RANGE," window_index: ",window_index,"; windows total: ",windows_total);
      return;
     }
//--- Добавим в общий массив элементов
   int last_index=ResizeArray(m_wnd[window_index].m_elements);
   m_wnd[window_index].m_elements[last_index]=::GetPointer(object);
//--- Добавим в массив главных элементов
   last_index=ResizeArray(m_wnd[window_index].m_main_elements);
   m_wnd[window_index].m_main_elements[last_index]=::GetPointer(object);
   
//--- Запомним во всех формах id последнего элемента
   for(int w=0; w<windows_total; w++)
      m_windows[w].LastId(m_counter_element_id);
//--- Увеличим счётчик идентификаторов элементов
   m_counter_element_id++;
   
//--- Сохраняет указатели на объекты контекстного меню
   if(AddContextMenuElements(window_index,object))
      return;
//--- Сохраняет указатели на объекты главного меню
   if(AddMenuBarElements(window_index,object))
      return;
//--- Сохраняет указатель на пункт меню
   if(AddMenuItemElements(window_index,object))
      return;
//--- Сохраняет указатели на объекты пункта
   if(AddStatusBarElements(window_index,object))
      return;
//--- Сохраняет указатели на объекты сдвоенной кнопки
   if(AddSplitButtonElements(window_index,object))
      return;
//--- Сохраняет указатели на объекты группы кнопок
   if(AddButtonsGroupElements(window_index,object))
      return;
//--- Сохраняет указатели на объекты списка в базу
   if(AddListViewElements(window_index,object))
      return;
//--- Сохраняет указатели на объекты элемента комбо-бокса
   if(AddComboBoxElements(window_index,object))
      return;
//--- Сохраняет указатели на объекты элемента кнопки для вызова цветовой палитры
   if(AddColorButtonElements(window_index,object))
      return;
//--- Сохраняет указатели на элементы таблицы
   if(AddTableElements(window_index,object))
      return;
//--- Сохраняет указатели на элементы вкладок
   if(AddTabsElements(window_index,object))
      return;
//--- Сохраняет указатели на элементы календаря
   if(AddCalendarElements(window_index,object))
      return;
//--- Сохраняет указатели на элементы выпадающего календаря
   if(AddDropCalendarElements(window_index,object))
      return;
//--- Сохраняет указатели на элементы цветовой палитры
   if(AddColorPickersElements(window_index,object))
      return;
//--- Сохраняет указатели на элементы стандартных графиков
   if(AddSubChartsElements(window_index,object))
      return;
//--- Сохраняет указатели на элементы слайдеров картинок
   if(AddPicturesSliderElements(window_index,object))
      return;
//--- Сохраняет указатели на элементы "Время"
   if(AddTimeEditsElements(window_index,object))
      return;
//--- Сохраняет указатели на элементы многострочного поля ввода
   if(AddTextBoxElements(window_index,object))
      return;
//--- Сохраняет указатели на элементы текстового поля ввода
   if(AddTextEditElements(window_index,object))
      return;
//--- Сохраняет указатели на элементы слайдера
   if(AddSliderElements(window_index,object))
      return;
//--- Сохраняет указатели на элементы древовидных списков
   if(AddTreeViewListsElements(window_index,object))
      return;
//--- Сохраняет указатели на элементы файлового навигатора
   if(AddFileNavigatorElements(window_index,object))
      return;
//--- Сохраняет указатели на объекты всплывающей подсказки
   if(AddTooltipElements(window_index,object))
      return;
//--- Сохраняет указатели на элементы областей
   if(AddFrameElements(window_index,object))
      return;
  }
//+------------------------------------------------------------------+
//| Добавляет указатель в массив элементов с таймерами               |
//+------------------------------------------------------------------+
void CWndContainer::AddTimerElement(const int window_index,CElement &object)
  {
   int last_index=ResizeArray(m_wnd[window_index].m_timer_elements);
   m_wnd[window_index].m_timer_elements[last_index]=::GetPointer(object);
  }
//+------------------------------------------------------------------+
//| Добавляет указатель в массив элементов с авто-ресайзом (X)       |
//+------------------------------------------------------------------+
void CWndContainer::AddAutoXResizeElement(const int window_index,CElement &object)
  {
   int last_index=ResizeArray(m_wnd[window_index].m_auto_x_resize_elements);
   m_wnd[window_index].m_auto_x_resize_elements[last_index]=::GetPointer(object);
  }
//+------------------------------------------------------------------+
//| Добавляет указатель в массив элементов с авто-ресайзом (Y)       |
//+------------------------------------------------------------------+
void CWndContainer::AddAutoYResizeElement(const int window_index,CElement &object)
  {
   int last_index=ResizeArray(m_wnd[window_index].m_auto_y_resize_elements);
   m_wnd[window_index].m_auto_y_resize_elements[last_index]=::GetPointer(object);
  }
//+------------------------------------------------------------------+
//| Добавляет указатель в массив доступных элементов                 |
//+------------------------------------------------------------------+
void CWndContainer::AddAvailableElement(const int window_index,CElement &object)
  {
   int last_index=ResizeArray(m_wnd[window_index].m_available_elements);
   m_wnd[window_index].m_available_elements[last_index]=::GetPointer(object);
  }
//+------------------------------------------------------------------+
//| Корректировка индекса окна в случае выхода из диапазона          |
//+------------------------------------------------------------------+
int CWndContainer::CheckOutOfRange(const int window_index)
  {
   int array_size=::ArraySize(m_wnd);
   if(array_size<1)
     {
      ::Print(PREVENTING_OUT_OF_RANGE);
      return(WRONG_VALUE);
     }
//--- Корректировка в случае выхода из диапазона
   int index=(window_index>=array_size)? array_size-1 : window_index;
//--- Вернуть индекс окна
   return(index);
  }
//+------------------------------------------------------------------+
//| Сохраняет указатели на объекты окна                              |
//+------------------------------------------------------------------+
bool CWndContainer::AddWindowElements(const int window_index,CElementBase &object)
  {
//--- Выйдем, если это не текстовое поле ввода
   if(dynamic_cast<CWindow *>(&object)==NULL)
      return(false);
//--- Получим указатель на элемент
   CWindow *wnd=::GetPointer(object);
//--- Сохраним указатель мыши
   object.MousePointer(m_mouse);
//---
   for(int i=0; i<4; i++)
     {
      CButton *ib=NULL;
      //---
      if(i==0)
         ib=wnd.GetCloseButtonPointer();
      else if(i==1)
         ib=wnd.GetFullscreenButtonPointer();
      else if(i==2)
         ib=wnd.GetCollapseButtonPointer();
      else if(i==3)
         ib=wnd.GetTooltipButtonPointer();
      //--- Увеличение массива элементов
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      //--- Добавим кнопку закрытия в базу
      m_wnd[window_index].m_elements[last_index]=ib;
      //--- Сохраним указатель мыши
      ib.MousePointer(m_mouse);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//| Сохраняет указатели на объекты контекстного меню                 |
//+------------------------------------------------------------------+
bool CWndContainer::AddContextMenuElements(const int window_index,CElementBase &object)
  {
//--- Выйдем, если это не контекстное меню
   if(dynamic_cast<CContextMenu *>(&object)==NULL)
      return(false);
//--- Получим указатель на контекстное меню
   CContextMenu *cm=::GetPointer(object);
//--- Сохраним указатели на его объекты в базе
   int items_total=cm.ItemsTotal();
   for(int i=0; i<items_total; i++)
     {
      //--- Сохраняем указатель в массив
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      m_wnd[window_index].m_elements[last_index]=cm.GetItemPointer(i);
     }
//--- Сохраним указатели на разделительные линии
   int lines_total=cm.SeparateLinesTotal();
   for(int i=0; i<lines_total; i++)
     {
      //--- Сохраняем указатель в массив
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      m_wnd[window_index].m_elements[last_index]=cm.GetSeparateLinePointer(i);
     }
//--- Добавим указатель в персональный массив
   AddToPersonalArray(cm,m_wnd[window_index].m_context_menus);
   return(true);
  }
//+------------------------------------------------------------------+
//| Сохраняет указатели на объекты главного меню                     |
//+------------------------------------------------------------------+
bool CWndContainer::AddMenuBarElements(const int window_index,CElementBase &object)
  {
//--- Выйдем, если это не главное меню
   if(dynamic_cast<CMenuBar *>(&object)==NULL)
      return(false);
//--- Получим указатель на главное меню
   CMenuBar *mb=::GetPointer(object);
//--- Сохраним указатели на его объекты в базе
   int items_total=mb.ItemsTotal();
   for(int i=0; i<items_total; i++)
     {
      //--- Сохраняем указатель в массив
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      m_wnd[window_index].m_elements[last_index]=mb.GetItemPointer(i);
     }
//--- Добавим указатель в персональный массив
   AddToPersonalArray(mb,m_wnd[window_index].m_menu_bars);
   return(true);
  }
//+------------------------------------------------------------------+
//| Сохраняет указатели на пункты меню                               |
//+------------------------------------------------------------------+
bool CWndContainer::AddMenuItemElements(const int window_index,CElementBase &object)
  {
//--- Выйдем, если это не пункт меню
   if(dynamic_cast<CMenuItem *>(&object)==NULL)
      return(false);
//--- Получим указатель на пункт меню
   CMenuItem *mi=::GetPointer(object);
//--- Добавим указатель в персональный массив
   AddToPersonalArray(mi,m_wnd[window_index].m_menu_items);
   return(true);
  }
//+------------------------------------------------------------------+
//| Сохраняет указатели на объекты сдвоенной кнопки                  |
//+------------------------------------------------------------------+
bool CWndContainer::AddSplitButtonElements(const int window_index,CElementBase &object)
  {
//--- Выйдем, если это не сдвоенная кнопка
   if(dynamic_cast<CSplitButton *>(&object)==NULL)
      return(false);
//--- Получим указатель на сдвоенную кнопку
   CSplitButton *sb=::GetPointer(object);
//--- 
   for(int i=0; i<3; i++)
     {
      //--- Увеличение массива элементов
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      //--- Сохраняем указатель в массив
      if(i==0)
        {
         m_wnd[window_index].m_elements[last_index]=sb.GetButtonPointer();
        }
      else if(i==1)
        {
         m_wnd[window_index].m_elements[last_index]=sb.GetDropButtonPointer();
        }
      else if(i==2)
        {
         CContextMenu *cm=sb.GetContextMenuPointer();
         m_wnd[window_index].m_elements[last_index]=cm;
         //--- Добавим элементы контекстного меню
         AddContextMenuElements(window_index,cm);
        }
     }
//--- Добавим указатель в персональный массив
   AddToPersonalArray(sb,m_wnd[window_index].m_split_buttons);
   return(true);
  }
//+------------------------------------------------------------------+
//| Сохраняет указатели на элементы статусной строки                 |
//+------------------------------------------------------------------+
bool CWndContainer::AddStatusBarElements(const int window_index,CElementBase &object)
  {
//--- Выйдем, если это не пункт
   if(dynamic_cast<CStatusBar *>(&object)==NULL)
      return(false);
//--- Получим указатель на пункт
   CStatusBar *sb=::GetPointer(object);
//--- Добавим пункты в базу
   int items_total=sb.ItemsTotal();
   for(int i=0; i<items_total; i++)
     {
      //--- Сохраняем указатель в массив
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      m_wnd[window_index].m_elements[last_index]=sb.GetItemPointer(i);
     }
//--- Сохраним указатели на разделительные линии
   int lines_total=sb.SeparateLinesTotal();
   for(int i=0; i<lines_total; i++)
     {
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      m_wnd[window_index].m_elements[last_index]=sb.GetSeparateLinePointer(i);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//| Сохраняет указатели на объекты группы кнопок                     |
//+------------------------------------------------------------------+
bool CWndContainer::AddButtonsGroupElements(const int window_index,CElementBase &object)
  {
//--- Выйдем, если это не список
   if(dynamic_cast<CButtonsGroup *>(&object)==NULL)
      return(false);
//--- Получим указатель на список
   CButtonsGroup *bg=::GetPointer(object);
//--- Добавим кнопки в базу
   int buttons_total=bg.ButtonsTotal();
   for(int i=0; i<buttons_total; i++)
     {
      //--- Сохраняем указатель в массив
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      m_wnd[window_index].m_elements[last_index]=bg.GetButtonPointer(i);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//| Сохраняет указатели на объекты списка                            |
//+------------------------------------------------------------------+
bool CWndContainer::AddListViewElements(const int window_index,CElementBase &object)
  {
//--- Выйдем, если это не список
   if(dynamic_cast<CListView *>(&object)==NULL)
      return(false);
//--- Получим указатель на список
   CListView *lv=::GetPointer(object);
//--- Сохраним указатели на объекты полосы прокрутки
   CScrollV *sv=lv.GetScrollVPointer();
   AddScrollElements(window_index,sv);
   return(true);
  }
//+------------------------------------------------------------------+
//| Сохраняет указатели на объекты полосы прокрутки                  |
//+------------------------------------------------------------------+
bool CWndContainer::AddScrollElements(const int window_index,CElementBase &object)
  {
//--- Выйдем, если это не список
   if(dynamic_cast<CScroll *>(&object)==NULL)
      return(false);
//--- Получим указатель на полосу прокрутки
   CScroll *sc=::GetPointer(object);
//--- Сохраняем указатель в массив
   int last_index=ResizeArray(m_wnd[window_index].m_elements);
   m_wnd[window_index].m_elements[last_index]=sc;
//---
   for(int i=0; i<2; i++)
     {
      //--- Получим указатель кнопки полосы прокрутки
      CButton *ib=(i<1)? sc.GetIncButtonPointer() : sc.GetDecButtonPointer();
      //--- Сохраняем указатель в массив
      last_index=ResizeArray(m_wnd[window_index].m_elements);
      m_wnd[window_index].m_elements[last_index]=ib;
     }
//--- Добавим указатель в персональный массив
   AddToPersonalArray(sc,m_wnd[window_index].m_scrolls);
   return(true);
  }
//+------------------------------------------------------------------+
//| Сохраняет указатель на выпадающий список в персональный массив   |
//+------------------------------------------------------------------+
bool CWndContainer::AddComboBoxElements(const int window_index,CElementBase &object)
  {
//--- Выйдем, если это не комбобокс
   if(dynamic_cast<CComboBox *>(&object)==NULL)
      return(false);
//--- Получим указатель на комбо-бокс
   CComboBox *cb=::GetPointer(object);
//---
   for(int i=0; i<2; i++)
     {
      //--- Увеличение массива элементов
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      //--- Добавим кнопку в базу
      if(i==0)
        {
         m_wnd[window_index].m_elements[last_index]=cb.GetButtonPointer();
        }
      //--- Добавим список в базу
      else if(i==1)
        {
         CListView *lv=cb.GetListViewPointer();
         m_wnd[window_index].m_elements[last_index]=lv;
         //--- Сохраним указатели на объекты списка
         AddListViewElements(window_index,lv);
         //--- Добавим указатель в персональный массив
         AddToPersonalArray(lv,m_wnd[window_index].m_drop_lists);
        }
     }
//--- Добавим указатель в персональный массив
   AddToPersonalArray(cb,m_wnd[window_index].m_combo_boxes);
   return(true);
  }
//+------------------------------------------------------------------+
//| Сохраняет указатель на элементы цветовой кнопки                  |
//+------------------------------------------------------------------+
bool CWndContainer::AddColorButtonElements(const int window_index,CElementBase &object)
  {
//--- Выйдем, если это не комбобокс
   if(dynamic_cast<CColorButton *>(&object)==NULL)
      return(false);
//--- Получим указатель на кнопку
   CColorButton *cb=::GetPointer(object);
//--- Сохраняем указатель в массив
   int last_index=ResizeArray(m_wnd[window_index].m_elements);
   m_wnd[window_index].m_elements[last_index]=cb.GetButtonPointer();
   return(true);
  }
//+------------------------------------------------------------------+
//| Сохраняет указатели на элементы таблицы                          |
//+------------------------------------------------------------------+
bool CWndContainer::AddTableElements(const int window_index,CElementBase &object)
  {
//--- Выйдем, если это не нарисованная таблица
   if(dynamic_cast<CTable *>(&object)==NULL)
      return(false);
//--- Получим указатель на нарисованную таблицу
   CTable *tbl=::GetPointer(object);
//---
   for(int i=0; i<2; i++)
     {
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      //---
      if(i==0)
        {
         //--- Сохраняем указатель в массив
         CScrollV *sv=tbl.GetScrollVPointer();
         m_wnd[window_index].m_elements[last_index]=sv;
         //--- Сохраним указатели на объекты полосы прокрутки
         AddScrollElements(window_index,sv);
         //--- Добавим указатель в персональный массив
         AddToPersonalArray(sv,m_wnd[window_index].m_scrolls);
        }
      else if(i==1)
        {
         //--- Сохраняем указатель в массив
         CScrollH *sh=tbl.GetScrollHPointer();
         m_wnd[window_index].m_elements[last_index]=sh;
         //--- Сохраним указатели на объекты полосы прокрутки
         AddScrollElements(window_index,sh);
         //--- Добавим указатель в персональный массив
         AddToPersonalArray(sh,m_wnd[window_index].m_scrolls);
        }
     }
//--- Если есть поле ввода
   if(tbl.HasEditElements())
     {
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      //--- Сохраняем указатель в массив
      CTextEdit *te=tbl.GetTextEditPointer();
      m_wnd[window_index].m_elements[last_index]=te;
      //--- Сохраним указатели на объекты
      AddTextEditElements(window_index,te);
     }
//--- Если есть комбо-бокс
   if(tbl.HasComboboxElements())
     {
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      //--- Сохраняем указатель в массив
      CComboBox *cb=tbl.GetComboboxPointer();
      m_wnd[window_index].m_elements[last_index]=cb;
      //--- Сохраним указатели на объекты
      AddComboBoxElements(window_index,cb);
     }
//--- Добавим указатель в персональный массив
   AddToPersonalArray(tbl,m_wnd[window_index].m_tables);
   return(true);
  }
//+------------------------------------------------------------------+
//| Сохраняет указатели на вкладки в персональный массив             |
//+------------------------------------------------------------------+
bool CWndContainer::AddTabsElements(const int window_index,CElementBase &object)
  {
//--- Выйдем, если это не вкладки
   if(dynamic_cast<CTabs *>(&object)==NULL)
      return(false);
//--- Получим указатель на элемент "Вкладки"
   CTabs *tabs=::GetPointer(object);
//--- Сохраняем указатель в массив
   int last_index=ResizeArray(m_wnd[window_index].m_elements);
   CButtonsGroup *bg=tabs.GetButtonsGroupPointer();
   m_wnd[window_index].m_elements[last_index]=bg;
//--- Сохраним указатели на кнопки группы
   AddButtonsGroupElements(window_index,bg);
//--- Добавим указатель в персональный массив
   AddToPersonalArray(tabs,m_wnd[window_index].m_tabs);
   return(true);
  }
//+------------------------------------------------------------------+
//| Сохраняет указатели на объекты календаря                         |
//+------------------------------------------------------------------+
bool CWndContainer::AddCalendarElements(const int window_index,CElementBase &object)
  {
//--- Выйдем, если это не календарь
   if(dynamic_cast<CCalendar *>(&object)==NULL)
      return(false);
//--- Получим указатель на элемент "Календарь"
   CCalendar *cal=::GetPointer(object);
//---
   for(int i=0; i<6; i++)
     {
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      //---
      switch(i)
        {
         case 0 :
           {
            m_wnd[window_index].m_elements[last_index]=cal.GetMonthDecPointer();
            break;
           }
         case 1 :
           {
            m_wnd[window_index].m_elements[last_index]=cal.GetMonthIncPointer();
            break;
           }
         case 2 :
           {
            CComboBox *cb=cal.GetComboBoxPointer();
            m_wnd[window_index].m_elements[last_index]=cb;
            //--- Добавить элементы комбо-бокса
            AddComboBoxElements(window_index,cb);
            break;
           }
         case 3 :
           {
            CTextEdit *te=cal.GetSpinEditPointer();
            m_wnd[window_index].m_elements[last_index]=te;
            //--- Добавить элементы поля ввода
            AddTextEditElements(window_index,te);
            break;
           }
         case 4 :
           {
            CButtonsGroup *bg=cal.GetDayButtonsPointer();
            m_wnd[window_index].m_elements[last_index]=bg;
            //--- Сохраним указатели на кнопки группы
            AddButtonsGroupElements(window_index,bg);
            break;
           }
         case 5 :
           {
            m_wnd[window_index].m_elements[last_index]=cal.GetTodayButtonPointer();
            break;
           }
        }
     }
//--- Добавим указатель в персональный массив
   AddToPersonalArray(cal,m_wnd[window_index].m_calendars);
   return(true);
  }
//+------------------------------------------------------------------+
//| Сохраняет указатели на объекты выпадающего календаря             |
//+------------------------------------------------------------------+
bool CWndContainer::AddDropCalendarElements(const int window_index,CElementBase &object)
  {
//--- Выйдем, если это не выпадающий календарь
   if(dynamic_cast<CDropCalendar *>(&object)==NULL)
      return(false);
//--- Получим указатель на элемент "Выпадающий календарь"
   CDropCalendar *dc=::GetPointer(object);
//---
   for(int i=0; i<3; i++)
     {
      //--- Увеличение массива элементов
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      //---
      if(i==0)
        {
         //--- Сохраняем указатель в массив
         CTextEdit *te=dc.GetTextEditPointer();
         m_wnd[window_index].m_elements[last_index]=te;
         //--- Добавить элементы календаря
         AddTextEditElements(window_index,te);
        }
      else if(i==1)
        {
         m_wnd[window_index].m_elements[last_index]=dc.GetDropButtonPointer();
        }
      else if(i==2)
        {
         //--- Сохраняем указатель в массив
         CCalendar *cal=dc.GetCalendarPointer();
         m_wnd[window_index].m_elements[last_index]=cal;
         //--- Добавить элементы календаря
         AddCalendarElements(window_index,cal);
        }
     }
//--- Добавим указатель в персональный массив
   AddToPersonalArray(dc,m_wnd[window_index].m_drop_calendars);
   return(true);
  }
//+------------------------------------------------------------------+
//| Сохраняет указатели на элементы цветовой палитры                 |
//+------------------------------------------------------------------+
bool CWndContainer::AddColorPickersElements(const int window_index,CElementBase &object)
  {
//--- Выйдем, если это не цветовая палитра
   if(dynamic_cast<CColorPicker *>(&object)==NULL)
      return(false);
//--- Получим указатель на элемент
   CColorPicker *cp=::GetPointer(object);
//---
   for(int i=0; i<12; i++)
     {
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      //---
      if(i<1)
        {
         //--- Сохраняем указатель в массив
         CButtonsGroup *bg=cp.GetRadioButtonsPointer();
         m_wnd[window_index].m_elements[last_index]=bg;
         //--- Добавить кнопки группы
         AddButtonsGroupElements(window_index,bg);
        }
      else if(i>0 && i<10)
        {
         //--- Сохраняем указатель в массив
         CTextEdit *se=cp.GetSpinEditPointer(i-1);
         m_wnd[window_index].m_elements[last_index]=se;
         //--- Добавить элементы поля ввода
         AddTextEditElements(window_index,se);
        }
      else if(i>9)
        {
         CButton *ib=cp.GetButtonPointer(i-10);
         m_wnd[window_index].m_elements[last_index]=ib;
        }
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Сохраняет указатель на стандартные графики в персональный массив |
//+------------------------------------------------------------------+
bool CWndContainer::AddSubChartsElements(const int window_index,CElementBase &object)
  {
//--- Выйдем, если это не стандартный график
   if(dynamic_cast<CStandardChart *>(&object)==NULL)
      return(false);
//--- Получим указатель на стандартный график
   CStandardChart *sc=::GetPointer(object);
//--- Добавим указатель в персональный массив
   AddToPersonalArray(sc,m_wnd[window_index].m_sub_charts);
   return(true);
  }
//+------------------------------------------------------------------+
//| Сохраняет указатель на слайдеры картинок в персональный массив   |
//+------------------------------------------------------------------+
bool CWndContainer::AddPicturesSliderElements(const int window_index,CElementBase &object)
  {
//--- Выйдем, если это не слайдер картинок
   if(dynamic_cast<CPicturesSlider *>(&object)==NULL)
      return(false);
//--- Получим указатель на слайдер картинок
   CPicturesSlider *ps=::GetPointer(object);
//--- Добавим кнопки в базу
   int picturs_total=ps.PicturesTotal();
   for(int i=0; i<picturs_total; i++)
     {
      //--- Сохраняем указатель в массив
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      m_wnd[window_index].m_elements[last_index]=ps.GetPicturePointer(i);
     }
//---
   for(int i=0; i<3; i++)
     {
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      //---
      if(i==0)
        {
         //--- Сохраняем указатель в массив
         CButtonsGroup *bg=ps.GetRadioButtonsPointer();
         m_wnd[window_index].m_elements[last_index]=bg;
         //--- Добавить кнопки группы
         AddButtonsGroupElements(window_index,bg);
        }
      else
        {
         //--- Сохраняем указатель в массив
         CButton *ib=(i<2)? ps.GetLeftArrowPointer() : ps.GetRightArrowPointer();
         m_wnd[window_index].m_elements[last_index]=ib;
        }
     }
//--- Добавим указатель в персональный массив
   AddToPersonalArray(ps,m_wnd[window_index].m_pictures_slider);
   return(true);
  }
//+------------------------------------------------------------------+
//| Сохраняет указатель на элементы "Время" в персональный массив    |
//+------------------------------------------------------------------+
bool CWndContainer::AddTimeEditsElements(const int window_index,CElementBase &object)
  {
//--- Выйдем, если это не элемент "Время"
   if(dynamic_cast<CTimeEdit *>(&object)==NULL)
      return(false);
//--- Получим указатель на элемент "Время"
   CTimeEdit *te=::GetPointer(object);
   for(int i=0; i<2; i++)
     {
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      //---
      if(i==0)
        {
         //--- Сохраняем указатель в массив
         CTextEdit *se=te.GetMinutesEditPointer();
         m_wnd[window_index].m_elements[last_index]=se;
         //--- Сохраним указатели на объекты текстового поля ввода
         AddTextEditElements(window_index,se);
        }
      else
        {
         //--- Сохраняем указатель в массив
         CTextEdit *se=te.GetHoursEditPointer();
         m_wnd[window_index].m_elements[last_index]=se;
         //--- Сохраним указатели на объекты текстового поля ввода
         AddTextEditElements(window_index,se);
        }
     }
//--- Добавим указатель в персональный массив
   AddToPersonalArray(te,m_wnd[window_index].m_time_edits);
   return(true);
  }
//+------------------------------------------------------------------+
//| Сохраняет указатели на объекты многострочного поля ввода         |
//+------------------------------------------------------------------+
bool CWndContainer::AddTextBoxElements(const int window_index,CElementBase &object)
  {
//--- Выйдем, если это не многострочное поле ввода
   if(dynamic_cast<CTextBox *>(&object)==NULL)
      return(false);
//--- Получим указатель на элемент
   CTextBox *tb=::GetPointer(object);
//--- Добавим указатель в персональный массив
   AddToPersonalArray(tb,m_wnd[window_index].m_text_boxes);
//---
   if(!tb.MultiLineMode())
      return(true);
//---
   for(int i=0; i<2; i++)
     {
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      //---
      if(i==0)
        {
         //--- Получим указатель полосы прокрутки
         CScrollV *sv=tb.GetScrollVPointer();
         m_wnd[window_index].m_elements[last_index]=sv;
         //--- Сохраним указатели на объекты полосы прокрутки
         AddScrollElements(window_index,sv);
         //--- Добавим указатель в персональный массив
         AddToPersonalArray(sv,m_wnd[window_index].m_scrolls);
        }
      else if(i==1)
        {
         CScrollH *sh=tb.GetScrollHPointer();
         m_wnd[window_index].m_elements[last_index]=sh;
         //--- Сохраним указатели на объекты полосы прокрутки
         AddScrollElements(window_index,sh);
         //--- Добавим указатель в персональный массив
         AddToPersonalArray(sh,m_wnd[window_index].m_scrolls);
        }
     }
   return(true);
  }
//+------------------------------------------------------------------+
//| Сохраняет указатели на объекты текстового поля ввода             |
//+------------------------------------------------------------------+
bool CWndContainer::AddTextEditElements(const int window_index,CElementBase &object)
  {
//--- Выйдем, если это не текстовое поле ввода
   if(dynamic_cast<CTextEdit *>(&object)==NULL)
      return(false);
//--- Получим указатель на элемент
   CTextEdit *te=::GetPointer(object);
//--- Увеличение массива элементов
   int last_index=ResizeArray(m_wnd[window_index].m_elements);
//--- Получим указатель поля ввода
   CTextBox *tb=te.GetTextBoxPointer();
   m_wnd[window_index].m_elements[last_index]=tb;
//--- Добавим указатель в персональный массив
   AddToPersonalArray(tb,m_wnd[window_index].m_text_boxes);
//--- Выйти, если кнопки отключены
   if(!te.SpinEditMode())
      return(true);
//---
   for(int i=0; i<2; i++)
     {
      //--- Увеличение массива элементов
      last_index=ResizeArray(m_wnd[window_index].m_elements);
      //--- Добавим кнопку в базу
      if(i==0)
         m_wnd[window_index].m_elements[last_index]=te.GetIncButtonPointer();
      else if(i==1)
         m_wnd[window_index].m_elements[last_index]=te.GetDecButtonPointer();
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Сохраняет указатели на элементы слайдера                         |
//+------------------------------------------------------------------+
bool CWndContainer::AddSliderElements(const int window_index,CElementBase &object)
  {
//--- Выйдем, если это не слайдер
   if(dynamic_cast<CSlider *>(&object)==NULL)
      return(false);
//--- Получим указатель на элемент
   CSlider *ns=::GetPointer(object);
//--- Увеличение массива элементов
   int last_index=ResizeArray(m_wnd[window_index].m_elements);
//--- Получим указатель поля ввода
   CTextEdit *te=ns.GetRightEditPointer();
   m_wnd[window_index].m_elements[last_index]=te;
//--- Сохраним указатели на элементы поля ввода
   AddTextEditElements(window_index,te);
//---
   if(ns.DualSliderMode())
     {
      //--- Увеличение массива элементов
      last_index=ResizeArray(m_wnd[window_index].m_elements);
      //--- Получим указатель поля ввода
      te=ns.GetLeftEditPointer();
      m_wnd[window_index].m_elements[last_index]=te;
      //--- Сохраним указатели на элементы поля ввода
      AddTextEditElements(window_index,te);
     }
//--- Добавим указатель в персональный массив
   AddToPersonalArray(ns,m_wnd[window_index].m_sliders);
   return(true);
  }
//+------------------------------------------------------------------+
//| Сохраняет указатель на подсказку в персональный массив           |
//+------------------------------------------------------------------+
bool CWndContainer::AddTooltipElements(const int window_index,CElementBase &object)
  {
//--- Выйдем, если это не всплывающая подсказка
   if(dynamic_cast<CTooltip *>(&object)==NULL)
      return(false);
//--- Получим указатель на всплывающую подсказку
   CTooltip *t=::GetPointer(object);
//--- Добавим указатель в персональный массив
   AddToPersonalArray(t,m_wnd[window_index].m_tooltips);
   return(true);
  }
//+------------------------------------------------------------------+
//| Сохраняет указатели на элементы древовидного списка              |
//+------------------------------------------------------------------+
bool CWndContainer::AddTreeViewListsElements(const int window_index,CElementBase &object)
  {
//--- Выйдем, если это не древовидный список
   if(dynamic_cast<CTreeView *>(&object)==NULL)
      return(false);
//--- Получим указатель на элемент "Древовидный список"
   CTreeView *tv=::GetPointer(object);
//--- Добавим указатель в персональный массив
   AddToPersonalArray(tv,m_wnd[window_index].m_treeview_lists);
//--- Последний индекс
   int last_index=0;
//---
   for(int i=0; i<4; i++)
     {
      if(i==3 && !tv.ShowItemContent())
         break;
      //---
      if(i>1)
        {
         last_index=ResizeArray(m_wnd[window_index].m_elements);
        }
      //---
      switch(i)
        {
         case 0 :
           {
            for(int j=0; j<tv.ItemsTotal(); j++)
              {
               last_index=ResizeArray(m_wnd[window_index].m_elements);
               m_wnd[window_index].m_elements[last_index]=tv.ItemPointer(j);
              }
            break;
           }
         case 1 :
           {
            for(int j=0; j<tv.ContentItemsTotal(); j++)
              {
               last_index=ResizeArray(m_wnd[window_index].m_elements);
               m_wnd[window_index].m_elements[last_index]=tv.ContentItemPointer(j);
              }
            break;
           }
         case 2 :
           {
            //--- Добавим указатель в персональный массив
            CScrollV *sv=tv.GetScrollVPointer();
            m_wnd[window_index].m_elements[last_index]=sv;
            AddToPersonalArray(sv,m_wnd[window_index].m_scrolls);
            //--- Сохраним указатели на объекты полосы прокрутки
            AddScrollElements(window_index,sv);
            break;
           }
         case 3 :
           {
            //--- Добавим указатель в персональный массив
            CScrollV *csv=tv.GetContentScrollVPointer();
            m_wnd[window_index].m_elements[last_index]=csv;
            AddToPersonalArray(csv,m_wnd[window_index].m_scrolls);
            //--- Сохраним указатели на объекты полосы прокрутки
            AddScrollElements(window_index,csv);
            break;
           }
        }
     }
   return(true);
  }
//+------------------------------------------------------------------+
//| Сохраняет указатели на элементы файлового навигатора             |
//+------------------------------------------------------------------+
bool CWndContainer::AddFileNavigatorElements(const int window_index,CElementBase &object)
  {
//--- Выйдем, если это не файловый навигатор
   if(dynamic_cast<CFileNavigator *>(&object)==NULL)
      return(false);
//--- Получим указатель файлового навигатора
   CFileNavigator *fn=::GetPointer(object);
//--- Добавим указатель в персональный массив
   AddToPersonalArray(fn,m_wnd[window_index].m_file_navigators);
//--- Сохраним указатель на древовидный список
   int last_index=ResizeArray(m_wnd[window_index].m_elements);
   m_wnd[window_index].m_elements[last_index]=fn.GetTreeViewPointer();
//--- Добавить элементы древовидного списка
   AddTreeViewListsElements(window_index,fn.GetTreeViewPointer());
   return(true);
  }
//+------------------------------------------------------------------+
//| Сохраняет указатели на вкладки в персональный массив             |
//+------------------------------------------------------------------+
bool CWndContainer::AddFrameElements(const int window_index,CElementBase &object)
  {
//--- Выйдем, если это не область
   if(dynamic_cast<CFrame *>(&object)==NULL)
      return(false);
//--- Получим указатель на элемент "Область"
   CFrame *frame=::GetPointer(object);
//--- Добавим указатель в персональный массив
   AddToPersonalArray(frame,m_wnd[window_index].m_frames);
//--- Сохраняем указатель в массив
   int last_index=ResizeArray(m_wnd[window_index].m_elements);
   m_wnd[window_index].m_elements[last_index]=frame.GetTextLabelPointer();
   return(true);
  }
//+------------------------------------------------------------------+
//| Увеличивает массив на один элемент и возвращает последний индекс |
//+------------------------------------------------------------------+
template<typename T>
int CWndContainer::ResizeArray(T &array[])
  {
   int size=::ArraySize(array);
   ::ArrayResize(array,size+1,RESERVE_SIZE_ARRAY);
   return(size);
  }
//+------------------------------------------------------------------+
//| Сохраняет указатель (T1) в переданный по ссылке массив (T2)      |
//+------------------------------------------------------------------+
template<typename T1,typename T2>
void CWndContainer::AddToPersonalArray(T1 &object,T2 &array[])
  {
   int last_index=ResizeArray(array);
   array[last_index]=object;
  }
//+------------------------------------------------------------------+
