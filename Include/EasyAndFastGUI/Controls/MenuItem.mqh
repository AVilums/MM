//+------------------------------------------------------------------+
//|                                                     MenuItem.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "Button.mqh"
class CContextMenu;
//+------------------------------------------------------------------+
//| Класс создания пункта меню                                       |
//+------------------------------------------------------------------+
class CMenuItem : public CButton
  {
private:
   //--- Указатель на предыдущий узел
   CMenuItem        *m_prev_node;
   //--- Указатель на привязанное контекстное меню
   CContextMenu     *m_context_menu;
   //--- Тип пункта меню
   ENUM_TYPE_MENU_ITEM m_type_menu_item;
   //--- Свойства признака контекстного меню
   bool              m_show_right_arrow;
   int               m_arrow_x_gap;
   //--- Состояние чекбокса
   bool              m_checkbox_state;
   //--- Состояние радио-кнопки и её идентификатор
   bool              m_radiobutton_state;
   int               m_radiobutton_id;
   //---
public:
                     CMenuItem(void);
                    ~CMenuItem(void);
   //--- Методы для создания пункта меню
   bool              CreateMenuItem(const string text,const int x_gap,const int y_gap);
   //---
public:
   //--- (1) Получение и (2) сохранение указателя предыдущего узла
   void              GetPrevNodePointer(CMenuItem &object)                { m_prev_node=::GetPointer(object);    }
   CMenuItem        *GetPrevNodePointer(void)                       const { return(m_prev_node);                 }
   void              GetContextMenuPointer(CContextMenu &object)          { m_context_menu=::GetPointer(object); }
   CContextMenu     *GetContextMenuPointer(void)                    const { return(m_context_menu);              }
   //--- (1) Установка и получение типа, (2) номер индекса
   void              TypeMenuItem(const ENUM_TYPE_MENU_ITEM type)         { m_type_menu_item=type;               }
   ENUM_TYPE_MENU_ITEM TypeMenuItem(void)                           const { return(m_type_menu_item);            }
   //--- (1) Отображение признака наличия контекстного меню, (2) общее состояние пункта-чекбокса
   void              ShowRightArrow(const bool flag)                      { m_show_right_arrow=flag;             }
   bool              CheckBoxState(void)                            const { return(m_checkbox_state);            }
   void              CheckBoxState(const bool state);
   //--- (1) Идентификатор радио-пункта, (2) состояние радио-пункта
   void              RadioButtonID(const int id)                          { m_radiobutton_id=id;                 }
   int               RadioButtonID(void)                            const { return(m_radiobutton_id);            }
   bool              RadioButtonState(void)                         const { return(m_radiobutton_state);         }
   void              RadioButtonState(const bool state);
   //---
public:
   //--- Обработчик событий графика
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Управление
   virtual void      Show(void);
   virtual void      Hide(void);
   //--- Рисует элемент
   virtual void      Draw(void);
   //---
private:
   //--- Нажатие на пункте меню
   bool              OnClickMenuItem(const string pressed_object,const int id,const int index);
   //--- Рисует картинку
   virtual void      DrawImage(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CMenuItem::CMenuItem(void) : m_type_menu_item(MI_SIMPLE),
                             m_checkbox_state(true),
                             m_radiobutton_id(0),
                             m_radiobutton_state(false),
                             m_show_right_arrow(true),
                             m_arrow_x_gap(18)
  {
//--- Сохраним имя класса элемента в базовом классе
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CMenuItem::~CMenuItem(void)
  {
  }
//+------------------------------------------------------------------+
//| Обработчик событий                                               |
//+------------------------------------------------------------------+
void CMenuItem::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Обработать событие в базовом классе
   CButton::OnEvent(id,lparam,dparam,sparam);
//--- Обработка события нажатия левой кнопки мыши на элементе
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)
     {
      if(OnClickMenuItem(sparam,(uint)lparam,(uint)dparam))
         return;
      //---
      return;
     }
  }
//+------------------------------------------------------------------+
//| Создаёт элемент "Пункт меню"                                     |
//+------------------------------------------------------------------+
bool CMenuItem::CreateMenuItem(const string text,const int x_gap,const int y_gap)
  {
//--- Выйти, если нет указателя на главный элемент
   if(!CElement::CheckMainPointer())
      return(false);
//--- Если указателя на предыдущий узел нет, то пункт не является частью контекстного меню
   if(::CheckPointer(m_prev_node)==POINTER_INVALID)
     {
      //--- Выйти, если установленный тип не соответствует
      if(m_type_menu_item!=MI_SIMPLE && m_type_menu_item!=MI_HAS_CONTEXT_MENU)
        {
         ::Print(__FUNCTION__," > Тип независимого пункта меню может быть только MI_SIMPLE или MI_HAS_CONTEXT_MENU, ",
                 "то есть, с наличием контекстного меню.\n",
                 __FUNCTION__," > Установить тип пункта меню можно с помощью метода CMenuItem::TypeMenuItem()");
         return(false);
        }
     }
//--- Определим ярлыки, если пункт имеет выпадающее меню 
   if(m_type_menu_item==MI_HAS_CONTEXT_MENU)
     {
      CButton::TwoState(true);
      //--- Если нужно отображать стрелку, как признак наличия контекстного меню
      if(m_show_right_arrow)
        {
         if(CButton::ImagesGroupTotal()<2)
           {
            CButton::AddImagesGroup(CElementBase::XSize()-m_arrow_x_gap,CElement::IconYGap());
            CButton::AddImage(1,RESOURCE_ARROW_RIGHT_BLACK);
            CButton::AddImage(1,RESOURCE_ARROW_RIGHT_WHITE);
           }
        }
     }
//--- Если это чекбокс
   if(m_type_menu_item==MI_CHECKBOX)
     {
      //--- Изображения по умолчанию
      CButton::SetImage(0,0,RESOURCE_CHECKBOX_MINI_BLACK);
      CButton::SetImage(0,1,RESOURCE_CHECKBOX_MINI_WHITE);
      CButton::AddImage(0,INT_MAX);
     }
//--- Если это радио-пункт
   else if(m_type_menu_item==MI_RADIOBUTTON)
     {
      //--- Изображения по умолчанию
      CButton::SetImage(0,0,RESOURCE_CHECKBOX_MINI_BLACK);
      CButton::SetImage(0,1,RESOURCE_CHECKBOX_MINI_WHITE);
      CButton::AddImage(0,INT_MAX);
     }
//--- Свойства
   CButton::NamePart("menu_item");
//--- Создадим элемент управления
   if(!CButton::CreateButton(text,x_gap,y_gap))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Изменение состояния пункта меню типа чекбокс                     |
//+------------------------------------------------------------------+
void CMenuItem::CheckBoxState(const bool state)
  {
   m_checkbox_state=state;
   Update(true);
  }
//+------------------------------------------------------------------+
//| Изменение состояния пункта меню типа радиопункт                  |
//+------------------------------------------------------------------+
void CMenuItem::RadioButtonState(const bool state)
  {
   m_radiobutton_state=state;
   Update(true);
  }
//+------------------------------------------------------------------+
//| Делает видимым пункт меню                                        |
//+------------------------------------------------------------------+
void CMenuItem::Show(void)
  {
//--- Выйти, если элемент уже видим
   if(CElementBase::IsVisible())
      return;
//--- Показать элемент
   CButton::Show();
//--- Обновить положение объектов
   Moving();
  }
//+------------------------------------------------------------------+
//| Скрывает пункт меню                                              |
//+------------------------------------------------------------------+
void CMenuItem::Hide(void)
  {
//--- Выйти, если элемент скрыт
   if(!CElementBase::IsVisible())
      return;
//--- Скрыть элемент
   CButton::Hide();
//--- Обнуление переменных
   CElementBase::IsVisible(false);
   CElementBase::MouseFocus(false);
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на пункте меню                                 |
//+------------------------------------------------------------------+
bool CMenuItem::OnClickMenuItem(const string pressed_object,const int id,const int index)
  {
//--- Выйдем, если нажатие было не на кнопке
   if(::StringFind(pressed_object,"menu_item")<0)
      return(false);
//--- Выйти, если (1) идентификаторы не совпадают или (2) элемент заблокирован
   if(id!=CElementBase::Id() || index!=CElementBase::Index() || CElementBase::IsLocked())
      return(false);
      
//--- Если этот пункт содержит контекстное меню
   if(m_type_menu_item==MI_HAS_CONTEXT_MENU)
     {
      if(::CheckPointer(m_context_menu)==POINTER_INVALID)
         return(true);
      //--- Если выпадающее меню этого пункта не активировано
      if(!m_context_menu.IsVisible())
        {
         //--- Показать контекстное меню
         m_context_menu.Show();
         //--- Сообщение на восстановление доступных элементов
         ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),0,"");
         //--- Отправим сообщение об изменении в графическом интерфейсе
         ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0.0,"");
        }
      else
        {
         int is_restore=1;
         if(CheckPointer(m_prev_node)!=POINTER_INVALID)
            is_restore=0;
         //--- Скрыть контекстное меню
         m_context_menu.Hide();
         //--- Отправим сигнал для закрытия контекстных меню, которые дальше этого пункта
         ::EventChartCustom(m_chart_id,ON_HIDE_BACK_CONTEXTMENUS,CElementBase::Id(),0,"");
         //--- Сообщение на восстановление доступных элементов
         ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),is_restore,"");
         //--- Отправим сообщение об изменении в графическом интерфейсе
         ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0.0,"");
        }
     }
