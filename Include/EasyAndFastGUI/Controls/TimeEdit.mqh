//+------------------------------------------------------------------+
//|                                                     TimeEdit.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "TextEdit.mqh"
//+------------------------------------------------------------------+
//| Класс для создания элемента "Время"                              |
//+------------------------------------------------------------------+
class CTimeEdit : public CElement
  {
private:
   //--- Объекты для создания элемента
   CTextEdit         m_hours;
   CTextEdit         m_minutes;
   //--- Режим сброса значения
   bool              m_reset_mode;
   //--- Режим элемента с чек-боксом
   bool              m_checkbox_mode;
   //---
public:
                     CTimeEdit(void);
                    ~CTimeEdit(void);
   //--- Методы для создания элемента
   bool              CreateTimeEdit(const string text,const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const string text,const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   bool              CreateSpinEdit(CTextEdit &edit_obj,const int index);
   //---
public:
   //--- (1) Возвращает указатели полей ввода, (2) возвращение/установка состояния доступности элемента
   CTextEdit        *GetHoursEditPointer(void)        { return(::GetPointer(m_hours));     }
   CTextEdit        *GetMinutesEditPointer(void)      { return(::GetPointer(m_minutes));   }
   //--- (1) Режим сброса при нажатии на текстовой метке, (2) режим элемента с чек-боксом
   bool              ResetMode(void)                  { return(m_reset_mode);              }
   void              ResetMode(const bool mode)       { m_reset_mode=mode;                 }
   void              CheckBoxMode(const bool state)   { m_checkbox_mode=state;             }
   //--- Возвращение и установка значений полей ввода
   int               GetHours(void)                   { return((int)m_hours.GetValue());   }
   int               GetMinutes(void)                 { return((int)m_minutes.GetValue()); }
   void              SetHours(const uint value)       { m_hours.SetValue((string)value);   }
   void              SetMinutes(const uint value)     { m_minutes.SetValue((string)value); }
   //--- Состояние элемента (нажат/отжат)
   bool              IsPressed(void) const { return(m_is_pressed); }
   void              IsPressed(const bool state);
   //---
public:
   //--- Обработчик событий графика
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Блокировка
   virtual void      IsLocked(const bool state);
   //--- Рисует элемент
   virtual void      Draw(void);
   //---
private:
   //--- Обработка нажатия на элементе
   bool              OnClickElement(const string clicked_object);
   //--- Рисует картинку
   virtual void      DrawImage(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTimeEdit::CTimeEdit(void) : m_reset_mode(false)

  {
//--- Сохраним имя класса элемента в базовом классе
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CTimeEdit::~CTimeEdit(void)
  {
  }
//+------------------------------------------------------------------+
//| Обработка событий                                                |
//+------------------------------------------------------------------+
void CTimeEdit::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Обработка события перемещения курсора
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Перерисовать элемент
      if(CheckCrossingBorder())
         Update(true);
      //---
      return;
     }
//--- Обработка события нажатия левой кнопки мыши на элементе
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      if(OnClickElement(sparam))
         return;
      //---
      return;
     }
  }
//+------------------------------------------------------------------+
//| Создаёт элемент управления "Время"                               |
//+------------------------------------------------------------------+
bool CTimeEdit::CreateTimeEdit(const string text,const int x_gap,const int y_gap)
  {
//--- Выйти, если нет указателя на главный элемент
   if(!CElement::CheckMainPointer())
      return(false);
//--- Инициализация свойств
   InitializeProperties(text,x_gap,y_gap);
//--- Создание элемента
   if(!CreateCanvas())
      return(false);
   if(!CreateSpinEdit(m_minutes,0))
      return(false);
   if(!CreateSpinEdit(m_hours,1))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Инициализация свойств                                            |
//+------------------------------------------------------------------+
void CTimeEdit::InitializeProperties(const string text,const int x_gap,const int y_gap)
  {
   m_x          =CElement::CalculateX(x_gap);
   m_y          =CElement::CalculateY(y_gap);
   m_x_size     =(m_x_size<1)? 100 : m_x_size;
   m_y_size     =(m_y_size<1)? 20 : m_y_size;
   m_label_text =text;
//--- Цвет фона по умолчанию
   m_back_color =(m_back_color!=clrNONE)? m_back_color : m_main.BackColor();
   m_icon_y_gap =(m_icon_y_gap!=WRONG_VALUE)? m_icon_y_gap : 4;
//--- Отступы и цвет текстовой метки
   m_label_x_gap         =(m_label_x_gap!=WRONG_VALUE)? m_label_x_gap : 0;
   m_label_y_gap         =(m_label_y_gap!=WRONG_VALUE)? m_label_y_gap : 3;
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
bool CTimeEdit::CreateCanvas(void)
  {
//--- Формирование имени объекта
   string name=CElementBase::ElementName("time_edit");
//--- Если нужен элемент с чек-боксом
   if(m_checkbox_mode)
     {
      IconFile(RESOURCE_CHECKBOX_OFF);
      IconFileLocked(RESOURCE_CHECKBOX_OFF_LOCKED);
      IconFilePressed(RESOURCE_CHECKBOX_ON);
      IconFilePressedLocked(RESOURCE_CHECKBOX_ON_LOCKED);
     }
//--- Создание объекта
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт поля ввода для часов и минут                             |
//+------------------------------------------------------------------+
bool CTimeEdit::CreateSpinEdit(CTextEdit &edit_obj,const int index)
  {
//--- Сохраним указатель на главный элемент
   edit_obj.MainPointer(this);
//--- Координаты
   int x=0,y=0;
//--- Размеры
   int x_size=40;
//--- Поле ввода для минут
   if(index==0)
     {
      x=x_size;
      //--- Максимальное значение
      edit_obj.MaxValue(59);
      //--- Индекс элемента
      edit_obj.Index(0);
     }
//--- Поле ввода для часов
   else
     {
      x=x_size*2;
      //--- Максимальное значение
      edit_obj.MaxValue(23);
      //--- Индекс элемента
      edit_obj.Index(1);
     }
//--- Установим свойства перед созданием
   edit_obj.XSize(x_size);
   edit_obj.YSize(m_y_size);
   edit_obj.MinValue(0);
   edit_obj.StepValue(1);
   edit_obj.SpinEditMode(true);
   edit_obj.AnchorRightWindowSide(true);
   edit_obj.GetTextBoxPointer().XGap(1);
   edit_obj.GetTextBoxPointer().XSize(x_size-1);
   edit_obj.IsDropdown(CElementBase::IsDropdown());
//--- Создадим элемент управления
   if(!edit_obj.CreateTextEdit("",x,y))
      return(false);
//--- Добавить элемент в массив
   CElement::AddToArray(edit_obj);
   return(true);
  }
//+------------------------------------------------------------------+
//| Показать элемент                                                 |
//+------------------------------------------------------------------+
void CTimeEdit::IsLocked(const bool state)
  {
   CElement::IsLocked(state);
//--- Установить соответствующую картинку
   CElement::ChangeImage(0,(m_is_locked)? !m_is_pressed? 1 : 3 : !m_is_pressed? 0 : 2);
  }
//+------------------------------------------------------------------+
//| Установка состояния элемента (нажат/отжат)                       |
//+------------------------------------------------------------------+
void CTimeEdit::IsPressed(const bool state)
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
//| Обработка нажатия на элементе                                    |
//+------------------------------------------------------------------+
bool CTimeEdit::OnClickElement(const string clicked_object)
  {
//--- Выйдем, если (1) элемент заблокирован или (2) чужое имя объекта
   if(CElementBase::IsLocked() || m_canvas.ChartObjectName()!=clicked_object)
      return(false);
//--- Если чек-бокс не используется
   if(!m_checkbox_mode)
      return(true);
//--- Переключить на противоположный режим
   IsPressed(!(IsPressed()));
//--- Нарисовать элемент
   Update(true);
//--- Отправим сообщение об этом
   ::EventChartCustom(m_chart_id,ON_CLICK_CHECKBOX,CElementBase::Id(),CElementBase::Index(),"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Рисует элемент                                                   |
//+------------------------------------------------------------------+
void CTimeEdit::Draw(void)
  {
//--- Нарисовать фон
   CElement::DrawBackground();
//--- Нарисовать картинку
   CTimeEdit::DrawImage();
//--- Нарисовать текст
   CElement::DrawText();
  }
//+------------------------------------------------------------------+
//| Рисует картинку                                                  |
//+------------------------------------------------------------------+
void CTimeEdit::DrawImage(void)
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
