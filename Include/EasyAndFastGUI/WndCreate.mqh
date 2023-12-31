//+------------------------------------------------------------------+
//|                                                    WndCreate.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "WndEvents.mqh"
//+------------------------------------------------------------------+
//| Класс для создания элементов                                     |
//+------------------------------------------------------------------+
class CWndCreate : public CWndEvents {
 protected:
  CWndCreate(void);
  ~CWndCreate(void);
  //---
 public:
  //--- Форма
  bool              CreateWindow(CWindow &object, const string text,
                                 const int x = 1, const int y = 1, const int x_size = 200, const int y_size = 200,
                                 const bool button_close = true, const bool button_fullscreen = true, const bool button_collapse = true, const bool button_tooltips = true);
  //--- Диалоговое окно
  bool              CreateDialogWindow(CWindow &object, const string caption_text,
                                       const int x, const int y, const int x_size, const int y_size,
                                       const string icon_path = "", const int icon_x_gap = 5, const int icon_y_gap = 2);
  //--- Статусная строка
  bool              CreateStatusBar(CStatusBar &object, CElement &main, const int x, const int y, const int y_size, string &text_items[], int &width_items[]);

  //--- Вкладки
  bool              CreateTabs(CTabs &object, CElement &main, const int window_index,
                               const int x, const int y, const int x_size, const int y_size, string &text[], int &width[],
                               ENUM_TABS_POSITION position = TABS_TOP, const bool auto_x_resize = false, const bool auto_y_resize = false, const int right_offset = 0, const int bottom_offset = 0);
  bool              CreateTabs(CTabs &object, CElement &main, const int window_index, CTabs &tabs, const int tab_index,
                               const int x, const int y, const int x_size, const int y_size, string &text[], int &width[],
                               ENUM_TABS_POSITION position = TABS_TOP, const bool auto_x_resize = false, const bool auto_y_resize = false, const int right_offset = 0, const int bottom_offset = 0);

  //--- Таблицы
  bool              CreateTable(CTable &object, CElement &main, const int window_index,
                                const int columns_total, const int rows_total, string &headers[],
                                const int x, const int y, const int x_size = 0, const int y_size = 0,
                                const bool auto_x_resize = false, const bool auto_y_resize = false, const int right_offset = 0, const int bottom_offset = 0);
                                
  bool              CreateTable(CTable &object, CElement &main, const int window_index, CTabs &tabs, const int tab_index,
                                const int columns_total, const int rows_total, string &headers[],
                                const int x, const int y, const int x_size = 0, const int y_size = 0,
                                const bool auto_x_resize = false, const bool auto_y_resize = false, const int right_offset = 0, const int bottom_offset = 0);

  //--- Стандартный график
  bool              CreateSubCharts(CStandardChart &object, CElement &main, const int window_index,
                                    const int x, const int y, const int x_size, const int y_size,
                                    const bool auto_x_resize = false, const bool auto_y_resize = false, const int right_offset = 0, const int bottom_offset = 0);
  bool              CreateSubCharts(CStandardChart &object, CElement &main, const int window_index, CTabs &tabs, const int tab_index,
                                    const int x, const int y, const int x_size, const int y_size,
                                    const bool auto_x_resize = false, const bool auto_y_resize = false, const int right_offset = 0, const int bottom_offset = 0);
  //--- Чекбокс
  bool              CreateCheckbox(CCheckBox &object, const string text, CElement &main, const int window_index,
                                   const int x, const int y, const int xsize = 100, const bool is_pressed = false, const bool is_right = false, const bool is_bottom = false);

  bool              CreateCheckbox(CCheckBox &object, const string text, CElement &main, const int window_index, CTabs &tabs, const int tab_index,
                                   const int x, const int y, const int xsize = 100, const bool is_pressed = false, const bool is_right = false, const bool is_bottom = false);
  //--- Комбобокс
  bool              CreateCombobox(CComboBox &object, const string text, CElement &main, const int window_index,
                                   const bool checkbox_mode, const int x, const int y, const int x_size, const int button_x_size,
                                   string &items[], const int list_y_size, const int selected_item_index = 0);

  bool              CreateCombobox(CComboBox &object, const string text, CElement &main, const int window_index, CTabs &tabs, const int tab_index,
                                   const bool checkbox_mode, const int x, const int y, const int x_size, const int button_x_size,
                                   string &items[], const int list_y_size, const int selected_item_index = 0);
  //--- Текстовая метка
  bool              CreateTextLabel(CTextLabel &object, const string text, CElement &main, const int window_index,
                                    const int x, const int y, const int x_size, const int y_size = 20);
  bool              CreateTextLabel(CTextLabel &object, const string text, CElement &main, const int window_index, CTabs &tabs, const int tab_index,
                                    const int x, const int y, const int x_size, const int y_size = 20);
  //--- Прогресс-бар
  bool              CreateProgressBar(CProgressBar &object, const string text, CElement &main, const int window_index, const int x, const int y);

  //--- Выпадающий календарь
  bool              CreateDropCalendar(CDropCalendar &object, const string text, CElement &main, const int window_index,
                                       const int x, const int y, const int x_size, const datetime selected_date);
                                       
  bool              CreateDropCalendar(CDropCalendar &object, const string text, CElement &main, const int window_index, CTabs &tabs, const int tab_index,
                                       const int x, const int y, const int x_size, const datetime selected_date);
  //--- Кнопка
  bool              CreateButton(CButton &object, const string text, CElement &main, const int window_index,
                                 const int x, const int y, const int x_size, const bool is_right = false, const bool is_bottom = false,
                                 const color back_color = clrNONE, const color back_color_hover = clrNONE, const color back_color_pressed = clrNONE,
                                 const color label_color = clrNONE, const color border_color = clrNONE);

  bool              CreateButton(CButton &object, const string text, CElement &main, const int window_index, CTabs &tabs, const int tab_index,
                                 const int x, const int y, const int x_size, const bool is_right = false, const bool is_bottom = false,
                                 const color back_color = clrNONE, const color back_color_hover = clrNONE, const color back_color_pressed = clrNONE,
                                 const color label_color = clrNONE, const color border_color = clrNONE);

  bool              CreateButton(CButton &object, const string text, CElement &main, const int window_index,
                                 const int x, const int y, const int x_size, const int y_size, const int label_x, const int label_y,
                                 const int icon_x, const int icon_y, const string image_path, const bool is_right = false, const bool is_bottom = false,
                                 const color back_color = clrNONE, const color back_color_hover = clrNONE, const color back_color_pressed = clrNONE,
                                 const color label_color = clrNONE, const color border_color = clrNONE);

  bool              CreateButton(CButton &object, const string text, CElement &main, const int window_index, CTabs &tabs, const int tab_index,
                                 const int x, const int y, const int x_size, const int y_size, const int label_x, const int label_y,
                                 const int icon_x, const int icon_y, const string image_path, const bool is_right = false, const bool is_bottom = false,
                                 const color back_color = clrNONE, const color back_color_hover = clrNONE, const color back_color_pressed = clrNONE,
                                 const color label_color = clrNONE, const color border_color = clrNONE);

  //--- Поле ввода
  bool              CreateTextEdit(CTextEdit &object, const string text, CElement &main, const int window_index,
                                   const bool checkbox_mode, const int x, const int y,
                                   const int x_size, const int edit_x_size, const string value, const string default_text = "");

