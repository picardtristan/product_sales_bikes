# Project Product sales bikes from 2017 to 2021

### Project Overview
This data analysis project aims to provide insights into the sales of products from 2017 to 2021. By analyzing the sales and profitability we want to identify trends to make data-driven recommandations and gain a depper understanding of the company's performance.

### Dataset
We download the dataset [Product_sales](https://data.world/sonalnew/productsales/workspace/file?filename=PRODUCT+SALES.csv) on data.world.
The dataset contains the sales of 3 categories of product in 6 countries for the year 2017 to 2021.

### Tools
- MariaDB on [sqliteonline](https://sqliteonline.com/)
- Tableau - Visualizations

### Exploratory Data Analysis and data cleaning
For the EDA we decided to use MariaDB on sqliteonline. See the code in the following link: [SQL script](https://github.com/picardtristan/product_sales_bikes/blob/main/Project%20Product%20sales%20script%20SQL.sql)

### Data visualization
For the vizualisation we decided to build a dashboard on [Tableau](https://public.tableau.com/app/profile/tristan.picard/viz/Productsalesbikes2017to2021/Dashboard1)

### Conclusions
- The more profitability category is the Bikes, then is the accessories, and after the clothing
- For the accessories and the clothing men are first whereas for the bike women are first
- The highest product category for the total revenue is bike. We can see that Canada is last for the bike but third for accessories and clothing.  We can recommend to put more effort to sell bikes in Canada or to understand where they buy bike
- To resume the better gross margin:
  -	Country => Canada
  -	Year => 2019 (the only year with 7 months of activity)
  -	Product category => Accessories
  -	Age group => Seniors (64+)
  -	Customer gender => Male
- The worst gross margin:
  -	Country => Australia
  -	Year => 2017 (the only year with only bike activity)
  -	Product category => Clothing
  -	Age group => Young adults (25-34)
  -	Customer gender => Female






