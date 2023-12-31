//+------------------------------------------------------------------+
//|                                                       Window.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\ElementBase.mqh"
#include "Button.mqh"
#include "Pointer.mqh"
//+------------------------------------------------------------------+
//| Класс формы для элементов управления                             |
//+------------------------------------------------------------------+
class CWindow : public CElement
  {
private:
   //--- Объекты для создания формы
   CButton           m_button_close;
   CButton           m_button_fullscreen;
   CButton           m_button_collapse;
   CButton           m_button_tooltip;
   CPointer          m_xy_resize;
   //--- Индекс предыдущего активного окна
   int               m_prev_active_window_index;
   //--- Возможность перемещать окно на графике
   bool              m_is_movable;
   //--- Статус свёрнутого окна
   bool              m_is_minimized;
   //--- Статус окна в полноэкранном режиме
   bool              m_is_fullscreen;
   //--- Последние координаты и размеры окна перед переводом в полноэкранный размер
   int               m_last_x;
   int               m_last_y;
   int               m_last_x_size;
   int               m_last_y_size;
   bool              m_last_auto_xresize;
   bool              m_last_auto_yresize;
   //--- Минимальные размеры окна
   int               m_minimum_x_size;
   int               m_minimum_y_size;
   //--- Тип окна
   ENUM_WINDOW_TYPE  m_window_type;
   //--- Режим фиксированной высоты подокна (для индикаторов)
   bool              m_height_subwindow_mode;
   //--- Режим сворачивания формы в подокне индикатора
   bool              m_rollup_subwindow_mode;
   //--- Высота подокна индикатора
   int               m_subwindow_height;
   //--- Полная высота формы
   int               m_full_height;
   //--- Высота заголовка
   int               m_caption_height;
   //--- Цвета заголовка
   color             m_caption_color;
   color             m_caption_color_hover;
   color             m_caption_color_locked;
   //--- Включает прозрачность только у заголовка
   bool              m_transparent_only_caption;
   //--- Наличие кнопки для (1) закрытия, (2) разворачивания в полноэкранный режим, (3) свёртывания окна
   bool              m_close_button;
   bool              m_fullscreen_button;
   bool              m_collapse_button;
   //--- Наличие кнопки для режима показа всплывающих подсказок
   bool              m_tooltips_button;
   bool              m_tooltips_button_state;
   //--- Размеры графика
   int               m_chart_width;
   int               m_chart_height;
   //--- Для определения границ области захвата в заголовке окна
   int               m_right_limit;
   //--- Переменные связанные с перемещением окна
   int               m_prev_x;
   int               m_prev_y;
   int               m_size_fixing_x;
   int               m_size_fixing_y;
   //--- Состояние кнопки мыши с учётом, где она была нажата
   ENUM_MOUSE_STATE  m_clamping_area_mouse;
   //--- Режим изменения размеров окна
   bool              m_xy_resize_mode;
   //--- Индекс границы для изменения размеров окна
   int               m_resize_mode_index;
   //--- Переменные связанные с изменением размеров окна
   int               m_x_fixed;
   int               m_size_fixed;
   int               m_point_fixed;
   //--- Для управления состоянием графика
   bool              m_custom_event_chart_state;
   //---
public:
                     CWindow(void);
                    ~CWindow(void);
   //--- Методы для создания окна
   bool              CreateWindow(const long chart_id,const int window,const string caption_text,const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const long chart_id,const int subwin,const string caption_text,const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   bool              CreateButtons(void);
   bool              CreateResizePointer(void);
   //---
public:
   //--- Возвращает указатели
   CButton          *GetCloseButtonPointer(void)                     { return(::GetPointer(m_button_close));      }
   CButton          *GetFullscreenButtonPointer(void)                { return(::GetPointer(m_button_fullscreen)); }
   CButton          *GetCollapseButtonPointer(void)                  { return(::GetPointer(m_button_collapse));   }
   CButton          *GetTooltipButtonPointer(void)                   { return(::GetPointer(m_button_tooltip));    }
   CPointer         *GetResizePointer(void)                          { return(::GetPointer(m_xy_resize));         }
   //--- (1) Получение и сохранение индекса предыдущего активного окна 
   int               PrevActiveWindowIndex(void)               const { return(m_prev_active_window_index);        }
   void              PrevActiveWindowIndex(const int index)          { m_prev_active_window_index=index;          }
   //--- (1) Тип окна, (2) ограничение области захвата заголовка
   ENUM_WINDOW_TYPE  WindowType(void)                          const { return(m_window_type);                     }
   void              WindowType(const ENUM_WINDOW_TYPE flag)         { m_window_type=flag;                        }
   void              RightLimit(const int value)                     { m_right_limit=value;                       }
   //--- Высота заголовка
   void              CaptionHeight(const int height)                 { m_caption_height=height;                   }
   int               CaptionHeight(void)                       const { return(m_caption_height);                  }
   //--- (1) Цвета заголовка, (2) включает режим прозрачности только у заголовка окна
   void              CaptionColor(const color clr)                   { m_caption_color=clr;                       }
   color             CaptionColor(void)                        const { return(m_caption_color);                   }
   void              CaptionColorHover(const color clr)              { m_caption_color_hover=clr;                 }
   color             CaptionColorHover(void)                   const { return(m_caption_color_hover);             }
   void              CaptionColorLocked(const color clr)             { m_caption_color_locked=clr;                }
   color             CaptionColorLocked(void)                  const { return(m_caption_color_locked);            }
   void              TransparentOnlyCaption(const bool state)        { m_transparent_only_caption=state;          }
   //--- (1) Использовать кнопку для закрытия окна, (2) использовать кнопку полноэкранного режима,
   //    (3) использовать кнопку для сворачивания/разворачивания окна, (4) использовать кнопку подсказок
   void              CloseButtonIsUsed(const bool state)             { m_close_button=state;                      }
   bool              CloseButtonIsUsed(void)                   const { return(m_close_button);                    }
   void              FullscreenButtonIsUsed(const bool state)        { m_fullscreen_button=state;                 }
   bool              FullscreenButtonIsUsed(void)              const { return(m_fullscreen_button);               }
   void              CollapseButtonIsUsed(const bool state)          { m_collapse_button=state;                   }
   bool              CollapseButtonIsUsed(void)                const { return(m_collapse_button);                 }
   void              TooltipsButtonIsUsed(const bool state)          { m_tooltips_button=state;                   }
   bool              TooltipsButtonIsUsed(void)                const { return(m_tooltips_button);                 }
   //--- (1) Проверка режима показа всплывающих подсказок
   void              TooltipButtonState(const bool state)            { m_tooltips_button_state=state;             }
   bool              TooltipButtonState(void)                  const { return(m_tooltips_button_state);           }
   //--- Возможность перемещения окна
   bool              IsMovable(void)                           const { return(m_is_movable);                      }
   void              IsMovable(const bool state)                     { m_is_movable=state;                        }
   //--- (1) Статус свёрнутого окна, (2) возвращает область, где была зажата левая кнопка мыши
   bool              IsMinimized(void)                         const { return(m_is_minimized);                    }
   void              IsMinimized(const bool state)                   { m_is_minimized=state;                      }
   ENUM_MOUSE_STATE  ClampingAreaMouse(void)                   const { return(m_clamping_area_mouse);             }
   //--- Установка минимальных размеров окна
   void              MinimumXSize(const int x_size)                  { m_minimum_x_size=x_size;                   }
   void              MinimumYSize(const int y_size)                  { m_minimum_y_size=y_size;                   }
   //--- Возможность изменения размеров окна
   bool              ResizeMode(void)                          const { return(m_xy_resize_mode);                  }
   void              ResizeMode(const bool state)                    { m_xy_resize_mode=state;                    }
   //--- Статус процесса изменения размеров окна
   bool              ResizeState(void) const { return(m_resize_mode_index!=WRONG_VALUE && m_mouse.LeftButtonState()); }

   //--- Ярлык по умолчанию
   uint              DefaultIcon(void);
   //--- Установка состояния окна
   void              State(const bool flag);
   //--- Режим сворачивания подокна индикатора
   void              RollUpSubwindowMode(const bool flag,const bool height_mode);
   //--- Управление размерами
   void              ChangeWindowWidth(const int width);
   void              ChangeWindowHeight(const int height);
   //--- Изменяет высоту подокна индикатора
   void              ChangeSubwindowHeight(const int height);

   //--- Получение размеров графика
   void              SetWindowProperties(void);
   //--- Проверка курсора в области заголовка 
   bool              CursorInsideCaption(const int x,const int y);
   //--- Обнуление переменных
   void              ZeroMoveVariables(void);
   void              ZeroResizeVariables(void);

   //--- Проверка состояния левой кнопки мыши
   void              CheckMouseButtonState(void);
   //--- Установка режима графика
   void              SetChartState(void);
   //--- Обновление координат формы
   void              UpdateWindowXY(const int x,const int y);
   //--- Пользовательский флаг управления свойствами графика
   void              CustomEventChartState(const bool state) { m_custom_event_chart_state=state; }

   //--- Открытие окна
   void              OpenWindow(void);
   //--- Закрытие главного окна
   void              CloseWindow(void);
   //--- Закрытие диалогового окна
   void              CloseDialogBox(void);
   //--- Изменение состояния окна
   void              ChangeWindowState(void);
   //---
public:
   //--- Обработчик событий графика
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Перемещение элемента
   virtual void      Moving(const int x,const int y);
   //--- Показ, скрытие, сброс, удаление
   virtual void      Show(void);
   virtual void      Reset(void);
   virtual void      Delete(void);
   //--- Рисует элемент
   virtual void      Draw(void);
   //---
public:
   //--- Обработка нажатия на кнопке "Закрыть окно"
   bool              OnClickCloseButton(const int id=WRONG_VALUE,const int index=WRONG_VALUE);
   //--- В полноэкранный размер или в предыдущий размер окна
   bool              OnClickFullScreenButton(const int id=WRONG_VALUE,const int index=WRONG_VALUE);
   //--- Обработка нажатия на кнопке "Свернуть окно"
   bool              OnClickCollapseButton(const int id=WRONG_VALUE,const int index=WRONG_VALUE);
   //--- Обработка нажатия на кнопке "Всплывающие подсказки"
   bool              OnClickTooltipsButton(const uint id,const uint index);
   
private:
   //--- Методы для (1) сворачивания и (2) разворачивания окна
   void              Collapse(void);
   void              Expand(void);

   //--- Управляет размерами окна
   void              ResizeWindow(void);
   //--- Проверка готовности для изменения размеров окна
   bool              CheckResizePointer(const int x,const int y);
   //--- Возвращает индекс режима для изменения размеров окна
   int               ResizeModeIndex(const int x,const int y);
   //--- Обновление размеров окна
   void              UpdateSize(const int x,const int y);
   //--- Проверка перетаскивания границы окна
   int               CheckDragWindowBorder(const int x,const int y);
   //--- Расчёт и изменение размеров окна
   void              CalculateAndResizeWindow(const int distance);

   //--- Рисует задний фон
   virtual void      DrawBackground(void);
   //--- Рисует передний фон
   virtual void      DrawForeground(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CWindow::CWindow(void) : m_right_limit(0),
                         m_caption_height(20),
                         m_caption_color(C'77,118,201'),
                         m_caption_color_hover(C'77,118,201'),
                         m_caption_color_locked(C'188,165,219'),
                         m_transparent_only_caption(true),
                         m_prev_active_window_index(0),
                         m_subwindow_height(0),
                         m_rollup_subwindow_mode(false),
                         m_height_subwindow_mode(false),
                         m_is_movable(false),
                         m_x_fixed(0),
                         m_size_fixed(0),
                         m_point_fixed(0),
                         m_xy_resize_mode(false),
                         m_resize_mode_index(WRONG_VALUE),
                         m_is_minimized(false),
                         m_is_fullscreen(false),
                         m_last_x(0),
                         m_last_y(0),
                         m_last_x_size(0),
                         m_last_y_size(0),
                         m_minimum_x_size(0),
                         m_minimum_y_size(0),
                         m_last_auto_xresize(false),
                         m_last_auto_yresize(false),
                         m_close_button(true),
                         m_fullscreen_button(false),
                         m_collapse_button(false),
                         m_tooltips_button(false),
                         m_tooltips_button_state(false),
                         m_window_type(W_MAIN),
                         m_clamping_area_mouse(NOT_PRESSED)
  {
//--- Сохраним имя класса элемента в базовом классе
   CElementBase::ClassName(CLASS_NAME);
//--- Получим размеры окна графика
   SetWindowProperties();
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CWindow::~CWindow(void)
  {
  }
//+------------------------------------------------------------------+
//| Обработчик событий графика                                       |
//+------------------------------------------------------------------+
void CWindow::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Обработка события перемещения курсора
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Выйти, если форма находится в другом подокне графика
      if(!CElementBase::CheckSubwindowNumber())
        {
         //--- Если прокрутка графика отключена
         if(!m_chart.GetInteger(CHART_MOUSE_SCROLL))
           {
            //--- Обнуление
            ZeroMoveVariables();
            CElementBase::MouseFocus(false);
            //--- Установим состояние графика
            m_chart.MouseScroll(true);
            m_chart.SetInteger(CHART_DRAG_TRADE_LEVELS,true);
           }
         //---
         return;
        }
      //--- Проверка фокуса мыши
      CElementBase::CheckMouseFocus();
      //--- Проверим и запомним состояние кнопки мыши
      CheckMouseButtonState();
      //--- Установим состояние графика
      SetChartState();
      //--- Выйти, если эта форма заблокирована
      if(CElementBase::IsLocked())
         return;
      //--- Перерисовать элемент, если (1) было пересечение границ и (2) цвета состояний различаются
      if(CElementBase::CheckCrossingBorder())
        {
         if(m_caption_color!=m_caption_color_hover)
            Update(true);
        }
      //--- Если управление передано окну
      if(m_clamping_area_mouse==PRESSED_INSIDE_HEADER)
        {
         //--- Выйти, если номера подокон не совпадают
         if(CElementBase::m_subwin!=CElementBase::m_mouse.SubWindowNumber())
            return;
         //--- Обновление координат окна
         UpdateWindowXY(m_mouse.X(),m_mouse.Y());
         return;
        }
      //--- Изменение размеров окна
      ResizeWindow();
      return;
     }
//--- Обработка события нажатия на графике
   if(id==CHARTEVENT_CLICK)
     {
      //--- Получим размеры окна графика
      SetWindowProperties();
      return;
     }
//--- Обработка события двойного нажатия на объекте
   if(id==CHARTEVENT_CUSTOM+ON_DOUBLE_CLICK)
     {
      //--- Если событие генерировалось на заголовке окна
      if(CursorInsideCaption(m_mouse.X(),m_mouse.Y()))
        {
          OnClickFullScreenButton(m_button_fullscreen.Id(),m_button_fullscreen.Index());
        }
      //---
      return;
     }
//--- Обработка события нажатия на кнопках формы
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)
     {
      //--- Закрыть окно
      if(OnClickCloseButton((uint)lparam,(uint)dparam))
         return;
      //--- Проверка полноэкранного режима
      if(OnClickFullScreenButton((uint)lparam,(uint)dparam))
         return;
      //--- Свернуть/Развернуть окно
      if(OnClickCollapseButton((uint)lparam,(uint)dparam))
         return;
      //--- Если нажатие на кнопке "Всплывающие подсказки"
      if(OnClickTooltipsButton((uint)lparam,(uint)dparam))
         return;
      //---
      return;
     }
//--- Событие изменения свойств графика
   if(id==CHARTEVENT_CHART_CHANGE)
     {
      //--- Если кнопка отжата
      if(m_clamping_area_mouse==NOT_PRESSED)
        {
         //--- Получим размеры окна графика
         SetWindowProperties();
         //--- Корректировка координат
         UpdateWindowXY(m_x,m_y);
        }
      //--- Изменить ширину, если включен режим
      if(CElementBase::AutoXResizeMode())
         ChangeWindowWidth(m_chart.WidthInPixels()-2);
      //--- Изменить высоту, если включен режим
      if(CElementBase::AutoYResizeMode())
         ChangeWindowHeight(m_chart.HeightInPixels(m_subwin)-3);
      //---
      return;
     }
//--- Обработка события изменения высоты подокна эксперта
   if(id==CHARTEVENT_CUSTOM+ON_SUBWINDOW_CHANGE_HEIGHT)
     {
      //--- Выйти, если (1) это сообщение было от эксперта или (2) это не эксперт
      if(sparam==PROGRAM_NAME || CElementBase::ProgramType()!=PROGRAM_EXPERT)
         return;
      //--- Выйти, если не установлен режим фиксированной высоты подокна
      if(!m_height_subwindow_mode)
         return;
      //--- Рассчитать и изменить высоту подокна
      m_subwindow_height=(m_is_minimized)? m_caption_height+3 : m_full_height+3;
      ChangeSubwindowHeight(m_subwindow_height);
      return;
     }
  }
//+------------------------------------------------------------------+
//| Создаёт форму для элементов управления                           |
//+------------------------------------------------------------------+
bool CWindow::CreateWindow(const long chart_id,const int subwin,const string caption_text,const int x,const int y)
  {
//--- Выйти, если идентификатор не определён
   if(CElementBase::Id()==WRONG_VALUE)
     {
      ::Print(__FUNCTION__," > Перед созданием окна его указатель нужно сохранить в базе: CWndContainer::AddWindow(CWindow &object)");
      return(false);
     }
//--- Сохраним указатели на себя
   CElement::WindowPointer(this);
   CElement::MainPointer(this);
//--- Сохраним свойства окна графика
   SetWindowProperties();
//--- Инициализация свойств
   InitializeProperties(chart_id,subwin,caption_text,x,y);
//--- Создание всех объектов окна
   if(!CreateCanvas())
      return(false);
   if(!CreateButtons())
      return(false);
   if(!CreateResizePointer())
      return(false);
//--- Значение последнего устрановленного идентификатора
   CElementBase::LastId(CElementBase::Id());
//--- Если эта программа индикатор
   if(CElementBase::ProgramType()==PROGRAM_INDICATOR)
     {
      //--- Если установлен режим фиксированной высоты подокна
      if(m_height_subwindow_mode)
        {
         m_subwindow_height=m_full_height+3;
         ChangeSubwindowHeight(m_subwindow_height);
        }
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Инициализация свойств                                            |
//+------------------------------------------------------------------+
void CWindow::InitializeProperties(const long chart_id,const int subwin,const string caption_text,const int x_gap,const int y_gap)
  {
   m_chart_id   =chart_id;
   m_subwin     =subwin;
   m_label_text =caption_text;
//--- Координты и размеры
   m_x              =x_gap;
   m_y              =y_gap;
   m_x_size         =(m_auto_xresize_mode)? m_chart_width-2 : m_x_size;
   m_y_size         =(m_auto_yresize_mode)? m_chart_height-3 : m_y_size;
   m_x_size         =(m_x_size<1)? 200 : m_x_size;
   m_y_size         =(m_y_size<1)? 200 : m_y_size;
   m_full_height    =m_y_size;
   m_last_x_size    =m_x_size;
   m_last_y_size    =m_y_size;
   m_minimum_x_size =(m_minimum_x_size<200)? m_x_size : m_minimum_x_size;
   m_minimum_y_size =(m_minimum_y_size<200)? m_y_size : m_minimum_y_size;
//--- Свойства по умолчанию
   m_back_color         =(m_back_color!=clrNONE)? m_back_color : clrWhiteSmoke;
   m_icon_x_gap         =(m_icon_x_gap!=WRONG_VALUE)? m_icon_x_gap : 5;
   m_icon_y_gap         =(m_icon_y_gap!=WRONG_VALUE)? m_icon_y_gap : 2;
   m_label_x_gap        =(m_label_x_gap!=WRONG_VALUE)? m_label_x_gap : 24;
   m_label_y_gap        =(m_label_y_gap!=WRONG_VALUE)? m_label_y_gap : 3;
   m_label_color        =(m_label_color!=clrNONE)? m_label_color : clrWhite;
   m_label_color_hover  =(m_label_color_hover!=clrNONE)? m_label_color_hover : clrWhite;
   m_label_color_locked =(m_label_color_locked!=clrNONE)? m_label_color_locked : clrBlack;
//--- Отступы от крайней точки
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
  }
//+------------------------------------------------------------------+
//| Создаёт объект для рисования                                     |
//+------------------------------------------------------------------+
bool CWindow::CreateCanvas(void)
  {
//--- Формирование имени объекта
   string name=CElementBase::ElementName("window");
//--- Размер главного окна зависит от состояния (свёрнуто/развёрнуто)
   if(m_window_type==W_MAIN)
      m_y_size=(m_is_minimized)? m_caption_height : m_full_height;
//--- Создание объекта
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//--- Установим свойства
   if(CElement::IconFile() == "")
     {
      CElement::IconFile((uint)DefaultIcon());
      CElement::IconFileLocked((uint)DefaultIcon());
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт кнопки на форме                                          |
//+------------------------------------------------------------------+
bool CWindow::CreateButtons(void)
  {
//--- Если тип программы "скрипт", выйдем
   if(CElementBase::ProgramType()==PROGRAM_SCRIPT)
      return(true);
//--- Счётчик, размер, количество
   int i=0,x_size=20;
   int buttons_total=4;
//--- Путь к файлу
   uint icon_index=INT_MAX;
//--- Исключение в области захвата
   m_right_limit=0;
//---
   CButton *button_obj=NULL;
//---
   for(int b=0; b<buttons_total; b++)
     {
      //---
      if(b==0)
        {
         CElementBase::LastId(LastId()-1);
         m_button_close.MainPointer(this);
         if(!m_close_button)
            continue;
         //---
         button_obj =::GetPointer(m_button_close);
         icon_index =RESOURCE_CLOSE_WHITE;
        }
      else if(b==1)
        {
         m_button_fullscreen.MainPointer(this);
         //--- Выйти, если (1) кнопка не включена или (2) это диалоговое окно
         if(!m_fullscreen_button || m_window_type==W_DIALOG)
            continue;
         //---
         button_obj =::GetPointer(m_button_fullscreen);
         icon_index =RESOURCE_FULL_SCREEN;
        }
      else if(b==2)
        {
         m_button_collapse.MainPointer(this);
         //--- Выйти, если (1) кнопка не включена или (2) это диалоговое окно
         if(!m_collapse_button || m_window_type==W_DIALOG)
            continue;
         //---
         button_obj=::GetPointer(m_button_collapse);
         if(m_is_minimized)
            icon_index =RESOURCE_DOWN_THIN_WHITE;
         else
            icon_index =RESOURCE_UP_THIN_WHITE;
        }
      else if(b==3)
        {
         m_button_tooltip.MainPointer(this);
         //--- Выйти, если (1) кнопка не включена или (2) это диалоговое окно
         if(!m_tooltips_button || m_window_type==W_DIALOG)
            continue;
         //---
         button_obj =::GetPointer(m_button_tooltip);
         icon_index =RESOURCE_HELP;
        }
      //--- Свойства
      button_obj.Index(i);
      button_obj.XSize(x_size);
      button_obj.YSize(x_size);
      button_obj.IconXGap(2);
      button_obj.IconYGap(2);
      button_obj.BackColor(m_caption_color);
      button_obj.BackColorHover((b<1)? C'242,27,45' : C'90,139,232');
      button_obj.BackColorPressed((b<1)? C'149,68,116' : C'67,103,173');
      button_obj.BackColorLocked(m_caption_color_locked);
      button_obj.BorderColor(m_caption_color);
      button_obj.BorderColorHover(m_caption_color);
      button_obj.BorderColorLocked(m_caption_color_locked);
      button_obj.BorderColorPressed(m_caption_color);
      button_obj.IconFile((uint)icon_index);
      button_obj.IconFileLocked((uint)icon_index);
      if(b==3)
        {
         button_obj.TwoState(true);
         button_obj.CElement::IconFilePressed((uint)icon_index);
         button_obj.CElement::IconFilePressedLocked((uint)icon_index);
        }
      button_obj.AnchorRightWindowSide(true);
      //--- Расчёт отступа для следующей кнопки
      m_right_limit+=x_size-((i<3)? 0 : 1);
      i++;
      //--- Создадим элемент
      if(!button_obj.CreateButton("",m_right_limit,0))
         return(false);
      //--- Добавить элемент в массив
      CElement::AddToArray(button_obj);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт указатель курсора изменения размеров                     |
//+------------------------------------------------------------------+
bool CWindow::CreateResizePointer(void)
  {
//--- Выйти, если режим изменения размеров выключен
   if(!m_xy_resize_mode)
      return(true);
//--- Свойства
   m_xy_resize.XGap(13);
   m_xy_resize.YGap(11);
   m_xy_resize.XSize(23);
   m_xy_resize.YSize(23);
   m_xy_resize.Id(CElementBase::Id());
   m_xy_resize.Type(MP_WINDOW_RESIZE);
//--- Создание элемента
   if(!m_xy_resize.CreatePointer(m_chart_id,m_subwin))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Определение ярлыка по умолчанию                                  |
//+------------------------------------------------------------------+
uint CWindow::DefaultIcon(void)
  {
   uint resource_index =RESOURCE_ADVISOR;
   
   switch(CElementBase::ProgramType()) {
    case PROGRAM_SCRIPT: {
       resource_index =RESOURCE_SCRIPT;
       break;
      }
    case PROGRAM_EXPERT: {
       resource_index =RESOURCE_ADVISOR;
       break;
      }
    case PROGRAM_INDICATOR: {
       resource_index =RESOURCE_INDICATOR;
       break;
      }
   }
   return(resource_index);
  }
//+------------------------------------------------------------------+
//| Режим сворачивания подокна индикатора                            |
//+------------------------------------------------------------------+
void CWindow::RollUpSubwindowMode(const bool rollup_mode=false,const bool height_mode=false)
  {
//--- Выйти, если это скрипт
   if(CElementBase::m_program_type==PROGRAM_SCRIPT)
      return;
//---
   m_rollup_subwindow_mode =rollup_mode;
   m_height_subwindow_mode =height_mode;
//---
   if(m_height_subwindow_mode)
      ChangeSubwindowHeight(m_subwindow_height);
  }
//+------------------------------------------------------------------+
//| Изменяет высоту подокна индикатора                               |
//+------------------------------------------------------------------+
void CWindow::ChangeSubwindowHeight(const int height)
  {
//--- Если графический интерфейс (1) не в подокне или (2) программа типа "Скрипт"
   if(CElementBase::m_subwin<=0 || CElementBase::m_program_type==PROGRAM_SCRIPT)
      return;
//--- Если нужно изменить высоту подокна
   if(height>0)
     {
      //--- Если программа типа "Индикатор"
      if(CElementBase::m_program_type==PROGRAM_INDICATOR)
        {
         if(!::IndicatorSetInteger(INDICATOR_HEIGHT,height))
            ::Print(__FUNCTION__," > Не удалось изменить высоту подокна индикатора! Номер ошибки: ",::GetLastError());
        }
      //--- Если программа типа "Эксперт"
      else
        {
         //--- Отправить сообщение индикатору SubWindow.ex5 о том, что размеры окна нужно изменить
         ::EventChartCustom(m_chart_id,ON_SUBWINDOW_CHANGE_HEIGHT,(long)height,0,PROGRAM_NAME);
        }
     }
  }
//+------------------------------------------------------------------+
//| Изменяет ширину окна                                             |
//+------------------------------------------------------------------+
void CWindow::ChangeWindowWidth(const int width)
  {
//--- Если ширина не изменилась, выйдем
   if(width==m_canvas.XSize())
      return;
//--- Обновим ширину для фона и заголовка
   CElementBase::XSize(width);
   m_canvas.XSize(width);
   m_canvas.Resize(width,m_y_size);
//--- Перерисовать окно
   Draw();
//--- Сообщение о том, что размеры окна были изменены
   ::EventChartCustom(m_chart_id,ON_WINDOW_CHANGE_XSIZE,(long)CElementBase::Id(),0,"");
  }
//+------------------------------------------------------------------+
//| Изменяет высоту окна                                             |
//+------------------------------------------------------------------+
void CWindow::ChangeWindowHeight(const int height)
  {
//--- Если высота не изменилась, выйдем
   if(height==m_canvas.YSize())
      return;
//--- Выйти, если окно свёрнуто
   if(m_is_minimized)
      return;
//--- Обновим высоту для фона
   CElementBase::YSize(height);
   m_canvas.YSize(height);
   m_canvas.Resize(m_x_size,height);
   m_full_height=m_last_y_size;
//--- Перерисовать окно
   Draw();
//--- Сообщение о том, что размеры окна были изменены
   ::EventChartCustom(m_chart_id,ON_WINDOW_CHANGE_YSIZE,(long)CElementBase::Id(),0,"");
  }
//+------------------------------------------------------------------+
//| Получение размеров графика                                       |
//+------------------------------------------------------------------+
void CWindow::SetWindowProperties(void)
  {
//--- Получим ширину и высоту окна графика
   m_chart_width  =m_chart.WidthInPixels();
   m_chart_height =m_chart.HeightInPixels(m_subwin);
  }
//+------------------------------------------------------------------+
//| Проверка положения курсора в области заголовка окна              |
//+------------------------------------------------------------------+
bool CWindow::CursorInsideCaption(const int x,const int y)
  {
   return(x>m_x && x<X2()-m_right_limit && y>m_y && y<m_y+m_caption_height);
  }
//+------------------------------------------------------------------+
//| Обнуление переменных связанных с перемещением окна и             |
//| состоянием левой кнопки мыши                                     |
//+------------------------------------------------------------------+
void CWindow::ZeroMoveVariables(void)
  {
//--- Выйти, если обнуление уже было
   if(m_clamping_area_mouse==NOT_PRESSED)
      return;
//--- Отправляем сообщение на восстановление только, если был захват в области заголовка
   if(m_clamping_area_mouse==PRESSED_INSIDE_HEADER)
     {
      //--- Отправим сообщение на восстановление доступных элементов
      ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),1,"");
      //--- Отправим сообщение об изменении в графическом интерфейсе
      ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
      //--- Отправим сообщение о завершении перетаскивания формы
      ::EventChartCustom(m_chart_id,ON_WINDOW_DRAG_END,CElementBase::Id(),0,"");
     }
//--- Обнулить
   m_prev_x              =0;
   m_prev_y              =0;
   m_size_fixing_x       =0;
   m_size_fixing_y       =0;
   m_clamping_area_mouse =NOT_PRESSED;
  }
//+------------------------------------------------------------------+
//| Обнуление переменных связанных с изменением размеров окна        |
//+------------------------------------------------------------------+
void CWindow::ZeroResizeVariables(void)
  {
//--- Выйти, если обнуление уже было
   if(m_point_fixed<1)
      return;
//--- Обнулить
   m_x_fixed     =0;
   m_size_fixed  =0;
   m_point_fixed =0;
//--- Отправим сообщение на восстановление доступных элементов
   ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),1,"");
//--- Отправим сообщение об изменении в графическом интерфейсе
   ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
  }
//+------------------------------------------------------------------+
//| Проверяет состояние кнопки мыши                                  |
//+------------------------------------------------------------------+
void CWindow::CheckMouseButtonState(void)
  {
//--- Если кнопка отжата
   if(!m_mouse.LeftButtonState())
     {
      //--- Обнулим переменные
      ZeroMoveVariables();
      return;
     }
//--- Если кнопка нажата
   else
     {
      //--- Выйдем, если состояние уже зафиксировано
      if(m_clamping_area_mouse!=NOT_PRESSED)
         return;
      //--- Вне области формы
      if(!CElementBase::MouseFocus())
         m_clamping_area_mouse=PRESSED_OUTSIDE;
      //--- В области формы
      else
        {
         //--- Выйти, если форма находится в другом подокне графика
         if(!CElementBase::CheckSubwindowNumber())
            return;
         //--- Если внутри заголовка
         if(CursorInsideCaption(m_mouse.X(),m_mouse.Y()))
           {
            m_clamping_area_mouse=PRESSED_INSIDE_HEADER;
            //--- Отправим сообщение на определение доступных элементов
            ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),0,"");
            //--- Отправим сообщение об изменении в графическом интерфейсе
            ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
            return;
           }
         //--- Если в области формы
         else
            m_clamping_area_mouse=PRESSED_INSIDE;
        }
     }
  }
//+------------------------------------------------------------------+
//| Установим состояние графика                                      |
//+------------------------------------------------------------------+
void CWindow::SetChartState(void)
  {
//--- Если (курсор в области панели и кнопка мыши отжата) или
//    кнопка мыши была нажата внутри области формы или заголовка
   if((CElementBase::MouseFocus() && m_clamping_area_mouse==NOT_PRESSED) || 
      m_clamping_area_mouse==PRESSED_INSIDE_HEADER ||
      m_clamping_area_mouse==PRESSED_INSIDE_BORDER ||
      m_clamping_area_mouse==PRESSED_INSIDE ||
      m_custom_event_chart_state)
     {
      //--- Отключим скролл и управление торговыми уровнями, заберём управление колёсиком мыши
      m_chart.MouseScroll(false);
      m_chart.SetInteger(CHART_DRAG_TRADE_LEVELS,false);
      m_chart.SetInteger(CHART_EVENT_MOUSE_WHEEL,true);
     }
//--- Включим управление, если курсор вне зоны окна, оставим управление колёсиком мыши
   else
     {
      m_chart.MouseScroll(true);
      m_chart.SetInteger(CHART_DRAG_TRADE_LEVELS,true);
      m_chart.SetInteger(CHART_EVENT_MOUSE_WHEEL,false);
     }
  }
//+------------------------------------------------------------------+
//| Обновление координат окна                                        |
//+------------------------------------------------------------------+
void CWindow::UpdateWindowXY(const int x,const int y)
  {
//--- Выйти, если установлен режим фиксированной формы
   if(!m_is_movable)
      return;
//--- Для расчёта новых X- и Y-координат
   int new_x_point=0,new_y_point=0;
//--- Лимиты
   int limit_top=0,limit_left=0,limit_bottom=0,limit_right=0;
//--- Если кнопка мыши нажата
   if((bool)m_clamping_area_mouse)
     {
      //--- Запомним текущие координаты XY курсора
      if(m_prev_y==0 || m_prev_x==0)
        {
         m_prev_y=y;
         m_prev_x=x;
        }
      //--- Запомним расстояние от крайней точки формы до курсора
      if(m_size_fixing_y==0 || m_size_fixing_x==0)
        {
         m_size_fixing_y =m_y-m_prev_y;
         m_size_fixing_x =m_x-m_prev_x;
        }
     }
//--- Установим лимиты
   limit_top    =y-::fabs(m_size_fixing_y);
   limit_left   =x-::fabs(m_size_fixing_x);
   limit_bottom =m_y+m_caption_height;
   limit_right  =m_x+m_x_size;
//--- Если не выходим за пределы графика вниз/вверх/вправо/влево
   if(limit_bottom<m_chart_height && limit_top>=0 && 
      limit_right<m_chart_width && limit_left>=0)
     {
      new_y_point =y+m_size_fixing_y;
      new_x_point =x+m_size_fixing_x;
     }
//--- Если вышли из границ графика
   else
     {
      if(limit_bottom>m_chart_height) // > вниз
        {
         new_y_point =m_chart_height-m_caption_height;
         new_x_point =x+m_size_fixing_x;
        }
      else if(limit_top<0) // > вверх
        {
         new_y_point =0;
         new_x_point =x+m_size_fixing_x;
        }
      if(limit_right>m_chart_width) // > вправо
        {
         new_x_point =m_chart_width-m_x_size;
         new_y_point =y+m_size_fixing_y;
        }
      else if(limit_left<0) // > влево
        {
         new_x_point =0;
         new_y_point =y+m_size_fixing_y;
        }
     }
//--- Обновим координаты, если было перемещение
   if(new_x_point>0 || new_y_point>0)
     {
      //--- Скорректируем координаты формы
      m_x =(new_x_point<=0)? 1 : new_x_point;
      m_y =(new_y_point<=0)? 1 : new_y_point;
      //---
      if(new_x_point>0)
         m_x=(m_x>m_chart_width-m_x_size-1) ? m_chart_width-m_x_size-1 : m_x;
      if(new_y_point>0)
         m_y=(m_y>m_chart_height-m_caption_height-2) ? m_chart_height-m_caption_height-2 : m_y;
      //--- Обнулим точки фиксации
      m_prev_x=0;
      m_prev_y=0;
     }
  }
//+------------------------------------------------------------------+
//| Открытие окна                                                    |
//+------------------------------------------------------------------+
void CWindow::OpenWindow(void)
  {
//--- Показать элемент
   CWindow::Show();
//--- Отправить сообщение об этом
   ::EventChartCustom(m_chart_id,ON_OPEN_DIALOG_BOX,CElementBase::Id(),0,m_program_name);
  }
//+------------------------------------------------------------------+
//| Закрытие диалогового окна или программы                          |
//+------------------------------------------------------------------+
void CWindow::CloseWindow(void)
  {
   OnClickCloseButton();
  }
//+------------------------------------------------------------------+
//| Закрытие диалогового окна                                        |
//+------------------------------------------------------------------+
void CWindow::CloseDialogBox(void)
  {
//--- Отправить сообщение об этом
   ::EventChartCustom(m_chart_id,ON_CLOSE_DIALOG_BOX,CElementBase::Id(),m_prev_active_window_index,m_label_text);
  }
//+------------------------------------------------------------------+
//| Изменение состояния окна на противополжное (свернуть/развернуть) |
//+------------------------------------------------------------------+
void CWindow::ChangeWindowState(void)
  {
   OnClickCollapseButton();
  }
//+------------------------------------------------------------------+
//| Устанавливает состояние окна                                     |
//+------------------------------------------------------------------+
void CWindow::State(const bool flag)
  {
   int elements_total=CElement::ElementsTotal();
//--- Если нужно заблокировать окно
   if(!flag)
     {
      //--- Установим статус
      CElementBase::IsLocked(true);
      for(int i=0; i<elements_total; i++)
         m_elements[i].IsLocked(true);
     }
//--- Если нужно разблокировать окно
   else
     {
      //--- Установим статус
      CElementBase::IsLocked(false);
      for(int i=0; i<elements_total; i++)
         m_elements[i].IsLocked(false);
      //--- Сброс фокуса
      CElementBase::MouseFocus(false);
     }
//--- Перерисовать окно
   Update(true);
   for(int i=0; i<elements_total; i++)
      m_elements[i].Update(true);
  }
//+------------------------------------------------------------------+
//| Перемещение окна                                                 |
//+------------------------------------------------------------------+
void CWindow::Moving(const int x,const int y)
  {
//--- Сохранение координат в переменных
   m_canvas.X(x);
   m_canvas.Y(y);
//--- Обновление координат графических объектов
   ::ObjectSetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_XDISTANCE,x);
   ::ObjectSetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_YDISTANCE,y);
//--- Перемещение элементов
   int elements_total=CElement::ElementsTotal();
   for(int i=0; i<elements_total; i++)
      m_elements[i].Moving();
  }
