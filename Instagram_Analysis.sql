-- Find the 5 oldest users.

select * from users 
order by created_at limit 5;

-- We need to figure out when to schedule an ad campgain. What day of the week do most users register on? 

select c "day of the week", count(total) from
(select DAYNAME(created_at) c , count(dayname(created_at)) as total
from users group by created_at) s
;

-- We want to target our inactive users with an email campaign. Find the users who have never posted a photo.

SELECT USERNAME FROM users 
WHERE ID NOT IN (SELECT USER_ID FROM photos); 

-- We're running a new contest to see who can get the most likes on a single photo. WHO WON?

select username, ss.id,image_url, Total_Likes from users inner join
(select * from photos inner join 
(SELECT COUNT(USER_ID) Total_Likes,PHOTO_ID FROM likes
GROUP BY PHOTO_ID 
ORDER BY COUNT(USER_ID) DESC LIMIT 1) s
on s.photo_id = photos.id) ss
on ss.user_id = users.id;

-- Our Investors want to know...How many times does the average user post? (total number of photos/total number of users)

select
ROUND((SELECT COUNT(*)FROM photos)/(SELECT COUNT(*) FROM users),2);

-- user ranking by postings higher to lower

select username ,count(*) from users
inner join photos on photos.user_id = users.id
group by username 
order by count(*);

-- Total Posts by users 

SELECT COUNT(*)FROM photos;

-- Total numbers of users who have posted at least one time


select count(*) from users
where id in (select user_id from photos);

-- A brand wants to know which hashtags to use in a post. What are the top 5 most commonly used hashtags?

select tag_name,count(*)
from photo_tags
inner join tags on tags.id = photo_tags.tag_id
group by tag_name
order by count(*);

-- We have a small problem with bots on our site. Find users who have liked every single photo on the site

SELECT S.USER_ID as id,username ,CT Total_Likes FROM 
(SELECT USER_ID,COUNT(PHOTO_ID) AS CT FROM likes
GROUP BY USER_ID
) S
INNER JOIN users ON users.ID = S.USER_ID
WHERE CT = (SELECT COUNT(ID) FROM photos);

-- We also have a problem with celebrities. Find users who have never commented on a photo

SELECT username, comment_text FROM users
left join comments on comments.user_id =users.id
where comment_text is null;

-- Are we overrun with bots and celebrity accounts? Find the percentage of our users
-- who have either never commented on a photo or have commented on every photo

SELECT count(*) "Number Of Users who never commented" ,(select
(SELECT count(*) FROM users U 
INNER JOIN
(SELECT USER_ID ,COUNT(PHOTO_ID) CT FROM comments
GROUP BY USER_ID ) S
ON S.USER_ID = U.ID
WHERE CT = (SELECT COUNT(ID) FROM photos)) /
(select count(id) from users)*100) "%",
(SELECT count(*)  FROM users U 
INNER JOIN
(SELECT USER_ID ,COUNT(PHOTO_ID) CT FROM comments
GROUP BY USER_ID ) S
ON S.USER_ID = U.ID
WHERE CT = (SELECT COUNT(ID) FROM photos)) "Number of Users who likes every photos"
FROM users
left join comments on comments.user_id =users.id
where comment_text is null;

-- Find users who have ever commented on a photo

select username,comment_text from
(select username,comment_text,row_number() over (partition by username order by comments.id desc) as rn from comments 
inner join users on users.id = comments.user_id order by user_id)s
where rn = 1;

-- Are we overrun with bots and celebrity accounts?
-- Find the percentage of our users who have either never commented on a photo or have commented on photos before.

SELECT count(*) "Number Of Users who never commented" ,(select
(select count(distinct(user_id)) from comments) /
(select count(id) from users)*100) "%",
(select count(distinct(user_id)) from comments) "Number of Users who commented on photos"
FROM users
left join comments on comments.user_id =users.id
where comment_text is null;

