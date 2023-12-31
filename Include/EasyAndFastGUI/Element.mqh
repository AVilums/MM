//+------------------------------------------------------------------+
//|                                                      Element.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "ElementBase.mqh"
class CWindow;
//+------------------------------------------------------------------+
//| Производный класс элемента управления                            |
//+------------------------------------------------------------------+
class CElement : public CElementBase
  {
protected:
   //--- Указатель на форму
   CWindow          *m_wnd;
   //--- Указатель на главный элемент
   CElement         *m_main;
   //--- Холст для рисования элемента
   CRectCanvas       m_canvas;
   //--- Указатели на подключенные элементы
   CElement         *m_elements[];
   //--- Группы изображений
   struct EImagesGroup
     {
      //--- Массив изображений
      CImage            m_image[];
      //--- Отступы ярлыка
      int               m_x_gap;
      int               m_y_gap;
      //--- Выбранное для показа изображение в группе
      int               m_selected_image;
     };
   EImagesGroup      m_images_group[];
   //--- Отступы ярлыка
   int               m_icon_x_gap;
   int               m_icon_y_gap;
   //--- Цвет фона в разных состояниях
   color             m_back_color;
   color             m_back_color_hover;
   color             m_back_color_locked;
   color             m_back_color_pressed;
   //--- Цвет рамки в разных состояниях
   color             m_border_color;
   color             m_border_color_hover;
   color             m_border_color_locked;
   color             m_border_color_pressed;
   //--- Цвета текста в разных состояниях
   color             m_label_color;
   color             m_label_color_hover;
   color             m_label_color_locked;
   color             m_label_color_pressed;
   //--- Текст описания
   string            m_label_text;
   //--- Отступы текстовой метки
   int               m_label_x_gap;
   int               m_label_y_gap;
   //--- Шрифт
   string            m_font;
   int               m_font_size;
   //--- Значение альфа-канала (прозрачность элемента)
   uchar             m_alpha;
   //--- Текст всплывающей подсказки
   string            m_tooltip_text;
   //--- Режим выравнивания текста
   bool              m_is_center_text;
   //--- Приоритет на нажатие левой кнопки мыши
   long              m_zorder;
   //---
public:
                     CElement(void);
                    ~CElement(void);
   //---
protected:
   //--- Создание холста для рисования
   bool              CreateCanvas(const string name,const int x,const int y,
                                  const int x_size,const int y_size,ENUM_COLOR_FORMAT clr_format=COLOR_FORMAT_ARGB_NORMALIZE);
   //---
public:
   //--- Сохраняет и возвращает указатель на форму
   CWindow          *WindowPointer(void)                             { return(::GetPointer(m_wnd));     }
   void              WindowPointer(CWindow &object)                  { m_wnd=::GetPointer(object);      }
   //--- Сохраняет и возвращает указатель на (1) главный элемент, 
   //    (2) возвращает указатель на холст элемента, (3) возвращает указатель на группу изображений
   CElement         *MainPointer(void)                               { return(::GetPointer(m_main));    }
   void              MainPointer(CElement &object)                   { m_main=::GetPointer(object);     }
   CRectCanvas      *CanvasPointer(void)                             { return(::GetPointer(m_canvas));  }
   //--- (1) Получение количества подключенных элементов, (2) освобождение массива подключенных элементов
   int               ElementsTotal(void)                       const { return(::ArraySize(m_elements)); }
   void              FreeElementsArray(void)                         { ::ArrayFree(m_elements);         }
   //--- Возвращает указатель подключенного элемента по указанному индексу
   CElement         *Element(const uint index);
   //--- Значение альфа-канала (прозрачность элемента)
   void              Alpha(const uchar value)                        { m_alpha=value;                   }
   uchar             Alpha(void)                               const { return(m_alpha);                 }
   //--- (1) Всплыващая подсказка, (2) режим показа всплывающей подсказки
   void              Tooltip(const string text)                      { m_tooltip_text=text;             }
   string            Tooltip(void)                             const { return(m_tooltip_text);          }
   void              ShowTooltip(const bool state);
   //--- Цвет фона в разных состояниях
   void              BackColor(const color clr)                      { m_back_color=clr;                }
   color             BackColor(void)                           const { return(m_back_color);            }
   void              BackColorHover(const color clr)                 { m_back_color_hover=clr;          }
   color             BackColorHover(void)                      const { return(m_back_color_hover);      }
   void              BackColorLocked(const color clr)                { m_back_color_locked=clr;         }
   color             BackColorLocked(void)                     const { return(m_back_color_locked);     }
   void              BackColorPressed(const color clr)               { m_back_color_pressed=clr;        }
   color             BackColorPressed(void)                    const { return(m_back_color_pressed);    }
   //--- Цвет рамки в разных состояниях
   void              BorderColor(const color clr)                    { m_border_color=clr;              }
   color             BorderColor(void)                         const { return(m_border_color);          }
   void              BorderColorHover(const color clr)               { m_border_color_hover=clr;        }
   color             BorderColorHover(void)                    const { return(m_border_color_hover);    }
   void              BorderColorLocked(const color clr)              { m_border_color_locked=clr;       }
   color             BorderColorLocked(void)                   const { return(m_border_color_locked);   }
   void              BorderColorPressed(const color clr)             { m_border_color_pressed=clr;      }
   color             BorderColorPressed(void)                  const { return(m_border_color_pressed);  }
   //--- Цвета текстовой метки в разных состояниях
   void              LabelColor(const color clr)                     { m_label_color=clr;               }
   color             LabelColor(void)                          const { return(m_label_color);           }
   void              LabelColorHover(const color clr)                { m_label_color_hover=clr;         }
   color             LabelColorHover(void)                     const { return(m_label_color_hover);     }
   void              LabelColorLocked(const color clr)               { m_label_color_locked=clr;        }
   color             LabelColorLocked(void)                    const { return(m_label_color_locked);    }
   void              LabelColorPressed(const color clr)              { m_label_color_pressed=clr;       }
   color             LabelColorPressed(void)                   const { return(m_label_color_pressed);   }
   //--- Отступы ярлыка
   void              IconXGap(const int x_gap)                       { m_icon_x_gap=x_gap;              }
   int               IconXGap(void)                            const { return(m_icon_x_gap);            }
   void              IconYGap(const int y_gap)                       { m_icon_y_gap=y_gap;              }
   int               IconYGap(void)                            const { return(m_icon_y_gap);            }
   //--- (1) Текст описания поля ввода, (2) отступы текстовой метки
   void              LabelText(const string text)                    { m_label_text=text;               }
   string            LabelText(void)                           const { return(m_label_text);            }
   void              LabelXGap(const int x_gap)                      { m_label_x_gap=x_gap;             }
   int               LabelXGap(void)                           const { return(m_label_x_gap);           }
   void              LabelYGap(const int y_gap)                      { m_label_y_gap=y_gap;             }
   int               LabelYGap(void)                           const { return(m_label_y_gap);           }
   //--- (1) Шрифт и (2) размер шрифта
   void              Font(const string font)                         { m_font=font;                     }
   string            Font(void)                                const { return(m_font);                  }
   void              FontSize(const int font_size)                   { m_font_size=font_size;           }
   int               FontSize(void)                            const { return(m_font_size);             }
   //--- (1) Выравнивать текст по центру, (2) приоритет на нажатие левой кнопкой мыши
   void              IsCenterText(const bool state)                  { m_is_center_text=state;          }
   bool              IsCenterText(void)                        const { return(m_is_center_text);        }
   long              Z_Order(void)                             const { return(m_zorder);                }
   void              Z_Order(const long z_order);
   //--- Блокировка элемента
   virtual void      IsLocked(const bool state);
   //--- Доступность элемента
   virtual void      IsAvailable(const bool state);
   //--- Отступ для картинок указанной группы
   int               ImageGroupXGap(const uint index);
   void              ImageGroupXGap(const uint index,const int x_gap);
   //--- Установка ярлыков для активного и заблокированного состояния
   void              IconFile(const string file_path);
   void              IconFile(const uint resource_index);
   string            IconFile(bool resource_index_mode = false);
   void              IconFileLocked(const string file_path);
   void              IconFileLocked(const uint resource_index);
   string            IconFileLocked(bool resource_index_mode = false);
   //--- Установка ярлыков для элемента в нажатом состоянии (доступен/заблокирован)
   void              IconFilePressed(const string file_path);
   void              IconFilePressed(const uint resource_index);
   string            IconFilePressed(bool resource_index_mode = false);
   void              IconFilePressedLocked(const string file_path);
   void              IconFilePressedLocked(const uint resource_index);
   string            IconFilePressedLocked(bool resource_index_mode = false);
   //--- Возвращает количество групп изображений
   uint              ImagesGroupTotal(void) const { return(::ArraySize(m_images_group)); }
   //--- Возвращает количество изображений в указанной группе
   int               ImagesTotal(const uint group_index);
   //--- Добавление группы изображений с массивом изображений
   void              AddImagesGroup(const int x_gap,const int y_gap,const string &file_pathways[]);
   //--- Добавление группы изображений
   void              AddImagesGroup(const int x_gap,const int y_gap);
   //--- Добавление изображения (путь к ресурсу) в указанную группу
   void              AddImage(const uint group_index,const string file_path);
   //--- Добавление изображения (индекс к ресурсу) в указанную группу
   void              AddImage(const uint group_index,const uint resource_index);
   //--- Установка/замена изображения (путь к ресурсу)
   void              SetImage(const uint group_index,const uint image_index,const string file_path);
   //--- Установка/замена изображения (индекс к ресурсу)
   void              SetImage(const uint group_index,const uint image_index,const uint resource_index);
   //--- Переключение изображения
   void              ChangeImage(const uint group_index,const uint image_index);
   //--- Возвращает выбранное для показа изображение в указанной группе
   int               SelectedImage(const uint group_index=0);
   //---
public:
   //--- Обработчик событий графика
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam) {}
   //--- Таймер
   virtual void      OnEventTimer(void) {}
   //--- Перемещение элемента
   virtual void      Moving(const bool only_visible=true);
   //--- (1) Показ, (2) скрытие, (3) перемещение на верхний слой, (4) удаление
   virtual void      Show(void);
   virtual void      Hide(void);
   virtual void      Reset(void);
   virtual void      Delete(void);
   //--- (1) Установка, (2) сброс приоритетов на нажатие левой кнопки мыши
   virtual void      SetZorders(void);
   virtual void      ResetZorders(void);
   //--- Обновляет элемент для отображения последних изменений
   virtual void      Update(const bool redraw=false);
   //--- Рисует элемент
   virtual void      Draw(void) {}
   //---
