//+------------------------------------------------------------------+
//|                                                 DropCalendar.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "Calendar.mqh"
//+------------------------------------------------------------------+
//| Класс для создания выпадающего календаря                         |
//+------------------------------------------------------------------+
class CDropCalendar : public CElement
  {
private:
   //--- Объекты и элементы для создания элемента
   CTextEdit         m_date_box;
   CButton           m_drop_button;
   CCalendar         m_calendar;
   //---
public:
                     CDropCalendar(void);
                    ~CDropCalendar(void);
   //--- Методы для создания выпадающего календаря
   bool              CreateDropCalendar(const string text,const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const string text,const int x_gap,const int y_gap);
   bool              CreateDateBox(void);
   bool              CreateDropButton(void);
   bool              CreateCalendar(void);
   //---
public:
   //--- Возвращает указатели на элементы
   CTextEdit        *GetTextEditPointer(void)      { return(::GetPointer(m_date_box));    }
   CButton          *GetDropButtonPointer(void)    { return(::GetPointer(m_drop_button)); }
   CCalendar        *GetCalendarPointer(void)      { return(::GetPointer(m_calendar));    }
   //--- (1) Установить (выделить) и (2) получить выделенную дату
   void              SelectedDate(const datetime date);
   datetime          SelectedDate(void) { return(m_calendar.SelectedDate()); }
   //--- Изменение состояния видимости календаря на противоположное
   void              ChangeComboBoxCalendarState(void);
   //---
public:
   //--- Обработчик событий графика
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Рисует элемент
   virtual void      Draw(void);
   //---
private:
   //--- Обработка нажатия на кнопку комбо-бокса
   bool              OnClickButton(const string pressed_object,const int id,const int index);
   //--- Проверка нажатой левой кнопки мыши над кнопкой комбо-бокса
   void              CheckPressedOverButton(void);

  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CDropCalendar::CDropCalendar(void)
  {
//--- Сохраним имя класса элемента в базовом классе
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CDropCalendar::~CDropCalendar(void)
  {
  }
//+------------------------------------------------------------------+
//| Обработчик событий                                               |
//+------------------------------------------------------------------+
void CDropCalendar::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Обработка события перемещения курсора
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Проверка нажатой левой кнопки мыши над кнопкой комбо-бокса
      CheckPressedOverButton();
      return;
     }
//--- Обработка события выбора новой даты в календаре
   if(id==CHARTEVENT_CUSTOM+ON_CHANGE_DATE)
     {
      //--- Выйти, если идентификаторы элементов не совпадают
      if(lparam!=CElementBase::Id())
         return;
      //--- Установим новую дату в поле комбо-бокса
      m_date_box.SetValue(::TimeToString((datetime)dparam,TIME_DATE),false);
      m_date_box.GetTextBoxPointer().Update(true);
      return;
     }
//--- Обработка события нажатия на кнопке
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)
     {
      if(OnClickButton(sparam,(uint)lparam,(uint)dparam))
         return;
      //---
      return;
     }
  }
//+------------------------------------------------------------------+
//| Создаёт выпадающий календарь                                     |
//+------------------------------------------------------------------+
bool CDropCalendar::CreateDropCalendar(const string text,const int x_gap,const int y_gap)
  {
//--- Выйти, если нет указателя на главный элемент
   if(!CElement::CheckMainPointer())
      return(false);
//--- Инициализация свойств
   InitializeProperties(text,x_gap,y_gap);
//--- Создание элемента
   if(!CreateDateBox())
      return(false);
   if(!CreateDropButton())
      return(false);
   if(!CreateCalendar())
      return(false);
//--- Скрыть календарь
   m_calendar.Hide();
//--- Отобразить выделенную дату в календаре
   m_date_box.SetValue(::TimeToString((datetime)m_calendar.SelectedDate(),TIME_DATE));
   return(true);
  }
