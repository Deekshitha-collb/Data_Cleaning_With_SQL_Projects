-- QUERYING

-- Q1 : WHO IS THE SENIOR MOST EMPLOYEE BASED ON JOB TITLE?

SELECT * 
FROM employee
ORDER BY levels DESC
LIMIT 1;


-- Q2 : WHICH COUNTRIES HAVE THE MOST INVOICES?

SELECT COUNT(*) AS c, billing_country 
FROM invoice
GROUP BY billing_country
ORDER BY c DESC;


-- Q3 : WHAT ARE TOP 3 VALUES OF TOTAL INVOICE?

SELECT total
FROM INVOICE
ORDER BY total DESC
LIMIT 3;


-- Q4 : WHICH CITY HAS THE BEST CUSTOMERS? WE WOULD LIKE TO THROW A PROMOTIONAL MUSIC FESTIVAL IN THE CITY WE MADE THE MOST MONEY.
--      WRITE A QUERY THAT RETURNS ONE CITY THAT HAS THE HIGHEST SUM OF INVOICE TOTALS. RETURN BOTH THE CITY NAME AND SUM OF INVOICE TOTALS?

SELECT billing_city, SUM(total) AS invoice_total
FROM invoice 
GROUP BY billing_city
ORDER BY invoice_total DESC
LIMIT 1;


-- Q5 : WHO IS THE BEST CUSTOMER? THE CUSTOMER WHO HAS SPENT THE MOST MONEY WILL BE DECLARED THE BEST CUSTOMER.
--      WRITE A QUERY THAT RETURNS THE PERSON WHO SPENT THE MOST MONEY?

SELECT customer.customer_id AS id, customer.first_name AS first_name, customer.last_name AS last_name, SUM(invoice.total) AS invoice_total
FROM customer , invoice
WHERE customer.customer_id=invoice.customer_id
GROUP BY id
ORDER BY invoice_total DESC
LIMIT 1;


-- Q5 : WRITE A QUERY TO RETURN THE EMAIL, FIRST NAME, LAST NAME AND GENRE OF ALL ROCK MUSIC LISTENERS? 
--      RETURN YOUR LIST ORDERED ALPHABETICALLY BY EMAIL STARTING WITH A.

SELECT DISTINCT customer.email AS email, customer.first_name AS first_name, customer.last_name
FROM customer, genre, invoice, invoice_line, track
WHERE customer.customer_id = invoice.customer_id AND invoice.invoice_id = invoice_line.invoice_id
AND track.track_id IN (SELECT track_id 
				FROM track
				WHERE track.genre_id = genre.genre_id and genre.name LIKE 'Rock')
ORDER BY email;


-- Q6 : LET'S INVITE THE ARTISTS WHO HAVE WRITTEN THE MOST ROCK MUSIC IN OUR DATASET.
--      WRITE A QUERY THAT RETURNS THE ARTIST NAME AND TOTAL TRACK COUNT OF THE TOP 10 ROCK BANDS?

SELECT artist.artist_id AS id, artist.name as name, COUNT(artist.artist_id) AS number_of_songs
FROM artist, album, track, genre
WHERE artist.artist_id = album.artist_id AND album.album_id = track.album_id AND track.genre_id = genre.genre_id
AND genre.name LIKE 'Rock'
GROUP BY id
ORDER BY number_of_songs DESC
LIMIT 10;


-- Q7 : RETURN ALL THE TRACK NAMES THAT HAVE A SONG LENGTH LONGER THAN THE AVERAGE SONG LENGTH?
--      RETURN THE NAME AND MILLISECONDS FOR EACH TRACK?
--      ORDER BY THE SONG LENGTH WITH THE LONGEST SONGS LISTED FIRST.

SELECT name, milliseconds
FROM track
WHERE milliseconds > (SELECT AVG(milliseconds) AS average_track_length
					 FROM track)
ORDER BY milliseconds DESC;


-- Q8 : FIND HOW MUCH AMOUNT SPENT BY EACH CUSTOMER ON ARTISTS.
--      WRITE A QUERY TO RETURN CUSTOMER NAME, ARTIST NAME AND TOTAL SPENT?

WITH best_selling_artist AS (
    SELECT artist.artist_id AS artist_id, artist.name AS artist_name, SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY 1
	ORDER BY 3 DESC
	LIMIT 1
)
SELECT customer.customer_id, customer.first_name, customer.last_name, best_selling_artist.artist_name, 
SUM(invoice_line.unit_price*invoice_line.quantity) AS amount_spent
FROM invoice
JOIN customer ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice_line.invoice_id = invoice.invoice_id
JOIN track ON track.track_id = invoice_line.track_id
JOIN album ON album.album_id = track.album_id
JOIN best_selling_artist ON best_selling_artist.artist_id = album.artist_id
GROUP BY 1, 2, 3, 4 
ORDER BY 5 DESC;


-- Q9 : WE WANT TO FIND OUT THE MOST POPULAR MUSIC GENRE FOR EACH GENRE FOR EACH COUNTRY.
--      WE DETERMINE THE MOST POPULAR GENRE AS THE GENRE WITH THE HIGHEST AMOUNT OF PURCHASES.
--      WRITE A QUERY THAT RETURNS EACH COUNTRY ALONG WITH THE TOP GENRE?
--      FOR COUNTRIES WHERE THE MAXIMUM NUMBER OF PURCHASES IS SHARED RETURN ALL GENRES.

WITH popular_genre AS (
    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo
	FROM invoice_line
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
)
SELECT * 
FROM popular_genre 
WHERE RowNo <= 1;


-- Q10 : WRITE A QUERY THAT DETERMINES THE CUSTOMER THAT HAS SPENT THE MOST ON MUSIC FOR EACH COUNTRY?
--      WRITE A QUERY THAT RETURNS THE COUNTRY ALONG WITH THE TOP CUSTOMER AND HOW MUCH THEY SPENT?
--      FOR COUNTRIES WHERE THE TOP AMOUNT SPENT IS SHARED, PROVIDE ALL CUSTOMERS WHO SPENT THE AMOUNT.

WITH customer_with_country AS (
    SELECT customer.customer_id, first_name, last_name, billing_country, SUM(total) AS total_spending,
	ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo
	FROM invoice
	JOIN customer ON customer.customer_id = invoice.customer_id
	GROUP BY 1, 2, 3, 4
	ORDER BY 4 ASC, 5 DESC
)
SELECT *
FROM customer_with_country 
WHERE RowNo <= 1;