protected:
   //--- Метод для добавления указателей на элементы-потомки в общий массив
   void              AddToArray(CElement &object);
   //--- Проверить выход из диапазона групп картинок
   virtual bool      CheckOutOfRange(const uint group_index,const uint image_index);
   //--- Проверка наличия указателя на главный элемент
   bool              CheckMainPointer(void);

   //--- Расчёт абсолютных координат
   int               CalculateX(const int x_gap);
   int               CalculateY(const int y_gap);
   //--- Расчёт относительных координат от крайней точки формы
   int               CalculateXGap(const int x);
   int               CalculateYGap(const int y);

   //--- Рисует фон
   virtual void      DrawBackground(void);
   //--- Рисует рамку
   virtual void      DrawBorder(void);
   //--- Рисует картинку
   virtual void      DrawImage(void);
   //--- Рисует текст
   virtual void      DrawText(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CElement::CElement(void) : m_alpha(255),
                           m_tooltip_text("\n"),
                           m_back_color(clrNONE),
                           m_back_color_hover(clrNONE),
                           m_back_color_locked(clrNONE),
                           m_back_color_pressed(clrNONE),
                           m_border_color(clrNONE),
                           m_border_color_hover(clrNONE),
                           m_border_color_locked(clrNONE),
                           m_border_color_pressed(clrNONE),
                           m_icon_x_gap(WRONG_VALUE),
                           m_icon_y_gap(WRONG_VALUE),
                           m_label_text(""),
                           m_label_x_gap(WRONG_VALUE),
                           m_label_y_gap(WRONG_VALUE),
                           m_label_color(clrNONE),
                           m_label_color_hover(clrNONE),
                           m_label_color_locked(clrNONE),
                           m_label_color_pressed(clrNONE),
                           m_font("Calibri"),
                           m_font_size(8),
                           m_is_center_text(false),
                           m_zorder(WRONG_VALUE)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CElement::~CElement(void)
  {
  }
//+------------------------------------------------------------------+
//| Создание холста для рисования элемента                           |
//+------------------------------------------------------------------+
bool CElement::CreateCanvas(const string name,const int x,const int y,
                            const int x_size,const int y_size,ENUM_COLOR_FORMAT clr_format=COLOR_FORMAT_ARGB_NORMALIZE)
  {
//--- Корректировка размеров
   int xsize =(x_size<1)? 50 : x_size;
   int ysize =(y_size<1)? 20 : y_size;
//--- Сбросить последнюю ошибку
   ::ResetLastError();
//--- Создание объекта
   if(!m_canvas.CreateBitmapLabel(m_chart_id,m_subwin,name,x,y,xsize,ysize,clr_format))
     {
      ::Print(__FUNCTION__," > name: ",name);
      ::Print(__FUNCTION__," > Не удалось создать холст для рисования элемента ("+m_class_name+"): ",::GetLastError());
      return(false);
     }
//--- Сбросить последнюю ошибку
   ::ResetLastError();
//--- Получим указатель на базовый класс
   if(!m_canvas.Attach(m_chart_id,name,clr_format))
     {
      ::Print(__FUNCTION__," > Не удалось присоединить холст для рисования к графику: ",::GetLastError());
      return(false);
     }
//--- Свойства
   ::ObjectSetString(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_TOOLTIP,"\n");
   ::ObjectSetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_CORNER,m_corner);
   ::ObjectSetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_SELECTABLE,false);

