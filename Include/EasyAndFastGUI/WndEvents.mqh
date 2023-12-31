//+------------------------------------------------------------------+
//|                                                    WndEvents.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "Defines.mqh"
#include "WndContainer.mqh"
//+------------------------------------------------------------------+
//| Класс для обработки событий                                      |
//+------------------------------------------------------------------+
class CWndEvents : public CWndContainer {
 protected:
  //--- Экземпляр класса для управления графиком
  CChart            m_chart;
  //--- Идентификатор и номер окна графика
  long              m_chart_id;
  int               m_subwin;
  //--- Имя программы
  string            m_program_name;
  //--- Короткое имя индикатора
  string            m_indicator_shortname;
  //--- Индекс активного окна
  int               m_active_window_index;
  //--- Хэндл подокна эксперта
  int               m_subwindow_handle;
  //--- Имя подокна эксперта
  string            m_subwindow_shortname;
  //--- Количество подокон на графике после установки подокна эксперта
  int               m_subwindows_total;
  //---
 private:
  //--- Параметры событий
  int               m_id;
  long              m_lparam;
  double            m_dparam;
  string            m_sparam;
  //---
 public:
  CWndEvents(void);
  ~CWndEvents(void);
  //--- Виртуальный обработчик события графика
  virtual void      OnEvent(const int id, const long &lparam, const double &dparam, const string &sparam) {}
  //--- Таймер
  void              OnTimerEvent(void);
  //---
 public:
  //--- Обработчики событий графика
  void              ChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam);
  //---
 public:
  //--- Возвращает индекс активированного окна
  int               GetActiveWindowIndex(void) {
    return(m_active_window_index);
  }
  //---
 private:
  void              ChartEventCustom(void);
  void              ChartEventClick(void);
  void              ChartEventMouseMove(void);
  void              ChartEventObjectClick(void);
  void              ChartEventEndEdit(void);
  void              ChartEventChartChange(void);
  //--- Проверка событий в элементах управления
  void              CheckElementsEvents(void);

  //--- Определение номера подокна
  void              DetermineSubwindow(void);
  //--- Удалить подокно эксперта
  void              DeleteExpertSubwindow(void);
  //--- Проверка и обновление номера окна эксперта
  void              CheckExpertSubwindowNumber(void);
  //--- Проверка и обновление номера окна индикатора
  void              CheckSubwindowNumber(void);
  //--- Изменение размеров заблокированной главной формы
  void              ResizeLockedWindow(void);

  //--- Инициализация параметров событий
  void              InitChartEventsParams(const int id, const long lparam, const double dparam, const string sparam);
  //--- Перемещение окна
  void              MovingWindow(const bool moving_mode = false);
  //--- Проверка событий всех элементов по таймеру
  void              CheckElementsEventsTimer(void);
  //--- Установка состояния графика
  void              SetChartState(void);
  //---
 protected:
  //--- Удаление интерфейса
  void              Destroy(void);
  //--- Перерисовка окна
  void              ResetWindow(void);
  //---
 public:
  //--- Инициализация ядра
  void              InitializeCore(void);
  //--- Завершение создания GUI
  void              CompletedGUI(void);
  //--- Обновление положения элементов
  void              Moving(void);
  //---
 protected:
  //--- Скрытие всех элементов
  void              Hide(void);
  //--- Показ элементов указанного окна
  void              Show(const uint window_index);
  //--- Восстановление приоритетов на нажатие левой кнопкой мыши
  void              SetZorders(void);
  //--- Перерисовка элементов
  void              Update(const bool redraw = false);

  //--- Перемещает всплывающие подсказки на верхний слой
  void              ResetTooltips(void);
  //--- Показывает элементы только выделенных вкладок
  void              ShowTabElements(const uint window_index);
  //--- Устанавливает состояние доступности элементов
  void              SetAvailable(const uint window_index, const bool state);

  //--- Формирует массив элементов с таймером
  void              FormTimerElementsArray(void);
  //--- Формирует массив доступных элементов
  void              FormAvailableElementsArray(void);
  //--- Формирует массив элементов с авто-ресайзом (X)
  void              FormAutoXResizeElementsArray(void);
  //--- Формирует массив элементов с авто-ресайзом (Y)
  void              FormAutoYResizeElementsArray(void);
  //---
 private:
  //--- Перетаскивание формы завершено
  bool              OnWindowEndDrag(void);
  //--- Сворачивание/разворачивание формы
  bool              OnWindowCollapse(void);
  bool              OnWindowExpand(void);
  //--- Обработка изменения размеров окна
  bool              OnWindowChangeXSize(void);
  bool              OnWindowChangeYSize(void);
  //--- Включение/отключение всплывающих подсказок
  bool              OnWindowTooltips(void);
  //--- Скрытие всех контекстных меню от пункта инициатора
  bool              OnHideBackContextMenus(void);
  //--- Скрытие всех контекстных меню
  bool              OnHideContextMenus(void);
  //--- Открытие диалогового окна
  bool              OnOpenDialogBox(void);
  //--- Закрытие диалогового окна
  bool              OnCloseDialogBox(void);
  //--- Определение доступных элементов
  bool              OnSetAvailable(void);
  //--- Определение заблокированных элементов
  bool              OnSetLocked(void);
  //--- Изменения в графическом интерфейсе
  bool              OnChangeGUI(void);
  //---
 private:
  //--- Возвращает индекс активированного окна
  int               ActivatedWindowIndex(void);
  //--- Возвращает индекс активированного главного меню
  int               ActivatedMenuBarIndex(void);
  //--- Возвращает индекс активированного пункта меню
  int               ActivatedMenuItemIndex(void);
  //--- Возвращает индекс активированной сдвоенной кнопки
  int               ActivatedSplitButtonIndex(void);
  //--- Возвращает индекс активированного комбо-бокса
  int               ActivatedComboBoxIndex(void);
  //--- Возвращает индекс активированного выпадающего календаря
  int               ActivatedDropCalendarIndex(void);
  //--- Возвращает индекс активированной полосы прокрутки
  int               ActivatedScrollIndex(void);
  //--- Возвращает индекс активированной таблицы
  int               ActivatedTableIndex(void);
  //--- Возвращает индекс активированного слайдера
  int               ActivatedSliderIndex(void);
  //--- Возвращает индекс активированного древовидного списка
  int               ActivatedTreeViewIndex(void);
  //--- Возвращает индекс активированного стандартного графика
  int               ActivatedSubChartIndex(void);

  //--- Проверяет и делает контекстное меню доступным
  void              CheckContextMenu(CMenuItem &object);
};
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CWndEvents::CWndEvents(void) : m_chart_id(::ChartID()),
  m_subwin(0),
  m_active_window_index(0),
  m_indicator_shortname(""),
  m_program_name(PROGRAM_NAME),
  m_subwindow_handle(INVALID_HANDLE),
  m_subwindow_shortname(""),
  m_subwindows_total(1) {

//--- Выйти, если это не реал-тайм
  if(::MQLInfoInteger(MQL_TESTER) || ::MQLInfoInteger(MQL_FRAME_MODE))
    return;
//--- Инициализация ядра
  InitializeCore();
}
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CWndEvents::~CWndEvents(void) {
//--- Выйти, если это не реал-тайм
  if(::MQLInfoInteger(MQL_TESTER))
    return;
//--- Удалить таймер
  ::EventKillTimer();
//--- Включим управление
  m_chart.MouseScroll(true);
  m_chart.SetInteger(CHART_DRAG_TRADE_LEVELS, true);
//--- Отключим слежение за событиями мыши
  m_chart.EventMouseMove(false);
//--- Включим вызов командной строки для клавиш Space и Enter
  m_chart.SetInteger(CHART_QUICK_NAVIGATION, true);
//--- Отсоединиться от графика
  m_chart.Detach();
//--- Удалим подокно индикатора
  DeleteExpertSubwindow();
//--- Стереть коммент
  ::Comment("");
}
//+------------------------------------------------------------------+
//| Инициализация ядра                                               |
//+------------------------------------------------------------------+
void CWndEvents::InitializeCore(void) {
//--- Включим таймер, если вне тестера
  if(!::MQLInfoInteger(MQL_TESTER)) {
    ::ResetLastError();
    bool is_timer =::EventSetMillisecondTimer(TIMER_STEP_MSC);
  }
//--- Получим ID текущего графика
  m_chart.Attach();
//--- Включим слежение за событиями мыши
  m_chart.EventMouseMove(true);
//--- Отключим вызов командной строки для клавиш Space и Enter
  m_chart.SetInteger(CHART_QUICK_NAVIGATION, false);
//--- Определение номера подокна
  DetermineSubwindow();
}
//+------------------------------------------------------------------+
//| Инициализация событийных переменных                              |
//+------------------------------------------------------------------+
void CWndEvents::InitChartEventsParams(const int id, const long lparam, const double dparam, const string sparam) {
  m_id     = id;
  m_lparam = lparam;
  m_dparam = dparam;
  m_sparam = sparam;
//--- Получим параметры мыши
  m_mouse.OnEvent(id, lparam, dparam, sparam);
}
//+------------------------------------------------------------------+
//| Обработка событий программы                                      |
//+------------------------------------------------------------------+
void CWndEvents::ChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam) {
//--- Если массив пуст, выйдем
  if(CWndContainer::WindowsTotal() < 1) {
    //--- Направление события в файл приложения
    OnEvent(id, lparam, dparam, sparam);
    return;
  }
//--- Инициализация полей параметров событий
  InitChartEventsParams(id, lparam, dparam, sparam);
//--- Пользовательские события
  ChartEventCustom();
//--- Проверка событий элементов интерфейса
  CheckElementsEvents();
//--- Событие перемещения мыши
  ChartEventMouseMove();
//--- Событие изменения свойств графика
  ChartEventChartChange();
}
//+------------------------------------------------------------------+
//| Проверка событий элементов управления                            |
//+------------------------------------------------------------------+
void CWndEvents::CheckElementsEvents(void) {
//--- Обработка события перемещения курсора мыши
  if(m_id == CHARTEVENT_MOUSE_MOVE) {
    //--- Выйти, если форма находится в другом подокне графика
    if(!m_windows[m_active_window_index].CheckSubwindowNumber())
      return;
    //--- Проверяем только доступные элементы
    int available_elements_total = CWndContainer::AvailableElementsTotal(m_active_window_index);
    for(int e = 0; e < available_elements_total; e++) {
      CElement *el = m_wnd[m_active_window_index].m_available_elements[e];
      //--- Проверка фокуса над элементами
      el.CheckMouseFocus();
      //--- Обработка события
      el.OnEvent(m_id, m_lparam, m_dparam, m_sparam);
    }
  }
//--- Все события, кроме перемещения курсора мыши
  else {
    int elements_total = CWndContainer::ElementsTotal(m_active_window_index);
    for(int e = 0; e < elements_total; e++) {
      //--- Проверяем только доступные элементы
      CElement *el = m_wnd[m_active_window_index].m_elements[e];
      if(!el.IsVisible() || !el.CElementBase::IsAvailable() || el.CElementBase::IsLocked())
        continue;
      //--- Обработка события в обработчике элемента
      el.OnEvent(m_id, m_lparam, m_dparam, m_sparam);
    }
  }
//--- Направление события в файл приложения
  OnEvent(m_id, m_lparam, m_dparam, m_sparam);
}
//+------------------------------------------------------------------+
//| Проверка пользовательских событий (CHARTEVENT_CUSTOM)            |
//+------------------------------------------------------------------+
void CWndEvents::ChartEventCustom(void) {
//--- Если сигнал на определение доступных элементов
  if(OnSetAvailable())
    return;
//--- Если сигнал об изменении в графическом интерфейсе
  if(OnChangeGUI())
    return;
//--- Если сигнал на определение заблокированных элементов
  if(OnSetLocked())
    return;
//--- Если сигнал об окончании перетаскивания формы
  if(OnWindowEndDrag())
    return;
//--- Если сигнал свернуть форму
  if(OnWindowCollapse())
    return;
//--- Если сигнал развернуть форму
  if(OnWindowExpand())
    return;
//--- Если сигнал изменить размер элементов по оси X
  if(OnWindowChangeXSize())
    return;
//--- Если сигнал изменить размер элементов по оси Y
  if(OnWindowChangeYSize())
    return;
//--- Если сигнал включить/выключить всплывающие подсказки
  if(OnWindowTooltips())
    return;
//--- Если сигнал на скрытие контекстных меню от пункта инициатора
  if(OnHideBackContextMenus())
    return;
//--- Если сигнал на скрытие всех контекстных меню
  if(OnHideContextMenus())
    return;
//--- Если сигнал на открытие диалогового окна
  if(OnOpenDialogBox())
    return;
//--- Если сигнал на закрытие диалогового окна
  if(OnCloseDialogBox())
    return;
}
//+------------------------------------------------------------------+
//| Событие CHARTEVENT CLICK                                         |
//+------------------------------------------------------------------+
void CWndEvents::ChartEventClick(void) {
}
//+------------------------------------------------------------------+
//| Событие CHARTEVENT MOUSE MOVE                                    |
//+------------------------------------------------------------------+
void CWndEvents::ChartEventMouseMove(void) {
//--- Выйти, если это не событие перемещения курсора
  if(m_id != CHARTEVENT_MOUSE_MOVE)
    return;
//--- Перемещение окна
  MovingWindow();
//--- Установка состояния графика
  SetChartState();
}
//+------------------------------------------------------------------+
//| Событие CHARTEVENT OBJECT CLICK                                  |
//+------------------------------------------------------------------+
void CWndEvents::ChartEventObjectClick(void) {
}
//+------------------------------------------------------------------+
//| Событие CHARTEVENT OBJECT ENDEDIT                                |
//+------------------------------------------------------------------+
void CWndEvents::ChartEventEndEdit(void) {
}
//+------------------------------------------------------------------+
//| Событие CHARTEVENT CHART CHANGE                                  |
//+------------------------------------------------------------------+
void CWndEvents::ChartEventChartChange(void) {
//--- Событие изменения свойств графика
  if(m_id != CHARTEVENT_CHART_CHANGE)
    return;
//--- Проверка и обновление номера окна эксперта
  CheckExpertSubwindowNumber();
//--- Проверка и обновление номера окна индикатора
  CheckSubwindowNumber();
//--- Перемещение окна
  MovingWindow(true);
//--- Изменение размеров заблокированного главного окна
  ResizeLockedWindow();
//--- Перерисуем график
  m_chart.Redraw();
}
//+------------------------------------------------------------------+
//| Таймер                                                           |
//+------------------------------------------------------------------+
void CWndEvents::OnTimerEvent(void) {
//--- Выйти, если курсор мыши в состоянии покоя (разница между вызовами > 300 ms) и левая кнопка мыши отжата
  if(m_mouse.GapBetweenCalls() > 300 && !m_mouse.LeftButtonState()) {
    int text_boxes_total = CWndContainer::ElementsTotal(m_active_window_index, E_TEXT_BOX);
    for(int e = 0; e < text_boxes_total; e++)
      m_wnd[m_active_window_index].m_text_boxes[e].OnEventTimer();
    //---
    return;
  }
//--- Если массив пуст, выйдем
  if(CWndContainer::WindowsTotal() < 1)
    return;
//--- Проверка событий всех элементов по таймеру
  CheckElementsEventsTimer();
//--- Перерисуем график, если окно в режиме перемещения
  if(m_windows[m_active_window_index].ClampingAreaMouse() == PRESSED_INSIDE_HEADER)
    m_chart.Redraw();
}
//+------------------------------------------------------------------+
//| Событие окончания перетаскивания формы                           |
//+------------------------------------------------------------------+
bool CWndEvents::OnWindowEndDrag(void) {
//--- Если сигнал свернуть форму
  if(m_id != CHARTEVENT_CUSTOM + ON_WINDOW_DRAG_END)
    return(false);
//--- Если идентификатор окна и номер подокна совпадают
  if(m_lparam == m_windows[0].Id() && (int)m_dparam == m_subwin) {
    //--- Установить режим показа во всех главных элементах
    int main_total = MainElementsTotal(m_active_window_index);
    for(int e = 0; e < main_total; e++) {
      CElement *el = m_wnd[m_active_window_index].m_main_elements[e];
      el.Moving(false);
    }
  }
//--- Обновить расположение всех элементов
  m_chart.Redraw();
  return(true);
}
//+------------------------------------------------------------------+
//| Событие свёртывания формы                                        |
//+------------------------------------------------------------------+
bool CWndEvents::OnWindowCollapse(void) {
//--- Если сигнал свернуть форму
  if(m_id != CHARTEVENT_CUSTOM + ON_WINDOW_COLLAPSE)
    return(false);
//--- Если идентификатор окна и номер подокна совпадают
  if(m_lparam == m_windows[0].Id() && (int)m_dparam == m_subwin) {
    int elements_total = CWndContainer::ElementsTotal(0);
    for(int e = 0; e < elements_total; e++) {
      CElement *el = m_wnd[0].m_elements[e];
      //--- Скрыть все элементы кроме формы
      if(el.Id() > 0)
        el.Hide();
    }
    //--- Сбросить цвета формы
    m_windows[0].ResetColors();
  }
//--- Обновить расположение всех элементов
  m_chart.Redraw();
  return(true);
}
//+------------------------------------------------------------------+
//| Событие развёртывания формы                                      |
//+------------------------------------------------------------------+
bool CWndEvents::OnWindowExpand(void) {
//--- Если сигнал "Развернуть форму"
  if(m_id != CHARTEVENT_CUSTOM + ON_WINDOW_EXPAND)
    return(false);
//--- Индекс активного окна
  int awi = m_active_window_index;
//--- Если идентификатор окна и номер подокна совпадают
  if(m_lparam != m_windows[awi].Id() || (int)m_dparam != m_subwin)
    return(true);
//--- Изменить высоту окна, если включен режим
  if(m_windows[awi].AutoYResizeMode())
    m_windows[awi].ChangeWindowHeight(m_chart.HeightInPixels(m_subwin) - 3);
//---
  int y_resize_total = CWndContainer::AutoYResizeElementsTotal(awi);
  for(int e = 0; e < y_resize_total; e++) {
    CElement *el = m_wnd[awi].m_auto_y_resize_elements[e];
    //--- Если включен режим, то подогнать высоту
    if(el.AutoYResizeMode()) {
      el.ChangeHeightByBottomWindowSide();
      el.Update();
    }
  }
//--- Показать элементы
  Show(awi);
//--- Показать элементы только выделенных вкладок
  ShowTabElements(awi);
//--- Обновить для отображения всех изменений
  int elements_total = CWndContainer::ElementsTotal(awi);
  for(int e = 0; e < elements_total; e++) {
    CElement *el = m_wnd[awi].m_elements[e];
    if(el.IsVisible())
      el.Update();
  }
//--- Обновить расположение всех элементов
  m_chart.Redraw();
  return(true);
}
//+------------------------------------------------------------------+
//| Событие изменения размеров элементов по оси X                    |
//+------------------------------------------------------------------+
bool CWndEvents::OnWindowChangeXSize(void) {
//--- Если сигнал "Изменить размер элементов"
  if(m_id != CHARTEVENT_CUSTOM + ON_WINDOW_CHANGE_XSIZE)
    return(false);
//--- Выйти, если идентификаторы окна не совпадают
  if(m_lparam != m_windows[m_active_window_index].Id())
    return(true);
//--- Обновить положение элементов
  Moving();
//--- Обновить окно
  m_windows[m_active_window_index].Update();
//--- Изменить ширину
  int x_resize_total = CWndContainer::AutoXResizeElementsTotal(m_active_window_index);
  for(int e = 0; e < x_resize_total; e++) {
    CElement *el = m_wnd[m_active_window_index].m_auto_x_resize_elements[e];
    el.ChangeWidthByRightWindowSide();
    //el.Update();
  }
//--- Обновить положение элементов
  Moving();
//---
  for(int e = 0; e < x_resize_total; e++) {
    CElement *el = m_wnd[m_active_window_index].m_auto_x_resize_elements[e];
    el.Moving(false);
  }
  m_chart.Redraw();
  for(int e = 0; e < x_resize_total; e++) {
    CElement *el = m_wnd[m_active_window_index].m_auto_x_resize_elements[e];
    el.Update();
  }
//--- Обновить для отображения всех изменений в древовидных списках
  int treeviews_total = ElementsTotal(m_active_window_index, E_TREE_VIEW);
  for(int t = 0; t < treeviews_total; t++) {
    CTreeView *tv = m_wnd[m_active_window_index].m_treeview_lists[t];
    tv.RedrawContentList();
    tv.UpdateContentList();
  }
//--- Показать указатель курсора, если в режиме ручного изменения ширины
  if(m_windows[m_active_window_index].ResizeState())
    m_windows[m_active_window_index].GetResizePointer().Reset();
//--- Обновить расположение всех элементов
  m_chart.Redraw();
  return(true);
}
//+------------------------------------------------------------------+
//| Событие изменения размеров элементов по оси Y                    |
//+------------------------------------------------------------------+
bool CWndEvents::OnWindowChangeYSize(void) {
//--- Если сигнал "Изменить размер элементов"
  if(m_id != CHARTEVENT_CUSTOM + ON_WINDOW_CHANGE_YSIZE)
    return(false);
//--- Выйти, если идентификаторы окна не совпадают
  if(m_lparam != m_windows[m_active_window_index].Id())
    return(true);
//--- Обновить положение элементов
  Moving();
//--- Обновить окно
  m_windows[m_active_window_index].Update();
//--- Изменить высоту
  int y_resize_total = CWndContainer::AutoYResizeElementsTotal(m_active_window_index);
  for(int e = 0; e < y_resize_total; e++) {
    CElement *el = m_wnd[m_active_window_index].m_auto_y_resize_elements[e];
    el.ChangeHeightByBottomWindowSide();
    //el.Update();
  }
//--- Обновить положение элементов
  Moving();
//---
  for(int e = 0; e < y_resize_total; e++) {
    CElement *el = m_wnd[m_active_window_index].m_auto_y_resize_elements[e];
    el.Moving(false);
  }
  m_chart.Redraw();
  for(int e = 0; e < y_resize_total; e++) {
    CElement *el = m_wnd[m_active_window_index].m_auto_y_resize_elements[e];
    el.Update();
  }
//--- Показать указатель курсора, если в режиме ручного изменения высоты
  if(m_windows[m_active_window_index].ResizeState())
    m_windows[m_active_window_index].GetResizePointer().Reset();
//--- Обновить расположение всех элементов
  m_chart.Redraw();
  return(true);
}
//+------------------------------------------------------------------+
//| Событие включения/отключения всплывающих подсказок               |
//+------------------------------------------------------------------+
bool CWndEvents::OnWindowTooltips(void) {
//--- Если сигнал "Включить/отключить всплывающие подсказки"
  if(m_id != CHARTEVENT_CUSTOM + ON_WINDOW_TOOLTIPS)
    return(false);
//--- Вытий, если идентификаторы окна не совпадают
  if(m_lparam != m_windows[0].Id())
    return(true);
//--- Синхронизировать режим всплывающих подсказок между всеми окнами
  int windows_total = WindowsTotal();
  for(int w = 0; w < windows_total; w++) {
    bool state = m_windows[0].TooltipButtonState();
    m_windows[w].IsTooltip(state);
    //--- Показать всплывающие подсказки в кнопках окон
    int window_elements_total = m_windows[w].ElementsTotal();
    for(int e = 0; e < window_elements_total; e++) {
      CElement *el = m_windows[w].Element(e);
      el.ShowTooltip(state);
    }
    //--- Установить режим показа во всех элементах
    int elements_total = ElementsTotal(w);
    for(int e = 0; e < elements_total; e++) {
      CElement *el = m_wnd[w].m_elements[e];
      el.ShowTooltip(state);
    }
  }
//--- Переместить всплывающие подсказки на верхний слой
  ResetTooltips();
  return(true);
}
//+------------------------------------------------------------------+
//| Событие скрытия контектсных меню от пункта инициатора            |
//+------------------------------------------------------------------+
bool CWndEvents::OnHideBackContextMenus(void) {
//--- Если сигнал на скрытие контекстных меню от пункта инициатора
  if(m_id != CHARTEVENT_CUSTOM + ON_HIDE_BACK_CONTEXTMENUS)
    return(false);
//--- Пройдём по всем меню от последнего вызванного
  int awi = m_active_window_index;
  int context_menus_total = CWndContainer::ElementsTotal(awi, E_CONTEXT_MENU);
  for(int i = context_menus_total - 1; i >= 0; i--) {
    //--- Указатели контекстного меню и его предыдущего узла
    CContextMenu *cm = m_wnd[awi].m_context_menus[i];
    CMenuItem    *mi = cm.PrevNodePointer();
    //--- Если дальше этого пункта больше ничего нет, то...
    if(::CheckPointer(mi) == POINTER_INVALID)
      continue;
    //--- Если дошли до пункта инициатора сигнала, то...
    if(mi.Id() == m_lparam) {
      //--- ...в случае, если его контекстное меню без фокуса, скроем его
      if(!cm.MouseFocus()) {
        cm.Hide();
        mi.IsPressed(false);
        mi.Update(true);
      }
      //--- Завершим цикл
      break;
    } else {
      cm.Hide();
      mi.IsPressed(false);
      mi.Update(true);
    }
  }
  return(true);
}
//+------------------------------------------------------------------+
//| Событие скрытия всех контекстных меню                            |
//+------------------------------------------------------------------+
bool CWndEvents::OnHideContextMenus(void) {
//--- Если сигнал на скрытие всех контекстных меню
  if(m_id != CHARTEVENT_CUSTOM + ON_HIDE_CONTEXTMENUS)
    return(false);
//--- Скрыть все контекстные меню
  int awi = m_active_window_index;
  int cm_total = CWndContainer::ElementsTotal(awi, E_CONTEXT_MENU);
  for(int i = 0; i < cm_total; i++) {
    m_wnd[awi].m_context_menus[i].Hide();
    //---
    if(CheckPointer(m_wnd[awi].m_context_menus[i].PrevNodePointer()) != POINTER_INVALID) {
      CMenuItem *mi = m_wnd[awi].m_context_menus[i].PrevNodePointer();
      mi.IsPressed(false);
      mi.Update(true);
    }
  }
//--- Отключить главные меню
  int menu_bars_total = CWndContainer::ElementsTotal(awi, E_MENU_BAR);
  for(int i = 0; i < menu_bars_total; i++)
    m_wnd[awi].m_menu_bars[i].State(false);
//---
  return(true);
}
//+------------------------------------------------------------------+
//| Событие открытия диалогового окна                                |
//+------------------------------------------------------------------+
bool CWndEvents::OnOpenDialogBox(void) {
//--- Если сигнал на открытие диалогового окна
  if(m_id != CHARTEVENT_CUSTOM + ON_OPEN_DIALOG_BOX)
    return(false);
//--- Выйти, если сообщение от другой программы
  if(m_sparam != m_program_name)
    return(true);
//--- Пройдёмся по массиву окон
  int window_total = CWndContainer::WindowsTotal();
  for(int w = 0; w < window_total; w++) {
    //--- Если идентификатор открытого окна
    if(m_windows[w].Id() == m_lparam) {
      //--- Запомним в этой форме индекс окна, с которого она была вызвана
      m_windows[w].PrevActiveWindowIndex(m_active_window_index);
      //--- Активируем форму
      m_windows[w].State(true);
      //--- Восстановим объектам формы приоритеты на нажатие левой кнопкой мыши
      m_windows[w].SetZorders();
      //--- Запомним индекс активированного окна
      m_active_window_index = w;
      //--- Показать окно
      Show(m_active_window_index);
    }
    //--- Другие формы будут заблокированы, пока не закроется активированное окно
    else {
      //--- Заблокируем форму
      m_windows[w].State(false);
      //--- Обнулим приоритеты элементов формы на нажатие левой кнопкой мыши
      int elements_total = CWndContainer::ElementsTotal(w);
      for(int e = 0; e < elements_total; e++)
        m_wnd[w].m_elements[e].ResetZorders();
    }
  }
//--- Скрытие всплывающих подсказок в предыдущем окне
  int prev_window_index = m_windows[m_active_window_index].PrevActiveWindowIndex();
  int tooltips_total = CWndContainer::ElementsTotal(prev_window_index, E_TOOLTIP);
  for(int t = 0; t < tooltips_total; t++)
    m_wnd[prev_window_index].m_tooltips[t].FadeOutTooltip();
//--- Показать элементы только выделенных вкладок
  ShowTabElements(m_active_window_index);
//--- Сформируем массив видимых и при этом доступных элементов
  FormAvailableElementsArray();
//--- Восстановление приоритетов на нажатие левой кнопкой мыши у активированного окна
  SetZorders();
//--- Переместить всплывающие подсказки на верхний слой
  ResetTooltips();
  return(true);
}
//+------------------------------------------------------------------+
//| Событие закрытия диалогового окна                                |
//+------------------------------------------------------------------+
bool CWndEvents::OnCloseDialogBox(void) {
//--- Если сигнал на закрытие диалогового окна
  if(m_id != CHARTEVENT_CUSTOM + ON_CLOSE_DIALOG_BOX)
    return(false);
//--- Пройдёмся по массиву окон
  int window_total = CWndContainer::WindowsTotal();
  for(int w = 0; w < window_total; w++) {
    //--- Если идентификатор открытого окна
    if(m_windows[w].Id() == m_lparam) {
      //--- Заблокируем форму
      m_windows[w].State(false);
      //--- Спрячем форму
      int elements_total = CWndContainer::ElementsTotal(w);
      for(int e = 0; e < elements_total; e++)
        m_wnd[w].m_elements[e].Hide();
      //--- Активируем предыдущую форму
      m_windows[int(m_dparam)].State(true);
      //--- Перерисовка графика
      m_chart.Redraw();
      break;
    }
  }
//--- Установка индекса предыдущего окна
  m_active_window_index = int(m_dparam);
//--- Восстановление приоритетов на нажатие левой кнопкой мыши у активированного окна
  SetZorders();
  return(true);
}
//+------------------------------------------------------------------+
//| Событие для определения доступных элементов управления           |
//+------------------------------------------------------------------+
bool CWndEvents::OnSetAvailable(void) {
//--- Если сигнал об изменении доступности элементов
  if(m_id != CHARTEVENT_CUSTOM + ON_SET_AVAILABLE)
    return(false);
//--- Сигнал на установку/восстановление
  bool is_restore = (bool)m_dparam;
//--- Определим активные элементы
  int ww_index = ActivatedWindowIndex();
  int mb_index = ActivatedMenuBarIndex();
  int mi_index = ActivatedMenuItemIndex();
  int sb_index = ActivatedSplitButtonIndex();
  int cb_index = ActivatedComboBoxIndex();
  int dc_index = ActivatedDropCalendarIndex();
  int sc_index = ActivatedScrollIndex();
  int tl_index = ActivatedTableIndex();
  int sd_index = ActivatedSliderIndex();
  int tv_index = ActivatedTreeViewIndex();
  int ch_index = ActivatedSubChartIndex();
//--- Если сигнал на определение доступных элементов, сначала отключаем доступ
  if(!is_restore)
    SetAvailable(m_active_window_index, false);
//--- Восстанавливаем, только если нет активированных элементов
  else {
    if(ww_index == WRONG_VALUE && mb_index == WRONG_VALUE && mi_index == WRONG_VALUE &&
        sb_index == WRONG_VALUE && dc_index == WRONG_VALUE && cb_index == WRONG_VALUE &&
        sc_index == WRONG_VALUE && tl_index == WRONG_VALUE && sd_index == WRONG_VALUE &&
        tv_index == WRONG_VALUE && ch_index == WRONG_VALUE) {
      SetAvailable(m_active_window_index, true);
      return(true);
    }
  }
//--- Если (1) сигнал на определение доступных элементов или (2) на восстановление для выпадающего календаря
  if(!is_restore || (is_restore && dc_index != WRONG_VALUE)) {
    CElement *el = NULL;
    //--- Окно
    if(ww_index != WRONG_VALUE) {
      el = m_windows[m_active_window_index];
    }
    //--- Главное меню
    else if(mb_index != WRONG_VALUE) {
      el = m_wnd[m_active_window_index].m_menu_bars[mb_index];
    }
    //--- Пункт меню
    else if(mi_index != WRONG_VALUE) {
      el = m_wnd[m_active_window_index].m_menu_items[mi_index];
    }
    //--- Сдвоенная кнопка
    else if(sb_index != WRONG_VALUE) {
      el = m_wnd[m_active_window_index].m_split_buttons[sb_index];
    }
    //--- Выпадающий календарь без выпадающего списка
    else if(dc_index != WRONG_VALUE && cb_index == WRONG_VALUE) {
      el = m_wnd[m_active_window_index].m_drop_calendars[dc_index];
    }
    //--- Выпадающий список
    else if(cb_index != WRONG_VALUE) {
      el = m_wnd[m_active_window_index].m_combo_boxes[cb_index];
    }
    //--- Полоса прокрутки
    else if(sc_index != WRONG_VALUE) {
      el = m_wnd[m_active_window_index].m_scrolls[sc_index];
    }
    //--- Таблица
    else if(tl_index != WRONG_VALUE) {
      el = m_wnd[m_active_window_index].m_tables[tl_index];
    }
    //--- Слайдер
    else if(sd_index != WRONG_VALUE) {
      el = m_wnd[m_active_window_index].m_sliders[sd_index];
    }
    //--- Древовидный список
    else if(tv_index != WRONG_VALUE) {
      el = m_wnd[m_active_window_index].m_treeview_lists[tv_index];
    }
    //--- Стандартный график
    else if(ch_index != WRONG_VALUE) {
      el = m_wnd[m_active_window_index].m_sub_charts[ch_index];
    }
    //--- Выйти, если указатель на элемент не получен
    if(::CheckPointer(el) == POINTER_INVALID) {
      return(true);
    }
    //--- Блок для главного меню
    if(mb_index != WRONG_VALUE) {
      //--- Сделать доступными главное меню и его видимые контекстные меню
      el.IsAvailable(true);
      //---
      CMenuBar *mb = dynamic_cast<CMenuBar*>(el);
      int items_total = mb.ItemsTotal();
      for(int i = 0; i < items_total; i++) {
        CMenuItem *mi = mb.GetItemPointer(i);
        mi.IsAvailable(true);
        //--- Проверяет и делает контекстное меню доступным
        CheckContextMenu(mi);
      }
    }
    //--- Блок для пункта меню
    if(mi_index != WRONG_VALUE) {
      CMenuItem *mi = dynamic_cast<CMenuItem*>(el);
      mi.IsAvailable(true);
      //--- Проверяет и делает контекстное меню доступным
      CheckContextMenu(mi);
    }
    //--- Блок для полос прокрутки
    else if(sc_index != WRONG_VALUE) {
      //--- Сделать доступным начиная от главного узла
      el.MainPointer().IsAvailable(true);
    }
    //--- Блок для древовидного списка
    else if(tv_index != WRONG_VALUE) {
      //--- Заблокировать все элементы, кроме главного
      CTreeView *tv = dynamic_cast<CTreeView*>(el);
      tv.IsAvailable(true, true);
      int total = tv.ElementsTotal();
      for(int i = 0; i < total; i++)
        tv.Element(i).IsAvailable(false);
    } else {
      //--- Сделать элемент доступным
      el.IsAvailable(true);
    }
  }
//---
  return(true);
}
//+------------------------------------------------------------------+
//| Событие ON_SET_LOCKED                                            |
//+------------------------------------------------------------------+
bool CWndEvents::OnSetLocked(void) {
//--- Если сигнал о блокировке элементов
  if(m_id != CHARTEVENT_CUSTOM + ON_SET_LOCKED)
    return(false);
//---
  bool find_flag = false;
//---
  int elements_total = CWndContainer::MainElementsTotal(m_active_window_index);
  for(int e = 0; e < elements_total; e++) {
    CElement *el = m_wnd[m_active_window_index].m_main_elements[e];
    //---
    if(m_lparam != el.Id()) {
      if(find_flag)
        break;
      //---
      continue;
    }
    //---
    find_flag = true;
    //---
    int total = el.ElementsTotal();
    for(int i = 0; i < total; i++)
      el.Element(i).Update(true);
    //---
    el.Update(true);
  }
  return(true);
}
//+------------------------------------------------------------------+
//| Событие изменений в графическом интерфейсе                       |
//+------------------------------------------------------------------+
bool CWndEvents::OnChangeGUI(void) {
//--- Если сигнал об изменении в графическом интерфейсе
  if(m_id != CHARTEVENT_CUSTOM + ON_CHANGE_GUI)
    return(false);
//--- Сформируем массив видимых и при этом доступных элементов
  FormAvailableElementsArray();
//--- Переместить всплывающие подсказки на верхний слой
  ResetTooltips();
//--- Перерисовать график
  m_chart.Redraw();
  return(true);
}
//+------------------------------------------------------------------+
//| Возвращает индекс активированного окна                           |
//+------------------------------------------------------------------+
int CWndEvents::ActivatedWindowIndex(void) {
  int index = WRONG_VALUE;
//---
  int total = WindowsTotal();
  for(int i = 0; i < total; i++) {
    if(m_windows[i].ResizeState()) {
      index = i;
      break;
    }
  }
  return(index);
}
//+------------------------------------------------------------------+
//| Возвращает индекс активированного главного меню                  |
//+------------------------------------------------------------------+
int CWndEvents::ActivatedMenuBarIndex(void) {
  int index = WRONG_VALUE;
//---
  int total = ElementsTotal(m_active_window_index, E_MENU_BAR);
  for(int i = 0; i < total; i++) {
    CMenuBar *el = m_wnd[m_active_window_index].m_menu_bars[i];
    if(el.State()) {
      index = i;
      break;
    }
  }
  return(index);
}
//+------------------------------------------------------------------+
//| Возвращает индекс активированного пункта меню                    |
//+------------------------------------------------------------------+
int CWndEvents::ActivatedMenuItemIndex(void) {
  int index = WRONG_VALUE;
//---
  int total = ElementsTotal(m_active_window_index, E_MENU_ITEM);
  for(int i = 0; i < total; i++) {
    CMenuItem *el = m_wnd[m_active_window_index].m_menu_items[i];
    if(el.GetContextMenuPointer().IsVisible()) {
      index = i;
      break;
    }
  }
  return(index);
}
//+------------------------------------------------------------------+
//| Возвращает индекс активированной сдвоенной кнопки                |
//+------------------------------------------------------------------+
int CWndEvents::ActivatedSplitButtonIndex(void) {
  int index = WRONG_VALUE;
//---
  int total = ElementsTotal(m_active_window_index, E_SPLIT_BUTTON);
  for(int i = 0; i < total; i++) {
    CSplitButton *el = m_wnd[m_active_window_index].m_split_buttons[i];
    if(el.GetContextMenuPointer().IsVisible()) {
      index = i;
      break;
    }
  }
  return(index);
}
//+------------------------------------------------------------------+
//| Возвращает индекс активированного комбо-бокса                    |
//+------------------------------------------------------------------+
int CWndEvents::ActivatedComboBoxIndex(void) {
  int index = WRONG_VALUE;
//---
  int total = ElementsTotal(m_active_window_index, E_COMBO_BOX);
  for(int i = 0; i < total; i++) {
    CComboBox *el = m_wnd[m_active_window_index].m_combo_boxes[i];
    if(el.GetListViewPointer().IsVisible()) {
      index = i;
      break;
    }
  }
  return(index);
}
//+------------------------------------------------------------------+
//| Возвращает индекс активированного выпадающего календаря          |
//+------------------------------------------------------------------+
int CWndEvents::ActivatedDropCalendarIndex(void) {
  int index = WRONG_VALUE;
//---
  int total = ElementsTotal(m_active_window_index, E_DROP_CALENDAR);
  for(int i = 0; i < total; i++) {
    CDropCalendar *el = m_wnd[m_active_window_index].m_drop_calendars[i];
    if(el.GetCalendarPointer().IsVisible()) {
      index = i;
      break;
    }
  }
  return(index);
}
//+------------------------------------------------------------------+
//| Возвращает индекс активированной полосы прокрутки                |
//+------------------------------------------------------------------+
int CWndEvents::ActivatedScrollIndex(void) {
  int index = WRONG_VALUE;
//---
  int total = ElementsTotal(m_active_window_index, E_SCROLL);
  for(int i = 0; i < total; i++) {
    CScroll *el = m_wnd[m_active_window_index].m_scrolls[i];
    if(el.State()) {
      index = i;
      break;
    }
  }
  return(index);
}
//+------------------------------------------------------------------+
//| Возвращает индекс активированной таблицы                         |
//+------------------------------------------------------------------+
int CWndEvents::ActivatedTableIndex(void) {
  int index = WRONG_VALUE;
//---
  int total = ElementsTotal(m_active_window_index, E_TABLE);
  for(int i = 0; i < total; i++) {
    CTable *el = m_wnd[m_active_window_index].m_tables[i];
    if(el.ColumnResizeControl()) {
      index = i;
      break;
    }
  }
  return(index);
}
//+------------------------------------------------------------------+
//| Возвращает индекс активированного слайдера                       |
//+------------------------------------------------------------------+
int CWndEvents::ActivatedSliderIndex(void) {
  int index = WRONG_VALUE;
//---
  int total = ElementsTotal(m_active_window_index, E_SLIDER);
  for(int i = 0; i < total; i++) {
    CSlider *el = m_wnd[m_active_window_index].m_sliders[i];
    if(el.State()) {
      index = i;
      break;
    }
  }
  return(index);
}
//+------------------------------------------------------------------+
//| Возвращает индекс активированного древовидного списка            |
//+------------------------------------------------------------------+
int CWndEvents::ActivatedTreeViewIndex(void) {
  int index = WRONG_VALUE;
//---
  int total = ElementsTotal(m_active_window_index, E_TREE_VIEW);
  for(int i = 0; i < total; i++) {
    CTreeView *el = m_wnd[m_active_window_index].m_treeview_lists[i];
    //--- Перейти к следующему, если включен режим вкладок
    if(el.TabItemsMode())
      continue;
    //--- Если процесс изменения ширины списков
    if(el.GetMousePointer().State()) {
      index = i;
      break;
    }
  }
  return(index);
}
//+------------------------------------------------------------------+
//| Возвращает индекс активированного стандартного графика           |
//+------------------------------------------------------------------+
int CWndEvents::ActivatedSubChartIndex(void) {
  int index = WRONG_VALUE;
//---
  int total = ElementsTotal(m_active_window_index, E_SUB_CHART);
  for(int i = 0; i < total; i++) {
    CStandardChart *el = m_wnd[m_active_window_index].m_sub_charts[i];
    if(el.GetMousePointer().IsVisible()) {
      index = i;
      break;
    }
  }
  return(index);
}
//+------------------------------------------------------------------+
//| Рекурсивно проверяет и делает контекстные меню доступными        |
//+------------------------------------------------------------------+
void CWndEvents::CheckContextMenu(CMenuItem &object) {
//--- Получим указатель контекстного меню
  CContextMenu *cm = object.GetContextMenuPointer();
//--- Выйти, если контекстного меню нет в пункте
  if(::CheckPointer(cm) == POINTER_INVALID)
    return;
//--- Выйти, если контекстное меню есть, но скрыто
  if(!cm.IsVisible())
    return;
//--- Установить признаки доступного элемента
  cm.IsAvailable(true);
//---
  int items_total = cm.ItemsTotal();
  for(int i = 0; i < items_total; i++) {
    //--- Установить признаки доступного элемента
    CMenuItem *mi = cm.GetItemPointer(i);
    mi.IsAvailable(true);
    //--- Проверим, есть ли в этом пункте контекстное меню
    CheckContextMenu(mi);
  }
}
//+------------------------------------------------------------------+
//| Перемещение окна                                                 |
//+------------------------------------------------------------------+
void CWndEvents::MovingWindow(const bool moving_mode = false) {
//--- Если управление передано окну, определим его положение
  if(!moving_mode)
    if(m_windows[m_active_window_index].ClampingAreaMouse() != PRESSED_INSIDE_HEADER)
      return;
//--- Перемещение окна
  int x = m_windows[m_active_window_index].X();
  int y = m_windows[m_active_window_index].Y();
  m_windows[m_active_window_index].Moving(x, y);
//--- Перемещение элементов управления
  int main_total = MainElementsTotal(m_active_window_index);
  for(int e = 0; e < main_total; e++) {
    CElement *el = m_wnd[m_active_window_index].m_main_elements[e];
    el.Moving();
  }
}
//+------------------------------------------------------------------+
//| Проверка событий всех элементов по таймеру                       |
//+------------------------------------------------------------------+
void CWndEvents::CheckElementsEventsTimer(void) {
  int awi = m_active_window_index;
  int timer_elements_total = CWndContainer::TimerElementsTotal(awi);
  for(int e = 0; e < timer_elements_total; e++) {
    CElement *el = m_wnd[awi].m_timer_elements[e];
    if(el.IsVisible())
      el.OnEventTimer();
  }
}
//+------------------------------------------------------------------+
//| Определение номера подокна                                       |
//+------------------------------------------------------------------+
void CWndEvents::DetermineSubwindow(void) {
//--- Выйдем, если тип программы "Скрипт"
  if(PROGRAM_TYPE == PROGRAM_SCRIPT)
    return;
//--- Сброс последней ошибки
  ::ResetLastError();
//--- Если тип программы эксперт
  if(PROGRAM_TYPE == PROGRAM_EXPERT) {
    //--- Выйти, если графический интерфейс эксперта нужен в главном окне
    if(!EXPERT_IN_SUBWINDOW)
      return;
    //--- Получим хэндл индикатора-пустышки (пустое подокно)
    m_subwindow_handle = iCustom(::Symbol(), ::Period(), "::Indicators\\SubWindow.ex5");
    //--- Если такого индикатор нет, сообщить об ошибке в журнал
    if(m_subwindow_handle == INVALID_HANDLE)
      ::Print(__FUNCTION__, " > Ошибка при получении хэндла индикатора в директории ::Indicators\\SubWindow.ex5 !");
    //--- Если хэндл получен, значит индикатор есть, подключен к приложению в качестве ресурса,
    //    а это значит, что графический интерфейс приложения нужно поместить в подокно
    else {
      //--- Получим количество подокон на графике
      int subwindows_total = (int)::ChartGetInteger(m_chart_id, CHART_WINDOWS_TOTAL);
      //--- Установим подокно для графического интерфейса эксперта
      if(::ChartIndicatorAdd(m_chart_id, subwindows_total, m_subwindow_handle)) {
        //--- Сохраним номер подокна и текущее количество подокон на графике
        m_subwin           = subwindows_total;
        m_subwindows_total = subwindows_total + 1;
        //--- Получим и сохраним короткое имя подокна эксперта
        m_subwindow_shortname =::ChartIndicatorName(m_chart_id, m_subwin, 0);
      }
      //--- Если подокно не установилось
      else
        ::Print(__FUNCTION__, " > Ошибка при установке подокна эксперта! Номер ошибки: ", ::GetLastError());
    }
    //---
    return;
  }
//--- Определение номера окна индикатора
  m_subwin =::ChartWindowFind();
//--- Если не получилось определить номер, выйдем
  if(m_subwin < 0) {
    ::Print(__FUNCTION__, " > Ошибка при определении номера подокна: ", ::GetLastError());
    return;
  }
//--- Если это не главное окно графика
  if(m_subwin > 0) {
    //--- Получим общее количество индикаторов в указанном подокне
    int total =::ChartIndicatorsTotal(m_chart_id, m_subwin);
    //--- Получим короткое имя последнего индикатора в списке
    string indicator_name =::ChartIndicatorName(m_chart_id, m_subwin, total - 1);
    //--- Если в подокне уже есть индикатор, то удалить программу с графика
    if(total != 1) {
      ::Print(__FUNCTION__, " > В этом подокне уже есть индикатор.");
      ::ChartIndicatorDelete(m_chart_id, m_subwin, indicator_name);
      return;
    }
  }
}
//+------------------------------------------------------------------+
//| Удаляет подокно эксперта                                         |
//+------------------------------------------------------------------+
void CWndEvents::DeleteExpertSubwindow(void) {
//--- Выйти, если это не эксперт
  if(PROGRAM_TYPE != PROGRAM_EXPERT)
    return;
//--- Выйти, если хэндл невалиден
  if(m_subwindow_handle == INVALID_HANDLE)
    return;
//--- Получим количество окон на графике
  int windows_total = (int)::ChartGetInteger(m_chart_id, CHART_WINDOWS_TOTAL);
//--- Найдём подокно эксперта
  for(int w = 0; w < windows_total; w++) {
    //--- Получим короткое имя подокна эксперта (индикатор SubWindow.ex5)
    string indicator_name =::ChartIndicatorName(m_chart_id, w, 0);
    //--- Перейти к следующему, если это не подокно эксперта
    if(indicator_name != m_subwindow_shortname || w != m_subwin)
      continue;
    //--- Удалить подокно эксперта
    if(!::ChartIndicatorDelete(m_chart_id, m_subwin, indicator_name))
      ::Print(__FUNCTION__, " > Ошибка при удалении подокна эксперта! Номер ошибки: ", ::GetLastError());
  }
}
//+------------------------------------------------------------------+
//| Проверка и обновление номера окна эксперта                       |
//+------------------------------------------------------------------+
void CWndEvents::CheckExpertSubwindowNumber(void) {
//--- Выйти, если (1) это не эксперт или (2) графический интерфейс эксперта в главном окне
  if(PROGRAM_TYPE != PROGRAM_EXPERT || !EXPERT_IN_SUBWINDOW)
    return;
//--- Получим количество подокон на графике
  int subwindows_total = (int)::ChartGetInteger(m_chart_id, CHART_WINDOWS_TOTAL);
//--- Выйти, если количество подокон и количество индикаторов не изменилось
  if(subwindows_total == m_subwindows_total)
    return;
//--- Сохраним текущее количество подокон
  m_subwindows_total = subwindows_total;
//--- Для проверки наличия подокна эксперта
  bool is_subwindow = false;
//--- Найдём подокно эксперта
  for(int sw = 0; sw < subwindows_total; sw++) {
    //--- Остановить цикл, если подокно эксперта есть
    if(is_subwindow)
      break;
    //--- Сколько индикаторов в данном окне/подокне
    int indicators_total =::ChartIndicatorsTotal(m_chart_id, sw);
    //--- Переберём все индикаторы в окне
    for(int i = 0; i < indicators_total; i++) {
      //--- Получим короткое имя индикатора
      string indicator_name =::ChartIndicatorName(m_chart_id, sw, i);
      //--- Если это не подокно эксперта, перейти к следующему
      if(indicator_name != m_subwindow_shortname)
        continue;
      //--- Отметим, что подокно эксперта есть
      is_subwindow = true;
      //--- Если номер подокна изменился, то
      //    нужно сохранить новый номер во всех элементах главной формы
      if(sw != m_subwin) {
        //--- Сохраним номер подокна
        m_subwin = sw;
        //--- Сохраним его также во всех элементах главной формы интерфейса
        int elements_total = CWndContainer::ElementsTotal(0);
        for(int e = 0; e < elements_total; e++)
          m_wnd[0].m_elements[e].SubwindowNumber(m_subwin);
      }
      //---
      break;
    }
  }
//--- Если подокно эксперта не обнаружено, удалим эксперта
  if(!is_subwindow) {
    ::Print(__FUNCTION__, " > Удаление подокна эксперта приводит к удалению эксперта!");
    //--- Удаление эксперта с графика
    ::ExpertRemove();
  }
}
//+------------------------------------------------------------------+
//| Проверка и обновление номера окна программы                      |
//+------------------------------------------------------------------+
void CWndEvents::CheckSubwindowNumber(void) {
//--- Выйти, если это не индикатор
  if(PROGRAM_TYPE != PROGRAM_INDICATOR)
    return;
//--- Если программа в подокне и номера не совпадают
  if(m_subwin != 0 && m_subwin !=::ChartWindowFind()) {
    //--- Определить номер подокна
    DetermineSubwindow();
    //--- Сохранить во всех элементах
    int windows_total = CWndContainer::WindowsTotal();
    for(int w = 0; w < windows_total; w++) {
      int elements_total = CWndContainer::ElementsTotal(w);
      for(int e = 0; e < elements_total; e++)
        m_wnd[w].m_elements[e].SubwindowNumber(m_subwin);
    }
  }
}
//+------------------------------------------------------------------+
//| Изменение размеров заблокированного главного окна                |
//+------------------------------------------------------------------+
void CWndEvents::ResizeLockedWindow(void) {
//--- Сохранить во всех элементах
  int windows_total = CWndContainer::WindowsTotal();
//--- Выйти, если интерфейс не создан
  if(windows_total < 1)
    return;
//--- Изменить размер всех элементов заблокированной формы, если включен один из режимов
  if(m_windows[0].CElementBase::IsLocked() && (m_windows[0].AutoXResizeMode() || m_windows[0].AutoXResizeMode())) {
    int elements_total = CWndContainer::ElementsTotal(0);
    for(int e = 0; e < elements_total; e++) {
      CElement *el = m_wnd[0].m_elements[e];
      //--- Если это форма
      if(dynamic_cast<CWindow*>(el) != NULL) {
        el.OnEvent(m_id, m_lparam, m_dparam, m_sparam);
        continue;
      }
      //--- Изменить ширину элементов, где включен такой режим
      if(el.AutoXResizeMode())
        el.ChangeWidthByRightWindowSide();
      //--- Изменить ширину элементов, где включен такой режим
      if(el.AutoYResizeMode())
        el.ChangeHeightByBottomWindowSide();
      //--- Обновить положение объектов
      el.Moving();
    }
    //--- Обновим (сохраним) свойства графика у других форм
    for(int w = 1; w < windows_total; w++)
      m_windows[w].SetWindowProperties();
    //--- Перерисовка активированного окна
    ResetWindow();
    //--- Обновить
    Update();
  }
}
//+------------------------------------------------------------------+
//| Перерисовка окна                                                 |
//+------------------------------------------------------------------+
void CWndEvents::ResetWindow(void) {
//--- Выйти, если ещё нет ни одного окна
  if(CWndContainer::WindowsTotal() < 1)
    return;
//--- Перерисовка окна и его элементов
  Hide();
  Show(m_active_window_index);
}
//+------------------------------------------------------------------+
//| Удаление всех объектов                                           |
//+------------------------------------------------------------------+
void CWndEvents::Destroy(void) {
//--- Установим индекс главного окна
  m_active_window_index = 0;
//--- Получим количество окон
  int window_total = CWndContainer::WindowsTotal();
//--- Пройдёмся по массиву окон
  for(int w = 0; w < window_total; w++) {
    //--- Активируем главное окно
    if(m_windows[w].WindowType() == W_MAIN)
      m_windows[w].State(true);
    //--- Заблокируем диалоговые окна
    else
      m_windows[w].State(false);
  }
//--- Освободим массивы элементов
  for(int w = 0; w < window_total; w++) {
    int elements_total = CWndContainer::ElementsTotal(w);
    for(int e = 0; e < elements_total; e++) {
      //--- Если указатель невалидный, перейти к следующему
      if(::CheckPointer(m_wnd[w].m_elements[e]) == POINTER_INVALID)
        continue;
      //--- Удалить объекты элемента
      m_wnd[w].m_elements[e].Delete();
      m_wnd[w].m_elements[e].Id(WRONG_VALUE);
    }
    //--- Освободить массивы элементов
    ::ArrayFree(m_wnd[w].m_elements);
    ::ArrayFree(m_wnd[w].m_main_elements);
    ::ArrayFree(m_wnd[w].m_timer_elements);
    ::ArrayFree(m_wnd[w].m_auto_x_resize_elements);
    ::ArrayFree(m_wnd[w].m_auto_y_resize_elements);
    ::ArrayFree(m_wnd[w].m_available_elements);
    ::ArrayFree(m_wnd[w].m_menu_bars);
    ::ArrayFree(m_wnd[w].m_menu_items);
    ::ArrayFree(m_wnd[w].m_context_menus);
    ::ArrayFree(m_wnd[w].m_combo_boxes);
    ::ArrayFree(m_wnd[w].m_split_buttons);
    ::ArrayFree(m_wnd[w].m_drop_lists);
    ::ArrayFree(m_wnd[w].m_scrolls);
    ::ArrayFree(m_wnd[w].m_tables);
    ::ArrayFree(m_wnd[w].m_tabs);
    ::ArrayFree(m_wnd[w].m_calendars);
    ::ArrayFree(m_wnd[w].m_drop_calendars);
    ::ArrayFree(m_wnd[w].m_sub_charts);
    ::ArrayFree(m_wnd[w].m_pictures_slider);
    ::ArrayFree(m_wnd[w].m_time_edits);
    ::ArrayFree(m_wnd[w].m_text_boxes);
    ::ArrayFree(m_wnd[w].m_tooltips);
    ::ArrayFree(m_wnd[w].m_treeview_lists);
    ::ArrayFree(m_wnd[w].m_file_navigators);
    ::ArrayFree(m_wnd[w].m_frames);
  }
//--- Освободить массивы форм
  ::ArrayFree(m_wnd);
  ::ArrayFree(m_windows);
}
//+------------------------------------------------------------------+
//| Завершение создания GUI                                          |
//+------------------------------------------------------------------+
void CWndEvents::CompletedGUI(void) {
//--- Выйти, если ещё нет ни одного окна
  int windows_total = CWndContainer::WindowsTotal();
  if(windows_total < 1) {
    return;
  }
//--- Показать комментарий информирующий пользователя
  ::Comment("Update. Please wait...");
//--- Скрыть элементы
  Hide();
//--- Нарисовать элементы
  Update(true);
//--- Показать элементы активированного окна
  Show(m_active_window_index);
//--- Сформируем массив элементов с таймером
  FormTimerElementsArray();
//--- Сформируем массив видимых и при этом доступных элементов
  FormAvailableElementsArray();
//--- Сформируем массивы элементов с авто-ресайзом
  FormAutoXResizeElementsArray();
  FormAutoYResizeElementsArray();
//--- Перерисовать график
  m_chart.Redraw();
//--- Очистить комментарий
  ::Comment("");
//--- Отправим событие завершения создания GUI
  ::EventChartCustom(m_chart_id, ON_END_CREATE_GUI, 0, 0.0, "");
  
  //CWndEvents::PrintContainer();
}
//+------------------------------------------------------------------+
//| Перемещение элементов                                            |
//+------------------------------------------------------------------+
void CWndEvents::Moving(void) {
//--- Обновить положение элементов
  int main_total = MainElementsTotal(m_active_window_index);
  for(int e = 0; e < main_total; e++) {
    CElement *el = m_wnd[m_active_window_index].m_main_elements[e];
    el.Moving(false);
  }
}
//+------------------------------------------------------------------+
//| Скрытие элементов                                                |
//+------------------------------------------------------------------+
void CWndEvents::Hide(void) {
  int windows_total = CWndContainer::WindowsTotal();
  for(int w = 0; w < windows_total; w++) {
    m_windows[w].Hide();
    int main_total = MainElementsTotal(w);
    for(int e = 0; e < main_total; e++) {
      CElement *el = m_wnd[w].m_main_elements[e];
      el.Hide();
    }
  }
}
//+------------------------------------------------------------------+
//| Показ элементов указанного окна                                  |
//+------------------------------------------------------------------+
void CWndEvents::Show(const uint window_index) {
//--- Показать элементы указанного окна
  m_windows[window_index].Show();
//--- Если окно не свёрнуто
  if(!m_windows[window_index].IsMinimized()) {
    int main_total = MainElementsTotal(window_index);
    for(int e = 0; e < main_total; e++) {
      CElement *el = m_wnd[window_index].m_main_elements[e];
      //--- Показать элемент, если он (1) не выпадающий и (2) его главный элемент не вкладки
      if(!el.IsDropdown() && dynamic_cast<CTabs*>(el.MainPointer()) == NULL)
        el.Show();
    }
    //--- Показать элементы только выделенных вкладок
    ShowTabElements(window_index);
  }
}
//+------------------------------------------------------------------+
//| Восстановление приоритетов на нажатие левой кнопкой мыши         |
//| у активного окна                                                 |
//+------------------------------------------------------------------+
void CWndEvents::SetZorders(void) {
  int elements_total = CWndContainer::ElementsTotal(m_active_window_index);
  for(int e = 0; e < elements_total; e++) {
    CElement *el = m_wnd[m_active_window_index].m_elements[e];
    //---
    if(el.ClassName() != "CGraph")
      el.SetZorders();
    else {
      CGraph *graph = dynamic_cast<CGraph*>(el);
      graph.SetZorders();
    }
  }
}
//+------------------------------------------------------------------+
//| Перерисовка элементов                                            |
//+------------------------------------------------------------------+
void CWndEvents::Update(const bool redraw = false) {
  int windows_total = CWndContainer::WindowsTotal();
  for(int w = 0; w < windows_total; w++) {
    //--- Перерисовка элементов
    int elements_total = CWndContainer::ElementsTotal(w);
    for(int e = 0; e < elements_total; e++) {
      CElement *el = m_wnd[w].m_elements[e];
      el.Update(redraw);
    }
  }
}
//+------------------------------------------------------------------+
//| Перемещает всплывающие подсказки на верхний слой                 |
//+------------------------------------------------------------------+
void CWndEvents::ResetTooltips(void) {
//--- Переместить всплывающие подсказки на верхний слой
  int window_total = CWndContainer::WindowsTotal();
  for(int w = 0; w < window_total; w++) {
    int tooltips_total = CWndContainer::ElementsTotal(w, E_TOOLTIP);
    for(int t = 0; t < tooltips_total; t++)
      m_wnd[w].m_tooltips[t].Reset();
  }
}
//+------------------------------------------------------------------+
//| Устанавливает состояние доступности элементов                    |
//+------------------------------------------------------------------+
void CWndEvents::SetAvailable(const uint window_index, const bool state) {
//--- Получим количество главных элементов
  int main_total = MainElementsTotal(window_index);
//--- Если нужно сделать элементы недоступными
  if(!state) {
    m_windows[window_index].IsAvailable(state);
    for(int e = 0; e < main_total; e++) {
      CElement *el = m_wnd[window_index].m_main_elements[e];
      el.IsAvailable(state);
    }
  } else {
    m_windows[window_index].IsAvailable(state);
    for(int e = 0; e < main_total; e++) {
      CElement *el = m_wnd[window_index].m_main_elements[e];
      //--- Если это древовидный список
      if(dynamic_cast<CTreeView*>(el) != NULL) {
        CTreeView *tv = dynamic_cast<CTreeView*>(el);
        tv.IsAvailable(true);
        continue;
      }
      //--- Если это файловый навигатор
      if(dynamic_cast<CFileNavigator*>(el) != NULL) {
        CFileNavigator *fn = dynamic_cast<CFileNavigator*>(el);
        CTreeView      *tv = fn.GetTreeViewPointer();
        fn.IsAvailable(state);
        tv.IsAvailable(state);
        continue;
      }
      //--- Сделать элемент доступным
      el.IsAvailable(state);
    }
  }
}
//+------------------------------------------------------------------+
//| Показывает элементы только выделенных вкладок                    |
//+------------------------------------------------------------------+
void CWndEvents::ShowTabElements(const uint window_index) {
//--- Простые вкладки
  int tabs_total = CWndContainer::ElementsTotal(window_index, E_TABS);
  for(int t = 0; t < tabs_total; t++) {
    CTabs *el = m_wnd[window_index].m_tabs[t];
    if(el.IsVisible())
      el.ShowTabElements();
  }
//--- Вкладки древовидных списков
  int treeview_total = CWndContainer::ElementsTotal(window_index, E_TREE_VIEW);
  for(int tv = 0; tv < treeview_total; tv++)
    m_wnd[window_index].m_treeview_lists[tv].ShowTabElements();
}
//+------------------------------------------------------------------+
//| Формирует массив элементов с таймером                            |
//+------------------------------------------------------------------+
void CWndEvents::FormTimerElementsArray(void) {
  int windows_total = CWndContainer::WindowsTotal();
  for(int w = 0; w < windows_total; w++) {
    int elements_total = CWndContainer::ElementsTotal(w);
    for(int e = 0; e < elements_total; e++) {
      CElement *el = m_wnd[w].m_elements[e];
      //---
      if(dynamic_cast<CCalendar    *>(el) != NULL ||
          dynamic_cast<CColorPicker *>(el) != NULL ||
          dynamic_cast<CListView    *>(el) != NULL ||
          dynamic_cast<CTable       *>(el) != NULL ||
          dynamic_cast<CTextBox     *>(el) != NULL ||
          dynamic_cast<CTextEdit    *>(el) != NULL ||
          dynamic_cast<CTreeView    *>(el) != NULL) {
        CWndContainer::AddTimerElement(w, el);
      }
    }
  }
}
//+------------------------------------------------------------------+
//| Формирует массив доступных элементов                             |
//+------------------------------------------------------------------+
void CWndEvents::FormAvailableElementsArray(void) {
//--- Индекс окна
  int awi = m_active_window_index;
//--- Общее количество элементов
  int elements_total = CWndContainer::ElementsTotal(awi);
//--- Очистим массив
  ::ArrayFree(m_wnd[awi].m_available_elements);
//---
  for(int e = 0; e < elements_total; e++) {
    CElement *el = m_wnd[awi].m_elements[e];
    //--- Добавляем только видимые и доступные для обработки элементы
    if(!el.IsVisible() || !el.CElementBase::IsAvailable() || el.CElementBase::IsLocked())
      continue;
    //--- Исключить элементы не требующие обработки по наведению курсора мыши
    if(dynamic_cast<CButtonsGroup   *>(el) == NULL &&
        dynamic_cast<CFileNavigator  *>(el) == NULL &&
        dynamic_cast<CPicture        *>(el) == NULL &&
        dynamic_cast<CPicturesSlider *>(el) == NULL &&
        dynamic_cast<CProgressBar    *>(el) == NULL &&
        dynamic_cast<CSeparateLine   *>(el) == NULL &&
        dynamic_cast<CStatusBar      *>(el) == NULL &&
        dynamic_cast<CTabs           *>(el) == NULL &&
        dynamic_cast<CTextLabel      *>(el) == NULL) {
      AddAvailableElement(awi, el);
      //Print(__FUNCTION__," > class: ",el.ClassName(),"; id: ",el.Id());
    }
  }
}
//+------------------------------------------------------------------+
//| Формирует массив элементов с авто-ресайзом (X)                   |
//+------------------------------------------------------------------+
void CWndEvents::FormAutoXResizeElementsArray(void) {
  int windows_total = CWndContainer::WindowsTotal();
  for(int w = 0; w < windows_total; w++) {
    int elements_total = CWndContainer::ElementsTotal(w);
    for(int e = 0; e < elements_total; e++) {
      CElement *el = m_wnd[w].m_elements[e];
      //--- Добавляем только те, у которых включен режим авто-ресайза
      if(!el.AutoXResizeMode())
        continue;
      //---
      if(dynamic_cast<CButton        *>(el) != NULL ||
          dynamic_cast<CFileNavigator *>(el) != NULL ||
          dynamic_cast<CGraph         *>(el) != NULL ||
          dynamic_cast<CListView      *>(el) != NULL ||
          dynamic_cast<CMenuBar       *>(el) != NULL ||
          dynamic_cast<CProgressBar   *>(el) != NULL ||
          dynamic_cast<CStandardChart *>(el) != NULL ||
          dynamic_cast<CStatusBar     *>(el) != NULL ||
          dynamic_cast<CTable         *>(el) != NULL ||
          dynamic_cast<CTabs          *>(el) != NULL ||
          dynamic_cast<CTextBox       *>(el) != NULL ||
          dynamic_cast<CTextEdit      *>(el) != NULL ||
          dynamic_cast<CTreeView      *>(el) != NULL ||
          dynamic_cast<CFrame         *>(el) != NULL) {
        CWndContainer::AddAutoXResizeElement(w, el);
      }
    }
  }
}
//+------------------------------------------------------------------+
//| Формирует массив элементов с авто-ресайзом (Y)                   |
//+------------------------------------------------------------------+
void CWndEvents::FormAutoYResizeElementsArray(void) {
  int windows_total = CWndContainer::WindowsTotal();
  for(int w = 0; w < windows_total; w++) {
    int elements_total = CWndContainer::ElementsTotal(w);
    for(int e = 0; e < elements_total; e++) {
      CElement *el = m_wnd[w].m_elements[e];
      //--- Добавляем только те, у которых включен режим авто-ресайза
      if(!el.AutoYResizeMode())
        continue;
      //---
      if (dynamic_cast<CGraph         *>(el) != NULL ||
          dynamic_cast<CListView      *>(el) != NULL ||
          dynamic_cast<CStandardChart *>(el) != NULL ||
          dynamic_cast<CTable         *>(el) != NULL ||
          dynamic_cast<CTabs          *>(el) != NULL ||
          dynamic_cast<CTextBox       *>(el) != NULL ||
          dynamic_cast<CFrame         *>(el) != NULL) {
        CWndContainer::AddAutoYResizeElement(w, el);
      }
    }
  }
}
//+------------------------------------------------------------------+
//| Устанавливает состояние графика                                  |
//+------------------------------------------------------------------+
void CWndEvents::SetChartState(void) {
  int awi = m_active_window_index;
//--- Для определения события, когда нужно отключить управление
  bool condition = false;
//--- Проверим окна
  int windows_total = CWndContainer::WindowsTotal();
  for(int i = 0; i < windows_total; i++) {
    //--- Перейти к следующей, если эта форма скрыта
    if(!m_windows[i].IsVisible())
      continue;
    //--- Проверить условия во внутреннем обработчике формы
    m_windows[i].OnEvent(m_id, m_lparam, m_dparam, m_sparam);
    //--- Если есть фокус, отметим это
    if(m_windows[i].MouseFocus())
      condition = true;
  }
  
//--- Проверим фокус выпадающих списков
  if(!condition) {
    //--- Получим общее количество выпадающих списков
    int drop_lists_total = CWndContainer::ElementsTotal(awi, E_DROP_LIST);
    for(int i = 0; i < drop_lists_total; i++) {
      //--- Получим указатель на выпадающий список
      CListView *lv = m_wnd[awi].m_drop_lists[i];
      //--- Если список активирован (открыт)
      if(lv.IsVisible()) {
        //--- Проверим фокус над списком и состояние его полосы прокрутки
        if(m_wnd[awi].m_drop_lists[i].MouseFocus() || lv.ScrollState()) {
          condition = true;
          break;
        }
      }
    }
  }
//--- Проверим фокус выпадающих календарей
  if(!condition) {
    int drop_calendars_total = CWndContainer::ElementsTotal(awi, E_DROP_CALENDAR);
    for(int i = 0; i < drop_calendars_total; i++) {
      if(m_wnd[awi].m_drop_calendars[i].GetCalendarPointer().MouseFocus()) {
        condition = true;
        break;
      }
    }
  }
//--- Проверим фокус контекстных меню
  if(!condition) {
    //--- Получим общее количество выпадающих контекстных меню
    int context_menus_total = CWndContainer::ElementsTotal(awi, E_CONTEXT_MENU);
    for(int i = 0; i < context_menus_total; i++) {
      //--- Если фокус над контексным меню
      if(m_wnd[awi].m_context_menus[i].MouseFocus()) {
        condition = true;
        break;
      }
    }
  }
//--- Проверим состояние полос прокрутки
  if(!condition) {
    int scrolls_total = CWndContainer::ElementsTotal(awi, E_SCROLL);
    for(int i = 0; i < scrolls_total; i++) {
      if(((CScroll*)m_wnd[awi].m_scrolls[i]).State()) {
        condition = true;
        break;
      }
    }
  }
  
//--- Устанавливаем состояние графика во всех формах
  for(int i = 0; i < windows_total; i++)
    m_windows[i].CustomEventChartState(condition);
}
//+------------------------------------------------------------------+
