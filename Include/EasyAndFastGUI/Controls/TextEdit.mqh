//+------------------------------------------------------------------+
//|                                                     TextEdit.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "TextBox.mqh"
class CCalendar;
//+------------------------------------------------------------------+
//| Класс для создания текстового поля ввода                         |
//+------------------------------------------------------------------+
class CTextEdit : public CElement
  {
private:
   //--- Объекты для создания поля ввода
   CTextBox          m_edit;
   CButton           m_button_inc;
   CButton           m_button_dec;
   //--- Режим элемента с чек-боксом
   bool              m_checkbox_mode;
   //--- Режим числового поля ввода с кнопками
   bool              m_spin_edit_mode;
   //--- Текущее значение в поле ввода
   string            m_edit_value;
   //--- Режим сброса значения (пустая строка)
   bool              m_reset_mode;
   //--- Минимальное/максимальное значение
   double            m_min_value;
   double            m_max_value;
   //--- Шаг для изменения значения в поле ввода
   double            m_step_value;
   //--- Счётчик таймера для перемотки списка
   int               m_timer_counter;
   //--- Количество знаков после запятой
   int               m_digits;
   //---
public:
                     CTextEdit(void);
                    ~CTextEdit(void);
   //--- Методы для создания текствого поля ввода
   bool              CreateTextEdit(const string text,const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const string text,const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   bool              CreateEdit(void);
   bool              CreateSpinButton(CButton &button_obj,const int index);
   //---
public:
   //--- Возвращает указатели на составные элементы
   CTextBox         *GetTextBoxPointer(void)                 { return(::GetPointer(m_edit));       }
   CButton          *GetIncButtonPointer(void)               { return(::GetPointer(m_button_inc)); }
   CButton          *GetDecButtonPointer(void)               { return(::GetPointer(m_button_dec)); }
   //--- Режим сброса при нажатии на текстовой метке
   bool              ResetMode(void)                   const { return(m_reset_mode);               }
   void              ResetMode(const bool mode)              { m_reset_mode=mode;                  }
   //--- (1) Режимы чек-бокса и (2) числового поля ввода
   void              CheckBoxMode(const bool state)          { m_checkbox_mode=state;              }
   bool              SpinEditMode(void)                const { return(m_spin_edit_mode);           }
   void              SpinEditMode(const bool state)          { m_spin_edit_mode=state;             }
   //--- Минимальное значение
   double            MinValue(void)                    const { return(m_min_value);                }
   void              MinValue(const double value)            { m_min_value=value;                  }
   //--- Максимальное значение
   double            MaxValue(void)                    const { return(m_max_value);                }
   void              MaxValue(const double value)            { m_max_value=value;                  }
   //--- (1) Шаг значения, (2) установка количества знаков после запятой
   double            StepValue(void)                   const { return(m_step_value);               }
   void              StepValue(const double value)           { m_step_value=(value<=0)? 1 : value; }
   int               GetDigits(void)                   const { return(m_digits);                   }
   void              SetDigits(const int digits)             { m_digits=::fabs(digits);            }
   //--- Состояние элемента (нажат/отжат)
   bool              IsPressed(void) const { return(m_is_pressed); }
   void              IsPressed(const bool state);
   //--- Возвращение и установка значения поля ввода
   string            GetValue(void) { return(m_edit.GetValue(0)); }
   void              SetValue(const string value,const bool is_size_adjustment=true);
   //---
public:
   //--- Обработчик событий графика
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Таймер
   virtual void      OnEventTimer(void);
   //--- Блокировка
   virtual void      IsLocked(const bool state);
   //--- Рисует элемент
   virtual void      Draw(void);
   //---
private:
   //--- Обработка нажатия на элементе
   bool              OnClickElement(const string clicked_object);
   //--- Обработка окончания ввода значения
   bool              OnEndEdit(const uint id);
   //--- Обработка нажатия кнопок поля ввода
   bool              OnClickButtonInc(const string pressed_object,const uint id,const uint index);
   bool              OnClickButtonDec(const string pressed_object,const uint id,const uint index);
   //--- Ускоренная перемотка значений в поле ввода
   void              FastSwitching(void);

   //--- Корректировка значения
   string            AdjustmentValue(const double value);
   //--- Подсвечивание лимита
   void              HighlightLimit(void);

   //--- Рисует картинку
   virtual void      DrawImage(void);
   //--- Изменить ширину по правому краю окна
   virtual void      ChangeWidthByRightWindowSide(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTextEdit::CTextEdit(void) : m_edit_value(""),
                             m_digits(0),
                             m_min_value(DBL_MIN),
                             m_max_value(DBL_MAX),
                             m_step_value(1),
                             m_reset_mode(false),
                             m_checkbox_mode(false),
                             m_spin_edit_mode(false),
                             m_timer_counter(SPIN_DELAY_MSC)

  {
//--- Сохраним имя класса элемента в базовом классе
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CTextEdit::~CTextEdit(void)
  {
  }
//+------------------------------------------------------------------+
//| Обработка событий                                                |
//+------------------------------------------------------------------+
void CTextEdit::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Обработка события перемещения курсора
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Проверка фокуса над элементами
      m_edit.MouseFocus(m_mouse.X()>m_edit.X() && m_mouse.X()<m_edit.X2() && 
                        m_mouse.Y()>m_edit.Y() && m_mouse.Y()<m_edit.Y2());
      //--- Перерисовать элемент
      if(CheckCrossingBorder())
         Update(true);
      //---
      return;
     }
//--- Обработка события нажатия левой кнопки мыши на объекте
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      //--- Обработка нажатия на элементе
      if(OnClickElement(sparam))
         return;
      //---
      return;
     }
//--- Обработка ввода нового значения
   if(id==CHARTEVENT_CUSTOM+ON_END_EDIT)
     {
      //--- Обработка нажатия на элементе
      if(OnEndEdit((uint)lparam))
         return;
      //---
      return;
     }
//--- Выйти, если отключен режим числового поля ввода
   if(!m_spin_edit_mode)
      return;
//--- Обработка события нажатия левой кнопки мыши на объекте
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)
     {
      //--- Обработка нажатия на кнопке инкремента
      if(OnClickButtonInc(sparam,(uint)lparam,(uint)dparam))
         return;
      //--- Обработка нажатия на кнопке декремента
      if(OnClickButtonDec(sparam,(uint)lparam,(uint)dparam))
         return;
      //---
      return;
     }
  }