  bool              CreateTextEdit(CTextEdit &object, const string text, CElement &main, const int window_index, 
                                   CTabs &tabs, const int tab_index,
                                   const bool checkbox_mode, const int x, const int y, 
                                   const int x_size, const int edit_x_size, const string value, const string default_text = "");

  bool              CreateTextEdit(CTextEdit &object, const string text, CElement &main, const int window_index,
                                   const bool checkbox_mode, const int x, const int y, const int x_size, const int edit_x_size,
                                   const double max, const double min, const double step, const int digits, const double value = 0);

  bool              CreateTextEdit(CTextEdit &object, const string text, CElement &main, const int window_index, 
                                   CTabs &tabs, const int tab_index,
                                   const bool checkbox_mode, const int x, const int y, const int x_size, const int edit_x_size,
                                   const double max, const double min, const double step, const int digits, const double value = 0);

  //--- Радио-кнопки
  bool              CreateRadioButtons(CButtonsGroup &object, CElement &main, const int window_index,
                                       const int x, const int y, int &x_offset[], int &y_offset[], string &text[], int &width[]);
  bool              CreateRadioButtons(CButtonsGroup &object, CElement &main, const int window_index, CTabs &tabs, const int tab_index,
                                       const int x, const int y, int &x_offset[], int &y_offset[], string &text[], int &width[]);

  //--- Группа кнопок
  bool              CreateButtonsGroup(CButtonsGroup &object, CElement &main, const int window_index,
                                       const int x, const int y, int &x_offset[], int &y_offset[], string &text[], int &width[],
                                       color &back_clr[], color &hover_clr[], color &pressed_clr[], const color label_clr, const color border_clr);

  bool              CreateButtonsGroup(CButtonsGroup &object, CElement &main, const int window_index, CTabs &tabs, const int tab_index,
                                       const int x, const int y, int &x_offset[], int &y_offset[], string &text[], int &width[],
                                       color &back_clr[], color &hover_clr[], color &pressed_clr[], const color label_clr, const color border_clr);

  //--- Кнопка цвета
  bool              CreateColorButton(CColorButton &object, const string text, CElement &main, const int window_index,
                                      const int x, const int y, const int xsize, const int button_x_size);
                                      
  bool              CreateColorButton(CColorButton &object, const string text, CElement &main, const int window_index, CTabs &tabs, const int tab_index,
                                      const int x, const int y, const int xsize, const int button_x_size);
  //--- Цветовая палитра
  bool              CreateColorPicker(CColorPicker &object, CElement &main, const int window_index, const int x, const int y);

  //--- Область
  bool              CreateFrame(CFrame &object, const string text, CElement &main, const int window_index,
                                const int x, const int y, const int x_size, const int y_size, const int label_x_size,
                                const bool is_right = false, const bool is_bottom = false, const int right_offset = 0, const int bottom_offset = 0);

  bool              CreateFrame(CFrame &object, const string text, CElement &main, const int window_index, CTabs &tabs, const int tab_index,
                                const int x, const int y, const int x_size, const int y_size, const int label_x_size,
                                const bool is_right = false, const bool is_bottom = false, const int right_offset = 0, const int bottom_offset = 0);

  //--- Файловый навигатор
  bool              CreateFileNavigator(CFileNavigator &object, CElement &main, const int window_index, const int x, const int y,
                                        const int tree_view_x_size, const bool auto_x_resize, const int right_offset, const int visible_items_total,
                                        ENUM_FILE_NAVIGATOR_CONTENT content_mode = FN_BOTH, ENUM_FILE_NAVIGATOR_MODE navigator_mode = FN_ONLY_FOLDERS);
  //--- Графики
  bool              CreateGraph(CGraph &object, CElement &main, const int window_index,
                                const int x, const int y, const bool auto_x_resize, const bool auto_y_resize,
                                const int right_offset, const int bottom_offset, const bool is_right, const bool is_bottom,
                                ENUM_AXIS_TYPE axis_type, DoubleToStringFunction func_x_axis, DoubleToStringFunction func_y_axis);
                                