//+------------------------------------------------------------------+
//| Показывает окно                                                  |
//+------------------------------------------------------------------+
void CWindow::Show(void)
  {
//--- Выйти, если элемент уже видим
   if(CElementBase::IsVisible())
      return;
//--- Состояние видимости
   CElementBase::IsVisible(true);
//--- Обновить положение объектов
   Moving(m_x,m_y);
//--- Показать объект
   ::ObjectSetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
//--- Показать элементы
   int elements_total=ElementsTotal();
   for(int i=0; i<elements_total; i++)
      m_elements[i].Show();
//--- Получим размеры окна графика
   SetWindowProperties();
  }
//+------------------------------------------------------------------+
//| Перерисовка всех объектов окна                                   |
//+------------------------------------------------------------------+
void CWindow::Reset(void)
  {
//--- Скрыть и показать объект
   ::ObjectSetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   ::ObjectSetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
//--- Состояние видимости
   CElementBase::IsVisible(true);
//--- Сброс фокуса
   CElementBase::MouseFocus(false);
  }
//+------------------------------------------------------------------+
//| Удаление                                                         |
//+------------------------------------------------------------------+
void CWindow::Delete(void)
  {
   CElement::Delete();
//--- Обнуление переменных
   m_right_limit       =0;
   m_is_fullscreen     =false;
   m_auto_xresize_mode =false;
   m_auto_yresize_mode =false;
  }
