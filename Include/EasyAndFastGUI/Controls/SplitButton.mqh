//+------------------------------------------------------------------+
//|                                                  SplitButton.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "Button.mqh"
#include "ContextMenu.mqh"
//+------------------------------------------------------------------+
//| Класс для создания сдвоенной кнопки                              |
//+------------------------------------------------------------------+
class CSplitButton : public CElement
  {
private:
   //--- Объекты для создания кнопки
   CButton           m_button;
   CButton           m_drop_button;
   CContextMenu      m_drop_menu;
   //--- Состояние контекстного меню 
   bool              m_drop_menu_state;
   //---
public:
                     CSplitButton(void);
                    ~CSplitButton(void);
   //--- Методы для создания кнопки
   bool              CreateSplitButton(const string text,const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const string text,const int x_gap,const int y_gap);
   bool              CreateButton(void);
   bool              CreateDropButton(void);
   bool              CreateDropMenu(void);
   //---
public:
   //--- (1) получение указателя контекстного меню, (2) общее состояние кнопки (доступен/заблокирован)
   CButton          *GetButtonPointer(void)      { return(::GetPointer(m_button));      }
   CButton          *GetDropButtonPointer(void)  { return(::GetPointer(m_drop_button)); }
   CContextMenu     *GetContextMenuPointer(void) { return(::GetPointer(m_drop_menu));   }
   //--- Добавляет пункт меню с указанными свойствами до создания контекстного меню
   void              AddItem(const string text,const string path_bmp_on,const string path_bmp_off);
   //--- Добавляет разделительную линию после указанного пункта до создания контекстного меню
   void              AddSeparateLine(const int item_index);
   //---
public:
   //--- Обработчик событий графика
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //---
private:
   //--- Обработка нажатия на кнопку
   bool              OnClickButton(const string pressed_object,const int id,const int index);
   //--- Обработка нажатия на кнопку с выпадающим меню
   bool              OnClickDropButton(const string pressed_object,const int id,const int index);

   //--- Скрывает выпадающее меню
   void              HideDropDownMenu(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CSplitButton::CSplitButton(void) : m_drop_menu_state(false)
  {
//--- Сохраним имя класса элемента в базовом классе  
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CSplitButton::~CSplitButton(void)
  {
  }
//+------------------------------------------------------------------+
//| Обработчик событий                                               |
//+------------------------------------------------------------------+
void CSplitButton::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Обработка события перемещения курсора
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Проверка фокуса над элементами
      m_drop_button.MouseFocus(m_mouse.X()>m_drop_button.X() && m_mouse.X()<m_drop_button.X2() && 
                               m_mouse.Y()>m_drop_button.Y() && m_mouse.Y()<m_drop_button.Y2());
      //--- Вне области элемента и с нажатой кнопкой мыши
      if(!CElementBase::MouseFocus() && m_mouse.LeftButtonState())
        {
         //--- Выйти, если фокус в контекстном меню
         if(m_drop_menu.MouseFocus())
            return;
         //--- Скрыть выпадающее меню
         HideDropDownMenu();
         return;
        }
      return;
     }
//--- Обработка события нажатия на пункте свободного меню
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_FREEMENU_ITEM)
     {
      //--- Выйти, если идентификаторы не совпадают
      if(CElementBase::Id()!=lparam)
         return;
      //--- Скрыть выпадающее меню
      HideDropDownMenu();
      //--- Отправим сообщение
      ::EventChartCustom(m_chart_id,ON_CLICK_CONTEXTMENU_ITEM,lparam,dparam,sparam);
      return;
     }
//--- Обработка события нажатия левой кнопки мыши на элементе
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)
     {
      //--- Нажатие на основной кнопке
      if(OnClickButton(sparam,(int)lparam,(int)dparam))
         return;
      //--- Нажатие на кнопке с выпадающим меню
      if(OnClickDropButton(sparam,(int)lparam,(int)dparam))
         return;
     }
  }
