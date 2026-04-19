# 📊 Z_CUSTOM_ALV_SALES_REPORT

### Custom SAP ABAP ALV Sales Order Status Report

---

## 📌 Overview

`Z_CUSTOM_ALV_SALES_REPORT` is a custom ABAP report developed to analyze and monitor **Sales Order data** in SAP using **ALV (ABAP List Viewer)**.

The report integrates data from key SAP tables:

* VBAK (Sales Order Header)
* VBAP (Sales Order Items)
* KNA1 (Customer Master Data)

It provides a structured, interactive, and visually enhanced reporting solution for business users.

---

##  Objectives

* Provide real-time visibility of Sales Orders
* Identify overdue orders using aging logic
* Enable quick navigation to detailed SAP transactions
* Demonstrate ALV reporting and ABAP programming concepts

---

##  Features

###  Interactive ALV Grid

* Zebra pattern for readability
* Auto-adjusted column widths
* Aggregation (Sum) for Quantity & Net Value

###  Status-Based Color Coding

| Status  | Condition  | Color     |
| ------- | ---------- | --------- |
| Overdue | > 30 days  | 🔴 Red    |
| Warning | 15–30 days | 🟡 Yellow |
| Normal  | < 15 days  | 🟢 Green  |

###  Drill-Down Functionality

* Double-click on Sales Order opens:
  → VA03

###  Aggregated Insights

* Total Quantity
* Total Net Value

---

##  Technical Architecture

* **Language:** ABAP
* **Program Type:** Executable Report (SE38)
* **ALV Technology:** `REUSE_ALV_GRID_DISPLAY`
* **Database Access:** Optimized SQL Join
* **Tables Used:** VBAK, VBAP, KNA1

---

## Selection Screen

Users can filter report data based on:

* Sales Order Date
* Customer Number
* Order Type
* Sales Organization (default: 1000)

---
## Process Flow



1. User enters selection criteria
2. System retrieves data via SQL joins
3. Order aging is calculated
4. Color coding is applied
5. ALV Grid is displayed
6. User interacts (sort, filter, drill-down)

---

##  Project Structure

```id="q2x8hs"
Z_CUSTOM_ALV_SALES_REPORT
│
├── Data Selection (SQL Join)
├── Internal Table Processing
├── Aging & Color Logic
├── Field Catalog Definition
├── ALV Layout Configuration
└── ALV Display Output
```

---

##  How to Run

1. Open SAP GUI
2. Go to transaction: `SE38`
3. Enter program name: `Z_CUSTOM_ALV_SALES_REPORT`
4. Execute (F8)
5. Provide selection inputs
6. View ALV output

---

##  Business Benefits

* Improved monitoring of sales order status
* Faster identification of delayed orders
* Enhanced reporting compared to standard SAP lists
* Better decision-making support for business users

---

##  Learning Outcomes

* ALV Grid implementation in ABAP
* SQL joins and data retrieval optimization
* Internal table handling
* Event handling (double-click navigation)
* Data visualization techniques in SAP

---

##  Future Enhancements

* Upgrade to **OO ALV (CL_GUI_ALV_GRID)**
* Convert to **CDS Views + Fiori Application**
* Add Excel export functionality
* Integrate delivery and billing status

---

##  Author

**Kislaya Srivastava**
---

## License

This project is developed for **academic and educational purposes only**.

---