//--- У всех элементов, кроме формы, приоритет больше, чем у главного элемента
   Z_Order((dynamic_cast<CWindow*>(&this)!=NULL)? 0 : m_main.Z_Order()+1);
//--- Координаты
   m_canvas.X(x);
   m_canvas.Y(y);
//--- Размеры
   m_canvas.XSize(x_size);
   m_canvas.YSize(y_size);
//--- Отступы от крайней точки
   m_canvas.XGap(CalculateXGap(x));
   m_canvas.YGap(CalculateYGap(y));
   return(true);
  }
//+------------------------------------------------------------------+
//| Возвращает отступ для картинок из указанной группы               |
//+------------------------------------------------------------------+
int CElement::ImageGroupXGap(const uint index)
  {
//--- Вернуть указатель объекта
   return(m_images_group[index].m_x_gap);
  }
//+------------------------------------------------------------------+
//| Установка отступа для картинок из указанной группы               |
//+------------------------------------------------------------------+
void CElement::ImageGroupXGap(const uint index,const int x_gap)
  {
   m_images_group[index].m_x_gap=x_gap;
  }
//+------------------------------------------------------------------+
//| Возвращает указатель подключенного элемента                      |
//+------------------------------------------------------------------+
CElement *CElement::Element(const uint index)
  {
   uint array_size=::ArraySize(m_elements);
//--- Проверка размера массива объектов
   if(array_size<1)
     {
      ::Print(__FUNCTION__," > В этом элементе ("+m_class_name+") нет элементов-потомков!");
      return(NULL);
     }
//--- Корректировка в случае выхода из диапазона
   uint i=(index>=array_size)? array_size-1 : index;
//--- Вернуть указатель объекта
   return(::GetPointer(m_elements[i]));
  }
//+------------------------------------------------------------------+
//| Установка показа всплывающей подсказки                           |
//+------------------------------------------------------------------+
void CElement::ShowTooltip(const bool state)
  {
   if(state)
       ::ObjectSetString(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_TOOLTIP,m_tooltip_text);
   else
       ::ObjectSetString(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_TOOLTIP,"\n");
  }
//+------------------------------------------------------------------+
//| Приоритет на нажатие левой кнопкой мыши                          |
//+------------------------------------------------------------------+
void CElement::Z_Order(const long z_order)
  {
   m_zorder=z_order;
   SetZorders();
  }
