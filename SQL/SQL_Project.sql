use project;

# 기온에 따른 모기 지수
select sm.mos_date, sm.mosquito, ct.month_temper
from seoul_mosquito sm
	inner join climate_table ct
	on year(sm.mos_date) = year(ct.c_date) and
	month(sm.mos_date) = month(ct.c_date)
order by ct.month_temper desc;


# 강수량에 따른 모기 지수
select sm.mos_date, sm.mosquito, ct.month_raniy 
from seoul_mosquito sm
	inner join climate_table ct
	on year(sm.mos_date) = year(ct.c_date) and
	month(sm.mos_date) = month(ct.c_date)
order by ct.month_raniy desc;


# 기온과 강수량에 따른 열대열 말라리아 진료 환자 수
select sm.mos_date, ct.month_temper,
	ct.month_raniy, pit.patient_num
from seoul_mosquito sm
	inner join climate_table ct
	on year(sm.mos_date) = year(ct.c_date) and
	month(sm.mos_date) = month(ct.c_date)
	inner join patient_info_table pit
	on year(sm.mos_date) = year(pit.p_date) and
	month(sm.mos_date) = month(pit.p_date)
where illness_name = '열대열 말라리아'
order by pit.patient_num desc;


# 기온과 강수량에 따른 발진티푸스 진료 환자 수
select sm.mos_date, ct.month_temper, ct.month_raniy,
	pit.patient_num
from seoul_mosquito sm
	inner join climate_table ct
	on year(sm.mos_date) = year(ct.c_date) and
	month(sm.mos_date) = month(ct.c_date)
	inner join patient_info_table pit
	on year(sm.mos_date) = year(pit.p_date) and
	month(sm.mos_date) = month(pit.p_date)
where illness_name = '발진티푸스'
order by pit.patient_num desc;