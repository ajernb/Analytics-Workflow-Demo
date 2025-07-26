# Analytics-Workflow-Demo
Visualisering av kampanj-, sessions- och e-handelsdata i BigQuery och Looker Studio, med fokus på datarensning, vyer och interaktiva dashboards.

Projektet demonstrerar hur större och ostrukturerade datamängder från olika källor kan kopplas samman och analyseras med SQL, samt visualiseras för affärsinsikter i Looker Studio. Syftet är att visa metodik för att hantera verklighetstrogna analysflöden.

Dataseten kommer från tre oberoende källor på Kaggle. För att möjliggöra kopplingar och skapa rimliga nyckeltal har datan manipulerats och förenklats. I vissa fall har även gemensamma ID:n, som `user_id`, behövt konstrueras för att simulera relationer mellan tabellerna. Värdena speglar inte verkliga utfall, utan syftar till att skapa en fungerande struktur för analys. För enkelhetens skull har all data begränsats till tidsperioden 1–31 augusti 2024.

## Innehåll

- `sql/` – SQL-filer för datarensning, transformation och vyer
- `screenshots/` – Exempelbilder från Looker Studio
- `README.md` – Projektbeskrivning

## Datakällor

- [Marketing Campaign Performance Dataset](https://www.kaggle.com/datasets/manishabhatt22/marketing-campaign-performance-dataset/data)  
- [E-commerce Customer Behavior Dataset](https://www.kaggle.com/datasets/uom190346a/e-commerce-customer-behavior-dataset)  
- [Session Data](https://www.kaggle.com/datasets/faheem113141/session-data)

## Dashboard
[Öppna Looker Studio-dashboard](https://lookerstudio.google.com/s/iB_asZxiVWg)