//+------------------------------------------------------------------+
//| Инициализация свойств                                            |
//+------------------------------------------------------------------+
void CDropCalendar::InitializeProperties(const string text,const int x_gap,const int y_gap)
  {
   m_x           =CElement::CalculateX(x_gap);
   m_y           =CElement::CalculateY(y_gap);
   m_label_text  =text;
//--- Цвета по умолчанию
   m_back_color  =(m_back_color!=clrNONE)? m_back_color : m_main.BackColor();
   m_label_color =(m_label_color!=clrNONE)? m_label_color : clrBlack;
   m_label_x_gap =(m_label_x_gap!=WRONG_VALUE)? m_label_x_gap : 0;
   m_label_y_gap =(m_label_y_gap!=WRONG_VALUE)? m_label_y_gap : 4;
//--- Отступы от крайней точки
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
//--- Приоритет, как у главного элемента, так как элемент не имеет своей области для нажатия
   CElement::Z_Order(m_main.Z_Order());
  }
//+------------------------------------------------------------------+
//| Создаёт поле ввода даты                                          |
//+------------------------------------------------------------------+
bool CDropCalendar::CreateDateBox(void)
  {
//--- Сохраним указатель на родительский элемент
   m_date_box.MainPointer(this);
//--- Свойства
   m_date_box.Index(0);
   m_date_box.NamePart("drop_calendar");
   m_date_box.XSize(m_x_size);
   m_date_box.YSize(m_y_size);
   m_date_box.LabelXGap(m_label_x_gap);
   m_date_box.LabelYGap(m_label_y_gap);
   m_date_box.Font(CElement::Font());
   m_date_box.FontSize(CElement::FontSize());
   m_date_box.GetTextBoxPointer().XSize(95);
   m_date_box.GetTextBoxPointer().TextYOffset(5);
   m_date_box.GetTextBoxPointer().ReadOnlyMode(true);
   m_date_box.GetTextBoxPointer().NamePart("date_box");
   m_date_box.GetTextBoxPointer().AnchorRightWindowSide(true);
//--- Установим объект
   if(!m_date_box.CreateTextEdit(m_label_text,0,0))
      return(false);
//--- Добавить элемент в массив
   CElement::AddToArray(m_date_box);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт кнопку комбо-бокса                                       |
//+------------------------------------------------------------------+
bool CDropCalendar::CreateDropButton(void)
  {
//--- Сохраним указатель на родительский элемент
   m_drop_button.MainPointer(m_date_box);
//--- Размеры
   int x_size=28;
//--- Координаты
   int x=x_size,y=0;
//--- Отступы для картинки
   int icon_x_gap =(m_drop_button.IconXGap()<1)? 4 : m_drop_button.IconXGap();
   int icon_y_gap =(m_drop_button.IconYGap()<1)? 2 : m_drop_button.IconYGap();
//--- Свойства
   m_drop_button.NamePart("drop_button");
   m_drop_button.TwoState(true);
   m_drop_button.XSize(x_size);
   m_drop_button.YSize(m_y_size);
   m_drop_button.IconXGap(icon_x_gap);
   m_drop_button.IconYGap(icon_y_gap);
   m_drop_button.AnchorRightWindowSide(true);
   m_drop_button.IconFile(RESOURCE_CALENDAR_DROP_OFF);
   m_drop_button.IconFileLocked(RESOURCE_CALENDAR_DROP_LOCKED);
   m_drop_button.CElement::IconFilePressed(RESOURCE_CALENDAR_DROP_ON);
   m_drop_button.CElement::IconFilePressedLocked(RESOURCE_CALENDAR_DROP_LOCKED);
//--- Создадим элемент управления
   if(!m_drop_button.CreateButton("",x,y))
      return(false);
//--- Установить приоритет
   m_drop_button.Z_Order(m_date_box.GetTextBoxPointer().Z_Order()+1);
//--- Добавить элемент в массив
   CElement::AddToArray(m_drop_button);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт список                                                   |
//+------------------------------------------------------------------+
bool CDropCalendar::CreateCalendar(void)
  {
//--- Сохраним указатель на главный элемент
   m_calendar.MainPointer(m_date_box);
//--- Координаты
   int x =m_date_box.GetTextBoxPointer().XGap();
   int y =m_y_size;
//--- Свойства
   m_calendar.IsDropdown(true);
   m_calendar.AnchorRightWindowSide(true);
//--- Создадим элемент управления
   if(!m_calendar.CreateCalendar(x,y))
      return(false);
//--- Добавить элемент в массив
   CElement::AddToArray(m_calendar);
   return(true);
  }
//+------------------------------------------------------------------+
//| Установка новой даты в календарь                                 |
//+------------------------------------------------------------------+
void CDropCalendar::SelectedDate(const datetime date)
  {
//--- Установим и запомним дату
   m_calendar.SelectedDate(date);
//--- Отобразим дату в поле ввода комбо-бокса
   m_date_box.LabelText(::TimeToString(date,TIME_DATE));
  }
//+------------------------------------------------------------------+
//| Изменение состояния видимости календаря на противоположное       |
//+------------------------------------------------------------------+
void CDropCalendar::ChangeComboBoxCalendarState(void)
  {
//--- Если календарь открыт, спрячем его
   if(m_calendar.IsVisible())
      {
       m_calendar.Hide();
      //--- Отправим сообщение на определение доступных элементов
      ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),1,"");
      //--- Отправим сообщение об изменении в графическом интерфейсе
      ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
      }
//--- Если календарь скрыт, откроем его
   else
      {
       m_calendar.Show();
       m_calendar.GetComboBoxPointer().Show();
       m_calendar.GetComboBoxPointer().GetButtonPointer().Show();
      //--- Отправим сообщение на определение доступных элементов
      ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),0,"");
      //--- Отправим сообщение об изменении в графическом интерфейсе
      ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
      }
  }
