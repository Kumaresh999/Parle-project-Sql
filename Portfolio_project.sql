use parle;
select * from sales_parle_ws;
  #  DSM wise Total sales in last month
select DSM,round(sum(Aug23),2) as total_aug from sales_parle_ws group by DSM order by total_aug desc;
# DSM wise Calculate growth between last year Aug22 vs Current year Aug 23
select DSM,round(sum(Aug23),2) as total_aug23,round(sum(Aug22),2) as total_aug22,round((((sum(Aug23)-sum(Aug22))/sum(Aug22)))*100,2) as growth from sales_parle_ws group by DSM order by growth desc;
# DSM wise calculate the growth between current year Aug23 vs Jul23
select DSM,round(sum(Aug23),2) as total_aug23,round(sum(Jul23),2) as total_Jul23,round((((sum(Aug23)-sum(Jul23))/sum(Jul23)))*100,2) as growth from sales_parle_ws group by DSM order by growth desc;
# Top 1o Wholesaler current year Aug23
select WSName,round(sum(Aug23),2) as total_aug from sales_parle_ws group by WSName order by total_aug desc limit 10;
# Top 5 highest selling city current year Aug23
select city,round(sum(Aug23),2) as total_aug from sales_parle_ws group by WSName order by total_aug desc limit 5;
#DSM wise current year total sales
select DSM ,round((sum(Jan23)+sum(Feb23)+sum(Mar23)+Sum(Apr23)+sum(May23)+sum(Jun23)+sum(Jul23)+sum(Aug23)),2) 
as total from sales_parle_ws group by DSM order by total desc;
#  wholesaler  current month growth 
select WSName,round(sum(Aug23),2) as total_aug23,round(sum(Jul23),2) as total_Jul23,round((((sum(Aug23)-sum(Jul23))/sum(Jul23)))*100,2) as wholesaler_growth
 from sales_parle_ws group by WSName order by wholesaler_growth desc;
 # Negetive growth wholesaler
 select WSName,round(sum(Aug23),2) as total_aug23,round(sum(Jul23),2) as total_Jul23,round((((sum(Aug23)-sum(Jul23))/sum(Jul23)))*100,2) as wholesaler_growth
 from sales_parle_ws group by WSName having wholesaler_growth<0 order by wholesaler_growth desc;
 # Find the  Wholesaler type acoording their last month sales
 select WSname,sum(Aug23),
 case
  when sum(Aug23)>=500000 then "Excelent"
  when (Aug23)>=200000 then "very good"
   else "good"
   end as wholesaler_type
   from sales_parle_ws group by WSName;
   # DSM wise maximum selling wholesaler in Aug23

select   DSM, WSName, max(Aug23) as Max_sales
 from  sales_parle_ws group by DSM order by Max_sales DESC; 
# Rtrgroupwise total sales in Aug23
 
 select  distinct  RtrGroupName,sum(Aug23) over (partition by RtrGroupName) as Total_sales from sales_parle_ws ;
 #DSM wise frowth last quater 22 vs 1st quater 23
  with  my_table as 
 (
 select DSM, round((sum(Jan23)+sum(Feb23)+sum(Mar23)),2) as last_quater22,
round((sum(Apr23)+sum(May23)+sum(Jun23)),2) as 1st_quater23 from sales_parle_ws group by DSM 
)
select DSM, last_quater22,1st_quater23,round(((((1st_quater23)-(last_quater22))/(last_quater22))*100),2) as quaterwise_growth from my_table;
## Negetive wholesaler growth consecutive 3 months
 with growth  as
(select WSName,round((((sum(Aug23)-sum(Jul23))/sum(Jul23)))*100,2) as wholesaler_growth_Aug23,round((((sum(Jul23)-sum(Jun23))/sum(Jun23)))*100,2) as wholesaler_growth_Jul23,
round((((sum(Jun23)-sum(May23))/sum(May23)))*100,2) as wholesaler_growth_Jun23
 from sales_parle_ws group by WSName having wholesaler_growth_Aug23<0 and wholesaler_growth_Jul23<0 and wholesaler_growth_Jun23<0  order by wholesaler_growth_Aug23 desc)
select WSName, wholesaler_growth_Jul23 ,wholesaler_growth_Aug23,wholesaler_growth_Jun23 from growth;