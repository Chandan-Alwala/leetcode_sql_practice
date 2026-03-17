SELECT patient_id, patient_name, conditions
FROM Patients
WHERE CONCAT(' ', conditions) LIKE '% DIAB1%';
--------------------------
-- this wrongly recognizes ex:"XDIAB100" ❌ (should NOT match) too
SELECT
    patient_id,
    patient_name,
    conditions
FROM patients
WHERE conditions LIKE "DIAB1%" OR conditions LIKE "% DIAB1%";
