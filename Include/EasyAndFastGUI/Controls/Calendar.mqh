//+------------------------------------------------------------------+
//|                                                     Calendar.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "TextEdit.mqh"
#include "ComboBox.mqh"
#include "Button.mqh"
#include "ButtonsGroup.mqh"
#include <Tools\DateTime.mqh>
//--- Количество дней в таблице
#define DAYS_TOTAL 42
//+------------------------------------------------------------------+
//| Класс для создания календаря                                     |
//+------------------------------------------------------------------+
class CCalendar : public CElement
  {
private:
   //--- Элементы для создания календаря
   CButton           m_month_dec;
   CButton           m_month_inc;
   CComboBox         m_months;
   CTextEdit         m_years;
   CButtonsGroup     m_days;
   CButton           m_button_today;
   //--- Экзепляры структуры для работы с датами и временем:
   CDateTime         m_date;      // выделенная пользователем дата
   CDateTime         m_today;     // текущая (локальная на компьютере пользователя) дата
   CDateTime         m_temp_date; // экземпляр для расчётов и проверок
   //--- Цвет пункта текущего дня
   color             m_today_color;
   //--- Цвет разделительной линии
   color             m_sepline_color;
   //--- Счётчик таймера для перемотки списка
   int               m_timer_counter;
   //---
public:
                     CCalendar(void);
                    ~CCalendar(void);
   //--- Методы для создания календаря
   bool              CreateCalendar(const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   bool              CreateMonthArrow(CButton &button_obj,const int index);
   bool              CreateMonthsList(void);
   bool              CreateYearsSpinEdit(void);
   bool              CreateDaysMonth(void);
   bool              CreateButtonToday(void);
   //---
public:
   //--- Возвращает указатели на элементы календаря
   CButton          *GetMonthDecPointer(void)              { return(::GetPointer(m_month_dec));    }
   CButton          *GetMonthIncPointer(void)              { return(::GetPointer(m_month_inc));    }
   CComboBox        *GetComboBoxPointer(void)              { return(::GetPointer(m_months));       }
   CTextEdit        *GetSpinEditPointer(void)              { return(::GetPointer(m_years));        }
   CButton          *GetTodayButtonPointer(void)           { return(::GetPointer(m_button_today)); }
   CButtonsGroup    *GetDayButtonsPointer(void)            { return(::GetPointer(m_days));         }
   //--- (1) получить текущую дату в календаре, (2) Установить (выделить) и (3) получить выделенную дату
   datetime          Today(void)                           { return(m_today.DateTime());           }
   datetime          SelectedDate(void)                    { return(m_date.DateTime());            }
   void              SelectedDate(const datetime date);
   //--- Отображение последних изменений в календаре
   void              UpdateCalendar(void);
   //--- Обновляет элементы календаря
   void              UpdateElements(void);
   //--- Обновление текущей даты
   void              UpdateCurrentDate(void);
   //---
public:
   //--- Обработчик событий графика
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Таймер
   virtual void      OnEventTimer(void);
   //--- Показ
   virtual void      Show(void);
   //--- Рисует элемент
   virtual void      Draw(void);
   //---
private:
   //--- Обработка нажатия на кнопке перехода к предыдущему месяцу
   bool              OnClickMonthDec(const string clicked_object,const int id,const int index);
   //--- Обработка нажатия на кнопке перехода к следующему месяцу
   bool              OnClickMonthInc(const string clicked_object,const int id,const int index);
   //--- Обработка выбора месяца в списке
   bool              OnClickMonthList(const int id);
   //--- Обработка ввода значения в поле ввода лет
   bool              OnEndEnterYear(const string edited_object,const int id);
   //--- Обработка нажатия на кнопке перехода к следующему году
   bool              OnClickYearInc(const string clicked_object,const int id,const int index);
   //--- Обработка нажатия на кнопке перехода к предыдущему году
   bool              OnClickYearDec(const string clicked_object,const int id,const int index);
   //--- Обработка нажатия на дне месяца
   bool              OnClickDayOfMonth(const string clicked_object,const int id,const int index);
   //--- Обработка нажатия на кнопке перехода к текущей дате
   bool              OnClickTodayButton(const string clicked_object,const int id,const int index);

   //--- Корректировка выделенного дня по количеству дней в месяце
   void              CorrectingSelectedDay(void);
   //--- Определение разницы от первого пункта таблицы календаря до пункта первого дня текущего месяца
   int               OffsetFirstDayOfMonth(void);
   //--- Отображает последние изменения в таблице календаря
   void              SetCalendar(void);
   //--- Ускоренная перемотка значений календаря
   void              FastSwitching(void);
   //--- Подсветка текущего дня и выбранного пользователем дня
   void              HighlightDate(void);
   //--- Сброс времени на начало суток
   void              ResetTime(void);

   //--- Рисует названия дней недели
   void              DrawDaysWeek(void);
   //--- Рисует разделительную линию
   void              DrawSeparateLine(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CCalendar::CCalendar(void) : m_today_color(C'0,102,204')
  {
//--- Сохраним имя класса элемента в базовом классе
   CElementBase::ClassName(CLASS_NAME);
//--- Инициализация структур времени
   m_date.DateTime(::TimeLocal());
   m_today.DateTime(::TimeLocal());
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CCalendar::~CCalendar(void)
  {
  }
//+------------------------------------------------------------------+
//| Обработчик событий                                               |
//+------------------------------------------------------------------+
void CCalendar::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Обработка события выбора пункта в выпадающем списке
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_COMBOBOX_ITEM)
     {
      //--- Обработка ввода значения в поле ввода лет
      if(OnClickMonthList((int)lparam))
         return;
      //---
      return;
     }
//--- Обработка события ввода значения в поле ввода
   if(id==CHARTEVENT_CUSTOM+ON_END_EDIT)
     {
      //--- Обработка ввода значения в поле ввода лет
      if(OnEndEnterYear(sparam,(int)lparam))
         return;
      //---
      return;
     }
//--- Обработка события нажатия на кнопке в группе
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_GROUP_BUTTON)
     {
      //--- Обработка нажатия на дне календаря
      if(OnClickDayOfMonth(sparam,(int)lparam,(int)dparam))
         return;
      //---
      return;
     }
//--- Обработка события нажатия на кнопке
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)
     {
      //--- Обработка нажатия на кнопках переключения месяцев
      if(OnClickMonthDec(sparam,(int)lparam,(int)dparam))
         return;
      if(OnClickMonthInc(sparam,(int)lparam,(int)dparam))
         return;
      //--- Обработка нажатия на кнопках перехода по годам
      if(OnClickYearInc(sparam,(int)lparam,(int)dparam))
         return;
      if(OnClickYearDec(sparam,(int)lparam,(int)dparam))
         return;
      //--- Обработка нажатия на кнопке перехода к текущей дате
      if(OnClickTodayButton(sparam,(int)lparam,(int)dparam))
         return;
      //---
      return;
     }
  }