//+------------------------------------------------------------------+
//| Блокировка/снятие блокировки элемента                            |
//+------------------------------------------------------------------+
void CElement::IsLocked(const bool state)
  {
//--- Выйти, если уже установлено
   if(state==CElementBase::IsLocked())
      return;
//--- Сохранить состояние
   CElementBase::IsLocked(state);
//--- Остальные элементы
   int elements_total=ElementsTotal();
   for(int i=0; i<elements_total; i++)
      m_elements[i].IsLocked(state);
//--- Проверка указателя
   if(::CheckPointer(m_main)==POINTER_INVALID)
      return;
//--- Событие отправляет только главный элемент составной группы
   if(this.Id()!=m_main.Id())
     {
      ::EventChartCustom(m_chart_id,ON_SET_LOCKED,CElementBase::Id(),(int)state,"");
      //--- Отправим сообщение об изменении в графическом интерфейсе
      ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0.0,"");
     }
   else
     {
      if(state!=m_main.CElementBase::IsLocked())
        {
         ::EventChartCustom(m_chart_id,ON_SET_LOCKED,CElementBase::Id(),(int)state,"");
         //--- Отправим сообщение об изменении в графическом интерфейсе
         ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0.0,"");
        }
     }
  }
//+------------------------------------------------------------------+
//| Доступность элемента                                             |
//+------------------------------------------------------------------+
void CElement::IsAvailable(const bool state)
  {
//--- Выйти, если уже установлено
   if(state==CElementBase::IsAvailable())
      return;
//--- Установить
   CElementBase::IsAvailable(state);
//--- Остальные элементы
   int elements_total=ElementsTotal();
   for(int i=0; i<elements_total; i++)
      m_elements[i].IsAvailable(state);
//--- Установить приоритеты на нажатие левой кнопкой мыши
   if(state)
      SetZorders();
   else
      ResetZorders();
  }
//+------------------------------------------------------------------+
//| Установка картинки для активного состояния                       |
//+------------------------------------------------------------------+
void CElement::IconFile(const string file_path)
  {
//--- Если ещё нет ни одной группы изображений
   if(ImagesGroupTotal()<1)
     {
      m_icon_x_gap =(m_icon_x_gap!=WRONG_VALUE)? m_icon_x_gap : 0;
      m_icon_y_gap =(m_icon_y_gap!=WRONG_VALUE)? m_icon_y_gap : 0;
      //--- Добавим группу и изображение
      AddImagesGroup(m_icon_x_gap,m_icon_y_gap);
      AddImage(0,file_path);
      AddImage(1,"");
      //--- Изображение по умолчанию
      m_images_group[0].m_selected_image=0;
      return;
     }
//--- Установить изображение в первую группу первым элементом
   SetImage(0,0,file_path);
  }
//+------------------------------------------------------------------+
//| Установка картинки для активного состояния (индекс с ресурсу)    |
//+------------------------------------------------------------------+
void CElement::IconFile(const uint resource_index)
  {
//--- Если ещё нет ни одной группы изображений
   if(ImagesGroupTotal()<1)
     {
      m_icon_x_gap =(m_icon_x_gap!=WRONG_VALUE)? m_icon_x_gap : 0;
      m_icon_y_gap =(m_icon_y_gap!=WRONG_VALUE)? m_icon_y_gap : 0;
      //--- Добавим группу и изображение
      AddImagesGroup(m_icon_x_gap,m_icon_y_gap);
      AddImage(0,resource_index);
      AddImage(1,INT_MAX);
      //--- Изображение по умолчанию
      m_images_group[0].m_selected_image=0;
      return;
     }
//--- Установить изображение в первую группу первым элементом
   SetImage(0,0,resource_index);
  }
//+------------------------------------------------------------------+
//| Возвращает картинку                                              |
//+------------------------------------------------------------------+
string CElement::IconFile(bool resource_index_mode = false)
  {
//--- Пустая строка, если нет ни одной группы изображений
   if(ImagesGroupTotal()<1)
      return("");
//--- Если нет изображения в группе
   if(::ArraySize(m_images_group[0].m_image)<1)
      return("");
//--- Вернуть путь к изображению
   return((!resource_index_mode)? 
     m_images_group[0].m_image[0].BmpPath() : 
     (string)m_images_group[0].m_image[0].ResourceIndex());
  }
//+------------------------------------------------------------------+
//| Установка картинки для заблокированного состояния                |
//+------------------------------------------------------------------+
void CElement::IconFileLocked(const string file_path)
  {
//--- Если ещё нет ни одной группы изображений
   if(ImagesGroupTotal()<1)
     {
      m_icon_x_gap =(m_icon_x_gap!=WRONG_VALUE)? m_icon_x_gap : 0;
      m_icon_y_gap =(m_icon_y_gap!=WRONG_VALUE)? m_icon_y_gap : 0;
      //--- Добавим группу и изображение
      AddImagesGroup(m_icon_x_gap,m_icon_y_gap);
      AddImage(0,"");
      AddImage(1,file_path);
      //--- Изображение по умолчанию
      m_images_group[0].m_selected_image=0;
      return;
     }
//--- Установить изображение в первую группу вторым элементом
   SetImage(0,1,file_path);
  }
//+------------------------------------------------------------------+
//| Установка картинки для заблокированного состояния                |
//+------------------------------------------------------------------+
void CElement::IconFileLocked(const uint resource_index)
  {
//--- Если ещё нет ни одной группы изображений
   if(ImagesGroupTotal()<1)
     {
      m_icon_x_gap =(m_icon_x_gap!=WRONG_VALUE)? m_icon_x_gap : 0;
      m_icon_y_gap =(m_icon_y_gap!=WRONG_VALUE)? m_icon_y_gap : 0;
      //--- Добавим группу и изображение
      AddImagesGroup(m_icon_x_gap,m_icon_y_gap);
      AddImage(0,INT_MAX);
      AddImage(1,resource_index);
      //--- Изображение по умолчанию
      m_images_group[0].m_selected_image=0;
      return;
     }
//--- Установить изображение в первую группу вторым элементом
   SetImage(0,1,resource_index);
  }