//--- Если этот пункт не содержит контекстное меню, но является частью контекстного меню
   else
     {
      //--- Префикс сообщения с именем программы
      string message=CElementBase::ProgramName();
      //--- Если это чекбокс, изменим его состояние
      if(m_type_menu_item==MI_CHECKBOX)
        {
         m_checkbox_state=(m_checkbox_state)? false : true;
         //--- Добавим в сообщение, что это чекбокс
         message+="_checkbox";
        }
      //--- Если это радио-пункт, изменим его состояние
      else if(m_type_menu_item==MI_RADIOBUTTON)
        {
         m_radiobutton_state=(m_radiobutton_state)? false : true;
         //--- Добавим в сообщение, что это радио-пункт
         message+="_radioitem_"+(string)m_radiobutton_id;
        }
      //--- Отжать кнопку
      CElementBase::MouseFocus(false);
      CElement::Update(true);
      //--- Отправим сообщение об этом
      ::EventChartCustom(m_chart_id,ON_CLICK_MENU_ITEM,CElementBase::Id(),CElementBase::Index(),message);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Рисует элемент                                                   |
//+------------------------------------------------------------------+
void CMenuItem::Draw(void)
  {
//--- Нарисовать фон
   CButton::DrawBackground();
//--- Нарисовать рамку
   CButton::DrawBorder();
//--- Нарисовать картинку
   if(m_type_menu_item!=MI_SIMPLE)
      CMenuItem::DrawImage();
   else
      CButton::DrawImage();
//--- Нарисовать текст
   CElement::DrawText();
  }
//+------------------------------------------------------------------+
//| Рисует картинку                                                  |
//+------------------------------------------------------------------+
void CMenuItem::DrawImage(void)
  {
//--- Определим индекс
   uint image_index=0;
//---
   if(m_type_menu_item==MI_CHECKBOX)
     {
      image_index=(m_checkbox_state)?(m_mouse_focus)? 1 : 0 : 2;
      //--- Сохранить индекс выбранного изображения
      CElement::ChangeImage(0,image_index);
     }
   else if(m_type_menu_item==MI_RADIOBUTTON)
     {
      image_index=(m_radiobutton_state)?(m_mouse_focus)? 1 : 0 : 2;
      //--- Сохранить индекс выбранного изображения
      CElement::ChangeImage(0,image_index);
     }
   else if(m_type_menu_item==MI_HAS_CONTEXT_MENU)
     {
      image_index=(m_mouse_focus || m_is_pressed)? 1 : 0;
      //--- Сохранить индекс выбранного изображения
      CElement::ChangeImage(0,0);
      CElement::ChangeImage(1,image_index);
     }
   else
     {
      //--- Сохранить индекс выбранного изображения
      CElement::ChangeImage(0,image_index);
     }
//--- Рисуем картинку
   CElement::DrawImage();
  }
//+------------------------------------------------------------------+
