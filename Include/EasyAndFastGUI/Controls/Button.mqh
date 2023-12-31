//+------------------------------------------------------------------+
//|                                                       Button.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
//+------------------------------------------------------------------+
//| Класс для создания кнопки                                        |
//+------------------------------------------------------------------+
class CButton : public CElement
  {
private:
   //--- Режим двух состояний кнопки
   bool              m_two_state;
   //---
public:
                     CButton(void);
                    ~CButton(void);
   //--- Методы для создания кнопки
   bool              CreateButton(const string text,const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const string text,const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   //---
public:
   //--- (1) Установка режима кнопки, (2) состояние кнопки (нажата/отжата)
   bool              TwoState(void)                       const { return(m_two_state);  }
   void              TwoState(const bool flag)                  { m_two_state=flag;     }
   bool              IsPressed(void)                      const { return(m_is_pressed); }
   void              IsPressed(const bool state);
   //--- Установка ярлыков для кнопки в нажатом состоянии (доступен/заблокирован)
   void              IconFilePressed(const string file_path);
   void              IconFilePressedLocked(const string file_path);
   //--- Изменение размеров
   void              ChangeSize(const uint x_size,const uint y_size);
   //---
public:
   //--- Обработчик событий графика
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Рисует элемент
   virtual void      Draw(void);
   //---
protected:
   //--- Рисует фон
   virtual void      DrawBackground(void);
   //--- Рисует рамку
   virtual void      DrawBorder(void);
   //--- Рисует картинку
   virtual void      DrawImage(void);
   //---
private:
   //--- Обработка нажатия на кнопке
   bool              OnClickButton(const string pressed_object);
   //--- Изменить ширину по правому краю окна
   virtual void      ChangeWidthByRightWindowSide(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CButton::CButton(void) : m_two_state(false)
  {
//--- Сохраним имя класса элемента в базовом классе  
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CButton::~CButton(void)
  {
  }
//+------------------------------------------------------------------+
//| Обработчик событий                                               |
//+------------------------------------------------------------------+
void CButton::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Обработка события перемещения курсора
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Перерисовать элемент, если было пересечение границ
      if(CElementBase::CheckCrossingBorder())
         Update(true);
      //---
      return;
     }
//--- Обработка события нажатия левой кнопки мыши на объекте
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      if(OnClickButton(sparam))
         return;
      //---
      return;
     }
//--- Обработка события изменения состояния левой кнопки мыши
   if(id==CHARTEVENT_CUSTOM+ON_CHANGE_MOUSE_LEFT_BUTTON)
     {
      if(!CElementBase::MouseFocus())
         return;
      //--- Перерисовать элемент
      Update(true);
      return;
     }
  }
//+------------------------------------------------------------------+
//| Создаёт элемент                                                  |
//+------------------------------------------------------------------+
bool CButton::CreateButton(const string text,const int x_gap,const int y_gap)
  {
//--- Выйти, если нет указателя на главный элемент
   if(!CElement::CheckMainPointer())
      return(false);
//--- Инициализация свойств
   InitializeProperties(text,x_gap,y_gap);
//--- Создание элемента
   if(!CButton::CreateCanvas())
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Инициализация свойств                                            |
//+------------------------------------------------------------------+
void CButton::InitializeProperties(const string text,const int x_gap,const int y_gap)
  {
   m_x          =CElement::CalculateX(x_gap);
   m_y          =CElement::CalculateY(y_gap);
   m_x_size     =(m_x_size<1 || m_auto_xresize_mode)? m_main.X2()-CElementBase::X()-m_auto_xresize_right_offset : m_x_size;
   m_y_size     =(m_y_size<1)? 20 : m_y_size;
   m_label_text =text;
//--- Цвет фона по умолчанию
   m_back_color         =(m_back_color!=clrNONE)? m_back_color : clrGainsboro;
   m_back_color_hover   =(m_back_color_hover!=clrNONE)? m_back_color_hover : C'229,241,251';
   m_back_color_locked  =(m_back_color_locked!=clrNONE)? m_back_color_locked : clrLightGray;
   m_back_color_pressed =(m_back_color_pressed!=clrNONE)? m_back_color_pressed : C'204,228,247';
//--- Цвет рамки по умолчанию
   m_border_color         =(m_border_color!=clrNONE)? m_border_color : C'150,170,180';
   m_border_color_hover   =(m_border_color_hover!=clrNONE)? m_border_color_hover : C'0,120,215';
   m_border_color_locked  =(m_border_color_locked!=clrNONE)? m_border_color_locked : clrDarkGray;
   m_border_color_pressed =(m_border_color_pressed!=clrNONE)? m_border_color_pressed : C'0,84,153';
//--- Отступы и цвет текстовой метки и картинки
   m_icon_x_gap          =(m_icon_x_gap!=WRONG_VALUE)? m_icon_x_gap : 0;
   m_icon_y_gap          =(m_icon_y_gap!=WRONG_VALUE)? m_icon_y_gap : 0;
   m_label_x_gap         =(m_label_x_gap!=WRONG_VALUE)? m_label_x_gap : 24;
   m_label_y_gap         =(m_label_y_gap!=WRONG_VALUE)? m_label_y_gap : 4;
   m_label_color         =(m_label_color!=clrNONE)? m_label_color : clrBlack;
   m_label_color_hover   =(m_label_color_hover!=clrNONE)? m_label_color_hover : clrBlack;
   m_label_color_locked  =(m_label_color_locked!=clrNONE)? m_label_color_locked : clrGray;
   m_label_color_pressed =(m_label_color_pressed!=clrNONE)? m_label_color_pressed : clrBlack;
//--- Отступы от крайней точки
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
  }
//+------------------------------------------------------------------+
//| Создаёт объект для рисования                                     |
//+------------------------------------------------------------------+
bool CButton::CreateCanvas(void)
  {
//--- Формирование имени объекта
   string name=CElementBase::ElementName("button");
//--- Создание объекта
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Установка состояния кнопки - нажата/отжата                       |
//+------------------------------------------------------------------+
void CButton::IsPressed(const bool state)
  {
//--- Выйти, если (1) не в режиме "Два состояния" или (2) элемент заблокирован или (3) кнопка уже в таком состоянии
   if(!m_two_state || CElementBase::IsLocked() || m_is_pressed==state)
      return;
//--- Установка состояния
   m_is_pressed=state;
//--- Установить соответствующую картинку
   CElement::ChangeImage(0,!m_is_pressed? 0 : 2);
  }
//+------------------------------------------------------------------+
//| Установка картинки для нажатого состояния (доступен)             |
//+------------------------------------------------------------------+
void CButton::IconFilePressed(const string file_path)
  {
//--- Выйти, если у кнопки отключен режим "Два состояния"
   if(!m_two_state)
      return;
//--- Добавить изображение
   CElement::IconFilePressed(file_path);
  }
//+------------------------------------------------------------------+
//| Установка картинки для нажатого состояния (заблокирован)         |
//+------------------------------------------------------------------+
void CButton::IconFilePressedLocked(const string file_path)
  {
//--- Выйти, если у кнопки отключен режим "Два состояния"
   if(!m_two_state)
      return;
//--- Добавить изображение
   CElement::IconFilePressedLocked(file_path);
  }
//+------------------------------------------------------------------+
//| Изменение размеров                                               |
//+------------------------------------------------------------------+
void CButton::ChangeSize(const uint x_size,const uint y_size)
  {
   int images_group=(int)ImagesGroupTotal();
   for(int i=0; i<images_group; i++)
     {
      int right_gap =m_x_size-ImageGroupXGap(i);
      ImageGroupXGap(i,(int)x_size-right_gap);
     }
//--- Установить новый размер
   CElementBase::XSize(x_size);
   CElementBase::YSize(y_size);
   m_canvas.XSize(m_x_size);
   m_canvas.YSize(m_y_size);
   m_canvas.Resize(m_x_size,m_y_size);
  }
//+------------------------------------------------------------------+
//| Нажатие на кнопку                                                |
//+------------------------------------------------------------------+
bool CButton::OnClickButton(const string pressed_object)
  {
//--- Выйдем, если (1) чужое имя объекта или (2) элемент заблокирован
   if(m_canvas.ChartObjectName()!=pressed_object || CElementBase::IsLocked())
      return(false);
//--- Если это кнопка с двумя состояниями
   if(m_two_state)
      IsPressed(!IsPressed());
//--- Перерисовать элемент
   Update(true);
//--- Отправим сообщение об этом
   ::EventChartCustom(m_chart_id,ON_CLICK_BUTTON,CElementBase::Id(),CElementBase::Index(),m_canvas.ChartObjectName());
   return(true);
  }
//+------------------------------------------------------------------+
//| Рисует элемент                                                   |
//+------------------------------------------------------------------+
void CButton::Draw(void)
  {
//--- Нарисовать фон
   DrawBackground();
//--- Нарисовать рамку
   DrawBorder();
//--- Нарисовать картинку
   DrawImage();
//--- Нарисовать текст
   CElement::DrawText();
  }
//+------------------------------------------------------------------+
//| Рисует фон                                                       |
//+------------------------------------------------------------------+
void CButton::DrawBackground(void)
  {
//--- Определим цвет
   uint clr=(m_is_pressed)? m_back_color_pressed : m_back_color;
//--- Если элемент не заблокирован
   if(!CElementBase::IsLocked())
     {
      if(CElementBase::MouseFocus())
         clr=(m_mouse.LeftButtonState() || m_is_pressed)? m_back_color_pressed : m_back_color_hover;
     }
   else
      clr=m_back_color_locked;
//--- Рисуем фон
   CElement::m_canvas.Erase(::ColorToARGB(clr,m_alpha));
  }
//+------------------------------------------------------------------+
//| Рисует рамку поля ввода                                          |
//+------------------------------------------------------------------+
void CButton::DrawBorder(void)
  {
//--- Определим цвет
   uint clr=(m_is_pressed)? m_border_color_pressed : m_border_color;
//--- Если элемент не заблокирован
   if(!CElementBase::IsLocked())
     {
      if(CElementBase::MouseFocus())
         clr=(m_mouse.LeftButtonState() || m_is_pressed)? m_border_color_pressed : m_border_color_hover;
     }
   else
      clr=m_border_color_locked;
//--- Координаты
   int x1=0,y1=0;
   int x2=(int)::ObjectGetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_XSIZE)-1;
   int y2=(int)::ObjectGetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_YSIZE)-1;
//--- Рисуем прямоугольник без заливки
   m_canvas.Rectangle(x1,y1,x2,y2,::ColorToARGB(clr));
  }
//+------------------------------------------------------------------+
//| Рисует картинку                                                  |
//+------------------------------------------------------------------+
void CButton::DrawImage(void)
  {
//--- Определим индекс
   uint image_index=(!m_two_state)? 0 :(m_is_pressed)? 2 : 0;
//--- Если элемент не заблокирован
   if(!CElementBase::IsLocked())
     {
      if(!m_two_state)
         image_index=0;
      else
        {
         if(CElementBase::MouseFocus())
            image_index=(m_mouse.LeftButtonState() || m_is_pressed)? 2 : 0;
        }
     }
   else
      image_index=(!m_two_state)? 1 :(m_is_pressed)? 3 : 1;
//--- Сохранить индекс выбранного изображения
   CElement::ChangeImage(0,image_index);
//--- Рисуем картинку
   CElement::DrawImage();
  }
//+------------------------------------------------------------------+
//| Изменить ширину по правому краю формы                            |
//+------------------------------------------------------------------+
void CButton::ChangeWidthByRightWindowSide(void)
  {
//--- Выйти, если включен режим фиксации к правому краю формы
   if(m_anchor_right_window_side)
      return;
//--- Координаты
   int x=0;
//--- Размеры
   int x_size =m_main.X2()-CElementBase::X()-m_auto_xresize_right_offset;
   int y_size =(m_auto_yresize_mode)? m_main.Y2()-CElementBase::Y()-m_auto_yresize_bottom_offset : m_y_size;
//--- Установить новый размер
   m_canvas.Resize(x_size,y_size);
//--- Перерисовать элемент
   Draw();
  }
//+------------------------------------------------------------------+
