--How can we know if the improvement of Tutorial in-game version 1.6.0 has impacted the User Experience better than in-game
version 1.5.2?
/*Đánh giá dựa trên 4 chỉ số:
  số lượt hoàn thành tutorial: quantity = -2
  tổng thời gian chơi game = sum(quantity) (quantity is not -2,-1,1,2,3,4)
  tổng số lượng event tham gia = count(event_name)
  trung bình số ngày quay lại gần nhất = min (day diff) partition by user
*/
--Kết luận: Version 1.6.0 mang lại UX tốt hơn
  
with bang as (select *
from public."Game"
where version ='1.6.0')
, bang1 as (select min(day_diff) over (partition by user) as min_day_diff
from bang
where day_diff <> 0) 
, bang2 as (select *
from public."Game"
where version ='1.5.2')
, bang3 as (select min(day_diff) over (partition by user) as min_day_diff
from bang2
where day_diff <> 0) 

select (select count(quantity) 
from bang
where quantity = -2) as so_luot_hoan_thanh_tutorial
, (select sum(quantity)
from bang
where not quantity in(-2,-1,1,2,3,4)) as tong_thoi_gian_choi
, count(event_name) as so_luong_event_tham_gia
, (select avg(min_day_diff) from bang1) as so_ngay_quay_lai_trung_binh
from bang 
union all

select (select count(quantity) 
from bang2
where quantity = -2) as so_luot_hoan_thanh_tutorial
, (select sum(quantity)
from bang2
where not quantity in(-2,-1,1,2,3,4)) as tong_thoi_gian_choi
, count(event_name) as so_luong_event_tham_gia
, (select avg(min_day_diff) from bang3) as so_ngay_quay_lai_trung_binh
from bang2

--Can we roll out 100% game version 1.6.0 to all users or not? Why?
/*Các chỉ số để đánh giá:
- Lỗi của game? */
