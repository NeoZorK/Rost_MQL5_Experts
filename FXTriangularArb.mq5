//+------------------------------------------------------------------+
//|                                          FX Triangular Arbitrage |
//|                                Copyright 2024.07.30, NeoZorK     |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024"
#property link      "https://"
#property version   "1.00"


/*
TODO:
1) add to input ability to choose 3x symbols
*/


// INCLUDE
#include <Trade\Trade.mqh>

CTrade Trade;

// INPUT
input double inpLot = 0.01;                                             // Lot size per thousand dollars of account balance
input double inpFee = 7.0;                                              // Total commission per lot traded
input bool inpPlot_Max_Diff = false;                                    // Flag to control plotting of maximum price difference

// Triangular Arbitrage Struct
struct STRUCT_TRIANGULAR_ARBITRAGE
  {
   double            a_Bid; // A BID
   double            b_Bid; // B BID
   double            c_Bid; // C BID
   double            a_Ask; // A ASK
   double            b_Ask; // B ASK
   double            c_Ask; // C ASK
   //
   double            diff_AB  ;    // A_ASK / B_BID
   double            diff_BA  ;    // A_BID / A_ASK
   //
   double            a_spread;     // Spread A in prices
   double            b_spread;     // Spread B in prices
   double            c_spread;     // Spread C in prices
  };

//+------------------------------------------------------------------+
//|   INIT                                                           |
//+------------------------------------------------------------------+
int OnInit()
  {
   return INIT_SUCCEEDED;
  }
//+------------------------------------------------------------------+
//|     DEINIT                                                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

  }
