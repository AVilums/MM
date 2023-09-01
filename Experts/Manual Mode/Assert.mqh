#define DEBUG

#ifdef DEBUG  
   #define assert(condition, message) \
      if(!(condition)) \
        { \
         string fullMessage= \
                            #condition+", " \
                            +__FILE__+", " \
                            +__FUNCSIG__+", " \
                            +"line: "+(string)__LINE__ \
                            +(message=="" ? "" : ", "+message); \
         \
         Alert("Assertion failed! "+fullMessage); \
        }
#else
   #define assert(condition, message) ;
#endif 