//+------------------------------------------------------------------+
//| Закрытие диалогового окна или программы                          |
//+------------------------------------------------------------------+
bool CWindow::OnClickCloseButton(const int id=WRONG_VALUE,const int index=WRONG_VALUE)
  {
//--- Проверить идентификатор и индекс элемента, если был внешний вызов
   uint check_id    =(id!=WRONG_VALUE)? id : CElementBase::Id();
   uint check_index =(index!=WRONG_VALUE)? index : CElementBase::Index();
//--- Выйти, если значения не совпадают
   if(check_id!=m_button_close.Id() || check_index!=m_button_close.Index())
      return(false);
//--- Если это главное окно
   if(m_window_type==W_MAIN)
     {
      //--- Если программа типа "Эксперт"
      if(CElementBase::ProgramType()==PROGRAM_EXPERT)
        {
         string text="You want to remove the program from the chart?";
         //--- Откроем диалоговое окно
         int mb_res=::MessageBox(text,NULL,MB_YESNO|MB_ICONQUESTION);
         //--- Если нажата кнопка "Да", то удалим программу с графика
         if(mb_res==IDYES)
           {
            ::Print(__FUNCTION__," > The program was removed from the chart with your consent!");
            //--- Удаление эксперта с графика
            ::ExpertRemove();
            return(true);
           }
         else
           {
            m_button_close.MouseFocus(false);
            m_button_close.Update(true);
           }
        }
      //--- Если программа типа "Индикатор"
      else if(CElementBase::ProgramType()==PROGRAM_INDICATOR)
        {
         //--- Удаление индикатора с графика
         if(::ChartIndicatorDelete(m_chart_id,::ChartWindowFind(),CElementBase::ProgramName()))
           {
            ::Print(__FUNCTION__," > The program was removed from the chart with your consent!");
            return(true);
           }
        }
     }
//--- Если это диалоговое окно, закроем его
   else if(m_window_type==W_DIALOG)
      CloseDialogBox();
//---
   return(false);
  }
