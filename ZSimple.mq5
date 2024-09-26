//+------------------------------------------------------------------+
//|                                                      ZSimple.mq5 |
//|                                     Copyright 2015, NeoZorK PJSC |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, NeoZorK PJSC"
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <RInclude\NeoZorK.mqh>
/*
Открываем позици без стопа с профитом в 5 пт
открываем то в одну то в другую сторону
*/
uchar    sinput _MaxSpread=30;
double input _DefaultVolume=1;
//Докупаться, если цена упала на _ShiftPrice_Pt пунктов
ushort input _ShiftPrice_Pt=100;
double input _MaxVolume=5;
ushort     input _Commission=0; //Comission = 7$ per 1.0 lot
                                //best Rost factor 3
uchar  input _RostFactor=3;

ushort input _TP = 7;
ushort input _SL = 7000;

const ushort BUY=1005;
const ushort SELL=2006;
const ushort MAGIC_IB = 30000;
const ushort MAGIC_IS = 31000;
const uchar OP_BUY=0;
const uchar OP_SELL=1;
const ushort NO_MONEY=10019;

//GLOBAL VAR
string symbol;
bool ran=false;
double vol=0;
double prev_balance=0;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   symbol=Symbol();
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
//---
   double balance=AccountInfoDouble(ACCOUNT_BALANCE);

//Если текущий баланс меньше, чем был, то ++лот
   if(balance<prev_balance)
     {
      vol=vol*_RostFactor;
      if(vol>_MaxVolume)
        {
         vol=_DefaultVolume;
        }
     }
//Если заработали, то ставим минимальный лот  
   if(balance>prev_balance)
     {
      vol=_DefaultVolume;
     }

   if(balance<100)
     {
      return;
     }

//Есть ли у этого символа открытая позиция
   bool current_position=PositionSelect(symbol);

//Если нет открытых позиций
   if(!current_position)
     {

      if(!ran) //false
        {
         prev_balance=balance;
         int res=Rost_OpenMarketOrder(symbol,vol,OP_SELL,_SL,_TP,3,MAGIC_IS,"");
         if(res==NO_MONEY) //nomoney
           {
            return;
           }
         ran=true;

        }
      else //true
        {
         prev_balance=balance;
         int res3=Rost_OpenMarketOrder(symbol,vol,OP_BUY,_SL,_TP,3,MAGIC_IB,"");
         if(res3==NO_MONEY) //nomoney
           {
            return;
           }
         ran=false;

        }

     }//end of open pos
  }
//+------------------------------------------------------------------+
