# SCHR MQL5 Expert Advisors Collection

A collection of professional expert advisors for MetaTrader 5, developed by Shcherbyna Rostyslav.

## ☕ Support the Project

If you find these expert advisors helpful and would like to support the development, consider buying me a coffee or donating Bitcoin!

[![Buy Me A Coffee](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/neozork)

### 💰 Bitcoin Donation

**Bitcoin Address:** `bc1qm0ynz8tk2em3zr8agv5j3550vpm420z3hxdfkq`

```
bc1qm0ynz8tk2em3zr8agv5j3550vpm420z3hxdfkq
```

**QR Code for Bitcoin Wallet:**

![Bitcoin QR Code](https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=bc1qm0ynz8tk2em3zr8agv5j3550vpm420z3hxdfkq)

*Scan the QR code above or copy the address to send Bitcoin from any wallet or exchange.*

---

## 🚀 Main Experts

### SCHR_Global.mq5 - Main Expert
**Version:** 1.27  
**Status:** ✅ Working

Main expert with extended functionality for global trading. Supports multiple trading strategies and indicators.

#### Main Features:
- **Global Direction Filtering** - using various filters to determine trend direction
- **Open Price Signals** - trading based on candle open price
- **Multiple Trading Rules** - 40+ different strategies
- **Position Management** - flexible open/close settings
- **Trailing Stop** - virtual and server trailing for different position types
- **Martingale and Volume Addition** - automatic position size increase
- **Risk Protection** - margin and position count limitations

#### Trading Rules (OPEN TR):
- **TR_Simple** - Simple 4 filters
- **TR_2Filter** - 2 filters GL_D1(2), GS_M5(20)
- **TR_MOM_Test/New** - SCHR MOM strategies
- **TR_SCHRTRUE_Test** - SCHR True strategy
- **TR_Wave_Test** - SCHR Wave strategy
- **TR_SCHR_DDAV_Test** - SCHR DDAV strategy
- **TR_SCHR_TREND_Test** - SCHR Trend strategy
- **TR_SCHR_PRESSURE** - SCHR Pressure strategy
- **TR_LongTrend** - Long-term trend strategies
- **TR_VolD/VolDTop/VolDCross** - Volume Direction strategies
- **TR_SCHR_DIR_TREND/RANGE** - Tick strategies
- **TR_ShortTrend** - Short-term trend strategies
- **TR_MultiTrend_Test** - Multi-trend strategies
- **TR_Wave2** - Wave2 strategies

#### Close Parameters (CLOSE TR):
- **TR_CLOSE_NONE** - No closing by TR
- **TR_CLOSE_IN_PROFIT** - Close only in profit
- **TR_CLOSE_SHORT_TREND_ANY_NEW_SIGNAL** - Close on any new signal
- **TR_CLOSE_SHORT_TREND_RETRACEMENT_ONLY** - Close only on retracement
- **TR_CLOSE_SHORT_TREND_EXTREME_ONLY** - Close only on extremes

#### Main Settings:
- **Volume:** Initial 0.01, maximum 0.1
- **Stop Loss/Take Profit:** 1000/1200 points
- **Position Limits:** Maximum 100 positions, 10 groups
- **Margin:** Maximum 30%
- **Trailing:** Configurable for each position, all buys/sells, groups

#### Indicators:
- **SCHR CORE** - Main direction indicator
- **SCHR MOM** - Momentum indicator
- **SCHR True** - True indicator
- **SCHR Wave** - Wave indicator
- **SCHR DDAV** - DDAV indicator
- **SCHR Trend** - Trend indicator
- **SCHR Pressure** - Pressure indicator
- **SCHR VolD** - Volume Direction indicator

### SCHR_Machine.mq5 - Secondary Expert
**Version:** 1.20  
**Status:** ✅ Working

Specialized expert for working with open prices and various Empire indicators.

#### Main Features:
- **Open Price Trading** - working only on new candles
- **Multiple Indicators** - support for Empire, SCHR, ADX, Volume
- **Flexible Trading Rules** - 22 different strategies
- **Risk Management** - automatic closing by spread, gap protection
- **Trailing Stop** - virtual and fixed trailing
- **Volume Addition** - without signal when price improves
- **Auto-compounding** - automatic volume increase

#### Trading Rules:
- **TR_VolDTop** - Empire VolDTop strategy
- **TR_DDAV** - DDAV strategy
- **TR_Emp2** - Empire2 VOL strategy
- **TR_Pressure** - PressureBOT strategy
- **TR_LWMA** - SCHRP LWMA strategy
- **TR_LWMA_TDF_Collinear** - LWMA + TDF collinear
- **TR_MULTI_ADX** - Multi ADX as one trend line
- **TR_MULTI_Empire9** - 2 LWMA as one trend line

#### Empire Indicators:
- **Empire9** - LWMA with additional settings
- **Empire TDF** - Trend Direction Filter
- **Empire ADX** - Average Directional Index
- **Empire VOL** - Volume indicator
- **Empire VOL2** - Volume indicator with two MA
- **Empire CORE** - Core indicator

#### SCHR Indicators:
- **SCHR_PRESSURE** - Pressure indicator
- **SCHR_DDAV** - DDAV indicator
- **SCHR_DIFF** - Differential indicator
- **SCHR_REVERSE** - Reverse indicator
- **SCHR_DFIB** - Fibonacci indicator

## 🔧 Experts in Development

### AI_Empire.mq5
**Version:** 9.00  
**Status:** 🚧 In Development

Expert based on Empire8 + RSI(2) with prohibition of opening opposite trends.

### SCHR_CORE_R.mq5
**Status:** 🚧 In Development

### SCHR_RoboCore.mq5
**Status:** 🚧 In Development

### SCHR_SportBot.mq5
**Status:** 🚧 In Development

### HedgeHogR.mq5
**Status:** 🚧 In Development

### HFTZ.mq5
**Status:** 🚧 In Development

### FXTriangularArb.mq5
**Status:** 🚧 In Development

### ZHour.mq5
**Status:** 🚧 In Development

### ZSimple.mq5
**Status:** 🚧 In Development

### FRF.mq5
**Status:** 🚧 In Development

## 🚀 Quick Start

### Prerequisites
- MetaTrader 5 installed and configured
- Access to RInclude and RIndicators repositories
- Basic understanding of MQL5 and trading concepts

### Step-by-Step Installation

#### 1. Install Dependencies
First, you need to install the required libraries and indicators:

**RInclude Library:**
```bash
# Clone RInclude repository
git clone https://github.com/NeoZorK/RInclude.git
# Copy to MQL5/Include/ directory
cp -r RInclude/* "C:/Users/[YourUsername]/AppData/Roaming/MetaQuotes/Terminal/[TerminalID]/MQL5/Include/"
```

**RIndicators Collection:**
```bash
# Clone RIndicators repository
git clone https://github.com/NeoZorK/RIndicators.git
# Copy to MQL5/Indicators/ directory
cp -r RIndicators/* "C:/Users/[YourUsername]/AppData/Roaming/MetaQuotes/Terminal/[TerminalID]/MQL5/Indicators/"
```

#### 2. Install Expert Advisors
Copy the expert advisor files to your MetaTrader 5:

```bash
# Copy experts to MQL5/Experts/ directory
cp *.mq5 "C:/Users/[YourUsername]/AppData/Roaming/MetaQuotes/Terminal/[TerminalID]/MQL5/Experts/"
```

#### 3. Compile Experts
1. Open MetaTrader 5
2. Press `Ctrl+N` to open MetaEditor
3. Navigate to `Experts` folder
4. Right-click on each `.mq5` file and select "Compile"
5. Fix any compilation errors (usually related to missing includes)

#### 4. Configure Expert Parameters
1. In MetaTrader 5, go to `View → Expert Advisors`
2. Drag and drop `SCHR_Global.mq5` to any chart
3. Configure input parameters:
   - **Volume Settings:** Start with small volumes (0.01-0.05)
   - **Risk Management:** Set appropriate SL/TP levels
   - **Trading Rules:** Choose strategy based on market conditions
   - **Timeframes:** Select appropriate timeframes for your strategy

#### 5. Test on Demo Account
**IMPORTANT:** Always test on demo account first!

1. Open a demo account in MetaTrader 5
2. Apply the expert to a demo chart
3. Monitor performance for at least 1-2 weeks
4. Analyze results and adjust parameters

#### 6. Live Trading Setup
Once satisfied with demo results:

1. Ensure all dependencies are properly installed
2. Set conservative risk parameters
3. Start with small position sizes
4. Monitor performance closely
5. Have emergency stop procedures ready

### Common Issues and Solutions

#### Compilation Errors
- **Missing includes:** Ensure RInclude is properly installed
- **Missing indicators:** Verify RIndicators are in correct directory
- **Path issues:** Check file paths in include statements

#### Runtime Errors
- **Indicator not found:** Reinstall RIndicators
- **Function not found:** Check RInclude installation
- **Memory issues:** Reduce indicator periods or optimize code

#### Performance Issues
- **Slow execution:** Reduce indicator complexity
- **High CPU usage:** Optimize calculation frequency
- **Memory leaks:** Check for proper array management

## 📚 Dependencies

For proper operation of experts, additional libraries and indicators are required:

### RInclude
Library of functions and classes for MQL5:
- **RAccProtect.mqh** - Account protection
- **ROnOpenPrice.mqh** - Open price operations
- **RTrailing.mqh** - Trailing stop functions
- **RAddVolume.mqh** - Volume addition
- **RSingleMartin.mqh** - Martingale strategies
- **RMarginLimit.mqh** - Margin limitations
- **RClose.mqh** - Position closing functions
- **RDynCmpd.mqh** - Dynamic compounding
- **RDynArrManage.mqh** - Dynamic array management

**Repository:** [RInclude](https://github.com/NeoZorK/RInclude)

### RIndicators
Collection of SCHR indicators:
- **SCHR_CORE** - Main indicator
- **SCHR_MOM** - Momentum indicator
- **SCHR_True** - True indicator
- **SCHR_Wave** - Wave indicator
- **SCHR_DDAV** - DDAV indicator
- **SCHR_Trend** - Trend indicator
- **SCHR_Pressure** - Pressure indicator
- **SCHR_VolD** - Volume Direction indicator
- **Empire indicators** - Empire family

**Repository:** [RIndicators](https://github.com/NeoZorK/RIndicators)

## 👨‍💻 About Me

**Rostyslav Shcherbyna** - Experienced MQL5 developer and algorithmic trading specialist with over 5 years of experience in developing automated trading systems. Specialized in creating robust expert advisors with advanced risk management and multiple trading strategies.

**LinkedIn:** [Rostyslav Shcherbyna](https://www.linkedin.com/in/rostyslav-sh-)

**Expertise:**
- MQL5/MQL4 Development
- Algorithmic Trading Strategies
- Risk Management Systems
- Technical Analysis Indicators
- High-Frequency Trading
- Portfolio Management

## 🛠 Installation

1. Copy expert files to `MQL5/Experts/` folder
2. Install RInclude and RIndicators dependencies
3. Restart MetaTrader 5
4. Configure expert parameters according to your requirements

## ⚠️ Important Notes

- **Testing:** Always test experts on demo account before using on live account
- **Risk Management:** Set proper stop-losses and volume limitations
- **Monitoring:** Regularly check expert performance
- **Updates:** Keep track of dependency updates

## 📄 License

MIT License

Copyright (c) 2020-2025 Shcherbyna Rostyslav

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## 📞 Contacts

**Author:** Shcherbyna Rostyslav  
**Documentation Version:** 1.0  
**Last Updated:** 2025

---

*Warning: Trading on financial markets involves high risks. Use these experts at your own risk.*