//+------------------------------------------------------------------+
//|                                                      Tooltip.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
//+------------------------------------------------------------------+
//| Класс для создания всплывающей подсказки                         |
//+------------------------------------------------------------------+
class CTooltip : public CElement
  {
private:
   //--- Указатель на элемент, к которому присоединена всплывающая подсказка
   CElement         *m_element;
   //--- Текст и цвет заголовока
   string            m_header_text;
   color             m_header_color;
   //--- Массив строк текста подсказки
   string            m_tooltip_lines[];
   //---
public:
                     CTooltip(void);
                    ~CTooltip(void);
   //--- Методы для создания всплывающей подсказки
   bool              CreateTooltip(void);
   //---
private:
   void              InitializeProperties(void);
   bool              CreateCanvas(void);
   //---
public:
   //--- (1) Сохраняет указатель элемента, (2) заголовок всплывающей подсказки
   void              ElementPointer(CElement &object) { m_element=::GetPointer(object); }
   void              HeaderText(const string text)    { m_header_text=text;             }
   void              HeaderColor(const color clr)     { m_header_color=clr;             }
   //--- Добавляет строку для подсказки
   void              AddString(const string text);

   //--- (1) Показывает и (2) скрывает всплывающую подсказку
   void              ShowTooltip(void);
   void              FadeOutTooltip(void);
   //---
public:
   //--- Обработчик событий графика
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Управление
   virtual void      Reset(void);
   virtual void      Delete(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTooltip::CTooltip(void) : m_header_text(""),
                           m_header_color(C'50,50,50')
  {
//--- Сохраним имя класса элемента в базовом классе  
   CElement::ClassName(CLASS_NAME);
//--- Изначально полностью прозрачна
   CElement::Alpha(0);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CTooltip::~CTooltip(void)
  {
  }
//+------------------------------------------------------------------+
//| Обработчик событий графика                                       |
//+------------------------------------------------------------------+
void CTooltip::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Обработка события перемещения курсора
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Выйти, если элемент скрыт
      if(!CElement::IsVisible())
         return;
      //--- Выйти, если кнопка всплывающих подсказок на форме отключена
      if(!m_wnd.IsTooltip())
         return;
      //--- Если форма заблокирована, скрыть подсказку
      if(m_main.CElementBase::IsLocked())
        {
         FadeOutTooltip();
         return;
        }
      //--- Если есть фокус на элементе, показать подсказку
      if(m_element.MouseFocus())
         ShowTooltip();
      //--- Если нет фокуса, скрыть подсказку
      else
         FadeOutTooltip();
      //---
      return;
     }
  }
//+------------------------------------------------------------------+
//| Создаёт объект Tooltip                                           |
//+------------------------------------------------------------------+
bool CTooltip::CreateTooltip(void)
  {
//--- Выйти, если нет указателя на главный элемент
   if(!CElement::CheckMainPointer())
      return(false);
//--- Выйти, если нет указателя на элемент
   if(::CheckPointer(m_element)==POINTER_INVALID)
     {
      ::Print(__FUNCTION__," > Перед созданием всплывающей подсказки классу нужно передать "
              "указатель на элемент: CTooltip::ElementPointer(CElement &object).");
      return(false);
     }
//--- Инициализация свойств
   InitializeProperties();
//--- Создаёт всплывающую подсказку
   if(!CreateCanvas())
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Инициализация свойств                                            |
//+------------------------------------------------------------------+
void CTooltip::InitializeProperties(void)
  {
   m_x        =CElement::CalculateX(m_element.XGap());
   m_y        =CElement::CalculateY(m_element.YGap()+m_element.YSize()+1);
   m_x_size   =(m_x_size<1)? 100 : m_x_size;
   m_y_size   =(m_y_size<1)? 50 : m_y_size;
//--- Цвета по умолчанию
   m_border_color =(m_border_color!=clrNONE)? m_border_color : C'150,170,180';
   m_label_color  =(m_label_color!=clrNONE)? m_label_color : clrDimGray;
//--- Отступы от крайней точки
   CElement::XGap(CElement::CalculateXGap(m_x));
   CElement::YGap(CElement::CalculateYGap(m_y));
  }
//+------------------------------------------------------------------+
//| Создаёт холст для рисования                                      |
//+------------------------------------------------------------------+
bool CTooltip::CreateCanvas(void)
  {
//--- Формирование имени объекта
   string name=CElementBase::ElementName("tooltip");
//--- Создание объекта
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//--- Очистка холста для рисования
   m_canvas.Erase(::ColorToARGB(clrNONE,0));
   m_canvas.Update();
//--- Обнулить приоритет на нажатие
   Z_Order(WRONG_VALUE);
   return(true);
  }
//+------------------------------------------------------------------+
//| Добавляет строку                                                 |
//+------------------------------------------------------------------+
void CTooltip::AddString(const string text)
  {
//--- Увеличим размер массивов на один элемент
   int array_size=::ArraySize(m_tooltip_lines);
   ::ArrayResize(m_tooltip_lines,array_size+1);
//--- Сохраним значения переданных параметров
   m_tooltip_lines[array_size]=text;
  }
//+------------------------------------------------------------------+
//| Отображает всплывающую подсказку                                 |
//+------------------------------------------------------------------+
void CTooltip::ShowTooltip(void)
  {
//--- Выйти, если подсказка видна на 100%
   if(m_alpha>=255)
      return;
//--- Координаты и отступ для заголовка
   int x=5,y=5;
   int y_offset=15;
//--- Признак полностью видимой подсказки
   m_alpha=255;
//--- Рисуем фон и рамку
   DrawBackground();
   DrawBorder();
//--- Рисуем заголовок (если установлен)
   if(m_header_text!="")
     {
      //--- Установим параметры шрифта
      m_canvas.FontSet(CElement::Font(),-CElement::FontSize()*10,FW_BLACK);
      //--- Рисуем текст заголовка
      m_canvas.TextOut(x,y,m_header_text,::ColorToARGB(m_header_color),TA_LEFT|TA_TOP);
     }
//--- Координаты для основного текста подсказки (с учётом наличия заголовка)
   x =(m_header_text!="")? 15 : 5;
   y =(m_header_text!="")? 25 : 5;
//--- Установим параметры шрифта
   m_canvas.FontSet(CElement::Font(),-CElement::FontSize()*10,FW_THIN);
//--- Рисуем основной текст подсказки
   int lines_total=::ArraySize(m_tooltip_lines);
   for(int i=0; i<lines_total; i++)
     {
      m_canvas.TextOut(x,y,m_tooltip_lines[i],::ColorToARGB(m_label_color),TA_LEFT|TA_TOP);
      y=y+y_offset;
     }
//--- Обновить холст
   m_canvas.Update();
  }
//+------------------------------------------------------------------+
//| Плавное исчезновение всплывающей подсказки                       |
//+------------------------------------------------------------------+
void CTooltip::FadeOutTooltip(void)
  {
//--- Выйти, если подсказка скрыта на 100%
   if(m_alpha<1)
      return;
//--- Отступ для заголовка
   int y_offset=15;
//--- Шаг прозрачности
   uchar fadeout_step=7;
//--- Начальное значение
   uchar alpha=m_alpha;
//--- Плавное исчезновение подсказки
   for(uchar a=alpha; a>=0; a-=fadeout_step)
     {
      m_alpha=a;
      //--- Если следующий шаг в минус, остановим цикл
      if(a-fadeout_step<0)
        {
         m_alpha=0;
         m_canvas.Erase(::ColorToARGB(clrNONE,m_alpha));
         m_canvas.Update();
         break;
        }
      //--- Координаты для заголовка
      int x=5,y=5;
      //--- Рисуем фон и рамку
      DrawBackground();
      DrawBorder();
      //--- Рисуем заголовок (если установлен)
      if(m_header_text!="")
        {
         //--- Установим параметры шрифта
         m_canvas.FontSet(CElement::Font(),-CElement::FontSize()*10,FW_BLACK);
         //--- Рисуем текст заголовка
         m_canvas.TextOut(x,y,m_header_text,::ColorToARGB(m_header_color,m_alpha),TA_LEFT|TA_TOP);
        }
      //--- Координаты для основного текста подсказки (с учётом наличия заголовка)
      x =(m_header_text!="")? 15 : 5;
      y =(m_header_text!="")? 25 : 5;
      //--- Установим параметры шрифта
      m_canvas.FontSet(CElement::Font(),-CElement::FontSize()*10,FW_THIN);
      //--- Рисуем основной текст подсказки
      int lines_total=::ArraySize(m_tooltip_lines);
      for(int i=0; i<lines_total; i++)
        {
         m_canvas.TextOut(x,y,m_tooltip_lines[i],::ColorToARGB(m_label_color,m_alpha),TA_LEFT|TA_TOP);
         y=y+y_offset;
        }
      //--- Обновить холст
      m_canvas.Update();
     }
  }
//+------------------------------------------------------------------+
//| Перерисовка                                                      |
//+------------------------------------------------------------------+
void CTooltip::Reset(void)
  {
   Hide();
   Show();
  }
//+------------------------------------------------------------------+
//| Удаление                                                         |
//+------------------------------------------------------------------+
void CTooltip::Delete(void)
  {
//--- Удаление объектов
   CElement::Delete();
//--- Освобождение массивов элемента
   ::ArrayFree(m_tooltip_lines);
  }
//+------------------------------------------------------------------+