//+------------------------------------------------------------------+
//| Создаёт элемент "Кнопка"                                         |
//+------------------------------------------------------------------+
bool CSplitButton::CreateSplitButton(const string text,const int x_gap,const int y_gap)
  {
//--- Выйти, если нет указателя на главный элемент
   if(!CElement::CheckMainPointer())
      return(false);
//--- Инициализация свойств
   InitializeProperties(text,x_gap,y_gap);
//--- Создание кнопки
   if(!CreateButton())
      return(false);
   if(!CreateDropButton())
      return(false);
   if(!CreateDropMenu())
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Инициализация свойств                                            |
//+------------------------------------------------------------------+
void CSplitButton::InitializeProperties(const string text,const int x_gap,const int y_gap)
  {
   m_x          =CElement::CalculateX(x_gap);
   m_y          =CElement::CalculateY(y_gap);
   m_label_text =text;
   m_x_size     =(m_x_size<1)? 80 : m_x_size;
   m_y_size     =(m_y_size<1)? 20 : m_y_size;
//--- Отступы от крайней точки
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
//--- Приоритет, как у главного элемента, так как элемент не имеет своей области для нажатия
   CElement::Z_Order(m_main.Z_Order());
  }
//+------------------------------------------------------------------+
//| Создаёт кнопку                                                   |
//+------------------------------------------------------------------+
bool CSplitButton::CreateButton(void)
  {
//--- Сохраним указатель на родительский элемент
   m_button.MainPointer(this);
//--- Размеры
   int x_size=m_x_size-18;
//--- Координаты
   int x=0,y=0;
//--- Отступы для картинки
   int icon_x_gap =(m_button.IconXGap()<1)? 3 : m_button.IconXGap();
   int icon_y_gap =(m_button.IconYGap()<1)? 3 : m_button.IconYGap();
//--- Свойства
   m_button.NamePart("split_button");
   m_button.Index(0);
   m_button.Alpha(m_alpha);
   m_button.XSize(x_size);
   m_button.YSize(m_y_size);
   m_button.IconXGap(icon_x_gap);
   m_button.IconYGap(icon_y_gap);
   m_button.IconFile(IconFile());
   m_button.IconFileLocked(IconFileLocked());
//--- Создадим элемент управления
   if(!m_button.CreateButton(m_label_text,x,y))
      return(false);
//--- Добавить элемент в массив
   CElement::AddToArray(m_button);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт кнопку для вызова контекстного меню                      |
//+------------------------------------------------------------------+
bool CSplitButton::CreateDropButton(void)
  {
//--- Сохраним указатель на родительский элемент
   m_drop_button.MainPointer(this);
//--- Размеры
   int x_size=18;
//--- Координаты
   int x=m_button.XSize()-1,y=0;
//--- Отступы для картинки
   int icon_x_gap =(m_drop_button.IconXGap()<1)? 1 : m_drop_button.IconXGap();
   int icon_y_gap =(m_drop_button.IconYGap()<1)? 3 : m_drop_button.IconYGap();
//--- Установим свойства перед созданием
   m_drop_button.NamePart("split_button");
   m_drop_button.Index(1);
   m_drop_button.Alpha(m_alpha);
   m_drop_button.TwoState(true);
   m_drop_button.XSize(x_size);
   m_drop_button.YSize(m_y_size);
   m_drop_button.IconXGap(icon_x_gap);
   m_drop_button.IconYGap(icon_y_gap);
   m_drop_button.IconFile(RESOURCE_DOWN_THIN_BLACK);
   m_drop_button.IconFileLocked(RESOURCE_DOWN_THIN_BLACK);
   m_drop_button.CElement::IconFilePressed(RESOURCE_UP_THIN_BLACK);
   m_drop_button.CElement::IconFilePressedLocked(RESOURCE_UP_THIN_BLACK);
//--- Создадим элемент управления
   if(!m_drop_button.CreateButton("",x,y))
      return(false);
//--- Добавить элемент в массив
   CElement::AddToArray(m_drop_button);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт выпадающее меню                                          |
//+------------------------------------------------------------------+
bool CSplitButton::CreateDropMenu(void)
  {
//--- Сохраним указатель на главный элемент
   m_drop_menu.MainPointer(this);
//--- Свободное контекстное меню
   m_drop_menu.FreeContextMenu(true);
//--- Координаты
   int x=0,y=m_y_size;
//--- Установим свойства
   m_drop_menu.XSize((m_drop_menu.XSize()>0)? m_drop_menu.XSize() : m_x_size-1);
//--- Установим контекстное меню
   if(!m_drop_menu.CreateContextMenu(x,y))
      return(false);
//--- Добавить элемент в массив
   CElement::AddToArray(m_drop_menu);
   return(true);
  }
//+------------------------------------------------------------------+
//| Добавляет пункт меню                                             |
//+------------------------------------------------------------------+
void CSplitButton::AddItem(const string text,const string path_bmp_on,const string path_bmp_off)
  {
   m_drop_menu.AddItem(text,path_bmp_on,path_bmp_off,MI_SIMPLE);
  }
//+------------------------------------------------------------------+
//| Добавляет разделительную линию                                   |
//+------------------------------------------------------------------+
void CSplitButton::AddSeparateLine(const int item_index)
  {
   m_drop_menu.AddSeparateLine(item_index);
  }
//+------------------------------------------------------------------+
//| Нажатие на кнопку                                                |
//+------------------------------------------------------------------+
bool CSplitButton::OnClickButton(const string pressed_object,const int id,const int index)
  {
//--- Выйдем, если нажатие было не на кнопке
   if(::StringFind(pressed_object,"split_button")<0)
      return(false);
//--- Выйти, если (1) идентификаторы не совпадают или (2) элемент заблокирован
   if(id!=CElementBase::Id() || index!=m_button.Index() || CElementBase::IsLocked())
      return(false);
//--- Скроем меню
   HideDropDownMenu();
//--- Отправим сообщение об этом
   ::EventChartCustom(m_chart_id,ON_CLICK_BUTTON,CElementBase::Id(),CElementBase::Index(),"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Нажатие на кнопку с выпадающим меню                              |
//+------------------------------------------------------------------+
bool CSplitButton::OnClickDropButton(const string pressed_object,const int id,const int index)
  {
//--- Выйдем, если нажатие было не на кнопке
   if(::StringFind(pressed_object,"split_button")<0)
      return(false);
//--- Выйти, если (1) идентификаторы не совпадают или (2) элемент заблокирован
   if(id!=CElementBase::Id() || index!=m_drop_button.Index() || CElementBase::IsLocked())
      return(false);
//--- Если список открыт, скроем его
   if(m_drop_menu_state)
     {
      m_drop_menu_state=false;
      m_drop_menu.Hide();
      //--- Отправим сообщение на определение доступных элементов
      ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),1,"");
     }
//--- Если список скрыт, откроем его
   else
     {
      m_drop_menu_state=true;
      m_drop_menu.Show();
      //--- Отправим сообщение на определение доступных элементов
      ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),0,"");
     }
//--- Отправим сообщение об изменении в графическом интерфейсе
   ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0.0,"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Скрывает выпадающее меню                                         |
//+------------------------------------------------------------------+
void CSplitButton::HideDropDownMenu(void)
  {
//--- Скрыть меню и установить соответствующие признаки
   m_drop_menu.Hide();
   m_drop_menu_state=false;
//--- Отжать кнопку, если нажата
   if(m_drop_button.IsPressed())
     {
      m_drop_button.IsPressed(false);
      m_drop_button.Update(true);
      //--- Отправим сообщение на определение доступных элементов
      ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),1,"");      
      //--- Отправим сообщение об изменении в графическом интерфейсе
      ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0.0,"");
     }
  }
//+------------------------------------------------------------------+