//+------------------------------------------------------------------+
//| Возвращает картинку                                              |
//+------------------------------------------------------------------+
string CElement::IconFileLocked(bool resource_index_mode = false)
  {
//--- Пустая строка, если нет ни одной группы изображений
   if(ImagesGroupTotal()<1)
      return("");
//--- Если нет изображения в группе
   if(::ArraySize(m_images_group[0].m_image)<2)
      return("");
//--- Вернуть путь к изображению
   return((!resource_index_mode)? 
     m_images_group[0].m_image[1].BmpPath() : 
     (string)m_images_group[0].m_image[1].ResourceIndex());
  }
//+------------------------------------------------------------------+
//| Установка картинки для нажатого состояния (доступен)             |
//+------------------------------------------------------------------+
void CElement::IconFilePressed(const string file_path)
  {
//--- Добавить место для изображения, если его ещё нет
   while(!CElement::CheckOutOfRange(0,2))
      AddImage(0,"");
//--- Установить картинку
   CElement::SetImage(0,2,file_path);
  }
//+------------------------------------------------------------------+
//| Установка картинки для нажатого состояния (доступен)             |
//+------------------------------------------------------------------+
void CElement::IconFilePressed(const uint resource_index)
  {
//--- Добавить место для изображения, если его ещё нет
   while(!CElement::CheckOutOfRange(0,2))
      AddImage(0,INT_MAX);
//--- Установить картинку
   CElement::SetImage(0,2,resource_index);
  }
//+------------------------------------------------------------------+
//| Возвращает картинку                                              |
//+------------------------------------------------------------------+
string CElement::IconFilePressed(bool resource_index_mode = false)
  {
//--- Пустая строка, если нет ни одной группы изображений
   if(ImagesGroupTotal()<1)
      return("");
//--- Если нет изображения в группе
   if(::ArraySize(m_images_group[0].m_image)<3)
      return("");
//--- Вернуть путь к изображению
   return((!resource_index_mode)? 
     m_images_group[0].m_image[2].BmpPath() : 
     (string)m_images_group[0].m_image[2].ResourceIndex());
  }
//+------------------------------------------------------------------+
//| Установка картинки для нажатого состояния (заблокирован)         |
//+------------------------------------------------------------------+
void CElement::IconFilePressedLocked(const string file_path)
  {
//--- Добавить место для изображения, если его ещё нет
   while(!CElement::CheckOutOfRange(0,3))
      AddImage(0,"");
//--- Установить картинку
   CElement::SetImage(0,3,file_path);
  }
//+------------------------------------------------------------------+
//| Установка картинки для нажатого состояния (заблокирован)         |
//+------------------------------------------------------------------+
void CElement::IconFilePressedLocked(const uint resource_index)
  {
//--- Добавить место для изображения, если его ещё нет
   while(!CElement::CheckOutOfRange(0,3))
      AddImage(0,INT_MAX);
//--- Установить картинку
   CElement::SetImage(0,3,resource_index);
  }
//+------------------------------------------------------------------+
//| Возвращает картинку                                              |
//+------------------------------------------------------------------+
string CElement::IconFilePressedLocked(bool resource_index_mode = false)
  {
//--- Пустая строка, если нет ни одной группы изображений
   if(ImagesGroupTotal()<1)
      return("");
//--- Если нет изображения в группе
   if(::ArraySize(m_images_group[0].m_image)<4)
      return("");
//--- Вернуть путь к изображению
   return((!resource_index_mode)? 
     m_images_group[0].m_image[3].BmpPath() : 
     (string)m_images_group[0].m_image[3].ResourceIndex());
  }
//+------------------------------------------------------------------+
//| Обновление элемента                                              |
//+------------------------------------------------------------------+
void CElement::Update(const bool redraw=false)
  {
//--- С перерисовкой элемента
   if(redraw)
     {
      Draw();
      m_canvas.Update(true);
      return;
     }
//--- Применить
   m_canvas.Update();
  }
//+------------------------------------------------------------------+
//| Перемещение элемента                                             |
//+------------------------------------------------------------------+
void CElement::Moving(const bool only_visible=true)
  {
//--- Выйти, если элемент скрыт
   if(only_visible)
      if(!CElementBase::IsVisible())
         return;
//--- Если привязка справа
   if(m_anchor_right_window_side)
     {
      //--- Сохранение координат в полях элемента
      CElementBase::X(m_main.X2()-XGap());
      //--- Сохранение координат в полях объектов
      m_canvas.X(m_main.X2()-m_canvas.XGap());
     }
   else
     {
      CElementBase::X(m_main.X()+XGap());
      m_canvas.X(m_main.X()+m_canvas.XGap());
     }
//--- Если привязка снизу
   if(m_anchor_bottom_window_side)
     {
      CElementBase::Y(m_main.Y2()-YGap());
      m_canvas.Y(m_main.Y2()-m_canvas.YGap());
     }
   else
     {
      CElementBase::Y(m_main.Y()+YGap());
      m_canvas.Y(m_main.Y()+m_canvas.YGap());
     }
//--- Обновление координат графических объектов
   ::ObjectSetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_XDISTANCE,m_canvas.X());
   ::ObjectSetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_YDISTANCE,m_canvas.Y());
//--- Перемещение подключенных элементов
   int elements_total=ElementsTotal();
   for(int i=0; i<elements_total; i++)
      m_elements[i].Moving(only_visible);
  }
