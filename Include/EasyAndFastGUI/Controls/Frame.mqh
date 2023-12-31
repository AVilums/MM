//+------------------------------------------------------------------+
//|                                                        Frame.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "TextLabel.mqh"
//+------------------------------------------------------------------+
//| Класс для создания области для группирования элементов           |
//+------------------------------------------------------------------+
class CFrame : public CElement
  {
private:
   //--- Экземпляры для создания элемента
   CTextLabel        m_text_label;
   //--- 
public:
                     CFrame(void);
                    ~CFrame(void);
   //--- Возвращает указатель текстовой метки
   CTextLabel       *GetTextLabelPointer(void) { return(::GetPointer(m_text_label)); }
   //--- Методы для создания области
   bool              CreateFrame(const string text,const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const string text,const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   bool              CreateTextLabel(void);
   //---
public:
   //--- Рисует элемент
   virtual void      Draw(void);
   //---
private:
   //--- Изменить ширину по правому краю окна
   virtual void      ChangeWidthByRightWindowSide(void);
   //--- Изменить высоту по нижнему краю окна
   virtual void      ChangeHeightByBottomWindowSide(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CFrame::CFrame(void)
  {
//--- Сохраним имя класса элемента в базовом классе
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CFrame::~CFrame(void)
  {
  }
//+------------------------------------------------------------------+
//| Создаёт группу объектов текстового поля ввода                    |
//+------------------------------------------------------------------+
bool CFrame::CreateFrame(const string text,const int x_gap,const int y_gap)
  {
//--- Выйти, если нет указателя на главный элемент
   if(!CElement::CheckMainPointer())
      return(false);
//--- Инициализация свойств
   InitializeProperties(text,x_gap,y_gap);
//--- Создание элемента
   if(!CreateCanvas())
      return(false);
   if(!CreateTextLabel())
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Инициализация свойств                                            |
//+------------------------------------------------------------------+
void CFrame::InitializeProperties(const string text,const int x_gap,const int y_gap)
  {
   m_x          =CElement::CalculateX(x_gap);
   m_y          =CElement::CalculateY(y_gap);
   m_x_size     =(m_x_size<1 || m_auto_xresize_mode)? m_main.X2()-m_x-m_auto_xresize_right_offset : m_x_size;
   m_y_size     =(m_y_size<1 || m_auto_yresize_mode)? m_main.Y2()-m_y-m_auto_yresize_bottom_offset : m_y_size;
   m_label_text =text;
//--- Цвет фона по умолчанию
   m_back_color=(m_back_color!=clrNONE)? m_back_color : m_main.BackColor();
//--- Отступы и цвет текстовой метки
   m_label_color =(m_label_color!=clrNONE)? m_label_color : clrBlack;
   m_label_x_gap =(m_label_x_gap!=WRONG_VALUE)? m_label_x_gap : 0;
   m_label_y_gap =(m_label_y_gap!=WRONG_VALUE)? m_label_y_gap : 0;
//--- Отступы от крайней точки
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
  }
//+------------------------------------------------------------------+
//| Создаёт объект для рисования                                     |
//+------------------------------------------------------------------+
bool CFrame::CreateCanvas(void)
  {
//--- Формирование имени объекта
   string name=CElementBase::ElementName("frame");
//--- Создание объекта
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   ShowTooltip(true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт текстовую метку                                          |
//+------------------------------------------------------------------+
bool CFrame::CreateTextLabel(void)
  {
//--- Сохраним указатель на родительский элемент
   m_text_label.MainPointer(this);
//--- КоординатЫ
   int x=12;
   int y=-6;
//--- Свойства
   if(m_label_text=="")
     {
      y=1;
      m_text_label.YSize(1);
      m_border_color=m_back_color;
     }
//---
   m_text_label.LabelXGap(5);
   m_text_label.Font(CElement::Font());
   m_text_label.FontSize(CElement::FontSize());
//--- Создание объекта
   if(!m_text_label.CreateTextLabel(m_label_text,x,y))
      return(false);
//--- Добавить элемент в массив
   CElement::AddToArray(m_text_label);
   return(true);
  }
//+------------------------------------------------------------------+
//| Изменить ширину по правому краю формы                            |
//+------------------------------------------------------------------+
void CFrame::ChangeWidthByRightWindowSide(void)
  {
//--- Выйти, если включен режим привязки к правой части окна
   if(m_anchor_right_window_side)
      return;
//--- Размеры
   int x_size=0;
//--- Рассчитать и установить новый размер фону элемента
   x_size=m_main.X2()-m_canvas.X()-m_auto_xresize_right_offset;
//--- Не изменять размер, если меньше установленного ограничения
   if(x_size==m_x_size)
      return;
//---
   CElementBase::XSize(x_size);
   m_canvas.XSize(x_size);
   m_canvas.Resize(x_size,m_y_size);
//--- Перерисовать элемент
   Draw();
//--- Обновить положение объектов
   Moving();
  }
//+------------------------------------------------------------------+
//| Изменить высоту по нижнему краю окна                             |
//+------------------------------------------------------------------+
void CFrame::ChangeHeightByBottomWindowSide(void)
  {
//--- Выйти, если включен режим привязки к нижней части окна
   if(m_anchor_bottom_window_side)
      return;
//--- Размеры
   int y_size=0;
//--- Рассчитать и установить новый размер фону элемента
   y_size=m_main.Y2()-m_canvas.Y()-m_auto_yresize_bottom_offset;
//--- Не изменять размер, если меньше установленного ограничения
   if(y_size==m_y_size)
      return;
//---
   CElementBase::YSize(y_size);
   m_canvas.YSize(y_size);
   m_canvas.Resize(m_x_size,y_size);
//--- Перерисовать элемент
   Draw();
//--- Обновить положение объектов
   Moving();
  }
//+------------------------------------------------------------------+
//| Рисует элемент                                                   |
//+------------------------------------------------------------------+
void CFrame::Draw(void)
  {
//--- Нарисовать фон
   CElement::DrawBackground();
//--- Нарисовать рамку
   CElement::DrawBorder();
  }
//+------------------------------------------------------------------+
