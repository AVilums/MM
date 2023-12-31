//+------------------------------------------------------------------+
//|                                                     ComboBox.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "ListView.mqh"
//+------------------------------------------------------------------+
//| Класс для создания комбинированного списка                       |
//+------------------------------------------------------------------+
class CComboBox : public CElement
  {
private:
   //--- Экземпляры для создания элемента
   CButton           m_button;
   CListView         m_listview;
   //--- Режим элемента с чек-боксом
   bool              m_checkbox_mode;
   //---
public:
                     CComboBox(void);
                    ~CComboBox(void);
   //--- Методы для создания комбо-бокса
   bool              CreateComboBox(const string text,const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const string text,const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   bool              CreateButton(void);
   bool              CreateList(void);
   //---
public:
   //--- Возвращает указатели на (1) кнопку, (2) список и (3) полосу прокрутки
   CButton          *GetButtonPointer(void)                 { return(::GetPointer(m_button));         }
   CListView        *GetListViewPointer(void)               { return(::GetPointer(m_listview));       }
   CScrollV         *GetScrollVPointer(void)                { return(m_listview.GetScrollVPointer()); }
   //--- (1) Размер списка (количество пунктов) (2) установка режима элемента с чек-боксом
   void              ItemsTotal(const int items_total)      { m_listview.ListSize(items_total);       }
   void              CheckBoxMode(const bool state)         { m_checkbox_mode=state;                  }
   //--- Состояние элемента (нажат/отжат)
   bool              IsPressed(void) const { return(m_is_pressed); }
   void              IsPressed(const bool state);
   //--- Сохраняет переданное значение в списке по указанному индексу
   void              SetValue(const int item_index,const string item_text);
   //--- Возвращает выбранное значение в списке
   string            GetValue(void);
   //--- Выделение пункта по указанному индексу
   void              SelectItem(const int item_index);
   //--- Изменяет текущее состояние комбо-бокса на противоположное
   void              ChangeComboBoxListState(void);
   //---
public:
   //--- Обработчик событий графика
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Блокировка
   virtual void      IsLocked(const bool state);
   //--- Управление видимостью
   virtual void      Hide(void);
   //--- Рисует элемент
   virtual void      Draw(void);
   //---
private:
   //--- Обработка нажатия на элементе
   bool              OnClickElement(const string pressed_object);
   //--- Обработка нажатия на кнопку
   bool              OnClickButton(const string pressed_object,const int id,const int index);
   //--- Обработка нажатия на пункте списка
   bool              OnClickListItem(const int id);

   //--- Проверка нажатой левой кнопки мыши над кнопкой комбо-бокса
   void              CheckPressedOverButton(void);
   //--- Рисует картинку
   virtual void      DrawImage(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CComboBox::CComboBox(void) : m_checkbox_mode(false)
  {
//--- Сохраним имя класса элемента в базовом классе
   CElementBase::ClassName(CLASS_NAME);
//--- Режим выпадающего списка
   m_listview.IsDropdown(true);
   m_listview.GetScrollVPointer().IsDropdown(true);
   m_listview.GetScrollVPointer().GetIncButtonPointer().IsDropdown(true);
   m_listview.GetScrollVPointer().GetDecButtonPointer().IsDropdown(true);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CComboBox::~CComboBox(void)
  {
  }
//+------------------------------------------------------------------+
//| Обработчик событий                                               |
//+------------------------------------------------------------------+
void CComboBox::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Обработка события перемещения курсора
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Проверка нажатой левой кнопки мыши над кнопкой
      CheckPressedOverButton();
      //--- Перерисовать элемент
      if(CheckCrossingBorder())
         Update(true);
      //---
      return;
     }
//--- Обработка события нажатия на пункте списка
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_LIST_ITEM)
     {
      if(!OnClickListItem((int)lparam))
         return;
      //---
      return;
     }
//--- Обработка нажатия на элементе
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      if(OnClickElement(sparam))
         return;
      //---
      return;
     }
//--- Обработка события нажатия на кнопке
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)
     {
      if(OnClickButton(sparam,(uint)lparam,(uint)dparam))
         return;
      //---
      return;
     }