//+------------------------------------------------------------------+
//| Показывает элемент                                               |
//+------------------------------------------------------------------+
void CElement::Show(void)
  {
//--- Выйти, если элемент уже видим
   if(CElementBase::IsVisible())
      return;
//--- Состояние видимости
   CElementBase::IsVisible(true);
//--- Обновить положение объектов
   Moving();
//--- Показать объект
   ::ObjectSetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
//--- Показать подключенные элементы
   int elements_total=ElementsTotal();
   for(int i=0; i<elements_total; i++)
     {
      if(!m_elements[i].IsDropdown())
         m_elements[i].Show();
     }
  }
//+------------------------------------------------------------------+
//| Скрывает элемент                                                 |
//+------------------------------------------------------------------+
void CElement::Hide(void)
  {
//--- Выйти, если элемент уже скрыт
   if(!CElementBase::IsVisible())
      return;
//--- Скрыть объект
   ::ObjectSetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
//--- Состояние видимости
   CElementBase::IsVisible(false);
   CElementBase::MouseFocus(false);
//--- Скрыть подключенные элементы
   int elements_total=ElementsTotal();
   for(int i=0; i<elements_total; i++)
      m_elements[i].Hide();
  }
//+------------------------------------------------------------------+
//| Перемещение на верхний слой                                      |
//+------------------------------------------------------------------+
void CElement::Reset(void)
  {
//--- Выйдем, если элемент выпадающий
   if(CElementBase::IsDropdown())
      return;
//--- Скрыть и показать подключенные элементы
   Hide();
   Show();
  }
//+------------------------------------------------------------------+
//| Удаление                                                         |
//+------------------------------------------------------------------+
void CElement::Delete(void)
  {
//--- Удаление объектов
   m_canvas.Destroy();
//--- Удалить подключенные элементы
   int elements_total=ElementsTotal();
   for(int i=0; i<elements_total; i++)
      m_elements[i].Delete();
//--- Освобождение массива подключенных элементов
   FreeElementsArray();
//--- Инициализация переменных значениями по умолчанию
   CElementBase::LastId(0);
   CElementBase::Id(WRONG_VALUE);
   CElementBase::MouseFocus(false);
   CElementBase::IsVisible(true);
   CElementBase::IsAvailable(true);
//--- Сброс приоритетов
   m_zorder=WRONG_VALUE;
  }
//+------------------------------------------------------------------+
//| Установка приоритетов                                            |
//+------------------------------------------------------------------+
void CElement::SetZorders(void)
  {
   ::ObjectSetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_ZORDER,m_zorder);
   int elements_total=ElementsTotal();
   for(int i=0; i<elements_total; i++)
      m_elements[i].SetZorders();
  }
//+------------------------------------------------------------------+
//| Сброс приоритетов                                                |
//+------------------------------------------------------------------+
void CElement::ResetZorders(void)
  {
   ::ObjectSetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_ZORDER,WRONG_VALUE);
   int elements_total=ElementsTotal();
   for(int i=0; i<elements_total; i++)
      m_elements[i].ResetZorders();
  }
//+------------------------------------------------------------------+
//| Метод для добавления указателей на подключенные элементы         |
//+------------------------------------------------------------------+
void CElement::AddToArray(CElement &object)
  {
   int size=ElementsTotal();
   ::ArrayResize(m_elements,size+1);
   m_elements[size]=::GetPointer(object);
  }