//+------------------------------------------------------------------+
//| В полноэкранный размер или в предыдущий размер формы             |
//+------------------------------------------------------------------+
bool CWindow::OnClickFullScreenButton(const int id=WRONG_VALUE,const int index=WRONG_VALUE)
  {
//--- Проверить идентификатор и индекс элемента, если был внешний вызов
   int check_id    =(id!=WRONG_VALUE)? id : CElementBase::Id();
   int check_index =(index!=WRONG_VALUE)? index : CElementBase::Index();
//--- Выйти, если индексы не совпадают
   if(check_id!=m_button_fullscreen.Id() || check_index!=m_button_fullscreen.Index())
      return(false);
//--- Если окно не в полноэкранном размере
   if(!m_is_fullscreen)
     {
      //--- Перевести в полноэкранный размер
      m_is_fullscreen=true;
      //--- Получим текущие размеры окна графика
      SetWindowProperties();
      //--- Запомним текущие координаты и размеры формы
      m_last_x            =m_x;
      m_last_y            =m_y;
      m_last_x_size       =m_x_size;
      m_last_y_size       =m_full_height;
      m_last_auto_xresize =m_auto_xresize_mode;
      m_last_auto_yresize =m_auto_yresize_mode;
      //--- Включить автоизменение размеров формы
      m_auto_xresize_mode=true;
      m_auto_yresize_mode=true;
      //--- Развернуть форму на весь график
      ChangeWindowWidth(m_chart.WidthInPixels()-2);
      ChangeWindowHeight(m_chart.HeightInPixels(m_subwin)-3);
      //--- Обновить местоположение
      m_x=m_y=1;
      Moving(m_x,m_y);
      //--- Заменить изображение в кнопке
      m_button_fullscreen.IconFile((uint)RESOURCE_MINIMIZE_TO_WINDOW);
      m_button_fullscreen.IconFileLocked((uint)RESOURCE_MINIMIZE_TO_WINDOW);
     }
//--- Если окно в полноэкранном размере
   else
     {
      //--- Перевести в предыдущий размер окна
      m_is_fullscreen=false;
      //--- Отключить автоизменение размеров
      m_auto_xresize_mode=m_last_auto_xresize;
      m_auto_yresize_mode=m_last_auto_yresize;
      //--- Если режим отключен, то установить прежний размер
      if(!m_auto_xresize_mode)
         ChangeWindowWidth(m_last_x_size);
      if(!m_auto_yresize_mode)
         ChangeWindowHeight(m_last_y_size);
      //--- Обновить местоположение
      m_x=m_last_x;
      m_y=m_last_y;
      Moving(m_x,m_y);
      //--- Заменить изображение в кнопке
      m_button_fullscreen.IconFile((uint)RESOURCE_FULL_SCREEN);
      m_button_fullscreen.IconFileLocked((uint)RESOURCE_FULL_SCREEN);
     }
//--- Снять фокус с кнопки
   m_button_fullscreen.MouseFocus(false);
   m_button_fullscreen.Update(true);
   ChartRedraw();
   return(true);
  }
