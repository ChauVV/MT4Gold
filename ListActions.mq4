//+------------------------------------------------------------------+
//|                                              me_CloseAll v3b.mq4 |
//|                                       Copyright © 2021, qK Code. |
//|                                          www.facebook.com/qkcode |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2021, qK Code. (www.facebook.com/qkcode)"
#property link      "www.facebook.com/qkcode"
#property strict

extern int tpPrice = 100; // Take profit price
input int slPrice = 100; //stop lot price
input double pfAverate = 5; //profit Average in $
int Corner = 1;
int Move_X = 1;
int Move_Y = 1;
string B00001 = "============================";
int Button_Width = 70;
int Button_Height = 30;
string Font_Type = "Arial Bold";
color Font_Color = clrWhite;
int Font_Size = 8;

double marginLeft = 5;
double marginTop = 10;
double Pekali;

string tpStr = tpPrice;
string slStr = slPrice;

double selectedPrice = 0.0;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   CreateItems();

   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {

   updateLabels();

   return 0;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   DeleteItems();

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CreateItems()
  {
   Move_X = Button_Width + marginLeft;
// Row 1
   if(!LabelCreate(0, "lblLotBuy", 0,  Move_X, marginTop + 5, " ", clrTeal))
      return;
   if(!LabelCreate(0, "lblLotSell", 0,  Move_X, marginTop * 2  + Button_Height /2, " ", clrCrimson))
      return;
   if(!ButtonCreate(0, "CloseALL_btn", 0, Move_X, marginTop *3 + Button_Height *1, Button_Width, Button_Height, Corner, "Close All", Font_Type, Font_Size, clrWhite, clrGray, clrGray))
      return;
   if(!ButtonCreate(0, "CloseBuy_btn", 0, Move_X, marginTop * 4 + Button_Height * 2, Button_Width, Button_Height, Corner, "Close Buy",Font_Type, Font_Size, Font_Color, clrTeal, clrTeal))
      return;
   if(!ButtonCreate(0, "CloseSell_btn", 0, Move_X, marginTop * 5 + Button_Height * 3, Button_Width, Button_Height, Corner, "Close Sell",Font_Type, Font_Size, Font_Color, clrCrimson, clrCrimson))
      return;
   if(!ButtonCreate(0, "average___btn", 0, Move_X, marginTop * 6 + Button_Height * 4, Button_Width, Button_Height, Corner, "Average",Font_Type, Font_Size, clrCrimson, clrWhite, clrCrimson))
      return;
   if(!ButtonCreate(0, "SetTP_btn", 0, Move_X, marginTop * 7 + Button_Height * 5, Button_Width, Button_Height, Corner, "Set TP",Font_Type, Font_Size, clrTeal, clrWhite, clrTeal))
      return;
   if(!ButtonCreate(0, "SetSL_btn", 0, Move_X, marginTop * 8 + Button_Height * 6, Button_Width, Button_Height, Corner, "Set SL",Font_Type, Font_Size, clrCrimson, clrWhite, clrCrimson))
      return;
//if(!ButtonCreate(0, "CloseBuyD_btn", 0, Move_X, marginTop * 9 + Button_Height * 7, Button_Width, Button_Height, Corner, "Cls Buy +",Font_Type, Font_Size, Font_Color, clrTeal, clrTeal))
//   return;
//if(!ButtonCreate(0, "CloseSellD_btn", 0, Move_X, marginTop * 10 + Button_Height * 8, Button_Width, Button_Height, Corner, "Cls Sell +",Font_Type, Font_Size, Font_Color, clrCrimson, clrCrimson))
//   return;

// Row 2
   if(!CreateInput(0, "txtTp", 0, Move_X + marginLeft + Button_Width, marginTop * 7 + Button_Height * 5, selectedPrice))
      return;
//if(!CreateInput(0, "txtSl", 0, Move_X + marginLeft + Button_Width, marginTop * 6 + Button_Height * 5, 100))
//   return;





//if(!LabelCreate(0, "lblLotBuy", 0, 5, 20, "Lot buy: ", clrTeal))
//   return;
//if(!LabelCreate(0, "lblLotSell", 0, 5, 35, "Lot sell: ", clrCrimson))
//   return;
   ChartRedraw();
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DeleteItems()
  {
   DeleteObject(0, "CloseALL_btn");
   DeleteObject(0, "CloseBuy_btn");
   DeleteObject(0, "CloseSell_btn");
   DeleteObject(0, "average___btn");
   DeleteObject(0, "SetTP_btn");
   DeleteObject(0, "SetSL_btn");

   DeleteObject(0, "txtTp");
//DeleteObject(0, "txtSl");
   DeleteObject(0, "lblLotBuy");
   DeleteObject(0, "lblLotSell");
//DeleteObject(0, "CloseBuyD_btn");
//DeleteObject(0, "CloseSellD_btn");
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void updateLabels()
  {
   double allLotBuy = getAllLot(OP_BUY);
   double allLotSell = getAllLot(OP_SELL);

   double pfBuy = getProfit(OP_BUY);
   double pfSell = getProfit(OP_SELL);

   LabelTextChange(0, "lblLotBuy",  DoubleToStr(allLotBuy, 2) + "  " + DoubleToStr(pfBuy, 2) + "$");
   LabelTextChange(0, "lblLotSell", DoubleToStr(allLotSell, 2) + "  " + DoubleToStr(pfSell, 2) + "$");
   LabelTextChange(0, "txtTp",  selectedPrice);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &action)
  {
   ResetLastError();

   if(id==CHARTEVENT_CLICK)
     {
      //--- Prepare variables
      int      x     =(int)lparam;
      int      y     =(int)dparam;
      datetime dt    =0;
      double   price =0;
      int      window=0;
      //--- Convert the X and Y coordinates in terms of date/time
      if(ChartXYToTimePrice(0,x,y,window,dt,price))
        {
         Print("");// PrintFormat("Window=%d X=%d  Y=%d  =>  Time=%s  Price=%G",window,x,y,TimeToString(dt),price);
         //--- Perform reverse conversion: (X,Y) => (Time,Price)
         if(ChartTimePriceToXY(0,window,dt,price,x,y))
            Print(""); // PrintFormat("Time=%s  Price=%G  =>  X=%d  Y=%d",TimeToString(dt),price,x,y);
         else
            Print("ChartTimePriceToXY return error code: ",GetLastError());

         selectedPrice = NormalizeDouble(price, Digits);
         //--- delete lines
         //ObjectDelete(0,"V Line");
         //ObjectDelete(0,"H Line");
         ////--- create horizontal and vertical lines of the crosshair
         //ObjectCreate(0,"H Line",OBJ_HLINE,window,dt,price);
         //ObjectSet   ( "H Line", OBJPROP_COLOR, Blue);
         //ObjectCreate(0,"V Line",OBJ_VLINE,window,dt,price);
         //ChartRedraw(0);
        }
      else
         Print("ChartXYToTimePrice return error code: ",GetLastError());
      Print("+--------------------------------------------------------------+");
     }

   if(id == CHARTEVENT_OBJECT_CLICK)
     {
      if(ObjectType(action) == OBJ_BUTTON)
        {
         ButtonPressed(0, action);
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ButtonPressed(const long chartID, const string action)
  {

   ObjectSetInteger(chartID, action, OBJPROP_BORDER_COLOR, clrBlack);  // button pressed
   if(action == "CloseALL_btn")
      CloseAll_Button(action);
   if(action == "CloseBuy_btn")
      closeBuy(action);
   if(action == "CloseSell_btn")
      closeSell(action);

   if(action == "CloseBuy_btn")
      closeBuyDuong(action);
   if(action == "CloseSell_btn")
      closeSellDuong(action);

   if(action == "average___btn")
      getAveragePrice();
   if(action == "SetTP_btn")
      setTP(action);
   if(action == "SetSL_btn")
      setSL(action);

   Sleep(200);
//ObjectSetInteger(chartID, action, OBJPROP_BORDER_COLOR, clrYellow);  // button unpressed
   ObjectSetInteger(chartID, action, OBJPROP_STATE, false);  // button unpressed
   ChartRedraw();
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void getAveragePrice()
  {
   double sum_lot_b = 0;
   double sum_price_b = 0;
   double sum_profit_b  = 0;
   double ave_price_b = 0;

   double sum_lot_s = 0;
   double sum_price_s = 0;
   double sum_profit_s = 0;
   double ave_price_s = 0;

   int countBuy = 0;
   int countSell = 0;

   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == _Symbol)
        {
         double _profit = OrderProfit() + OrderSwap() + OrderCommission();
         if(OrderType() == OP_BUY)
           {
            sum_lot_b += OrderLots();
            sum_price_b += OrderOpenPrice() * OrderLots();
            sum_profit_b  += _profit;
            countBuy++;
           }
         if(OrderType() == OP_SELL)
           {
            sum_lot_s += OrderLots();
            sum_price_s += OrderOpenPrice() * OrderLots();
            sum_profit_s += _profit;
            countSell++;
           }
        }
     }

   if(sum_price_b > DBL_EPSILON)
     {
      sum_price_b /= sum_lot_b;
      ave_price_b = NormalizeDouble(((sum_profit_b)/(MathAbs(sum_lot_b*MarketInfo(Symbol(),MODE_TICKVALUE)))*MarketInfo(Symbol(),MODE_TICKSIZE)), _Digits);
     }
   if(sum_price_s > DBL_EPSILON)
     {
      sum_price_s /= sum_lot_s;
      ave_price_s = NormalizeDouble(((sum_profit_s)/(MathAbs(sum_lot_s*MarketInfo(Symbol(),MODE_TICKVALUE)))*MarketInfo(Symbol(),MODE_TICKSIZE)), _Digits);
     }

   double b = 0;
   double s = 0;

   if(countBuy > 0)
     {
      b = Bid + MathAbs(ave_price_b);
      blinkLine("Buy_line",b, clrGreen);
      selectedPrice = NormalizeDouble(ave_price_b, Digits);
     }

   if(countSell > 0)
     {
      s = Ask  -MathAbs(ave_price_s);
      blinkLine("Sell_line", s, clrRed);

      selectedPrice = NormalizeDouble(ave_price_s, Digits);
     }

   Comment(StringFormat("                                    Average prices:\n                                    > Buy = %G\n                                    > Sell = %G",b,s));
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void blinkLine(string lineName, double price, double colors)
  {
   int      x     =0;
   int      y     =0;
   datetime dt    =0;
   int      window=0;

   ObjectDelete(0,lineName);
   ObjectCreate(0,lineName,OBJ_HLINE,window,dt,price);
   ObjectSet("H Line", OBJPROP_COLOR, colors);
   ChartRedraw(0);
   Sleep(1000);
   ObjectDelete(0,lineName);
   ChartRedraw(0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getAllLot(int orderType)
  {
   double lots = 0;
   if(OrdersTotal() == 0)
      return(lots);
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true)
        {
         if(OrderType() == OP_BUY && OrderType() == orderType && OrderSymbol() == Symbol())
           {
            lots+= OrderLots();
           }
         if(OrderType() == OP_SELL && OrderType() == orderType && OrderSymbol() == Symbol())
           {
            lots+= OrderLots();
           }
        }
     }
   return(lots);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getProfit(int orderType)
  {
   double pf = 0;
   if(OrdersTotal() == 0)
      return(pf);
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true)
        {
         if(OrderType() == OP_BUY && OrderType() == orderType && OrderSymbol() == Symbol())
           {
            pf+= OrderProfit()+OrderCommission()+OrderSwap();
           }
         if(OrderType() == OP_SELL && OrderType() == orderType && OrderSymbol() == Symbol())
           {
            pf+= OrderProfit()+OrderCommission()+OrderSwap();
           }
        }
     }
   return(pf);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CloseAll_Button(const string action)
  {
   RefreshRates();
   int ticket;
   if(OrdersTotal() == 0)
      return(0);
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true)
        {
         if(OrderType() == OP_BUY && OrderSymbol() == Symbol())
           {
            ticket = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 0, clrNONE);
            if(ticket == -1)
               Print("Error : ", GetLastError());
            if(ticket >   0)
               Print("Position ", OrderTicket()," closed");
           }
         if(OrderType() == OP_SELL && OrderSymbol() == Symbol())
           {
            ticket = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 0, clrNONE);
            if(ticket == -1)
               Print("Error : ",  GetLastError());
            if(ticket >   0)
               Print("Position ", OrderTicket()," closed");
           }
        }
     }
   return(0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int closeBuy(const string action)
  {
   int ticket;
   if(OrdersTotal() == 0)
      return(0);
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true)
        {
         if(OrderType() == OP_BUY && OrderSymbol() == Symbol())
           {
            ticket = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 3, clrNONE);
            if(ticket == -1)
               Print("Error : ", GetLastError());
            if(ticket >   0)
               Print("Position ", OrderTicket()," closed");
           }

        }
     }
   return(0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int closeBuyDuong(const string action)
  {
   int ticket;
   if(OrdersTotal() == 0)
      return(0);
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true)
        {
         if(OrderType() == OP_BUY && OrderSymbol() == Symbol())
           {

            double pf = OrderProfit()+OrderCommission()+OrderSwap();
            if(pf > 0)
              {
               ticket = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 3, clrNONE);
               if(ticket == -1)
                  Print("Error : ", GetLastError());
               if(ticket >   0)
                  Print("Position ", OrderTicket()," closed");
              }
           }

        }
     }
   return(0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int closeSell(const string action)
  {
   int ticket;
   if(OrdersTotal() == 0)
      return(0);
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true)
        {

         if(OrderType() == OP_SELL && OrderSymbol() == Symbol())
           {
            ticket = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 3, clrNONE);
            if(ticket == -1)
               Print("Error : ",  GetLastError());
            if(ticket >   0)
               Print("Position ", OrderTicket()," closed");
           }
        }
     }
   return(0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int closeSellDuong(const string action)
  {
   int ticket;
   if(OrdersTotal() == 0)
      return(0);
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true)
        {
         if(OrderType() == OP_SELL && OrderSymbol() == Symbol())
           {
            double pf = OrderProfit()+OrderCommission()+OrderSwap();
            if(pf > 0)
              {
               ticket = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 3, clrNONE);
               if(ticket == -1)
                  Print("Error : ",  GetLastError());
               if(ticket >   0)
                  Print("Position ", OrderTicket()," closed");
              }
           }
        }
     }
   return(0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int setTP(const string action)
  {
   int ticket;
   if(OrdersTotal() == 0)
      return(0);

   if(selectedPrice == 0)
      return 0;

   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true)
        {

         if(OrderType() == OP_BUY && OrderSymbol() == Symbol())
           {
            OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),selectedPrice,0,0);
           }
         if(OrderType() == OP_SELL && OrderSymbol() == Symbol())
           {
            OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),selectedPrice,0,0);
           }
        }
     }
   return(0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int setSL(const string action)
  {
   if(OrdersTotal() == 0)
      return(0);

   if(selectedPrice == 0)
      return 0;

   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true)
        {

         if(OrderType() == OP_BUY && OrderSymbol() == Symbol())
           {
            OrderModify(OrderTicket(),OrderOpenPrice(),selectedPrice,OrderTakeProfit(),0,0);
           }
         if(OrderType() == OP_SELL && OrderSymbol() == Symbol())
           {
            OrderModify(OrderTicket(),OrderOpenPrice(),selectedPrice,OrderTakeProfit(),0,0);
           }
        }
     }
   return(0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Delete___Button(const string action)
  {
   int ticket;
   if(OrdersTotal() == 0)
      return(0);
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true)
        {
         if(OrderType() == OP_BUYLIMIT && OrderSymbol() == Symbol())
           {
            ticket = OrderDelete(OrderTicket(), clrNONE);
            if(ticket == -1)
               Print("Error : ",  GetLastError());
            if(ticket >   0)
               Print("Position ", OrderTicket()," closed");
           }
         if(OrderType() == OP_SELLLIMIT && OrderSymbol() == Symbol())
           {
            ticket = OrderDelete(OrderTicket(), clrNONE);
            if(ticket == -1)
               Print("Error : ",  GetLastError());
            if(ticket >   0)
               Print("Position ", OrderTicket()," closed");
           }
         if(OrderType() == OP_BUYSTOP && OrderSymbol() == Symbol())
           {
            ticket = OrderDelete(OrderTicket(), clrNONE);
            if(ticket == -1)
               Print("Error : ",  GetLastError());
            if(ticket >   0)
               Print("Position ", OrderTicket()," closed");
           }
         if(OrderType() == OP_SELLSTOP && OrderSymbol() == Symbol())
           {
            ticket = OrderDelete(OrderTicket(), clrNONE);
            if(ticket == -1)
               Print("Error : ",  GetLastError());
            if(ticket >   0)
               Print("Position ", OrderTicket()," closed");
           }
        }
     }
   return(0);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CreateInput(
   const long chart_ID = 0,
   const string name = "edit",
   const int sub_window = 0,
   const int x = 0,
   const int y = 0,
   const double value=500
)
  {
   ResetLastError();
   if(!ObjectCreate(chart_ID, name, OBJ_EDIT, sub_window, 0, 0))
     {
      Print(__FUNCTION__, " : failed to create the edit! Error code : ", GetLastError());
      return(false);
     }
//ObjectCreate ("SL_Edit", OBJ_EDIT, ChartWindowFind(), 0, 0);
   ObjectSet(name, OBJPROP_CORNER, Corner);
   ObjectSet(name, OBJPROP_XSIZE, Button_Width);
   ObjectSet(name, OBJPROP_YSIZE, Button_Height*2/3);
   ObjectSet(name, OBJPROP_XDISTANCE, x);
   ObjectSet(name, OBJPROP_YDISTANCE, y + Button_Height/6);
   ObjectSet(name, OBJPROP_ALIGN, ALIGN_CENTER);
   ObjectSetText(name, value, 13, Font_Type, Font_Color);
   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool DeleteObject(const long chart_ID=0, const string name="Button")
  {
   ResetLastError();
   if(!ObjectDelete(chart_ID,name))
     {
      Print(__FUNCTION__, ": Failed to delete the object! Error code = ", GetLastError());
      return(false);
     }
   return(true);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool EditTextGet(string      &text,        // text
                 const long   chart_ID=0,  // chart's ID
                 const string name="Edit") // object name
  {
   ResetLastError();

   if(!ObjectGetString(chart_ID,name,OBJPROP_TEXT,0,text))
     {
      Print(__FUNCTION__,
            ": failed to get the text! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool LabelCreate(const long              chart_ID=0,               // chart's ID
                 const string            name="Label",             // label name
                 const int               sub_window=0,             // subwindow index
                 const int               x=0,                      // X coordinate
                 const int               y=0,                      // Y coordinate
                 const string            text="Label",             // text
                 const color             clr=clrRed              // color
                )
  {
   int  corner=Corner; // chart corner for anchoring
   double            angle=0.0;                // text slope
   int anchor=0; // anchor type
   bool              back=false;               // in the background
   bool              selection=false;          // highlight to move
   bool              hidden=true;              // hidden in the object list
   long              z_order=0;
   string            font="Arial";             // font
   int               font_size=10;             // font size
//--- reset the error value
   ResetLastError();
//--- create a text label
   if(!ObjectCreate(chart_ID,name,OBJ_LABEL,sub_window,0,0))
     {
      Print(__FUNCTION__,
            ": failed to create text label! Error code = ",GetLastError());
      return(false);
     }
//--- set label coordinates
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
//--- set the chart's corner, relative to which point coordinates are defined
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
//--- set the text
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
//--- set text font
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
//--- set font size
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
//--- set the slope angle of the text
   ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
//--- set anchor type
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
//--- set color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of moving the label by mouse
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool LabelTextChange(const long   chart_ID=0,   // chart's ID
                     const string name="Label", // object name
                     const string text="Text")  // text
  {
//--- reset the error value
   ResetLastError();
//--- change object text
   if(!ObjectSetString(chart_ID,name,OBJPROP_TEXT,text))
     {
      Print(__FUNCTION__,
            ": failed to change the text! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ButtonCreate(
   const long chart_ID = 0,
   const string name = "Button",
   const int sub_window = 0,
   const int x = 0,
   const int y = 0,
   const int width = 500,
   const int height = 18,
   int corner = 0,
   const string text = "button",
   const string font = "Arial Bold",
   const int font_size = 10,
   const color clr = clrBlack,
   const color back_clr = C'170,170,170',
   const color border_clr = clrNONE,
   const bool state = false,
   const bool back = false,
   const bool selection = false,
   const bool hidden = true,
   const long z_order = 0)
  {
   ResetLastError();
   if(!ObjectCreate(chart_ID,name, OBJ_BUTTON, sub_window, 0, 0))
     {
      Print(__FUNCTION__, " : failed to create the button! Error code : ", GetLastError());
      return(false);
     }
   ObjectSetInteger(chart_ID, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(chart_ID, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(chart_ID, name, OBJPROP_XSIZE, width);
   ObjectSetInteger(chart_ID, name, OBJPROP_YSIZE, height);
   ObjectSetInteger(chart_ID, name, OBJPROP_CORNER, corner);
   ObjectSetInteger(chart_ID, name, OBJPROP_FONTSIZE, font_size);
   ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
   ObjectSetInteger(chart_ID, name, OBJPROP_BGCOLOR, back_clr);
   ObjectSetInteger(chart_ID, name, OBJPROP_BORDER_COLOR, border_clr);
   ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);
   ObjectSetInteger(chart_ID, name, OBJPROP_STATE, state);
   ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, selection);
   ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, selection);
   ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN, hidden);
   ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER,z_order);
   ObjectSetString(chart_ID, name, OBJPROP_TEXT, text);
   ObjectSetString(chart_ID, name, OBJPROP_FONT, font);
   return(true);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ToolTips_Text(const string action)
  {
   if(action == "CloseALL_btn")
     {
      ObjectSetString(0, action, OBJPROP_TOOLTIP, "Close Open Order(s) for **Current Chart** ONLY");
     }
   if(action == "average___btn")
     {
      ObjectSetString(0, action, OBJPROP_TOOLTIP, "Get Average Prices");
     }
   if(action == "SLplusOnebtn")
     {
      ObjectSetString(0, action, OBJPROP_TOOLTIP, "Add 1.0 pip to SL for ALL Open Order(s) on **Current Chart** ONLY");
     }
   if(action == "DeleteSL_btn")
     {
      ObjectSetString(0, action, OBJPROP_TOOLTIP, "Remove current SL value for ALL Open Order(s) on **Current Chart** ONLY");
     }
   if(action == "ChangeSL_btn")
     {
      ObjectSetString(0, action, OBJPROP_TOOLTIP, "Change SL value for ALL Open Order(s) on **Current Chart** ONLY");
     }
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
