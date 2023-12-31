//+------------------------------------------------------------------+
//|                                                     CheckBox.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
//+------------------------------------------------------------------+
//| Класс для создания чек-бокса                                     |
//+------------------------------------------------------------------+
class CCheckBox : public CElement
  {
public:
                     CCheckBox(void);
                    ~CCheckBox(void);
   //--- Методы для создания чек-бокса
   bool              CreateCheckBox(const string text,const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const string text,const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   //---
public:
   //--- Состояние кнопки (нажата/отжата)
   bool              IsPressed(void) const { return(m_is_pressed); }
   void              IsPressed(const bool state);
   //---
public:
   //--- Обработчик событий графика
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Рисует элемент
   virtual void      Draw(void);
   //---
private:
   //--- Обработка нажатия на элемент
   bool              OnClickCheckbox(const string pressed_object);
   //--- Рисует картинку
   virtual void      DrawImage(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CCheckBox::CCheckBox(void)

  {
//--- Сохраним имя класса элемента в базовом классе
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CCheckBox::~CCheckBox(void)
  {
  }
//+------------------------------------------------------------------+
//| Обработка событий                                                |
//+------------------------------------------------------------------+
void CCheckBox::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
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
//--- Обработка события нажатия левой кнопки мыши на объекте
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      //--- Нажатие на чек-боксе
      if(OnClickCheckbox(sparam))
         return;
     }
  }
//+------------------------------------------------------------------+
//| Создаёт группу объектов чекбокс                                  |
//+------------------------------------------------------------------+
bool CCheckBox::CreateCheckBox(const string text,const int x_gap,const int y_gap)
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
void CCheckBox::InitializeProperties(const string text,const int x_gap,const int y_gap)
  {
   m_x          =CElement::CalculateX(x_gap);
   m_y          =CElement::CalculateY(y_gap);
   m_x_size     =(m_x_size<1)? 100 : m_x_size;
   m_y_size     =(m_y_size<1)? 14 : m_y_size;
   m_label_text =text;
//--- Цвет фона по умолчанию
   m_back_color=(m_back_color!=clrNONE)? m_back_color : m_main.BackColor();
//--- Отступы и цвет текстовой метки
   m_label_x_gap         =(m_label_x_gap!=WRONG_VALUE)? m_label_x_gap : 18;
   m_label_y_gap         =(m_label_y_gap!=WRONG_VALUE)? m_label_y_gap : 0;
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
bool CCheckBox::CreateCanvas(void)
  {
//--- Формирование имени объекта
   string name=CElementBase::ElementName("checkbox");
//--- Установка изображений
   IconFile(RESOURCE_CHECKBOX_OFF);
   IconFileLocked(RESOURCE_CHECKBOX_OFF_LOCKED);
   IconFilePressed(RESOURCE_CHECKBOX_ON);
   IconFilePressedLocked(RESOURCE_CHECKBOX_ON_LOCKED);
//--- Создание объекта
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Установка состояния элемента (нажат/отжат)                       |
//+------------------------------------------------------------------+
void CCheckBox::IsPressed(const bool state)
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
//| Нажатие на элемента                                              |
//+------------------------------------------------------------------+
bool CCheckBox::OnClickCheckbox(const string pressed_object)
  {
//--- Выйдем, если (1) чужое имя объекта или (2) элемент заблокирован
   if(m_canvas.ChartObjectName()!=pressed_object || CElementBase::IsLocked())
      return(false);
//--- Переключить на противоположное состояние
   IsPressed(!(IsPressed()));
//--- Перерисовать элемент
   Update(true);
//--- Отправим сообщение об этом
   ::EventChartCustom(m_chart_id,ON_CLICK_CHECKBOX,CElementBase::Id(),0,m_label_text);
   return(true);
  }
//+------------------------------------------------------------------+
//| Рисует элемент                                                   |
//+------------------------------------------------------------------+
void CCheckBox::Draw(void)
  {
//--- Нарисовать фон
   CElement::DrawBackground();
//--- Нарисовать картинку
   CCheckBox::DrawImage();
//--- Нарисовать текст
   CElement::DrawText();
  }
//+------------------------------------------------------------------+
//| Рисует картинку                                                  |
//+------------------------------------------------------------------+
void CCheckBox::DrawImage(void)
  {
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