//+------------------------------------------------------------------+
//| Нажатие на кнопку комбо-бокса                                    |
//+------------------------------------------------------------------+
bool CDropCalendar::OnClickButton(const string pressed_object,const int id,const int index)
  {
//--- Выйдем, если нажатие было не на этом элементе
   if(!m_drop_button.CheckElementName(pressed_object))
      return(false);
//--- Выйти, если значения не совпадают
   if(id!=m_drop_button.Id() || index!=m_drop_button.Index())
      return(false);
//--- Изменить состояние видимости календаря на противоположное
   ChangeComboBoxCalendarState();
//--- Отправим сообщение об этом
   ::EventChartCustom(m_chart_id,ON_CLICK_COMBOBOX_BUTTON,CElementBase::Id(),0,"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Проверка нажатой левой кнопки мыши над кнопкой                   |
//+------------------------------------------------------------------+
void CDropCalendar::CheckPressedOverButton(void)
  {
//--- Выйти, если (1) левая кнопка мыши или (2) кнопка вызова календаря отжаты
   if(!m_mouse.LeftButtonState() || !m_drop_button.IsPressed())
      return;
//--- Если нет фокуса на элементе
   if(!CElementBase::MouseFocus())
     {
      //--- Выйти, если фокус на календаре
      if(m_calendar.MouseFocus())
         return;
      //--- Выйти, если полоса прокрутки списка месяцев календаря в действии
      if(m_calendar.GetComboBoxPointer().GetScrollVPointer().State())
         return;
      //--- Скрыть календарь и сбросить цвета объектов
      m_calendar.Hide();
      m_drop_button.IsPressed(false);
      m_drop_button.Update(true);
      //--- Отправим сообщение на определение доступных элементов
      ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),1,"");
      //--- Отправим сообщение об изменении в графическом интерфейсе
      ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0.0,"");
     }
  }
//+------------------------------------------------------------------+
//| Рисует элемент                                                   |
//+------------------------------------------------------------------+
void CDropCalendar::Draw(void)
  {
//--- Нарисовать фон
   DrawBackground();
//--- Нарисовать текст
   CElement::DrawText();
  }
//+------------------------------------------------------------------+
