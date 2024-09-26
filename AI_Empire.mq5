//+------------------------------------------------------------------+
//|                                                    AI_Empire.mq5 |
//|                             Copyright 2017, Shcherbyna Rostyslav |
//| Empire8+RSI(2), Do not Open opposite trend!                      |
//| Work on Open Prices                                              |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Shcherbyna Rostyslav"
#property link      ""
#property version   "9.00"
//+------------------------------------------------------------------+
//| Trading Rule                                                     |
//+------------------------------------------------------------------+
enum ENUM_TR_LIST
  {
   Simple,
   TrendOnly,
  };
//+------------------------------------------------------------------+
//| Empire Indicator Trend States                                    |
//+------------------------------------------------------------------+
enum ENUM_EMPIRE_STATE
  {
   NONE,
   TREND_UP,
   TREND_DOWN,
  };
//+------------------------------------------------------------------+
//| INIT STRUCT                                                      |
//+------------------------------------------------------------------+
struct STRUCT_Init
  {
   double            _Volume;
   double            _MaxVolume;
   double            _SL;
   double            _TP;
   double            _Shift_pts;
   double            _RSI_Level_UP_1;
   double            _RSI_Level_UP_2;
   double            _RSI_Level_DOWN_1;
   double            _RSI_Level_DOWN_2;
   string            ind_Empire_Path;
   int               ind_Empire_Period;
   int               ind_Empire_Depth;
   int               ind_RSI_Period;
   ENUM_TR_LIST      _TR_Num;
   uchar             _Broker_Fee;
   bool              _OpenBarsOnly;
   bool              _ReverseSignal;
   bool              _ReverseVolume;
   bool              _CloseReverseSignal;

  };
//+------------------------------------------------------------------+
//| Trading Rule Signals                                             |
//+------------------------------------------------------------------+
enum ENUM_TR_SIGNAL
  {
   NOTRADE,
   BUY,
   SELL,
   DBL_BUY,
   DBL_SELL,
   CLOSE_ALL,
  };