  bool              CreateGraph(CGraph &object, CElement &main, const int window_index, CTabs &tabs, const int tab_index,
                                const int x, const int y, const bool auto_x_resize, const bool auto_y_resize,
                                const int right_offset, const int bottom_offset, const bool is_right, const bool is_bottom,
                                ENUM_AXIS_TYPE axis_type, DoubleToStringFunction func_x_axis, DoubleToStringFunction func_y_axis);
  //--- Разделительная линия
  bool              CreateSepLine(CSeparateLine &object, CElement &main, const int window_index,
                                  const int x, const int y, const int x_size, const int y_size,
                                  color dark_clr, color light_clr, ENUM_TYPE_SEP_LINE type_line);
};
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CWndCreate::CWndCreate(void) {
}
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CWndCreate::~CWndCreate(void) {
}
//+------------------------------------------------------------------+
//| Создаёт форму для элементов управления                           |
//+------------------------------------------------------------------+
bool CWndCreate::CreateWindow(CWindow &object, const string caption_text,
                              const int x = 1, const int y = 1, const int x_size = 200, const int y_size = 200,
                              const bool button_close = true, const bool button_fullscreen = true, const bool button_collapse = true, const bool button_tooltips = true) {
//--- Добавим указатель окна в массив окон
  CWndContainer::AddWindow(object);
//--- Координаты
  int x_l = (object.X() > x) ? object.X() : x;
  int y_l = (object.Y() > y) ? object.Y() : y;
//--- Свойства
  object.XSize(x_size);
  object.YSize(y_size);
  object.IsMovable(true);
//--- Кнопки
  object.CloseButtonIsUsed(button_close);
  object.CollapseButtonIsUsed(button_collapse);
  object.TooltipsButtonIsUsed(button_tooltips);
  object.FullscreenButtonIsUsed(button_fullscreen);
  object.TransparentOnlyCaption(false);
//--- Установим всплывающие подсказки
  object.GetCloseButtonPointer().Tooltip("Close");
  object.GetTooltipButtonPointer().Tooltip("Tooltips");
  object.GetFullscreenButtonPointer().Tooltip("Fullscreen");
  object.GetCollapseButtonPointer().Tooltip("Collapse/Expand");
//--- Создание формы
  if(!object.CreateWindow(m_chart_id, m_subwin, caption_text, x_l, y_l))
    return(false);
//---
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт диалоговое окно                                          |
//+------------------------------------------------------------------+
bool CWndCreate::CreateDialogWindow(CWindow &object, const string caption_text,
                                    const int x, const int y, const int x_size, const int y_size,
                                    const string icon_path = "", const int icon_x_gap = 5, const int icon_y_gap = 2) {
//--- Добавим объект окна в массив окон
  CWndContainer::AddWindow(object);
//--- Свойства
  object.IsMovable(true);
  object.XSize(x_size);
  object.YSize(y_size);
  object.IconXGap(icon_x_gap);
  object.IconYGap(icon_y_gap);
  object.WindowType(W_DIALOG);

  if(icon_path != "") {
    object.IconFile(icon_path);
  } else {
    object.IconFile((uint)RESOURCE_HELP);
  }
//--- Создание формы
  if(!object.CreateWindow(m_chart_id, m_subwin, caption_text, x, y))
    return(false);
//---
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт статусную строку                                         |
//+------------------------------------------------------------------+
bool CWndCreate::CreateStatusBar(CStatusBar &object, CElement &main, const int x, const int y, const int y_size, string &text_items[], int &width_items[]) {
//--- Сохраним указатель на главный элемент
  object.MainPointer(main);
//--- Свойства
  object.YSize(y_size);
  object.AutoXResizeMode(true);
  object.AutoXResizeRightOffset(1);
  object.AnchorBottomWindowSide(true);
//--- Укажем сколько должно быть частей и установим им свойства
  int total =::ArraySize(text_items);
  for(int i = 0; i < total; i++)
    object.AddItem(text_items[i], width_items[i]);
//--- Создание элемента
  if(!object.CreateStatusBar(x, y))
    return(false);
//--- Добавим объект в общий массив
  CWndContainer::AddToElementsArray(0, object);
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт область с вкладками                                      |
//+------------------------------------------------------------------+
bool CWndCreate::CreateTabs(CTabs &object, CElement &main, const int window_index,
                            const int x, const int y, const int x_size, const int y_size, string &text[], int &width[],
                            ENUM_TABS_POSITION position = TABS_TOP, const bool auto_x_resize = false, const bool auto_y_resize = false, const int right_offset = 0, const int bottom_offset = 0) {
//--- Сохраним указатель на главный элемент
  object.MainPointer(main);
//--- Свойства
  object.XSize(x_size);
  object.YSize(y_size);
  object.IsCenterText(true);
  object.PositionMode(position);
  object.AutoXResizeMode(auto_x_resize);
  object.AutoYResizeMode(auto_y_resize);
  object.AutoXResizeRightOffset(right_offset);
  object.AutoYResizeBottomOffset(bottom_offset);
//--- Добавим вкладки с указанными свойствами
  int total =::ArraySize(text);
  for(int i = 0; i < total; i++)
    object.AddTab(text[i], width[i]);
//--- Создадим элемент управления
  if(!object.CreateTabs(x, y))
    return(false);
//--- Добавим объект в общий массив
  CWndContainer::AddToElementsArray(window_index, object);
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт область с вкладками                                      |
//+------------------------------------------------------------------+
bool CWndCreate::CreateTabs(CTabs &object, CElement &main, const int window_index, CTabs &tabs, const int tab_index,
                            const int x, const int y, const int x_size, const int y_size, string &text[], int &width[],
                            ENUM_TABS_POSITION position = TABS_TOP, const bool auto_x_resize = false, const bool auto_y_resize = false, const int right_offset = 0, const int bottom_offset = 0) {
//--- Сохраним указатель на главный элемент
  object.MainPointer(main);
//--- Закрепить за вкладкой
  tabs.AddToElementsArray(tab_index, object);
//--- Свойства
  object.XSize(x_size);
  object.YSize(y_size);
  object.IsCenterText(true);
  object.PositionMode(position);
  object.AutoXResizeMode(auto_x_resize);
  object.AutoYResizeMode(auto_y_resize);
  object.AutoXResizeRightOffset(right_offset);
  object.AutoYResizeBottomOffset(bottom_offset);
//--- Добавим вкладки с указанными свойствами
  int total =::ArraySize(text);
  for(int i = 0; i < total; i++)
    object.AddTab(text[i], width[i]);
//--- Создадим элемент управления
  if(!object.CreateTabs(x, y))
    return(false);
//--- Добавим объект в общий массив
  CWndContainer::AddToElementsArray(window_index, object);
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт таблицу                                                  |
//+------------------------------------------------------------------+
bool CWndCreate::CreateTable(CTable &object, CElement &main, const int window_index,
                             const int columns_total, const int rows_total, string &headers[],
                             const int x, const int y, const int x_size = 0, const int y_size = 0,
                             const bool auto_x_resize = false, const bool auto_y_resize = false, const int right_offset = 0, const int bottom_offset = 0) {
//--- Сохраним указатель на главный элемент
  object.MainPointer(main);
  
//--- Свойства
  object.XSize(x_size);
  object.YSize(y_size);
  object.TableSize(columns_total, rows_total);
  object.ShowHeaders(::ArraySize(headers) > 0);
  object.SelectableRow(true);
  object.IsWithoutDeselect(true);
  object.IsSortMode(true);
  object.AutoXResizeMode(auto_x_resize);
  object.AutoYResizeMode(auto_y_resize);
  object.AutoXResizeRightOffset(right_offset);
  object.AutoYResizeBottomOffset(bottom_offset);
  
//--- Создадим элемент управления
  if(!object.CreateTable(x, y))
    return(false);
    
//--- Заголовки
  if(object.ColumnsTotal() == ::ArraySize(headers) && ::ArraySize(headers) > 0) {
    for(uint i = 0; i < object.ColumnsTotal(); i++)
      object.SetHeaderText(i, headers[i]);
  }
//--- Добавим объект в общий массив групп объектов
  CWndContainer::AddToElementsArray(window_index, object);
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт таблицу                                                  |
//+------------------------------------------------------------------+
bool CWndCreate::CreateTable(CTable &object, CElement &main, const int window_index, CTabs &tabs, const int tab_index,
                             const int columns_total, const int rows_total, string &headers[],
                             const int x, const int y, const int x_size = 0, const int y_size = 0,
                             const bool auto_x_resize = false, const bool auto_y_resize = false, const int right_offset = 0, const int bottom_offset = 0) {
//--- Сохраним указатель на главный элемент
  object.MainPointer(main);
//--- Закрепить за вкладкой
  tabs.AddToElementsArray(tab_index, object);
//--- Свойства
  object.XSize(x_size);
  object.YSize(y_size);
  if(object.ColumnsTotal() < 2 && object.RowsTotal() < 2)
    object.TableSize(columns_total, rows_total);
  object.ShowHeaders(::ArraySize(headers) > 0);
  object.SelectableRow(true);
  object.IsWithoutDeselect(true);
  object.IsSortMode(true);
  object.AutoXResizeMode(auto_x_resize);
  object.AutoYResizeMode(auto_y_resize);
  object.AutoXResizeRightOffset(right_offset);
  object.AutoYResizeBottomOffset(bottom_offset);
//--- Создадим элемент управления
  if(!object.CreateTable(x, y))
    return(false);
//--- Заголовки
  if(object.ColumnsTotal() ==::ArraySize(headers) && ::ArraySize(headers) > 0) {
    for(uint i = 0; i < object.ColumnsTotal(); i++)
      object.SetHeaderText(i, headers[i]);
  }
//--- Добавим объект в общий массив групп объектов
  CWndContainer::AddToElementsArray(window_index, object);
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт стандартный график                                       |
//+------------------------------------------------------------------+
bool CWndCreate::CreateSubCharts(CStandardChart &object, CElement &main, const int window_index,
                                 const int x, const int y, const int x_size, const int y_size,
                                 const bool auto_x_resize = false, const bool auto_y_resize = false, const int right_offset = 0, const int bottom_offset = 0) {
//--- Сохраним указатель на главный элемент
  object.MainPointer(main);
//--- Свойства
  object.XSize(x_size);
  object.YSize(y_size);
  object.XScrollMode(true);
  object.AutoXResizeMode(auto_x_resize);
  object.AutoYResizeMode(auto_y_resize);
  object.AutoXResizeRightOffset(right_offset);
  object.AutoYResizeBottomOffset(bottom_offset);
  object.AddSubChart(_Symbol, _Period);
//--- Создадим элемент управления
  if(!object.CreateStandardChart(x, y))
    return(false);
//--- Добавим объект в общий массив
  CWndContainer::AddToElementsArray(window_index, object);
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт стандартный график                                       |
//+------------------------------------------------------------------+
bool CWndCreate::CreateSubCharts(CStandardChart &object, CElement &main, const int window_index, CTabs &tabs, const int tab_index,
                                 const int x, const int y, const int x_size, const int y_size,
                                 const bool auto_x_resize = false, const bool auto_y_resize = false, const int right_offset = 0, const int bottom_offset = 0) {
//--- Сохраним указатель на главный элемент
  object.MainPointer(main);
//--- Закрепить за вкладкой
  tabs.AddToElementsArray(tab_index, object);
//--- Свойства
  object.XSize(x_size);
  object.YSize(y_size);
  object.XScrollMode(true);
  object.AutoXResizeMode(auto_x_resize);
  object.AutoYResizeMode(auto_y_resize);
  object.AutoXResizeRightOffset(right_offset);
  object.AutoYResizeBottomOffset(bottom_offset);
  object.AddSubChart(_Symbol, _Period);
//--- Создадим элемент управления
  if(!object.CreateStandardChart(x, y))
    return(false);
//--- Добавим объект в общий массив
  CWndContainer::AddToElementsArray(window_index, object);
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт чекбокс                                                  |
//+------------------------------------------------------------------+
bool CWndCreate::CreateCheckbox(CCheckBox &object, const string text, CElement &main, const int window_index,
                                const int x, const int y, const int xsize = 100, const bool is_pressed = false, const bool is_right = false, const bool is_bottom = false) {
//--- Сохраним указатель на главный элемент
  object.MainPointer(main);

//--- Свойства
  object.XSize(xsize);
  object.AnchorRightWindowSide(is_right);
  object.AnchorBottomWindowSide(is_bottom);

//--- Создадим элемент управления
  if(!object.CreateCheckBox(text, x, y))
    return(false);

//--- Включить чек-бокс
  object.IsPressed(is_pressed);

//--- Добавим объект в общий массив
  CWndContainer::AddToElementsArray(window_index, object);
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт чекбокс                                                  |
//+------------------------------------------------------------------+
bool CWndCreate::CreateCheckbox(CCheckBox &object, const string text, CElement &main, const int window_index, CTabs &tabs, const int tab_index,
                                const int x, const int y, const int xsize = 100, const bool is_pressed = false, const bool is_right = false, const bool is_bottom = false) {
//--- Сохраним указатель на главный элемент
  object.MainPointer(main);
//--- Закрепить за вкладкой
  tabs.AddToElementsArray(tab_index, object);
//--- Свойства
  object.XSize(xsize);
  object.AnchorRightWindowSide(is_right);
  object.AnchorBottomWindowSide(is_bottom);
//--- Создадим элемент управления
  if(!object.CreateCheckBox(text, x, y))
    return(false);
//--- Включить чек-бокс
  object.IsPressed(is_pressed);
//--- Добавим объект в общий массив
  CWndContainer::AddToElementsArray(window_index, object);
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт комбо-бокс                                               |
//+------------------------------------------------------------------+
bool CWndCreate::CreateCombobox(CComboBox &object, const string text, CElement &main, const int window_index,
                                const bool checkbox_mode, const int x, const int y, const int x_size, const int button_x_size,
                                string &items[], const int list_y_size, const int selected_item_index = 0) {
//--- Сохраним указатель на главный элемент
  object.MainPointer(main);
//--- Количество пунктов
  int total =::ArraySize(items);
//--- Установим свойства перед созданием
  object.XSize(x_size);
  object.YSize(20);
  object.ItemsTotal(total);
  object.CheckBoxMode(checkbox_mode);
  object.GetButtonPointer().XSize(button_x_size);
  object.GetButtonPointer().YSize(18);
  object.GetButtonPointer().AnchorRightWindowSide(true);
//--- Сохраним значения пунктов в список комбо-бокса
  for(int i = 0; i < total; i++)
    object.SetValue(i, items[i]);
//--- Получим указатель списка
  CListView *lv = object.GetListViewPointer();
//--- Установим свойства списка
  lv.YSize(list_y_size);
  lv.LightsHover(true);
  lv.SelectItem(lv.SelectedItemIndex() == WRONG_VALUE ? selected_item_index : lv.SelectedItemIndex());

//--- Создадим элемент управления
  if(!object.CreateComboBox(text, x, y))
    return(false);

//--- Добавим объект в общий массив
  CWndContainer::AddToElementsArray(window_index, object);
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт комбо-бокс                                               |
//+------------------------------------------------------------------+
bool CWndCreate::CreateCombobox(CComboBox &object, const string text, CElement &main, const int window_index, CTabs &tabs, const int tab_index,
                                const bool checkbox_mode, const int x, const int y, const int x_size, const int button_x_size,
                                string &items[], const int list_y_size, const int selected_item_index = 0) {
//--- Сохраним указатель на главный элемент
  object.MainPointer(main);
//--- Закрепить за вкладкой
  tabs.AddToElementsArray(tab_index, object);
//--- Количество пунктов
  int total =::ArraySize(items);
//--- Установим свойства перед созданием
  object.XSize(x_size);
  object.YSize(20);
  object.ItemsTotal(total);
  object.CheckBoxMode(checkbox_mode);
  object.GetButtonPointer().XSize(button_x_size);
  object.GetButtonPointer().YSize(18);
  object.GetButtonPointer().AnchorRightWindowSide(true);
//--- Сохраним значения пунктов в список комбо-бокса
  for(int i = 0; i < total; i++)
    object.SetValue(i, items[i]);
//--- Получим указатель списка
  CListView *lv = object.GetListViewPointer();
//--- Установим свойства списка
  lv.YSize(list_y_size);
  lv.LightsHover(true);
  lv.SelectItem(lv.SelectedItemIndex() == WRONG_VALUE ? selected_item_index : lv.SelectedItemIndex());
//--- Создадим элемент управления
  if(!object.CreateComboBox(text, x, y))
    return(false);
//--- Добавим объект в общий массив
  CWndContainer::AddToElementsArray(window_index, object);
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт текстовую метку                                          |
//+------------------------------------------------------------------+
bool CWndCreate::CreateTextLabel(CTextLabel &object, const string text, CElement &main, const int window_index,
                                 const int x, const int y, const int x_size, const int y_size = 20) {
//--- Сохраним указатель на главный элемент
  object.MainPointer(main);
//--- Свойства
  object.XSize(x_size);
  object.YSize(y_size);
//--- Создание кнопки
  if(!object.CreateTextLabel(text, x, y))
    return(false);
//--- Добавим указатель на элемент в базу
  CWndContainer::AddToElementsArray(window_index, object);
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт текстовую метку                                          |
//+------------------------------------------------------------------+
bool CWndCreate::CreateTextLabel(CTextLabel &object, const string text, CElement &main, const int window_index, CTabs &tabs, const int tab_index,
                                 const int x, const int y, const int x_size, const int y_size = 20) {
//--- Сохраним указатель на главный элемент
  object.MainPointer(main);
//--- Закрепить за вкладкой
  tabs.AddToElementsArray(tab_index, object);
//--- Свойства
  object.XSize(x_size);
  object.YSize(y_size);
//--- Создание кнопки
  if(!object.CreateTextLabel(text, x, y))
    return(false);
//--- Добавим указатель на элемент в базу
  CWndContainer::AddToElementsArray(window_index, object);
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт прогресс бар                                             |
//+------------------------------------------------------------------+
bool CWndCreate::CreateProgressBar(CProgressBar &object, const string text, CElement &main, const int window_index, const int x, const int y) {
//--- Сохраним указатель на главный элемент
  object.MainPointer(main);
//--- Свойства
  object.YSize(17);
  object.BarYSize(14);
  object.BarXGap(0);
  object.BarYGap(1);
  object.LabelXGap(5);
  object.LabelYGap(2);
  object.PercentXGap(5);
  object.PercentYGap(2);
  object.IsDropdown(true);
  object.Font("Consolas");
  object.BorderColor(clrSilver);
  object.IndicatorBackColor(clrWhiteSmoke);
  object.IndicatorColor(clrLightGreen);
  object.AutoXResizeMode(true);
  object.AutoXResizeRightOffset(2);
//--- Создание элемента
  if(!object.CreateProgressBar(text, x, y))
    return(false);
//--- Добавим указатель на элемент в базу
  CWndContainer::AddToElementsArray(window_index, object);
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт выпадающий календарь                                     |
//+------------------------------------------------------------------+
bool CWndCreate::CreateDropCalendar(CDropCalendar &object, const string text, CElement &main, const int window_index,
                                    const int x, const int y, const int x_size, const datetime selected_date) {
//--- Сохранить указатель на главный элемент
  object.MainPointer(main);
//--- Свойства
  object.XSize(x_size);
  object.YSize(20);
  object.SelectedDate(selected_date);
//--- Создадим элемент управления
  if(!object.CreateDropCalendar(text, x, y))
    return(false);
//--- Добавим указатель на элемент в базу
  CWndContainer::AddToElementsArray(window_index, object);
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт выпадающий календарь                                     |
//+------------------------------------------------------------------+
bool CWndCreate::CreateDropCalendar(CDropCalendar &object, const string text, CElement &main, const int window_index, CTabs &tabs, const int tab_index,
                                    const int x, const int y, const int x_size, const datetime selected_date) {
//--- Сохранить указатель на главный элемент
  object.MainPointer(main);
//--- Закрепить за вкладкой
  tabs.AddToElementsArray(tab_index, object);
//--- Свойства
  object.XSize(x_size);
  object.YSize(20);
  object.SelectedDate(selected_date);
//--- Создадим элемент управления
  if(!object.CreateDropCalendar(text, x, y))
    return(false);
//--- Добавим указатель на элемент в базу
  CWndContainer::AddToElementsArray(window_index, object);
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт кнопку                                                   |
//+------------------------------------------------------------------+
bool CWndCreate::CreateButton(CButton &object, const string text, CElement &main, const int window_index,
                              const int x, const int y, const int x_size, const bool is_right = false, const bool is_bottom = false,
                              const color back_color = clrNONE, const color back_color_hover = clrNONE, const color back_color_pressed = clrNONE,
                              const color label_color = clrNONE, const color border_color = clrNONE) {
//--- Сохранить указатель на главный элемент
  object.MainPointer(main);
//--- Свойства
  object.XSize(x_size);
  object.IsCenterText(true);
  object.AnchorRightWindowSide(is_right);
  object.AnchorBottomWindowSide(is_bottom);
  if(back_color != clrNONE) {
    object.BackColor(back_color);
    object.BackColorHover(back_color_hover);
    object.BackColorPressed(back_color_pressed);
    object.LabelColor(label_color);
    object.LabelColorHover(label_color);
    object.LabelColorPressed(label_color);
    object.BorderColor(border_color);
    object.BorderColorHover(border_color);
    object.BorderColorPressed(border_color);
  }
//--- Создадим элемент управления
  if(!object.CreateButton(text, x, y))
    return(false);
//--- Добавим объект в общий массив
  CWndContainer::AddToElementsArray(window_index, object);
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт кнопку                                                   |
//+------------------------------------------------------------------+
bool CWndCreate::CreateButton(CButton &object, const string text, CElement &main, const int window_index, CTabs &tabs, const int tab_index,
                              const int x, const int y, const int x_size, const bool is_right = false, const bool is_bottom = false,
                              const color back_color = clrNONE, const color back_color_hover = clrNONE, const color back_color_pressed = clrNONE,
                              const color label_color = clrNONE, const color border_color = clrNONE) {
//--- Сохранить указатель на главный элемент
  object.MainPointer(main);
//--- Закрепить за вкладкой
  tabs.AddToElementsArray(tab_index, object);
//--- Свойства
  object.XSize(x_size);
  object.IsCenterText(true);
  object.AnchorRightWindowSide(is_right);
  object.AnchorBottomWindowSide(is_bottom);
  if(back_color != clrNONE) {
    object.BackColor(back_color);
    object.BackColorHover(back_color_hover);
    object.BackColorPressed(back_color_pressed);
    object.LabelColor(label_color);
    object.LabelColorHover(label_color);
    object.LabelColorPressed(label_color);
    object.BorderColor(border_color);
    object.BorderColorHover(border_color);
    object.BorderColorPressed(border_color);
  }
//--- Создадим элемент управления
  if(!object.CreateButton(text, x, y))
    return(false);
//--- Добавим объект в общий массив
  CWndContainer::AddToElementsArray(window_index, object);
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт кнопку                                                   |
//+------------------------------------------------------------------+
bool CWndCreate::CreateButton(CButton &object, const string text, CElement &main, const int window_index,
                              const int x, const int y, const int x_size, const int y_size, const int label_x, const int label_y,
                              const int icon_x, const int icon_y, const string image_path, const bool is_right = false, const bool is_bottom = false,
                              const color back_color = clrNONE, const color back_color_hover = clrNONE, const color back_color_pressed = clrNONE,
                              const color label_color = clrNONE, const color border_color = clrNONE) {
//--- Сохранить указатель на главный элемент
  object.MainPointer(main);
//--- Свойства
  object.XSize(x_size);
  object.YSize(y_size);
  object.LabelXGap(label_x);
  object.LabelYGap(label_y);
  object.IconXGap(icon_x);
  object.IconYGap(icon_y);
  object.IconFile(image_path);
  object.IconFileLocked(image_path);
  object.AnchorRightWindowSide(is_right);
  object.AnchorBottomWindowSide(is_bottom);
  if(back_color != clrNONE) {
    object.BackColor(back_color);
    object.BackColorHover(back_color_hover);
    object.BackColorPressed(back_color_pressed);
    object.LabelColor(label_color);
    object.LabelColorHover(label_color);
    object.LabelColorPressed(label_color);
    object.BorderColor(border_color);
    object.BorderColorHover(border_color);
    object.BorderColorPressed(border_color);
  }
//--- Создадим элемент управления
  if(!object.CreateButton(text, x, y))
    return(false);
//--- Добавим объект в общий массив
  CWndContainer::AddToElementsArray(window_index, object);
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт кнопку                                                   |
//+------------------------------------------------------------------+
bool CWndCreate::CreateButton(CButton &object, const string text, CElement &main, const int window_index, CTabs &tabs, const int tab_index,
                              const int x, const int y, const int x_size, const int y_size, const int label_x, const int label_y,
                              const int icon_x, const int icon_y, const string image_path, const bool is_right = false, const bool is_bottom = false,
                              const color back_color = clrNONE, const color back_color_hover = clrNONE, const color back_color_pressed = clrNONE,
                              const color label_color = clrNONE, const color border_color = clrNONE) {
//--- Сохранить указатель на главный элемент
  object.MainPointer(main);
//--- Закрепить за вкладкой
  tabs.AddToElementsArray(tab_index, object);
//--- Свойства
  object.XSize(x_size);
  object.YSize(y_size);
  object.LabelXGap(label_x);
  object.LabelYGap(label_y);
  object.IconXGap(icon_x);
  object.IconYGap(icon_y);
  object.IconFile(image_path);
  object.IconFileLocked(image_path);
  object.AnchorRightWindowSide(is_right);
  object.AnchorBottomWindowSide(is_bottom);
  if(back_color != clrNONE) {
    object.BackColor(back_color);
    object.BackColorHover(back_color_hover);
    object.BackColorPressed(back_color_pressed);
    object.LabelColor(label_color);
    object.LabelColorHover(label_color);
    object.LabelColorPressed(label_color);
    object.BorderColor(border_color);
    object.BorderColorHover(border_color);
    object.BorderColorPressed(border_color);
  }
//--- Создадим элемент управления
  if(!object.CreateButton(text, x, y))
    return(false);
//--- Добавим объект в общий массив
  CWndContainer::AddToElementsArray(window_index, object);
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт поле ввода - текстовое                                   |
//+------------------------------------------------------------------+
bool CWndCreate::CreateTextEdit(CTextEdit &object, const string text, CElement &main, const int window_index,
                                const bool checkbox_mode, const int x, const int y, 
                                const int x_size, const int edit_x_size, 
                                const string value, const string default_text = "") {
//--- Сохраним указатель на главный элемент
  object.MainPointer(main);
  
//--- Свойства
  object.XSize(x_size);
  object.SetValue(value);
  object.SpinEditMode(false);
  object.CheckBoxMode(checkbox_mode);
  object.GetTextBoxPointer().XSize(edit_x_size);
  object.GetTextBoxPointer().AutoSelectionMode(true);
  object.GetTextBoxPointer().AnchorRightWindowSide(true);
  object.GetTextBoxPointer().DefaultText(default_text);
  
//--- Создадим элемент управления
  if(!object.CreateTextEdit(text, x, y))
    return(false);
    
//--- Добавим объект в общий массив
  CWndContainer::AddToElementsArray(window_index, object);
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт поле ввода - текстовое                                   |
//+------------------------------------------------------------------+
bool CWndCreate::CreateTextEdit(CTextEdit &object, const string text, CElement &main, const int window_index, CTabs &tabs, const int tab_index,
                                const bool checkbox_mode, const int x, const int y, 
                                const int x_size, const int edit_x_size, 
                                const string value, const string default_text = "") {
//--- Сохраним указатель на главный элемент
  object.MainPointer(main);
//--- Закрепить за вкладкой
  tabs.AddToElementsArray(tab_index, object);
//--- Свойства
  object.XSize(x_size);
  object.SetValue(value);
  object.SpinEditMode(false);
  object.CheckBoxMode(checkbox_mode);
  object.GetTextBoxPointer().XSize(edit_x_size);
  object.GetTextBoxPointer().AutoSelectionMode(true);
  object.GetTextBoxPointer().AnchorRightWindowSide(true);
  object.GetTextBoxPointer().DefaultText(default_text);
//--- Создадим элемент управления
  if(!object.CreateTextEdit(text, x, y))
    return(false);
//--- Добавим объект в общий массив
  CWndContainer::AddToElementsArray(window_index, object);
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт поле ввода - числовое                                    |
//+------------------------------------------------------------------+
bool CWndCreate::CreateTextEdit(CTextEdit &object, const string text, CElement &main, const int window_index,
                                const bool checkbox_mode, const int x, const int y, const int x_size, const int edit_x_size,
                                const double max, const double min, const double step, const int digits, const double value = 0) {
//--- Сохраним указатель на главный элемент
  object.MainPointer(main);
//--- Свойства
  object.XSize(x_size);
  object.MaxValue(max);
  object.MinValue(min);
  object.StepValue(step);
  object.SetDigits(digits);
  object.SpinEditMode(true);
  object.CheckBoxMode(checkbox_mode);
  object.SetValue((string)value);
  object.AnchorBottomWindowSide(false);
  object.GetTextBoxPointer().XSize(edit_x_size);
  object.GetTextBoxPointer().AutoSelectionMode(true);
  object.GetTextBoxPointer().AnchorRightWindowSide(true);
//--- Создадим элемент управления
  if(!object.CreateTextEdit(text, x, y))
    return(false);
//--- Добавим объект в общий массив
  CWndContainer::AddToElementsArray(window_index, object);
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт поле ввода - числовое                                    |
//+------------------------------------------------------------------+
bool CWndCreate::CreateTextEdit(CTextEdit &object, const string text, CElement &main, const int window_index, CTabs &tabs, const int tab_index,
                                const bool checkbox_mode, const int x, const int y, const int x_size, const int edit_x_size,
                                const double max, const double min, const double step, const int digits, const double value = 0) {
//--- Сохраним указатель на главный элемент
  object.MainPointer(main);
//--- Закрепить за вкладкой
  tabs.AddToElementsArray(tab_index, object);
//--- Свойства
  object.XSize(x_size);
  object.MaxValue(max);
  object.MinValue(min);
  object.StepValue(step);
  object.SetDigits(digits);
  object.SpinEditMode(true);
  object.CheckBoxMode(checkbox_mode);
  object.SetValue((string)value);
  object.AnchorBottomWindowSide(false);
  object.GetTextBoxPointer().XSize(edit_x_size);
  object.GetTextBoxPointer().AutoSelectionMode(true);
  object.GetTextBoxPointer().AnchorRightWindowSide(true);
//--- Создадим элемент управления
  if(!object.CreateTextEdit(text, x, y))
    return(false);
//--- Добавим объект в общий массив
  CWndContainer::AddToElementsArray(window_index, object);
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт группу радио-кнопок                                      |
//+------------------------------------------------------------------+
bool CWndCreate::CreateRadioButtons(CButtonsGroup &object, CElement &main, const int window_index,
                                    const int x, const int y, int &x_offset[], int &y_offset[], string &text[], int &width[]) {
//--- Сохранить указатель на главный элемент
  object.MainPointer(main);
//--- Свойства
  object.RadioButtonsMode(true);
  object.RadioButtonsStyle(true);
//--- Добавим кнопки в группу
  int total =::ArraySize(x_offset);
  for(int i = 0; i < total; i++) {
    //--- Сначала добавляем кнопку
    object.AddButton(x_offset[i], y_offset[i], text[i], width[i]);
    //--- Устанавливаем свойства для кнопки
    object.GetButtonPointer(i).YSize(14);
    object.GetButtonPointer(i).LabelXGap(17);
    object.GetButtonPointer(i).LabelYGap(0);
  }
//--- Создать группу кнопок
  if(!object.CreateButtonsGroup(x, y))
    return(false);
//--- Выделим кнопку в группе
  object.SelectButton(0);
//--- Добавим объект в общий массив
  CWndContainer::AddToElementsArray(window_index, object);
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт группу радио-кнопок                                      |
//+------------------------------------------------------------------+
bool CWndCreate::CreateRadioButtons(CButtonsGroup &object, CElement &main, const int window_index, CTabs &tabs, const int tab_index,
                                    const int x, const int y, int &x_offset[], int &y_offset[], string &text[], int &width[]) {
//--- Сохранить указатель на главный элемент
  object.MainPointer(main);
//--- Закрепить за вкладкой
  tabs.AddToElementsArray(tab_index, object);
//--- Свойства
  object.RadioButtonsMode(true);
  object.RadioButtonsStyle(true);
//--- Добавим кнопки в группу
  int total =::ArraySize(x_offset);
  for(int i = 0; i < total; i++) {
    //--- Сначала добавляем кнопку
    object.AddButton(x_offset[i], y_offset[i], text[i], width[i]);
    //--- Устанавливаем свойства для кнопки
    object.GetButtonPointer(i).YSize(14);
    object.GetButtonPointer(i).LabelXGap(17);
    object.GetButtonPointer(i).LabelYGap(0);
  }
//--- Создать группу кнопок
  if(!object.CreateButtonsGroup(x, y))
    return(false);
//--- Выделим кнопку в группе
  object.SelectButton(0);
//--- Добавим объект в общий массив
  CWndContainer::AddToElementsArray(window_index, object);
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт группу кнопок                                            |
//+------------------------------------------------------------------+
bool CWndCreate::CreateButtonsGroup(CButtonsGroup &object, CElement &main, const int window_index,
                                    const int x, const int y, int &x_offset[], int &y_offset[], string &text[], int &width[],
                                    color &back_clr[], color &hover_clr[], color &pressed_clr[], const color label_clr, const color border_clr) {
//--- Сохранить указатель на главный элемент
  object.MainPointer(main);
//--- Свойства
  object.RadioButtonsMode(false);
  object.RadioButtonsStyle(false);
  object.IsCenterText(true);
//--- Добавим кнопки в группу
  int total =::ArraySize(x_offset);
  for(int i = 0; i < total; i++) {
    //--- Сначала добавляем кнопку
    object.AddButton(x_offset[i], y_offset[i], text[i], width[i], back_clr[i], hover_clr[i], pressed_clr[i]);
    //--- Устанавливаем свойства для кнопки
    object.GetButtonPointer(i).YSize(20);
    object.GetButtonPointer(i).LabelColor(label_clr);
    object.GetButtonPointer(i).LabelColorHover(label_clr);
    object.GetButtonPointer(i).LabelColorPressed(label_clr);
    object.GetButtonPointer(i).BorderColor(border_clr);
    object.GetButtonPointer(i).BorderColorHover(border_clr);
    object.GetButtonPointer(i).BorderColorPressed(border_clr);
  }
//--- Создать группу кнопок
  if(!object.CreateButtonsGroup(x, y))
    return(false);
//--- Добавим объект в общий массив
  CWndContainer::AddToElementsArray(window_index, object);
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт группу кнопок                                            |
//+------------------------------------------------------------------+
bool CWndCreate::CreateButtonsGroup(CButtonsGroup &object, CElement &main, const int window_index, CTabs &tabs, const int tab_index,
                                    const int x, const int y, int &x_offset[], int &y_offset[], string &text[], int &width[],
                                    color &back_clr[], color &hover_clr[], color &pressed_clr[], const color label_clr, const color border_clr) {
//--- Сохранить указатель на главный элемент
  object.MainPointer(main);
//--- Закрепить за вкладкой
  tabs.AddToElementsArray(tab_index, object);
//--- Свойства
  object.RadioButtonsMode(false);
  object.RadioButtonsStyle(false);
  object.IsCenterText(true);
//--- Добавим кнопки в группу
  int total =::ArraySize(x_offset);
  for(int i = 0; i < total; i++) {
    //--- Сначала добавляем кнопку
    object.AddButton(x_offset[i], y_offset[i], text[i], width[i], back_clr[i], hover_clr[i], pressed_clr[i]);
    //--- Устанавливаем свойства для кнопки
    object.GetButtonPointer(i).YSize(20);
    object.GetButtonPointer(i).LabelColor(label_clr);
    object.GetButtonPointer(i).LabelColorHover(label_clr);
    object.GetButtonPointer(i).LabelColorPressed(label_clr);
    object.GetButtonPointer(i).BorderColor(border_clr);
    object.GetButtonPointer(i).BorderColorHover(border_clr);
    object.GetButtonPointer(i).BorderColorPressed(border_clr);
  }
//--- Создать группу кнопок
  if(!object.CreateButtonsGroup(x, y))
    return(false);
//--- Добавим объект в общий массив
  CWndContainer::AddToElementsArray(window_index, object);
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт кнопку цвета                                             |
//+------------------------------------------------------------------+
bool CWndCreate::CreateColorButton(CColorButton &object, const string text, CElement &main, const int window_index,
                                   const int x, const int y, const int xsize, const int button_x_size) {
//--- Сохранить указатель на главный элемент
  object.MainPointer(main);
//--- Свойства
  object.XSize(xsize);
  object.GetButtonPointer().XSize(button_x_size);
  object.GetButtonPointer().AnchorRightWindowSide(true);
//--- Создадим элемент
  if(!object.CreateColorButton(text, x, y))
    return(false);
//--- Добавим объект в общий массив
  AddToElementsArray(window_index, object);
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт кнопку цвета                                             |
//+------------------------------------------------------------------+
bool CWndCreate::CreateColorButton(CColorButton &object, const string text, CElement &main, const int window_index, CTabs &tabs, const int tab_index,
                                   const int x, const int y, const int xsize, const int button_x_size) {
//--- Сохранить указатель на главный элемент
  object.MainPointer(main);
//--- Закрепить за вкладкой
  tabs.AddToElementsArray(tab_index, object);
//--- Свойства
  object.XSize(xsize);
  object.GetButtonPointer().XSize(button_x_size);
  object.GetButtonPointer().AnchorRightWindowSide(true);
//--- Создадим элемент
  if(!object.CreateColorButton(text, x, y))
    return(false);
//--- Добавим объект в общий массив
  AddToElementsArray(window_index, object);
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт цветовую палитру                                         |
//+------------------------------------------------------------------+
bool CWndCreate::CreateColorPicker(CColorPicker &object, CElement &main, const int window_index, const int x, const int y) {
//--- Сохранить указатель на главный элемент
  object.MainPointer(main);
//--- Создадим элемент
  if(!object.CreateColorPicker(x, y))
    return(false);
//--- Добавим объект в общий массив
  AddToElementsArray(window_index, object);
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт область                                                  |
//+------------------------------------------------------------------+
bool CWndCreate::CreateFrame(CFrame &object, const string text, CElement &main, const int window_index,
                             const int x, const int y, const int x_size, const int y_size, const int label_x_size,
                             const bool is_right = false, const bool is_bottom = false, const int right_offset = 0, const int bottom_offset = 0) {
//--- Сохраним указатель на окно
  object.MainPointer(main);
//--- Свойства
  object.XSize(x_size);
  object.YSize(y_size);
  object.BorderColor(C'213,223,229');
  object.GetTextLabelPointer().XSize(label_x_size);
  object.AnchorRightWindowSide(is_right);
  object.AnchorBottomWindowSide(is_bottom);
  if(right_offset) {
    object.AutoXResizeMode(true);
    object.AutoXResizeRightOffset(right_offset);
  }
  if(bottom_offset) {
    object.AutoYResizeMode(true);
    object.AutoYResizeBottomOffset(bottom_offset);
  }
//--- Создадим элемент управления
  if(!object.CreateFrame(text, x, y))
    return(false);
//--- Добавим объект в общий массив
  CWndContainer::AddToElementsArray(window_index, object);
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт область                                                  |
//+------------------------------------------------------------------+
bool CWndCreate::CreateFrame(CFrame &object, const string text, CElement &main, const int window_index, CTabs &tabs, const int tab_index,
                             const int x, const int y, const int x_size, const int y_size, const int label_x_size,
                             const bool is_right = false, const bool is_bottom = false, const int right_offset = 0, const int bottom_offset = 0) {
//--- Сохраним указатель на окно
  object.MainPointer(main);
//--- Закрепить за вкладкой
  tabs.AddToElementsArray(tab_index, object);
//--- Свойства
  object.XSize(x_size);
  object.YSize(y_size);
  object.BorderColor(C'213,223,229');
  object.GetTextLabelPointer().XSize(label_x_size);
  object.AnchorRightWindowSide(is_right);
  object.AnchorBottomWindowSide(is_bottom);
  if(right_offset) {
    object.AutoXResizeMode(true);
    object.AutoXResizeRightOffset(right_offset);
  }
  if(bottom_offset) {
    object.AutoYResizeMode(true);
    object.AutoYResizeBottomOffset(bottom_offset);
  }
//--- Создадим элемент управления
  if(!object.CreateFrame(text, x, y))
    return(false);
//--- Добавим объект в общий массив
  CWndContainer::AddToElementsArray(window_index, object);
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт файловый навигатор                                       |
//+------------------------------------------------------------------+
bool CWndCreate::CreateFileNavigator(CFileNavigator &object, CElement &main, const int window_index, const int x, const int y,
                                     const int tree_view_x_size, const bool auto_x_resize, const int right_offset, const int visible_items_total,
                                     ENUM_FILE_NAVIGATOR_CONTENT content_mode = FN_BOTH, ENUM_FILE_NAVIGATOR_MODE navigator_mode = FN_ONLY_FOLDERS) {
//--- Сохраним указатель на главный элемент
  object.MainPointer(main);
//--- Свойства
  object.NavigatorMode(navigator_mode);
  object.NavigatorContent(content_mode);
  object.TreeViewWidth(tree_view_x_size);
  object.AutoXResizeMode(auto_x_resize);
  object.AutoXResizeRightOffset(right_offset);
  object.GetTreeViewPointer().VisibleItemsTotal(visible_items_total);
//--- Создание элемента
  if(!object.CreateFileNavigator(x, y))
    return(false);
//--- Скрыть объект
  object.Hide();
//--- Добавим указатель на элемент в базу
  CWndContainer::AddToElementsArray(window_index, object);
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт график                                                   |
//+------------------------------------------------------------------+
bool CWndCreate::CreateGraph(CGraph &object, CElement &main, const int window_index,
                             const int x, const int y, const bool auto_x_resize, const bool auto_y_resize,
                             const int right_offset, const int bottom_offset, const bool is_right, const bool is_bottom,
                             ENUM_AXIS_TYPE axis_type, DoubleToStringFunction func_x_axis, DoubleToStringFunction func_y_axis) {
//--- Сохраним указатель на главный элемент
  object.MainPointer(main);
  
//--- Свойства
  object.AutoXResizeMode(auto_x_resize);
  object.AutoYResizeMode(auto_y_resize);
  object.AutoXResizeRightOffset(right_offset);
  object.AutoYResizeBottomOffset(bottom_offset);
  object.AnchorRightWindowSide(is_right);
  object.AnchorBottomWindowSide(is_bottom);
  
//--- Создание элемента
  if(!object.CreateGraph(x, y))
    return(false);
    
//--- Скрыть объект
  object.Hide();
//--- Свойства графика
  CGraphic *graph = object.GetGraphicPointer();
  graph.BackgroundMainSize(16);
  graph.BackgroundMain("");
  graph.BackgroundColor(::ColorToARGB(clrWhite));
  graph.IndentLeft(-15);
  graph.IndentRight(-5);
  graph.IndentUp(-5);
  graph.IndentDown(0);
  
//--- Свойства X-оси
  CAxis *x_axis = graph.XAxis();
  x_axis.AutoScale(false);
  x_axis.Min(0);
  x_axis.Max(1);
  x_axis.MaxGrace(0);
  x_axis.MinGrace(0);
  x_axis.NameSize(14);
  x_axis.Type(axis_type);
  x_axis.ValuesFunctionFormat(func_x_axis);
  
//--- Свойства Y-оси
  CAxis *y_axis = graph.YAxis();
  y_axis.MaxLabels(10);
  y_axis.ValuesWidth(60);
  y_axis.Type(axis_type);
  y_axis.ValuesFunctionFormat(func_y_axis);
  
//--- Добавим указатель на элемент в базу
  CWndContainer::AddToElementsArray(window_index, object);
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт график                                                   |
//+------------------------------------------------------------------+
bool CWndCreate::CreateGraph(CGraph &object, CElement &main, const int window_index, CTabs &tabs, const int tab_index,
                             const int x, const int y, const bool auto_x_resize, const bool auto_y_resize,
                             const int right_offset, const int bottom_offset, const bool is_right, const bool is_bottom,
                             ENUM_AXIS_TYPE axis_type, DoubleToStringFunction func_x_axis, DoubleToStringFunction func_y_axis) {
//--- Сохраним указатель на главный элемент
  object.MainPointer(main);
//--- Закрепить за вкладкой
  tabs.AddToElementsArray(tab_index, object);
//--- Свойства
  object.AutoXResizeMode(auto_x_resize);
  object.AutoYResizeMode(auto_y_resize);
  object.AutoXResizeRightOffset(right_offset);
  object.AutoYResizeBottomOffset(bottom_offset);
  object.AnchorRightWindowSide(is_right);
  object.AnchorBottomWindowSide(is_bottom);
//--- Создание элемента
  if(!object.CreateGraph(x, y))
    return(false);
//--- Скрыть объект
  object.Hide();
//--- Свойства графика
  CGraphic *graph = object.GetGraphicPointer();
  graph.BackgroundMainSize(16);
  graph.BackgroundMain("");
  graph.BackgroundColor(::ColorToARGB(clrWhite));
  graph.IndentLeft(-15);
  graph.IndentRight(-5);
  graph.IndentUp(-5);
  graph.IndentDown(0);
//--- Свойства X-оси
  CAxis *x_axis = graph.XAxis();
  x_axis.AutoScale(false);
  x_axis.Min(0);
  x_axis.Max(1);
  x_axis.MaxGrace(0);
  x_axis.MinGrace(0);
  x_axis.NameSize(14);
  x_axis.Type(axis_type);
  x_axis.ValuesFunctionFormat(func_x_axis);
//--- Свойства Y-оси
  CAxis *y_axis = graph.YAxis();
  y_axis.MaxLabels(10);
  y_axis.ValuesWidth(60);
  y_axis.Type(axis_type);
  y_axis.ValuesFunctionFormat(func_y_axis);
//--- Добавим указатель на элемент в базу
  CWndContainer::AddToElementsArray(window_index, object);
  return(true);
}
//+------------------------------------------------------------------+
//| Создаёт разделительную линию                                     |
//+------------------------------------------------------------------+
bool CWndCreate::CreateSepLine(CSeparateLine &object, CElement &main, const int window_index,
                               const int x, const int y, const int x_size, const int y_size,
                               color dark_clr, color light_clr, ENUM_TYPE_SEP_LINE type_line) {
//--- Сохраним указатель на окно
  object.MainPointer(main);
//--- Свойства
  object.DarkColor(dark_clr);
  object.LightColor(light_clr);
  object.TypeSepLine(type_line);
//--- Создание элемента
  if(!object.CreateSeparateLine(x, y, x_size, y_size))
    return(false);
//--- Добавим указатель на элемент в базу
  CWndContainer::AddToElementsArray(window_index, object);
  return(true);
}
//+------------------------------------------------------------------+