//--- Обработка события изменения свойств графика
   if(id==CHARTEVENT_CHART_CHANGE)
     {
      //--- Выйти, если (1) элемент заблокирован или (2) кнопка отжата
      if(CElementBase::IsLocked() || !m_button.IsPressed())
         return;
      //--- Отжать кнопку
      m_button.IsPressed(false);
      //--- Изменить состояние списка
      ChangeComboBoxListState();
      return;
     }
  }
//+------------------------------------------------------------------+
//| Создаёт группу объектов типа комбо-бокс                          |
//+------------------------------------------------------------------+
bool CComboBox::CreateComboBox(const string text,const int x_gap,const int y_gap)
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
   if(!CreateList())
      return(false);
//--- Установить текст в кнопку
   m_button.LabelText(m_listview.SelectedItemText());
   return(true);
  }
//+------------------------------------------------------------------+
//| Инициализация свойств                                            |
//+------------------------------------------------------------------+
void CComboBox::InitializeProperties(const string text,const int x_gap,const int y_gap)
  {
   m_x          =CElement::CalculateX(x_gap);
   m_y          =CElement::CalculateY(y_gap);
   m_x_size     =(m_x_size<1)? 50 : m_x_size;
   m_y_size     =(m_y_size<1)? 20 : m_y_size;
   m_label_text =text;
//--- Цвет фона и отступы для картинки/чек-бокса
   m_back_color=(m_back_color!=clrNONE)? m_back_color : m_main.BackColor();
//--- Отступы и цвет текстовой метки
   m_icon_y_gap          =(m_icon_y_gap!=WRONG_VALUE)? m_icon_y_gap : 4;
   m_label_x_gap         =(m_label_x_gap!=WRONG_VALUE)? m_label_x_gap : (m_checkbox_mode)? 20 : 0;
   m_label_y_gap         =(m_label_y_gap!=WRONG_VALUE)? m_label_y_gap : 4;
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
bool CComboBox::CreateCanvas(void)
  {
//--- Формирование имени объекта
   string name=CElementBase::ElementName("combobox");
//--- Если нужен элемент с чек-боксом
   if(m_checkbox_mode)
     {
      IconFile(RESOURCE_CHECKBOX_OFF);
      IconFileLocked(RESOURCE_CHECKBOX_OFF_LOCKED);
      IconFilePressed(RESOURCE_CHECKBOX_ON);
      IconFilePressedLocked(RESOURCE_CHECKBOX_ON_LOCKED);
     }
//--- Создание объекта
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт кнопку                                                   |
//+------------------------------------------------------------------+
bool CComboBox::CreateButton(void)
  {
//--- Сохраним указатель на родительский элемент
   m_button.MainPointer(this);
//--- Размеры
   int x_size=(m_button.XSize()<1)? 80 : m_button.XSize();
//--- Координаты
   int x =(m_button.XGap()<1)? x_size : m_button.XGap();
   int y =0;
//--- Отступы для картинки
   int icon_x_gap =(m_button.IconXGap()<1)? x_size-18 : m_button.IconXGap();
   int icon_y_gap =(m_button.IconYGap()<1)? 2 : m_button.IconYGap();
//--- Отступы для текста
   int label_x_gap =(m_button.LabelXGap()<1)? 7 : m_button.LabelXGap();
   int label_y_gap =(m_button.LabelYGap()<1)? 4 : m_button.LabelYGap();
//--- Свойства
   m_button.NamePart("combobox_button");
   m_button.Index(0);
   m_button.TwoState(true);
   m_button.XSize(x_size);
   m_button.YSize(m_y_size);
   m_button.IconXGap(icon_x_gap);
   m_button.IconYGap(icon_y_gap);
   m_button.LabelXGap(label_x_gap);
   m_button.LabelYGap(label_y_gap);
   m_button.IsDropdown(CElementBase::IsDropdown());
   m_button.IconFile(RESOURCE_DOWN_THIN_BLACK);
   m_button.IconFileLocked(RESOURCE_DOWN_THIN_BLACK);
   m_button.CElement::IconFilePressed(RESOURCE_UP_THIN_BLACK);
   m_button.CElement::IconFilePressedLocked(RESOURCE_UP_THIN_BLACK);
   
//--- Создадим элемент управления
   if(!m_button.CreateButton("",x,y))
      return(false);
   
//--- Добавить элемент в массив
   CElement::AddToArray(m_button);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт список                                                   |
//+------------------------------------------------------------------+
bool CComboBox::CreateList(void)
  {
//--- Сохраним указатель на главный элемент
   m_listview.MainPointer(this);
//--- Координаты
   int x =m_button.XGap();
   int y =m_button.YSize();
//--- Размеры
   int x_size =(m_listview.XSize()<1)? m_button.XSize() : m_listview.XSize();
   int y_size =(m_listview.YSize()<1)? 93 : m_listview.YSize();
//--- Свойства
   m_listview.XSize(x_size);
   m_listview.YSize(y_size);
   m_listview.AnchorRightWindowSide(m_button.AnchorRightWindowSide());
//--- Создадим элемент управления
   if(!m_listview.CreateListView(x,y))
      return(false);
//--- Скрыть список
   m_listview.Hide();
//--- Добавить элемент в массив
   CElement::AddToArray(m_listview);
   return(true);
  }
//+------------------------------------------------------------------+
//| Установка состояния элемента (нажат/отжат)                       |
//+------------------------------------------------------------------+
void CComboBox::IsPressed(const bool state)
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
//| Сохраняет переданное значение в списке по указанному индексу     |
//+------------------------------------------------------------------+
void CComboBox::SetValue(const int item_index,const string item_text)
  {
   m_listview.SetValue(item_index,item_text);
  }
//+------------------------------------------------------------------+
//| Возвращает выбранное в списке значение                           |
//+------------------------------------------------------------------+
string CComboBox::GetValue(void)
  {
   return(m_listview.SelectedItemText());
  }
//+------------------------------------------------------------------+
//| Выделение пункта по указанному индексу                           |
//+------------------------------------------------------------------+
void CComboBox::SelectItem(const int item_index)
  {
//--- Выбрать пункт в списке
   m_listview.SelectItem(item_index);
//--- Установить текст в кнопку
   m_button.LabelText(m_listview.SelectedItemText());
  }
//+------------------------------------------------------------------+
//| Блокировка                                                       |
//+------------------------------------------------------------------+
void CComboBox::IsLocked(const bool state)
  {
   CElement::IsLocked(state);
//--- Установить соответствующую картинку
   CElement::ChangeImage(0,(m_is_locked)? !m_is_pressed? 1 : 3 : !m_is_pressed? 0 : 2);
  }
//+------------------------------------------------------------------+
//| Скрытие                                                          |
//+------------------------------------------------------------------+
void CComboBox::Hide(void)
  {
   CElement::Hide();
//--- Отжать кнопку
   m_button.IsPressed(false);
  }
//+------------------------------------------------------------------+
//| Изменяет текущее состояние комбо-бокса на противоположное        |
//+------------------------------------------------------------------+
void CComboBox::ChangeComboBoxListState(void)
  {
//--- Если кнопка нажата
   if(m_button.IsPressed())
     {
      //--- Показать список
      m_listview.Show();
      //--- Отправим сообщение на определение доступных элементов
      ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),0,"");
      //--- Отправим сообщение об изменении в графическом интерфейсе
      ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
     }
   else
     {
      //--- Скрыть список
      m_listview.Hide();
      //--- Отправим сообщение на восстановление элементов
      ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),1,"");
      //--- Отправим сообщение об изменении в графическом интерфейсе
      ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
     }
  }