//+------------------------------------------------------------------+
//| Проверить выход из диапазона                                     |
//+------------------------------------------------------------------+
bool CElement::CheckOutOfRange(const uint group_index,const uint image_index)
  {
//--- Проверка индекса группы
   uint images_group_total=::ArraySize(m_images_group);
   if(images_group_total<1 || group_index>=images_group_total)
      return(false);
//--- Проверка индекса изображения
   uint images_total=::ArraySize(m_images_group[group_index].m_image);
   if(images_total<1 || image_index>=images_total)
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Возвращает количество изображений в указанной группе             |
//+------------------------------------------------------------------+
int CElement::ImagesTotal(const uint group_index)
  {
//--- Проверка индекса группы
   uint images_group_total=::ArraySize(m_images_group);
   if(images_group_total<1 || group_index>=images_group_total)
      return(WRONG_VALUE);
//--- Количество изображений
   return(::ArraySize(m_images_group[group_index].m_image));
  }
//+------------------------------------------------------------------+
//| Добавление группы изображений с массивом изображений             |
//+------------------------------------------------------------------+
void CElement::AddImagesGroup(const int x_gap,const int y_gap,const string &file_pathways[])
  {
//--- Получим размер массива групп изображений
   uint images_group_total=::ArraySize(m_images_group);
//--- Добавим одну группу
   ::ArrayResize(m_images_group,images_group_total+1);
//--- Установить отступы для изображений
   m_images_group[images_group_total].m_x_gap =x_gap;
   m_images_group[images_group_total].m_y_gap =y_gap;
//--- Изображение по умолчанию
   m_images_group[images_group_total].m_selected_image=0;
//--- Получим размер массива добавляемых изображений
   uint images_total=::ArraySize(file_pathways);
//--- Добавим изображения в новую группу, если был передан не пустой массив
   for(uint i=0; i<images_total; i++)
      AddImage(images_group_total,file_pathways[i]);
  }
//+------------------------------------------------------------------+
//| Добавление группы изображений                                    |
//+------------------------------------------------------------------+
void CElement::AddImagesGroup(const int x_gap,const int y_gap)
  {
//--- Получим размер массива групп изображений
   uint images_group_total=::ArraySize(m_images_group);
//--- Добавим одну группу
   ::ArrayResize(m_images_group,images_group_total+1);
//--- Установить отступы для изображений
   m_images_group[images_group_total].m_x_gap=x_gap;
   m_images_group[images_group_total].m_y_gap=y_gap;
//--- Изображение по умолчанию
   m_images_group[images_group_total].m_selected_image=0;
  }
//+------------------------------------------------------------------+
//| Добавление изображения (путь к ресурсу) в указанную группу       |
//+------------------------------------------------------------------+
void CElement::AddImage(const uint group_index,const string file_path)
  {
//--- Получим размер массива групп изображений
   uint images_group_total=::ArraySize(m_images_group);
//--- Выйти, если нет ни одной группы
   if(images_group_total<1)
     {
      Print(__FUNCTION__," > Добавить группу изображений можно с помощью методов CElement::AddImagesGroup()");
      return;
     }
//--- Предотвращение выхода из диапазона
   uint check_group_index=(group_index<images_group_total)? group_index : images_group_total-1;
//--- Получим размер массива изображений
   uint images_total=::ArraySize(m_images_group[check_group_index].m_image);
//--- Увеличим размер массива на один элемент
   ::ArrayResize(m_images_group[check_group_index].m_image,images_total+1);
//--- Добавим изображение
   m_images_group[check_group_index].m_image[images_total].ReadImageData(file_path);
  }
//+------------------------------------------------------------------+
//| Добавление изображения (индекс к ресурсу) в указанную группу     |
//+------------------------------------------------------------------+
void CElement::AddImage(const uint group_index,const uint resource_index)
  {
//--- Получим размер массива групп изображений
   uint images_group_total=::ArraySize(m_images_group);
//--- Выйти, если нет ни одной группы
   if(images_group_total<1)
     {
      Print(__FUNCTION__," > Добавить группу изображений можно с помощью методов CElement::AddImagesGroup()");
      return;
     }
//--- Предотвращение выхода из диапазона
   uint check_group_index=(group_index<images_group_total)? group_index : images_group_total-1;
//--- Получим размер массива изображений
   uint images_total=::ArraySize(m_images_group[check_group_index].m_image);
//--- Увеличим размер массива на один элемент
   ::ArrayResize(m_images_group[check_group_index].m_image,images_total+1);
//--- Добавим изображение
   m_images_group[check_group_index].m_image[images_total].ReadImageData(resource_index);
  }
//+------------------------------------------------------------------+
//| Установка/замена изображения (путь к ресурсу)                    |
//+------------------------------------------------------------------+
void CElement::SetImage(const uint group_index,const uint image_index,const string file_path)
  {
//--- Проверка на выход из диапазона
   if(!CheckOutOfRange(group_index,image_index))
      return;
//--- Удалить изображение
   m_images_group[group_index].m_image[image_index].DeleteImageData();
//--- Добавим изображение
   m_images_group[group_index].m_image[image_index].ReadImageData(file_path);
  }
//+------------------------------------------------------------------+
//| Установка/замена изображения (индекс к ресурсу)                  |
//+------------------------------------------------------------------+
void CElement::SetImage(const uint group_index,const uint image_index,const uint resource_index)
  {
//--- Проверка на выход из диапазона
   if(!CheckOutOfRange(group_index,image_index))
      return;
//--- Удалить изображение
   m_images_group[group_index].m_image[image_index].DeleteImageData();
//--- Добавим изображение
   m_images_group[group_index].m_image[image_index].ReadImageData(resource_index);
  }
//+------------------------------------------------------------------+
//| Переключение изображения                                         |
//+------------------------------------------------------------------+
void CElement::ChangeImage(const uint group_index,const uint image_index)
  {
//--- Проверка на выход из диапазона
   if(!CheckOutOfRange(group_index,image_index))
      return;
//--- Сохранить индекс изображения для показа
   m_images_group[group_index].m_selected_image=(int)image_index;
  }
//+------------------------------------------------------------------+
//| Возвращает выбранное для показа изображение в указанной группе   |
//+------------------------------------------------------------------+
int CElement::SelectedImage(const uint group_index=0)
  {
//--- Выйти, если нет ни одной группы
   uint images_group_total=::ArraySize(m_images_group);
   if(images_group_total<1 || group_index>=images_group_total)
      return(WRONG_VALUE);
//--- Выйти, если не одного изображения в указанной группе
   uint images_total=::ArraySize(m_images_group[group_index].m_image);
   if(images_total<1)
      return(WRONG_VALUE);
//--- Вернуть выбранное для показа изображение
   return(m_images_group[group_index].m_selected_image);
  }
//+------------------------------------------------------------------+
//| Проверка наличия указателя на главный элемент                    |
//+------------------------------------------------------------------+
bool CElement::CheckMainPointer(void)
  {
//--- Если нет указателя
   if(::CheckPointer(m_main)==POINTER_INVALID)
     {
      //--- Вывести сообщение в журнал терминала
      ::Print(__FUNCTION__,
              " > Перед созданием элемента... \n...нужно передать указатель на главный элемент: "+
              ClassName()+"::MainPointer(CElementBase &object)");
      //--- Прервать построение графического интерфейса приложения
      return(false);
     }
//--- Сохранение указателя на форму
   m_wnd =m_main.WindowPointer();
//--- Если нет указателя на форму
   if(::CheckPointer(m_wnd)==POINTER_INVALID)
     {
      //--- Вывести сообщение в журнал терминала
      ::Print(__FUNCTION__,
              " > У элемента "+ClassName()+" нет указателя на форму!...\n"+
              "...Элементы должны создаваться в порядке своей вложенности!");
      //--- Прервать построение графического интерфейса приложения
      return(false);
     }
//--- Сохранение указателя на курсор мыши
   m_mouse =m_main.MousePointer();
   
//--- Сохранение свойств

   //Print(__FUNCTION__,
   // " > dynamic_cast<CWindow*>(&this) != NULL: ", dynamic_cast<CWindow*>(&this) != NULL,
   // "; m_main.ClassName(): ", m_main.ClassName(),
   // "; m_wnd: ",m_wnd,
   // "; m_wnd.LastId(): ",m_wnd.LastId(),
   // "; m_main.LastId(): ",m_main.LastId());
   
   m_id       =m_wnd.LastId()+1;
   m_chart_id =m_wnd.ChartId();
   m_subwin   =m_wnd.SubwindowNumber();
   m_corner   =(ENUM_BASE_CORNER)m_wnd.Corner();
   m_anchor   =(ENUM_ANCHOR_POINT)m_wnd.Anchor();
   
//--- Отправить признак наличия указателя
   return(true);
  }
//+------------------------------------------------------------------+
//| Расчёт абсолютной X-координаты                                   |
//+------------------------------------------------------------------+
int CElement::CalculateX(const int x_gap)
  {
   return((AnchorRightWindowSide())? m_main.X2()-x_gap : m_main.X()+x_gap);
  }
//+------------------------------------------------------------------+
//| Расчёт абсолютной Y-координаты                                   |
//+------------------------------------------------------------------+
int CElement::CalculateY(const int y_gap)
  {
   return((AnchorBottomWindowSide())? m_main.Y2()-y_gap : m_main.Y()+y_gap);
  }
//+------------------------------------------------------------------+
//| Расчёт относительной X-координаты от крайней точки формы         |
//+------------------------------------------------------------------+
int CElement::CalculateXGap(const int x)
  {
   return((AnchorRightWindowSide())? m_main.X2()-x : x-m_main.X());
  }
//+------------------------------------------------------------------+
//| Расчёт относительной Y-координаты от крайней точки формы         |
//+------------------------------------------------------------------+
int CElement::CalculateYGap(const int y)
  {
   return((AnchorBottomWindowSide())? m_main.Y2()-y : y-m_main.Y());
  }
//+------------------------------------------------------------------+
//| Рисует фон                                                       |
//+------------------------------------------------------------------+
void CElement::DrawBackground(void)
  {
   m_canvas.Erase(::ColorToARGB(m_back_color,m_alpha));
  }
//+------------------------------------------------------------------+
//| Рисует рамку                                                     |
//+------------------------------------------------------------------+
void CElement::DrawBorder(void)
  {
//--- Координаты
   int x1=0,y1=0;
   int x2=(int)::ObjectGetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_XSIZE)-1;
   int y2=(int)::ObjectGetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_YSIZE)-1;
