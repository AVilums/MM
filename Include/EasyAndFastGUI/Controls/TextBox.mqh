//+------------------------------------------------------------------+
//|                                                      TextBox.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "Scrolls.mqh"
#include "..\Keys.mqh"
#include "..\Element.mqh"
#include "..\TimeCounter.mqh"
#include <Charts\Chart.mqh>
//+------------------------------------------------------------------+
//| Класс для создания многострочного текстового поля                |
//+------------------------------------------------------------------+
class CTextBox : public CElement
  {
private:
   //--- Экземпляр класса для работы с клавиатурой
   CKeys             m_keys;
   //--- Объект для работы со счётчиком таймера
   CTimeCounter      m_counter;
   //--- Объекты для создания элемента
   CRectCanvas       m_textbox;
   CScrollV          m_scrollv;
   CScrollH          m_scrollh;
   //--- Символы и их свойства
   struct StringOptions
     {
      string            m_symbol[];     // Символы
      int               m_width[];      // Ширина символов
      bool              m_end_of_line;  // Признак окончания строки
     };
   StringOptions     m_lines[];
   //--- Общий размер и размер видимой части элемента
   int               m_area_x_size;
   int               m_area_y_size;
   int               m_area_visible_x_size;
   int               m_area_visible_y_size;
   //--- Цвет фона и символов выделенного текста
   color             m_selected_back_color;
   color             m_selected_text_color;
   //--- Начальные и конечные индексы строк и символов (выделенного текста)
   int               m_selected_line_from;
   int               m_selected_line_to;
   int               m_selected_symbol_from;
   int               m_selected_symbol_to;
   //--- Цвет текста по умолчанию
   color             m_default_text_color;
   //--- Текст по умолчанию
   string            m_default_text;
   //--- Переменная для работы со строкой
   string            m_temp_input_string;
   //--- Отступы для текста от краёв поля ввода
   int               m_text_x_offset;
   int               m_text_y_offset;
   //--- Текущие координаты текстового курсора
   int               m_text_cursor_x;
   int               m_text_cursor_y;
   //--- Текущая позиция текстового курсора
   uint              m_text_cursor_x_pos;
   uint              m_text_cursor_y_pos;
   //--- Для расчёта границ видимой части поля ввода
   int               m_x_limit;
   int               m_y_limit;
   int               m_x2_limit;
   int               m_y2_limit;
   //--- Размер шага для смещения по горизонтали
   int               m_shift_x_step;
   //--- Ограничения на смещение
   int               m_shift_x2_limit;
   int               m_shift_y2_limit;
   //--- Многострочный режим
   bool              m_multi_line_mode;
   //--- Режим "Перенос по словам"
   bool              m_word_wrap_mode;
   //--- Режим "Только для чтения"
   bool              m_read_only_mode;
   //--- Режим авто выделения текста
   bool              m_auto_selection_mode;
   //--- Состояние поля ввода
   bool              m_text_edit_state;
   //--- Счётчик таймера для перемотки списка
   int               m_timer_counter;
   //---
public:
                     CTextBox(void);
                    ~CTextBox(void);
   //--- Методы для создания элемента
   bool              CreateTextBox(const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   bool              CreateTextBox(void);
   bool              CreateScrollV(void);
   bool              CreateScrollH(void);
   //---
public:
   //--- Возвращает указатели на полосы прокрутки
   CScrollV         *GetScrollVPointer(void)                   { return(::GetPointer(m_scrollv)); }
   CScrollH         *GetScrollHPointer(void)                   { return(::GetPointer(m_scrollh)); }
   //--- Цвет фона и символов выделенного текста
   void              SelectedBackColor(const color clr)        { m_selected_back_color=clr;       }
   void              SelectedTextColor(const color clr)        { m_selected_text_color=clr;       }
   //--- (1) Текст по умолчанию и (2) цвет текста по умолчанию
   void              DefaultText(const string text)            { m_default_text=text;             }
   void              DefaultTextColor(const color clr)         { m_default_text_color=clr;        }
   //--- (1) Многострочный режим, (2) режим "Перенос по словам"
   void              MultiLineMode(const bool mode)            { m_multi_line_mode=mode;          }
   bool              MultiLineMode(void)                const  { return(m_multi_line_mode);       }
   void              WordWrapMode(const bool mode)             { m_word_wrap_mode=mode;           }
   //--- (1) Режим "Только для чтения", (2) состояние поля ввода, (3) режим для автоматического выделения текста
   bool              ReadOnlyMode(void)                  const { return(m_read_only_mode);        }
   void              ReadOnlyMode(const bool mode)             { m_read_only_mode=mode;           }
   bool              TextEditState(void)                 const { return(m_text_edit_state);       }
   void              AutoSelectionMode(const bool state)       { m_auto_selection_mode=state;     }
   //--- (1) Отступы для текста от краёв поля ввода, (2) режим выравнивания текста
   void              TextXOffset(const int x_offset)           { m_text_x_offset=x_offset;        }
   void              TextYOffset(const int y_offset)           { m_text_y_offset=y_offset;        }
   //--- Возвращает индекс (1) строки, (2) символа, на котором находится текстовый курсор,
   //    (3) количество строк, (4) количество видимых строк
   uint              TextCursorLine(void)                      { return(m_text_cursor_y_pos);     }
   uint              TextCursorColumn(void)                    { return(m_text_cursor_x_pos);     }
   uint              LinesTotal(void)                          { return(::ArraySize(m_lines));    }
   uint              VisibleLinesTotal(void);
   //--- Количество символов в указанной строке
   uint              ColumnsTotal(const uint line_index);
   //--- Информация текстового курсора (строка/количество строк, столбец/количество столбцов)
   string            TextCursorInfo(void);
   //--- Добавляет строку 
   void              AddLine(const string added_text="");
   //--- Добавляет текст в указанную строку 
   void              AddText(const uint line_index,const string added_text);
   //--- Возвращает текст из указанной строки
   string            GetValue(const uint line_index=0);
   //--- Очищает текстовое поле ввода
   void              ClearTextBox(void);
   //--- Прокрутка таблицы: (1) вертикальная и (2) горизонтальная
   void              VerticalScrolling(const int pos=WRONG_VALUE);
   void              HorizontalScrolling(const int pos=WRONG_VALUE);
   //--- Смещение данных относительно позиций полос прокрутки
   void              ShiftData(void);
   //--- Корректировка размеров поля ввода
   void              CorrectSize(void);
   //--- Активация поля ввода
   void              ActivateTextBox(void);
   //--- Дезактивирует поле ввода
   void              DeactivateTextBox(void);
   //--- Изменение размеров
   void              ChangeSize(const uint x_size,const uint y_size);
   //---
public:
   //--- Обработчик событий графика
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Таймер
   virtual void      OnEventTimer(void);
   //--- Перемещение элемента
   virtual void      Moving(const bool only_visible=true);
   //--- Управление
   virtual void      Show(void);
   virtual void      Hide(void);
   virtual void      Delete(void);
   //--- (1) Установка, (2) сброс приоритетов на нажатие левой кнопки мыши
   virtual void      SetZorders(void);
   virtual void      ResetZorders(void);
   //--- Рисует элемент
   virtual void      Draw(void);
   //--- Обновление элемента
   virtual void      Update(const bool redraw=false);
   //---
private:
   //--- Обработка нажатия на элемент
   bool              OnClickTextBox(const string clicked_object);

   //--- Обработка нажатия на клавише
   bool              OnPressedKey(const long key_code);
   //--- Обработка нажатия на клавише "Backspace"
   bool              OnPressedKeyBackspace(const long key_code);
   //--- Обработка нажатия на клавише "Enter"
   bool              OnPressedKeyEnter(const long key_code);
   //--- Обработка нажатия на клавише "Left"
   bool              OnPressedKeyLeft(const long key_code);
   //--- Обработка нажатия на клавише "Right"
   bool              OnPressedKeyRight(const long key_code);
   //--- Обработка нажатия на клавише "Up"
   bool              OnPressedKeyUp(const long key_code);
   //--- Обработка нажатия на клавише "Down"
   bool              OnPressedKeyDown(const long key_code);
   //--- Обработка нажатия на клавише "Home"
   bool              OnPressedKeyHome(const long key_code);
   //--- Обработка нажатия на клавише "End"
   bool              OnPressedKeyEnd(const long key_code);

   //--- Обработка нажатия на клавише Ctrl + Left
   bool              OnPressedKeyCtrlAndLeft(const long key_code);
   //--- Обработка нажатия на клавише Ctrl + Right
   bool              OnPressedKeyCtrlAndRight(const long key_code);
   //--- Обработка одновременного нажатия клавиш Ctrl + Home
   bool              OnPressedKeyCtrlAndHome(const long key_code);
   //--- Обработка одновременного нажатия клавиш Ctrl + End
   bool              OnPressedKeyCtrlAndEnd(const long key_code);

   //--- Обработка нажатия на клавише Shift + Left
   bool              OnPressedKeyShiftAndLeft(const long key_code);
   //--- Обработка нажатия на клавише Shift + Right
   bool              OnPressedKeyShiftAndRight(const long key_code);
   //--- Обработка нажатия на клавише Shift + Up
   bool              OnPressedKeyShiftAndUp(const long key_code);
   //--- Обработка нажатия на клавише Shift + Down
   bool              OnPressedKeyShiftAndDown(const long key_code);
   //--- Обработка нажатия на клавише Shift + Home
   bool              OnPressedKeyShiftAndHome(const long key_code);
   //--- Обработка нажатия на клавише Shift + End
   bool              OnPressedKeyShiftAndEnd(const long key_code);

   //--- Обработка нажатия на клавише Ctrl + Shift + Left
   bool              OnPressedKeyCtrlShiftAndLeft(const long key_code);
   //--- Обработка нажатия на клавише Ctrl + Shift + Right
   bool              OnPressedKeyCtrlShiftAndRight(const long key_code);
   //--- Обработка нажатия на клавише Ctrl + Shift + Home
   bool              OnPressedKeyCtrlShiftAndHome(const long key_code);
   //--- Обработка нажатия на клавише Ctrl + Shift + End
   bool              OnPressedKeyCtrlShiftAndEnd(const long key_code);
   //---
private:
   //--- Устанавливает (1) начальные и (2) конечные индексы для выделения текста
   void              SetStartSelectedTextIndexes(void);
   void              SetEndSelectedTextIndexes(void);
   //--- Выделить весь текст
   void              SelectAllText(void);
   //--- Сбросить выделенный текст
   void              ResetSelectedText(void);
   //--- Ускоренная перемотка поля ввода
   void              FastSwitching(void);

   //--- Вывод текста на холст
   void              TextOut(void);
   //--- Рисует рамку
   virtual void      DrawBorder(void);
   //--- Рисует текстовый курсор
   void              DrawCursor(void);
   //--- Отображает текст и мигающий курсор
   void              DrawTextAndCursor(const bool show_state=false);

   //--- Возвращает текущий цвет фона
   uint              AreaColorCurrent(void);
   //--- Возвращает текущий цвет текста
   uint              TextColorCurrent(void);
   //--- Возвращает текущий цвет рамки
   uint              BorderColorCurrent(void);
   //--- Изменение цвета объектов
   void              ChangeObjectsColor(void);

   //--- Собирает строку из символов
   string            CollectString(const uint line_index,const uint symbols_total=0);
   //--- Добавляет символ и его свойства в массивы структуры
   void              AddSymbol(const string key_symbol);
   //--- Удаляет символ
   void              DeleteSymbol(void);
   //--- Удаляет (1) выделенный текст, (2) на одной строке, (3) на нескольких строках
   bool              DeleteSelectedText(void);
   void              DeleteTextOnOneLine(void);
   void              DeleteTextOnMultipleLines(void);

   //--- Возвращает высоту строки
   uint              LineHeight(void);
   //--- Возвращает ширину строки от указанного символа в пикселях
   uint              LineWidth(const uint symbol_index,const uint line_index);
   //--- Возвращает максимальную ширину строки
   uint              MaxLineWidth(void);

   //--- Смещает строки на одну позицию вверх
   void              ShiftOnePositionUp(void);
   //--- Смещает строки на одну позицию вниз
   void              ShiftOnePositionDown(void);

   //--- Проверка наличия выделенного текста
   bool              CheckSelectedText(const uint line_index,const uint symbol_index);
   //--- Проверка на наличие обязательной первой строки
   uint              CheckFirstLine(void);

   //--- Устанавливает новый размер массивам свойств указанной строки
   void              ArraysResize(const uint line_index,const uint new_size);
   //--- Делает копию указанной (source) строки в новое место (destination)
   void              LineCopy(const uint destination,const uint source);
   //--- Очищает указанную строку
   void              ClearLine(const uint line_index);

   //--- Перемещение текстового курсора в указанном направлении
   void              MoveTextCursor(const ENUM_MOVE_TEXT_CURSOR direction);
   void              MoveTextCursor(const ENUM_MOVE_TEXT_CURSOR direction,const bool with_highlighted_text);
   //--- Перемещение текстового курсора влево
   void              MoveTextCursorToLeft(const bool to_next_word=false);
   //--- Перемещение текстового курсора вправо
   void              MoveTextCursorToRight(const bool to_next_word=false);
   //--- Перемещение текстового курсора на одну строку вверх
   void              MoveTextCursorToUp(void);
   //--- Перемещение текстового курсора на одну строку вниз
   void              MoveTextCursorToDown(void);

   //--- Устанавливает курсор по указанным позициям
   void              SetTextCursor(const uint x_pos,const uint y_pos);
   //--- Устанавливает курсор по указанным позициям по курсору мыши
   void              SetTextCursorByMouseCursor(void);
   //--- Корректировка текстового курсора по оси X
   void              CorrectingTextCursorXPos(const int x_pos=WRONG_VALUE);

   //--- Расчёт координат для текстового курсора
   void              CalculateTextCursorX(void);
   void              CalculateTextCursorY(void);

   //--- Расчёт границ поля ввода
   void              CalculateBoundaries(void);
   void              CalculateXBoundaries(void);
   void              CalculateYBoundaries(void);
   //--- Расчёт X-позиции ползунка полосы прокрутки в левой границе поля ввода
   int               CalculateScrollThumbX(void);
   //--- Расчёт X-позиции ползунка полосы прокрутки в правой границе поля ввода
   int               CalculateScrollThumbX2(void);
   //--- Расчёт X-позиции ползунка полосы прокрутки
   int               CalculateScrollPosX(const bool to_right=false);
   //--- Расчёт Y-позиции ползунка полосы прокрутки в верхней границе поля ввода
   int               CalculateScrollThumbY(void);
   //--- Расчёт Y-позиции ползунка полосы прокрутки в нижней границе поля ввода
   int               CalculateScrollThumbY2(void);
   //--- Расчёт Y-позиции ползунка полосы прокрутки
   int               CalculateScrollPosY(const bool to_down=false);
   //--- Корректировка горизонтальной полосы прокрутки
   void              CorrectingHorizontalScrollThumb(void);
   //--- Корректировка вертикальной полосы прокрутки
   void              CorrectingVerticalScrollThumb(void);

   //--- Рассчитывает размеры текстого поля ввода
   void              CalculateTextBoxSize(void);
   bool              CalculateTextBoxXSize(void);
   bool              CalculateTextBoxYSize(void);
   //--- Изменить основные размеры элемента
   void              ChangeMainSize(const int x_size,const int y_size);
   //--- Изменить размеры поля ввода
   void              ChangeTextBoxSize(const bool x_offset=false,const bool y_offset=false);
   //--- Изменить размеры полос прокрутки
   void              ChangeScrollsSize(void);

   //--- Перенос по словам
   void              WordWrap(void);
   //--- Возвращает индексы первых видимых символа и пробела
   bool              CheckForOverflow(const uint line_index,int &symbol_index,int &space_index);
   //--- Количество слов в указанной строке
   uint              WordsTotal(const uint line_index);
   //--- Возвращает количество переносимых символов
   bool              WrapSymbolsTotal(const uint line_index,uint &wrap_symbols_total);
   //--- Возвращает индекс символа пробела по его номеру 
   uint              SymbolIndexBySpaceNumber(const uint line_index,const uint space_index);
   //--- Перемещает строки
   void              MoveLines(const uint from_index,const uint to_index,const uint count,const bool to_down=true);
   //--- Перемещение символов в указанной строке
   void              MoveSymbols(const uint line_index,const uint from_pos,const uint to_pos,const bool to_left=true);
   //--- Добавление текста в указанную строку
   void              AddToString(const uint line_index,const string text);
   //--- Копирует в переданный массив символы для переноса на другую строку
   void              CopyWrapSymbols(const uint line_index,const uint start_pos,const uint symbols_total,string &array[]);
   //--- Вставляет символы из переданного массива в указанную строку
   void              PasteWrapSymbols(const uint line_index,const uint start_pos,string &array[]);
   //--- Перенос текста на следующую строку
   void              WrapTextToNewLine(const uint curr_line_index,const uint symbol_index,const bool by_pressed_enter=false);
   //--- Перенос текста из указанной строки в предыдущую
   void              WrapTextToPrevLine(const uint next_line_index,const uint wrap_symbols_total,const bool is_all_text=false);

   //--- Изменить ширину по правому краю окна
   virtual void      ChangeWidthByRightWindowSide(void);
   //--- Изменить высоту по нижнему краю окна
   virtual void      ChangeHeightByBottomWindowSide(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTextBox::CTextBox(void) : m_selected_text_color(clrWhite),
                           m_selected_back_color(C'51,153,255'),
                           m_selected_line_from(WRONG_VALUE),
                           m_selected_line_to(WRONG_VALUE),
                           m_selected_symbol_from(WRONG_VALUE),
                           m_selected_symbol_to(WRONG_VALUE),
                           m_default_text_color(clrTomato),
                           m_default_text(""),
                           m_temp_input_string(""),
                           m_text_x_offset(5),
                           m_text_y_offset(4),
                           m_multi_line_mode(false),
                           m_word_wrap_mode(false),
                           m_read_only_mode(false),
                           m_auto_selection_mode(false),
                           m_text_edit_state(false),
                           m_text_cursor_x_pos(0),
                           m_text_cursor_y_pos(0),
                           m_shift_x_step(10),
                           m_shift_x2_limit(0),
                           m_shift_y2_limit(0)
  {
//--- Сохраним имя класса элемента в базовом классе
   CElementBase::ClassName(CLASS_NAME);
//--- Исходные координаты текстового курсора
   m_text_cursor_x=m_text_x_offset;
   m_text_cursor_y=m_text_y_offset;
//--- Установка параметров для счётчика таймера
   m_counter.SetParameters(16,200);
//--- Обязательная первая строка многострочного поля ввода
   ::ArrayResize(m_lines,1);
//--- Установим признак окончания строки
   m_lines[0].m_end_of_line=true;
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CTextBox::~CTextBox(void)
  {
  }
//+------------------------------------------------------------------+
//| Обработчик событий графика                                       |
//+------------------------------------------------------------------+
void CTextBox::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Обработка события перемещения курсора
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Проверка статуса полос прокрутки
      bool is_scroll_state=m_scrollv.ScrollBarControl() || ((m_multi_line_mode)? m_scrollh.ScrollBarControl() : false);
      //---
      if(m_text_edit_state)
        {
         //--- Если (1) не в фокусе и (2) левая кнопка мыши нажата и (3) не в режиме перемещения полос прокрутки
         if(!CElementBase::MouseFocus() && m_mouse.LeftButtonState() && !is_scroll_state)
           {
            //--- Отправим сообщение об окончании ввода строки в поле ввода, если поле было активно
            string str=(m_multi_line_mode)? TextCursorInfo() : "";
            ::EventChartCustom(m_chart_id,ON_END_EDIT,CElementBase::Id(),CElementBase::Index(),str);
            //--- Дезактивируем поле ввода
            DeactivateTextBox();
            //--- Обновить
            Update(true);
           }
        }
      //--- Изменение цвета объектов
      ChangeObjectsColor();
      //--- Выйти, если многострочный режим отключен
      if(!m_multi_line_mode)
         return;
      //--- Если полоса прокрутки в действии
      if(is_scroll_state)
        {
         //--- Сдвинуть данные относительно полос прокрутки
         ShiftData();
         //--- Дезактивируем поле ввода
         DeactivateTextBox();
         //--- Обновить
         Update(true);
         //--- Обновить полосу прокрутки в действии
         if(m_scrollh.State()) m_scrollh.Update(true);
         if(m_scrollv.State()) m_scrollv.Update(true);
        }
      //--- Если одна из кнопок полос прокрутки нажата
      if(m_mouse.LeftButtonState() && 
         (m_scrollv.ScrollIncState() || m_scrollv.ScrollDecState() || 
         m_scrollh.ScrollIncState() || m_scrollh.ScrollDecState()))
        {
         //--- Дезактивируем поле ввода
         DeactivateTextBox();
         //--- Обновить
         Update(true);
        }
      //---
      return;
     }
//--- Обработка события нажатия левой кнопки мыши на объекте
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      //--- Нажатие на поле ввода
      if(OnClickTextBox(sparam))
         return;
      //---
      return;
     }
//--- Обработка события нажатия на кнопках полосы прокрутки
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)
     {
      //--- Если было нажатие на кнопках полосы прокрутки списка
      if(m_scrollv.OnClickScrollInc((uint)lparam,(uint)dparam) ||
         m_scrollv.OnClickScrollDec((uint)lparam,(uint)dparam))
        {
         //--- Сдвигает данные
         ShiftData();
         m_scrollv.Update(true);
         return;
        }
      //--- Если было нажатие на кнопках полосы прокрутки списка
      if(m_scrollh.OnClickScrollInc((uint)lparam,(uint)dparam) ||
         m_scrollh.OnClickScrollDec((uint)lparam,(uint)dparam))
        {
         //--- Сдвигает данные
         ShiftData();
         m_scrollh.Update(true);
         return;
        }
     }
//--- Обработка нажатия кнопки на клавиатуре
   if(id==CHARTEVENT_KEYDOWN)
     {
      //--- Выйти, если поле ввода не активировано
      if(!m_text_edit_state)
         return;
      //--- Нажатие на символьной клавише
      if(OnPressedKey(lparam))
         return;
      //--- Нажатие на клавише "Backspace"
      if(OnPressedKeyBackspace(lparam))
         return;
      //--- Нажатие на клавише "Enter"
      if(OnPressedKeyEnter(lparam))
         return;
      //--- Нажатие на клавише "Left"
      if(OnPressedKeyLeft(lparam))
         return;
      //--- Нажатие на клавише "Right"
      if(OnPressedKeyRight(lparam))
         return;
      //--- Нажатие на клавише "Up"
      if(OnPressedKeyUp(lparam))
         return;
      //--- Нажатие на клавише "Down"
      if(OnPressedKeyDown(lparam))
         return;
      //--- Нажатие на клавише "Home"
      if(OnPressedKeyHome(lparam))
         return;
      //--- Нажатие на клавише "End"
      if(OnPressedKeyEnd(lparam))
         return;
      //--- Одновременное нажатие клавиш Ctrl + Left
      if(OnPressedKeyCtrlAndLeft(lparam))
         return;
      //--- Одновременное нажатие клавиш Ctrl + Right
      if(OnPressedKeyCtrlAndRight(lparam))
         return;
      //--- Одновременное нажатие клавиш Ctrl + Home
      if(OnPressedKeyCtrlAndHome(lparam))
         return;
      //--- Одновременное нажатие клавиш Ctrl + End
      if(OnPressedKeyCtrlAndEnd(lparam))
         return;
      //--- Одновременное нажатие клавиш Shift + Left
      if(OnPressedKeyShiftAndLeft(lparam))
         return;
      //--- Одновременное нажатие клавиш Shift + Right
      if(OnPressedKeyShiftAndRight(lparam))
         return;
      //--- Одновременное нажатие клавиш Shift + Up
      if(OnPressedKeyShiftAndUp(lparam))
         return;
      //--- Одновременное нажатие клавиш Shift + Down
      if(OnPressedKeyShiftAndDown(lparam))
         return;
      //--- Одновременное нажатие клавиш Shift + Home
      if(OnPressedKeyShiftAndHome(lparam))
         return;
      //--- Одновременное нажатие клавиш Shift + End
      if(OnPressedKeyShiftAndEnd(lparam))
         return;
      //--- Одновременное нажатие клавиш Ctrl + Shift + Left
      if(OnPressedKeyCtrlShiftAndLeft(lparam))
         return;
      //--- Одновременное нажатие клавиш Ctrl + Shift + Right
      if(OnPressedKeyCtrlShiftAndRight(lparam))
         return;
      //--- Одновременное нажатие клавиш Ctrl + Shift + Home
      if(OnPressedKeyCtrlShiftAndHome(lparam))
         return;
      //--- Одновременное нажатие клавиш Ctrl + Shift + End
      if(OnPressedKeyCtrlShiftAndEnd(lparam))
         return;
      //---
      return;
     }
  }
