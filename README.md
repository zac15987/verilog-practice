# verilog-practice

Verilog 數位邏輯練習專案，使用 **Quartus II 13.1 Web Edition** 開發，目標 FPGA 為 **Cyclone IV GX**。

## 專案結構

每個電路為獨立的 Quartus 專案，模組之間以階層式架構組合：

| 專案 | 說明 | 依賴 |
|------|------|------|
| `half_adder` | 半加器 | — |
| `full_adder` | 全加器（2 個半加器 + OR 閘） | `half_adder` |
| `ripple_carry_adder` | 4-bit 漣波進位加法器（4 個全加器） | `full_adder`、`half_adder` |

## 開發環境

- **Quartus II** 13.1 Web Edition（64-bit）
- **ModelSim-Altera**（透過 Quartus 內建 qsim 流程執行模擬）

## 模擬方式

使用 Quartus 的 Vector Waveform File（`.vwf`）定義測試波形，透過內建的 qsim 流程進行功能模擬。波形檔已納入版本控制以確保測試可重現。

## Editor 配色

`quartus2_vscode_dark_theme.ini` 提供 VS Code Dark+ 風格的 Quartus 文字編輯器配色，安裝方式請參考檔案內的說明。
