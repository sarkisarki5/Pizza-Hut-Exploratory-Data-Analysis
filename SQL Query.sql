create table order_details(
order_details_id int primary key,
order_id int not null,
pizza_id text not null,
quantity int not null);

-- Retrieve the total number of orders placed.
select count(order_id) as Total_Number_of_Order from orders;

-- Calculate the total revenue generated from pizza sales.
SELECT 
    round(SUM(order_details.quantity * pizzas.price)) AS Total_Revenue
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id;

-- Identify the highest-priced pizza.
SELECT 
    pizza_types.name, price
FROM
    pizzas
        JOIN
    pizza_types ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY price DESC
LIMIT 1;


-- Identify the most common pizza size ordered.
SELECT 
    size, COUNT(order_details.order_details_id) AS total_orders
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizzas.size
ORDER BY total_orders DESC;


 -- List the top 5 most ordered pizza types along with their quantities.
 SELECT 
    pizza_types.name,
    COUNT(order_details_id) AS total_quantities
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY pizza_types.name
ORDER BY total_quantities DESC
LIMIT 5;


-- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    pizza_types.category,
    COUNT(order_details.quantity) AS Total_Quantity
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY pizza_types.category;


-- Determine the distribution of orders by hour of the day.
SELECT 
    COUNT(order_details.quantity) AS total_Quantity,
    HOUR(order_time)
FROM
    orders
        JOIN
    order_details ON orders.order_id = order_details.order_id
GROUP BY HOUR(order_time)
ORDER BY total_Quantity DESC;


-- Join relevant tables to find the category-wise distribution of pizzas.
SELECT 
    COUNT(order_details.order_id) AS Total_Orders,
    pizza_types.category
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY pizza_types.category
ORDER BY Total_Orders DESC;


-- Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    ROUND(AVG(quan), 0) AS Avg_per_day
FROM
    (SELECT 
        SUM(quantity) AS quan, order_date AS per_day
    FROM
        order_details
    JOIN orders ON order_details.order_id = orders.order_id
    GROUP BY order_date) AS order_quan;

-- Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    pizza_types.name as Name,
    SUM(pizzas.price * order_details.quantity) AS Revenue
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY pizza_types.name
ORDER BY Revenue DESC
LIMIT 3;



-- Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    ROUND((SUM(order_details.quantity * pizzas.price) / (SELECT 
                    ROUND(SUM(order_details.quantity * pizzas.price),
                                2) AS total_sales
                FROM
                    order_details
                        JOIN
                    pizzas ON order_details.pizza_id = pizzas.pizza_id)) * 100,
            2) AS Total_Revenue,
    pizza_types.category as Category
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY pizza_types.category;


-- Analyze the cumulative revenue generated over time.
select Order_Date,sum(Total_revenue)over(order by Order_Date) as Cumulative_revenue 
from(select round(sum(order_details.quantity*pizzas.price)) as Total_revenue,orders.order_date as Order_Date
from order_details 
join pizzas on order_details.pizza_id=pizzas.pizza_id 
join orders on order_details.order_id=orders.order_id group by Order_Date) as sales;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select revenue,name,category from
(select category,revenue,name,
rank() over(partition by category order by revenue desc )  as ran  from
(select sum(order_details.quantity*pizzas.price) as revenue, pizza_types.category,pizza_types.name from order_details join pizzas on order_details.pizza_id=pizzas.pizza_id 
join pizza_types on pizzas.pizza_type_id=pizza_types.pizza_type_id group by category,name) as a ) as b where ran<=3;