//+------------------------------------------------------------------+
//|   ONTICK                                                         |
//+------------------------------------------------------------------+
void OnTick()
  {
   STRUCT_TRIANGULAR_ARBITRAGE triArb;

// Fill Arb Struct
   triArb.a_Ask = SymbolInfoDouble("EURUSD", SYMBOL_ASK);
   triArb.a_Bid = SymbolInfoDouble("EURUSD", SYMBOL_BID);
   triArb.b_Ask = SymbolInfoDouble("GBPUSD", SYMBOL_ASK);
   triArb.b_Bid = SymbolInfoDouble("GBPUSD", SYMBOL_BID);
   triArb.c_Ask = SymbolInfoDouble("EURGBP", SYMBOL_ASK);
   triArb.c_Bid = SymbolInfoDouble("EURGBP", SYMBOL_BID);
   triArb.a_spread = SymbolInfoInteger("EURUSD", SYMBOL_SPREAD) * _Point;
   triArb.b_spread = SymbolInfoInteger("GBPUSD", SYMBOL_SPREAD) * _Point;
   triArb.c_spread = SymbolInfoInteger("EURGBP", SYMBOL_SPREAD) * _Point;

/// Zero Div Check
   if(triArb.b_Bid <= 0)
      return;

// Fill AB Diff
   triArb.diff_AB = triArb.a_Ask / triArb.b_Bid;

/// Zero Div Check
   if(triArb.b_Ask <= 0)
      return;

// Fill BA Diff
   triArb.diff_BA =  triArb.a_Bid / triArb.b_Ask;

// Fee Calculation in prices
   double total_fee = 3 * inpFee * _Point;

// Total Spread calculation in prices
   double total_spread = triArb.a_spread + triArb.b_spread + triArb.c_spread;

// Round
   double new_PlusRound = Round(total_fee + total_spread, _Digits);
   double new_MinusRound = Round(-total_fee - total_spread, _Digits);


   /*
   // Track and log the largest price difference if plotting is enabled
      static double biggest = 0.0;

      if(inpPlot_Max_Diff)
         if(MathAbs(EURUSD_Ask__GBPUSD_bid - EURGBP_Ask) > biggest)
           {
            biggest = MathAbs(EURUSD_Ask__GBPUSD_bid - EURGBP_Ask);
            PrintFormat("Biggest Difference in points: %.5lf", biggest);
            PrintFormat("Needed: %.5lf", _Point + Round(3 * inpFee * _Point + SymbolInfoInteger("EURUSD", SYMBOL_SPREAD)*_Point +
                        SymbolInfoInteger("GBPUSD", SYMBOL_SPREAD)*_Point +
                        SymbolInfoInteger("EURGBP", SYMBOL_SPREAD)*_Point, _Digits));
           }
   */
// Check for an arbitrage opportunity to sell EURGBP
   if(triArb.diff_AB - triArb.c_Ask > _Point + new_PlusRound)
     {

      printf("Opportunity : EURUSD SELL > " + (string) new_PlusRound);
      printf("EURUSD Ask / GBPUSD Bid " + (string)triArb.diff_AB + " - " + " EURGBP Ask " + (string)triArb.c_Ask + " = " + (string)(triArb.diff_AB - triArb.c_Ask));


      // Close negative side of trades
      CloseNegSide();

      // Check if there are no open positions
      if(!PositionsTotal())
        {
         Trade.Sell(inpLot, "EURUSD");
         Trade.Buy(inpLot, "GBPUSD");
         Trade.Buy(inpLot, "EURGBP");
         return;
        }
     }

// Check for an arbitrage opportunity to buy EURGBP
   if(triArb.diff_BA - triArb.c_Bid < -_Point + new_MinusRound)
     {

      printf("Opportunity : EURUSD BUY < " + (string) new_MinusRound);
      printf("EURUSD Bid / GBPUSD Ask " + (string)triArb.diff_BA + " - " + " EURGBP Bid " + (string)triArb.c_Bid + " = " + (string)(triArb.diff_BA - triArb.c_Bid));

      // Close positive side of trades
      ClosePosSide();

      // Check if there are no open positions
      if(!PositionsTotal())
        {
         Trade.Buy(inpLot, "EURUSD");
         Trade.Sell(inpLot, "GBPUSD");
         Trade.Sell(inpLot, "EURGBP");
         return;
        }
     }
  }// END OF ON TICK
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Function to close the positive side: EURGBP GBPUSD Buy and EURUSD Sell positions
void ClosePosSide()
  {
   for(int i = 0; i < PositionsTotal(); i++)
      if(PositionSelectByTicket(PositionGetTicket(i)))
        {
         ENUM_POSITION_TYPE Type = (ENUM_POSITION_TYPE) PositionGetInteger(POSITION_TYPE);
         string symb = PositionGetString(POSITION_SYMBOL);

         // Close buy positions for GBPUSD or EURGBP
         if(Type == POSITION_TYPE_BUY && (symb == "GBPUSD" || symb == "EURGBP"))
            Trade.PositionClose(PositionGetTicket(i));

         // Close sell positions for EURUSD
         if(Type == POSITION_TYPE_SELL && symb == "EURUSD")
            Trade.PositionClose(PositionGetTicket(i));
        }
  }
//+------------------------------------------------------------------+
//|     EURGBP GBPUSD Sell and EURUSD Buy positions                  |
//+------------------------------------------------------------------+
void CloseNegSide()
  {
   for(int i = 0; i < PositionsTotal(); i++)
      if(PositionSelectByTicket(PositionGetTicket(i)))
        {
         ENUM_POSITION_TYPE Type = (ENUM_POSITION_TYPE) PositionGetInteger(POSITION_TYPE);
         string symb = PositionGetString(POSITION_SYMBOL);


         if(Type == POSITION_TYPE_SELL && (symb == "GBPUSD" || symb == "EURGBP"))
            Trade.PositionClose(PositionGetTicket(i));


         // Close buy positions for EURUSD
         if(Type == POSITION_TYPE_BUY && symb == "EURUSD")
            Trade.PositionClose(PositionGetTicket(i));
        }
  }
//+------------------------------------------------------------------+
//|  Generic function to round a value to a specified number of decimal places   |
//+------------------------------------------------------------------+
double Round(double value, int decimals)
  {
// Validate input
   if(decimals < 0)
     {
      Print("Wrong decimals input parameter, parameter can't be below 0");
      return 0;
     }
   double timesten = value * MathPow(10, decimals);
   timesten = MathRound(timesten);
   double truevalue = timesten / MathPow(10, decimals);
   return truevalue;
  }
//+------------------------------------------------------------------+
