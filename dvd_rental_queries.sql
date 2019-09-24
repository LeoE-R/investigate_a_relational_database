/* Slide 1 */
SELECT
    t1.film_title,
    t1.category_name,
    t2.rental_count
FROM (
    SELECT
        f.title film_title,
        c.name category_name
    FROM
        category c
        JOIN film_category fc ON c.category_id = fc.category_id
        JOIN film f ON f.film_id = fc.film_id
    WHERE
        name IN ('Animation', 'Children', 'Classic', 'Comedy', 'Family', 'Music')
    GROUP BY
        film_title,
        category_name) t1
    JOIN (
        SELECT
            f.title AS film_title,
            COUNT(r.rental_id) AS rental_count
        FROM
            film AS f
            JOIN inventory AS i ON f.film_id = i.film_id
            JOIN rental r ON i.inventory_id = r.inventory_id
        GROUP BY
            f.title) t2 ON t1.film_title = t2.film_title
ORDER BY
    t1.category_name,
    t1.film_title;


/* Slide 2 */
WITH top10 AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) full_name
    FROM
        payment p
        JOIN customer c ON p.customer_id = c.customer_id
    GROUP BY
        1,
        2
    ORDER BY
        1 DESC
    LIMIT 10
)
SELECT
    date_trunc('month', p.payment_date) pay_month,
    top10.full_name,
    COUNT(p.payment_date) pay_countpermont
FROM
    payment p
    JOIN top10 ON top10.customer_id = p.customer_id
GROUP BY
    1,
    2
ORDER BY
    2;


/* Slide 3 */
SELECT
    category,
    standard_quartile,
    COUNT(film_title) AS count
FROM (
    SELECT
        film_title,
        category,
        rental_duration,
        NTILE(4) OVER (ORDER BY rental_duration) AS standard_quartile
    FROM (
        SELECT
            f.rental_duration rental_duration,
            f.title film_title,
            c.name category
        FROM
            film f
            JOIN film_category fc ON f.film_id = fc.film_id
            JOIN category c ON fc.category_id = c.category_id) T1
    WHERE
        category IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')) T2
GROUP BY
    1,
    2
ORDER BY
    1,
    2;


/* Slide 4 */
SELECT DISTINCT
    CONCAT(month, '-', year) month_year,
    COUNT(id) AS count_rentals
FROM (
    SELECT
        EXTRACT(month FROM r.rental_date) AS month,
        EXTRACT(year FROM r.rental_date) AS year,
        r.rental_id AS id
    FROM
        rental r
        JOIN staff s ON r.staff_id = s.staff_id) AS t1
GROUP BY
    1
ORDER BY
    1 DESC;
