//+------------------------------------------------------------------+
//|                                                         Tabs.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "ButtonsGroup.mqh"
//+------------------------------------------------------------------+
//| Класс для создания вкладок                                       |
//+------------------------------------------------------------------+
class CTabs : public CElement
  {
private:
   //--- Экземпляры для создания элемента
   CButtonsGroup     m_tabs;
   //--- Структура свойств и массивов элементов закреплённых за каждой вкладкой
   struct TElements
     {
      CElement         *elements[];
     };
   TElements         m_tab[];
   //--- Позиционирование вкладок
   ENUM_TABS_POSITION m_position_mode;
   //--- Размер вкладок оси Y
   int               m_tab_y_size;
   //--- Индекс выделенной вкладки
   int               m_selected_tab;
   //---
public:
                     CTabs(void);
                    ~CTabs(void);
   //--- Методы для создания вкладок
   bool              CreateTabs(const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   bool              CreateButtons(void);
   //---
public:
   //--- Возвращает указатель на группу кнопок
   CButtonsGroup    *GetButtonsGroupPointer(void) { return(::GetPointer(m_tabs)); }
   //--- (1) возвращает количество вкладок, 
   //    (2) устанавливает/получает расположение вкладок (сверху/снизу/слева/справа), (3) устанавливает размер вкладок по оси Y
   int               TabsTotal(void)                           const { return(m_tabs.ButtonsTotal()); }
   void              PositionMode(const ENUM_TABS_POSITION mode)     { m_position_mode=mode;          }
   ENUM_TABS_POSITION PositionMode(void)                       const { return(m_position_mode);       }
   void              TabsYSize(const int y_size);
   //--- (1) Сохраняет и (2) возвращает индекс выделенной вкладки
   void              SelectedTab(const int index)                    { m_selected_tab=index;          }
   int               SelectedTab(void)                         const { return(m_selected_tab);        }
   //--- Устанавливает текст по указанному индексу
   void              Text(const uint index,const string text);
   //--- Выделяет указанную вкладку
   void              SelectTab(const int index);
   //--- Добавляет вкладку
   void              AddTab(const string tab_text="",const int tab_width=50);
   //--- Добавляет элемент в массив вкладки
   void              AddToElementsArray(const int tab_index,CElement &object);
   //--- Показать элементы только выделенной вкладки
   void              ShowTabElements(void);
   //---
public:
   //--- Обработчик событий графика
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Управление
   virtual void      Show(void);
   virtual void      Hide(void);
   virtual void      Delete(void);
   //--- Рисует элемент
   virtual void      Draw(void);
   //--- Обновляет элемент для отображения последних изменений
   virtual void      Update(void);
   //---
private:
   //--- Обработка нажатия на вкладке
   bool              OnClickTab(const int id,const int index);
   //--- Ширина всех вкладок
   int               SumWidthTabs(void);
   //--- Проверка индекса выделенной вкладки
   void              CheckTabIndex();

   //--- Изменить ширину по правому краю окна
   virtual void      ChangeWidthByRightWindowSide(void);
   //--- Изменить высоту по нижнему краю окна
   virtual void      ChangeHeightByBottomWindowSide(void);

   //--- Рисует фон области элементов
   void              DrawMainArea(void);
   //--- Рисует метку вкладки
   void              DrawPatch();
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTabs::CTabs(void) : m_tab_y_size(22),
                     m_position_mode(TABS_TOP),
                     m_selected_tab(WRONG_VALUE)
  {
//--- Сохраним имя класса элемента в базовом классе
   CElementBase::ClassName(CLASS_NAME);
//--- Высота вкладок
   m_tabs.ButtonYSize(m_tab_y_size);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CTabs::~CTabs(void)
  {
  }
//+------------------------------------------------------------------+
//| Обработчик события графика                                       |
//+------------------------------------------------------------------+
void CTabs::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Обработка события нажатия левой кнопки мыши на объекте
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_GROUP_BUTTON)
     {
      //--- Нажатие на вкладке
      if(OnClickTab((int)lparam,(int)dparam))
         return;
      //---
      return;
     }
  }
//+------------------------------------------------------------------+
//| Создаёт элемент "Вкладки"                                        |
//+------------------------------------------------------------------+
bool CTabs::CreateTabs(const int x_gap,const int y_gap)
  {
//--- Выйти, если нет указателя на главный элемент
   if(!CElement::CheckMainPointer())
      return(false);
//--- Если нет ни одной вкладки в группе, сообщить об этом
   if(TabsTotal()<1)
     {
      ::Print(__FUNCTION__," > Вызов этого метода нужно осуществлять, "
              "когда в группе есть хотя бы одна вкладка! Воспользуйтесь методом CTabs::AddTab()");
      return(false);
     }
//--- Инициализация свойств
   InitializeProperties(x_gap,y_gap);
//--- Создание элемента
   if(!CreateButtons())
      return(false);
   if(!CreateCanvas())
      return(false);
//--- 
   return(true);
  }
//+------------------------------------------------------------------+
//| Инициализация свойств                                            |
//+------------------------------------------------------------------+
void CTabs::InitializeProperties(const int x_gap,const int y_gap)
  {
   m_x        =CElement::CalculateX(x_gap);
   m_y        =CElement::CalculateY(y_gap);
   m_x_size   =(m_x_size<1 || m_auto_xresize_mode)? m_main.X2()-m_x-m_auto_xresize_right_offset : m_x_size;
   m_y_size   =(m_y_size<1 || m_auto_yresize_mode)? m_main.Y2()-m_y-m_auto_yresize_bottom_offset : m_y_size;
//--- Цвет фона по умолчанию
   m_back_color         =(m_back_color!=clrNONE)? m_back_color : clrWhiteSmoke;
   m_back_color_hover   =(m_back_color_hover!=clrNONE)? m_back_color_hover : C'229,241,251';
   m_back_color_pressed =(m_back_color_pressed!=clrNONE)? m_back_color_pressed : clrWhite;
//--- Цвет рамки по умолчанию
   m_border_color         =(m_border_color!=clrNONE)? m_border_color : C'217,217,217';
   m_border_color_hover   =(m_border_color_hover!=clrNONE)? m_border_color_hover : m_border_color;
   m_border_color_pressed =(m_border_color_pressed!=clrNONE)? m_border_color_pressed : m_border_color;
//--- Отступы и цвет текстовой метки
   m_label_color =(m_label_color!=clrNONE)? m_label_color : clrBlack;
   m_label_x_gap =(m_label_x_gap!=WRONG_VALUE)? m_label_x_gap : 0;
   m_label_y_gap =(m_label_y_gap!=WRONG_VALUE)? m_label_y_gap : 0;
//--- Отступы от крайней точки
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
//--- Приоритет, как у родителя
   CElement::Z_Order(m_main.Z_Order());
  }
//+------------------------------------------------------------------+
//| Создаёт объект для рисования                                     |
//+------------------------------------------------------------------+
bool CTabs::CreateCanvas(void)
  {
//--- Формирование имени объекта
   string name=CElementBase::ElementName("tabs");
//--- Создание объекта
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт группу кнопок                                            |
//+------------------------------------------------------------------+
bool CTabs::CreateButtons(void)
  {
   int x=0,y=0;
//--- Получим количество вкладок
   int tabs_total=TabsTotal();
//--- Если нет ни одной вкладки в группе, сообщить об этом и выйти
   if(tabs_total<1)
     {
      ::Print(__FUNCTION__," > Вызов этого метода нужно осуществлять, "
              "когда в группе есть хотя бы одна вкладка! Воспользуйтесь методом CTabs::AddTabs()");
      return(false);
     }
//--- Сохраним указатель на главный элемент
   m_tabs.MainPointer(this);
//--- Расчёт координат относительно позиционирования вкладок
   if(m_position_mode==TABS_TOP)
     {
      y=-m_tab_y_size+1;
     }
   else if(m_position_mode==TABS_BOTTOM)
     {
      y=1;
      m_tabs.AnchorBottomWindowSide(true);
     }
   else if(m_position_mode==TABS_RIGHT)
     {
      x=1;
      m_tabs.AnchorRightWindowSide(true);
     }
   else if(m_position_mode==TABS_LEFT)
     {
      x=-SumWidthTabs()+1;
     }
//--- Проверка индекса выделенной вкладки
   CheckTabIndex();
//--- Свойства
   m_tabs.NamePart("tab");
   m_tabs.RadioButtonsMode(true);
   m_tabs.IsCenterText(CElement::IsCenterText());
//--- Создать группу кнопок
   if(!m_tabs.CreateButtonsGroup(x,y))
      return(false);
//--- Добавить элемент в массив
   CElement::AddToArray(m_tabs);
//---
   for(int i=0; i<tabs_total; i++)
     {
      m_tabs.GetButtonPointer(i).LabelYGap(2);
      m_tabs.GetButtonPointer(i).BackColor(m_back_color);
      m_tabs.GetButtonPointer(i).BackColorHover(m_back_color_hover);
      m_tabs.GetButtonPointer(i).BackColorPressed(m_back_color_pressed);
      m_tabs.GetButtonPointer(i).BorderColor(m_border_color);
      m_tabs.GetButtonPointer(i).BorderColorHover(m_border_color);
      m_tabs.GetButtonPointer(i).BorderColorPressed(m_border_color);
      m_tabs.GetButtonPointer(i).BorderColorLocked(m_border_color);
     }
//---
   m_back_color=m_back_color_pressed;
//--- Выделить кнопку
   m_tabs.SelectButton(m_selected_tab);
   return(true);
  }
//+------------------------------------------------------------------+
//| Устанавливает высоту вкладок                                     |
//+------------------------------------------------------------------+
void CTabs::TabsYSize(const int y_size)
  {
   m_tab_y_size=y_size;
   m_tabs.ButtonYSize(y_size);
  }
//+------------------------------------------------------------------+
//| Устанавливает текст вкладки                                      |
//+------------------------------------------------------------------+
void CTabs::Text(const uint index,const string text)
  {
//--- Получим количество вкладок
   uint tabs_total=TabsTotal();
//--- Выйти, если нет ни одной вкладки в группе
   if(tabs_total<1)
      return;
//--- Скорректировать значение индекса, если выходит из диапазона
   uint correct_index=(index>=tabs_total)? tabs_total-1 : index;
//--- Установить текст
   m_tabs.GetButtonPointer(correct_index).LabelText(text);
  }
//+------------------------------------------------------------------+
//| Выделяет вкладку                                                 |
//+------------------------------------------------------------------+
void CTabs::SelectTab(const int index)
  {
//--- Получим количество вкладок
   uint tabs_total=TabsTotal();
   for(uint i=0; i<tabs_total; i++)
     {
      //--- Если выбрана эта вкладка
      if(index==i)
        {
         //--- Сохранить индекс выделенной вкладки
         SelectedTab(index);
         //---
         m_tabs.SelectButton(index);
        }
     }
//--- Показать элементы только выделенной вкладки
   ShowTabElements();
  }
//+------------------------------------------------------------------+
//| Добавляет вкладку                                                |
//+------------------------------------------------------------------+
void CTabs::AddTab(const string tab_text,const int tab_width)
  {
//--- Резервное количество
   int reserve=10;
//--- Установить размер массивам вкладок
   int array_size=::ArraySize(m_tab);
   ::ArrayResize(m_tab,array_size+1,reserve);
//--- Координаты
   int x=0,y=0;
   if(array_size>0)
     {
      if(m_position_mode==TABS_TOP || m_position_mode==TABS_BOTTOM)
        {
         x=SumWidthTabs()-1;
        }
      else
         y=((array_size*m_tab_y_size)+m_tab_y_size)-m_tab_y_size-array_size;
     }
//--- Добавить кнопку в группу
   m_tabs.AddButton(x,y,tab_text,tab_width,m_back_color,m_back_color_hover,m_back_color_pressed);
  }
//+------------------------------------------------------------------+
//| Добавляет элемент в массив указанной вкладки                     |
//+------------------------------------------------------------------+
void CTabs::AddToElementsArray(const int tab_index,CElement &object)
  {
//--- Проверка на выход из диапазона
   int array_size=::ArraySize(m_tab);
   if(array_size<1 || tab_index<0 || tab_index>=array_size)
      return;
//--- Добавим указатель переданного элемента в массив указанной вкладки
   int size=::ArraySize(m_tab[tab_index].elements);
   ::ArrayResize(m_tab[tab_index].elements,size+1);
   m_tab[tab_index].elements[size]=::GetPointer(object);
  }
//+------------------------------------------------------------------+
//| Показывает элементы только выделенной вкладки                    |
//+------------------------------------------------------------------+
void CTabs::ShowTabElements(void)
  {
//--- Выйти, если вкладки скрыты
   if(!CElementBase::IsVisible())
      return;
//--- Проверка индекса выделенной вкладки
   CheckTabIndex();
//---
   uint tabs_total=TabsTotal();
   for(uint i=0; i<tabs_total; i++)
     {
      //--- Получим количество элементов присоединённых к вкладке
      int tab_elements_total=::ArraySize(m_tab[i].elements);
      //--- Если выделена эта вкладка
      if(i==m_selected_tab)
        {
         //--- Показать элементы вкладки
         for(int j=0; j<tab_elements_total; j++)
           {
            //--- Показать элементы
            CElement *el=m_tab[i].elements[j];
            el.Reset();
            //--- Если этот элемент 'Вкладки', то показать элементы открытой
            CTabs *tb=dynamic_cast<CTabs*>(el);
            if(tb!=NULL)
               tb.ShowTabElements();
           }
        }
      //--- Скрыть элементы неактивных вкладок
      else
        {
         for(int j=0; j<tab_elements_total; j++)
            m_tab[i].elements[j].Hide();
        }
     }
//--- Отправить сообщение об этом
   ::EventChartCustom(m_chart_id,ON_CLICK_TAB,CElementBase::Id(),m_selected_tab,"");
  }
//+------------------------------------------------------------------+
//| Показать                                                         |
//+------------------------------------------------------------------+
void CTabs::Show(void)
  {
//--- Выйти, если элемент уже видим
   if(CElementBase::IsVisible())
      return;
//--- Состояние видимости
   CElementBase::IsVisible(true);
//--- Обновить положение объектов
   Moving();
//--- Показать элементы
   int elements_total=ElementsTotal();
   for(int i=0; i<elements_total; i++)
     {
      if(!m_elements[i].IsDropdown())
         m_elements[i].Show();
     }
//--- Показать объект (должен быть сверху группы кнопок)
   ::ObjectSetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
  }
//+------------------------------------------------------------------+
//| Скрыть                                                           |
//+------------------------------------------------------------------+
void CTabs::Hide(void)
  {
//--- Выйти, если элемент уже скрыт
   if(!CElementBase::IsVisible())
      return;
//--- Скрыть объект
   ::ObjectSetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
//--- Состояние видимости
   CElementBase::IsVisible(false);
   CElementBase::MouseFocus(false);
//--- Скрыть элементы
   int elements_total=ElementsTotal();
   for(int i=0; i<elements_total; i++)
      m_elements[i].Hide();
//--- Скрыть элементы вкладок
   int tabs_total=TabsTotal();
   for(int i=0; i<tabs_total; i++)
     {
      int tab_elements_total=::ArraySize(m_tab[i].elements);
      for(int t=0; t<tab_elements_total; t++)
         m_tab[i].elements[t].Hide();
     }
  }
//+------------------------------------------------------------------+
//| Удаление                                                         |
//+------------------------------------------------------------------+
void CTabs::Delete(void)
  {
   CElement::Delete();
//--- Освобождение массивов элемента
   uint tabs_total=TabsTotal();
   for(uint i=0; i<tabs_total; i++)
      ::ArrayFree(m_tab[i].elements);
//--- 
   ::ArrayFree(m_tab);
   m_back_color=clrNONE;
  }
//+------------------------------------------------------------------+
//| Нажатие на вкладку в группе                                      |
//+------------------------------------------------------------------+
bool CTabs::OnClickTab(const int id,const int index)
  {
//--- Выйти, если (1) идентификаторы не совпадают или (2) элемент заблокирован
   if(id!=CElementBase::Id() || CElementBase::IsLocked())
      return(false);
//--- Выйти, если индекс не совпадает
   if(index!=m_tabs.SelectedButtonIndex())
      return(true);
//--- Сохранить индекс выделенной вкладки
   SelectedTab(index);
//--- Перерисовать элемент
   ::ObjectSetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   CElement::Update(true);
   ::ObjectSetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
//--- Показать элементы только выделенной вкладки
   ShowTabElements();
//--- Отправим сообщение об изменении в графическом интерфейсе
   ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0.0,"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Общая ширина всех вкладок                                        |
//+------------------------------------------------------------------+
int CTabs::SumWidthTabs(void)
  {
   int width=0;
//--- Если позиционирование вкладок справа или слева, вернуть ширину первой вкладки
   if(m_position_mode==TABS_LEFT || m_position_mode==TABS_RIGHT)
      return(m_tabs.GetButtonPointer(0).XSize());
//--- Суммируем ширину всех вкладок
   int tabs_total=m_tabs.ButtonsTotal();
   for(int i=0; i<tabs_total; i++)
     {
      width=width+m_tabs.GetButtonPointer(i).XSize();
     }
//--- С учётом наслоения на один пиксель
   width=width-(tabs_total-1);
   return(width);
  }
//+------------------------------------------------------------------+
//| Проверка индекса выделенной вкладки                              |
//+------------------------------------------------------------------+
void CTabs::CheckTabIndex(void)
  {
//--- Проверка на выход из диапазона
   int array_size=::ArraySize(m_tab);
   if(m_selected_tab<0)
      m_selected_tab=0;
   if(m_selected_tab>=array_size)
      m_selected_tab=array_size-1;
  }
//+------------------------------------------------------------------+
//| Изменить ширину по правому краю формы                            |
//+------------------------------------------------------------------+
void CTabs::ChangeWidthByRightWindowSide(void)
  {
//--- Выйти, если включен режим привязки к правой части окна
   if(m_anchor_right_window_side)
      return;
//--- Размеры
   int x_size=0;
//--- Рассчитать и установить новый размер фону элемента
   x_size=m_main.X2()-m_canvas.X()-m_auto_xresize_right_offset;
   
//--- Не изменять размер, если меньше установленного ограничения
   if(x_size == m_x_size)
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
void CTabs::ChangeHeightByBottomWindowSide(void)
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
void CTabs::Draw(void)
  {
//--- Нарисовать фон
   CElement::DrawBackground();
//--- Нарисовать рамку
   CElement::DrawBorder();
//--- Нарисовать метку выделенной вкладки
   DrawPatch();
  }
//+------------------------------------------------------------------+
//| Рисует метку вкладки                                             |
//+------------------------------------------------------------------+
void CTabs::DrawPatch(void)
  {
//--- Координаты
   int x1 =0,x2 =0;
   int y1 =0,y2 =0;
//---
   if(m_position_mode==TABS_TOP)
     {
      x1 =m_tabs.GetButtonPointer(m_selected_tab).XGap()+1;
      x2 =x1+m_tabs.GetButtonPointer(m_selected_tab).XSize()-3;
     }
   else if(m_position_mode==TABS_BOTTOM)
     {
      x1 =m_tabs.GetButtonPointer(m_selected_tab).XGap()+1;
      x2 =x1+m_tabs.GetButtonPointer(m_selected_tab).XSize()-3;
      y1 =YSize()-1;
      y2 =y1;
     }
   else if(m_position_mode==TABS_LEFT)
     {
      y1 =m_tabs.GetButtonPointer(m_selected_tab).YGap()+1;
      y2 =y1+m_tabs.GetButtonPointer(m_selected_tab).YSize()-3;
     }
   else if(m_position_mode==TABS_RIGHT)
     {
      x1 =XSize()-1;
      x2 =x1;
      y1 =m_tabs.GetButtonPointer(m_selected_tab).YGap()+1;
      y2 =y1+m_tabs.GetButtonPointer(m_selected_tab).YSize()-3;
     }
//--- Определим цвет для линии
   color clr=m_back_color;
   if(m_tabs.GetButtonPointer(m_selected_tab).CElementBase::IsLocked())
      clr=m_tabs.GetButtonPointer(m_selected_tab).BackColorLocked();
//--- Рисуем линию
   m_canvas.Line(x1,y1,x2,y2,::ColorToARGB(clr,m_alpha));
  }
//+------------------------------------------------------------------+
//| Обновление элемента                                              |
//+------------------------------------------------------------------+
void CTabs::Update(void)
  {
//--- Нарисовать фон
   CElement::Update(true);
//--- Нарисовать кнопки
   int tabs_total=TabsTotal();
   for(int i=0; i<tabs_total; i++)
      m_tabs.GetButtonPointer(i).Update(true);
  }
//+------------------------------------------------------------------+