//+------------------------------------------------------------------+
//| Проверка на события сворачивания/разворачивания окна             |
//+------------------------------------------------------------------+
bool CWindow::OnClickCollapseButton(const int id=WRONG_VALUE,const int index=WRONG_VALUE)
  {
//--- Проверить идентификатор и индекс элемента, если был внешний вызов
   int check_id    =(id!=WRONG_VALUE)? id : CElementBase::Id();
   int check_index =(index!=WRONG_VALUE)? index : CElementBase::Index();
//--- Выйти, если индексы не совпадают
   if(check_id!=m_button_collapse.Id() || check_index!=m_button_collapse.Index())
      return(false);
//--- Если окно развёрнуто
   if(!m_is_minimized)
      Collapse();
   else
      Expand();
//--- Снять фокус с кнопки
   m_button_collapse.MouseFocus(false);
   m_button_collapse.Update(true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Сворачивает окно                                                 |
//+------------------------------------------------------------------+
void CWindow::Collapse(void)
  {
//--- Заменить кнопку
   m_button_collapse.IconFile((uint)RESOURCE_DOWN_THIN_WHITE);
   m_button_collapse.IconFileLocked((uint)RESOURCE_DOWN_THIN_WHITE);
//--- Установить и запомнить размер
   CElementBase::YSize(m_caption_height);
   m_canvas.YSize(m_caption_height);
   m_canvas.Resize(m_x_size,m_canvas.YSize());
//--- Состояние формы "Свёрнуто"
   m_is_minimized=true;
//--- Перерисовать окно
   Update(true);
//--- Рассчитаем высоту подокна
   m_subwindow_height=m_caption_height+3;
//--- Если эта программа в подокне с фиксированной высотой и с режимом сворачивания подокна,
//    установим размер для подокна программы
   if(m_height_subwindow_mode)
      if(m_rollup_subwindow_mode)
         ChangeSubwindowHeight(m_subwindow_height);
//--- Получим номер подокна программы
   int subwin=(CElementBase::ProgramType()==PROGRAM_INDICATOR)? ::ChartWindowFind() : m_subwin;
//--- Отправим сообщение об этом
   ::EventChartCustom(m_chart_id,ON_WINDOW_COLLAPSE,CElementBase::Id(),subwin,"");
//--- Отправим сообщение об изменении в графическом интерфейсе
   ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0.0,"");
  }
//+------------------------------------------------------------------+
//| Разворачивает окно                                               |
//+------------------------------------------------------------------+
void CWindow::Expand(void)
  {
//--- Заменить кнопку
   m_button_collapse.IconFile((uint)RESOURCE_UP_THIN_WHITE);
   m_button_collapse.IconFileLocked((uint)RESOURCE_UP_THIN_WHITE);
//--- Установить и запомнить размер
   CElementBase::YSize(m_full_height);
   m_canvas.YSize(m_full_height);
   m_canvas.Resize(m_x_size,m_canvas.YSize());
//--- Состояние формы "Развёрнуто"
   m_is_minimized=false;
//--- Перерисовать окно
   Update(true);
//--- Рассчитаем высоту подокна
   m_subwindow_height=m_full_height+3;
//--- Если это индикатор в подокне с фиксированной высотой и с режимом сворачивания подокна,
//    установим размер для подокна программы
   if(m_height_subwindow_mode)
      if(m_rollup_subwindow_mode)
         ChangeSubwindowHeight(m_subwindow_height);
//--- Получим номер подокна программы
   int subwin=(CElementBase::ProgramType()==PROGRAM_INDICATOR)? ::ChartWindowFind() : m_subwin;
//--- Отправим сообщение об этом
   ::EventChartCustom(m_chart_id,ON_WINDOW_EXPAND,CElementBase::Id(),subwin,"");
//--- Отправим сообщение об изменении в графическом интерфейсе
   ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0.0,"");
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на кнопке "Всплывающие подсказки"              |
//+------------------------------------------------------------------+
bool CWindow::OnClickTooltipsButton(const uint id,const uint index)
  {
//--- Эта кнопка не нужна, если окно диалоговое
   if(m_window_type==W_DIALOG)
      return(false);
//--- Выйти, если индексы не совпадают
   if(id!=m_button_tooltip.Id() || index!=m_button_tooltip.Index())
      return(false);
//--- Запомним состояние в поле класса
   m_tooltips_button_state=m_button_tooltip.IsPressed();
//--- Отправим сообщение об этом
   ::EventChartCustom(m_chart_id,ON_WINDOW_TOOLTIPS,CElementBase::Id(),CElementBase::Index(),"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Управляет размерами окна                                         |
//+------------------------------------------------------------------+
void CWindow::ResizeWindow(void)
  {
//--- Выйти, если окно недоступно
   if(!CElementBase::IsAvailable())
      return;
//--- Выйти, если кнопка мыши была нажата не над границей формы
   if(m_clamping_area_mouse!=PRESSED_INSIDE_BORDER && m_clamping_area_mouse!=NOT_PRESSED)
      return;
//--- Выйти, если (1) режим изменения размеров окна отключен или 
//    (2) окно в полноэкранном размере или (3) окно минимизировано
   if(!m_xy_resize_mode || m_is_fullscreen || m_is_minimized)
      return;
//--- Координаты
   int x =m_mouse.RelativeX(m_canvas);
   int y =m_mouse.RelativeY(m_canvas);
//--- Проверка готовности для изменения ширины списков
   if(!CheckResizePointer(x,y))
      return;
//--- Обновление размеров окна
   UpdateSize(x,y);
  }
//+------------------------------------------------------------------+
//| Проверка готовности для изменения размеров окна                  |
//+------------------------------------------------------------------+
bool CWindow::CheckResizePointer(const int x,const int y)
  {
//--- Определим текущий индекс режима
   m_resize_mode_index=ResizeModeIndex(x,y);
//--- Если курсор скрыт
   if(!m_xy_resize.IsVisible())
     {
      //--- Если режим определён
      if(m_resize_mode_index!=WRONG_VALUE)
        {
         //--- Для определения индекса отображаемой картинки указателя курсора мыши
         int index=WRONG_VALUE;
         //--- Если на вертикальных границах
         if(m_resize_mode_index==0 || m_resize_mode_index==1)
            index=0;
         //--- Если на горизонтальных границах
         else if(m_resize_mode_index==2)
            index=1;
         //--- Изменить картинку
         m_xy_resize.ChangeImage(0,index);
         //--- Переместить, перерисовать и показать
         m_xy_resize.Moving(m_mouse.X(),m_mouse.Y());
         m_xy_resize.Update(true);
         m_xy_resize.Reset();
         return(true);
        }
     }
   else
     {
      //--- Переместить указатель
      if(m_resize_mode_index!=WRONG_VALUE)
         m_xy_resize.Moving(m_mouse.X(),m_mouse.Y());
      //--- Скрыть указатель
      else if(!m_mouse.LeftButtonState())
        {
         //--- Скрыть указатель и обнулить переменные
         m_xy_resize.Hide();
         ZeroResizeVariables();
        }
      //--- Обновить график
      m_chart.Redraw();
      return(true);
     }
//---
   return(false);
  }
//+------------------------------------------------------------------+
//| Возвращает индекс режима для изменения размеров окна             |
//+------------------------------------------------------------------+
int CWindow::ResizeModeIndex(const int x,const int y)
  {
//--- Вернуть индекс границы, если уже есть захват
   if(m_resize_mode_index!=WRONG_VALUE && m_mouse.LeftButtonState())
      return(m_resize_mode_index);
//--- Толщина, отступ и индекс границы
   int width  =5;
   int offset =15;
   int index  =WRONG_VALUE;
//--- Проверка фокуса на левой границе
   if(x>0 && x<width && y>m_caption_height+offset && y<m_y_size-offset)
      index=0;
//--- Проверка фокуса на правой границе
   else if(x>m_x_size-width && x<m_x_size && y>m_caption_height+offset && y<m_y_size-offset)
      index=1;
//--- Проверка фокуса на нижней границе
   else if(y>m_y_size-width && y<m_y_size && x>offset && x<m_x_size-offset)
      index=2;
//--- Если индекс получен, отметим область нажатия
   if(index!=WRONG_VALUE)
      m_clamping_area_mouse=PRESSED_INSIDE_BORDER;
//--- Вернуть индекс области
   return(index);
  }
//+------------------------------------------------------------------+
//| Обновление размеров окна                                         |
//+------------------------------------------------------------------+
void CWindow::UpdateSize(const int x,const int y)
  {
//--- Если закончили и левая кнопка мыши отжата, сбросим значения
   if(!m_mouse.LeftButtonState())
     {
      ZeroResizeVariables();
      return;
     }
//--- Выйти, если захват и перемещение границы ещё не началось
   int distance=0;
   if((distance=CheckDragWindowBorder(x,y))==0)
      return;
//--- Расчёт и изменение размеров окна
   CalculateAndResizeWindow(distance);
//--- Перерисовать окно
   Update(true);
//--- Обновить положение объектов
   Moving(m_x,m_y);
//--- Сообщение о том, что размеры окна были изменены
   if(m_resize_mode_index==2)
      ::EventChartCustom(m_chart_id,ON_WINDOW_CHANGE_YSIZE,(long)CElementBase::Id(),0,"");
   else
      ::EventChartCustom(m_chart_id,ON_WINDOW_CHANGE_XSIZE,(long)CElementBase::Id(),0,"");
  }
//+------------------------------------------------------------------+
//| Проверка перетаскивания границы окна                             |
//+------------------------------------------------------------------+
int CWindow::CheckDragWindowBorder(const int x,const int y)
  {
//--- Для определения расстояния перемещения
   int distance=0;
//--- Если захват границы ещё не осуществлён
   if(m_point_fixed<1)
     {
      //--- Если изменение размера по оси X
      if(m_resize_mode_index==0 || m_resize_mode_index==1)
        {
         m_x_fixed     =m_x;
         m_size_fixed  =m_x_size;
         m_point_fixed =x;
        }
      //--- Если изменение размера по оси Y
      else if(m_resize_mode_index==2)
        {
         m_size_fixed  =m_y_size;
         m_point_fixed =y;
        }
      //--- Отправим сообщение на определение доступных элементов
      ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),0,"");
      //--- Отправим сообщение об изменении в графическом интерфейсе
      ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
      return(0);
     }
//--- Если это левая граница
   if(m_resize_mode_index==0)
      distance=m_mouse.X()-m_x_fixed;
//--- Если это правая граница
   else if(m_resize_mode_index==1)
      distance=x-m_point_fixed;
//--- Если это нижняя граница
   else if(m_resize_mode_index==2)
      distance=y-m_point_fixed;
//--- Вернуть расстояние перемещения
   return(distance);
  }
//+------------------------------------------------------------------+
//| Расчёт и изменение размеров окна                                 |
//+------------------------------------------------------------------+
void CWindow::CalculateAndResizeWindow(const int distance)
  {
//--- Левая граница
   if(m_resize_mode_index==0)
     {
      int new_x      =m_x_fixed+distance-m_point_fixed;
      int new_x_size =m_size_fixed-distance+m_point_fixed;
      //--- Выйти, если превышаем ограничения
      if(new_x<1 || new_x_size<=m_minimum_x_size)
         return;
      //--- Координаты
      CElementBase::X(new_x);
      ::ObjectSetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_XDISTANCE,new_x);
      //--- Установить и запомнить размер
      CElementBase::XSize(new_x_size);
      m_canvas.XSize(new_x_size);
      m_canvas.Resize(new_x_size,m_canvas.YSize());
     }
//--- Правая граница
   else if(m_resize_mode_index==1)
     {
      int gap_x2     =m_chart_width-m_mouse.X()-(m_size_fixed-m_point_fixed);
      int new_x_size =m_size_fixed+distance;
      //--- Выйти, если превышаем ограничения
      if(gap_x2<1 || new_x_size<=m_minimum_x_size)
         return;
      //--- Установить и запомнить размер
      CElementBase::XSize(new_x_size);
      m_canvas.XSize(new_x_size);
      m_canvas.Resize(new_x_size,m_canvas.YSize());
     }
//--- Нижняя граница
   else if(m_resize_mode_index==2)
     {
      int gap_y2=m_chart_height-m_mouse.Y()-(m_size_fixed-m_point_fixed);
      int new_y_size=m_size_fixed+distance;
      //--- Выйти, если превышаем ограничения
      if(gap_y2<2 || new_y_size<=m_minimum_y_size)
         return;
      //--- Установить и запомнить размер
      m_full_height=new_y_size;
      CElementBase::YSize(new_y_size);
      m_canvas.YSize(new_y_size);
      m_canvas.Resize(m_canvas.XSize(),new_y_size);
     }
  }
