//+------------------------------------------------------------------+
//|                                                     TreeItem.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "Button.mqh"
//+------------------------------------------------------------------+
//| Класс для создания пункта древовидного списка                    |
//+------------------------------------------------------------------+
class CTreeItem : public CButton
  {
private:
   //--- Отступ для стрелки (признака наличия списка)
   int               m_arrow_x_gap;
   //--- Тип пункта
   ENUM_TYPE_TREE_ITEM m_item_type;
   //--- Индекс пункта в общем списке
   int               m_list_index;
   //--- Уровень узла
   int               m_node_level;
   //--- Отображаемый текст пункта
   string            m_item_text;
   //--- Состояние списка пункта (открыт/свёрнут)
   bool              m_item_state;
   //---
public:
                     CTreeItem(void);
                    ~CTreeItem(void);
   //--- Методы для создания пункта древовидного списка
   bool              CreateTreeItem(const int x_gap,const int y_gap,const ENUM_TYPE_TREE_ITEM type,
                                    const int list_index,const int node_level,const string text,const bool item_state);
   //---
private:
   void              InitializeProperties(const int x_gap,const int y_gap,const ENUM_TYPE_TREE_ITEM type,
                                          const int list_index,const int node_level,const string text,const bool item_state);
   //---
public:
   //--- (1) Состояние пункта (свёрнут/развёрнут), (2) тип пункта
   void              ItemState(const int state);
   bool              ItemState(void) const { return(m_item_state); }
   ENUM_TYPE_TREE_ITEM Type(void)    const { return(m_item_type);  }
   //--- Отступ для стрелки
   int               ArrowXGap(const int node_level);
   int               ArrowXGap(void) const { return(m_arrow_x_gap); }
   //--- Обновление координат и ширины
   void              UpdateX(const int x);
   void              UpdateY(const int y);
   void              UpdateWidth(const int width);
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
CTreeItem::CTreeItem(void) : m_node_level(0),
                             m_arrow_x_gap(5),
                             m_item_type(TI_SIMPLE)
  {
//--- Сохраним имя класса элемента в базовом классе
   CElementBase::ClassName(CLASS_NAME);
//--- Пункт будет выпалающим элементом
   CElementBase::IsDropdown(true);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CTreeItem::~CTreeItem(void)
  {
  }
//+------------------------------------------------------------------+
//| Обработчик событий                                               |
//+------------------------------------------------------------------+
void CTreeItem::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Выйти, если главный элемент недоступен
   if(!m_main.CElementBase::IsAvailable())
      return;
//--- Обработать событие в базовом классе
   CButton::OnEvent(id,lparam,dparam,sparam);
  }
//+------------------------------------------------------------------+
//| Создаёт пункт древовидного списка                                |
//+------------------------------------------------------------------+
bool CTreeItem::CreateTreeItem(const int x_gap,const int y_gap,const ENUM_TYPE_TREE_ITEM type,
                               const int list_index,const int node_level,const string text,const bool item_state)
  {
//--- Выйти, если нет указателя на главный элемент
   if(!CElement::CheckMainPointer())
      return(false);
//--- Инициализация свойств
   InitializeProperties(x_gap,y_gap,type,list_index,node_level,text,item_state);
//--- Установить картинки, если пункт имеет выпадающий список
   if(m_item_type==TI_HAS_ITEMS)
     {
      CElement::AddImagesGroup(m_arrow_x_gap,2);
      CElement::AddImage(1,RESOURCE_DOWN_THICK_BLACK);
      CElement::AddImage(1,RESOURCE_RIGHT_THICK_BLACK);
      //--- Выбрать соответствующее изображение
      CButton::ChangeImage(1,(m_item_state)? 1 : 0);
     }
//--- Свойства
   CButton::TwoState(true);
//--- Создадим элемент управления
   if(!CButton::CreateButton(text,x_gap,y_gap))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Инициализация свойств                                            |
//+------------------------------------------------------------------+
void CTreeItem::InitializeProperties(const int x_gap,const int y_gap,const ENUM_TYPE_TREE_ITEM type,
                                     const int list_index,const int node_level,const string text,const bool item_state)
  {
   m_x           =CElement::CalculateX(x_gap);
   m_y           =CElement::CalculateY(y_gap);
   m_item_type   =type;
   m_list_index  =list_index;
   m_node_level  =node_level;
   m_item_text   =text;
   m_item_state  =item_state;
   m_label_text  =text;
//--- Свойства по умолчанию
   m_back_color           =m_main.BackColor();
   m_back_color_hover     =C'229,243,255';
   m_back_color_pressed   =C'204,232,255';
   m_border_color         =m_main.BackColor();
   m_border_color_hover   =m_back_color_hover;
   m_border_color_pressed =C'153,209,255';
   m_label_color          =clrBlack;
   m_label_color_hover    =clrBlack;
   m_label_color_pressed  =clrBlack;
   m_label_x_gap          =(m_label_x_gap!=WRONG_VALUE)? m_icon_x_gap+m_label_x_gap : m_icon_x_gap+22;
   m_label_y_gap          =4;
//--- Отступы от крайней точки
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
  }
//+------------------------------------------------------------------+
//| Установка состояния пункта (свёрнут/развёрнут)                   |
//+------------------------------------------------------------------+
void CTreeItem::ItemState(const int state)
  {
   m_item_state=state;

  }
//+------------------------------------------------------------------+
//| Отступ для стрелки                                               |
//+------------------------------------------------------------------+
int CTreeItem::ArrowXGap(const int node_level)
  {
   return((m_arrow_x_gap=(node_level>0)? (12*node_level)+5 : 5));
  }
//+------------------------------------------------------------------+
//| Обновление координаты X                                          |
//+------------------------------------------------------------------+
void CTreeItem::UpdateX(const int x)
  {
//--- Обновление общих координат и отступа от крайней точки
   CElementBase::X(CElement::CalculateX(x));
   CElementBase::XGap(x);
//--- Координаты и отступ
   m_canvas.X(x);
   m_canvas.XGap(x);
  }
//+------------------------------------------------------------------+
//| Обновление координаты Y                                          |
//+------------------------------------------------------------------+
void CTreeItem::UpdateY(const int y)
  {
//--- Обновление общих координат и отступа от крайней точки
   CElementBase::Y(CElement::CalculateY(y));
   CElementBase::YGap(y);
//--- Координаты и отступ
   m_canvas.Y(y);
   m_canvas.YGap(y);
  }
//+------------------------------------------------------------------+
//| Обновление ширины                                                |
//+------------------------------------------------------------------+
void CTreeItem::UpdateWidth(const int width)
  {
//--- Ширина фона
   CElementBase::XSize(width);
   m_canvas.XSize(width);
   m_canvas.Resize(width,m_y_size);
  }
//+------------------------------------------------------------------+
//| Рисует элемент                                                   |
//+------------------------------------------------------------------+
void CTreeItem::Draw(void)
  {
//--- Нарисовать фон
   CButton::DrawBackground();
//--- Нарисовать картинку
   if(m_item_type==TI_HAS_ITEMS)
      CTreeItem::DrawImage();
   else
      CButton::DrawImage();
//--- Нарисовать текст
   CElement::DrawText();
  }
//+------------------------------------------------------------------+
//| Рисует картинку                                                  |
//+------------------------------------------------------------------+
void CTreeItem::DrawImage(void)
  {
//--- Определим индекс
   uint image_index=(m_item_state)? 0 : 1;
//--- Сохранить индекс выбранного изображения
   CElement::ChangeImage(1,image_index);
//--- Рисуем картинку
   CElement::DrawImage();
  }
//+------------------------------------------------------------------+
