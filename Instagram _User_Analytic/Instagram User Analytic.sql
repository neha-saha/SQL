use ig_clone;
select * from users;
desc users;
select * from photos;
select * from comments;
select * from likes;
select * from follows;
select * from tags;
select * from photo_tags;
select * from follows where follower_id is null or followee_id is null or created_at is null;
select * from tags where id is null or tag_name is null or created_at is null;
select * from photo_tags where photo_id is null or tag_id is null;

-- Marketing Analysis:
-- 1. loyal user--
select *from users order by created_at limit 5;

-- 2. inactive users
select users.id, users.username from users left join photos on users.id=photos.user_id where photos.user_id is null;

-- 3. most like--
with newtab as (select photo_id , count(user_id) as total_likes from likes group by photo_id order by total_likes desc limit 1)
select photos.user_id, users.username,photos.image_url,total_likes  
from photos join newtab on photos.id=newtab.photo_id join users on users.id=photos.user_id;

-- 4. hashtag winner
select tags.tag_name, count(photo_tags.tag_id) from tags join photo_tags on tags.id=photo_tags.tag_id 
group by photo_tags.tag_id order by count(photo_tags.tag_id) desc limit 5;

-- 5.ad campaign launch
with daytab as(select Dayname(created_at) as day, count(id) as totalreg from users group by day )
select day from daytab where totalreg= (select max(totalreg) from daytab);


-- Invester matrics--

-- 1.users engagement
select ((select count(*) from photos)/(select count(*) from users)) as avg;

-- --2.bot--
with temp as (select users.id, users.username, count(likes.photo_id) as ct from users join likes 
on users.id=likes.user_id group by likes.user_id) 
select * from temp where ct=(select count(id) from photos);