//+------------------------------------------------------------------+
//| AI Empire                                                        |
//+------------------------------------------------------------------+
class AI_Empire
  {
private:

   //---Indicator Buffers
   double            m_arr_rsi[];
   double            m_arr_empire[];

   double            m_max_volume;
   double            m_volume;
   double            m_max_broker_volume;
   double            m_shift_pts;
   double            m_sl;
   double            m_tp;
   double            m_rsi_level_up_1;
   double            m_rsi_level_up_2;
   double            m_rsi_level_down_1;
   double            m_rsi_level_down_2;
   string            m_ind_empire_path;
   int               m_ind_rsi_handle;
   int               m_ind_empire_handle;
   int               m_ind_empire_period;
   int               m_ind_empire_depth;
   int               m_ind_rsi_period;
   int               m_magic;
   //Broker Fee
   uchar             m_broker_fee;

   ENUM_ORDER_TYPE_FILLING m_order_filling_type;

   //Control Open Bars Only
   bool              m_open_bar_only;
   datetime          m_arr_open_bars[1];
   datetime          m_new_bar_time;

   //Last Buffer Index
   char              m_ind_last_indx;

   //Current TR
   ENUM_TR_LIST      m_current_tr;

   //Current Signal
   ENUM_TR_SIGNAL    m_current_signal;

   //Current Empire State
   ENUM_EMPIRE_STATE m_current_empire_state;

   //Reverse Signal
   bool              m_reverse_signal;

   //Reverse Volume
   bool              m_reverse_volume;

   //Close by Reverse Signal
   bool              m_close_reverse_signal;

   //---PRIVATE METHODS:
   //Connect Indicator
   bool              m_ConnectIndicator();

   //Is New BAR?
   bool              m_IsNewBar();

   //Last Indicator Buffers
   bool              m_IndBuffers();

   //Apply TR
   void              m_ApplyTR();

   //Trade
   void              m_Trade();

   //Open Market Order
   int               m_OpenMarketOrder(const double &Vol,const ENUM_TR_SIGNAL &BuyOrSell,
                                       const double &Sl,const double &Tp,const string _Comment);

   //Add Volume
   bool              m_AddVolume(const double &Shift_pts,const ENUM_TR_SIGNAL &Signal);

   //Closs All Positions
   bool              m_CloseAllPositions(const string CustomComment);

   //Parially send order (avoid broker limit 100 lots maximum at one order -> send many orders)
   void              m_PartiallySendOrder(const double &Volume,const ENUM_TR_SIGNAL BuyOrSell,const string comment);

   //Reverse Signal
   ENUM_TR_SIGNAL    m_ReverseSignal(const ENUM_TR_SIGNAL &Signal);

   //Complete Signal (Reverse\Close\ReverseVolume)
   ENUM_TR_SIGNAL    m_CompleteSignal();

   //TR Simple 
   ENUM_TR_SIGNAL    m_TR_Simple();

   //Trend Only
   ENUM_TR_SIGNAL    m_TR_TrendOnly();

public:
                     AI_Empire(void);
                    ~AI_Empire(void);

   //Last IndBuffers
   double            RSI(void)            const {return(m_arr_rsi[m_ind_last_indx]);}
   double            EMPIRE(void)         const {return(m_arr_empire[m_ind_last_indx]);}

   //---PUBLIC METHODS:
   void              Init(const STRUCT_Init &init);
   void              DeInit();
   void              NewPrice();
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
AI_Empire::AI_Empire(void)
  {

  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
AI_Empire::~AI_Empire(void)
  {

  }
//+------------------------------------------------------------------+
//| Init                                                             |
//+------------------------------------------------------------------+
void AI_Empire::Init(const STRUCT_Init &init)
  {
//IF NEED to Caclulate NewBAR on Restart Expert
   m_arr_open_bars[0]=0;
   m_new_bar_time=0;

//Get Maximum Availables Volume on broker
   m_max_broker_volume=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   m_broker_fee=is._Broker_Fee;

   m_max_volume=is._MaxVolume;
   m_volume=is._Volume;
   m_open_bar_only=is._OpenBarsOnly;
   m_sl=is._SL;
   m_tp=is._TP;
   m_ind_empire_depth=is.ind_Empire_Depth;
   m_ind_empire_period=is.ind_Empire_Period;
   m_ind_rsi_period=is.ind_RSI_Period;
   m_ind_empire_path=is.ind_Empire_Path;
   m_current_tr=is._TR_Num;
   m_reverse_signal=is._ReverseSignal;
   m_reverse_volume=is._ReverseVolume;
   m_close_reverse_signal=is._CloseReverseSignal;
   m_shift_pts=is._Shift_pts;
   m_rsi_level_up_1=is._RSI_Level_UP_1;
   m_rsi_level_up_2=is._RSI_Level_UP_2;
   m_rsi_level_down_1=is._RSI_Level_DOWN_1;
   m_rsi_level_down_2=is._RSI_Level_DOWN_2;

   m_order_filling_type=ORDER_FILLING_IOC;
   m_magic=20171019;

//Connect Indicator
   if(!m_ConnectIndicator())
     {
      Print("Can`t connect indicator, exit");
      ExpertRemove();
     }
  }
//+------------------------------------------------------------------+
//| DeInit                                                           |
//+------------------------------------------------------------------+
void AI_Empire::DeInit(void)
  {
  }
//+------------------------------------------------------------------+
//| New Price                                                        |
//+------------------------------------------------------------------+
void AI_Empire::NewPrice(void)
  {
//If CONTROL OPEN BAR and If not New Bar, Exit
   if(m_open_bar_only) if(!m_IsNewBar()) return;

//UpdateBuffers
   if(!m_IndBuffers()) return;

//  Print(TimeCurrent());
//  Print(RSI());
//  Print(EMPIRE());

//Apply TR
   m_ApplyTR();

//AutoCompounding (Sets Start\Max Volumes size)   
//   if(m_compounding) m_AutoCompounding();

//Trade
   m_Trade();
  }
//+------------------------------------------------------------------+
//| Market Open Position                                             |
//+------------------------------------------------------------------+
int AI_Empire::m_OpenMarketOrder(const double &Vol,const ENUM_TR_SIGNAL &BuyOrSell,
                                 const double &Sl,const double &Tp,const string _Comment)
  {
//Get Last Prices
   MqlTick z_ts;
   SymbolInfoTick(_Symbol,z_ts);

//Check SL\TP Bounds
   double opm_sl=(BuyOrSell==BUY)?z_ts.ask-(Sl*_Point):z_ts.bid+(Sl*_Point);
   double opm_tp=(BuyOrSell==BUY)?z_ts.ask+(Tp*_Point):z_ts.bid-(Tp*_Point);

//Prepare SendOrder Struct
   MqlTradeRequest z_mt_req;
   MqlTradeResult  z_mt_rez={0};

//Set to Market Order
   z_mt_req.action=TRADE_ACTION_DEAL;
   z_mt_req.type_filling=(m_order_filling_type==true)?ORDER_FILLING_FOK:ORDER_FILLING_IOC;
   z_mt_req.symbol=_Symbol;
   z_mt_req.magic=m_magic;
   z_mt_req.volume=Vol;
   z_mt_req.sl=opm_sl;
   z_mt_req.tp=opm_tp;
   z_mt_req.comment=_Comment;
   z_mt_req.deviation=3;

//BugFix(error 10015) -not for market execution
   z_mt_req.price=(BuyOrSell==BUY)?z_ts.ask:z_ts.bid;
   z_mt_req.type=(BuyOrSell==BUY)?ORDER_TYPE_BUY:ORDER_TYPE_SELL;

//Reset Error
   ResetLastError();

//Check Structures
   MqlTradeCheckResult z_mt_cr={0};

//+------------------------------------------------------------------+
//| Check Order                                                      |
//+------------------------------------------------------------------+
   if(!OrderCheck(z_mt_req,z_mt_cr) && z_mt_cr.retcode!=0)
     {
      Print(__FUNCTION__+" Verify send order failed with : "+z_mt_cr.comment+" Code="+IntegerToString(z_mt_cr.retcode));

      // Code 10030 FxPro Unsupported filling mode (FOK)
      if(z_mt_cr.retcode==10030)
        {
         Print("Please change Filling order mode to: FOK or IOK");
         ExpertRemove();
         return(-3);
        }

      //If wrong volume, show it
      else if((z_mt_cr.retcode==TRADE_RETCODE_INVALID_VOLUME) && (MQLInfoInteger(MQL_TESTER)==true))
        {
         Print("Open Position Volume: "+DoubleToString(z_mt_req.volume));
         ExpertRemove();
         return(-3);
        }

      //If no money in HISTORY_TESTER_MODE, remove expert
      else if((z_mt_cr.retcode==TRADE_RETCODE_NO_MONEY) && (MQLInfoInteger(MQL_TESTER)==true))
         ExpertRemove();

      //In Both Cases return
      return(-3);
     }

//Check Result
   if(OrderSend(z_mt_req,z_mt_rez))
     {
      //If Done
      if(z_mt_rez.retcode==TRADE_RETCODE_DONE)
        {
         //If Opened, Withdrawal Broker Fee (to emulate broker comission)
         TesterWithdrawal(m_broker_fee*Vol/2);
         return(true);
        }
     }
   else
     {
      //If NOT OK!
      Print(" ret:"+IntegerToString(z_mt_rez.retcode)+
            " LastErr: "+IntegerToString(GetLastError())+z_mt_rez.comment);
     }//END of Err

   return(-1);
  }//END OF OPEN MARKET ORDER   
//+------------------------------------------------------------------+
//| Partiall Order                                                   |
//+------------------------------------------------------------------+
void AI_Empire::m_PartiallySendOrder(const double &Volume,const ENUM_TR_SIGNAL BuyOrSell,const string comment)
  {
//Vol > Max Broker Volume 
   if(Volume>=m_max_broker_volume)
     {
      //New partially volume
      double part_volume=NormalizeDouble(Volume/(m_max_broker_volume),2);

      //Lots Count for circle 
      double part_count=NormalizeDouble(part_volume,0);

      //Difference between Circle Closed position & not closed position yet
      double part_not_closed_lot=Volume-(part_count*m_max_broker_volume);

      //Part SendOrder
      for(int i=0;i<part_count;i++)
         m_OpenMarketOrder(m_max_broker_volume,BuyOrSell,m_sl,m_tp,comment);

      //Close\Open other lot
      if(part_not_closed_lot>0)
         m_OpenMarketOrder(part_not_closed_lot,BuyOrSell,m_sl,m_tp,comment);

      //Exit in Both Cases
      return;
     }//END OF Volume > MAX BROKER VOLUME  
   else
     {
      //Normal Open Position
      m_OpenMarketOrder(Volume,BuyOrSell,m_sl,m_tp,comment);

      return;
     }//END OF NORMAL Open Position
  }
//+------------------------------------------------------------------+
//|  CLOSE ALL POSITIONS                                             |
//+------------------------------------------------------------------+
bool AI_Empire::m_CloseAllPositions(const string CustomComment)
  {
   bool  m_partially_order=true;
   ENUM_TR_SIGNAL signal=0;

//Get total positions
   int m_positions_total=PositionsTotal();

//If no positions , exit
   if(m_positions_total<1)return(false);

//Check Symbols
   for(int i=0;i<m_positions_total;i++)
     {
      if(PositionGetSymbol(i)=="")
        {
         Print(__FUNCTION__+" Err: "+IntegerToString(GetLastError()));
         return(false);
        }

      //Position Direction
      long m_position_type=PositionGetInteger(POSITION_TYPE);

      //Position Volume
      double m_position_volume=PositionGetDouble(POSITION_VOLUME);

      //If Buy Opened, close it  
      if(m_position_type==POSITION_TYPE_BUY)
        {
         //If PartiallyOrder
         if(m_partially_order) m_PartiallySendOrder(m_position_volume,SELL,"CL");
         else
           {
            //Normal Close
            signal=SELL;
            m_OpenMarketOrder(m_position_volume,signal,m_sl,m_tp,CustomComment);
            return(true);
           }//END of normal close buy
        }//END OF CLOSE BUY

      //If Sell Opened, close it  
      if(m_position_type==POSITION_TYPE_SELL)
        {
         //If PartiallyOrder
         if(m_partially_order)m_PartiallySendOrder(m_position_volume,BUY,"CL");
         else
           {
            //Normal Open
            signal=BUY;
            m_OpenMarketOrder(m_position_volume,signal,m_sl,m_tp,CustomComment);
            return(true);
           }//END OF normal close buy
        }//END OF CLOSE SELL
     }//END of FOR
   return(true);
  }//END OF CLOSE ALL POSITIONS    
//+------------------------------------------------------------------+
//| Add Volume to opened position                                    |
//+------------------------------------------------------------------+
bool AI_Empire::m_AddVolume(const double &Shift_pts,const ENUM_TR_SIGNAL &Signal)
  {
//Check MaxVolume
   if(PositionGetDouble(POSITION_VOLUME)>=m_max_volume) return(false);

//Position Open Price
   double open_price=PositionGetDouble(POSITION_PRICE_OPEN);

//Current Price(Bid for BuyClose & Ask for SellClose)
   double current_price=PositionGetDouble(POSITION_PRICE_CURRENT);

//Position Direction
   ulong pos_type=PositionGetInteger(POSITION_TYPE);

//Current AddVolume(Changed if partially order enabled)
   double current_add_volume=m_volume;

//Add Volume BUY
   if((pos_type==POSITION_TYPE_BUY) && (Signal==BUY))
     {
      //If Price lower->Add Vol Buy, else Exit
      if(current_price>open_price-(Shift_pts*_Point)) return(false);

      //Add BUY
      m_PartiallySendOrder(current_add_volume,BUY,"AV B "
                           +EnumToString(m_current_empire_state)+" | "
                           +DoubleToString(RSI(),0)+" | ");
      return(true);
     }//END OF ADD VOL BUY

//Add Volume SELL
   if((pos_type==POSITION_TYPE_SELL) && (Signal==SELL))
     {
      //If Price Higher->Add Vol Sell, else Exit
      if(current_price<open_price+(Shift_pts*_Point)) return(false);

      //Add SELL
      m_PartiallySendOrder(current_add_volume,SELL,"AV S "
                           +EnumToString(m_current_empire_state)+" | "
                           +DoubleToString(RSI(),0)+" | ");
      return(true);
     }//END OF ADD VOL SELL

//If no pos,
   return(false);
  }//END of AddVolume    
//+------------------------------------------------------------------+
//| TRADE                                                            |
//+------------------------------------------------------------------+
void AI_Empire::m_Trade(void)
  {
   ENUM_TR_SIGNAL signal=m_current_signal;
   double   lot=m_volume;

//If No Signals EXIT
   if(signal==NOTRADE) return;

//Check if we have opened position
   if(PositionSelect(_Symbol))
     {
      //if open position, exit
      if(m_AddVolume(m_shift_pts,signal)) return;

      //Check reverse sell
      if(signal==DBL_BUY)
        {
         signal=BUY;
         lot=lot*2;
         m_PartiallySendOrder(lot,signal,"2B "+EnumToString(m_current_empire_state)+
                              " | "+DoubleToString(RSI(),0));
         return;
        }

      //Check reverse buy
      if(signal==DBL_SELL)
        {
         signal=SELL;
         lot=lot*2;
         m_PartiallySendOrder(lot,signal,"2S "+EnumToString(m_current_empire_state)+" | "
                              +DoubleToString(RSI(),0)+" | ");
         return;
        }

      //CLOSE ALL
      if(signal==CLOSE_ALL)
        {
         m_CloseAllPositions("ClALL "+EnumToString(m_current_empire_state)+" | "
                             +DoubleToString(RSI(),0)+" | ");
         return;
        }
     }//END OF HAS OPENED POSITION
   else
     {
      //if NO opened position
      switch(m_current_signal)
        {
         case  BUY:  m_PartiallySendOrder(m_volume,signal,"B "
                                          +EnumToString(m_current_empire_state)+" | "
                                          +DoubleToString(RSI(),0)+" | ");
            return; break;

         case  SELL: m_PartiallySendOrder(m_volume,signal,"S "
                                          +EnumToString(m_current_empire_state)+" | "
                                          +DoubleToString(RSI(),0));
            return; break;

         default:return;  break;
        }
     }//END OF NO OPEN POSITIONS
  }
//+------------------------------------------------------------------+
//| Connect Indicator                                                |
//+------------------------------------------------------------------+ 
bool AI_Empire::m_ConnectIndicator(void)
  {
//Connect Empire
   m_ind_empire_handle=iCustom(_Symbol,0,m_ind_empire_path,m_ind_empire_period,m_ind_empire_depth,PRICE_OPEN);

//Connect RSI
   m_ind_rsi_handle=iRSI(_Symbol,0,m_ind_rsi_period,PRICE_OPEN);

// is Indicators Created?
   if((m_ind_empire_handle<0) || (m_ind_rsi_handle<0))
      return(false);
   else
      return(true);
  }//END OF Connect Indicator 
//+------------------------------------------------------------------+
//| is New Bar ?                                                     |
//+------------------------------------------------------------------+
bool AI_Empire::m_IsNewBar(void)
  {
//Latest Bar Time
   CopyTime(_Symbol,_Period,0,1,m_arr_open_bars);

//If NEW Bar, save it time
   if(m_arr_open_bars[0]>m_new_bar_time)
     {
      m_new_bar_time=m_arr_open_bars[0];
      return(true);
     }

//If not New Bar, Exit
   else return(false);
  }
//+------------------------------------------------------------------+
//| Indicator Last Buffers                                           |
//+------------------------------------------------------------------+ 
bool AI_Empire::m_IndBuffers(void)
  {
//Count of copyed values
   char CopyCount=5;

//Save Last Ind_Value_Index
   m_ind_last_indx=CopyCount-1;

//If bars not calculated in indicator, then exit
   if((BarsCalculated(m_ind_empire_handle)<0) || (BarsCalculated(m_ind_rsi_handle)<0))
      return(false);

//RSI on Open Prices;
   if(CopyBuffer(m_ind_rsi_handle,0,0,CopyCount,m_arr_rsi)<0) return(false);

//EMpire8
   if(CopyBuffer(m_ind_empire_handle,0,0,CopyCount,m_arr_empire)<0) return(false);

//Check Empire State   
   if(m_arr_empire[m_ind_last_indx]>m_arr_empire[m_ind_last_indx-1])      m_current_empire_state=TREND_UP;
   else if(m_arr_empire[m_ind_last_indx]<m_arr_empire[m_ind_last_indx-1]) m_current_empire_state=TREND_DOWN;
   else m_current_empire_state=NONE;

//If Ok
   return(true);
  }//END of IndBuffers  
//+------------------------------------------------------------------+
//| Apply TR                                                         |
//+------------------------------------------------------------------+
void AI_Empire::m_ApplyTR()
  {
//Always reset signal
   m_current_signal=NOTRADE;

   switch(m_current_tr)
     {
      case  Simple:m_current_signal=m_TR_Simple();                          return;break;
      case  TrendOnly:m_current_signal=m_TR_TrendOnly();                    return;break;

      default:return; break;
     }
   return;
  }
//+------------------------------------------------------------------+
//| Reverse Signal                                                   |
//+------------------------------------------------------------------+
ENUM_TR_SIGNAL AI_Empire::m_ReverseSignal(const ENUM_TR_SIGNAL &Signal)
  {
//+++ IF ALREADY HAVE OPEN POSITION then Reverse position
   if(PositionSelect(_Symbol))
     {
      //Reverse Direction Signal
      if(     (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)  && (Signal==SELL)) return(DBL_SELL);
      else if((PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL) && (Signal==BUY))  return(DBL_BUY);
      else if((PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)  && (Signal==DBL_SELL)) return(DBL_SELL);
      else if((PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL) && (Signal==DBL_BUY))  return(DBL_BUY);
     }

// Same direction and all others 
   return(Signal);
  }
//+------------------------------------------------------------------+
//| Complete Signal (Reverse\Close\ReverseVolume)                    |
//+------------------------------------------------------------------+
ENUM_TR_SIGNAL  AI_Empire::m_CompleteSignal(void)
  {
//If Range, reverse signal
   if(m_reverse_signal)
     {
      if(m_current_signal==BUY) m_current_signal=SELL;
      else if(m_current_signal==SELL) m_current_signal=BUY;
     }
/////?DONT CLOSE BY REVERSE SIGNAL!

//If Position Exist - compare with saved params when open posion and Cover it
   if(PositionSelect(_Symbol))
     {
      //If Reversal Strategy of System, Reverse Volume!
      if(m_reverse_volume) return(m_ReverseSignal(m_current_signal));
      else
        {
         //If NOT Reversal
         //Check For Close, if opposite signal
         if(m_close_reverse_signal)
           {
            if((PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY) && m_current_signal==SELL)
               m_current_signal=CLOSE_ALL;

            else if((PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL) && m_current_signal==BUY)
               m_current_signal=CLOSE_ALL;
           }
        }//END OF NOT REVERSAL

     }//END OF POS EXIST
   return(m_current_signal);
  }
//+------------------------------------------------------------------+
//| TR SIMPLE                                                        |
//+------------------------------------------------------------------+
ENUM_TR_SIGNAL AI_Empire::m_TR_Simple()
  {
//Default
   m_current_signal=NOTRADE;

//Check TR
//BUY
   if((m_current_empire_state==TREND_UP) && (RSI()<m_rsi_level_down_1)) m_current_signal=BUY;

//SELL
   else    if((m_current_empire_state==TREND_DOWN) && (RSI()>m_rsi_level_up_1)) m_current_signal=SELL;

//Complete Signal (Reverse\Close\ReverseVolume)
   m_CompleteSignal();

//Normal Result
   return(m_current_signal);
  }
//+------------------------------------------------------------------+
//| TR Trend Only                                                    |
//+------------------------------------------------------------------+
ENUM_TR_SIGNAL AI_Empire::m_TR_TrendOnly(void)
  {
//Default
   m_current_signal=NOTRADE;

//Check TR
//BUY
   if(m_current_empire_state==TREND_UP) m_current_signal=BUY;

//SELL
   else    if(m_current_empire_state==TREND_DOWN) m_current_signal=SELL;

//Complete Signal (Reverse\Close\ReverseVolume)
   m_CompleteSignal();

//Normal Result
   return(m_current_signal);
  }
//---CLASS----------------------------------------------------------//
AI_Empire emp();
//Init Structure
STRUCT_Init is={0};
//--------------INPUT--------------------
bool   input         _OpenBarOnly=true;                           // Calc ones only on New Bar
int    input         _EmpirePeriod=5;                             // Empire Period (min 2)
int    input         _EmpireDepth=2;                              // Empire Depth  (2..10)
int    input         _RSI_Period=2;                               // RSI Period (min 2)
input ENUM_TR_LIST   _TR_Num=Simple;                              // Select TR 
bool   input         _ReverseVolume=false;                        // Reverse Volume (Always in position)
bool   input         _ReverseSignal=false;                        // Reverse Signal (BUY->SELL & ViceVersa)
bool   input         _CloseReverseSignal=false;                   // Close by Reverse Signal
double input         _SL=10000;                                   // SL
double input         _TP=10000;                                   // TP
uchar  input         _BrokerFee=8;                                // Broker Fee Roundtrip (8$-100k)
double input         _Volume=0.01;                                // Start Volume
double input         _MaxVolume=0.02;                             // Max Volume
double input         _RSI_Level_UP_1=70;                         // RSI Level UP 1
double input         _RSI_Level_UP_2=90;                         // RSI Level UP 2
double input         _RSI_Level_DOWN_1=30;                       // RSI Level DOWN 1
double input         _RSI_Level_DOWN_2=10;                       // RSI Level DOWN 2
double input         _Shift_pts=20;                               // Add Volume Shift Points
uchar input          _Broker_Fee=8;                               // Broker Fee (def:8) 
bool   input         _Compounding=false;                          // Enable Compounding
string input         _Empire_Path="RIndicators//Empire8";         // Empire Path
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   is._MaxVolume=_MaxVolume;
   is._OpenBarsOnly=_OpenBarOnly;
   is._SL=_SL;
   is._TP=_TP;
   is._Volume=_Volume;
   is.ind_Empire_Path=_Empire_Path;
   is.ind_Empire_Depth=_EmpireDepth;
   is.ind_Empire_Period=_EmpirePeriod;
   is.ind_RSI_Period=_RSI_Period;
   is._TR_Num=_TR_Num;
   is._ReverseSignal=_ReverseSignal;
   is._ReverseVolume=_ReverseVolume;
   is._CloseReverseSignal=_CloseReverseSignal;
   is._Shift_pts=_Shift_pts;
   is._RSI_Level_UP_1=_RSI_Level_UP_1;
   is._RSI_Level_UP_2=_RSI_Level_UP_2;
   is._RSI_Level_DOWN_1=_RSI_Level_DOWN_1;
   is._RSI_Level_DOWN_2=_RSI_Level_DOWN_2;

   emp.Init(is);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   emp.DeInit();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   emp.NewPrice();
  }
//+------------------------------------------------------------------+