//+------------------------------------------------------------------+
//| Нажатие на чек-боксе                                             |
//+------------------------------------------------------------------+
bool CComboBox::OnClickElement(const string pressed_object)
  {
//--- Выйдем, если (1) элемент заблокирован или (2) чужое имя объекта
   if(CElementBase::IsLocked() || m_canvas.ChartObjectName()!=pressed_object)
      return(false);
//--- Если чек-бокс включен
   if(m_checkbox_mode)
     {
      //--- Переключить на противоположный режим
      IsPressed(!(IsPressed()));
      //--- Отправим сообщение об этом
      ::EventChartCustom(m_chart_id,ON_CLICK_CHECKBOX,CElementBase::Id(),CElementBase::Index(),"");
     }
//--- Нарисовать элемент
   CElement::Update(true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Нажатие на кнопку комбо-бокса                                    |
//+------------------------------------------------------------------+
bool CComboBox::OnClickButton(const string pressed_object,const int id,const int index)
  {
//--- Выйти, если нажатие было на другом элементе
   if(!m_button.CheckElementName(pressed_object))
      return(false);
//--- Выйти, если значения не совпадают
   if(id!=m_button.Id() || index!=m_button.Index())
      return(false);
//--- Изменить состояние списка
   ChangeComboBoxListState();
//--- Отправим сообщение об этом
   ::EventChartCustom(m_chart_id,ON_CLICK_COMBOBOX_BUTTON,CElementBase::Id(),0,"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на пункте списка                               |
//+------------------------------------------------------------------+
bool CComboBox::OnClickListItem(const int id)
  {
//--- Выйти, если значения не совпадают
   if(id!=CElementBase::Id())
      return(false);
//--- Отжать кнопку
   m_button.IsPressed(false);
//--- Установить текст в кнопку
   m_button.LabelText(m_listview.SelectedItemText());
   m_button.Update(true);
//--- Изменить состояние списка
   ChangeComboBoxListState();
//--- Отправим сообщение об этом
   ::EventChartCustom(m_chart_id,ON_CLICK_COMBOBOX_ITEM,CElementBase::Id(),0,m_label_text);
   return(true);
  }
//+------------------------------------------------------------------+
//| Проверка нажатой левой кнопки мыши над кнопкой                   |
//+------------------------------------------------------------------+
void CComboBox::CheckPressedOverButton(void)
  {
//--- Выйти, если кнопка уже отжата
   if(!m_button.IsPressed())
      return;
//--- Выйти, если (1) элемент заблокирован или (2) левая кнопка мыши отжата
   if(CElementBase::IsLocked() || !m_mouse.LeftButtonState())
      return;
//--- Если фокуса нет
   if(!CElementBase::MouseFocus() && !m_button.MouseFocus())
     {
      //--- Выйти, если фокус на списке или полоса прокрутки списка в действии
      if(m_listview.MouseFocus() || m_listview.ScrollState())
         return;
      //--- Скрыть список
      m_listview.Hide();
      m_button.IsPressed(false);
      m_button.Update(true);
      //--- Нарисовать элемент
      Update(true);
      //--- Отправим сообщение на восстановление элементов
      ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),1,"");
      //--- Отправим сообщение об изменении в графическом интерфейсе
      ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0.0,"");
     }
  }
//+------------------------------------------------------------------+
//| Рисует элемент                                                   |
//+------------------------------------------------------------------+
void CComboBox::Draw(void)
  {
//--- Нарисовать фон
   CElement::DrawBackground();
//--- Нарисовать картинку
   CElement::DrawImage();
//--- Нарисовать текст
   CElement::DrawText();
  }
//+------------------------------------------------------------------+
//| Рисует картинку                                                  |
//+------------------------------------------------------------------+
void CComboBox::DrawImage(void)
  {
//--- Выйти, если (1) чек-бокс не нужен или (2) картинка не определена
   if(!m_checkbox_mode || CElement::IconFile()=="")
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
//--- Установить соответствующую картинку
   CElement::ChangeImage(0,image_index);
//--- Рисуем картинку
   CElement::DrawImage();
  }
//+------------------------------------------------------------------+
