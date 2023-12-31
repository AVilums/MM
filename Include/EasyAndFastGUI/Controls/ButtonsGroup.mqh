//+------------------------------------------------------------------+
//|                                                 ButtonsGroup.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "Button.mqh"
//+------------------------------------------------------------------+
//| Класс для создания группы кнопок                                 |
//+------------------------------------------------------------------+
class CButtonsGroup : public CElement
  {
private:
   //--- Экземпляры для создания элемента
   CButton           m_buttons[];
   //--- Режим радио-кнопок
   bool              m_radio_buttons_mode;
   //--- Стиль отображения радио-кнопок
   bool              m_radio_buttons_style;
   //--- Высота кнопок
   int               m_button_y_size;
   //--- (1) Текст и (2) индекс выделенной кнопки
   string            m_selected_button_text;
   int               m_selected_button_index;
   //---
public:
                     CButtonsGroup(void);
                    ~CButtonsGroup(void);
   //--- Методы для создания кнопки
   bool              CreateButtonsGroup(const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const int x_gap,const int y_gap);
   bool              CreateButtons(void);
   //---
public:
   //--- Возвращает указатель на кнопку по указанному индексу
   CButton          *GetButtonPointer(const uint index);
   //--- (1) Количество кнопок, (2) высота кнопок
   int               ButtonsTotal(void)                       const { return(::ArraySize(m_buttons));  }
   void              ButtonYSize(const int y_size)                  { m_button_y_size=y_size;          }
   //--- (1) Установка режима и (2) стиля отображения радио-кнопок
   void              RadioButtonsMode(const bool flag)              { m_radio_buttons_mode=flag;       }
   void              RadioButtonsStyle(const bool flag)             { m_radio_buttons_style=flag;      }
   //--- Возвращает (1) текст и (2) индекс выделенной кнопки
   string            SelectedButtonText(void)                 const { return(m_selected_button_text);  }
   int               SelectedButtonIndex(void)                const { return(m_selected_button_index); }

   //--- Добавляет кнопку с указанными свойствами до создания
   void              AddButton(const int x_gap,const int y_gap,const string text,const int width,
                               const color button_color=clrNONE,const color button_color_hover=clrNONE,const color button_color_pressed=clrNONE);
   //--- Переключает кнопку по указанному индексу
   void              SelectButton(const uint index,const bool is_external_call=true);
   //---
public:
   //--- Обработчик событий графика
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Управление объектами
   virtual void      Show(void);
   virtual void      Delete(void);
   //--- Обновляет элемент для отображения последних изменений
   virtual void      Update(const bool redraw=false);
   //--- Рисует элемент
   virtual void      Draw(void);
   //---
private:
   //--- Обработка нажатия на кнопку
   bool              OnClickButton(const string pressed_object,const int id,const int index);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CButtonsGroup::CButtonsGroup(void) : m_button_y_size(20),
                                     m_radio_buttons_mode(false),
                                     m_radio_buttons_style(false),
                                     m_selected_button_text(""),
                                     m_selected_button_index(WRONG_VALUE)
  {
//--- Сохраним имя класса элемента в базовом классе  
   CElementBase::ClassName(CLASS_NAME);
//--- Метка по умолчанию
   CElementBase::NamePart("button");
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CButtonsGroup::~CButtonsGroup(void)
  {
  }
//+------------------------------------------------------------------+
//| Обработчик события графика                                       |
//+------------------------------------------------------------------+
void CButtonsGroup::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Обработка события нажатия левой кнопки мыши на элементе
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)
     {
      if(OnClickButton(sparam,(uint)lparam,(uint)dparam))
         return;
      //---
      return;
     }
  }