//+------------------------------------------------------------------+
//| Таймер                                                           |
//+------------------------------------------------------------------+
void CCalendar::OnEventTimer(void)
  {
//--- Ускоренная перемотка значений
   FastSwitching();
//--- Обновление текущей даты календаря
   UpdateCurrentDate();
  }
//+------------------------------------------------------------------+
//| Создаёт контекстное меню                                         |
//+------------------------------------------------------------------+
bool CCalendar::CreateCalendar(const int x_gap,const int y_gap)
  {
//--- Выйти, если нет указателя на главный элемент
   if(!CElement::CheckMainPointer())
      return(false);
//--- Инициализация свойств
   InitializeProperties(x_gap,y_gap);
//--- Создание элемента
   if(!CreateCanvas())
      return(false);
   if(!CreateMonthArrow(m_month_dec,0))
      return(false);
   if(!CreateMonthArrow(m_month_inc,1))
      return(false);
   if(!CreateMonthsList())
      return(false);
   if(!CreateYearsSpinEdit())
      return(false);
   if(!CreateDaysMonth())
      return(false);
   if(!CreateButtonToday())
      return(false);
//--- Обновить календарь
   UpdateCalendar();
   return(true);
  }
//+------------------------------------------------------------------+
//| Инициализация свойств                                            |
//+------------------------------------------------------------------+
void CCalendar::InitializeProperties(const int x_gap,const int y_gap)
  {
   m_x      =CElement::CalculateX(x_gap);
   m_y      =CElement::CalculateY(y_gap);
   m_x_size =161;
   m_y_size =158;
//--- Цвета умолчанию
   m_back_color         =(m_back_color!=clrNONE)? m_back_color : clrWhite;
   m_border_color       =(m_border_color!=clrNONE)? m_border_color : C'150,170,180';
   m_label_color        =(m_label_color!=clrNONE)? m_label_color : clrBlack;
   m_label_color_locked =(m_label_color_locked!=clrNONE)? m_label_color_locked : C'200,200,200';
//--- Отступы от крайней точки
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
  }
