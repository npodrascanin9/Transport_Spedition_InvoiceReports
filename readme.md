# TRANSPORT & SPEDITION Portfolio Mini Project

---

## 1. What's the business problem?

### I) How the problem began?
- Let's assume I work for the company "MyCompany d.o.o.", which specializes in software development for transportation and spedition.
- The client recently requested an invoice report for various services, where each company can have multiple invoices.
- The current procedure: spGetInvoiceReportById_v1 (located in the 4. Stored Procedures folder) returns two result sets: invoice details and invoice items.
- However, over time, new requirements have been made - incoterm rules.

<br>
Table: Incoterm Rules:

<br>

<img width="1633" height="97" alt="image" src="https://github.com/user-attachments/assets/3f577ac8-e8ca-41d2-b1f5-3e7744a67617" />


<br>

### II) What are incoterm rules?
- Incoterm rules in transporation & spedition represent the relationships between the seller and the buyer regarding: obligations, costs, and responsibilities during the transportation and delivery of goods. 
- They define who is responsible for what, when, and where, as well as who bears the costs at various stages of delivery. Parities are key to ensuring clarity and protecting interests in international trade.
- For a better understanding the concept, here is the picture bellow:

<br>
<img width="598" height="602" alt="image" src="https://github.com/user-attachments/assets/589def89-e843-45ba-81de-92844870ed58" />
<br>

### III) Business scenario examples regarding incoterm rules
- if **EXW** is selected, the buyer is responsible for all the cost types.
- If **CIF** is selected, the seller is responsible for the transport and insurance costs, while the buyer is responsible for customs clearance. The sale-of-goods amount represents the commercial value of the goods - which is payed usually by the buyer subject.

### IV) Concslusion of the problem
- Due to this change, the existing procedure `spGetInvoiceReportById_v1` no longer meets the requirements
- Klijent traži novu verziju: **`spGetInvoiceReportById_v2`** koja će na osnovu odabranog pariteta prikazivati ko je kome koliko dužan.
- The client is requesting a new procedure version: **`spGetInvoiceReportById_v2`**, which will display who owes whom and how much, based on the selected parity.
- Currently, there are two subjects involved: **Buyer** and **Seller**.

---

## 2. How to solve the problem?

### I) New tables (ERP - Entity relationship diagram)

#### a) Current tables:

<img width="1358" height="582" alt="image" src="https://github.com/user-attachments/assets/400c976d-ab38-4c5f-9a68-df85fc8ef783" />


<br>

- In this version, there are no tables like IncotermRules, which is actually what the client requires.

#### b) New tables that need to be created and populated:

<img width="1340" height="882" alt="image" src="https://github.com/user-attachments/assets/5fe25ee4-bb02-4d6a-bbd5-874a72b4ddd0" />


<br>

- New tables include: Subjects, InvoiceSubjects, IncotermRules, and IncotermCostResponsibilities.

> Note: column **CompanyId** is dropped in the table **Invoices**. So, we are gonna use this table - **InvoiceSubjects** instead.

### II) Stored Procedures
- **old procedure**: `spGetInvoiceReportById_v1` — simply displays details of an invoice, including items. Picture bellow as an example:

<img width="1156" height="487" alt="image" src="https://github.com/user-attachments/assets/de5c71e7-57c2-4975-bc50-76deed158f75" />


<br>

- **new procedure**: `spGetInvoiceReportById_v2` — this version includes new logic regarding incoterm rules (who owes who'm, and how much). Picture bellow as an example:

<img width="1702" height="562" alt="image" src="https://github.com/user-attachments/assets/cf48f7ce-0d60-4ec2-b277-50e577dcab38" />


<br>

- **User Function**: `CalculateAmounts` — very usefull for calculating the amount of invoice items based on the incoterm rules.

<br>
---

## 3. Future considerations and potential problems

- It's possible that the client in the future requires a "non-existing" incoterm rule, such as **Custom Incoterm rule**, whereas the buyer and seller sign a contract who will pay what.
- As a solution to this problem that might happen in the future, we can add a new table - **CustomInvoiceCostResponsibilities**, where we could store those custom records (CostTypeId, InvoiceId, SubjectId, AmountPercentage, etc.).
- `spGetInvoiceReportById_v2` - this procedure can be easiliy updated. We can use union all to place this new logic with the custom incoterm rule, or simply join invoiceItems to this new table.