//+------------------------------------------------------------------+
//| Создаёт группу кнопок                                            |
//+------------------------------------------------------------------+
bool CButtonsGroup::CreateButtonsGroup(const int x_gap,const int y_gap)
  {
//--- Выйти, если нет указателя на главный элемент
   if(!CElement::CheckMainPointer())
      return(false);
//--- Инициализация свойств
   InitializeProperties(x_gap,y_gap);
//--- Создаёт кнопки
   if(!CreateButtons())
      return(false);
//--- Выделить радио-кнопку
   if(m_radio_buttons_mode)
      m_buttons[m_selected_button_index].IsPressed(true);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Инициализация свойств                                            |
//+------------------------------------------------------------------+
void CButtonsGroup::InitializeProperties(const int x_gap,const int y_gap)
  {
   m_x =CElement::CalculateX(x_gap);
   m_y =CElement::CalculateY(y_gap);
//--- Значения по умолчанию
   m_label_x_gap =(m_label_x_gap!=WRONG_VALUE)? m_label_x_gap : 18;
   m_label_y_gap =(m_label_y_gap!=WRONG_VALUE)? m_label_y_gap : 0;
//--- Одна радио-кнопка должна быть выделена обязательно
   if(m_radio_buttons_mode)
      m_selected_button_index=(m_selected_button_index!=WRONG_VALUE)? m_selected_button_index : 0;
//--- Отступы от крайней точки
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
//--- Приоритет, как у главного элемента, так как элемент не имеет своей области для нажатия
   CElement::Z_Order(m_main.Z_Order());
  }
//+------------------------------------------------------------------+
//| Создаёт кнопки                                                   |
//+------------------------------------------------------------------+
bool CButtonsGroup::CreateButtons(void)
  {
//--- Координаты
   int x=0,y=0;
//--- Получим количество кнопок
   int buttons_total=ButtonsTotal();
//--- Если нет ни одной кнопки в группе, сообщить об этом
   if(buttons_total<1)
     {
      //::Print(__FUNCTION__," > Вызов этого метода нужно осуществлять, ...\n"
      //        "... когда в группе есть хотя бы одна кнопка! Воспользуйтесь методом CButtonsGroup::AddButton()"
      
      ::Print(__FUNCTION__," > You must call this method when there is at least one button in the group! "
              "Use the method CButtonsGroup::AddButton()");
      return(false);
     }
//--- Создадим указанное количество кнопок
   for(int i=0; i<buttons_total; i++)
     {
      //--- Сохраним указатель на родительский элемент
      m_buttons[i].MainPointer(this);
      //--- Координаты
      x =m_buttons[i].XGap();
      y =m_buttons[i].YGap();
      //--- Свойства
      m_buttons[i].NamePart(CElementBase::NamePart());
      m_buttons[i].Alpha(m_alpha);
      m_buttons[i].IconXGap(m_icon_x_gap);
      m_buttons[i].IconYGap(m_icon_y_gap);
      m_buttons[i].LabelXGap(m_label_x_gap);
      m_buttons[i].LabelYGap(m_label_y_gap);
      m_buttons[i].IsCenterText(CElement::IsCenterText());
      m_buttons[i].IsDropdown(CElementBase::IsDropdown());
      //--- Создадим элемент управления
      if(!m_buttons[i].CreateButton(m_buttons[i].LabelText(),x,y))
         return(false);
      //--- Нажмём кнопку, если определена
      if(i==m_selected_button_index)
         m_buttons[i].IsPressed(true);
      //--- Добавить элемент в массив
      CElement::AddToArray(m_buttons[i]);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Возвращает указатель на кнопку по указанному индексу             |
//+------------------------------------------------------------------+
CButton *CButtonsGroup::GetButtonPointer(const uint index)
  {
   uint array_size=::ArraySize(m_buttons);
//--- Проверка размера массива объектов
   if(array_size<1)
     {
      ::Print(__FUNCTION__," > There is no button in the group!");
      return(NULL);
     }
//--- Корректировка в случае выхода из диапазона
   uint i=(index>=array_size)? array_size-1 : index;
//--- Вернуть указатель объекта
   return(::GetPointer(m_buttons[i]));
  }
//+------------------------------------------------------------------+
//| Добавляет кнопку                                                 |
//+------------------------------------------------------------------+
void CButtonsGroup::AddButton(const int x_gap,const int y_gap,const string text,const int width,
                              const color button_color=clrNONE,const color button_color_hover=clrNONE,const color button_color_pressed=clrNONE)
  {
//--- Резервный размер
   int reserve_size=100;
//--- Увеличим размер массивов на один элемент
   int array_size=::ArraySize(m_buttons);
   int new_size=array_size+1;
   ::ArrayResize(m_buttons,new_size,reserve_size);
//--- Установим свойства
   m_buttons[array_size].Index(array_size);
   m_buttons[array_size].TwoState(true);
   m_buttons[array_size].XSize(width);
   m_buttons[array_size].YSize(m_button_y_size);
   m_buttons[array_size].XGap(x_gap);
   m_buttons[array_size].YGap(y_gap);
   m_buttons[array_size].LabelText(text);
   m_buttons[array_size].BackColor(button_color);
   m_buttons[array_size].BackColorHover(button_color_hover);
   m_buttons[array_size].BackColorPressed(button_color_pressed);
//--- Выйти, если выключен стиль радио-кнопок
   if(!m_radio_buttons_style)
      return;
//---
   m_buttons[array_size].BackColor(m_main.BackColor());
   m_buttons[array_size].BackColorHover(m_main.BackColor());
   m_buttons[array_size].BackColorPressed(m_main.BackColor());
   m_buttons[array_size].BackColorLocked(m_main.BackColor());
   m_buttons[array_size].BorderColor(m_main.BackColor());
   m_buttons[array_size].BorderColorHover(m_main.BackColor());
   m_buttons[array_size].BorderColorPressed(m_main.BackColor());
   m_buttons[array_size].BorderColorLocked(m_main.BackColor());
   m_buttons[array_size].LabelColorHover(C'0,120,215');
   m_buttons[array_size].IconXGap(m_icon_x_gap);
   m_buttons[array_size].IconYGap(m_icon_y_gap);
   m_buttons[array_size].IconFileLocked(RESOURCE_RADIO_BUTTON_OFF_LOCKED);
   m_buttons[array_size].IconFile(RESOURCE_RADIO_BUTTON_OFF);
   m_buttons[array_size].IconFileLocked(RESOURCE_RADIO_BUTTON_OFF_LOCKED);
   m_buttons[array_size].CElement::IconFilePressed(RESOURCE_RADIO_BUTTON_ON);
   m_buttons[array_size].CElement::IconFilePressedLocked(RESOURCE_RADIO_BUTTON_ON_LOCKED);
  }
//+------------------------------------------------------------------+
//| Переключает кнопку по указанному индексу                         |
//+------------------------------------------------------------------+
void CButtonsGroup::SelectButton(const uint index,const bool is_external_call=true)
  {
//--- Для проверки существования нажатой в группе кнопки
   bool check_pressed_button=false;
//--- Получим количество кнопок
   uint buttons_total=ButtonsTotal();
//--- Если нет ни одной кнопки в группе, сообщить об этом
   if(buttons_total<1)
     {  
      ::Print(__FUNCTION__," > You must call this method when there is at least one button in the group! "
              "Use the method CButtonsGroup::AddButton()");
      return;
     }
//--- Скорректировать значение индекса, если выходит из диапазона
   uint correct_index=(index>=buttons_total)? buttons_total-1 : index;
//---
   if(is_external_call && !m_radio_buttons_mode)
      m_buttons[correct_index].IsPressed(!m_buttons[correct_index].IsPressed());
//--- Пройдёмся в цикле по группе кнопок
   for(uint i=0; i<buttons_total; i++)
     {
      if(i==correct_index)
        {
         if(m_radio_buttons_mode)
            m_buttons[i].IsPressed(true);
         //--- Если есть нажатая кнопка
         if(m_buttons[i].IsPressed())
            check_pressed_button=true;
         //---
         continue;
        }
      //--- Отожмём остальные кнопки
      if(m_buttons[i].IsPressed())
         m_buttons[i].IsPressed(false);
     }
//--- Если есть нажатая кнопка, сохраним её текст и индекс
   m_selected_button_text  =(check_pressed_button)? m_buttons[correct_index].LabelText() : "";
   m_selected_button_index =(check_pressed_button)? (int)correct_index : WRONG_VALUE;
  }
//+------------------------------------------------------------------+
//| Показать                                                         |
//+------------------------------------------------------------------+
void CButtonsGroup::Show(void)
  {
   CElement::Show();
   int total=ButtonsTotal();
   for(int i=0; i<total; i++)
      m_buttons[i].Show();
  }
//+------------------------------------------------------------------+
//| Удаление                                                         |
//+------------------------------------------------------------------+
void CButtonsGroup::Delete(void)
  {
   CElement::Delete();
//--- Освобождение массивов элемента
   ::ArrayFree(m_buttons);
  }
//+------------------------------------------------------------------+
//| Обновление элемента                                              |
//+------------------------------------------------------------------+
void CButtonsGroup::Update(const bool redraw=false)
  {
   int buttons_total=ButtonsTotal();
//--- С перерисовкой элемента
   if(redraw)
     {
      for(int i=0; i<buttons_total; i++)
         m_buttons[i].Draw();
      for(int i=0; i<buttons_total; i++)
         m_buttons[i].Update();
      //---
      return;
     }
//--- Применить
   for(int i=0; i<buttons_total; i++)
      m_buttons[i].Update();
  }
//+------------------------------------------------------------------+
//| Нажатие на кнопку в группе                                       |
//+------------------------------------------------------------------+
bool CButtonsGroup::OnClickButton(const string pressed_object,const int id,const int index)
  {
//--- Выйдем, если нажатие было не на этом элементе
   if(!CElementBase::CheckElementName(pressed_object))
      return(false);
//--- Выйти, если (1) идентификаторы не совпадают или (2) элемент заблокирован
   if(id!=CElementBase::Id() || CElementBase::IsLocked())
      return(false);
//--- Если эта кнопка уже нажата
   if(index==m_selected_button_index)
     {
      //--- Переключить кнопку
      SelectButton(m_selected_button_index,false);
      return(true);
     }
//---
   int check_index=WRONG_VALUE;
//--- Проверим, было ли нажатие на одной из кнопок этой группы
   int buttons_total=ButtonsTotal();
//--- Если нажатие было, то запомним индекс
   for(int i=0; i<buttons_total; i++)
     {
      if(m_buttons[i].Index()==index)
        {
         check_index=i;
         break;
        }
     }
//--- Выйдем, если не было нажатия на кнопку в этой группе
   if(check_index==WRONG_VALUE)
      return(false);
//--- Переключить кнопку
   SelectButton(check_index,false);
   Update(true);
//--- Отправим сообщение об этом
   ::EventChartCustom(m_chart_id,ON_CLICK_GROUP_BUTTON,CElementBase::Id(),m_selected_button_index,m_selected_button_text);
   return(true);
  }
//+------------------------------------------------------------------+
//| Рисует элемент                                                   |
//+------------------------------------------------------------------+
void CButtonsGroup::Draw(void)
  {
   int buttons_total=ButtonsTotal();
   for(int i=0; i<buttons_total; i++)
      m_buttons[i].Draw();
  }
//+------------------------------------------------------------------+