//+------------------------------------------------------------------+
//| Создаёт объект для рисования                                     |
//+------------------------------------------------------------------+
bool CCalendar::CreateCanvas(void)
  {
//--- Формирование имени объекта
   string name=CElementBase::ElementName("calendar");
//--- Создание объекта
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт переключатель месяцев влево                              |
//+------------------------------------------------------------------+
bool CCalendar::CreateMonthArrow(CButton &button_obj,const int index)
  {
//--- Сохраним указатель на главный элемент
   button_obj.MainPointer(this);
//--- Размеры
   int x_size=12;
   int y_size=18;
//--- Отступ
   int offset=2;
//--- Координаты
   int x =(index<1)? offset : x_size+offset;
   int y =offset;
//--- Свойства
   button_obj.Index(index);
   button_obj.XSize(x_size);
   button_obj.YSize(y_size);
   button_obj.IconXGap(-2);
   button_obj.IconYGap(1);
   button_obj.IsDropdown(CElementBase::IsDropdown());
//--- Ярлыки для кнопок
   if(index<1)
     {
      button_obj.IconFile(RESOURCE_LEFT_THIN_BLACK);
      button_obj.IconFileLocked(RESOURCE_LEFT_THIN_BLACK);
     }
   else
     {
      button_obj.IconFile(RESOURCE_RIGHT_THIN_BLACK);
      button_obj.IconFileLocked(RESOURCE_RIGHT_THIN_BLACK);
      button_obj.AnchorRightWindowSide(true);
     }
//--- Создадим элемент управления
   if(!button_obj.CreateButton("",x,y))
      return(false);
//--- Добавить элемент в массив
   CElement::AddToArray(button_obj);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт комбо-бокс с месяцами                                    |
//+------------------------------------------------------------------+
bool CCalendar::CreateMonthsList(void)
  {
//--- Сохраним указатель на главный элемент
   m_months.MainPointer(this);
//--- Координаты
   int x=14,y=2;
//--- Свойства
   m_months.XSize(50);
   m_months.YSize(18);
   m_months.ItemsTotal(12);
   m_months.GetButtonPointer().XGap(1);
   m_months.GetButtonPointer().LabelYGap(3);
   m_months.IsDropdown(CElementBase::IsDropdown());
//--- Получим указатель на список
   CListView *lv=m_months.GetListViewPointer();
//--- Установим свойства списка
   lv.YSize(93);
   lv.LightsHover(true);
//--- Занесём значения в список (названия месяцев)
   for(int i=0; i<12; i++)
      m_months.SetValue(i,m_date.MonthName(i+1));
//--- Выделим в списке текущий месяц
   m_months.SelectItem(m_date.mon-1);
//--- Создадим элемент управления
   if(!m_months.CreateComboBox("",x,y))
      return(false);
//--- Добавить элемент в массив
   CElement::AddToArray(m_months);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт поле ввода года                                          |
//+------------------------------------------------------------------+
bool CCalendar::CreateYearsSpinEdit(void)
  {
//--- Сохраним указатель на главный элемент
   m_years.MainPointer(this);
//--- Координаты
   int x=95,y=2;
//--- Свойства
   m_years.Index(m_is_dropdown? 1 : 0);
   m_years.XSize(50);
   m_years.YSize(18);
   m_years.MaxValue(2099);
   m_years.MinValue(1970);
   m_years.StepValue(1);
   m_years.SetDigits(0);
   m_years.SpinEditMode(true);
   m_years.GetTextBoxPointer().AutoSelectionMode(true);
   m_years.SetValue((string)m_date.year);
   m_years.GetTextBoxPointer().XGap(1);
   m_years.GetTextBoxPointer().XSize(50);
   m_years.GetIncButtonPointer().NamePart("cal_spin_inc");
   m_years.GetDecButtonPointer().NamePart("cal_spin_dec");
//--- Создадим элемент управления
   if(!m_years.CreateTextEdit("",x,y))
      return(false);
//--- Отступ текста в поле ввода
   m_years.GetTextBoxPointer().TextYOffset(4);
//--- Добавить элемент в массив
   CElement::AddToArray(m_years);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт таблицу дней месяца                                      |
//+------------------------------------------------------------------+
bool CCalendar::CreateDaysMonth(void)
  {
//--- Счётчик дней
   int i=0;
//--- Координаты и отступы
   int x=0,y=0;
   int x_offset=7,y_offset=44;
//--- Размеры
   int x_size=21,y_size=15;
//--- Сохраним указатель на главный элемент
   m_days.MainPointer(this);
//---
   int    buttons_x_offset[DAYS_TOTAL]={};
   int    buttons_y_offset[DAYS_TOTAL]={};
   string buttons_text[DAYS_TOTAL]={};
//--- Установим объекты таблицы дней календаря
   for(int r=0; r<6; r++)
     {
      //--- Расчёт координаты Y
      y=(r>0)? y+y_size : 0;
      //---
      for(int c=0; c<7; c++)
        {
         //--- Расчёт координаты X
         x=(c>0)? x+x_size : 0;
         //--
         buttons_text[i]     =string(i);
         buttons_x_offset[i] =x;
         buttons_y_offset[i] =y;
         //---
         i++;
        }
     }
//--- Свойства
   m_days.NamePart("day");
   m_days.ButtonYSize(y_size);
   m_days.LabelYGap(1);
   m_days.IsCenterText(true);
   m_days.RadioButtonsMode(true);
   m_days.IsDropdown(CElementBase::IsDropdown());
   
//--- Добавим кнопки в группу
   for(int j=0; j<DAYS_TOTAL; j++)
      m_days.AddButton(buttons_x_offset[j],buttons_y_offset[j],buttons_text[j],x_size);
      
//--- Создать группу кнопок
   x=x_offset;
   y=y_offset;
   if(!m_days.CreateButtonsGroup(x,y))
      return(false);
//--- Свойства
   for(int j=0; j<DAYS_TOTAL; j++)
     {
      m_days.GetButtonPointer(j).BackColor(m_back_color);
      m_days.GetButtonPointer(j).BorderColor(m_back_color);
     }
//--- Добавить элемент в массив
   CElement::AddToArray(m_days);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт кнопку для перехода на текущую дату                      |
//+------------------------------------------------------------------+
bool CCalendar::CreateButtonToday(void)
  {
//--- Сохраним указатель на главный элемент
   m_button_today.MainPointer(this);
//--- Координаты
   int x=22,y=YSize()-23;
//--- Свойства
   m_button_today.NamePart("today_button");
   m_button_today.Index(2);
   m_button_today.XSize(120);
   m_button_today.YSize(20);
   m_button_today.IconXGap(1);
   m_button_today.IconYGap(1);
   m_button_today.LabelXGap(25);
   m_button_today.LabelYGap(4);
   m_button_today.BackColor(m_back_color);
   m_button_today.BackColorHover(m_back_color);
   m_button_today.BackColorLocked(m_back_color);
   m_button_today.BackColorPressed(m_back_color);
   m_button_today.BorderColor(m_back_color);
   m_button_today.BorderColorHover(m_back_color);
   m_button_today.BorderColorLocked(m_back_color);
   m_button_today.BorderColorPressed(m_back_color);
   m_button_today.LabelColorHover(C'0,102,250');
   m_button_today.IsDropdown(CElementBase::IsDropdown());
   m_button_today.IconFile(RESOURCE_CALENDAR_TODAY);
   m_button_today.IconFileLocked(RESOURCE_CALENDAR_TODAY);
   m_button_today.CElement::IconFilePressed(RESOURCE_CALENDAR_TODAY);
   m_button_today.CElement::IconFilePressedLocked(RESOURCE_CALENDAR_TODAY);
//--- Создадим элемент управления
   if(!m_button_today.CreateButton("Today: "+::TimeToString(::TimeLocal(),TIME_DATE),x,y))
      return(false);
//--- Добавить элемент в массив
   CElement::AddToArray(m_button_today);
   return(true);
  }
//+------------------------------------------------------------------+
//| Выбор новой даты                                                 |
//+------------------------------------------------------------------+
void CCalendar::SelectedDate(const datetime date)
  {
//--- Сохранение даты в структуре и поле класса
   m_date.DateTime(date);
//--- Отображение последних изменений в календаре
   UpdateCalendar();
  }
//+------------------------------------------------------------------+
//| Отображение последних изменений в календаре                      |
//+------------------------------------------------------------------+
void CCalendar::UpdateCalendar(void)
  {
//--- Отобразить изменения в таблице календаря
   SetCalendar();
//--- Подсветка текущего дня и выбранного пользователем дня
   HighlightDate();
//--- Установим год в поле ввода
   m_years.SetValue((string)m_date.year,false);
//--- Установим месяц в списке комбо-бокса
   m_months.SelectItem(m_date.mon-1);
  }
//+------------------------------------------------------------------+
//| Обновляет элементы календаря                                     |
//+------------------------------------------------------------------+
void CCalendar::UpdateElements(void)
  {
   m_years.GetTextBoxPointer().Update(true);
   m_months.GetButtonPointer().Update(true);
   m_days.Update(true);
  }
//+------------------------------------------------------------------+
//| Обновление текущей даты                                          |
//+------------------------------------------------------------------+
void CCalendar::UpdateCurrentDate(void)
  {
//--- Счётчик
   static int count=0;
//--- Выйти, если прошло меньше секунды
   if(count<1000)
     {
      count+=TIMER_STEP_MSC;
      return;
     }
//--- Обнулить счётчик
   count=0;
//--- Получим текущее (локальное) время
   MqlDateTime local_time;
   ::TimeToStruct(::TimeLocal(),local_time);
//--- Если наступил новый день
   if(local_time.day!=m_today.day)
     {
      //--- Обновить дату в календаре
      m_today.DateTime(::TimeLocal());
      m_button_today.LabelText(::TimeToString(m_today.DateTime()));
      //--- Отобразить последние изменения в календаре
      UpdateCalendar();
      return;
     }
//--- Обновить дату в календаре
   m_today.DateTime(::TimeLocal());
  }
//+------------------------------------------------------------------+
//| Показывает календарь                                             |
//+------------------------------------------------------------------+
void CCalendar::Show(void)
  {
//--- Если календарь не выпадающий, сделать видимыми все его элементы
   CElement::Show();
//--- Если календарь выпадающий
   if(CElementBase::IsDropdown())
     {
      int elements_total=ElementsTotal();
      for(int i=0; i<elements_total; i++)
         m_elements[i].Show();
     }
  }
//+------------------------------------------------------------------+
//| Нажатие на стрелку влево. Переход к предыдущему месяцу.          |
//+------------------------------------------------------------------+
bool CCalendar::OnClickMonthDec(const string clicked_object,const int id,const int index)
  {
//--- Выйдем, если нажатие было не на этом элементе
   if(!m_month_dec.CheckElementName(clicked_object))
      return(false);
//--- Выйти, если (1) идентификаторы не совпадают или (2) элемент заблокирован
   if(id!=CElementBase::Id() || index!=m_month_dec.Index() || CElementBase::IsLocked())
      return(false);
//--- Если текущий год в календаре равен минимальному указанному и текущий месяц "Январь"
   if(m_date.year==m_years.MinValue() && m_date.mon==1)
      return(true);
//--- Перейти к предыдущему месяцу
   m_date.MonDec();
//--- Установить первое число месяца
   m_date.day=1;
//--- Установить время на начало суток
   ResetTime();
//--- Отображение последних изменений в календаре
   UpdateCalendar();
//--- Обновляет элементы календаря
   UpdateElements();
//--- Отправим сообщение об этом
   ::EventChartCustom(m_chart_id,ON_CHANGE_DATE,CElementBase::Id(),m_date.DateTime(),"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Нажатие на стрелку влево. Переход к следующему месяцу.           |
//+------------------------------------------------------------------+
bool CCalendar::OnClickMonthInc(const string clicked_object,const int id,const int index)
  {
//--- Выйдем, если нажатие было не на этом элементе
   if(!m_month_inc.CheckElementName(clicked_object))
      return(false);
//--- Выйти, если (1) идентификаторы не совпадают или (2) элемент заблокирован
   if(id!=CElementBase::Id() || index!=m_month_inc.Index() || CElementBase::IsLocked())
      return(false);
//--- Если текущий год в календаре равен максимальному указанному и текущий месяц "Декабрь"
   if(m_date.year==m_years.MaxValue() && m_date.mon==12)
      return(true);
//--- Перейти к следующему месяцу
   m_date.MonInc();
//--- Установить первое число месяца
   m_date.day=1;
//--- Установить время на начало суток
   ResetTime();
//--- Отображение последних изменений в календаре
   UpdateCalendar();
//--- Обновляет элементы календаря
   UpdateElements();
//--- Отправим сообщение об этом
   ::EventChartCustom(m_chart_id,ON_CHANGE_DATE,CElementBase::Id(),m_date.DateTime(),"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка выбора месяца в списке                                 |
//+------------------------------------------------------------------+
bool CCalendar::OnClickMonthList(const int id)
  {
//--- Выйти, если идентификаторы элементов не совпадают
   if(id!=CElementBase::Id())
      return(false);
//--- Получим выбранный месяц в списке
   int month=m_months.GetListViewPointer().SelectedItemIndex()+1;
   m_date.Mon(month);
//--- Корректировка выделенного дня по количеству дней в месяце
   CorrectingSelectedDay();
//--- Установить время на начало суток
   ResetTime();
//--- Отобразить изменения в таблице календаря
   UpdateCalendar();
//--- Обновляет элементы календаря
   UpdateElements();
//--- Отправим сообщение об этом
   ::EventChartCustom(m_chart_id,ON_CHANGE_DATE,CElementBase::Id(),m_date.DateTime(),"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка ввода значения в поле ввода лет                        |
//+------------------------------------------------------------------+
bool CCalendar::OnEndEnterYear(const string edited_object,const int id)
  {
//--- Выйти, если (1) идентификаторы не совпадают или (2) элемент заблокирован
   if(id!=CElementBase::Id() || CElementBase::IsLocked())
      return(false);
//--- Выйдем, если значение не изменилось
   string value=m_years.GetValue();
   if(m_date.year==(int)value)
     {
      //--- Обновляет поле ввода
      m_years.GetTextBoxPointer().Update(true);
      return(false);
     }
//--- Скорректируем значение в случае выхода за установленные ограничения
   if((int)value<m_years.MinValue())
      value=(string)int(m_years.MinValue());
   if((int)value>m_years.MaxValue())
      value=(string)int(m_years.MaxValue());
//--- Определим количество дней в текущем месяце
   string year  =value;
   string month =string(m_date.mon);
   string day   =string(1);
   m_temp_date.DateTime(::StringToTime(year+"."+month+"."+day));
//--- Если значение выделенного дня больше, чем количество дней в месяце,
//    установить текущее количество дней в месяце в качестве выделенного дня
   if(m_date.day>m_temp_date.DaysInMonth())
      m_date.day=m_temp_date.DaysInMonth();
//--- Установим дату в структуру
   m_date.DateTime(::StringToTime(year+"."+month+"."+string(m_date.day)));
//--- Отобразим изменения в таблице календаря
   UpdateCalendar();
//--- Обновляет элементы календаря
   UpdateElements();
//--- Отправим сообщение об этом
   ::EventChartCustom(m_chart_id,ON_CHANGE_DATE,CElementBase::Id(),m_date.DateTime(),"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на кнопке перехода к следующему году           |
//+------------------------------------------------------------------+
bool CCalendar::OnClickYearInc(const string clicked_object,const int id,const int index)
  {
//--- Выйдем, если нажатие было не на этом элементе
   if(!m_years.GetIncButtonPointer().CheckElementName(clicked_object))
      return(false);
//--- Если список месяцев открыт, закроем его
   if(m_months.GetListViewPointer().IsVisible())
      m_months.ChangeComboBoxListState();
//--- Выйти, если идентификаторы элементов не совпадают
   if(id!=CElementBase::Id())
      return(false);
//--- Если год меньше максимального указанного, увеличить значение на один
   if(m_date.year<m_years.MaxValue())
      m_date.YearInc();
//--- Корректировка выделенного дня по количеству дней в месяце
   CorrectingSelectedDay();
//--- Отобразить изменения в таблице календаря
   UpdateCalendar();
//--- Обновляет элементы календаря
   UpdateElements();
//--- Отправим сообщение об этом
   ::EventChartCustom(m_chart_id,ON_CHANGE_DATE,CElementBase::Id(),m_date.DateTime(),"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на кнопке перехода к предыдущему году          |
//+------------------------------------------------------------------+
bool CCalendar::OnClickYearDec(const string clicked_object,const int id,const int index)
  {
//--- Выйдем, если нажатие было не на этом элементе
   if(!m_years.GetDecButtonPointer().CheckElementName(clicked_object))
      return(false);
//--- Если список месяцев открыт, закроем его
   if(m_months.GetListViewPointer().IsVisible())
      m_months.ChangeComboBoxListState();
//--- Выйти, если идентификаторы элементов не совпадают
   if(id!=CElementBase::Id())
      return(false);
//--- Если год больше минимального указанного, уменьшить значение на один
   if(m_date.year>m_years.MinValue())
      m_date.YearDec();
//--- Корректировка выделенного дня по количеству дней в месяце  
   CorrectingSelectedDay();
//--- Отобразить изменения в таблице календаря
   UpdateCalendar();
//--- Обновляет элементы календаря
   UpdateElements();
//--- Отправим сообщение об этом
   ::EventChartCustom(m_chart_id,ON_CHANGE_DATE,CElementBase::Id(),m_date.DateTime(),"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на дне месяца календаря                        |
//+------------------------------------------------------------------+
bool CCalendar::OnClickDayOfMonth(const string clicked_object,const int id,const int index)
  {
//--- Выйти, если (1) идентификаторы не совпадают или (2) элемент заблокирован
   if(id!=CElementBase::Id() || CElementBase::IsLocked())
      return(false);
//--- Определение разницы от первого пункта таблицы календаря до пункта первого дня текущего месяца
   OffsetFirstDayOfMonth();
//--- Пройдёмся в цикле по пунктам таблицы календаря
   int items_total=m_days.ButtonsTotal();
   for(int i=0; i<items_total; i++)
     {
      //--- Если дата текущего пункта меньше, чем установленный в системе минимум
      if(m_temp_date.DateTime()<datetime(D'01.01.1970'))
        {
         //--- Если это объект, на который нажали
         if(i==index)
            return(false);
         //--- Перейти к следующей дате
         m_temp_date.DayInc();
         continue;
        }
      //--- Если это объект, на который нажали
      if(i==index)
        {
         //--- Сохраним дату
         m_date.DateTime(m_temp_date.DateTime());
         //--- Отображение последних изменений в календаре
         UpdateCalendar();
         break;
        }
      //--- Перейти к следующей дате
      m_temp_date.DayInc();
      //--- Проверка выхода за установленный в системе максимум
      if(m_temp_date.year>m_years.MaxValue())
         return(false);
     }
//--- Обновляет элементы календаря
   UpdateElements();
//--- Отправим сообщение об этом
   ::EventChartCustom(m_chart_id,ON_CHANGE_DATE,CElementBase::Id(),m_date.DateTime(),"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на кнопке перехода к текущей дате              |
//+------------------------------------------------------------------+
bool CCalendar::OnClickTodayButton(const string clicked_object,const int id,const int index)
  {
//--- Выйти, если чужое имя объекта
   if(::StringFind(clicked_object,m_button_today.NamePart(),0)<0)
      return(false);
//--- Выйти, если идентификаторы элементов не совпадают
   if(id!=CElementBase::Id())
      return(false);
//--- Если список месяцев открыт, закроем его
   if(m_months.GetListViewPointer().IsVisible())
      m_months.ChangeComboBoxListState();
//--- Установить текущую дату
   m_date.DateTime(::TimeLocal());
//--- Отображение последних изменений в календаре
   UpdateCalendar();
//--- Обновляет элементы календаря
   UpdateElements();
//--- Отправим сообщение об этом
   ::EventChartCustom(m_chart_id,ON_CHANGE_DATE,CElementBase::Id(),m_date.DateTime(),"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Определение первого дня месяца                                   |
//+------------------------------------------------------------------+
void CCalendar::CorrectingSelectedDay(void)
  {
//--- Установить текущее количество дней в месяце, если значение выделенного дня больше
   if(m_date.day>m_date.DaysInMonth())
      m_date.day=m_date.DaysInMonth();
  }
//+------------------------------------------------------------------+
//| Определение разницы от первого пункта таблицы календаря          |
//| до пункта первого дня текущего месяца                            |
//+------------------------------------------------------------------+
int CCalendar::OffsetFirstDayOfMonth(void)
  {
//--- Получим дату первого дня выделенного года и месяца в виде строки
   string date=string(m_date.year)+"."+string(m_date.mon)+"."+string(1);
//--- Установим эту дату в структуру для расчётов
   m_temp_date.DateTime(::StringToTime(date));
//--- Если результат вычитания единицы от текущего номера дня недели больше либо равен нулю,
//    вернуть результат, иначе вернуть значение 6
   int diff=(m_temp_date.day_of_week-1>=0) ? m_temp_date.day_of_week-1 : 6;
//--- Запомним дату, которая приходится на первый пункт таблицы
   m_temp_date.DayDec(diff);
   return(diff);
  }
//+------------------------------------------------------------------+
//| Установка значений календаря                                     |
//+------------------------------------------------------------------+
void CCalendar::SetCalendar(void)
  {
//--- Определение разницы от первого пункта таблицы календаря до пункта первого дня текущего месяца
   int diff=OffsetFirstDayOfMonth();
//--- Пройдёмся в цикле по всем пунктам таблицы календаря
   int items_total=m_days.ButtonsTotal();
   for(int i=0; i<items_total; i++)
     {
      //--- Установка дня в текущий пункт таблицы
      m_days.GetButtonPointer(i).LabelText(string(m_temp_date.day));
      //--- Перейти к следующей дате
      m_temp_date.DayInc();
     }
  }
//+------------------------------------------------------------------+
//| Ускоренная промотка календаря                                    |
//+------------------------------------------------------------------+
void CCalendar::FastSwitching(void)
  {
//--- Выйдем, если нет фокуса на элементе
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
      //--- Если левая стрелка нажата
      if(m_month_dec.MouseFocus())
        {
         //--- Если текущий год в календаре больше/равен минимального указанного
         if(m_date.year>=m_years.MinValue())
           {
            //--- Если текущий год в календаре уже равен минимальному указанному и
            //    текущий месяц "Январь"
            if(m_date.year==m_years.MinValue() && m_date.mon==1)
               return;
            //--- Перейти к следующему месяцу (в сторону уменьшения)
            m_date.MonDec();
            //--- Установить первое число месяца
            m_date.day=1;
           }
        }
      //--- Если правая стрелка нажата
      else if(m_month_inc.MouseFocus())
        {
         //--- Если текущий в календаре год меньше/равен максимального указанного
         if(m_date.year<=m_years.MaxValue())
           {
            //--- Если текущий год в календаре уже равен максимальному указанному и
            //    текущий месяц "Декабрь"
            if(m_date.year==m_years.MaxValue() && m_date.mon==12)
               return;
            //--- Перейти к следующему месяцу (в сторону увеличения)
            m_date.MonInc();
            //--- Установить первое число месяца
            m_date.day=1;
           }
        }
      //--- Если кнопка инкремента поля ввода лет нажата
      else if(m_years.GetIncButtonPointer().MouseFocus())
        {
         //--- Если меньше максимального указанного года,
         //    перейти к следующему году (в сторону увеличения)
         if(m_date.year<m_years.MaxValue())
            m_date.YearInc();
         else
            return;
        }
      //--- Если кнопка декремента поля ввода лет нажата
      else if(m_years.GetDecButtonPointer().MouseFocus())
        {
         //--- Если больше минимального указанного года,
         //    перейти к следующему году (в сторону уменьшения)
         if(m_date.year>m_years.MinValue())
            m_date.YearDec();
         else
            return;
        }
      else
         return;
      //--- Отображение последних изменений в календаре
      UpdateCalendar();
      //--- Обновляет элементы календаря
      UpdateElements();
      //--- Отправим сообщение об этом
      ::EventChartCustom(m_chart_id,ON_CHANGE_DATE,CElementBase::Id(),m_date.DateTime(),"");
     }
  }
//+------------------------------------------------------------------+
//| Подсветка текущего дня и выбранного пользователем дня            |
//+------------------------------------------------------------------+
void CCalendar::HighlightDate(void)
  {
//--- Определение разницы от первого пункта таблицы календаря до пункта первого дня текущего месяца
   OffsetFirstDayOfMonth();
//--- Пройдёмся в цикле по пунктам таблицы календаря
   int items_total=m_days.ButtonsTotal();
   for(int i=0; i<items_total; i++)
     {
      //--- Если месяц пункта совпадает с текущим месяцем и 
      //    день пункта совпадает с выделенным днём
      if(m_temp_date.mon==m_date.mon &&
         m_temp_date.day==m_date.day)
        {
         //--- Выделить эту кнопку
         m_days.SelectButton(i);
         //--- Перейти к следующему пункту таблицы
         m_temp_date.DayInc();
         continue;
        }
      //--- Если это текущая дата (сегодня)
      if(m_temp_date.year==m_today.year && 
         m_temp_date.mon==m_today.mon &&
         m_temp_date.day==m_today.day)
        {
         m_days.GetButtonPointer(i).LabelColor(m_today_color);
         m_days.GetButtonPointer(i).BorderColor(m_today_color);
         //--- Перейти к следующему пункту таблицы
         m_temp_date.DayInc();
         continue;
        }
      //---
      m_days.GetButtonPointer(i).BorderColor(m_back_color);
      m_days.GetButtonPointer(i).LabelColor((m_temp_date.mon==m_date.mon)? m_label_color : m_label_color_locked);
      //--- Перейти к следующему пункту таблицы
      m_temp_date.DayInc();
     }
  }
//+------------------------------------------------------------------+
//| Сброс времени на начало суток                                    |
//+------------------------------------------------------------------+
void CCalendar::ResetTime(void)
  {
   m_date.hour =0;
   m_date.min  =0;
   m_date.sec  =0;
  }
//+------------------------------------------------------------------+
//| Рисует элемент                                                   |
//+------------------------------------------------------------------+
void CCalendar::Draw(void)
  {
//--- Нарисовать фон
   CElement::DrawBackground();
//--- Нарисовать рамку
   CElement::DrawBorder();
//--- Рисует названия дней недели
   DrawDaysWeek();
//--- Рисует разделительную линию
   DrawSeparateLine();
  }
//+------------------------------------------------------------------+
//| Рисует названия дней недели                                      |
//+------------------------------------------------------------------+
void CCalendar::DrawDaysWeek(void)
  {
//--- Координаты
   int x=17,y=26;
//--- Размеры
   int x_size =21;
   int y_size =16;
//--- Счётчик дней недели (для массива объектов)
   int w=0;
//--- Установим объекты отображающие сокращённые названия дней недели
   for(int i=1; i<7; i++,w++)
     {
      //--- Расчёт координаты X
      x=(w>0)? x+x_size : x;
      //--- Свойства шрифта
      m_canvas.FontSet(CElement::Font(),-CElement::FontSize()*10,FW_NORMAL);
      //--- Вывести текст
      m_canvas.TextOut(x,y,m_date.ShortDayName(i),::ColorToARGB(clrBlack),TA_CENTER);
      //--- Если был сброс, выйти
      if(i==0)
         break;
      //--- Сброс, если прошли все дни недели
      if(i>=6)
         i=-1;
     }
  }
//+------------------------------------------------------------------+
//| Рисует разделительную линию                                      |
//+------------------------------------------------------------------+
void CCalendar::DrawSeparateLine(void)
  {
//--- Координаты
   int x1=7,x2=154,y=42;
//--- Нарисовать линию
   m_canvas.Line(x1,y,x2,y,::ColorToARGB(m_border_color));
  }
//+------------------------------------------------------------------+
