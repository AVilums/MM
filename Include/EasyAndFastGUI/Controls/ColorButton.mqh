//+------------------------------------------------------------------+
//|                                                  ColorButton.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "Button.mqh"
//+------------------------------------------------------------------+
//| Класс для создания кнопки вызова цветовой палитры                |
//+------------------------------------------------------------------+
class CColorButton : public CElement
  {
private:
   //--- Экземпляры для создания элемента
   CButton           m_button;
   //--- Выбранный цвет
   color             m_current_color;
   //--- Имя ресурса для изображения маркера цвета на кнопке
   string            m_resource_name;
   //---
public:
                     CColorButton(void);
                    ~CColorButton(void);
   //--- Методы для создания элемента
   bool              CreateColorButton(const string text,const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const string text,const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   bool              CreateButton(void);
   //---
public:
   //--- Возвращает указатели на кнопку
   CButton          *GetButtonPointer(void)                 { return(::GetPointer(m_button)); }
   color             CurrentColor(void)               const { return(m_current_color);        }
   void              CurrentColor(const color clr);
   //---
public:
   //--- Обработчик событий графика
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Рисует элемент
   virtual void      Draw(void);
   //---
private:
   //--- Рисует картинку
   virtual void      DrawImage(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CColorButton::CColorButton(void) : m_current_color(C'35,205,255'),
                                   m_resource_name("color_marker.bmp")
  {
//--- Сохраним имя класса элемента в базовом классе
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CColorButton::~CColorButton(void)
  {
  }
//+------------------------------------------------------------------+
//| Обработчик событий                                               |
//+------------------------------------------------------------------+
void CColorButton::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
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
  }
//+------------------------------------------------------------------+
//| Создаёт объект Кнопка                                            |
//+------------------------------------------------------------------+
bool CColorButton::CreateColorButton(const string text,const int x_gap,const int y_gap)
  {
//--- Выйти, если нет указателя на главный элемент
   if(!CElement::CheckMainPointer())
      return(false);
//--- Инициализация свойств
   InitializeProperties(text,x_gap,y_gap);
//--- Создание элемента
   if(!CreateCanvas())
      return(false);
   if(!CreateButton())
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Инициализация свойств                                            |
//+------------------------------------------------------------------+
void CColorButton::InitializeProperties(const string text,const int x_gap,const int y_gap)
  {
   m_x          =CElement::CalculateX(x_gap);
   m_y          =CElement::CalculateY(y_gap);
   m_x_size     =(m_x_size<1)? 100 : m_x_size;
   m_y_size     =(m_y_size<1)? 20 : m_y_size;
   m_label_text =text;
   m_back_color =(m_back_color!=clrNONE)? m_back_color : m_main.BackColor();
//--- Отступы и цвет текстовой метки
   m_label_x_gap         =(m_label_x_gap!=WRONG_VALUE)? m_label_x_gap : 0;
   m_label_y_gap         =(m_label_y_gap!=WRONG_VALUE)? m_label_y_gap : 4;
   m_label_color         =(m_label_color!=clrNONE)? m_label_color : clrBlack;
   m_label_color_hover   =(m_label_color_hover!=clrNONE)? m_label_color_hover : C'0,120,215';
   m_label_color_locked  =(m_label_color_locked!=clrNONE)? m_label_color_locked : clrSilver;
//--- Отступы от крайней точки
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
  }
//+------------------------------------------------------------------+
//| Создаёт объект для рисования                                     |
//+------------------------------------------------------------------+
bool CColorButton::CreateCanvas(void)
  {
//--- Формирование имени объекта
   string name=CElementBase::ElementName("color_button");
//--- Создание объекта
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт кнопку                                                   |
//+------------------------------------------------------------------+
bool CColorButton::CreateButton(void)
  {
//--- Сохраним указатель на главный элемент
   m_button.MainPointer(this);
//--- Размеры
   int x_size=(m_button.XSize()<1)? 80 : m_button.XSize();
//--- Координаты
   int x =(m_button.XGap()<1)? x_size : m_button.XGap();
   int y =0;
//--- Отступы для картинки
   int icon_x_gap =(m_button.IconXGap()<1)? 4 : m_button.IconXGap();
   int icon_y_gap =(m_button.IconYGap()<1)? 3 : m_button.IconYGap();
//--- Отступы для текста
   int label_x_gap =(m_button.LabelXGap()<1)? 24 : m_button.LabelXGap();
   int label_y_gap =(m_button.LabelYGap()<1)? 4 : m_button.LabelYGap();
//--- Свойства
   m_button.XSize(x_size);
   m_button.YSize(m_y_size);
   m_button.IconXGap(icon_x_gap);
   m_button.IconYGap(icon_y_gap);
   m_button.LabelXGap(label_x_gap);
   m_button.LabelYGap(label_y_gap);
//--- Установка цвета для кнопки
   CurrentColor(m_current_color);
   m_button.IconFile(m_resource_name);
   m_button.IconFileLocked(m_resource_name);
//--- Создадим элемент управления
   if(!m_button.CreateButton(::ColorToString(m_current_color),x,y))
      return(false);
//--- Добавить элемент в массив
   CElement::AddToArray(m_button);
   return(true);
  }
//+------------------------------------------------------------------+
//| Изменяет текущий цвет параметра                                  |
//+------------------------------------------------------------------+
void CColorButton::CurrentColor(const color clr)
  {
//--- Сохраним цвет
   m_current_color=clr;
//--- Размер изображения и массива (image_size x image_size)
   uint image_size=14;
   uint image_data[196];
//--- Инициализация массива цветом
   for(uint y=0,i=0; y<image_size; y++)
     {
      for(uint x=0; x<image_size; x++,i++)
        {
         if(y<1 || y==image_size-1 || x<1 || x==image_size-1)
            image_data[i]=::ColorToARGB(C'160,160,160');
         else
            image_data[i]=::ColorToARGB(m_current_color);
        }
     }
//--- Создание ресурса в EX5-приложении
   ::ResetLastError();
   if(!::ResourceCreate(m_resource_name,image_data,image_size,image_size,0,0,0,COLOR_FORMAT_ARGB_NORMALIZE))
      ::Print(__FUNCTION__," > error: ",::GetLastError());
//---
   if(m_button.IconXGap()<1)
     {
      m_button.IconXGap(4);
      m_button.IconYGap(3);
     }
//--- Установка пути к изображению в свойствах кнопки
   m_button.IconFile(m_resource_name);
   m_button.IconFileLocked(m_resource_name);
//--- Установка текста для кнопки
   m_button.LabelText(::ColorToString(m_current_color));
  }
//+------------------------------------------------------------------+
//| Рисует элемент                                                   |
//+------------------------------------------------------------------+
void CColorButton::Draw(void)
  {
//--- Нарисовать фон
   CElement::DrawBackground();
//--- Нарисовать картинку
   CColorButton::DrawImage();
//--- Нарисовать текст
   CElement::DrawText();
  }
//+------------------------------------------------------------------+
//| Рисует картинку                                                  |
//+------------------------------------------------------------------+
void CColorButton::DrawImage(void)
  {
//--- Выйти, если (1) чек-бокс не нужен или (2) картинка не определена
   if(CElement::IconFile()=="")
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
//--- Рисуем картинку
   CElement::DrawImage();
  }
//+------------------------------------------------------------------+
