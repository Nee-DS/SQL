/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */
SELECT facid, name, membercost
FROM `Facilities`
WHERE membercost >0

/* Q2: How many facilities do not charge a fee to members? */
SELECT facid, name, membercost
FROM `Facilities`
WHERE membercost =0

/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */
SELECT name, membercost, monthlymaintenance
FROM `Facilities`
WHERE membercost >0
AND membercost < ( 0.2 * monthlymaintenance ) 

/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */
SELECT *
FROM `Facilities`
WHERE facid
IN ( 1, 5 )

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

SELECT name, monthlymaintenance,
CASE WHEN monthlymaintenance <100
THEN "cheap"
ELSE "expensive"
END AS rate
FROM `Facilities`

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

SELECT firstname, surname, joindate
FROM `Members`
WHERE joindate = (
SELECT MAX( joindate )
FROM `Members` )
/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */
SELECT DISTINCT CONCAT( firstname, '  ', surname ) AS fullname, Facilities.name
FROM `Members`
INNER JOIN `Bookings` ON Members.memid = Bookings.memid
INNER JOIN `Facilities` ON Bookings.facid = Facilities.facid
WHERE Bookings.facid <2
ORDER BY fullname

/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */


SELECT CONCAT( Members.firstname, '  ', Members.surname ) AS fullname, Facilities.name,
CASE WHEN Bookings.memid = '0'
THEN slots * Facilities.guestcost
ELSE slots * Facilities.membercost
END AS cost
FROM `Members`
INNER JOIN `Bookings` ON Members.memid = Bookings.memid
INNER JOIN `Facilities` ON Bookings.facid = Facilities.facid
WHERE DATE( starttime ) = DATE( '2012-09-14' )
having cost >30
ORDER BY cost DESC



/* Q9: This time, produce the same result as in Q8, but using a subquery. */
SELECT sub . *

FROM (

SELECT CONCAT( Members.firstname, '  ', Members.surname ) AS fullname, Facilities.name,
CASE WHEN Bookings.memid = '0'
THEN slots * Facilities.guestcost
ELSE slots * Facilities.membercost
END AS cost
FROM `Members`
INNER JOIN `Bookings` ON Members.memid = Bookings.memid
INNER JOIN `Facilities` ON Bookings.facid = Facilities.facid
WHERE DATE( starttime ) = DATE( '2012-09-14' )
)sub

HAVING cost >30
ORDER BY cost DESC


/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */
SELECT name, SUM( (slots * membercost) *2 + ( slots * guestcost ) *2 ) AS revenue
FROM `Bookings`
INNER JOIN `Members` ON Members.memid = Bookings.memid
INNER JOIN `Facilities` ON Bookings.facid = Facilities.facid
GROUP BY Facilities.name
ORDER BY revenue