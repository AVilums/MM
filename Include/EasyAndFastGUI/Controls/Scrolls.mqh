//+------------------------------------------------------------------+
//|                                                      Scrolls.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "Button.mqh"
//--- Список классов в файле для быстрого перехода (Alt+G)
class CScroll;
class CScrollV;
class CScrollH;
//+------------------------------------------------------------------+
//| Базовый класс для создания полосы прокрутки                      |
//+------------------------------------------------------------------+
class CScroll : public CElement
  {
protected:
   //--- Объекты для создания полосы прокрутки
   CButton           m_button_inc;
   CButton           m_button_dec;
   //--- Свойства общей площади полосы прокрутки
   int               m_area_width;
   int               m_area_length;
   //--- Картинки для кнопок
   string            m_inc_file;
   string            m_inc_file_locked;
   string            m_inc_file_pressed;
   string            m_dec_file;
   string            m_dec_file_locked;
   string            m_dec_file_pressed;
   //--- (1) Фокус на ползунке и (2) момент его пересечения границ
   bool              m_thumb_focus;
   bool              m_is_crossing_thumb_border;
   //--- Цвета ползунка в разных состояниях
   color             m_thumb_color;
   color             m_thumb_color_hover;
   color             m_thumb_color_pressed;
   //--- (1) Общее количество пунктов и (2) видимое
   int               m_items_total;
   int               m_visible_items_total;
   //--- Координаты ползунка
   int               m_thumb_x;
   int               m_thumb_y;
   //--- (1) Ширина ползунка, (2) длина ползунка и (3) его минимальная длина
   int               m_thumb_width;
   int               m_thumb_length;
   int               m_thumb_min_length;
   //--- (1) Размер шага ползунка и (2) кол-во шагов
   double            m_thumb_step_size;
   double            m_thumb_steps_total;
   //--- Переменные связанные с перемещением ползунка
   bool              m_scroll_state;
   int               m_thumb_size_fixing;
   int               m_thumb_point_fixing;
   //--- Текущая позиция ползунка
   int               m_current_pos;
   //--- Для определения области зажатия левой кнопки мыши
   ENUM_MOUSE_STATE  m_clamping_area_mouse;
   //---
public:
                     CScroll(void);
                    ~CScroll(void);
   //--- Методы для создания полосы прокрутки
   bool              CreateScroll(const int x_gap,const int y_gap,
                                  const int items_total,const int visible_items_total);
   //---
private:
   void              InitializeProperties(const int x_gap,const int y_gap,
                                          const int items_total,const int visible_items_total);
   bool              CreateCanvas(void);
   bool              CreateScrollButton(CButton &button_obj,const int index);
   //---
public:
   //--- Возвращает указатели на кнопки полосы прокрутки
   CButton          *GetIncButtonPointer(void)                { return(::GetPointer(m_button_inc)); }
   CButton          *GetDecButtonPointer(void)                { return(::GetPointer(m_button_dec)); }
   //--- Ширина полосы прокрутки
   void              ScrollWidth(const int width)             { m_area_width=width;                 }
   int               ScrollWidth(void)                  const { return(m_area_width);               }
   //--- Установка картинок для кнопок
   void              IncFile(const string file_path)          { m_inc_file=file_path;               }
   void              IncFileLocked(const string file_path)    { m_inc_file_locked=file_path;        }
   void              IncFilePressed(const string file_path)   { m_inc_file_pressed=file_path;       }
   void              DecFile(const string file_path)          { m_dec_file=file_path;               }
   void              DecFileLocked(const string file_path)    { m_dec_file_locked=file_path;        }
   void              DecFilePressed(const string file_path)   { m_dec_file_pressed=file_path;       }
   //--- (1) Цвета ползунка и (2) рамки ползунка
   void              ThumbColor(const color clr)              { m_thumb_color=clr;                  }
   void              ThumbColorHover(const color clr)         { m_thumb_color_hover=clr;            }
   void              ThumbColorPressed(const color clr)       { m_thumb_color_pressed=clr;          }
   //--- Состояние кнопок
   bool              ScrollIncState(void)               const { return(m_button_inc.IsPressed());   }
   bool              ScrollDecState(void)               const { return(m_button_dec.IsPressed());   }
   //--- Состояние полосы прокрутки (свободно/в режиме перемещения ползунка)
   void              State(const bool scroll_state)           { m_scroll_state=scroll_state;        }
   bool              State(void)                        const { return(m_scroll_state);             }
   //--- Текущая позиция ползунка
   void              CurrentPos(const int pos)                { m_current_pos=pos;                  }
   int               CurrentPos(void)                   const { return(m_current_pos);              }
   //--- Инициализация новыми значениями
   void              Reinit(const int items_total,const int visible_items_total);
   //--- Изменение размера ползунка по новым условиям
   void              ChangeThumbSize(const int items_total,const int visible_items_total);
   //--- Необходимость показа полосы прокрутки
   bool              IsScroll(void) const { return(m_items_total>m_visible_items_total); }
   //---
protected:
   //--- Текущий цвет ползунка
   uint              ThumbColorCurrent(void);
   //--- Проверка фокуса над ползунком
   bool              CheckThumbFocus(const int x,const int y);
   //--- Определяет область зажатия левой кнопки мыши
   void              CheckMouseButtonState(void);
   //--- Обнуление переменных
   void              ZeroThumbVariables(void);
   //--- Расчёт длины ползунка полосы прокрутки
   bool              CalculateThumbSize(void);
   //--- Расчёт границ ползунка полосы прокрутки
   void              CalculateThumbBoundaries(int &x1,int &y1,int &x2,int &y2);
   //---
public:
   //--- Управление
   virtual void      Show(void);
   virtual void      Hide(void);
   virtual void      Delete(void);
   //--- Рисует элемент
   virtual void      Draw(void);
   //---
private:
   //--- Рисует фон
   virtual void      DrawThumb(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CScroll::CScroll(void) : m_current_pos(0),
                         m_area_width(15),
                         m_area_length(0),
                         m_inc_file(""),
                         m_inc_file_locked(""),
                         m_inc_file_pressed(""),
                         m_dec_file(""),
                         m_dec_file_locked(""),
                         m_dec_file_pressed(""),
                         m_thumb_focus(false),
                         m_is_crossing_thumb_border(false),
                         m_thumb_x(0),
                         m_thumb_y(0),
                         m_thumb_width(0),
                         m_thumb_length(0),
                         m_thumb_min_length(15),
                         m_thumb_size_fixing(0),
                         m_thumb_point_fixing(0),
                         m_thumb_color(C'205,205,205'),
                         m_thumb_color_hover(C'166,166,166'),
                         m_thumb_color_pressed(C'96,96,96')
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CScroll::~CScroll(void)
  {
  }
//+------------------------------------------------------------------+
//| Создаёт полосу прокрутки                                         |
//+------------------------------------------------------------------+
bool CScroll::CreateScroll(const int x_gap,const int y_gap,const int items_total,const int visible_items_total)
  {
//--- Выйти, если нет указателя на главный элемент
   if(!CElement::CheckMainPointer())
      return(false);
//--- Выйти, если производится попытка использовать базовый класс полосы прокрутки
   if(CElementBase::ClassName()=="")
     {
      ::Print(__FUNCTION__," > Используйте производные классы полосы прокрутки (CScrollV или CScrollH).");
      return(false);
     }
//--- Инициализация свойств
   InitializeProperties(x_gap,y_gap,items_total,visible_items_total);
//--- Создание элемента 
   if(!CreateCanvas())
      return(false);
   if(!CreateScrollButton(m_button_inc,0))
      return(false);
   if(!CreateScrollButton(m_button_dec,1))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Инициализация свойств                                            |
//+------------------------------------------------------------------+
void CScroll::InitializeProperties(const int x_gap,const int y_gap,
                                   const int items_total,const int visible_items_total)
  {
   m_x                   =CElement::CalculateX(x_gap);
   m_y                   =CElement::CalculateY(y_gap);
   m_area_width          =(CElementBase::ClassName()=="CScrollV")? CElementBase::XSize() : CElementBase::YSize();
   m_area_length         =(CElementBase::ClassName()=="CScrollV")? CElementBase::YSize() : CElementBase::XSize();
   m_items_total         =(items_total<1)? 1 : items_total;
   m_visible_items_total =(visible_items_total>0)? visible_items_total : 1;
   m_thumb_width         =m_area_width;
   m_thumb_steps_total   =(IsScroll())? m_items_total-m_visible_items_total : 1;
   m_back_color          =(m_back_color!=clrNONE)? m_back_color : C'240,240,240';
//--- Отступы от крайней точки
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
//--- Рассчитаем размер полосы прокрутки
   CalculateThumbSize();
  }
//+------------------------------------------------------------------+
//| Создаёт объект для рисования                                     |
//+------------------------------------------------------------------+
bool CScroll::CreateCanvas(void)
  {
//--- Формирование имени объекта
   string name=CElementBase::ElementName((CElementBase::ClassName()=="CScrollV")? "scrollv" : "scrollh");
//--- Создание объекта
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт переключатель скролла вверх или влево                    |
//+------------------------------------------------------------------+
bool CScroll::CreateScrollButton(CButton &button_obj,const int index)
  {
//--- Сохраним указатель на главный элемент
   button_obj.MainPointer(this);
//--- Координаты
   int x=0,y=0;
//--- Файлы
   string file="",file_locked="",file_pressed="";
//--- Кнопка вверх или влево
   if(index==0)
     {
      //--- Установка свойств с учётом типа скролла
      if(CElementBase::ClassName()=="CScrollV")
        {
         file=(m_inc_file=="")? (string)RESOURCE_SCROLL_UP_BLACK : m_inc_file;
         file_locked=(m_inc_file_locked=="")? (string)RESOURCE_SCROLL_UP_BLACK : m_inc_file_locked;
         file_pressed=(m_inc_file_pressed=="")? (string)RESOURCE_SCROLL_UP_WHITE : m_inc_file_pressed;
        }
      else
        {
         file=(m_inc_file=="")? (string)RESOURCE_SCROLL_LEFT_BLACK : m_inc_file;
         file_locked=(m_inc_file_locked=="")? (string)RESOURCE_SCROLL_LEFT_BLACK : m_inc_file_locked;
         file_pressed=(m_inc_file_pressed=="")? (string)RESOURCE_SCROLL_LEFT_WHITE : m_inc_file_pressed;
        }
      //--- Индекс элемента
      button_obj.Index(m_index*2);
     }
//--- Кнопка вниз или вправо
   else
     {
      //--- Установка свойств с учётом типа скролла
      if(CElementBase::ClassName()=="CScrollV")
        {
         x=0; y=m_thumb_width;
         file=(m_dec_file=="")? (string)RESOURCE_SCROLL_DOWN_BLACK : m_dec_file;
         file_locked=(m_dec_file_locked=="")? (string)RESOURCE_SCROLL_DOWN_BLACK : m_dec_file_locked;
         file_pressed=(m_dec_file_pressed=="")? (string)RESOURCE_SCROLL_DOWN_WHITE : m_dec_file_pressed;
         button_obj.AnchorBottomWindowSide(true);
        }
      else
        {
         x=m_thumb_width; y=0;
         file=(m_dec_file=="")? (string)RESOURCE_SCROLL_RIGHT_BLACK : m_dec_file;
         file_locked=(m_dec_file_locked=="")? (string)RESOURCE_SCROLL_RIGHT_BLACK : m_dec_file_locked;
         file_pressed=(m_dec_file_pressed=="")? (string)RESOURCE_SCROLL_RIGHT_WHITE : m_dec_file_pressed;
         button_obj.AnchorRightWindowSide(true);
        }
      //--- Индекс элемента
      button_obj.Index(m_index*2+1);
     }
//--- Свойства
   button_obj.NamePart("scroll_button");
   button_obj.Alpha(m_alpha);
   button_obj.XSize(15);
   button_obj.YSize(15);
   button_obj.IconXGap(0);
   button_obj.IconYGap(0);
   button_obj.TwoState(true);
   button_obj.BackColor(m_back_color);
   button_obj.BackColorHover(C'218,218,218');
   button_obj.BackColorLocked(clrLightGray);
   button_obj.BackColorPressed(m_thumb_color_pressed);
   button_obj.BorderColor(m_back_color);
   button_obj.BorderColorHover(C'218,218,218');
   button_obj.BorderColorLocked(clrLightGray);
   button_obj.BorderColorPressed(m_thumb_color_pressed);
   button_obj.IconFile((uint)file);
   button_obj.IconFileLocked((uint)file_locked);
   button_obj.CElement::IconFilePressed((uint)file_pressed);
   button_obj.CElement::IconFilePressedLocked((uint)file_locked);
   button_obj.IsDropdown(CElementBase::IsDropdown());
//--- Создадим элемент управления
   if(!button_obj.CreateButton("",x,y))
      return(false);
//--- Добавить элемент в массив
   CElement::AddToArray(button_obj);
   return(true);
  }
//+------------------------------------------------------------------+
//| Текущий цвет ползунка                                            |
//+------------------------------------------------------------------+
uint CScroll::ThumbColorCurrent(void)
  {
//--- Определим цвет ползунка
   color clr=(m_scroll_state)? m_thumb_color_pressed : m_thumb_color;
//--- Если курсор мыши в зоне ползунка полосы прокрутки
   if(m_thumb_focus)
     {
      //--- Если левая кнопка мыши отжата
      if(m_clamping_area_mouse==NOT_PRESSED)
         clr=m_thumb_color_hover;
      //--- Левая кнопка мыши нажата на ползунке
      else if(m_clamping_area_mouse==PRESSED_INSIDE)
         clr=m_thumb_color_pressed;
     }
//--- Если курсор вне зоны полосы прокрутки
   else
     {
      //--- Левая кнопка мыши отжата
      if(m_clamping_area_mouse==NOT_PRESSED)
         clr=m_thumb_color;
     }
//---
   return(::ColorToARGB(clr,m_alpha));
  }
//+------------------------------------------------------------------+
//| Проверка фокуса над ползунком                                    |
//+------------------------------------------------------------------+
bool CScroll::CheckThumbFocus(const int x,const int y)
  {
//--- Проверка фокуса над ползунком
   if(CElementBase::ClassName()=="CScrollV")
     {
      m_thumb_focus=(x>m_thumb_x && x<m_thumb_x+m_thumb_width && 
                     y>m_thumb_y && y<m_thumb_y+m_thumb_length);
     }
   else
     {
      m_thumb_focus=(x>m_thumb_x && x<m_thumb_x+m_thumb_length && 
                     y>m_thumb_y && y<m_thumb_y+m_thumb_width);
     }
//--- Если это момент пересечения границ элемента
   if((m_thumb_focus && !m_is_crossing_thumb_border) || (!m_thumb_focus && m_is_crossing_thumb_border))
     {
      m_is_crossing_thumb_border=m_thumb_focus;
      //---
      if(!CScroll::State())
        {
         int x1=0,y1=0,x2=0,y2=0;
         CalculateThumbBoundaries(x1,y1,x2,y2);
         //--- Нарисовать прямоугольник с заливкой
         m_canvas.FillRectangle(x1,y1,x2-1,y2-1,ThumbColorCurrent());
         m_canvas.Update();
        }
      return(true);
     }
//---
   return(false);
  }
//+------------------------------------------------------------------+
//| Определяет область зажатия левой кнопки мыши                     |
//+------------------------------------------------------------------+
void CScroll::CheckMouseButtonState(void)
  {
//--- Если левая кнопки мыши отжата
   if(!m_mouse.LeftButtonState())
     {
      //--- Обнулим переменные
      ZeroThumbVariables();
      return;
     }
//--- Если кнопка нажата
   else
     {
      //--- Выйдем, если кнопка уже нажата в какой-либо области
      if(m_clamping_area_mouse!=NOT_PRESSED)
         return;
      //--- Вне области ползунка полосы прокрутки
      if(!m_thumb_focus)
         m_clamping_area_mouse=PRESSED_OUTSIDE;
      //--- В области ползунка полосы прокрутки
      else
        {
         m_scroll_state        =true;
         m_clamping_area_mouse =PRESSED_INSIDE;
         //--- Перерисовать элемент
         Update(true);
         //--- Если элемент не выпадающий
         if(!CElementBase::IsDropdown())
           {
            //--- Отправим сообщение на определение доступных элементов
            ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),0,"");
            //--- Отправим сообщение об изменении в графическом интерфейсе
            ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| Обнуление переменных связанных с перемещением ползунка           |
//+------------------------------------------------------------------+
void CScroll::ZeroThumbVariables(void)
  {
//--- Выйти, если нет указателя на главный элемент
   if(!CElement::CheckMainPointer())
      return;
//--- Выйти, если кнопка уже отжата
   if(m_clamping_area_mouse==NOT_PRESSED)
      return;
//--- Если элемент не выпадающий
   if(!CElementBase::IsDropdown() && m_clamping_area_mouse==PRESSED_INSIDE)
     {
      //--- Отправим сообщение на определение доступных элементов
      ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),1,"");
      //--- Отправим сообщение об изменении в графическом интерфейсе
      ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
     }
//--- Обнулить переменные
   m_scroll_state        =false;
   m_thumb_size_fixing   =0;
   m_clamping_area_mouse =NOT_PRESSED;
//--- Перерисовать элемент
   Update(true);
  }
//+------------------------------------------------------------------+
//| Изменение размера ползунка по новым условиям                     |
//+------------------------------------------------------------------+
void CScroll::ChangeThumbSize(const int items_total,const int visible_items_total)
  {
   m_items_total         =items_total;
   m_visible_items_total =visible_items_total;
//--- Выйдем, если количество элементов списка не больше количества видимой части списка
   if(!IsScroll())
      return;
//--- Получим количество шагов для ползунка
   m_thumb_steps_total=items_total-visible_items_total;
//--- Получим размер полосы прокрутки
   if(!CalculateThumbSize())
      return;
  }
//+------------------------------------------------------------------+
//| Расчёт размера полосы прокрутки                                  |
//+------------------------------------------------------------------+
bool CScroll::CalculateThumbSize(void)
  {
//--- Разница в процентах между общим количеством пунктов и видимым
   double percentage_difference=1-(double)(m_items_total-m_visible_items_total)/m_items_total;
//--- Рассчитаем размер шага ползунка
   uint bg_length=(m_class_name=="CScrollV")? m_y_size-(m_thumb_width*2) : m_x_size-(m_thumb_width*2);
   m_thumb_step_size=(double)(bg_length-(bg_length*percentage_difference))/m_thumb_steps_total;
//--- Рассчитаем размер рабочей области для перемещения ползунка
   double work_area=m_thumb_step_size*m_thumb_steps_total;
//--- Если размер рабочей области меньше размера всей области, получим размер ползунка, иначе установим минимальный размер
   double thumb_size=(work_area<bg_length)? bg_length-work_area+m_thumb_step_size : m_thumb_min_length;
//--- Проверка размера ползунка с учётом приведения типа
   m_thumb_length=((int)thumb_size<m_thumb_min_length)? m_thumb_min_length :(int)thumb_size;
   return(true);
  }
//+------------------------------------------------------------------+
//| Расчёт границ ползунка полосы прокрутки                          |
//+------------------------------------------------------------------+
void CScroll::CalculateThumbBoundaries(int &x1,int &y1,int &x2,int &y2)
  {
   if(CElementBase::ClassName()=="CScrollV")
     {
      x1 =0;
      y1 =(m_thumb_y>0) ? m_thumb_y : m_thumb_width;
      x2 =x1+m_thumb_width;
      y2 =y1+m_thumb_length;
     }
   else
     {
      x1 =(m_thumb_x>0) ? m_thumb_x : m_thumb_width;
      y1 =0;
      x2 =x1+m_thumb_length;
      y2 =y1+m_thumb_width;
     }
  }
//+------------------------------------------------------------------+
//| Инициализация новыми значениями                                  |
//+------------------------------------------------------------------+
void CScroll::Reinit(const int items_total,const int visible_items_total)
  {
   m_items_total         =(items_total>0)? items_total : 1;
   m_visible_items_total =(visible_items_total>items_total)? items_total : visible_items_total;
   m_thumb_steps_total   =m_items_total-m_visible_items_total+1;
  }
//+------------------------------------------------------------------+
//| Показывает элемент                                               |
//+------------------------------------------------------------------+
void CScroll::Show(void)
  {
//--- Выйти, если (1) элемент уже видим или (2) его не нужно показывать
   if(CElementBase::IsVisible() || !IsScroll())
      return;
//--- Состояние видимости
   CElementBase::IsVisible(true);
//--- Обновить положение объектов
   Moving();
//--- Показать объекты
   ::ObjectSetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
   m_button_inc.Show();
   m_button_dec.Show();
  }
//+------------------------------------------------------------------+
//| Скрывает элемент                                                 |
//+------------------------------------------------------------------+
void CScroll::Hide(void)
  {
   ::ObjectSetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   m_button_inc.Hide();
   m_button_dec.Hide();
//--- Состояние видимости
   CElementBase::IsVisible(false);
  }
//+------------------------------------------------------------------+
//| Удаление                                                         |
//+------------------------------------------------------------------+
void CScroll::Delete(void)
  {
//--- Удаление объектов
   m_canvas.Destroy();
//--- Инициализация переменных значениями по умолчанию
   m_thumb_x=0;
   m_thumb_y=0;
   CurrentPos(0);
   CElementBase::IsVisible(true);
  }
//+------------------------------------------------------------------+
//| Рисует элемент                                                   |
//+------------------------------------------------------------------+
void CScroll::Draw(void)
  {
//--- Нарисовать фон
   CElement::DrawBackground();
//--- Нарисовать ползунок
   DrawThumb();
  }
//+------------------------------------------------------------------+
//| Рисует ползунок полосы прокрутки                                 |
//+------------------------------------------------------------------+
void CScroll::DrawThumb(void)
  {
//--- Координаты
   int x1=0,y1=0,x2=0,y2=0;
//--- Расчёт границ ползунка
   CalculateThumbBoundaries(x1,y1,x2,y2);
//--- Сохраним координаты ползунка (левый верхний угол)
   m_thumb_x=x1;
   m_thumb_y=y1;
//--- Нарисовать прямоугольник с заливкой
   m_canvas.FillRectangle(x1,y1,x2-1,y2-1,ThumbColorCurrent());
  }
//+------------------------------------------------------------------+
//| Класс для управления вертикальной полосой прокрутки              |
//+------------------------------------------------------------------+
class CScrollV : public CScroll
  {
public:
                     CScrollV(void);
                    ~CScrollV(void);
   //--- Управление ползунком
   bool              ScrollBarControl(void);
   //--- Перемещает ползунок на указанную позицию
   void              MovingThumb(const int pos=WRONG_VALUE);
   //--- Установить новую координату для полосы прокрутки
   void              XDistance(const int x);
   //--- Изменить длину полосы прокрутки
   void              ChangeYSize(const int height);
   //--- Обработка нажатия на кнопках полосы прокрутки
   bool              OnClickScrollInc(const int id=WRONG_VALUE,const int index=WRONG_VALUE);
   bool              OnClickScrollDec(const int id=WRONG_VALUE,const int index=WRONG_VALUE);
   //---
private:
   //--- Процесс перемещения ползунка
   bool              OnDragThumb(const int y);
   //--- Обновление положения ползунка
   void              UpdateThumb(const int new_y_point);
   //--- Расчёт координаты Y ползунка
   void              CalculateThumbY(void);
   //--- Корректирует номер позиции ползунка
   void              CalculateThumbPos(void);
   //--- Быстрая перерисовка ползунка полосы прокрутки
   void              RedrawThumb(const int y);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CScrollV::CScrollV(void)
  {
//--- Сохраним имя класса элемента в базовом классе
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CScrollV::~CScrollV(void)
  {
  }
//+------------------------------------------------------------------+
//| Управление ползунком                                             |
//+------------------------------------------------------------------+
bool CScrollV::ScrollBarControl(void)
  {
//--- Выйти, если (1) нет указателя на главный элемент или (2) элемент скрыт
   if(!CElement::CheckMainPointer() || !CElementBase::IsVisible())
      return(false);
//--- Выйти, если родитель отключен другим элементом
   if(!m_main.CElementBase::IsAvailable())
      return(false);
//--- Проверка фокуса над ползунком
   int x =m_mouse.RelativeX(m_canvas);
   int y =m_mouse.RelativeY(m_canvas);
   CheckThumbFocus(x,y);
//--- Проверим и запомним состояние кнопки мыши
   CScroll::CheckMouseButtonState();
//--- Если управление передано полосе прокрутки, определим положение ползунка
   if(CScroll::State())
     {
      //--- Если ползунок переместили
      if(OnDragThumb(y))
        {
         //--- Изменяет номер позиции ползунка
         CalculateThumbPos();
         return(true);
        }
     }
//---
   return(false);
  }
//+------------------------------------------------------------------+
//| Перемещает ползунок на указанную позицию                         |
//+------------------------------------------------------------------+
void CScrollV::MovingThumb(const int pos=WRONG_VALUE)
  {
//--- Выйти, если полоса прокрутки не нужна
   if(!IsScroll())
      return;
//--- Для проверки позиции ползунка
   uint check_pos=0;
//--- Скорректируем позицию в случае выхода из диапазона
   if(pos<0 || pos>m_items_total-m_visible_items_total)
      check_pos=m_items_total-m_visible_items_total;
   else
      check_pos=pos;
//--- Запомним позицию ползунка
   CScroll::CurrentPos(check_pos);
//--- Расчёт и установка координаты Y ползунка полосы прокрутки
   CalculateThumbY();
  }
//+------------------------------------------------------------------+
//| Расчёт и установка координаты Y ползунка полосы прокрутки        |
//+------------------------------------------------------------------+
void CScrollV::CalculateThumbY(void)
  {
//--- Выйти, если нет указателя на главный элемент
   if(!CElement::CheckMainPointer())
      return;
//--- Определим текущую координату Y ползунка
   int scroll_thumb_y=int(m_thumb_width+(CurrentPos()*m_thumb_step_size));
//--- Если выходим за пределы рабочей области вверх
   if(scroll_thumb_y<=m_thumb_width)
      scroll_thumb_y=m_thumb_width;
//--- Если выходим за пределы рабочей области вниз
   if(scroll_thumb_y+m_thumb_length>=m_y_size-m_thumb_width || 
      CScroll::CurrentPos()>=m_thumb_steps_total-1)
     {
      scroll_thumb_y=int(m_y_size-m_thumb_width-m_thumb_length);
     }
//--- Обновим координату и отступ по оси Y
   m_thumb_y=scroll_thumb_y;
  }
//+------------------------------------------------------------------+
//| Изменение координаты X элемента                                  |
//+------------------------------------------------------------------+
void CScrollV::XDistance(const int x)
  {
//--- Выйти, если нет указателя на главный элемент
   if(!CElement::CheckMainPointer())
      return;
//--- Обновим координату X элемента...
   CElementBase::X(CElement::CalculateX(x));
   CElementBase::XGap(x);
   m_canvas.X(x);
//--- Установим координату и отступ
   ::ObjectSetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_XDISTANCE,x);
   m_canvas.XGap(x);
//--- Переместить объекты
   Moving();
  }
//+------------------------------------------------------------------+
//| Изменить длину полосы прокрутки                                  |
//+------------------------------------------------------------------+
void CScrollV::ChangeYSize(const int height)
  {
//--- Координаты и размеры
   int y=0,y_size=0;
//--- Изменить ширину элемента и фона
   CElementBase::YSize(height);
   m_canvas.YSize(height);
   m_canvas.Resize(m_x_size,height);
//--- Скорректировать положение кнопки декремента
   m_button_dec.Moving();
//--- Рассчитаем и установим размеры объектов полосы прокрутки
   CalculateThumbSize();
//--- Корректировка положения ползунка
   if(m_thumb_y+m_thumb_length>=m_y_size-m_thumb_length || m_thumb_y<m_thumb_width)
     {
      CalculateThumbY();
      CalculateThumbPos();
     }
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на кнопке вверх/влево                          |
//+------------------------------------------------------------------+
bool CScrollV::OnClickScrollInc(const int id=WRONG_VALUE,const int index=WRONG_VALUE)
  {
//--- Проверить идентификатор и индекс элемента, если был внешний вызов
   uint check_id    =(id!=WRONG_VALUE)? id : CElementBase::Id();
   uint check_index =(index!=WRONG_VALUE)? index : CElementBase::Index();
//--- Выйти, если значения не совпадают
   if(check_id!=m_button_inc.Id() || check_index!=m_button_inc.Index())
      return(false);
//--- Выйдем, если (1) сейчас активен или (2) кол-во шагов неопределено
   if(CScroll::State() || m_thumb_steps_total<1)
      return(false);
//--- Уменьшим номер позиции полосы прокрутки
   if(CScroll::CurrentPos()>0)
      CScroll::m_current_pos--;
//--- Расчёт координты Y полосы прокрутки
   CalculateThumbY();
//--- Отожмём кнопку
   m_button_inc.IsPressed(false);
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на кнопке вниз/вправо                          |
//+------------------------------------------------------------------+
bool CScrollV::OnClickScrollDec(const int id=WRONG_VALUE,const int index=WRONG_VALUE)
  {
//--- Проверить идентификатор и индекс элемента, если был внешний вызов
   uint check_id    =(id!=WRONG_VALUE)? id : CElementBase::Id();
   uint check_index =(index!=WRONG_VALUE)? index : CElementBase::Index();
//--- Выйти, если значения не совпадают
   if(check_id!=m_button_dec.Id() || check_index!=m_button_dec.Index())
      return(false);
//--- Выйдем, если (1) сейчас активен или (2) кол-во шагов неопределено
   if(CScroll::State() || m_thumb_steps_total<1)
      return(false);
//--- Увеличим номер позиции полосы прокрутки
   if(CScroll::CurrentPos()<CScroll::m_thumb_steps_total-1)
      CScroll::m_current_pos++;
//--- Расчёт координты Y полосы прокрутки
   CalculateThumbY();
//--- Отожмём кнопку
   m_button_dec.IsPressed(false);
   return(true);
  }
//+------------------------------------------------------------------+
//| Перемещение ползунка                                             |
//+------------------------------------------------------------------+
bool CScrollV::OnDragThumb(const int y)
  {
//--- Для определения новой Y координаты
   int new_y_point=0;
//--- Если полоса прокрутки неактивна, ...
   if(!CScroll::State())
     {
      //--- ...обнулим вспомогательные переменные для перемещения ползунка
      m_thumb_size_fixing  =0;
      m_thumb_point_fixing =0;
      return(false);
     }
//--- Если точка фиксации нулевая, то запомним текущую координату курсора
   if(m_thumb_point_fixing==0)
      m_thumb_point_fixing=y;
//--- Если значение расстояния от крайней точки ползунка до текущей координаты курсора нулевое, рассчитаем его
   if(m_thumb_size_fixing==0)
      m_thumb_size_fixing=m_thumb_y-y;
//--- Если в нажатом состоянии прошли порог вниз
   if(y-m_thumb_point_fixing>0)
     {
      //--- Рассчитаем координату Y
      new_y_point=y+m_thumb_size_fixing;
      //--- Обновим положение ползунка
      UpdateThumb(new_y_point);
      return(true);
     }
//--- Если в нажатом состоянии прошли порог вверх
   if(y-m_thumb_point_fixing<0)
     {
      //--- Рассчитаем координату Y
      new_y_point=y-::fabs(m_thumb_size_fixing);
      //--- Обновим положение ползунка
      UpdateThumb(new_y_point);
      return(true);
     }
//---
   return(false);
  }
//+------------------------------------------------------------------+
//| Обновление положения ползунка                                    |
//+------------------------------------------------------------------+
void CScrollV::UpdateThumb(const int new_y_point)
  {
   int y=new_y_point;
//--- Обнуление точки фиксации
   m_thumb_point_fixing=0;
//--- Проверка на выход из рабочей области вниз и корректировка значений
   if(new_y_point>m_y_size-m_thumb_width-m_thumb_length)
     {
      y=m_y_size-m_thumb_width-m_thumb_length;
      CScroll::CurrentPos(int(m_thumb_steps_total-1));
     }
//--- Проверка на выход из рабочей области вверх и корректировка значений
   if(new_y_point<=m_thumb_width)
     {
      y=m_thumb_width;
      CScroll::CurrentPos(0);
     }
//--- Текущие координаты
   RedrawThumb(y);
  }
//+------------------------------------------------------------------+
//| Корректирует номер позиции ползунка                              |
//+------------------------------------------------------------------+
void CScrollV::CalculateThumbPos(void)
  {
//--- Выйти, если шаг равен нулю
   if(m_thumb_step_size==0)
      return;
//--- Корректирует номер позиции полосы прокрутки
   CScroll::CurrentPos(int((m_thumb_y-m_thumb_width+1)/m_thumb_step_size));
//--- Проверка на выход из рабочей области вниз/вверх
   if(m_thumb_y+m_thumb_length>=m_y_size-m_thumb_width)
      CScroll::CurrentPos(int(m_thumb_steps_total-1));
   if(m_thumb_y<=m_thumb_width)
      CScroll::CurrentPos(0);
  }
//+------------------------------------------------------------------+
//| Быстрая перерисовка ползунка полосы прокрутки                    |
//+------------------------------------------------------------------+
void CScrollV::RedrawThumb(const int y)
  {
//--- Текущие координаты
   int x1=0,y1=0,x2=0,y2=0;
   CalculateThumbBoundaries(x1,y1,x2,y2);
//--- Стереть текущее положение ползунка
   m_canvas.FillRectangle(x1,y1,x2-1,y2-1,m_back_color);
//--- Обновим координаты
   m_thumb_y=y;
   y2=y+m_thumb_length;
//--- Нарисовать новое положение ползунка
   m_canvas.FillRectangle(x1,y1,x2-1,y2-1,m_thumb_color_pressed);
  }
//+------------------------------------------------------------------+
//| Класс для управления горизонтальной полосой прокрутки            |
//+------------------------------------------------------------------+
class CScrollH : public CScroll
  {
public:
                     CScrollH(void);
                    ~CScrollH(void);
   //--- Управление ползунком
   bool              ScrollBarControl(void);
   //--- Перемещает ползунок на указанную позицию
   void              MovingThumb(const int pos=WRONG_VALUE);
   //--- Установить новую координату для полосы прокрутки
   void              YDistance(const int y);
   //--- Изменить длину полосы прокрутки
   void              ChangeXSize(const int width);
   //--- Обработка нажатия на кнопках полосы прокрутки
   bool              OnClickScrollInc(const int id=WRONG_VALUE,const int index=WRONG_VALUE);
   bool              OnClickScrollDec(const int id=WRONG_VALUE,const int index=WRONG_VALUE);
   //---
private:
   //--- Перемещение ползунка
   bool              OnDragThumb(const int x);
   //--- Обновление положения ползунка
   void              UpdateThumb(const int new_x_point);
   //--- Расчёт координаты X ползунка
   void              CalculateThumbX(void);
   //--- Корректирует номер позиции ползунка
   void              CalculateThumbPos(void);
   //--- Быстрая перерисовка ползунка полосы прокрутки
   void              RedrawThumb(const int x);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CScrollH::CScrollH(void)
  {
//--- Сохраним имя класса элемента в базовом классе
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CScrollH::~CScrollH(void)
  {
  }
//+------------------------------------------------------------------+
//| Управление скроллом                                              |
//+------------------------------------------------------------------+
bool CScrollH::ScrollBarControl(void)
  {
//--- Выйти, если (1) нет указателя на главный элемент или (2) элемент скрыт
   if(!CElement::CheckMainPointer() || !CElementBase::IsVisible())
      return(false);
//--- Выйти, если родитель отключен другим элементом
   if(!m_main.CElementBase::IsAvailable())
      return(false);
//--- Проверка фокуса над ползунком
   int x=m_mouse.RelativeX(m_canvas);
   int y=m_mouse.RelativeY(m_canvas);
   CheckThumbFocus(x,y);
//--- Проверим и запомним состояние кнопки мыши
   CScroll::CheckMouseButtonState();
//--- Если управление передано полосе прокрутки, определим положение ползунка
   if(CScroll::State())
     {
      //--- Если ползунок переместили
      if(OnDragThumb(x))
        {
         //--- Изменяет номер позиции ползунка
         CalculateThumbPos();
         return(true);
        }
     }
   return(false);
  }
//+------------------------------------------------------------------+
//| Перемещает ползунок на указанную позицию                         |
//+------------------------------------------------------------------+
void CScrollH::MovingThumb(const int pos=WRONG_VALUE)
  {
//--- Выйти, если полоса прокрутки не нужна
   if(!IsScroll())
      return;
//--- Для проверки позиции ползунка
   uint check_pos=0;
//--- Скорректируем позицию в случае выхода из диапазона
   if(pos<0 || pos>m_items_total-m_visible_items_total)
      check_pos=m_items_total-m_visible_items_total;
   else
      check_pos=pos;
//--- Запомним позицию ползунка
   CScroll::CurrentPos(check_pos);
//--- Расчёт и установка координаты Y ползунка полосы прокрутки
   CalculateThumbX();
  }
//+------------------------------------------------------------------+
//| Расчёт координаты X ползунка                                     |
//+------------------------------------------------------------------+
void CScrollH::CalculateThumbX(void)
  {
//--- Определим текущую координату X ползунка
   double scroll_thumb_x=m_thumb_width+(CurrentPos()*m_thumb_step_size);
//--- Если выходим за пределы рабочей области влево
   if(scroll_thumb_x<=m_thumb_width)
     {
      scroll_thumb_x=m_thumb_width;
     }
//--- Если выходим за пределы рабочей области вправо
   if(scroll_thumb_x+m_thumb_length>=m_x_size-m_thumb_width || 
      CScroll::CurrentPos()>=m_thumb_steps_total-1)
     {
      scroll_thumb_x=int(m_x_size-m_thumb_width-m_thumb_length);
     }
//--- Обновим координату и отступ по оси X
   m_thumb_x=(int)scroll_thumb_x;
  }
//+------------------------------------------------------------------+
//| Изменение координаты Y элемента                                  |
//+------------------------------------------------------------------+
void CScrollH::YDistance(const int y)
  {
//--- Выйти, если нет указателя на главный элемент
   if(!CElement::CheckMainPointer())
      return;
//--- Обновим координату Y элемента...
   CElementBase::Y(CElement::CalculateY(y));
   CElementBase::YGap(y);
//--- ...и всех объектов полосы прокрутки
   m_canvas.Y(y);
   m_thumb_y=y;
//--- Установим координату объектам
   ::ObjectSetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_YDISTANCE,y);
//--- Обновим отступы у всех объектов элемента
   int y_gap=CElement::CalculateYGap(y);
   m_canvas.YGap(CElement::CalculateYGap(y));
  }
//+------------------------------------------------------------------+
//| Изменить длину полосы прокрутки                                  |
//+------------------------------------------------------------------+
void CScrollH::ChangeXSize(const int width)
  {
//--- Координаты и размеры
   int x=0,x_size=width-1;
//--- Изменить ширину элемента и фона
   CElementBase::XSize(x_size);
   m_canvas.XSize(x_size);
   m_canvas.Resize(x_size,m_y_size);
//--- Скорректировать положение кнопки декремента
   m_button_dec.Moving();
//--- Рассчитаем и установим размеры объектов полосы прокрутки
   CalculateThumbSize();
//--- Корректировка положения ползунка
   if(m_thumb_x+m_thumb_length>=m_x_size-m_thumb_length || m_thumb_x<m_thumb_width)
     {
      CalculateThumbX();
      CalculateThumbPos();
     }
  }
//+------------------------------------------------------------------+
//| Нажатие на переключателе влево                                   |
//+------------------------------------------------------------------+
bool CScrollH::OnClickScrollInc(const int id=WRONG_VALUE,const int index=WRONG_VALUE)
  {
//--- Проверить идентификатор и индекс элемента, если был внешний вызов
   uint check_id    =(id!=WRONG_VALUE)? id : CElementBase::Id();
   uint check_index =(index!=WRONG_VALUE)? index : CElementBase::Index();
//--- Выйти, если значения не совпадают
   if(check_id!=m_button_inc.Id() || check_index!=m_button_inc.Index())
      return(false);
//--- Выйдем, если (1) сейчас активен или (2) кол-во шагов неопределено
   if(CScroll::State() || m_thumb_steps_total<1)
      return(false);
//--- Уменьшим номер позиции полосы прокрутки
   if(CScroll::CurrentPos()>0)
      CScroll::m_current_pos--;
//--- Расчёт координты X полосы прокрутки
   CalculateThumbX();
//--- Отожмём кнопку
   m_button_inc.IsPressed(false);
   return(true);
  }
//+------------------------------------------------------------------+
//| Нажатие на переключателе вправо                                  |
//+------------------------------------------------------------------+
bool CScrollH::OnClickScrollDec(const int id=WRONG_VALUE,const int index=WRONG_VALUE)
  {
//--- Проверить идентификатор и индекс элемента, если был внешний вызов
   uint check_id    =(id!=WRONG_VALUE)? id : CElementBase::Id();
   uint check_index =(index!=WRONG_VALUE)? index : CElementBase::Index();
//--- Выйти, если значения не совпадают
   if(check_id!=m_button_inc.Id() || check_index!=m_button_dec.Index())
      return(false);
//--- Выйдем, если (1) сейчас активен или (2) кол-во шагов неопределено
   if(CScroll::State() || m_thumb_steps_total<1)
      return(false);
//--- Увеличим номер позиции полосы прокрутки
   if(CScroll::CurrentPos()<CScroll::m_thumb_steps_total-1)
      CScroll::m_current_pos++;
//--- Расчёт координаты X полосы прокрутки
   CalculateThumbX();
//--- Отожмём кнопку
   m_button_dec.IsPressed(false);
   return(true);
  }
//+------------------------------------------------------------------+
//| Перемещение ползунка                                             |
//+------------------------------------------------------------------+
bool CScrollH::OnDragThumb(const int x)
  {
//--- Для определения новой X координаты
   int new_x_point=0;
//--- Если полоса прокрутки неактивна, ...
   if(!CScroll::State())
     {
      //--- ...обнулим вспомогательные переменные для перемещения ползунка
      CScroll::m_thumb_size_fixing  =0;
      CScroll::m_thumb_point_fixing =0;
      return(false);
     }
//--- Если точка фиксации нулевая, то запомним текущую координаты курсора
   if(CScroll::m_thumb_point_fixing==0)
      CScroll::m_thumb_point_fixing=x;
//--- Если значение расстояния от крайней точки ползунка до текущей координаты курсора нулевое, рассчитаем его
   if(CScroll::m_thumb_size_fixing==0)
      CScroll::m_thumb_size_fixing=m_thumb_x-x;
//--- Если в нажатом состоянии прошли порог вправо
   if(x-CScroll::m_thumb_point_fixing>0)
     {
      //--- Рассчитаем координату X
      new_x_point=x+CScroll::m_thumb_size_fixing;
      //--- Обновление положения полосы прокрутки
      UpdateThumb(new_x_point);
      return(true);
     }
//--- Если в нажатом состоянии прошли порог влево
   if(x-CScroll::m_thumb_point_fixing<0)
     {
      //--- Рассчитаем координату X
      new_x_point=x-::fabs(CScroll::m_thumb_size_fixing);
      //--- Обновление положения полосы прокрутки
      UpdateThumb(new_x_point);
      return(true);
     }
//---
   return(false);
  }
//+------------------------------------------------------------------+
//| Обновление положения полосы прокрутки                            |
//+------------------------------------------------------------------+
void CScrollH::UpdateThumb(const int new_x_point)
  {
   int x=new_x_point;
//--- Обнуление точки фиксации
   CScroll::m_thumb_point_fixing=0;
//--- Проверка на выход из рабочей области вправо и корректировка значений
   if(new_x_point>m_x_size-m_thumb_width-m_thumb_length)
     {
      x=m_x_size-m_thumb_width-m_thumb_length;
      CScroll::CurrentPos(0);
     }
//--- Проверка на выход из рабочей области влево и корректировка значений
   if(new_x_point<=m_thumb_width)
     {
      x=m_thumb_width;
      CScroll::CurrentPos(int(m_thumb_steps_total));
     }
//--- Текущие координаты
   RedrawThumb(x);
  }
//+------------------------------------------------------------------+
//| Корректирует номер позиции ползунка                              |
//+------------------------------------------------------------------+
void CScrollH::CalculateThumbPos(void)
  {
//--- Выйти, если шаг равен нулю
   if(CScroll::m_thumb_step_size==0)
      return;
//--- Корректирует номер позиции полосы прокрутки
   double pos=(m_thumb_x-m_thumb_width)/m_thumb_step_size;
   CScroll::CurrentPos((int)::MathCeil(pos));
//--- Проверка на выход из рабочей области влево/вправо
   if(m_thumb_x+m_thumb_length>=m_x_size-m_thumb_width-1)
      CScroll::CurrentPos(int(m_thumb_steps_total-1));
   if(m_thumb_x<m_thumb_width)
      CScroll::CurrentPos(0);
  }
//+------------------------------------------------------------------+
//| Быстрая перерисовка ползунка полосы прокрутки                    |
//+------------------------------------------------------------------+
void CScrollH::RedrawThumb(const int x)
  {
//--- Текущие координаты
   int x1=0,y1=0,x2=0,y2=0;
   CalculateThumbBoundaries(x1,y1,x2,y2);
//--- Стереть текущее положение ползунка
   m_canvas.FillRectangle(x1,y1,x2-1,y2-1,m_back_color);
//--- Обновим координаты
   m_thumb_x=x;
   x2=x+m_thumb_length;
//--- Нарисовать новое положение ползунка
   m_canvas.FillRectangle(x1,y1,x2-1,y2-1,m_thumb_color_pressed);
  }
//+------------------------------------------------------------------+