//+------------------------------------------------------------------+
//| Таймер                                                           |
//+------------------------------------------------------------------+
void CTextEdit::OnEventTimer(void)
  {
//--- Ускоренная перемотка значений
   FastSwitching();
  }
//+------------------------------------------------------------------+
//| Создаёт группу объектов текстового поля ввода                    |
//+------------------------------------------------------------------+
bool CTextEdit::CreateTextEdit(const string text,const int x_gap,const int y_gap)
  {
//--- Выйти, если нет указателя на главный элемент
   if(!CElement::CheckMainPointer())
      return(false);
//--- Инициализация свойств
   InitializeProperties(text,x_gap,y_gap);
//--- Создание элемента
   if(!CreateCanvas())
      return(false);
   if(!CreateEdit())
      return(false);
   if(!CreateSpinButton(m_button_inc,0))
      return(false);
   if(!CreateSpinButton(m_button_dec,1))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Инициализация свойств                                            |
//+------------------------------------------------------------------+
void CTextEdit::InitializeProperties(const string text,const int x_gap,const int y_gap)
  {
   m_x          =CElement::CalculateX(x_gap);
   m_y          =CElement::CalculateY(y_gap);
   m_x_size     =(m_x_size<1 || m_auto_xresize_mode)? m_main.X2()-m_x-m_auto_xresize_right_offset : m_x_size;
   m_y_size     =(m_y_size<1)? 20 : m_y_size;
   m_label_text =text;
//--- Свойства по умолчанию
   m_back_color          =(m_back_color!=clrNONE)? m_back_color : m_main.BackColor();
   m_icon_y_gap          =(m_icon_y_gap!=WRONG_VALUE)? m_icon_y_gap : 4;
   m_label_x_gap         =(m_label_x_gap!=WRONG_VALUE)? m_label_x_gap : (m_checkbox_mode)? 18 : 0;
   m_label_y_gap         =(m_label_y_gap!=WRONG_VALUE)? m_label_y_gap : 4;
   m_label_color         =(m_label_color!=clrNONE)? m_label_color : clrBlack;
   m_label_color_hover   =(m_label_color_hover!=clrNONE)? m_label_color_hover : C'0,120,215';
   m_label_color_locked  =(m_label_color_locked!=clrNONE)? m_label_color_locked : clrSilver;
   m_label_color_pressed =(m_label_color_pressed!=clrNONE)? m_label_color_pressed : clrBlack;
//--- Отступы от крайней точки
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
  }
//+------------------------------------------------------------------+
//| Создаёт объект для рисования                                     |
//+------------------------------------------------------------------+
bool CTextEdit::CreateCanvas(void)
  {
//--- Формирование имени объекта
   string name=CElementBase::ElementName("text_edit");
//--- Создание объекта
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт поле ввода                                               |
//+------------------------------------------------------------------+
bool CTextEdit::CreateEdit(void)
  {
//--- Сохранить указатель главного элемента
   m_edit.MainPointer(this);
//--- Размеры
   int x_size=(m_edit.XSize()<1)? 80 : m_edit.XSize();
//--- Координаты
   int x =(m_edit.XGap()<1)? x_size : m_edit.XGap();
   int y =0;
//--- Если нужен элемент с чек-боксом
   if(m_checkbox_mode)
     {
      IconFile(RESOURCE_CHECKBOX_OFF);
      IconFileLocked(RESOURCE_CHECKBOX_OFF_LOCKED);
      IconFilePressed(RESOURCE_CHECKBOX_ON);
      IconFilePressedLocked(RESOURCE_CHECKBOX_ON_LOCKED);
     }
//--- Установим свойства перед созданием
   if(m_index!=WRONG_VALUE)
      m_edit.Index(m_index);
//---
   m_edit.XSize(x_size);
   m_edit.YSize(m_y_size);
   m_edit.TextYOffset(5);
   m_edit.Font(CElement::Font());
   m_edit.FontSize(CElement::FontSize());
   m_edit.IsDropdown(CElementBase::IsDropdown());
//--- Установим объект
   if(!m_edit.CreateTextBox(x,y))
      return(false);
//--- Добавить элемент в массив
   CElement::AddToArray(m_edit);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт кнопки поля ввода вверх и ввниз                          |
//+------------------------------------------------------------------+
bool CTextEdit::CreateSpinButton(CButton &button_obj,const int index)
  {
//--- Сохраним указатель на главный элемент
   button_obj.MainPointer(m_edit);
//--- Выйти, если режим числового поля ввода отключен
   if(!m_spin_edit_mode)
      return(true);
//--- Размеры
   int x_size=15,y_size=0;
//--- Координаты
   int x=x_size+1,y=0;
//--- Файлы
   string file="",file_locked="",file_pressed="";
//--- Кнопка вверх
   if(index==0)
     {
      y      =1;
      y_size =m_edit.YSize()/2;
      //--- 
      file         =(string)RESOURCE_SPIN_INC;
      file_locked  =(string)RESOURCE_SPIN_INC;
      file_pressed =(string)RESOURCE_SPIN_INC;
      //---
      button_obj.NamePart(button_obj.NamePart()==""? "spin_inc" : button_obj.NamePart());
      button_obj.AnchorRightWindowSide(true);
      //--- Индекс элемента
      button_obj.Index((m_index!=WRONG_VALUE)? m_index*2 : 0);
     }
//--- Кнопка вниз
   else
     {
      y      =m_button_inc.YGap()+m_button_inc.YSize()-1;
      y_size =m_edit.Y2()-m_button_inc.Y2();
      //---
      file         =(string)RESOURCE_SPIN_DEC;
      file_locked  =(string)RESOURCE_SPIN_DEC;
      file_pressed =(string)RESOURCE_SPIN_DEC;
      //---
      button_obj.NamePart(button_obj.NamePart()==""? "spin_dec" : button_obj.NamePart());
      button_obj.AnchorRightWindowSide(true);
      button_obj.AnchorBottomWindowSide(true);
      //--- Индекс элемента
      button_obj.Index((m_index!=WRONG_VALUE)? m_button_inc.Index()+1 : 1);
     }
//--- 
   color back_color         =(button_obj.BackColor()!=clrNONE)? button_obj.BackColor() : m_edit.BackColor();
   color back_color_hover   =(button_obj.BackColorHover()!=clrNONE)? button_obj.BackColorHover() : C'225,225,225';
   color back_color_pressed =(button_obj.BackColorPressed()!=clrNONE)? button_obj.BackColorPressed() : clrLightGray;
//--- Установим свойства перед созданием
   button_obj.XSize(x_size);
   button_obj.YSize(y_size);
   button_obj.IconXGap(5);
   button_obj.IconYGap(3);
   button_obj.BackColor(back_color);
   button_obj.BackColorHover(back_color_hover);
   button_obj.BackColorLocked(clrLightGray);
   button_obj.BackColorPressed(back_color_pressed);
   button_obj.BorderColor(back_color);
   button_obj.BorderColorHover(back_color_hover);
   button_obj.BorderColorLocked(clrLightGray);
   button_obj.BorderColorPressed(back_color_pressed);
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
//| Установка состояния элемента (нажат/отжат)                       |
//+------------------------------------------------------------------+
void CTextEdit::IsPressed(const bool state)
  {
//--- Выйти, если (1) элемент заблокирован или (2) элемент уже в таком состоянии
   if(CElementBase::IsLocked() || m_is_pressed==state)
      return;
//--- Установка состояния
   m_is_pressed=state;
//--- Установить соответствующую картинку
   CElement::ChangeImage(0,!m_is_pressed? 0 : 2);
  }
//+------------------------------------------------------------------+
//| Установка значения в поле ввода                                  |
//+------------------------------------------------------------------+
void CTextEdit::SetValue(const string value,const bool is_size_adjustment=true)
  {
//--- Очистить поле ввода
   m_edit.ClearTextBox();
//--- Добавить новое значение
   if(!m_spin_edit_mode)
      m_edit.AddText(0,value);
   else
      m_edit.AddText(0,AdjustmentValue(::StringToDouble(value)));
//--- Корректировка размеров поля ввода, если указано
   if(is_size_adjustment)
     {
      m_edit.CorrectSize();
     }
  }
//+------------------------------------------------------------------+
//| Корректировка значения                                           |
//+------------------------------------------------------------------+
string CTextEdit::AdjustmentValue(const double value)
  {
//--- Для корректировки
   double corrected_value=0.0;
//--- Скорректируем с учетом шага
   corrected_value=::MathRound(value/m_step_value)*m_step_value;
//--- Проверка на минимум/максимум
   if(corrected_value<m_min_value)
      corrected_value=m_min_value;
   if(corrected_value>m_max_value)
      corrected_value=m_max_value;
//--- Если значение было изменено
   if(::StringToDouble(m_edit_value)!=corrected_value || m_edit_value=="")
      m_edit_value=::DoubleToString(corrected_value,m_digits);
//--- Значение без изменений
   return(m_edit_value);
  }
//+------------------------------------------------------------------+
//| Блокировка                                                       |
//+------------------------------------------------------------------+
void CTextEdit::IsLocked(const bool state)
  {
   CElement::IsLocked(state);
//--- Установить соответствующую картинку
   CElement::ChangeImage(0,(m_is_locked)? !m_is_pressed? 1 : 3 : !m_is_pressed? 0 : 2);
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на элементе                                    |
//+------------------------------------------------------------------+
bool CTextEdit::OnClickElement(const string clicked_object)
  {
//--- Выйдем, если (1) элемент заблокирован или (2) чужое имя объекта
   if(CElementBase::IsLocked() || m_canvas.ChartObjectName()!=clicked_object)
      return(false);
//--- Если включен режим сброса значения
   if(m_reset_mode)
      SetValue("");
//--- Если чек-бокс включен
   if(m_checkbox_mode)
     {
      //--- Переключить на противоположное состояние
      IsPressed(!(IsPressed()));
      //--- Нарисовать элемент
      Update(true);
      //--- Отправим сообщение об этом
      ::EventChartCustom(m_chart_id,ON_CLICK_CHECKBOX,CElementBase::Id(),CElementBase::Index(),"");
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на элементе                                    |
//+------------------------------------------------------------------+
bool CTextEdit::OnEndEdit(const uint id)
  {
//--- Выйдем, если идентификаторы не совпадают
   if(id!=CElementBase::Id())
      return(false);
//--- Установить значение
   SetValue(m_edit.GetValue());
//--- Обновить поле ввода
   m_edit.Update(true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Нажатие на переключатель инкремента                              |
//+------------------------------------------------------------------+
bool CTextEdit::OnClickButtonInc(const string pressed_object,const uint id,const uint index)
  {
//--- Выйдем, если нажатие было не на кнопке
   if(::StringFind(pressed_object,m_program_name+"_spin_inc")<0)
      return(false);
//--- Выйдем, если идентификаторы и индексы не совпадают
   if(id!=CElementBase::Id() || index!=m_button_inc.Index())
      return(false);
//--- Получим новое значение
   double value=::StringToDouble(m_edit.GetValue())+m_step_value;
//--- Увеличим на один шаг и проверим на выход за ограничение
   SetValue(::DoubleToString(value),false);
//--- Отожмём кнопку
   m_button_inc.IsPressed(false);
//--- Обновить поле ввода
   m_edit.Update(true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Нажатие на переключатель декремента                              |
//+------------------------------------------------------------------+
bool CTextEdit::OnClickButtonDec(const string pressed_object,const uint id,const uint index)
  {
//--- Выйдем, если нажатие было не на кнопке
   if(::StringFind(pressed_object,m_program_name+"_spin_dec")<0)
      return(false);
//--- Выйдем, если идентификаторы и индексы не совпадают
   if(id!=CElementBase::Id() || index!=m_button_dec.Index())
      return(false);
//--- Получим текущее значение
   double value=::StringToDouble(m_edit.GetValue())-m_step_value;
//--- Уменьшим на один шаг и проверим на выход за ограничение
   SetValue(::DoubleToString(value),false);
//--- Отожмём кнопку
   m_button_dec.IsPressed(false);
//--- Обновить поле ввода
   m_edit.Update(true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Ускоренная промотка значения в поле ввода                        |
//+------------------------------------------------------------------+
void CTextEdit::FastSwitching(void)
  {
//--- Выйдем, если (1) нет фокуса на элементе или (2) элемент является частью календаря
   if(!CElementBase::MouseFocus() || dynamic_cast<CCalendar*>(m_main)!=NULL)
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
      //--- Получим текущее значение в поле ввода
      double current_value=::StringToDouble(m_edit.GetValue());
      //--- Если увеличить 
      if(m_button_inc.MouseFocus())
        {
         SetValue(::DoubleToString(current_value+m_step_value),false);
         m_edit.Update(true);
         //--- Отправим сообщение об этом
         ::EventChartCustom(m_chart_id,ON_CLICK_INC,CElementBase::Id(),m_button_inc.Index(),"");
        }
      //--- Если уменьшить
      else if(m_button_dec.MouseFocus())
        {
         SetValue(::DoubleToString(current_value-m_step_value),false);
         m_edit.Update(true);
         //--- Отправим сообщение об этом
         ::EventChartCustom(m_chart_id,ON_CLICK_DEC,CElementBase::Id(),m_button_dec.Index(),"");
        }
     }
  }
//+------------------------------------------------------------------+
//| Рисует элемент                                                   |
//+------------------------------------------------------------------+
void CTextEdit::Draw(void)
  {
//--- Нарисовать фон
   CElement::DrawBackground();
//--- Нарисовать картинку
   CElement::DrawImage();
//--- Нарисовать текст
   CElement::DrawText();
  }
//+------------------------------------------------------------------+
//| Рисует картинку                                                  |
//+------------------------------------------------------------------+
void CTextEdit::DrawImage(void)
  {
//--- Выйти, если (1) чек-бокс не нужен или (2) картинка не определена
   if(!m_checkbox_mode || CElement::IconFile()=="")
      return;
//--- Определим индекс
   uint image_index=(m_is_pressed)? 2 : 0;
//--- Если элемент не заблокирован
   if(!CElementBase::IsLocked())
     {
      if(CElementBase::MouseFocus())
         image_index=(m_is_pressed)? 2 : 0;
     }
   else
      image_index=(m_is_pressed)? 3 : 1;
//--- Установить соответствующую картинку
   CElement::ChangeImage(0,image_index);
//--- Рисуем картинку
   CElement::DrawImage();
  }
//+------------------------------------------------------------------+
//| Изменить ширину по правому краю формы                            |
//+------------------------------------------------------------------+
void CTextEdit::ChangeWidthByRightWindowSide(void)
  {
//--- Выйти, если включен режим фиксации к правому краю формы
   if(m_anchor_right_window_side)
      return;
//--- Координаты и размеры
   int x=0,x_size=0;
//--- Рассчитать и установить новый размер фону элемента
   x_size=m_main.X2()-m_canvas.X()-m_auto_xresize_right_offset;
   CElementBase::XSize(x_size);
   m_canvas.XSize(x_size);
   m_canvas.Resize(x_size,m_y_size);
//--- Перерисовать элемент
   Draw();
//--- Обновить положение объектов
   Moving();
  }
//+------------------------------------------------------------------+
