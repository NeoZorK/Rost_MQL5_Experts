//+------------------------------------------------------------------+
//|                                                        ZHour.mq5 |
//|                                     Copyright 2015, NeoZorK PJSC |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, NeoZorK PJSC"
#property link      ""
#property version   "1.00"
#include <RInclude\NeoZork.mqh>

double arr_open[];
double arr_close[];

double input _DefaultVolume=0.1;
ushort input _tp=100;
ushort input _sl=500;
uchar  input _RostFactor=2;
uchar  input _MaxVolume=7;

const uchar OP_BUY=0;
const uchar OP_SELL=1;

double vol=0;
double prev_balance=0;
double balance=9;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   vol=_DefaultVolume;
   prev_balance=AccountInfoDouble(ACCOUNT_BALANCE);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//   balance=AccountInfoDouble(ACCOUNT_BALANCE);
//---


//если нет открытых позиций
   if(!PositionSelect(Symbol()))
     {

      MqlDateTime mdt;
      TimeTradeServer(mdt);

      if((mdt.hour==3) && (mdt.min==31))
        {
         CopyOpen(Symbol(),0,1,1,arr_open);
         CopyClose(Symbol(),0,1,1,arr_close);

         if(arr_open[0]<arr_close[0])
           {
            //open sell
           // prev_balance=balance;
            Rost_OpenMarketOrder(Symbol(),vol,OP_SELL,_sl,_tp,3,7777,"buy");
           }

         if(arr_open[0]>arr_close[0])
           {
            //open buy
         //   prev_balance=balance;
            Rost_OpenMarketOrder(Symbol(),vol,OP_BUY,_sl,_tp,3,7779,"buy");
           }
        }//end of minute
     }// end of no open positions yet


  }//end of tic
//+------------------------------------------------------------------+
