SELECT prov.[Scheduling Name], enc.[Clinical Encounter ID], enc.[Clinical EncounterType], enc.[Encounter Date], dep.[Department Name], enc.[Encounter Status],
enc.[Created Datetime], enc.[Closed Datetime], prov.Specialty, enc.[Patient ID]
FROM clinicalencounter AS enc
JOIN provider as prov
ON enc.[Provider ID] = prov.[Provider ID]
JOIN department as dep
ON enc.[Department ID] = dep.[Department ID]
WHERE enc.[Encounter Date] >= '2023-07-01' AND enc.[Encounter Date] <= '2023-09-30' AND dep.[Department Name] != 'Ambulatory Surgery Center_FAC' AND dep.[Department Name] != 'Anticoag Clinic_Asbury_3rd'
	AND dep.[Department Name] != 'AntiCoag Clinic_Waverly' AND dep.[Department Name] != 'Billing and Coding' AND dep.[Department Name] != 'Bridge creek Specialized Care' AND dep.[Department Name] != 'Care_Coordination'
	AND dep.[Department Name] != 'Diabetes Education' AND dep.[Department Name] != 'Diabetes Education_PFM' AND dep.[Department Name] != 'Data Import' AND dep.[Department Name] != 'Good Samaritan Hospital' AND dep.[Department Name] != 'Good Samaritan Out Patient'
	AND dep.[Department Name] != 'Laboratory_NAR' AND dep.[Department Name] != 'Laboratory_PFM' AND dep.[Department Name] != 'Laboratory_QuickCare_Monroe' AND dep.[Department Name] != 'Laboratory_TCC' AND dep.[Department Name] != 'Laboratory_TCC'
	AND dep.[Department Name] != 'Lebanon Community Hospital' AND dep.[Department Name] != 'RX Refill' AND dep.[Department Name] != 'Samaritan Ambulatory Surgery Center' AND enc.[Encounter Status] = 'CLOSED' OR enc.[Encounter Status] = 'REVIEW'
	OR enc.[Encounter Status] = 'REQUIRESIGNATURE' OR enc.[Encounter Status] = 'OPEN'


Select  apt.[Appointment ID], apt.[Scheduling Provider], apt.[Appointment Date]
FROM appointment AS apt
WHERE apt.[Claim ID] = '-1' AND apt.[Appointment Date] >= '2023-1-1'