//--- Рисуем прямоугольник без заливки
   m_canvas.Rectangle(x1,y1,x2,y2,::ColorToARGB(m_border_color,m_alpha));
  }
//+------------------------------------------------------------------+
//| Рисует картинку                                                  |
//+------------------------------------------------------------------+
void CElement::DrawImage(void)
  {
//--- Количество групп
   uint group_total=ImagesGroupTotal();
//--- Рисуем изображения
   for(uint g=0; g<group_total; g++)
     {
      //--- Индекс выбранного изображения
      int i=SelectedImage(g);
      //--- Если нет изображений
      if(i==WRONG_VALUE)
         continue;
      //--- Координаты
      int x =m_images_group[g].m_x_gap;
      int y =m_images_group[g].m_y_gap;
      //--- Размеры
      uint height =m_images_group[g].m_image[i].Height();
      uint width  =m_images_group[g].m_image[i].Width();
      
      //--- Рисуем
      for(uint ly=0,p=0; ly<height; ly++)
        {
         for(uint lx=0; lx<width; lx++, p++)
           {
            //--- Если нет цвета, перейти к следующему пикселю
            if(m_images_group[g].m_image[i].Data(p)<1)
               continue;
            //---
            uint rx =x+lx;
            uint ry =y+ly;
            //--- Получаем цвет нижнего слоя и цвет указанного пикселя картинки
            uint background  =::ColorToARGB(m_canvas.PixelGet(rx,ry));
            uint pixel_color =m_images_group[g].m_image[i].Data(p);
            //--- Смешиваем цвета
            uint foreground=::ColorToARGB(m_clr.BlendColors(background,pixel_color));
            //--- Рисуем пиксель наслаиваемого изображения
            m_canvas.PixelSet(rx,ry,foreground);
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| Рисует текст                                                     |
//+------------------------------------------------------------------+
void CElement::DrawText(void)
  {
//--- Координаты
   int x =m_label_x_gap;
   int y =m_label_y_gap;
//--- Определим цвет для текстовой метки
   color clr=clrBlack;
//--- Если элемент заблокирован
   if(m_is_locked)
      clr=m_label_color_locked;
   else
     {
      //--- Если элемент в отжатом состоянии
      if(!m_is_pressed)
         clr=(m_mouse_focus)? m_label_color_hover : m_label_color;
      else
        {
         if(m_class_name=="CButton")
            clr=m_label_color_pressed;
         else
            clr=(m_mouse_focus)? m_label_color_hover : m_label_color_pressed;
        }
     }
//--- Свойства шрифта
   m_canvas.FontSet(m_font,-m_font_size*10,FW_NORMAL);
//--- Нарисовать текст с учётом режима выравнивания по центру
   if(m_is_center_text)
     {
      x =m_x_size>>1;
      y =m_y_size>>1;
      m_canvas.TextOut(x,y,m_label_text,::ColorToARGB(clr),TA_CENTER|TA_VCENTER);
     }
   else
      m_canvas.TextOut(x,y,m_label_text,::ColorToARGB(clr),TA_LEFT);
  }
//+------------------------------------------------------------------+