//+------------------------------------------------------------------+
//| Таймер                                                           |
//+------------------------------------------------------------------+
void CTextBox::OnEventTimer(void)
  {
//--- Ускоренная перемотка значений
   FastSwitching();
//--- Пауза между обновлением текстового курсора
   if(m_counter.CheckTimeCounter())
     {
      //--- Обновим текстовый курсор, если элемент видим и поле ввода активировано
      if(CElementBase::IsVisible() && m_text_edit_state)
         DrawTextAndCursor();
     }
  }
//+------------------------------------------------------------------+
//| Создаёт элемент "Текстовое поле ввода"                           |
//+------------------------------------------------------------------+
bool CTextBox::CreateTextBox(const int x_gap,const int y_gap)
  {
//--- Выйти, если нет указателя на главный элемент
   if(!CElement::CheckMainPointer())
      return(false);
//--- Инициализация свойств
   InitializeProperties(x_gap,y_gap);
//--- Рассчитаем размеры текстового поля ввода
   CalculateTextBoxSize();
//--- Создание элемента
   if(!CreateCanvas())
      return(false);
   if(!CreateTextBox())
      return(false);
   if(!CreateScrollV())
      return(false);
   if(!CreateScrollH())
      return(false);
//--- Изменить размеры текстового поля ввода
   ChangeTextBoxSize();
//--- В режиме переноса слов нужно повторно пересчитать и установить размеры
   if(m_word_wrap_mode)
     {
      CalculateTextBoxSize();
      ChangeTextBoxSize();
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Инициализация свойств                                            |
//+------------------------------------------------------------------+
void CTextBox::InitializeProperties(const int x_gap,const int y_gap)
  {
   m_x        =CElement::CalculateX(x_gap);
   m_y        =CElement::CalculateY(y_gap);
   m_x_size   =(m_x_size<0 || m_auto_xresize_mode)? m_main.X2()-CElementBase::X()-m_auto_xresize_right_offset : m_x_size;
   m_y_size   =(m_y_size<0 || m_auto_yresize_mode)? m_main.Y2()-CElementBase::Y()-m_auto_yresize_bottom_offset : m_y_size;
//--- Цвета по умолчанию
   m_back_color           =(m_back_color!=clrNONE)? m_back_color : clrWhite;
   m_back_color_locked    =(m_back_color_locked!=clrNONE)? m_back_color_locked : clrWhiteSmoke;
   m_border_color         =(m_border_color!=clrNONE)? m_border_color : clrGray;
   m_border_color_hover   =(m_border_color_hover!=clrNONE)? m_border_color_hover : clrBlack;
   m_border_color_locked  =(m_border_color_locked!=clrNONE)? m_border_color_locked : clrSilver;
   m_border_color_pressed =(m_border_color_pressed!=clrNONE)? m_border_color_pressed : clrCornflowerBlue;
   m_label_color          =(m_label_color!=clrNONE)? m_label_color : clrBlack;
   m_label_color_locked   =(m_label_color_locked!=clrNONE)? m_label_color_locked : clrSilver;
//--- Отступы от крайней точки
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
  }
//+------------------------------------------------------------------+
//| Создаёт холст для рисования фона                                 |
//+------------------------------------------------------------------+
bool CTextBox::CreateCanvas(void)
  {
//--- Формирование имени объекта
   string name=CElementBase::ElementName("textbox");
//--- Создание объекта
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//--- Проверка на наличие обязательной первой строки
   CheckFirstLine();
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт холст для рисования поля ввода                           |
//+------------------------------------------------------------------+
bool CTextBox::CreateTextBox(void)
  {
//--- Формирование имени объекта
   string name="";
   if(m_index==WRONG_VALUE)
      name=m_program_name+"_"+"textbox_edit"+"_"+(string)m_id;
   else
      name=m_program_name+"_"+"textbox_edit"+"_"+(string)m_index+"__"+(string)m_id;
//--- Координаты
   int x =m_x+1;
   int y =m_y+1;
//--- Размер
   int x_size =m_area_x_size-2;
   int y_size =m_area_y_size-2;
//--- Создание объекта
   ::ResetLastError();
   if(!m_textbox.CreateBitmapLabel(m_chart_id,m_subwin,name,x,y,x_size,y_size,COLOR_FORMAT_ARGB_NORMALIZE))
     {
      ::Print(__FUNCTION__," > Не удалось создать холст для рисования поля ввода: ",::GetLastError());
      return(false);
     }
//--- Получим указатель на базовый класс
   if(!m_textbox.Attach(m_chart_id,name,COLOR_FORMAT_ARGB_NORMALIZE))
     {
      ::Print(__FUNCTION__," > Не удалось присоединить холст для рисования к графику: ",::GetLastError());
      return(false);
     }
//--- Свойства
   ::ObjectSetInteger(m_chart_id,m_textbox.ChartObjectName(),OBJPROP_ZORDER,m_zorder+1);
   ::ObjectSetString(m_chart_id,m_textbox.ChartObjectName(),OBJPROP_TOOLTIP,"\n");
//--- Координаты
   m_textbox.X(x);
   m_textbox.Y(y);
//--- Отступы от крайней точки панели
   m_textbox.XGap(CElement::CalculateXGap(x));
   m_textbox.YGap(CElement::CalculateYGap(y));
//--- Установим размеры видимой области
   ::ObjectSetInteger(m_chart_id,m_textbox.ChartObjectName(),OBJPROP_XSIZE,m_area_visible_x_size);
   ::ObjectSetInteger(m_chart_id,m_textbox.ChartObjectName(),OBJPROP_YSIZE,m_area_visible_y_size);
//--- Зададим смещение фрейма внутри изображения по осям X и Y
   ::ObjectSetInteger(m_chart_id,m_textbox.ChartObjectName(),OBJPROP_XOFFSET,0);
   ::ObjectSetInteger(m_chart_id,m_textbox.ChartObjectName(),OBJPROP_YOFFSET,0);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт вертикальный скролл                                      |
//+------------------------------------------------------------------+
bool CTextBox::CreateScrollV(void)
  {
//--- Сохранить указатель родительского элемента
   m_scrollv.MainPointer(this);
//--- Если отключен многострочный режим
   if(!m_multi_line_mode)
     {
      //--- Инициализация вертикальной полосы прокрутки
      m_scrollv.Reinit(m_area_y_size,m_area_visible_y_size);
      //--- Сохранить указатель родительского элемента
      m_scrollv.GetIncButtonPointer().MainPointer(m_scrollv);
      m_scrollv.GetDecButtonPointer().MainPointer(m_scrollv);
      return(true);
     }
//--- Координаты
   int x =m_scrollv.ScrollWidth()+1;
   int y =1;
//--- Установим свойства
   m_scrollv.Index(0);
   m_scrollv.IsDropdown(CElementBase::IsDropdown());
   m_scrollv.XSize(m_scrollv.ScrollWidth());
   m_scrollv.YSize(m_y_size-m_scrollv.ScrollWidth()-1);
   m_scrollv.AnchorRightWindowSide(true);
//--- Расчёт количества шагов для смещения
   uint lines_total         =LinesTotal()+1;
   uint visible_lines_total =VisibleLinesTotal();
//--- Создание полосы прокрутки
   if(!m_scrollv.CreateScroll(x,y,lines_total,visible_lines_total))
      return(false);
//--- Добавить элемент в массив
   CElement::AddToArray(m_scrollv);
   return(true);
  }
//+------------------------------------------------------------------+
//| Создаёт горизонтальный скролл                                    |
//+------------------------------------------------------------------+
bool CTextBox::CreateScrollH(void)
  {
//--- Сохранить указатель родительского элемента
   m_scrollh.MainPointer(this);
//--- Если отключен многострочный режим
   if(!m_multi_line_mode)
     {
      //--- Инициализация горизонтальной полосы прокрутки
      m_scrollh.Reinit(m_area_x_size,m_area_visible_x_size);
      //--- Сохранить указатель главного элемента
      m_scrollh.GetIncButtonPointer().MainPointer(m_scrollh);
      m_scrollh.GetDecButtonPointer().MainPointer(m_scrollh);
      return(true);
     }
//--- Координаты
   int x =1;
   int y =m_scrollh.ScrollWidth()+1;
//--- Установим свойства
   m_scrollh.Index(1);
   m_scrollh.IsDropdown(CElementBase::IsDropdown());
   m_scrollh.XSize(CElementBase::XSize()-m_scrollv.ScrollWidth()-1);
   m_scrollh.YSize(m_scrollv.ScrollWidth());
   m_scrollh.AnchorBottomWindowSide(true);
//--- Расчёт количества шагов для смещения
   uint x_size_total         =m_area_x_size/m_shift_x_step;
   uint visible_x_size_total =m_area_visible_x_size/m_shift_x_step;
//--- Создание полосы прокрутки
   if(!m_scrollh.CreateScroll(x,y,x_size_total,visible_x_size_total))
      return(false);
//--- Добавить элемент в массив
   CElement::AddToArray(m_scrollh);
   return(true);
  }
//+------------------------------------------------------------------+
//| Возвращает количество видимых строк                              |
//+------------------------------------------------------------------+
uint CTextBox::VisibleLinesTotal(void)
  {
   return((m_area_visible_y_size-(m_text_y_offset*2))/LineHeight());
  }
//+------------------------------------------------------------------+
//| Возвращает количество символов в указанной строке                |
//+------------------------------------------------------------------+
uint CTextBox::ColumnsTotal(const uint line_index)
  {
//--- Получим размер массива строк
   uint lines_total=::ArraySize(m_lines);
//--- Предотвращение выхода из диапазона
   uint check_index=(line_index<lines_total)? line_index : lines_total-1;
//--- Получим размер массива символов в строке
   uint symbols_total=::ArraySize(m_lines[check_index].m_symbol);
//--- Вернуть количество символов
   return(symbols_total);
  }
//+------------------------------------------------------------------+
//| Информация текстового курсора                                    |
//+------------------------------------------------------------------+
string CTextBox::TextCursorInfo(void)
  {
//--- Компоненты для строки
   string lines_total        =(string)LinesTotal();
   string columns_total      =(string)ColumnsTotal(TextCursorLine());
   string text_cursor_line   =string(TextCursorLine()+1);
   string text_cursor_column =string(TextCursorColumn()+1);
//--- Сформируем строку
   string text_box_info="Ln "+text_cursor_line+"/"+lines_total+", "+"Col "+text_cursor_column+"/"+columns_total;
//--- Вернуть строку
   return(text_box_info);
  }
//+------------------------------------------------------------------+
//| Добавляет строку                                                 |
//+------------------------------------------------------------------+
void CTextBox::AddLine(const string added_text="")
  {
//--- Выйти, если отключен многострочный режим
   if(!m_multi_line_mode)
      return;
//--- Получим размер массива строк
   uint lines_total=::ArraySize(m_lines);
//--- Резервный размер массива
   int reserve_size=10000;
//--- Устанавливаем размер массивам структуры
   ::ArrayResize(m_lines,lines_total+1,reserve_size);
//--- Установим признак окончания строки
   m_lines[lines_total].m_end_of_line=true;
//--- Установим шрифт
   m_textbox.FontSet(CElement::Font(),-CElement::FontSize()*10,FW_NORMAL);
//--- Добавим текст в строку
   AddToString(lines_total,added_text);
//--- Выйти, если у составного элемента указатель на главный элемент невалиден
   if(::CheckPointer(m_scrollh.MainPointer())==POINTER_INVALID)
      return;
//--- Рассчитать размеры поля ввода
   CalculateTextBoxSize();
//--- Установить новый размер полю ввода
   ChangeTextBoxSize();
//--- В режиме переноса слов нужно повторно пересчитать и установить размеры
   if(m_word_wrap_mode)
     {
      CalculateTextBoxSize();
      ChangeTextBoxSize();
     }
//--- Перерисовать полосы прокрутки
   //if(m_scrollh.IsScroll())
   //   m_scrollh.Update(true);
   //if(m_scrollv.IsScroll())
   //   m_scrollv.Update(true);
  }
//+------------------------------------------------------------------+
//| Добавляет текст в указанную строку                               |
//+------------------------------------------------------------------+
void CTextBox::AddText(const uint line_index,const string added_text)
  {
//--- Выйти, если передана пустая строка
   if(added_text=="")
      return;
//--- Получим размер массива строк, с проверкой на наличие обязательной первой строки
   uint lines_total=CheckFirstLine();
//--- Предотвращение выхода из диапазона
   uint l=(line_index<lines_total)? line_index : lines_total-1;
//--- Корректировка индекса с учётом режима переноса по словам
   if(m_word_wrap_mode)
     {
      for(uint i=0,j=0; i<lines_total; i++)
        {
         //--- Считаем строки по признаку окончания
         if(m_lines[i].m_end_of_line)
           {
            //---
            if(l==j || i+1>=lines_total)
              {
               l=i;
               break;
              }
            //---
            j++;
           }
        }
     }
//--- Установим шрифт
   m_textbox.FontSet(CElement::Font(),-CElement::FontSize()*10,FW_NORMAL);
//--- Добавим текст в строку
   AddToString(l,added_text);
  }
//+------------------------------------------------------------------+
//| Возвращает текст из указанной строки                             |
//+------------------------------------------------------------------+
string CTextBox::GetValue(const uint line_index=0)
  {
//--- Получим размер массива строк, с проверкой на наличие обязательной первой строки
   uint lines_total=CheckFirstLine();
//--- Предотвращение выхода из диапазона
   uint l=(line_index<lines_total)? line_index : lines_total-1;
//--- Вернуть текст
   return(CollectString(l));
  }
//+------------------------------------------------------------------+
//| Очищает текстовое поле ввода                                     |
//+------------------------------------------------------------------+
void CTextBox::ClearTextBox(void)
  {
//--- Удаляем все строки кроме первой
   ::ArrayResize(m_lines,1);
//--- Очищаем первую строку
   ClearLine(0);
  }
//+------------------------------------------------------------------+
//| Горизонтальная прокрутка поля ввода                              |
//+------------------------------------------------------------------+
void CTextBox::HorizontalScrolling(const int pos=WRONG_VALUE)
  {
//--- Для определения позиции ползунка
   int index=0;
//--- Индекс последней позиции
   int last_pos_index=int(m_area_x_size-m_area_visible_x_size);
//--- Корректировка в случае выхода из диапазона
   if(pos<0)
      index=last_pos_index;
   else
      index=(pos>last_pos_index)? last_pos_index : pos;
//--- Сдвигаем ползунок полосы прокрутки
   m_scrollh.MovingThumb(index);
//--- Сдвигаем поле ввода
   ShiftData();
//--- Обновить полосу прокрутки
   m_scrollh.Update();
  }
//+------------------------------------------------------------------+
//| Вертикальная прокрутка поля ввода                                |
//+------------------------------------------------------------------+
void CTextBox::VerticalScrolling(const int pos=WRONG_VALUE)
  {
//--- Для определения позиции ползунка
   int index=0;
//--- Индекс последней позиции
   int last_pos_index=int((m_area_y_size-m_area_visible_y_size)/(double)LineHeight());
//--- Корректировка в случае выхода из диапазона
   if(pos<0)
      index=last_pos_index;
   else
      index=(pos>last_pos_index)? last_pos_index : pos;
//--- Сдвигаем ползунок полосы прокрутки
   m_scrollv.MovingThumb(index);
//--- Сдвигаем поле ввода
   ShiftData();
//--- Обновить полосу прокрутки
   m_scrollv.Update(true);
  }
//+------------------------------------------------------------------+
//| Сдвигает данные относительно полос прокрутки                     |
//+------------------------------------------------------------------+
void CTextBox::ShiftData(void)
  {
//--- Получим текущие позиции ползунков горизонтальной и вертикальной полос прокрутки
   int h_offset =m_scrollh.CurrentPos()*m_shift_x_step;
   int v_offset =m_text_y_offset+(m_scrollv.CurrentPos()*(int)LineHeight())-2;
//--- Рассчитаем отступы для смещения
   int x_offset =(h_offset<1)? 0 : (h_offset>=m_shift_x2_limit)? m_shift_x2_limit : h_offset;
   int y_offset =(v_offset<1)? 0 : (v_offset>=m_shift_y2_limit)? m_shift_y2_limit : v_offset;
//--- Расчёт положения данных относительно ползунков полос прокрутки
   long x =(m_area_x_size>m_area_visible_x_size && !m_word_wrap_mode)? x_offset : 0;
   long y =(m_area_y_size>m_area_visible_y_size)? y_offset : 0;
//--- Смещение данных
   ::ObjectSetInteger(m_chart_id,m_textbox.ChartObjectName(),OBJPROP_XOFFSET,x);
   ::ObjectSetInteger(m_chart_id,m_textbox.ChartObjectName(),OBJPROP_YOFFSET,y);
  }
//+------------------------------------------------------------------+
//| Корректировка размеров поля ввода                                |
//+------------------------------------------------------------------+
void CTextBox::CorrectSize(void)
  {
//--- Рассчитать размеры поля ввода
   CalculateTextBoxSize();
//--- Установить новый размер полю ввода
   ChangeTextBoxSize(true,true);
  }
//+------------------------------------------------------------------+
//| Активация поля ввода                                             |
//+------------------------------------------------------------------+
void CTextBox::ActivateTextBox(void)
  {
   OnClickTextBox(m_textbox.ChartObjectName());
  }
//+------------------------------------------------------------------+
//| Изменение размеров                                               |
//+------------------------------------------------------------------+
void CTextBox::ChangeSize(const uint x_size,const uint y_size)
  {
//--- Установить новый размер
   ChangeMainSize(x_size,y_size);
//--- Рассчитать размеры поля ввода
   CalculateTextBoxSize();
//--- Установить новый размер полю ввода
   ChangeTextBoxSize();
  }
//+------------------------------------------------------------------+
//| Перемещение элемента                                             |
//+------------------------------------------------------------------+
void CTextBox::Moving(const bool only_visible=true)
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
      m_textbox.X(m_main.X2()-m_textbox.XGap());
     }
   else
     {
      CElementBase::X(m_main.X()+XGap());
      m_textbox.X(m_main.X()+m_textbox.XGap());
     }
//--- Если привязка снизу
   if(m_anchor_bottom_window_side)
     {
      CElementBase::Y(m_main.Y2()-YGap());
      m_textbox.Y(m_main.Y2()-m_textbox.YGap());
     }
   else
     {
      CElementBase::Y(m_main.Y()+YGap());
      m_textbox.Y(m_main.Y()+m_textbox.YGap());
     }
//--- Обновление координат
   ::ObjectSetInteger(m_chart_id,m_textbox.ChartObjectName(),OBJPROP_XDISTANCE,m_textbox.X());
   ::ObjectSetInteger(m_chart_id,m_textbox.ChartObjectName(),OBJPROP_YDISTANCE,m_textbox.Y());
//--- Обновить положение объектов
   CElement::Moving(only_visible);
  }
//+------------------------------------------------------------------+
//| Показывает элемент                                               |
//+------------------------------------------------------------------+
void CTextBox::Show(void)
  {
//--- Выйти, если элемент уже видим
   if(CElementBase::IsVisible())
      return;
//--- Сделать видимыми все объекты
   ::ObjectSetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
   ::ObjectSetInteger(m_chart_id,m_textbox.ChartObjectName(),OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
//--- Состояние видимости
   CElementBase::IsVisible(true);
//--- Обновить положение элемента
   Moving();
//--- Показать полосы прокрутки
   if(m_scrollv.IsScroll())
      m_scrollv.Show();
   if(m_scrollh.IsScroll())
      m_scrollh.Show();
  }
//+------------------------------------------------------------------+
//| Скрывает элемент                                                 |
//+------------------------------------------------------------------+
void CTextBox::Hide(void)
  {
//--- Выйти, если элемент скрыт
   if(!CElementBase::IsVisible())
      return;
//--- Скрыть все объекты
   ::ObjectSetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   ::ObjectSetInteger(m_chart_id,m_textbox.ChartObjectName(),OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
   m_scrollv.Hide();
   m_scrollh.Hide();
//--- Состояние видимости
   CElementBase::IsVisible(false);
  }
//+------------------------------------------------------------------+
//| Удаление                                                         |
//+------------------------------------------------------------------+
void CTextBox::Delete(void)
  {
//--- Удаление объектов
   m_canvas.Destroy();
   m_textbox.Destroy();
//--- Получим размер массива строк
   uint lines_total=::ArraySize(m_lines);
//--- Освобождение массивов элемента
   for(uint i=0; i<lines_total; i++)
     {
      ::ArrayFree(m_lines[i].m_width);
      ::ArrayFree(m_lines[i].m_symbol);
     }
//---
   ::ArrayFree(m_lines);
//--- Инициализация переменных значениями по умолчанию
   m_text_edit_state=false;
   CElementBase::IsVisible(true);
   CElementBase::MouseFocus(false);
  }
//+------------------------------------------------------------------+
//| Установка приоритетов                                            |
//+------------------------------------------------------------------+
void CTextBox::SetZorders(void)
  {
   CElement::SetZorders();
   ::ObjectSetInteger(m_chart_id,m_textbox.ChartObjectName(),OBJPROP_ZORDER,m_zorder+1);
  }
//+------------------------------------------------------------------+
//| Сброс приоритетов                                                |
//+------------------------------------------------------------------+
void CTextBox::ResetZorders(void)
  {
   CElement::ResetZorders();
   ::ObjectSetInteger(m_chart_id,m_textbox.ChartObjectName(),OBJPROP_ZORDER,WRONG_VALUE);
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на элемент                                     |
//+------------------------------------------------------------------+
bool CTextBox::OnClickTextBox(const string clicked_object)
  {
//--- Выйдем, если чужое имя объекта
   if(m_textbox.ChartObjectName()!=clicked_object)
     {
      //--- Отправим сообщение об окончании ввода строки в поле ввода, если поле было активно
      if(m_text_edit_state)
        {
         string str=(m_multi_line_mode)? TextCursorInfo() : "";
         ::EventChartCustom(m_chart_id,ON_END_EDIT,CElementBase::Id(),CElementBase::Index(),str);
        }
      //--- Дезактивировать поле ввода
      DeactivateTextBox();
      //--- Обновить
      Update(true);
      return(false);
     }
//--- Выйти, если (1) включен режим "Только для чтения" или (2) элемент заблокирован
   if(m_read_only_mode || CElementBase::IsLocked())
      return(true);
//--- Выйдем, если полоса прокрутки в активном режиме
   if(m_scrollv.State() || m_scrollh.State())
      return(true);
//--- Если (1) включен режим авто выделения текста и (2) поле ввода было активировано только что
   if(m_auto_selection_mode && !m_text_edit_state)
      SelectAllText();
//--- Сброс выделения
   else
      ResetSelectedText();
//--- Отключим управление графиком
   m_chart.SetInteger(CHART_KEYBOARD_CONTROL,false);
//--- Если (1) включен режим авто выделения текста и (2) поле ввода активировано
   if(!m_auto_selection_mode || (m_auto_selection_mode && m_text_edit_state))
     {
      //--- Установить текстовый курсор по курсору мыши
      SetTextCursorByMouseCursor();
     }
//--- Если включен режим многострочного поля ввода, корректируем вертикальную полосу прокрутки
   if(m_multi_line_mode)
      CorrectingVerticalScrollThumb();
//--- Активировать поле ввода
   m_text_edit_state=true;
//--- Обновить текст и курсор
   DrawTextAndCursor(true);
//--- Изменить цвет рамки
   DrawBorder();
   m_canvas.Update();
//--- Отправим сообщение об этом
   ::EventChartCustom(m_chart_id,ON_CLICK_TEXT_BOX,CElementBase::Id(),CElementBase::Index(),TextCursorInfo());
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на клавише                                     |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKey(const long key_code)
  {
//--- Получим символ клавиши
   string pressed_key=m_keys.KeySymbol(key_code);
//--- Выйти, если нет символа
   if(pressed_key=="")
      return(false);
//--- Если есть выделенный текст, удалим его
   DeleteSelectedText();
//--- Добавим символ и его свойства
   AddSymbol(pressed_key);
//--- Рассчитать размеры поля ввода
   CalculateTextBoxSize();
//--- Установить новый размер полю ввода
   ChangeTextBoxSize(true,true);
//--- Корректируем горизонтальную полосу прокрутки
   CorrectingHorizontalScrollThumb();
//--- Если режим переноса слов включен, корректируем вертикальную полосу прокрутки
   if(m_word_wrap_mode)
      CorrectingVerticalScrollThumb();
//--- Обновить текст в поле ввода
   DrawTextAndCursor(true);
//--- Отправим сообщение об этом
   ::EventChartCustom(m_chart_id,ON_MOVE_TEXT_CURSOR,CElementBase::Id(),CElementBase::Index(),TextCursorInfo());
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на клавише 'Backspace'                         |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyBackspace(const long key_code)
  {
//--- Выйти, если это не клавиша 'Backspace'
   if(key_code!=KEY_BACKSPACE)
      return(false);
//--- Если есть выделенный текст, удалим его и выйдем
   if(DeleteSelectedText())
      return(true);
//--- Удалить символ, если позиция больше нуля
   if(m_text_cursor_x_pos>0)
      DeleteSymbol();
//--- Если нулевая позиция и не первая строка,
//    удалить строку и сместить строки на одну позицию вверх
   else if(m_text_cursor_y_pos>0)
      ShiftOnePositionUp();
//--- Рассчитать размеры поля ввода
   CalculateTextBoxSize();
//--- Установить новый размер полю ввода
   ChangeTextBoxSize(true,true);
//--- Корректируем полосы прокрутки
   CorrectingHorizontalScrollThumb();
   CorrectingVerticalScrollThumb();
//--- Обновить текст в поле ввода
   DrawTextAndCursor(true);
//--- Отправим сообщение об этом
   ::EventChartCustom(m_chart_id,ON_MOVE_TEXT_CURSOR,CElementBase::Id(),CElementBase::Index(),TextCursorInfo());
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на клавише "Enter"                             |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyEnter(const long key_code)
  {
//--- Выйти, если это не клавиша 'Enter'
   if(key_code!=KEY_ENTER)
      return(false);
//--- Если есть выделенный текст, удалим его
   DeleteSelectedText();
//--- Если отключен многострочный режим
   if(!m_multi_line_mode)
     {
      //--- Дезактивировать поле ввода
      DeactivateTextBox();
      //--- Обновить
      Update(true);
      //--- Отправим сообщение об этом
      string str=(m_multi_line_mode)? TextCursorInfo() : "";
      ::EventChartCustom(m_chart_id,ON_END_EDIT,CElementBase::Id(),CElementBase::Index(),str);
      return(false);
     }
//--- Сместим строки на одну позицию вниз
   ShiftOnePositionDown();
//--- Рассчитать размеры поля ввода
   CalculateTextBoxSize();
//--- Установить новый размер полю ввода
   ChangeTextBoxSize();
//--- Корректируем вертикальную полосу прокрутки
   CorrectingVerticalScrollThumb();
//--- Переместить курсор в начало строки
   SetTextCursor(0,m_text_cursor_y_pos);
//--- Переместить полосу прокрутки в начало
   HorizontalScrolling(0);
//--- Обновить текст в поле ввода
   DrawTextAndCursor(true);
//--- Отправим сообщение об этом
   ::EventChartCustom(m_chart_id,ON_MOVE_TEXT_CURSOR,CElementBase::Id(),CElementBase::Index(),TextCursorInfo());
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на клавише 'Left'                              |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyLeft(const long key_code)
  {
//--- Выйти, если (1) это не клавиша 'Left' или (2) нажата клавиша 'Ctrl' или (3) клавиша 'Shift' нажата
   if(key_code!=KEY_LEFT || m_keys.KeyCtrlState() || m_keys.KeyShiftState())
      return(false);
//--- Сместить текстовый курсор влево на один символ
   MoveTextCursor(TO_NEXT_LEFT_SYMBOL,false);
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на клавише 'Right'                             |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyRight(const long key_code)
  {
//--- Выйти, если (1) это не клавиша 'Right' или (2) нажата клавиша 'Ctrl' или (3) клавиша 'Shift' нажата
   if(key_code!=KEY_RIGHT || m_keys.KeyCtrlState() || m_keys.KeyShiftState())
      return(false);
//--- Сместить текстовый курсор вправо на один символ
   MoveTextCursor(TO_NEXT_RIGHT_SYMBOL,false);
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на клавише 'Up'                                |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyUp(const long key_code)
  {
//--- Выйти, если отключен многострочный режим
   if(!m_multi_line_mode)
      return(false);
//--- Выйти, если (1) это не клавиша 'Up' или (2) клавиша 'Shift' нажата
   if(key_code!=KEY_UP || m_keys.KeyShiftState())
      return(false);
//--- Сместить текстовый курсор вверх на одну строку
   MoveTextCursor(TO_NEXT_UP_LINE,false);
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на клавише 'Down'                              |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyDown(const long key_code)
  {
//--- Выйти, если отключен многострочный режим
   if(!m_multi_line_mode)
      return(false);
//--- Выйти, если (1) это не клавиша 'Down' или (2) клавиша 'Shift' нажата
   if(key_code!=KEY_DOWN || m_keys.KeyShiftState())
      return(false);
//--- Сместить текстовый курсор вниз на одну строку
   MoveTextCursor(TO_NEXT_DOWN_LINE,false);
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на клавише 'Home'                              |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyHome(const long key_code)
  {
//--- Выйти, если (1) это не клавиша 'Home' или (2) клавиша 'Ctrl' нажата или (3) клавиша 'Shift' нажата
   if(key_code!=KEY_HOME || m_keys.KeyCtrlState() || m_keys.KeyShiftState())
      return(false);
//--- Переместить курсор в начало текущей строки
   MoveTextCursor(TO_BEGIN_LINE,false);
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на клавише 'End'                               |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyEnd(const long key_code)
  {
//--- Выйти, если (1) это не клавиша 'End' или (2) клавиша 'Ctrl' нажата или (3) клавиша 'Shift' нажата
   if(key_code!=KEY_END || m_keys.KeyCtrlState() || m_keys.KeyShiftState())
      return(false);
//--- Переместить курсор в конец текущей строки
   MoveTextCursor(TO_END_LINE,false);
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка одновременного нажатия клавиш Ctrl + Left              |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyCtrlAndLeft(const long key_code)
  {
//--- Выйти, если (1) это не клавиша 'Left' и (2) клавиша 'Ctrl' не нажата или (3) клавиша 'Shift' нажата
   if(!(key_code==KEY_LEFT && m_keys.KeyCtrlState()) || m_keys.KeyShiftState())
      return(false);
//--- Сместить текстовый курсор влево на одно слово
   MoveTextCursor(TO_NEXT_LEFT_WORD,false);
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка одновременного нажатия клавиш Ctrl + Right             |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyCtrlAndRight(const long key_code)
  {
//--- Выйти, если (1) это не клавиша 'Right' и (2) клавиша 'Ctrl' не нажата или (3) клавиша 'Shift' нажата
   if(!(key_code==KEY_RIGHT && m_keys.KeyCtrlState()) || m_keys.KeyShiftState())
      return(false);
//--- Сместить текстовый курсор вправо на одно слово
   MoveTextCursor(TO_NEXT_RIGHT_WORD,false);
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка одновременного нажатия клавиш Ctrl + Home              |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyCtrlAndHome(const long key_code)
  {
//--- Выйти, если (1) это не клавиша 'Home' и (2) клавиша 'Ctrl' не нажата или (3) клавиша 'Shift' нажата
   if(!(key_code==KEY_HOME && m_keys.KeyCtrlState()) || m_keys.KeyShiftState())
      return(false);
//--- Переместить курсор в начало первой строки
   MoveTextCursor(TO_BEGIN_FIRST_LINE,false);
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка одновременного нажатия клавиш Ctrl + End               |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyCtrlAndEnd(const long key_code)
  {
//--- Выйти, если (1) это не клавиша 'End' и (2) клавиша 'Ctrl' не нажата или (3) клавиша 'Shift' нажата
   if(!(key_code==KEY_END && m_keys.KeyCtrlState()) || m_keys.KeyShiftState())
      return(false);
//--- Переместить курсор в конец последней строки
   MoveTextCursor(TO_END_LAST_LINE,false);
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на клавише Shift + Left                        |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyShiftAndLeft(const long key_code)
  {
//--- Выйти, если (1) это не клавиша 'Left' или (2) клавиша 'Ctrl' нажата или (3) клавиша 'Shift' не нажата
   if(key_code!=KEY_LEFT || m_keys.KeyCtrlState() || !m_keys.KeyShiftState())
      return(false);
//--- Сместить текстовый курсор влево на один символ
   MoveTextCursor(TO_NEXT_LEFT_SYMBOL,true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на клавише Shift + Right                       |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyShiftAndRight(const long key_code)
  {
//--- Выйти, если (1) это не клавиша 'Right' или (2) клавиша 'Ctrl' нажата или (3) клавиша 'Shift' не нажата
   if(key_code!=KEY_RIGHT || m_keys.KeyCtrlState() || !m_keys.KeyShiftState())
      return(false);
//--- Сместить текстовый курсор вправо на один символ
   MoveTextCursor(TO_NEXT_RIGHT_SYMBOL,true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на клавише Shift + Up                          |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyShiftAndUp(const long key_code)
  {
//--- Выйти, если (1) это не клавиша 'Up' или (2) клавиша 'Ctrl' нажата или (3) клавиша 'Shift' не нажата
   if(key_code!=KEY_UP || m_keys.KeyCtrlState() || !m_keys.KeyShiftState())
      return(false);
//--- Сместить текстовый курсор вверх на одну строку
   MoveTextCursor(TO_NEXT_UP_LINE,true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на клавише Shift + Down                        |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyShiftAndDown(const long key_code)
  {
//--- Выйти, если (1) это не клавиша 'Down' или (2) клавиша 'Ctrl' нажата или (3) клавиша 'Shift' не нажата
   if(key_code!=KEY_DOWN || m_keys.KeyCtrlState() || !m_keys.KeyShiftState())
      return(false);
//--- Сместить текстовый курсор вниз на одну строку
   MoveTextCursor(TO_NEXT_DOWN_LINE,true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на клавише Shift + Home                        |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyShiftAndHome(const long key_code)
  {
//--- Выйти, если (1) это не клавиша 'Home' или (2) клавиша 'Ctrl' нажата или (3) клавиша 'Shift' не нажата
   if(key_code!=KEY_HOME || m_keys.KeyCtrlState() || !m_keys.KeyShiftState())
      return(false);
//--- Переместить курсор в начало текущей строки
   MoveTextCursor(TO_BEGIN_LINE,true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на клавише Shift + End                         |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyShiftAndEnd(const long key_code)
  {
//--- Выйти, если (1) это не клавиша 'End' или (2) клавиша 'Ctrl' нажата или (3) клавиша 'Shift' не нажата
   if(key_code!=KEY_END || m_keys.KeyCtrlState() || !m_keys.KeyShiftState())
      return(false);
//--- Переместить курсор в конец текущей строки
   MoveTextCursor(TO_END_LINE,true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на клавише Ctrl + Shift + Left                 |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyCtrlShiftAndLeft(const long key_code)
  {
//--- Выйти, если (1) это не клавиша 'Left' и (2) клавиша 'Ctrl' не нажата и (3) клавиша 'Shift' нажата
   if(!(key_code==KEY_LEFT && m_keys.KeyCtrlState() && m_keys.KeyShiftState()))
      return(false);
//--- Сместить текстовый курсор влево на одно слово
   MoveTextCursor(TO_NEXT_LEFT_WORD,true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на клавише Ctrl + Shift + Right                |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyCtrlShiftAndRight(const long key_code)
  {
//--- Выйти, если (1) это не клавиша 'Right' и (2) клавиша 'Ctrl' не нажата и (3) клавиша 'Shift' нажата
   if(!(key_code==KEY_RIGHT && m_keys.KeyCtrlState() && m_keys.KeyShiftState()))
      return(false);
//--- Сместить текстовый курсор вправо на одно слово
   MoveTextCursor(TO_NEXT_RIGHT_WORD,true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на клавише Ctrl + Shift + Home                 |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyCtrlShiftAndHome(const long key_code)
  {
//--- Выйти, если (1) это не клавиша 'Home' и (2) клавиша 'Ctrl' не нажата и (3) клавиша 'Shift' нажата
   if(!(key_code==KEY_HOME && m_keys.KeyCtrlState() && m_keys.KeyShiftState()))
      return(false);
//--- Переместить курсор в начало первой строки
   MoveTextCursor(TO_BEGIN_FIRST_LINE,true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Обработка нажатия на клавише Ctrl + Shift + End                  |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyCtrlShiftAndEnd(const long key_code)
  {
//--- Выйти, если (1) это не клавиша 'End' и (2) клавиша 'Ctrl' не нажата и (3) клавиша 'Shift' нажата
   if(!(key_code==KEY_END && m_keys.KeyCtrlState() && m_keys.KeyShiftState()))
      return(false);
//--- Переместить курсор в конец последней строки
   MoveTextCursor(TO_END_LAST_LINE,true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Установить начальные индексы для выделенния текста               |
//+------------------------------------------------------------------+
void CTextBox::SetStartSelectedTextIndexes(void)
  {
//--- Если начальные индексы для выделения текста ещё не установлены
   if(m_selected_line_from==WRONG_VALUE)
     {
      m_selected_line_from   =(int)m_text_cursor_y_pos;
      m_selected_symbol_from =(int)m_text_cursor_x_pos;
     }
  }
//+------------------------------------------------------------------+
//| Установить конечные индексы для выделенния текста                |
//+------------------------------------------------------------------+
void CTextBox::SetEndSelectedTextIndexes(void)
  {
//--- Установить конечные индексы для выделения текста
   m_selected_line_to   =(int)m_text_cursor_y_pos;
   m_selected_symbol_to =(int)m_text_cursor_x_pos;
//--- Если все индексы равны, то сбросить выделение
   if(m_selected_line_from==m_selected_line_to && m_selected_symbol_from==m_selected_symbol_to)
      ResetSelectedText();
  }
//+------------------------------------------------------------------+
//| Выделить весь текст                                              |
//+------------------------------------------------------------------+
void CTextBox::SelectAllText(void)
  {
//--- Получим размер массива символов
   int symbols_total=::ArraySize(m_lines[0].m_symbol);
//--- Установить индексы для выделения текста
   m_selected_line_from   =0;
   m_selected_line_to     =0;
   m_selected_symbol_from =0;
   m_selected_symbol_to   =symbols_total;
//--- Переместить ползунок горизонтальной полосы прокрутки на последнюю позицию
   HorizontalScrolling();
//--- Переместить курсор в конец строки
   SetTextCursor(symbols_total,0);
  }
//+------------------------------------------------------------------+
//| Сбросить выделенный текст                                        |
//+------------------------------------------------------------------+
void CTextBox::ResetSelectedText(void)
  {
   m_selected_line_from   =WRONG_VALUE;
   m_selected_line_to     =WRONG_VALUE;
   m_selected_symbol_from =WRONG_VALUE;
   m_selected_symbol_to   =WRONG_VALUE;
  }
//+------------------------------------------------------------------+
//| Дезактивация поля ввода                                          |
//+------------------------------------------------------------------+
void CTextBox::DeactivateTextBox(void)
  {
//--- Выйти, если уже дезактивировано
   if(!m_text_edit_state)
      return;
//--- Дезактивировать
   m_text_edit_state=false;
//--- Включим управление графиком
   m_chart.SetInteger(CHART_KEYBOARD_CONTROL,true);
//--- Сброс выделения
   ResetSelectedText();
//--- Если многострочный режим отключен
   if(!m_multi_line_mode)
     {
      //--- Переместить курсор в начало строки
      SetTextCursor(0,0);
      //--- Сместить полосу прокрутки в начало строки
      HorizontalScrolling(0);
     }
  }
//+------------------------------------------------------------------+
//| Ускоренная промотка полосы прокрутки                             |
//+------------------------------------------------------------------+
void CTextBox::FastSwitching(void)
  {
//--- Выйдем, если нет фокуса на элементе
   if(!CElementBase::MouseFocus())
      return;
//--- Вернём счётчик к первоначальному значению, если кнопка мыши отжата
   if(!m_mouse.LeftButtonState() || m_scrollv.State() || m_scrollh.State())
      m_timer_counter=SPIN_DELAY_MSC;
//--- Если же кнопка мыши нажата
   else
     {
      //--- Увеличим счётчик на установленный интервал
      m_timer_counter+=TIMER_STEP_MSC;
      //--- Выйдем, если меньше нуля
      if(m_timer_counter<0)
         return;
      //---
      bool scroll_v=false,scroll_h=false;
      //--- Если прокрутка вверх
      if(m_scrollv.GetIncButtonPointer().MouseFocus())
        {
         m_scrollv.OnClickScrollInc((uint)Id(),0);
         scroll_v=true;
        }
      //--- Если прокрутка вниз
      else if(m_scrollv.GetDecButtonPointer().MouseFocus())
        {
         m_scrollv.OnClickScrollDec((uint)Id(),1);
         scroll_v=true;
        }
      //--- Если прокрутка влево
      else if(m_scrollh.GetIncButtonPointer().MouseFocus())
        {
         m_scrollh.OnClickScrollInc((uint)Id(),2);
         scroll_h=true;
        }
      //--- Если прокрутка вправо
      else if(m_scrollh.GetDecButtonPointer().MouseFocus())
        {
         m_scrollh.OnClickScrollDec((uint)Id(),3);
         scroll_h=true;
        }
      //--- Выйти, если ни одна кнопка не нажата
      if(!scroll_v && !scroll_h)
         return;
      //--- Смещает поле ввода
      ShiftData();
      //--- Обновить полосы прокрутки
      if(scroll_v) m_scrollv.Update(true);
      if(scroll_h) m_scrollh.Update(true);
     }
  }
//+------------------------------------------------------------------+
//| Рисует текст                                                     |
//+------------------------------------------------------------------+
void CTextBox::Draw(void)
  {
//--- Выводим текст
   CTextBox::TextOut();
//--- Рисуем рамку
   DrawBorder();
  }
//+------------------------------------------------------------------+
//| Обновление элемента                                              |
//+------------------------------------------------------------------+
void CTextBox::Update(const bool redraw=false)
  {
//--- Перерисовать таблицу, если указано
   if(redraw)
     {
      //--- Нарисовать
      Draw();
      //--- Применить
      m_canvas.Update();
      m_textbox.Update();
      return;
     }
//--- Применить
   m_canvas.Update();
   m_textbox.Update();
  }
//+------------------------------------------------------------------+
//| Вывод текста на холст                                            |
//+------------------------------------------------------------------+
void CTextBox::TextOut(void)
  {
//--- Очистить холст
   m_textbox.Erase(AreaColorCurrent());
//--- Получим размер массива строк
   uint lines_total=::ArraySize(m_lines);
//--- Корректировка в случае выхода из диапазона
   m_text_cursor_y_pos=(m_text_cursor_y_pos>=lines_total)? lines_total-1 : m_text_cursor_y_pos;
//--- Получим размер массива символов
   uint symbols_total=::ArraySize(m_lines[m_text_cursor_y_pos].m_symbol);
//--- Если включен многострочный режим или количество символов больше нуля
   if(m_multi_line_mode || symbols_total>0)
     {
      //--- Цвет текста
      uint text_color=TextColorCurrent();
      //--- Получим ширину строки
      int line_width=(int)LineWidth(m_text_cursor_x_pos,m_text_cursor_y_pos);
      //--- Получим высоту строки и пройдёмся по всем строкам в цикле
      int line_height=(int)LineHeight();
      for(uint i=0; i<lines_total; i++)
        {
         //--- Получим координаты для текста
         int x=m_text_x_offset;
         int y=m_text_y_offset+((int)i*line_height);
         //--- Получим размер строки
         uint string_length=::ArraySize(m_lines[i].m_symbol);
         //--- Рисуем текст
         for(uint s=0; s<string_length; s++)
           {
            //--- Если есть выделенный текст, определим его цвет, а также цвет фона текущего символа
            if(CheckSelectedText(i,s))
              {
               //--- Цвет выделенного текста
               text_color=::ColorToARGB(m_selected_text_color);
               //--- Рассчитаем координаты для рисования фона
               int x2 =x+m_lines[i].m_width[s];
               int y2 =y+line_height-1;
               //--- Рисуем цвет фона символа
               m_textbox.FillRectangle(x,y,x2,y2,::ColorToARGB(m_selected_back_color,m_alpha));
              }
            else
               text_color=TextColorCurrent();
            //--- Нарисовать символ
            m_textbox.TextOut(x,y,m_lines[i].m_symbol[s],text_color,TA_LEFT);
            //--- X-координата для следующего символа
            x+=m_lines[i].m_width[s];
           }
        }
     }
//--- Если же многострочный режим отключен и нет ни одного символа, то будет отображаться текст по умолчанию (если указан)
   else
     {
      if(m_default_text!="")
         m_textbox.TextOut(m_area_x_size/2,m_area_y_size/2,m_default_text,::ColorToARGB(m_default_text_color),TA_CENTER|TA_VCENTER);
     }
  }
//+------------------------------------------------------------------+
//| Рисует рамку поля ввода                                          |
//+------------------------------------------------------------------+
void CTextBox::DrawBorder(void)
  {
//--- Получим смещение по оси X
   int xo=(int)::ObjectGetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_XOFFSET);
   int yo=(int)::ObjectGetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_YOFFSET);
//--- Границы
   int x_size =(int)::ObjectGetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_XSIZE)-1;
   int y_size =(int)::ObjectGetInteger(m_chart_id,m_canvas.ChartObjectName(),OBJPROP_YSIZE)-1;
//--- Координаты
   int x1=xo,y1=yo;
   int x2=xo+x_size;
   int y2=yo+y_size;
//--- Рисуем прямоугольник без заливки
   m_canvas.Rectangle(x1,y1,x2,y2,BorderColorCurrent());
  }
//+------------------------------------------------------------------+
//| Рисует текстовый курсор                                          |
//+------------------------------------------------------------------+
void CTextBox::DrawCursor(void)
  {
//--- Получим высоту строки
   int line_height=(int)LineHeight();
//--- Получим X-координату курсора
   CalculateTextCursorX();
//--- Нарисуем текстовый курсор
   for(int i=0; i<line_height; i++)
     {
      //--- Получим Y-координату для пикселя
      int y=m_text_y_offset+((int)m_text_cursor_y_pos*line_height)+i;
      //--- Получим текущий цвет пикселя
      uint pixel_color=m_textbox.PixelGet(m_text_cursor_x,y);
      //--- Инвертируем цвет для курсора
      pixel_color=::ColorToARGB(m_clr.Negative((color)pixel_color));
      m_textbox.PixelSet(m_text_cursor_x,y,::ColorToARGB(pixel_color));
     }
  }
//+------------------------------------------------------------------+
//| Отображает текст и мигающий курсор                               |
//+------------------------------------------------------------------+
void CTextBox::DrawTextAndCursor(const bool show_state=false)
  {
//--- Определим состояние для текстового курсора (показать/скрыть)
   static bool state=false;
   state=(!show_state)? !state : show_state;
//--- Выводим текст
   CTextBox::TextOut();
//--- Нарисовать текстовый курсор
   if(state)
      DrawCursor();
//--- Обновить поле ввода
   m_canvas.Update();
   m_textbox.Update();
   m_scrollh.Update(true);
   m_scrollv.Update(true);
//--- Сброс счётчика
   m_counter.ZeroTimeCounter();
  }
//+------------------------------------------------------------------+
//| Возвращает цвет фона относительно текущего состояния элемента    |
//+------------------------------------------------------------------+
uint CTextBox::AreaColorCurrent(void)
  {
   uint clr=(!CElementBase::IsLocked())? m_back_color : m_back_color_locked;
//--- Вернуть цвет
   return(::ColorToARGB(clr,m_alpha));
  }
//+------------------------------------------------------------------+
//| Возвращает цвет текста относительно текущего состояния элемента  |
//+------------------------------------------------------------------+
uint CTextBox::TextColorCurrent(void)
  {
   uint clr=(!CElementBase::IsLocked())? m_label_color : m_label_color_locked;
//--- Вернуть цвет
   return(::ColorToARGB(clr));
  }
//+------------------------------------------------------------------+
//| Возвращает цвет рамки относительно текущего состояния элемента   |
//+------------------------------------------------------------------+
uint CTextBox::BorderColorCurrent(void)
  {
   uint clr=clrBlack;
//--- Если элемент не заблокирован
   if(!CElementBase::IsLocked())
     {
      //--- Если поле ввода активировано
      if(m_text_edit_state)
         clr=m_border_color_pressed;
      //--- Если неактивировано, то проверяем фокус элемента
      else
         clr=(CElementBase::MouseFocus())? m_border_color_hover : m_border_color;
     }
//--- Если элемент заблокирован
   else
      clr=m_border_color_locked;
//--- Вернуть цвет
   return(::ColorToARGB(clr));
  }
//+------------------------------------------------------------------+
//| Изменение цвета объектов                                         |
//+------------------------------------------------------------------+
void CTextBox::ChangeObjectsColor(void)
  {
//--- Отслеживаем изменение цвета, только если доступен сам и родитель 
   if(m_main.CElementBase::IsLocked() || !CElementBase::IsAvailable())
      return;
//--- Если это момент пересечения границ элемента
   if(CElementBase::CheckCrossingBorder())
     {
      //--- Изменить цвет
      DrawBorder();
      m_canvas.Update();
     }
  }
//+------------------------------------------------------------------+
//| Собирает строку из символов                                      |
//+------------------------------------------------------------------+
string CTextBox::CollectString(const uint line_index,const uint symbols_total=0)
  {
   m_temp_input_string="";
//--- Получим размер строки
   uint string_length=::ArraySize(m_lines[line_index].m_symbol);
//---
   for(uint i=0; i<string_length; i++)
     {
      if(symbols_total>0)
        {
         if(i==symbols_total)
            break;
        }
      //---
      ::StringAdd(m_temp_input_string,m_lines[line_index].m_symbol[i]);
     }
//--- Вернуть собранную строку
   return(m_temp_input_string);
  }
//+------------------------------------------------------------------+
//| Добавляет символ и его свойства в массивы структуры              |
//+------------------------------------------------------------------+
void CTextBox::AddSymbol(const string key_symbol)
  {
//--- Получим размер массива символов
   uint symbols_total=::ArraySize(m_lines[m_text_cursor_y_pos].m_symbol);
//--- Установим новый размер массивам
   ArraysResize(m_text_cursor_y_pos,symbols_total+1);
//--- Сместить все символы от конца массива к индексу добавляемого символа
   MoveSymbols(m_text_cursor_y_pos,0,m_text_cursor_x_pos,false);
//--- Получим ширину символа
   int width=m_textbox.TextWidth(key_symbol);
//--- Добавить символ в освободившийся элемент
   m_lines[m_text_cursor_y_pos].m_symbol[m_text_cursor_x_pos] =key_symbol;
   m_lines[m_text_cursor_y_pos].m_width[m_text_cursor_x_pos]  =width;
//--- Увеличить счётчик позиции курсора
   m_text_cursor_x_pos++;
  }
//+------------------------------------------------------------------+
//| Удаляет символ                                                   |
//+------------------------------------------------------------------+
void CTextBox::DeleteSymbol(void)
  {
//--- Получим размер массива символов
   uint symbols_total=::ArraySize(m_lines[m_text_cursor_y_pos].m_symbol);
//--- Если массив пустой
   if(symbols_total<1)
     {
      //--- Установим курсор на нулевую позицию текщей строки
      SetTextCursor(0,m_text_cursor_y_pos);
      return;
     }
//--- Получим позицию предыдущего символа
   int check_pos=(int)m_text_cursor_x_pos-1;
//--- Выйти, если выход из диапазона
   if(check_pos<0)
      return;
//--- Сместить все символы на один элемент влево от индекса удаляемого символа
   MoveSymbols(m_text_cursor_y_pos,m_text_cursor_x_pos,check_pos);
//--- Уменьшить счётчик позиции курсора
   m_text_cursor_x_pos--;
//--- Установим новый размер массивам
   ArraysResize(m_text_cursor_y_pos,symbols_total-1);
  }
//+------------------------------------------------------------------+
//| Удаляет выделенный текст                                         |
//+------------------------------------------------------------------+
bool CTextBox::DeleteSelectedText(void)
  {
//--- Выйти, если текст не выделен
   if(m_selected_line_from==WRONG_VALUE)
      return(false);
//--- Если удаляются символы на одной строке
   if(m_selected_line_from==m_selected_line_to)
      DeleteTextOnOneLine();
//--- Если удаляются символы с нескольких строк
   else
      DeleteTextOnMultipleLines();
//--- Сброс выделенного текста
   ResetSelectedText();
//--- Рассчитать размеры поля ввода
   CalculateTextBoxSize();
//--- Установить новый размер полю ввода
   ChangeTextBoxSize();
//--- Корректируем полосы прокрутки
   CorrectingHorizontalScrollThumb();
   CorrectingVerticalScrollThumb();
//--- Обновить текст в поле ввода
   DrawTextAndCursor(true);
//--- Отправим сообщение об этом
   ::EventChartCustom(m_chart_id,ON_MOVE_TEXT_CURSOR,CElementBase::Id(),CElementBase::Index(),TextCursorInfo());
   return(true);
  }
//+------------------------------------------------------------------+
//| Удаляет выделенный на одной строке текст                         |
//+------------------------------------------------------------------+
void CTextBox::DeleteTextOnOneLine(void)
  {
   int symbols_total     =::ArraySize(m_lines[m_text_cursor_y_pos].m_symbol);
   int symbols_to_delete =::fabs(m_selected_symbol_from-m_selected_symbol_to);
//--- Если начальный индекс символа справа
   if(m_selected_symbol_to<m_selected_symbol_from)
     {
      //--- Сместим символы на освободившееся место в текущей строке
      MoveSymbols(m_text_cursor_y_pos,m_selected_symbol_from,m_selected_symbol_to);
     }
//--- Если начальный индекс символа слева
   else
     {
      //--- Сместим текстовый курсор влево на количество удаляемых символов
      m_text_cursor_x_pos-=symbols_to_delete;
      //--- Сместим символы на освободившееся место в текущей строке
      MoveSymbols(m_text_cursor_y_pos,m_selected_symbol_to,m_selected_symbol_from);
     }
//--- Уменьшим размер массива текущей строки на извлечённое из неё количество символов
   ArraysResize(m_text_cursor_y_pos,symbols_total-symbols_to_delete);
  }
//+------------------------------------------------------------------+
//| Удаляет выделенный текст на нескольких строках                   |
//+------------------------------------------------------------------+
void CTextBox::DeleteTextOnMultipleLines(void)
  {
//--- Общее количество символов на начальной и конечной строках
   uint symbols_total_line_from =::ArraySize(m_lines[m_selected_line_from].m_symbol);
   uint symbols_total_line_to   =::ArraySize(m_lines[m_selected_line_to].m_symbol);
//--- Количество промежуточных строк для удаления
   uint lines_to_delete=::fabs(m_selected_line_from-m_selected_line_to);
//--- Количество символов для удаления на начальной и конечной строках
   uint symbols_to_delete_in_line_from =::fabs(symbols_total_line_from-m_selected_symbol_from);
   uint symbols_to_delete_in_line_to   =::fabs(symbols_total_line_to-m_selected_symbol_to);
//--- Если начальная строка ниже конечной
   if(m_selected_line_from>m_selected_line_to)
     {
      //--- Скопируем в массив символы, которые нужно перенести
      string array[];
      CopyWrapSymbols(m_selected_line_from,m_selected_symbol_from,symbols_to_delete_in_line_from,array);
      //--- Установим новый размер строке-приёмнику
      uint new_size=m_selected_symbol_to+symbols_to_delete_in_line_from;
      ArraysResize(m_selected_line_to,new_size);
      //--- Добавить данные в массивы структуры строки-приёмника
      PasteWrapSymbols(m_selected_line_to,m_selected_symbol_to,array);
      //--- Получим размер массива строк
      uint lines_total=::ArraySize(m_lines);
      //--- Сместим строки вверх на количество удаляемых строк
      MoveLines(m_selected_line_to+1,lines_total-lines_to_delete,lines_to_delete,false);
      //--- Установим новый размер массиву строк
      ::ArrayResize(m_lines,lines_total-lines_to_delete);
     }
//--- Если начальная строка выше конечной
   else
     {
      //--- Скопируем в массив символы, которые нужно перенести
      string array[];
      CopyWrapSymbols(m_selected_line_to,m_selected_symbol_to,symbols_to_delete_in_line_to,array);
      //--- Установим новый размер строке-приёмнику
      uint new_size=m_selected_symbol_from+symbols_to_delete_in_line_to;
      ArraysResize(m_selected_line_from,new_size);
      //--- Добавить данные в массивы структуры строки-приёмника
      PasteWrapSymbols(m_selected_line_from,m_selected_symbol_from,array);
      //--- Получим размер массива строк
      uint lines_total=::ArraySize(m_lines);
      //--- Сместим строки вверх на количество удаляемых строк
      MoveLines(m_selected_line_from+1,lines_total-lines_to_delete,lines_to_delete,false);
      //--- Установим новый размер массиву строк
      ::ArrayResize(m_lines,lines_total-lines_to_delete);
      //--- Переместить курсор на начальную позицию в выделении
      SetTextCursor(m_selected_symbol_from,m_selected_line_from);
     }
  }
//+------------------------------------------------------------------+
//| Возвращает высоту строки                                         |
//+------------------------------------------------------------------+
uint CTextBox::LineHeight(void)
  {
//--- Установим шрифт для отображения на холсте (нужно, чтобы получить высоту строки)
   m_textbox.FontSet(CElement::Font(),-CElement::FontSize()*10,FW_NORMAL);
//--- Вернём высоту строки
   return(m_textbox.TextHeight("|"));
  }
//+------------------------------------------------------------------+
//| Возвращает ширину строки от начала до указанной позиции          |
//+------------------------------------------------------------------+
uint CTextBox::LineWidth(const uint symbol_index,const uint line_index)
  {
//--- Получим размер массива строк
   uint lines_total=::ArraySize(m_lines);
//--- Предотвращение выхода из диапазона
   uint l=(line_index<lines_total)? line_index : lines_total-1;
//--- Получим размер массива символов указанной строки
   uint symbols_total=::ArraySize(m_lines[l].m_symbol);
//--- Предотвращение выхода из диапазона
   uint s=(symbol_index<symbols_total)? symbol_index : symbols_total;
//--- Суммируем ширину всех символов
   uint width=0;
   for(uint i=0; i<s; i++)
      width+=m_lines[l].m_width[i];
//--- Вернуть ширину строки
   return(width);
  }
//+------------------------------------------------------------------+
//| Возвращает максимальную ширину строки                            |
//+------------------------------------------------------------------+
uint CTextBox::MaxLineWidth(void)
  {
   uint max_line_width=0;
//--- Получим размер массива строк
   uint lines_total=::ArraySize(m_lines);
   for(uint i=0; i<lines_total; i++)
     {
      //--- Получим размер массива символов
      uint symbols_total=::ArraySize(m_lines[i].m_symbol);
      //--- Получим ширину строки
      uint line_width=LineWidth(symbols_total,i);
      //--- Сохраним максимальную ширину
      if(line_width>max_line_width)
         max_line_width=line_width;
     }
//--- Вернуть максимальную ширину строки
   return(max_line_width);
  }
//+------------------------------------------------------------------+
//| Смещает строки на одну позицию вверх                             |
//+------------------------------------------------------------------+
void CTextBox::ShiftOnePositionUp(void)
  {
//--- Если включен перенос слов
   if(m_word_wrap_mode)
     {
      //--- Индекс предыдущей строки
      uint prev_line_index=m_text_cursor_y_pos-1;
      //--- Получим размер массива символов
      uint symbols_total=::ArraySize(m_lines[prev_line_index].m_symbol);
      //--- Если предыдущая строка имеет признак окончания
      if(m_lines[prev_line_index].m_end_of_line)
        {
         //--- (1) Уберём признак окончания и (2) переместим текстовый курсор в конец строки
         m_lines[prev_line_index].m_end_of_line=false;
         SetTextCursor(symbols_total,prev_line_index);
        }
      else
        {
         //--- (1) Переместим текстовый курсор в конец строки и (2) удалим символ
         SetTextCursor(symbols_total,prev_line_index);
         DeleteSymbol();
        }
      return;
     }
//--- Получим размер массива строк
   uint lines_total=::ArraySize(m_lines);
//--- Получим размер массива символов
   uint symbols_total=::ArraySize(m_lines[m_text_cursor_y_pos].m_symbol);
//--- Если есть символы в этой строке, запомним их, чтобы добавить к предыдущей строке
   m_temp_input_string=(symbols_total>0)? CollectString(m_text_cursor_y_pos) : "";
//--- Сместим строки от следующего элемента на одну строку вверх
   MoveLines(m_text_cursor_y_pos,lines_total-1,1,false);
//--- Установим новый размер массиву строк
   ::ArrayResize(m_lines,lines_total-1);
//--- Уменьшим счётчик строк
   m_text_cursor_y_pos--;
//--- Получим размер массива символов
   symbols_total=::ArraySize(m_lines[m_text_cursor_y_pos].m_symbol);
//--- Переместим курсор в конец
   m_text_cursor_x_pos=symbols_total;
//--- Получим X-координату курсора
   CalculateTextCursorX();
//--- Если есть строка, которую нужно добавить к предыдущей
   if(m_temp_input_string!="")
      AddToString(m_text_cursor_y_pos,m_temp_input_string);
  }
//+------------------------------------------------------------------+
//| Смещает строки на одну позицию вниз                              |
//+------------------------------------------------------------------+
void CTextBox::ShiftOnePositionDown(void)
  {
//--- Получим размер массива строк
   uint lines_total=::ArraySize(m_lines);
//--- Увеличим массив на один элемент
   uint new_size=lines_total+1;
   ::ArrayResize(m_lines,new_size);
//--- Сместим строки от текущей позиции на один пункт вниз (начиная с конца массива)
   MoveLines(lines_total,m_text_cursor_y_pos+1,1);
//--- Перенесём текст на новую строку
   WrapTextToNewLine(m_text_cursor_y_pos,m_text_cursor_x_pos,true);
  }
//+------------------------------------------------------------------+
//| Проверка наличия выделенного текста                              |
//+------------------------------------------------------------------+
bool CTextBox::CheckSelectedText(const uint line_index,const uint symbol_index)
  {
   bool is_selected_text=false;
//--- Выйти, если нет выделенного текста
   if(m_selected_line_from==WRONG_VALUE)
      return(false);
//--- Если начальный индекс на строке ниже
   if(m_selected_line_from>m_selected_line_to)
     {
      //--- Конечная строка и символ справа от конечного выделенного
      if((int)line_index==m_selected_line_to && (int)symbol_index>=m_selected_symbol_to)
        { is_selected_text=true; }
      //--- Начальная строка и символ слева от начального выделенного
      else if((int)line_index==m_selected_line_from && (int)symbol_index<m_selected_symbol_from)
        { is_selected_text=true; }
      //--- Промежуточная строка (выделяются все символы)
      else if((int)line_index>m_selected_line_to && (int)line_index<m_selected_line_from)
        { is_selected_text=true; }
     }
//--- Если начальный индекс на строке выше
   else if(m_selected_line_from<m_selected_line_to)
     {
      //--- Конечная строка и символ слева от конечного выделенного
      if((int)line_index==m_selected_line_to && (int)symbol_index<m_selected_symbol_to)
        { is_selected_text=true; }
      //--- Начальная строка и символ справа от начального выделенного
      else if((int)line_index==m_selected_line_from && (int)symbol_index>=m_selected_symbol_from)
        { is_selected_text=true; }
      //--- Промежуточная строка (выделяются все символы)
      else if((int)line_index<m_selected_line_to && (int)line_index>m_selected_line_from)
        { is_selected_text=true; }
     }
//--- Если начальный и конечный индекс на одной строке
   else
     {
      //--- Нашли проверяемую строку
      if((int)line_index>=m_selected_line_to && (int)line_index<=m_selected_line_from)
        {
         //--- Если смещение курсора вправо и символ в выделенном диапазоне
         if(m_selected_symbol_from>m_selected_symbol_to)
           {
            if((int)symbol_index>=m_selected_symbol_to && (int)symbol_index<m_selected_symbol_from)
               is_selected_text=true;
           }
         //--- Если смещение курсора влево и символ в выделенном диапазоне
         else
           {
            if((int)symbol_index>=m_selected_symbol_from && (int)symbol_index<m_selected_symbol_to)
               is_selected_text=true;
           }
        }
     }
//--- Вернуть результат
   return(is_selected_text);
  }
//+------------------------------------------------------------------+
//| Проверка на наличие обязательной первой строки                   |
//+------------------------------------------------------------------+
uint CTextBox::CheckFirstLine(void)
  {
//--- Получим размер массива строк
   uint lines_total=::ArraySize(m_lines);
//--- Если нет ни одной строки, устанавливаем размер массивам структуры
   if(lines_total<1)
      ::ArrayResize(m_lines,++lines_total);
//--- Вернуть количество строк
   return(lines_total);
  }
//+------------------------------------------------------------------+
//| Устанавливает новый размер массивам свойств указанной строки     |
//+------------------------------------------------------------------+
void CTextBox::ArraysResize(const uint line_index,const uint new_size)
  {
//--- Получим размер массива строк
   uint lines_total=::ArraySize(m_lines);
//--- Предотвращение выхода из диапазона
   uint l=(line_index<lines_total)? line_index : lines_total-1;
//--- Резервный размер массива
   int reserve_size=100;
//--- Устанавливаем размер массивам структуры
   ::ArrayResize(m_lines[line_index].m_symbol,new_size,reserve_size);
   ::ArrayResize(m_lines[line_index].m_width,new_size,reserve_size);
  }
//+------------------------------------------------------------------+
//| Делает копию указанной (source) строки в новое место (dest.)     |
//+------------------------------------------------------------------+
void CTextBox::LineCopy(const uint destination,const uint source)
  {
   ::ArrayCopy(m_lines[destination].m_width,m_lines[source].m_width);
   ::ArrayCopy(m_lines[destination].m_symbol,m_lines[source].m_symbol);
   m_lines[destination].m_end_of_line=m_lines[source].m_end_of_line;
  }
//+------------------------------------------------------------------+
//| Очищает указанную строку                                         |
//+------------------------------------------------------------------+
void CTextBox::ClearLine(const uint line_index)
  {
   ::ArrayFree(m_lines[line_index].m_symbol);
   ::ArrayFree(m_lines[line_index].m_width);
  }
//+------------------------------------------------------------------+
//| Перемещение текстового курсора в указанном направлении           |
//+------------------------------------------------------------------+
void CTextBox::MoveTextCursor(const ENUM_MOVE_TEXT_CURSOR direction)
  {
   switch(direction)
     {
      //--- Переместить курсор на один символ влево
      case TO_NEXT_LEFT_SYMBOL  : MoveTextCursorToLeft();        break;
      //--- Переместить курсор на один символ вправо
      case TO_NEXT_RIGHT_SYMBOL : MoveTextCursorToRight();       break;
      //--- Переместить курсор на одно слово влево
      case TO_NEXT_LEFT_WORD    : MoveTextCursorToLeft(true);    break;
      //--- Переместить курсор на одно слово вправо
      case TO_NEXT_RIGHT_WORD   : MoveTextCursorToRight(true);   break;
      //--- Переместить курсор на одну строку вверх
      case TO_NEXT_UP_LINE      : MoveTextCursorToUp();          break;
      //--- Переместить курсор на одну строку вниз
      case TO_NEXT_DOWN_LINE    : MoveTextCursorToDown();        break;
      //--- Переместить курсор в начало текущей строки
      case TO_BEGIN_LINE : SetTextCursor(0,m_text_cursor_y_pos); break;
      //--- Переместить курсор в конец текущей строки
      case TO_END_LINE :
        {
         //--- Получим количество символов в текущей строке
         uint symbols_total=::ArraySize(m_lines[m_text_cursor_y_pos].m_symbol);
         //--- Переместить курсор
         SetTextCursor(symbols_total,m_text_cursor_y_pos);
         break;
        }
      //--- Переместить курсор в начало первой строки
      case TO_BEGIN_FIRST_LINE : SetTextCursor(0,0); break;
      //--- Переместить курсор в конец последней строки
      case TO_END_LAST_LINE :
        {
         //--- Получим количество строк и символов в последней строке
         uint lines_total   =::ArraySize(m_lines);
         uint symbols_total =::ArraySize(m_lines[lines_total-1].m_symbol);
         //--- Переместить курсор
         SetTextCursor(symbols_total,lines_total-1);
         break;
        }
     }
  }
//+------------------------------------------------------------------+
//| Перемещение текстового курсора в указанном направлении и         |
//| с условием                                                       |
//+------------------------------------------------------------------+
void CTextBox::MoveTextCursor(const ENUM_MOVE_TEXT_CURSOR direction,const bool with_highlighted_text)
  {
//--- Если только перемещение текстового курсора
   if(!with_highlighted_text)
     {
      //--- Сброс выделения
      ResetSelectedText();
      //--- Переместить курсор в начало первой строки
      MoveTextCursor(direction);
     }
//--- Если с выделением текста
   else
     {
      //--- Установить начальные индексы для выделенния текста
      SetStartSelectedTextIndexes();
      //--- Сместить текстовый курсор на один символ
      MoveTextCursor(direction);
      //--- Установить конечные индексы для выделения текста
      SetEndSelectedTextIndexes();
     }
//--- Корректируем полосы прокрутки
   CorrectingHorizontalScrollThumb();
   CorrectingVerticalScrollThumb();
//--- Обновить текст в поле ввода
   DrawTextAndCursor(true);
//--- Отправим сообщение об этом
   ::EventChartCustom(m_chart_id,ON_MOVE_TEXT_CURSOR,CElementBase::Id(),CElementBase::Index(),TextCursorInfo());
  }
//+------------------------------------------------------------------+
//| Перемещение текстового курсора влево                             |
//+------------------------------------------------------------------+
void CTextBox::MoveTextCursorToLeft(const bool to_next_word=false)
  {
//--- Если перейти к следующему символу
   if(!to_next_word)
     {
      //--- Если позиция текстового курсора больше нуля
      if(m_text_cursor_x_pos>0)
        {
         //--- Сместим его на предыдущий символ
         m_text_cursor_x-=m_lines[m_text_cursor_y_pos].m_width[m_text_cursor_x_pos-1];
         //--- Уменьшим счётчик символов
         m_text_cursor_x_pos--;
        }
      else
        {
         //--- Если это не первая строка
         if(m_text_cursor_y_pos>0)
           {
            //--- Перейдём в конец предыдущей строки
            m_text_cursor_y_pos--;
            CorrectingTextCursorXPos();
           }
        }
      return;
     }
//--- Получим размер массива строк
   uint lines_total=::ArraySize(m_lines);
//--- Получим количество символов в текущей строке
   uint symbols_total=::ArraySize(m_lines[m_text_cursor_y_pos].m_symbol);
//--- Если курсор в начале текущей строки и это не первая строка,
//    переместим курсор в конец предыдущей строки
   if(m_text_cursor_x_pos==0 && m_text_cursor_y_pos>0)
     {
      //--- Получим индекс предыдущей строки
      uint prev_line_index=m_text_cursor_y_pos-1;
      //--- Получим количество символов предыдущей строки
      symbols_total=::ArraySize(m_lines[prev_line_index].m_symbol);
      //--- Переместим курсор в конец предыдущей строки
      SetTextCursor(symbols_total,prev_line_index);
     }
//--- Если курсор не в начале текущей строки или курсор на первой строке
   else
     {
      //--- Найдём начало непрерывной последовательности символов (справа налево)
      for(uint i=m_text_cursor_x_pos; i<=symbols_total; i--)
        {
         //--- Перейти к следующему, если курсор в конце строки
         if(i==symbols_total)
            continue;
         //--- Если это первый символ строки
         if(i==0)
           {
            //--- Установим курсор в начало строки
            SetTextCursor(0,m_text_cursor_y_pos);
            break;
           }
         //--- Если это не первый символ строки
         else
           {
            //--- Если нашли начало непрерывной последовательности, на которой впервые.
            //    Началом считается пробел на следующем индексе.
            if(i!=m_text_cursor_x_pos && 
               m_lines[m_text_cursor_y_pos].m_symbol[i]!=SPACE && 
               m_lines[m_text_cursor_y_pos].m_symbol[i-1]==SPACE)
              {
               //--- Установим курсор в начало новой непрерывной последовательности
               SetTextCursor(i,m_text_cursor_y_pos);
               break;
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| Перемещение текстового курсора на один символ вправо             |
//+------------------------------------------------------------------+
void CTextBox::MoveTextCursorToRight(const bool to_next_word=false)
  {
//--- Если перейти к следующему символу
   if(!to_next_word)
     {
      //--- Получим размер массива символов
      uint symbols_total=::ArraySize(m_lines[m_text_cursor_y_pos].m_width);
      //--- Если это не конец строки
      if(m_text_cursor_x_pos<symbols_total)
        {
         //--- Сместим позицию текстового курсора на следующий символ
         m_text_cursor_x+=m_lines[m_text_cursor_y_pos].m_width[m_text_cursor_x_pos];
         //--- Увеличим счётчик символов
         m_text_cursor_x_pos++;
        }
      else
        {
         //--- Получим размер массива строк
         uint lines_total=::ArraySize(m_lines);
         //--- Если это не последняя строка
         if(m_text_cursor_y_pos<lines_total-1)
           {
            //--- Переместить курсор в начало следующей строки
            m_text_cursor_x=m_text_x_offset;
            SetTextCursor(0,++m_text_cursor_y_pos);
           }
        }
      return;
     }
//--- Получим размер массива строк
   uint lines_total=::ArraySize(m_lines);
//--- Получим количество символов в текущей строке
   uint symbols_total=::ArraySize(m_lines[m_text_cursor_y_pos].m_symbol);
//--- Если курсор в конце строки и это не последняя строка, переместим курсор в начало следующей строки
   if(m_text_cursor_x_pos==symbols_total && m_text_cursor_y_pos<lines_total-1)
     {
      SetTextCursor(0,m_text_cursor_y_pos+1);
     }
//--- Если курсор не в конце строки или это последняя строка
   else
     {
      //--- Найдём начало непрерывной последовательности символов (слева направо)
      for(uint i=m_text_cursor_x_pos; i<=symbols_total; i++)
        {
         //--- Если это первый символ, перейти к следующему
         if(i==0)
            continue;
         //--- Если дошли до конца строки, переместить курсор в конец
         if(i>=symbols_total-1)
           {
            SetTextCursor(symbols_total,m_text_cursor_y_pos);
            break;
           }
         //--- Если нашли начало непрерывной последовательности, на которой впервые.
         //    Началом считается пробел на предыдущем индексе.
         if(i!=m_text_cursor_x_pos && 
            m_lines[m_text_cursor_y_pos].m_symbol[i]!=SPACE && 
            m_lines[m_text_cursor_y_pos].m_symbol[i-1]==SPACE)
           {
            //--- Установим курсор в конец новой непрерывной последовательности
            SetTextCursor(i,m_text_cursor_y_pos);
            break;
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| Перемещение текстового курсора на одну строку вверх              |
//+------------------------------------------------------------------+
void CTextBox::MoveTextCursorToUp(void)
  {
//--- Получим размер массива строк
   uint lines_total=::ArraySize(m_lines);
//--- Если не выходим за пределы массива
   if(m_text_cursor_y_pos-1<lines_total)
     {
      //--- Переход на предыдущую строку
      m_text_cursor_y_pos--;
      //--- Корректировка текстового курсора по оси X
      CorrectingTextCursorXPos(m_text_cursor_x_pos);
     }
  }
//+------------------------------------------------------------------+
//| Перемещение текстового курсора на одну строку вниз               |
//+------------------------------------------------------------------+
void CTextBox::MoveTextCursorToDown(void)
  {
   uint lines_total=::ArraySize(m_lines);
//--- Если не выходим за пределы массива
   if(m_text_cursor_y_pos+1<lines_total)
     {
      //--- Переход на следующую строку
      m_text_cursor_y_pos++;
      //--- Корректировка текстового курсора по оси X
      CorrectingTextCursorXPos(m_text_cursor_x_pos);
     }
  }
//+------------------------------------------------------------------+
//| Устанавливает курсор по указанным позициям                       |
//+------------------------------------------------------------------+
void CTextBox::SetTextCursor(const uint x_pos,const uint y_pos)
  {
   m_text_cursor_x_pos=x_pos;
   m_text_cursor_y_pos=(!m_multi_line_mode)? 0 : y_pos;
  }
//+------------------------------------------------------------------+
//| Устанавливает курсор по указанным позициям по курсору мыши       |
//+------------------------------------------------------------------+
void CTextBox::SetTextCursorByMouseCursor(void)
  {
//--- Определим координаты на поле ввода под курсором мыши
   int x =m_mouse.RelativeX(m_textbox);
   int y =m_mouse.RelativeY(m_textbox);
//--- Получим высоту строки
   int line_height=(int)LineHeight();
//--- Получим размер массива строк
   uint lines_total=::ArraySize(m_lines);
//--- Определим символ нажатия
   for(uint l=0; l<lines_total; l++)
     {
      //--- Зададим начальные координаты для проверки условия
      int x_offset=m_text_x_offset;
      int y_offset=m_text_y_offset+((int)l*line_height);
      //--- Проверка условия по оси Y
      bool y_pos_check=(l<lines_total-1)?(y>=y_offset && y<y_offset+line_height) : y>=y_offset;
      //--- Если нажатие было не на этой строке, перейти к следующей
      if(!y_pos_check)
         continue;
      //--- Получим размер массива символов
      uint symbols_total=::ArraySize(m_lines[l].m_width);
      //--- Если это пустая строка, переместить курсор на указанную позицию и выйти из цикла
      if(symbols_total<1)
        {
         SetTextCursor(0,l);
         HorizontalScrolling(0);
         break;
        }
      //--- Найдём символ, на который нажали
      for(uint s=0; s<symbols_total; s++)
        {
         //--- Если нашли символ, переместить курсор на указанную позицию и выйти из цикла
         if(x>=x_offset && x<x_offset+m_lines[l].m_width[s])
           {
            SetTextCursor(s,l);
            l=lines_total;
            break;
           }
         //--- Прибавить ширину текущего символа для следующей проверки
         x_offset+=m_lines[l].m_width[s];
         //--- Если это последний символ, переместим курсор в конец строки и выйдем из цикла
         if(s==symbols_total-1 && x>x_offset)
           {
            SetTextCursor(s+1,l);
            l=lines_total;
            break;
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| Корректировка текстового курсора по оси X                        |
//+------------------------------------------------------------------+
void CTextBox::CorrectingTextCursorXPos(const int x_pos=WRONG_VALUE)
  {
//--- Получим размер массива символов
   uint symbols_total=::ArraySize(m_lines[m_text_cursor_y_pos].m_width);
//--- Опеределим позицию курсора
   uint text_cursor_x_pos=0;
//--- Если позиция указана
   if(x_pos!=WRONG_VALUE)
      text_cursor_x_pos=(x_pos>(int)symbols_total-1)? symbols_total : x_pos;
//--- Если позиция не указана, то установим курсор в конец строки
   else
      text_cursor_x_pos=symbols_total;
//--- Нулевая позиция, если в строке нет символов
   m_text_cursor_x_pos=(symbols_total<1)? 0 : text_cursor_x_pos;
//--- Получим X-координату курсора
   CalculateTextCursorX();
  }
//+------------------------------------------------------------------+
//| Расчёт X-координаты для текстового курсора                       |
//+------------------------------------------------------------------+
void CTextBox::CalculateTextCursorX(void)
  {
//--- Получим ширину строки
   int line_width=(int)LineWidth(m_text_cursor_x_pos,m_text_cursor_y_pos);
//--- Рассчитать и сохранить X-координату курсора
   m_text_cursor_x=m_text_x_offset+line_width;
  }
//+------------------------------------------------------------------+
//| Расчёт Y-координаты для текстового курсора                       |
//+------------------------------------------------------------------+
void CTextBox::CalculateTextCursorY(void)
  {
//--- Получим высоту строки
   int line_height=(int)LineHeight();
//--- Получим Y-координату курсора
   m_text_cursor_y=m_text_y_offset+int(line_height*m_text_cursor_y_pos);
  }
//+------------------------------------------------------------------+
//| Расчёт границ поля ввода по двум осям                            |
//+------------------------------------------------------------------+
void CTextBox::CalculateBoundaries(void)
  {
   CalculateXBoundaries();
   CalculateYBoundaries();
  }
//+------------------------------------------------------------------+
//| Расчёт границ поля ввода по оси X                                |
//+------------------------------------------------------------------+
void CTextBox::CalculateXBoundaries(void)
  {
//--- Получим X-координату и смещение по оси X
   int x       =(int)::ObjectGetInteger(m_chart_id,m_textbox.ChartObjectName(),OBJPROP_XDISTANCE);
   int xoffset =(int)::ObjectGetInteger(m_chart_id,m_textbox.ChartObjectName(),OBJPROP_XOFFSET);
//--- Рассчитаем границы видимой части поля ввода
   m_x_limit  =(x+xoffset)-x;
   m_x2_limit =(m_multi_line_mode)? (x+xoffset+m_x_size-m_scrollv.ScrollWidth()-m_text_x_offset)-x : (x+xoffset+m_x_size-m_text_x_offset)-x;
  }
//+------------------------------------------------------------------+
//| Расчёт границ поля ввода по оси Y                                |
//+------------------------------------------------------------------+
void CTextBox::CalculateYBoundaries(void)
  {
//--- Выйти, если отключен многострочный режим
   if(!m_multi_line_mode)
      return;
//--- Получим Y-координату и смещение по оси Y
   int y       =(int)::ObjectGetInteger(m_chart_id,m_textbox.ChartObjectName(),OBJPROP_YDISTANCE);
   int yoffset =(int)::ObjectGetInteger(m_chart_id,m_textbox.ChartObjectName(),OBJPROP_YOFFSET);
//--- Рассчитаем границы видимой части поля ввода
   m_y_limit  =(y+yoffset)-y;
   m_y2_limit =(y+yoffset+m_y_size-m_scrollh.ScrollWidth())-y;
  }
//+------------------------------------------------------------------+
//| Расчёт X-координаты полосы прокрутки в левой границе поля ввода  |
//+------------------------------------------------------------------+
int CTextBox::CalculateScrollThumbX(void)
  {
   return(m_text_cursor_x-m_text_x_offset);
  }
//+------------------------------------------------------------------+
//| Расчёт X-координаты полосы прокрутки в правой границе поля ввода |
//+------------------------------------------------------------------+
int CTextBox::CalculateScrollThumbX2(void)
  {
   return((m_multi_line_mode)? m_text_cursor_x-m_x_size+m_scrollv.ScrollWidth()+m_text_x_offset : m_text_cursor_x-m_x_size+m_text_x_offset*2);
  }
//+------------------------------------------------------------------+
//| Расчёт X-позиции ползунка полосы прокрутки                       |
//+------------------------------------------------------------------+
int CTextBox::CalculateScrollPosX(const bool to_right=false)
  {
   int    calc_x      =(!to_right)? CalculateScrollThumbX() : CalculateScrollThumbX2();
   double pos_x_value =(calc_x-::fmod((double)calc_x,(double)m_shift_x_step))/m_shift_x_step+((!to_right)? 0 : 1);
//---
   return((int)pos_x_value);
  }
//+------------------------------------------------------------------+
//| Расчёт Y-координаты полосы прокрутки в верхней границе поля ввода|
//+------------------------------------------------------------------+
int CTextBox::CalculateScrollThumbY(void)
  {
   return(m_text_cursor_y-m_text_y_offset);
  }
//+------------------------------------------------------------------+
//| Расчёт Y-координаты полосы прокрутки в нижней границе поля ввода |
//+------------------------------------------------------------------+
int CTextBox::CalculateScrollThumbY2(void)
  {
//--- Установим шрифт для отображения на холсте (нужно, чтобы получить высоту строки)
   m_textbox.FontSet(CElement::Font(),-CElement::FontSize()*10,FW_NORMAL);
//--- Получим высоту строки
   int line_height=m_textbox.TextHeight("|");
//--- Рассчитать и вернуть значение
   return(m_text_cursor_y-m_y_size+m_scrollh.ScrollWidth()+m_text_y_offset+line_height);
  }
//+------------------------------------------------------------------+
//| Расчёт Y-позиции ползунка полосы прокрутки                       |
//+------------------------------------------------------------------+
int CTextBox::CalculateScrollPosY(const bool to_down=false)
  {
   int    calc_y      =(!to_down)? CalculateScrollThumbY() : CalculateScrollThumbY2();
   double pos_y_value =(calc_y-::fmod((double)calc_y,(double)LineHeight()))/LineHeight()+((!to_down)? 0 : 1);
//---
   return((int)pos_y_value);
  }
//+------------------------------------------------------------------+
//| Корректировка горизонтальной полосы прокрутки                    |
//+------------------------------------------------------------------+
void CTextBox::CorrectingHorizontalScrollThumb(void)
  {
//--- Получим границы видимой части поля ввода
   CalculateXBoundaries();
//--- Получим X-координату курсора
   CalculateTextCursorX();
//--- Если текстовый курсор вышел из поля видимости влево
   if(m_text_cursor_x<=m_x_limit)
     {
      HorizontalScrolling(CalculateScrollPosX());
     }
//--- Если текстовый курсор вышел из поля видимости вправо
   else if(m_text_cursor_x>=m_x2_limit)
     {
      HorizontalScrolling(CalculateScrollPosX(true));
     }
  }
//+------------------------------------------------------------------+
//| Корректировка вертикальной полосы прокрутки                      |
//+------------------------------------------------------------------+
void CTextBox::CorrectingVerticalScrollThumb(void)
  {
//--- Получим границы видимой части поля ввода
   CalculateYBoundaries();
//--- Получим Y-координату курсора
   CalculateTextCursorY();
//--- Если текстовый курсор вышел из поля видимости вверх
   if(m_text_cursor_y<=m_y_limit)
     {
      VerticalScrolling(CalculateScrollPosY());
     }
//--- Если текстовый курсор вышел из поля видимости вниз
   else if(m_text_cursor_y+(int)LineHeight()>=m_y2_limit)
     {
      VerticalScrolling(CalculateScrollPosY(true));
     }
  }
//+------------------------------------------------------------------+
//| Рассчитывает размеры текстового поля ввода                       |
//+------------------------------------------------------------------+
void CTextBox::CalculateTextBoxSize(void)
  {
   CalculateTextBoxXSize();
   CalculateTextBoxYSize();
  }
//+------------------------------------------------------------------+
//| Рассчитывает ширину текстового поля ввода                        |
//+------------------------------------------------------------------+
bool CTextBox::CalculateTextBoxXSize(void)
  {
//--- Запомним текущие размеры
   int area_x_size_curr=m_area_x_size;
//--- Получим максимальную ширину строки из текстового поля ввода
   int max_line_width=int((m_text_x_offset*2)+MaxLineWidth()+m_scrollv.ScrollWidth());
//--- Определим общую ширину
   m_area_x_size=(max_line_width>m_x_size)? max_line_width : m_x_size;
//--- Определим видимую ширину
   m_area_visible_x_size=m_x_size-2;
//--- Сохраним ограничение по смещению
   m_shift_x2_limit=m_area_x_size-m_area_visible_x_size;
//--- Признак того, что размеры не изменились
   if(area_x_size_curr==m_area_x_size)
      return(false);
//--- Признак того, что размеры были изменились
   return(true);
  }
//+------------------------------------------------------------------+
//| Рассчитывает высоту текстового поля ввода                        |4
//+------------------------------------------------------------------+
bool CTextBox::CalculateTextBoxYSize(void)
  {
//--- Запомним текущие размеры
   int area_y_size_curr=m_area_y_size;
//--- Получим высоту строки
   int line_height=(int)LineHeight();
//--- Получим размер массива строк
   int lines_total=::ArraySize(m_lines);
//--- Рассчитаем общую высоту элемента
   int lines_height=int((m_text_y_offset*2)+(line_height*lines_total)+m_scrollh.ScrollWidth());//*2);
//--- Определим общую высоту
   m_area_y_size=(m_multi_line_mode && lines_height>m_y_size)? lines_height : m_y_size;
//--- Определим видимую высоту
   m_area_visible_y_size=m_y_size-2;
//--- Сохраним ограничение по смещению
   m_shift_y2_limit=m_area_y_size-m_area_visible_y_size;
//--- Признак того, что размеры не изменились
   if(area_y_size_curr==m_area_y_size)
      return(false);
//--- Признак того, что размеры были изменились
   return(true);
  }
//+------------------------------------------------------------------+
//| Изменить основные размеры элемента                               |
//+------------------------------------------------------------------+
void CTextBox::ChangeMainSize(const int x_size,const int y_size)
  {
//--- Установить новый размер
   CElementBase::XSize(x_size);
   CElementBase::YSize(y_size);
   m_canvas.XSize(m_x_size);
   m_canvas.YSize(m_y_size);
   m_canvas.Resize(m_x_size,m_y_size);
  }
//+------------------------------------------------------------------+
//| Изменить размеры поля ввода                                      |
//+------------------------------------------------------------------+
void CTextBox::ChangeTextBoxSize(const bool is_x_offset=false,const bool is_y_offset=false)
  {
//--- Установить новый размер таблице
   m_textbox.XSize(m_area_x_size);
   m_textbox.YSize(m_area_y_size);
   m_textbox.Resize(m_area_x_size,m_area_y_size);
//--- Установим размеры видимой области
   ::ObjectSetInteger(m_chart_id,m_textbox.ChartObjectName(),OBJPROP_XSIZE,m_area_visible_x_size);
   ::ObjectSetInteger(m_chart_id,m_textbox.ChartObjectName(),OBJPROP_YSIZE,m_area_visible_y_size);
//--- Разница между общей шириной и видимой частью
   int x_different =m_area_x_size-m_area_visible_x_size;
   int y_different =m_area_y_size-m_area_visible_y_size;
//--- Зададим смещение фрейма внутри изображения по осям X и Y
   int x_offset  =(int)::ObjectGetInteger(m_chart_id,m_textbox.ChartObjectName(),OBJPROP_XOFFSET);
   int y_offset  =(int)::ObjectGetInteger(m_chart_id,m_textbox.ChartObjectName(),OBJPROP_YOFFSET);
   int x_offset2 =(!is_x_offset)? 0 : (x_offset<=x_different)? x_offset : x_different;
   int y_offset2 =(!is_y_offset)? 0 : (y_offset<=y_different)? y_offset : y_different;
   ::ObjectSetInteger(m_chart_id,m_textbox.ChartObjectName(),OBJPROP_XOFFSET,x_offset2);
   ::ObjectSetInteger(m_chart_id,m_textbox.ChartObjectName(),OBJPROP_YOFFSET,y_offset2);
//--- Изменить размеры полос прокрутки
   ChangeScrollsSize();
//--- Перенос по словам
   WordWrap();
//--- Корректировка данных
   ShiftData();
  }
//+------------------------------------------------------------------+
//| Изменить размеры полос прокрутки                                 |
//+------------------------------------------------------------------+
void CTextBox::ChangeScrollsSize(void)
  {
//--- Расчёт количества шагов для смещения
   uint x_size_total         =m_area_x_size/m_shift_x_step;
   uint visible_x_size_total =m_area_visible_x_size/m_shift_x_step;
   uint y_size_total         =LinesTotal()+1;
   uint visible_y_size_total =VisibleLinesTotal();
//--- Рассчитать размеры полос прокрутки
   m_scrollh.Reinit(x_size_total,visible_x_size_total);
   m_scrollv.Reinit(y_size_total,visible_y_size_total);
//--- Выйти, если это однострочное поле ввода
   if(!m_multi_line_mode)
      return;
//--- Если (1) горизонтальная полоса прокрутки не нужна или (2) включен перенос по словам
   if(!m_scrollh.IsScroll() || m_word_wrap_mode)
     {
      HorizontalScrolling(0);
      //--- Скрыть горизонтальную полосу прокрутки
      m_scrollh.Hide();
      //--- Изменить высоту вертикальной полосы прокрутки
      if(m_multi_line_mode)
         m_scrollv.ChangeYSize(CElementBase::YSize()-2);
     }
   else
     {
      //--- Показать горизонтальную полосу прокрутки
      if(CElementBase::IsVisible())
        {
         m_scrollh.Show();
         m_scrollh.GetIncButtonPointer().Show();
         m_scrollh.GetDecButtonPointer().Show();
         //--- Отправим сообщение об изменении в графическом интерфейсе
         ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
        }
      //--- Рассчитать и изменить высоту вертикальной полосы прокрутки
      if(m_multi_line_mode)
         m_scrollv.ChangeYSize(CElementBase::YSize()-m_scrollh.ScrollWidth()-2);
     }
//--- Если вертикальная полоса прокрутки не нужна
   if(!m_scrollv.IsScroll())
     {
      VerticalScrolling(0);
      //--- Скрыть вертикальную полосу прокрутки
      m_scrollv.Hide();
      //--- Изменить ширину горизонтальной полосы прокрутки, если отключен перенос по словам
      if(!m_word_wrap_mode)
         m_scrollh.ChangeXSize(CElementBase::XSize()-1);
     }
   else
     {
      //--- Показать вертикальную полосу прокрутки
      if(CElementBase::IsVisible())
        {
         m_scrollv.Show();
         m_scrollv.GetIncButtonPointer().Show();
         m_scrollv.GetDecButtonPointer().Show();
         //--- Отправим сообщение об изменении в графическом интерфейсе
         ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
        }
      //--- Изменить ширину горизонтальной полосы прокрутки, если отключен перенос по словам
      if(!m_word_wrap_mode)
         m_scrollh.ChangeXSize(CElementBase::XSize()-m_scrollh.ScrollWidth()-1);
     }
  }
//+------------------------------------------------------------------+
//| Перенос по словам                                                |
//+------------------------------------------------------------------+
void CTextBox::WordWrap(void)
  {
//--- Выйти, если режимы (1) многострочного поля ввода или (2) переноса по словам отключены
   if(!m_multi_line_mode || !m_word_wrap_mode)
      return;
//--- Получим размер массива строк
   uint lines_total=::ArraySize(m_lines);
//--- Проверим, нужно ли выровнять текст по ширине поля ввода
   for(uint i=0; i<lines_total; i++)
     {
      //--- Для определения первых видимых индексов (1) символа и (2) пробела
      int symbol_index =WRONG_VALUE;
      int space_index  =WRONG_VALUE;
      //--- Индекс следующей строки
      uint next_line_index=i+1;
      //--- Если строка не помещается, то перенесём часть текущей строки на новую строку
      if(CheckForOverflow(i,symbol_index,space_index))
        {
         //--- Если пробел найден, то он переносится не будет
         if(space_index!=WRONG_VALUE)
            space_index++;
         //--- Увеличим массив строк на один элемент
         ::ArrayResize(m_lines,++lines_total);
         //--- Сместим строки от текущей позиции на один пункт вниз
         MoveLines(lines_total-1,next_line_index,1);
         //--- Проверим индекс символа, от которого будет перенос текста
         int check_index=(space_index==WRONG_VALUE && symbol_index!=WRONG_VALUE)? symbol_index : space_index;
         //--- Перенесём текст на новую строку
         WrapTextToNewLine(i,check_index);
        }
      //--- Если строка помещается, то проверим, не нужно ли осуществить обратный перенос
      else
        {
         //--- Пропускаем, если (1) это строка с окончанием или (2) это последняя строка
         if(m_lines[i].m_end_of_line || next_line_index>=lines_total)
            continue;
         //--- Определим количество символов для переноса
         uint wrap_symbols_total=0;
         //--- Если нужно перенести оставшийся текст следующей строки на текущую
         if(WrapSymbolsTotal(i,wrap_symbols_total))
           {
            WrapTextToPrevLine(next_line_index,wrap_symbols_total,true);
            //--- Обновить размер массива для дальнейшего использования в цикле
            lines_total=::ArraySize(m_lines);
            //--- Шаг назад, чтобы избежать пропуск строки для следующей проверки
            i--;
           }
         //--- Перенести только то, что помещается
         else
            WrapTextToPrevLine(next_line_index,wrap_symbols_total);
        }
     }
  }
//+------------------------------------------------------------------+
//| Проверка на переполнение строки                                  |
//+------------------------------------------------------------------+
bool CTextBox::CheckForOverflow(const uint line_index,int &symbol_index,int &space_index)
  {
//--- Получим размер массива символов
   uint symbols_total=::ArraySize(m_lines[line_index].m_symbol);
//--- Отступы
   uint x_offset_plus=m_text_x_offset+m_scrollv.XSize();
//--- Получим полную ширину строки
   uint full_line_width=LineWidth(symbols_total,line_index)+x_offset_plus;
//--- Если ширина этой строки помещается в поле
   if(full_line_width<(uint)m_area_visible_x_size)
      return(false);
//--- Определим индексы символов переполнения
   for(uint s=symbols_total-1; s>0; s--)
     {
      //--- Получим (1) ширину подстроки от начала до текущего символа и (2) символ
      uint   line_width =LineWidth(s,line_index)+x_offset_plus;
      string symbol     =m_lines[line_index].m_symbol[s];
      //--- Если ещё не нашли видимый символ
      if(symbol_index==WRONG_VALUE)
        {
         //--- Если ширина подстроки помещается в область поля ввода, запомним индекс символа
         if(line_width<(uint)m_area_visible_x_size)
            symbol_index=(int)s;
         //--- Перейти к следующему символу
         continue;
        }
      //--- Если это пробел, запомним его индекс и остановим цикл
      if(symbol==SPACE)
        {
         space_index=(int)s;
         break;
        }
     }
//--- Выполнение условия означает, что строка не помещается
   bool is_overflow=(symbol_index!=WRONG_VALUE || space_index!=WRONG_VALUE);
//--- Вернуть результат
   return(is_overflow);
  }
//+------------------------------------------------------------------+
//| Возвращает количество слов в указанной строке                    |
//+------------------------------------------------------------------+
uint CTextBox::WordsTotal(const uint line_index)
  {
//--- Получим размер массива строк
   uint lines_total=::ArraySize(m_lines);
//--- Предотвращение выхода из диапазона
   uint l=(line_index<lines_total)? line_index : lines_total-1;
//--- Получим размер массива символов указанной строки
   uint symbols_total=::ArraySize(m_lines[l].m_symbol);
//--- Счётчик слов
   uint words_counter=0;
//--- Ищем пробел по указанному индексу
   for(uint s=1; s<symbols_total; s++)
     {
      //--- Считаем, если (2) дошли до конца строки или (2) нашли пробел (конец слова)
      if(s+1==symbols_total || (m_lines[l].m_symbol[s]!=SPACE && m_lines[l].m_symbol[s-1]==SPACE))
         words_counter++;
     }
//--- Вернуть количество слов
   return((words_counter<1)? 1 : words_counter);
  }
//+------------------------------------------------------------------+
//| Возвращает количество переносимых символов с признаком объёма    |
//+------------------------------------------------------------------+
bool CTextBox::WrapSymbolsTotal(const uint line_index,uint &wrap_symbols_total)
  {
//--- Признаки (1) количества символов для переноса и (2) строки без пробелов
   bool is_all_text=false,is_solid_row=false;
//--- Получим размер массива символов
   uint symbols_total=::ArraySize(m_lines[line_index].m_symbol);
//--- Отступы
   uint x_offset_plus=m_text_x_offset+m_scrollv.XSize();
//--- Получим полную ширину строки
   uint full_line_width=LineWidth(symbols_total,line_index)+x_offset_plus;
//--- Получим ширину свободного пространства
   uint free_space=m_area_visible_x_size-full_line_width;
//--- Получим количество слов в следующей строке
   uint next_line_index =line_index+1;
   uint words_total     =WordsTotal(next_line_index);
//--- Получим размер массива символов
   uint next_line_symbols_total=::ArraySize(m_lines[next_line_index].m_symbol);
//--- Определить количество слов, которые можно перенести со следующей строки (поиск по пробелу)
   for(uint w=0; w<words_total; w++)
     {
      //--- Получим (1) индекс пробела и (2) ширину подстроки от начала до пробела
      uint ss_index        =SymbolIndexBySpaceNumber(next_line_index,w);
      uint substring_width =LineWidth(ss_index,next_line_index);
      //--- Если подстрока помещается в свободное пространство текущей строки
      if(substring_width<free_space)
        {
         //--- ...проверим, можно ли добавить ещё одно слово
         wrap_symbols_total=ss_index;
         //--- Остановиться, если это вся строка
         if(next_line_symbols_total==wrap_symbols_total)
           {
            is_all_text=true;
            break;
           }
        }
      else
        {
         //--- Если это сплошная строка без пробела
         if(ss_index==next_line_symbols_total)
            is_solid_row=true;
         //---
         break;
        }
     }
//--- Сразу вернуть результат, если (1) это строка с пробелом или (2) нет свободного места
   if(!is_solid_row || free_space<1)
      return(is_all_text);
//--- Получим полную ширину следующей строки
   full_line_width=LineWidth(next_line_symbols_total,next_line_index)+x_offset_plus;
//--- Если (1) строка не помещается и нет пробелов в конце (2) текущей и (3) предыдущей строках
   if(full_line_width>free_space && 
      m_lines[line_index].m_symbol[symbols_total-1]!=SPACE && 
      m_lines[next_line_index].m_symbol[next_line_symbols_total-1]!=SPACE)
     {
      //--- Определить количество символов, которые можно перенести со следующей строки
      for(uint s=next_line_symbols_total-1; s>=0; s--)
        {
         //--- Получим ширину подстроки от начала до указанного символа
         uint substring_width=LineWidth(s,next_line_index);
         //--- Если подстрока не помещается в свободное пространство указанного контейнера, перейти к следующему символу
         if(substring_width>=free_space)
            continue;
         //--- Если подстрока помещается, запомним значение и остановимся
         wrap_symbols_total=s;
         break;
        }
     }
//--- Вернуть истину, если нужно перенести весь текст
   return(is_all_text);
  }
//+------------------------------------------------------------------+
//| Возвращает индекс символа пробела по его номеру                  |
//+------------------------------------------------------------------+
uint CTextBox::SymbolIndexBySpaceNumber(const uint line_index,const uint space_index)
  {
//--- Получим размер массива строк
   uint lines_total=::ArraySize(m_lines);
//--- Предотвращение выхода из диапазона
   uint l=(line_index<lines_total)? line_index : lines_total-1;
//--- Получим размер массива символов указанной строки
   uint symbols_total=::ArraySize(m_lines[l].m_symbol);
//--- (1) Для определения индекса символа пробела и (2) счётчик пробелов
   uint symbol_index  =0;
   uint space_counter =0;
//--- Ищем пробел по указанному индексу
   for(uint s=1; s<symbols_total; s++)
     {
      //--- Если нашли пробел
      if(m_lines[l].m_symbol[s]!=SPACE && m_lines[l].m_symbol[s-1]==SPACE)
        {
         //--- Если счётчик равен указанному индексу пробела, запомним его и остановим цикл
         if(space_counter==space_index)
           {
            symbol_index=s;
            break;
           }
         //--- Увеличим счётчик пробелов
         space_counter++;
        }
     }
//--- Вернуть размер строки, если не нашли индекс пробела
   return((symbol_index<1)? symbols_total : symbol_index);
  }
//+------------------------------------------------------------------+
//| Перемещение строк на указанное количество позиций                |
//+------------------------------------------------------------------+
void CTextBox::MoveLines(const uint from_index,const uint to_index,const uint count,const bool to_down=true)
  {
//--- Смещение строк по направлению вниз
   if(to_down)
     {
      for(uint i=from_index; i>to_index; i--)
        {
         //--- Индекс предыдущего элемента массива строк
         uint prev_index=i-count;
         //--- Получим размер массива символов
         uint symbols_total=::ArraySize(m_lines[prev_index].m_symbol);
         //--- Установим новый размер массивам
         ArraysResize(i,symbols_total);
         //--- Сделать копию строки
         LineCopy(i,prev_index);
         //--- Если это последняя итерация
         if(prev_index==to_index)
           {
            //--- Выйти, если это первая строка
            if(to_index<1)
               break;
           }
        }
     }
//--- Смещение строк по направлению вверх
   else
     {
      for(uint i=from_index; i<to_index; i++)
        {
         //--- Индекс следующего элемента массива строк
         uint next_index=i+count;
         //--- Получим размер массива символов
         uint symbols_total=::ArraySize(m_lines[next_index].m_symbol);
         //--- Установим новый размер массивам
         ArraysResize(i,symbols_total);
         //--- Сделать копию строки
         LineCopy(i,next_index);
        }
     }
  }
//+------------------------------------------------------------------+
//| Перемещение символов в указанной строке                          |
//+------------------------------------------------------------------+
void CTextBox::MoveSymbols(const uint line_index,const uint from_pos,const uint to_pos,const bool to_left=true)
  {
//--- Получим размер массива символов
   uint symbols_total=::ArraySize(m_lines[line_index].m_symbol);
//--- Разница
   uint offset=from_pos-to_pos;
//--- Если нужно сместить символы влево
   if(to_left)
     {
      for(uint s=to_pos; s<symbols_total-offset; s++)
        {
         uint i=s+offset;
         m_lines[line_index].m_symbol[s] =m_lines[line_index].m_symbol[i];
         m_lines[line_index].m_width[s]  =m_lines[line_index].m_width[i];
        }
     }
//--- Если нужно сместить символы вправо
   else
     {
      for(uint s=symbols_total-1; s>to_pos; s--)
        {
         uint i=s-1;
         m_lines[line_index].m_symbol[s] =m_lines[line_index].m_symbol[i];
         m_lines[line_index].m_width[s]  =m_lines[line_index].m_width[i];
        }
     }
  }
//+------------------------------------------------------------------+
//| Добавляет текст в указанную строку                               |
//+------------------------------------------------------------------+
void CTextBox::AddToString(const uint line_index,const string text)
  {
//--- Переносим строку в массив
   uchar array[];
   int total=::StringToCharArray(text,array)-1;
   if(total<0)
      return;
//--- Получим размер массива символов
   uint symbols_total=::ArraySize(m_lines[line_index].m_symbol);
//--- Установим новый размер массивам
   uint new_size=symbols_total+total;
   ArraysResize(line_index,new_size);
//--- Добавить данные в массивы структуры
   for(uint i=symbols_total; i<new_size; i++)
     {
      m_lines[line_index].m_symbol[i] =::CharToString(array[i-symbols_total]);
      m_lines[line_index].m_width[i]  =m_textbox.TextWidth(m_lines[line_index].m_symbol[i]);
     }
  }
//+------------------------------------------------------------------+
//| Копирует в переданный массив символы для переноса                |
//+------------------------------------------------------------------+
void CTextBox::CopyWrapSymbols(const uint line_index,const uint start_pos,const uint symbols_total,string &array[])
  {
//--- Установим размер массиву
   ::ArrayResize(array,symbols_total);
//--- Скопируем в массив символы, которые нужно перенести
   for(uint i=0; i<symbols_total; i++)
      array[i]=m_lines[line_index].m_symbol[start_pos+i];
  }
//+------------------------------------------------------------------+
//| Вставляет символы в указанную строку                             |
//+------------------------------------------------------------------+
void CTextBox::PasteWrapSymbols(const uint line_index,const uint start_pos,string &array[])
  {
   uint array_size=::ArraySize(array);
//--- Добавить данные в массивы структуры новой строки
   for(uint i=0; i<array_size; i++)
     {
      uint s=start_pos+i;
      m_lines[line_index].m_symbol[s] =array[i];
      m_lines[line_index].m_width[s]  =m_textbox.TextWidth(array[i]);
     }
  }
//+------------------------------------------------------------------+
//| Перенос текста на новую строку                                   |
//+------------------------------------------------------------------+
void CTextBox::WrapTextToNewLine(const uint line_index,const uint symbol_index,const bool by_pressed_enter=false)
  {
//--- Получим размер массива символов из строки
   uint symbols_total=::ArraySize(m_lines[line_index].m_symbol);
//--- Последний индекс символа
   uint last_symbol_index=symbols_total-1;
//--- Корректировка в случае пустой строки
   uint check_symbol_index=(symbol_index>last_symbol_index && symbol_index!=symbols_total)? last_symbol_index : symbol_index;
//--- Индекс следующей строки
   uint next_line_index=line_index+1;
//--- Количество символов, которые нужно перенести на новую строку
   uint new_line_size=symbols_total-check_symbol_index;
//--- Скопируем в массив символы, которые нужно перенести
   string array[];
   CopyWrapSymbols(line_index,check_symbol_index,new_line_size,array);
//--- Установим новый размер массивам структуры в строке
   ArraysResize(line_index,symbols_total-new_line_size);
//--- Установим новый размер массивам структуры в новой строке
   ArraysResize(next_line_index,new_line_size);
//--- Добавить данные в массивы структуры новой строки
   PasteWrapSymbols(next_line_index,0,array);
//--- Определим новое положение текстового курсора
   int x_pos=int(new_line_size-(symbols_total-m_text_cursor_x_pos));
   m_text_cursor_x_pos =(x_pos<0)? (int)m_text_cursor_x_pos : x_pos;
   m_text_cursor_y_pos =(x_pos<0)? (int)line_index : (int)next_line_index;
//--- Если указано, что вызов по нажатию на клавише Enter
   if(by_pressed_enter)
     {
      //--- Если строка имела признак окончания, то ставим признак окончания текущей и следующей
      if(m_lines[line_index].m_end_of_line)
        {
         m_lines[line_index].m_end_of_line      =true;
         m_lines[next_line_index].m_end_of_line =true;
        }
      //--- Если нет, то только текущей
      else
        {
         m_lines[line_index].m_end_of_line      =true;
         m_lines[next_line_index].m_end_of_line =false;
        }
     }
   else
     {
      //--- Если строка имела признак окончания, то продолжаем и устанавливаем признак на следующей строке
      if(m_lines[line_index].m_end_of_line)
        {
         m_lines[line_index].m_end_of_line      =false;
         m_lines[next_line_index].m_end_of_line =true;
        }
      //--- Если строка не имела признак окончания, то продолжаем в обеих строках
      else
        {
         m_lines[line_index].m_end_of_line      =false;
         m_lines[next_line_index].m_end_of_line =false;
        }
     }
  }
//+------------------------------------------------------------------+
//| Перенос текста из следующей строки в текущую                     |
//+------------------------------------------------------------------+
void CTextBox::WrapTextToPrevLine(const uint next_line_index,const uint wrap_symbols_total,const bool is_all_text=false)
  {
//--- Получим размер массива символов из строки
   uint symbols_total=::ArraySize(m_lines[next_line_index].m_symbol);
//--- Индекс предыдущей строки
   uint prev_line_index=next_line_index-1;
//--- Скопируем в массив символы, которые нужно перенести
   string array[];
   CopyWrapSymbols(next_line_index,0,wrap_symbols_total,array);
//--- Получим размер массива символов из предыдущей строки
   uint prev_line_symbols_total=::ArraySize(m_lines[prev_line_index].m_symbol);
//--- Увеличим размер массива предыдущей строки на добавляемое количество символов
   uint new_prev_line_size=prev_line_symbols_total+wrap_symbols_total;
   ArraysResize(prev_line_index,new_prev_line_size);
//--- Добавить данные в массивы структуры новой строки
   PasteWrapSymbols(prev_line_index,new_prev_line_size-wrap_symbols_total,array);
//--- Сместим символы на освободившееся место в текущей строке
   MoveSymbols(next_line_index,wrap_symbols_total,0);
//--- Уменьшим размер массива текущей строки на извлечённое из неё количество символов
   ArraysResize(next_line_index,symbols_total-wrap_symbols_total);
//--- Скорректировать текстовый курсор
   if((is_all_text && next_line_index==m_text_cursor_y_pos) || 
      (!is_all_text && next_line_index==m_text_cursor_y_pos && wrap_symbols_total>0))
     {
      m_text_cursor_x_pos=new_prev_line_size-(wrap_symbols_total-m_text_cursor_x_pos);
      m_text_cursor_y_pos--;
     }
//--- Выйти, если это не весь оставшийся текст строки
   if(!is_all_text)
      return;
//--- Добавить признак оконачания для предыдущей строки, если у текущей строки он тоже есть
   if(m_lines[next_line_index].m_end_of_line)
      m_lines[next_line_index-1].m_end_of_line=true;
//--- Получим размер массива строк
   uint lines_total=::ArraySize(m_lines);
//--- Сместим строки на одну вверх
   MoveLines(next_line_index,lines_total-1,1,false);
//--- Установим новый размер массиву строк
   ::ArrayResize(m_lines,lines_total-1);
  }
//+------------------------------------------------------------------+
//| Изменить ширину по правому краю формы                            |
//+------------------------------------------------------------------+
void CTextBox::ChangeWidthByRightWindowSide(void)
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
   ChangeMainSize(x_size,y_size);
//--- Рассчитать размеры поля ввода
   CalculateTextBoxSize();
//--- Установить новый размер полю ввода
   ChangeTextBoxSize();
//--- В режиме переноса слов нужно повторно пересчитать и установить размеры
   if(m_word_wrap_mode)
     {
      CalculateTextBoxSize();
      ChangeTextBoxSize();
     }
//--- Нарисовать текст и дезактивировать поле ввода
   DeactivateTextBox();
//--- Перерисовать элемент
   Draw();
   if(m_scrollh.IsScroll())
      m_scrollh.Update(true);
   if(m_scrollv.IsScroll())
      m_scrollv.Update(true);
  }
//+------------------------------------------------------------------+
//| Изменить высоту по нижнему краю окна                             |
//+------------------------------------------------------------------+
void CTextBox::ChangeHeightByBottomWindowSide(void)
  {
//--- Выйти, если включен режим фиксации к нижнему краю формы  
   if(m_anchor_bottom_window_side)
      return;
//--- Координаты
   int y=0;
//--- Размеры
   int x_size =(m_auto_xresize_mode)? m_main.X2()-CElementBase::X()-m_auto_xresize_right_offset : m_x_size;
   int y_size =m_main.Y2()-CElementBase::Y()-m_auto_yresize_bottom_offset;
//--- Установить новый размер
   ChangeMainSize(x_size,y_size);
//--- Рассчитать размеры поля ввода
   CalculateTextBoxSize();
//--- Установить новый размер полю ввода
   ChangeTextBoxSize();
//--- Нарисовать текст и дезактивировать поле ввода
   DeactivateTextBox();
//--- Перерисовать элемент
   Draw();
   if(m_scrollh.IsScroll())
      m_scrollh.Update(true);
   if(m_scrollv.IsScroll())
      m_scrollv.Update(true);
  }
//+------------------------------------------------------------------+
