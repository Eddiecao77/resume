show databases ;
use hospital_tcm;
show tables ;

#基础指标分析
-- 1. 总就诊量
select count(*) as total_visits
from visits;

-- 2. 总患者数
select count(distinct patient_id) as total_patients
from visits;

-- 3. 整体治愈率
select sum(is_cured) / count(*) as cure_rate
from visits;

-- 4. 平均就诊费用
select round(avg(cost),2) as avg_cost
from visits;

#科室指标分析
-- 5. 各科室就诊量排名
select d.dept_id,d.dept_name,count(v.visit_id) as visit_count
from visits v inner join departments d on d.dept_id = v.dept_id
group by d.dept_id,d.dept_name
order by visit_count desc;

-- 6. 各科室治愈率
select d.dept_name, round(sum(is_cured) /count(v.visit_id) * 100,2)   as dept_cured_rate
from visits v join departments d on v.dept_id = d.dept_id
group by d.dept_name
order by dept_cured_rate desc;

-- 7. 各科室平均费用
select d.dept_name, round(sum(v.cost) / count(v.visit_id), 2) as dept_avg_cost
from departments d
         join visits v on d.dept_id = v.visit_id
group by d.dept_name
order by dept_avg_cost;

#时间维度分析
-- 8. 月度就诊趋势（2025年）
select DATE_FORMAT (visit_date, '%Y-%m') as month, count(*) as visit_count
from visits
where YEAR(visit_date)=2025
group by DATE_FORMAT (visit_date, '%Y-%m')
order by month;

-- 9. 季度就诊量
select
    concat(year(visit_date), '-q', quarter(visit_date)) as quarter,
    count(*) as visit_count
from visits
group by concat(year(visit_date), '-q', quarter(visit_date))
order by quarter;

#患者维度分析
-- 10. 年龄分布（按年龄段）
select
    case
        when age < 18 then '未成年'
        when age between 18 and 30 then '青年'
        when age between 31 and 50 then '中年'
        when age between 51 and 65 then '中老年'
        else '老年'
    end as age_group,
    count(distinct v.patient_id) as patient_count
from patients p join visits v on p.patient_id = v.patient_id
group by age_group;

-- 11. 性别分布
select patients.gender,count(distinct patient_id)
from patients
group by patients.gender;

-- 12. 复诊患者分析（就诊次数>=2）
select patient_id,count(*) as visit_times
from visits
group by patient_id
having visit_times >= 2
order by visit_times desc;

#疾病维度分析
-- 13. 疾病排名（TOP10）
select diagnosis, count(*) as disease_count
from visits
group by diagnosis
order by disease_count desc
limit 10;

-- 14. 各疾病平均治疗天数
select diagnosis, round(avg(duration_days),2) as avg_curedays
from visits
group by diagnosis
order by avg_curedays;


