//+------------------------------------------------------------------+
//| Рисует элемент                                                   |
//+------------------------------------------------------------------+
void CWindow::Draw(void)
  {
//--- Нарисовать задний фон
   DrawBackground();
//--- Нарисовать передний фон
   DrawForeground();
//--- Нарисовать картинку
   CElement::DrawImage();
//--- Нарисовать текст
   CElement::DrawText();
  }
//+------------------------------------------------------------------+
//| Рисует задний фон                                                |
//+------------------------------------------------------------------+
void CWindow::DrawBackground(void)
  {
   uint clr=(CElementBase::IsLocked())? m_caption_color_locked :(CElementBase::MouseFocus())? m_caption_color_hover : m_caption_color;
   CElement::m_canvas.Erase(::ColorToARGB(clr,m_alpha));
  }
//+------------------------------------------------------------------+
//| Рисует передний фон                                              |
//+------------------------------------------------------------------+
void CWindow::DrawForeground(void)
  {
//--- Выйти, если окно свёрнуто
   if(m_is_minimized)
      return;
//--- Координаты
   int x  =1;
   int y  =m_caption_height;
   int x2 =m_x_size-2;
   int y2 =m_y_size-2;
//--- Нарисовать прямоугольник с заливкой
   m_canvas.FillRectangle(x,y,x2,y2,::ColorToARGB(m_back_color,(m_transparent_only_caption)?(uchar)255 : m_alpha));
  }
//+------------------------------------------------------------------+
