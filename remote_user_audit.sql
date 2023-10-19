-- verifying that the loaded data matches expectations 
USE [TCC Inquries]
Go

select *
From user_audit

-- adding necessary columns to data set
ALTER TABLE user_audit
Add date date,
time time,
session_time DATETIME,
login_time DATETIME,
logout_time DATETIME,
action_count  int,
AVG_CREATE_ACTION  int ,
create_count int,
update_count int,
view_count int,
search_count int,
sessiontimeout_count int,
Department varchar(50),
report_date date;

-- updating added columns

update user_audit
set report_date = '10-02-2023' -- DONT FORGET TO UPDATE THIS

UPDATE user_audit
Set Department = CASE
	WHEN username = 'amarkum'
	THEN 'Carp'
	WHEN username = 'eandrews36' OR username = 'ldoyal' OR username = 'mcornejo16' or username = 'npribnow' OR username = 'ssanders56'
	THEN 'Clinical Ops - Admin'
	WHEN username = 'bregalado5' OR username = 'bwachsmuth1' OR username = 'cbench4' or username = 'jomalley15'
	THEN 'Clinical Ops - MA'
	WHEN username = 'cthom1'
	THEN 'Clinical Ops - RN'
	WHEN username = 'cgarcia417'
	THEN 'FP - NAV MA'
	WHEN username = 'kromero94' OR username = 'lwestbrook2'
	THEN 'FP - PFM'
	WHEN username = 'jrubeshhughes'
	THEN 'ITS'
	WHEN username = 'kstalnakervivero'
	THEN 'Lab - Admin'
	WHEN username = 'kpodlipaeva' OR username = 'twagoner'
	THEN 'Occ Med'
	WHEN username = 'bandersen6' OR username = 'snelson87'
	THEN 'Quality'
	WHEN username = 'earellano8'  OR username = 'mbagnall' OR username = 'djochimsen'
	THEN 'RCM' 
	WHEN username = 'mmohrman' OR username = 'shosner' OR username = 'eanderson172'
	THEN 'RCM - Admin'
	WHEN username = 'awhite167' OR username = 'bparramunoz' OR username = 'bryan16' OR username = 'cbates24' OR username = 'cmorrill2' OR username = 'leilers' OR username = 'mhenry39' OR username = 'bwippert'
	THEN 'RCM - Coding'
	WHEN username = 'rday12' OR username = 'tcole34' OR username = 'lleslie9'
	THEN 'RCM - Contract Accounts'
	WHEN username = 'jfoos2' OR username = 'akolar1' OR username = 'bcagle7' OR username = 'mfowler40' OR username = 'rdecker7' OR username = 'scox130' OR username = 'spenning' OR username = 'jchrzamowski2 '
	THEN 'RCM - Patient Accounts'
	WHEN username = 'mroe5' OR username = 'tunquera' OR username = 'aavery35' OR username = 'aellings' OR username = 'rwheeler34'
	THEN 'RCM - Pre-Registration'
	WHEN username = 'mzak7'
	THEN 'RCM - WC/MVA'
	WHEN username = 'tcurteman'
	THEN 'RCM - Contract Insurance Billing'
	WHEN username = 'aespinoza86'  OR username = 'cparrish33'
	THEN 'Patient Services - CCS Rep'
	WHEN username = 'dcole71'
	THEN 'Patient Services - Find A Physican Cord'
	Else NULL
	END
UPDATE user_audit
SET date = LEFT(timestamp,10)
update user_audit
set time = RIGHT(timestamp,16)

-- creating temporary table to using cast to create new variables
select cast(date as date) as date, cast(time as time) as time, type, cast(session_time as datetime) as session_time, username
,   CAST(NULL AS TIME) AS login_time
,   CAST(NULL AS TIME) AS logout_time
, action_count
, create_count
, update_count
, view_count
, search_count
, sessiontimeout_count
, Department
, report_date
into #remote_users
from user_audit

