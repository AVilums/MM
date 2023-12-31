//+------------------------------------------------------------------+
//|                                                    StatusBar.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "TextLabel.mqh"
#include "SeparateLine.mqh"
//+------------------------------------------------------------------+
//| Класс для создания статусной строки                              |
//+------------------------------------------------------------------+
class CStatusBar : public CElement
  {
private:
   //--- Объекты для создания элемента
   CTextLabel        m_items[];
   CSeparateLine     m_sep_line[];
   //---
public:
                     CStatusBar(void);
                    ~CStatusBar(void);
   //--- Методы для создания статусной строки
   bool              CreateStatusBar(const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   bool              CreateItems(void);
   bool              CreateSeparateLine(const int line_index);
   //---
public:
   //--- Возвращает указатель пункта и разделительной линии
   CTextLabel       *GetItemPointer(const uint index);
   CSeparateLine    *GetSeparateLinePointer(const uint index);
   //--- (1) Количество пунктов и (2) разделительных линий
   int               ItemsTotal(void)         const { return(::ArraySize(m_items));    }
   int               SeparateLinesTotal(void) const { return(::ArraySize(m_sep_line)); }
   //--- Добавляет пункт с указанными свойствами до создания статусной строки
   void              AddItem(const string text,const int width);
   //--- Установка значения по указанному индексу
   void              SetValue(const uint index,const string value);
   //---
public:
   //--- Удаление
   virtual void      Delete(void);
   //--- Рисует элемент
   virtual void      Draw(void);
   //---
private:
   //--- Расчёт ширины элемента
   int               CalculationXSize(void);
   //--- Расчёт ширины первого пункта
   int               CalculationFirstItemXSize(void);
   //--- Расчёт X-координаты пункта
   int               CalculationItemX(const int item_index=0);
   //--- Изменить ширину по правому краю окна
   virtual void      ChangeWidthByRightWindowSide(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CStatusBar::CStatusBar(void)
  {
//--- Сохраним имя класса элемента в базовом классе  
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CStatusBar::~CStatusBar(void)
  {
  }
//+------------------------------------------------------------------+
//| Создаёт статусную строку                                         |
//+------------------------------------------------------------------+
bool CStatusBar::CreateStatusBar(const int x_gap,const int y_gap)
  {
//--- Выйти, если нет указателя на главный элемент
   if(!CElement::CheckMainPointer())
      return(false);
//--- Инициализация свойств
   InitializeProperties(x_gap,y_gap);
//--- Создаёт элемент
   if(!CreateCanvas())
      return(false);
   if(!CreateItems())
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Инициализация свойств                                            |
//+------------------------------------------------------------------+
void CStatusBar::InitializeProperties(const int x_gap,const int y_gap)
  {
   m_x        =CElement::CalculateX(x_gap);
   m_y        =CElement::CalculateY(y_gap);
   m_x_size   =CalculationXSize();
   m_y_size   =(m_y_size<1)? 22 : m_y_size;
//--- Свойства по умолчанию
   m_back_color   =(m_back_color!=clrNONE)? m_back_color : C'225,225,225';
   m_border_color =(m_border_color!=clrNONE)? m_border_color : m_back_color;
   m_label_color  =(m_label_color!=clrNONE)? m_label_color : clrBlack;
   m_label_x_gap  =(m_label_x_gap!=WRONG_VALUE)? m_label_x_gap : 0;
   m_label_y_gap  =(m_label_y_gap!=WRONG_VALUE)? m_label_y_gap : 0;
//--- Отступы от крайней точки
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
  }
//+------------------------------------------------------------------+
//| Создаёт объект для рисования                                     |
//+------------------------------------------------------------------+
bool CStatusBar::CreateCanvas(void)
  {
//--- Формирование имени объекта
   string name=CElementBase::ElementName("statusbar");
//--- Создание объекта
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт список пунктов статусной строки                          |
//+------------------------------------------------------------------+
bool CStatusBar::CreateItems(void)
  {
   int x=0,y=0;
//--- Получим количество пунктов
   int items_total=ItemsTotal();
//--- Если нет ни одного пункта в группе, сообщить об этом и выйти
   if(items_total<1)
     {
      ::Print(__FUNCTION__," > Вызов этого метода нужно осуществлять, "
              "когда в группе есть хотя бы один пункт! Воспользуйтесь методом CStatusBar::AddItem()");
      return(false);
     }
//--- Если ширина первого пункта не задана, то рассчитаем её относительно общей ширины других пунктов
   if(m_items[0].XSize()<1)
      m_items[0].XSize(CalculationFirstItemXSize());
//--- Создадим указанное количество пунктов
   for(int i=0; i<items_total; i++)
     {
      //--- Сохраним указатель на родительский элемент
      m_items[i].MainPointer(this);
      //--- Координата X
      x=(i>0)? x+m_items[i-1].XSize() : 0;
      //--- Свойства
      m_items[i].Index(i);
      m_items[i].YSize(m_y_size);
      m_items[i].Font(CElement::Font());
      m_items[i].FontSize(CElement::FontSize());
      m_items[i].LabelXGap(m_items[i].LabelXGap()<0? 7 : m_items[i].LabelXGap());
      m_items[i].LabelYGap(m_items[i].LabelYGap()<0? 5 : m_items[i].LabelYGap());
      //--- Создание объекта
      if(!m_items[i].CreateTextLabel(m_items[i].LabelText(),x,y))
         return(false);
      //--- Добавить элемент в массив
      CElement::AddToArray(m_items[i]);
     }
//--- Создание разделительных линий
   for(int i=1; i<items_total; i++)
      CreateSeparateLine(i);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт разделительную линию                                     |
//+------------------------------------------------------------------+
bool CStatusBar::CreateSeparateLine(const int line_index)
  {
//--- Линии устанавливаются со второго (1) пункта
   if(line_index<1)
      return(false);
//--- Координаты
   int x =m_items[line_index].XGap();
   int y =3;
//--- Корректировка индекса
   int i=line_index-1;
//--- Увеличение массива линий на один элемент
   int array_size=::ArraySize(m_sep_line);
   ::ArrayResize(m_sep_line,array_size+1);
//--- Сохраним указатель формы
   m_sep_line[i].MainPointer(this);
//--- Свойства
   m_sep_line[i].Index(i);
   m_sep_line[i].TypeSepLine(V_SEP_LINE);
//--- Создание линии
   if(!m_sep_line[i].CreateSeparateLine(x,y,2,m_y_size-6))
      return(false);
//--- Добавить элемент в массив
   CElement::AddToArray(m_sep_line[i]);
   return(true);
  }
//+------------------------------------------------------------------+
//| Возвращает указатель пункта меню по индексу                      |
//+------------------------------------------------------------------+
CTextLabel *CStatusBar::GetItemPointer(const uint index)
  {
   uint array_size=::ArraySize(m_items);
//--- Если нет ни одного пункта в контекстном меню, сообщить об этом
   if(array_size<1)
      ::Print(__FUNCTION__," > Вызов этого метода нужно осуществлять, когда есть хотя бы один пункт!");
//--- Корректировка в случае выхода из диапазона
   uint i=(index>=array_size)? array_size-1 : index;
//--- Вернуть указатель
   return(::GetPointer(m_items[i]));
  }
//+------------------------------------------------------------------+
//| Возвращает указатель разделительную линию по индексу             |
//+------------------------------------------------------------------+
CSeparateLine *CStatusBar::GetSeparateLinePointer(const uint index)
  {
   uint array_size=::ArraySize(m_sep_line);
//--- Если нет ни одного пункта в контекстном меню, сообщить об этом
   if(array_size<1)
      return(NULL);
//--- Корректировка в случае выхода из диапазона
   uint i=(index>=array_size)? array_size-1 : index;
//--- Вернуть указатель
   return(::GetPointer(m_sep_line[i]));
  }
//+------------------------------------------------------------------+
//| Добавляет пункт меню                                             |
//+------------------------------------------------------------------+
void CStatusBar::AddItem(const string text,const int width)
  {
//--- Увеличим размер массивов на один элемент
   int array_size=::ArraySize(m_items);
   ::ArrayResize(m_items,array_size+1);
//--- Сохраним значения переданных параметров
   m_items[array_size].XSize(width);
   m_items[array_size].LabelText(text);
  }
//+------------------------------------------------------------------+
//| Устанавливает значение по указанному индексу                     |
//+------------------------------------------------------------------+
void CStatusBar::SetValue(const uint index,const string value)
  {
//--- Проверка на выход из диапазона
   uint array_size=::ArraySize(m_items);
   if(array_size<1)
      return;
//--- Скорректировать значение индекса, если выходит из диапазона
   uint correct_index=(index>=array_size)? array_size-1 : index;
//--- Установка переданного текста
   m_items[correct_index].LabelText(value);
  }
//+------------------------------------------------------------------+
//| Удаление                                                         |
//+------------------------------------------------------------------+
void CStatusBar::Delete(void)
  {
   CElement::Delete();
//--- Освобождение массивов элемента
   ::ArrayFree(m_items);
   ::ArrayFree(m_sep_line);
  }
//+------------------------------------------------------------------+
//| Расчёт ширины элемента                                           |
//+------------------------------------------------------------------+
int CStatusBar::CalculationXSize(void)
  {
   return((m_x_size<1 || m_auto_xresize_mode)? m_main.X2()-m_x-m_auto_xresize_right_offset : m_x_size);
  }
//+------------------------------------------------------------------+
//| Расчёт ширины первого пункта                                     |
//+------------------------------------------------------------------+
int CStatusBar::CalculationFirstItemXSize(void)
  {
   int width=0;
//--- Получим количество пунктов
   int items_total=ItemsTotal();
   if(items_total<1)
      return(0);
//--- Рассчитаем ширину относительно общей ширины остальных пунктов
   for(int i=1; i<items_total; i++)
      width+=m_items[i].XSize();
//---
   return(m_x_size-width);
  }
//+------------------------------------------------------------------+
//| Изменить ширину по правому краю формы                            |
//+------------------------------------------------------------------+
void CStatusBar::ChangeWidthByRightWindowSide(void)
  {
//--- Выйти, если включен режим фиксации к правому краю формы
   if(m_anchor_right_window_side)
      return;
//--- Координаты и ширина
   int x=0;
//--- Рассчитаем и установим новый общий размер
   int x_size=m_main.X2()-m_canvas.X()-m_auto_xresize_right_offset;
   CElementBase::XSize(x_size);
   m_canvas.XSize(x_size);
   m_canvas.Resize(x_size,m_y_size);
//--- Рассчитаем и установим новый размер первому пункту
   x_size=CalculationFirstItemXSize();
   m_items[0].XSize(x_size);
   m_items[0].CanvasPointer().XSize(x_size);
   m_items[0].CanvasPointer().Resize(x_size,m_y_size);
   m_items[0].Update(true);
//--- Получим количество пунктов
   int items_total=ItemsTotal();
//--- Установим координату и отступ для всех пунктов кроме первого
   for(int i=1; i<items_total; i++)
     {
      x=x+m_items[i-1].XSize();
      m_items[i].XGap(x);
      m_sep_line[i-1].XGap(x);
      m_items[i].CanvasPointer().XGap(x);
      m_sep_line[i-1].CanvasPointer().XGap(x);
     }
//--- Перерисовать элемент
   Draw();
//--- Обновить положение объектов
   Moving();
  }
//+------------------------------------------------------------------+
//| Рисует элемент                                                   |
//+------------------------------------------------------------------+
void CStatusBar::Draw(void)
  {
//--- Нарисовать фон
   CElement::DrawBackground();
  }
//+------------------------------------------------------------------+
