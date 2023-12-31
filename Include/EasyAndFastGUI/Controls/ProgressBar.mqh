//+------------------------------------------------------------------+
//|                                                  ProgressBar.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
//+------------------------------------------------------------------+
//| Класс для создания индикатора выполнения                         |
//+------------------------------------------------------------------+
class CProgressBar : public CElement
  {
private:
   //--- Цвета фона прогресс-бара и рамки фона
   color             m_bar_back_color;
   //--- Размеры прогресс-бара
   int               m_bar_x_size;
   int               m_bar_y_size;
   //--- Смещение прогресс-бара по двум осям
   int               m_bar_x_gap;
   int               m_bar_y_gap;
   //--- Толщина рамки прогресс-бара
   int               m_bar_border_width;
   //--- Цвет индикатора
   color             m_indicator_color;
   //--- Смещение метки показателя процентов
   int               m_percent_x_gap;
   int               m_percent_y_gap;
   //--- Количество знаков после запятой
   int               m_digits;
   //--- Количество шагов диапазона
   double            m_steps_total;
   //--- Текущая позиция индикатора
   double            m_current_index;
   //---
public:
                     CProgressBar(void);
                    ~CProgressBar(void);
   //--- Методы для создания элемента
   bool              CreateProgressBar(const string text,const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const string text,const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   //---
public:
   //--- Цвет (1) фона и (2) рамки прогресс-бара, (3) цвет индикатора
   void              IndicatorBackColor(const color clr) { m_bar_back_color=clr;     }
   void              IndicatorColor(const color clr)     { m_indicator_color=clr;    }
   //--- (1) Толщина рамки, (2) Y-размер области индикатора
   void              BarBorderWidth(const int width)     { m_bar_border_width=width; }
   void              BarYSize(const int y_size)          { m_bar_y_size=y_size;      }
   //--- (1) Смещение прогресс бара по двум осям, (2) смещение метки показателя процентов
   void              BarXGap(const int x_gap)            { m_bar_x_gap=x_gap;        }
   void              BarYGap(const int y_gap)            { m_bar_y_gap=y_gap;        }
   //--- (1) Смещение текстовой метки (процента процесса), (2) количество знаков после запятой
   void              PercentXGap(const int x_gap)        { m_percent_x_gap=x_gap;    }
   void              PercentYGap(const int y_gap)        { m_percent_y_gap=y_gap;    }
   void              SetDigits(const int digits)         { m_digits=::fabs(digits);  }
   //--- Обновление индикатора по указанным значениям
   void              Update(const int index,const int total);
   //--- Рисует элемент
   virtual void      Draw(void);
   //---
private:
   //--- Рисует индикатор
   void              DrawIndicator(void);
   //--- Рисует процентное отображение прогресса
   void              DrawPercent(void);

   //--- Установка новых значений для индикатора
   void              CurrentIndex(const int index);
   void              StepsTotal(const int total);

   //--- Изменить ширину по правому краю окна
   virtual void      ChangeWidthByRightWindowSide(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CProgressBar::CProgressBar(void) : m_digits(0),
                                   m_steps_total(1),
                                   m_current_index(0),
                                   m_bar_x_gap(0),
                                   m_bar_y_gap(0),
                                   m_bar_border_width(0),
                                   m_percent_x_gap(7),
                                   m_percent_y_gap(0),
                                   m_bar_back_color(C'225,225,225'),
                                   m_indicator_color(clrMediumSeaGreen)
  {
//--- Сохраним имя класса элемента в базовом классе
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CProgressBar::~CProgressBar(void)
  {
  }
//+------------------------------------------------------------------+
//| Создаёт элемент "Индикатор прогресса"                            |
//+------------------------------------------------------------------+
bool CProgressBar::CreateProgressBar(const string text,const int x_gap,const int y_gap)
  {
//--- Выйти, если нет указателя на главный элемент
   if(!CElement::CheckMainPointer())
      return(false);
//--- Инициализация свойств
   InitializeProperties(text,x_gap,y_gap);
//--- Создание элемента
   if(!CreateCanvas())
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Инициализация свойств                                            |
//+------------------------------------------------------------------+
void CProgressBar::InitializeProperties(const string text,const int x_gap,const int y_gap)
  {
   m_x          =CElement::CalculateX(x_gap);
   m_y          =CElement::CalculateY(y_gap);
   m_label_text =text;
   m_x_size     =(m_x_size<1 || m_auto_xresize_mode)? m_main.X2()-m_x-m_auto_xresize_right_offset : m_x_size;
//--- Свойства по умолчанию
   m_back_color  =(m_back_color!=clrNONE)? m_back_color : m_main.BackColor();
   m_label_color =(m_label_color!=clrNONE)? m_label_color : clrBlack;
   m_label_y_gap =(m_label_y_gap!=WRONG_VALUE)? m_label_y_gap : 0;
//--- Отступы от крайней точки
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
  }
//+------------------------------------------------------------------+
//| Создаёт объект для рисования                                     |
//+------------------------------------------------------------------+
bool CProgressBar::CreateCanvas(void)
  {
//--- Формирование имени объекта
   string name=CElementBase::ElementName("progress");
//--- Создание объекта
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Обновляет прогресс бар                                           |
//+------------------------------------------------------------------+
void CProgressBar::Update(const int index,const int total)
  {
//--- Установить новый индекс
   CurrentIndex(index);
//--- Установить новый диапазон
   StepsTotal(total);
//--- Перерисовать элемент
   CElement::Update(true);
  }
//+------------------------------------------------------------------+
//| Рисует элемент                                                   |
//+------------------------------------------------------------------+
void CProgressBar::Draw(void)
  {
//--- Нарисовать фон
   CElement::DrawBackground();
//--- Нарисовать картинку
   CElement::DrawImage();
//--- Нарисовать индикатор
   DrawIndicator();
//--- Нарисовать рамку, если цвет указан
   if(m_border_color!=clrNONE)
     CElement::DrawBorder();
//--- Нарисовать текст
   CElement::DrawText();
//--- Нарисовать прогресс в процентном выражении
   DrawPercent();
  }
//+------------------------------------------------------------------+
//| Рисует индикатор                                                 |
//+------------------------------------------------------------------+
void CProgressBar::DrawIndicator(void)
  {
   int x1 =m_bar_x_gap;
   int y1 =m_bar_y_gap;
   int x2 =m_x_size; // -40
   int y2 =m_bar_y_gap+m_bar_y_size;
//--- Размер фона индикатора
   m_bar_x_size=x2-m_bar_x_gap;
//--- Нарисовать фон индикатора
   m_canvas.FillRectangle(x1,y1,x2,y2,::ColorToARGB(m_bar_back_color));
//--- Рассчитаем ширину индикатора
   double new_width=(m_current_index/m_steps_total)*m_bar_x_size;
//--- Скорректировать, если меньше 1
   if((int)new_width<1)
      new_width=1;
   else
     {
      //--- Скорректировать с учётом ширины рамки
      int x_size=m_bar_x_size-(m_bar_border_width*2);
      //--- Скорректировать, если выход за границу
      if((int)new_width>=x_size)
         new_width=x_size;
     }
//--- Установим индикатору новую ширину
   x1 =x1+m_bar_border_width;
   y1 =y1+m_bar_border_width;
   x2 =x1+(int)new_width;
   y2 =y2-m_bar_border_width;
//--- Нарисовать индикатор
   m_canvas.FillRectangle(x1,y1,x2,y2,::ColorToARGB(m_indicator_color));
  }
//+------------------------------------------------------------------+
//| Рисует процентное отображение прогресса                          |
//+------------------------------------------------------------------+
void CProgressBar::DrawPercent(void)
  {
   int x =m_x_size-m_percent_x_gap;
   int y =m_percent_y_gap;
//--- Рассчитаем процент и сформируем строку
   double percent =m_current_index/m_steps_total*100;
   string text    =::DoubleToString((percent>100)? 100 : percent,m_digits)+"%";
//--- Нарисовать текст
   m_canvas.TextOut(x,y,text,::ColorToARGB(m_label_color),TA_RIGHT);
  }
//+------------------------------------------------------------------+
//| Количество шагов прогресс бара                                   |
//+------------------------------------------------------------------+
void CProgressBar::StepsTotal(const int total)
  {
//--- Скорректировать, если меньше 0
   m_steps_total=(total<1)? 1 : total;
//--- Скорректировать индекс, если выход из диапазона
   if(m_current_index>m_steps_total)
      m_current_index=m_steps_total;
  }
//+------------------------------------------------------------------+
//| Текущая позиция индикатора                                       |
//+------------------------------------------------------------------+
void CProgressBar::CurrentIndex(const int index)
  {
//--- Скорректировать, если меньше 0
   if(index<0)
      m_current_index=1;
//--- Скорректировать индекс, если выход из диапазона
   else
      m_current_index=(index>m_steps_total)? m_steps_total : index;
  }
//+------------------------------------------------------------------+
//| Изменить ширину по правому краю формы                            |
//+------------------------------------------------------------------+
void CProgressBar::ChangeWidthByRightWindowSide(void)
  {
//--- Размеры
   int x_size=0;
//--- Рассчитать и установить новый размер фону элемента
   x_size=m_main.X2()-m_canvas.X()-m_auto_xresize_right_offset;
   CElementBase::XSize(x_size);
   m_canvas.XSize(x_size);
   m_canvas.Resize(x_size,m_y_size);
//--- Перерисовать элемент
   CElementBase::Update(true);
//--- Обновить положение объектов
   Moving();
  }
//+------------------------------------------------------------------+