-- update tale to allow for averages
update  t
set login_time = loginTimeNew
,   logout_time = t.logoutTimeNew
,   session_time = CAST(dateadd(ms, datediff(ms, logintimenew, logouttimenew) , '19000101') AS TIME)
, action_count = t.ActionCountNew
, create_count = t.CreateCountNew
, update_count = t.UpdateCountNew
, view_count = t.ViewCountNew
, search_count = t.SearchCountNew
, sessiontimeout_count = t.SessiontimeoutCountNew
FROM    (
    select  min(time) OVER(PARTITION BY username, date) as loginTimeNew
    ,   Max(time) OVER(PARTITION BY username, date) as logoutTimeNew
    ,   count(type) OVER(PARTITION by username, date) as ActionCountNew
	, count(case when type = 'create' then type else null end) OVER(PARTITION BY username, date) as CreateCountNew
	, count(case when type = 'update' then type else null end) OVER(PARTITION BY username, date) as UpdateCountNew
	, count(case when type = 'view' then type else null end) OVER(PARTITION BY username, date) as ViewCountNew
	, count(case when type = 'search' then type else null end) OVER(PARTITION BY username, date) as SearchCountNew
	, count(case when type = 'sessiontimeout' then type else null end) OVER(PARTITION BY username, date) as SessiontimeoutCountNew
	,*
    FROM    #remote_users t
    ) t

-- creating clean data set with only remote users
select cast(session_time as float) as session_time_new, *
INTO #remote_users_clean
from #remote_users
where username = 'lleslie9' OR username = 'tcurteman' OR username = 'mbagnall' OR username = 'djochimsen'
 OR username = 'tcole34' OR username = 'mmohrman' OR username = 'rdecker7' OR username = 'shosner' OR username = 'earellano8'
  OR username = 'lwestbrook2' OR username = 'amarkum' OR username = 'snelson87' OR username = 'spenning' OR username = 'aellings'
   OR username = 'kstalnakervivero' OR username = 'mbartman2' OR username = 'tunquera' OR username = 'bryan16' OR username = 'cbates24'
    OR username = 'jparksion' OR username = 'cmorrill2' OR username = 'awhite167' OR username = 'mfowler40' OR username = 'mroe5'
	 OR username = 'wmitchell10' OR username = 'rday12' OR username = 'mhenry39' OR username = '' OR username = 'jrubeshhughes' OR username = 'akolar1'
	  OR username = 'bcagle7' OR username = 'bwachsmuth1' OR username = 'kpodlipaeva' OR username = 'bwippert' OR username = 'cthom1'
	   OR username = 'bparramunoz' OR username = 'scox130' OR username = 'leilers' OR username = 'rwheeler34' OR username = 'cgarcia417' OR username = 'eanderson172'
	    OR username = 'mzak7' OR username = 'eandrews36' OR username = 'mcornejo16' OR username = 'cparrish33' OR username = 'tstouffer' OR username = 'jomalley15'
		 OR username = 'cbench4' OR username = 'aespinoza86' OR username = 'dcole71' OR username = 'jfoos2' OR username = 'twagoner' OR username = 'bregalado5'
		  OR username = 'ldoyal' OR username = 'kromero94' OR username = 'carends' OR username = 'npribnow' OR username = 'aavery35' OR username = 'kcruise3'
		   OR username = 'ssanders56' OR username = 'jchrzamowski2'
order by username DESC


-- verifying clean data set for one user
select *
FROM #remote_users_clean
WHERE USERNAME = 'mbagnall'


-- calling all aggregate data for all variables
select DISTINCT(username), Department,
(dense_rank() over (partition by username order by date) 
+ dense_rank() over (partition by username order by date desc) 
- 1) as Days_worked,
AVG(datediff(HOUR,0,session_time)) OVER(PARTITION BY username) AS AVERAGE_SESSION_HOURS,
AVG(datediff(HOUR,0,login_time)) OVER(PARTITION BY username) AS AVERAGE_LOGIN_HOUR,
AVG(datediff(HOUR,0,logout_time)) OVER(PARTITION BY username) AS AVERAGE_LOGOUT_HOUR,
AVG(create_count) OVER(PARTITION BY username) AS AVG_CREATE_ACTION,
AVG(update_count) OVER(PARTITION BY username) AS AVG_UPDATE_ACTION,
AVG(view_count) OVER(PARTITION BY username) AS AVG_VIEW_ACTION,
AVG(search_count) OVER(PARTITION BY username) AS AVG_SEARCH_ACTION,
AVG(sessiontimeout_count) OVER(PARTITION BY username) AS AVG_SESSIONTIMEOUT_ACTION,
AVG(action_count)  OVER(PARTITION BY username) AS AVERAGE_ATHENA_ACTIONS,
report_date
from #remote_users_clean



Drop TABLE #remote_users_clean
DROP TABLE #remote_users;

