--------------------------------------------------------------------------------------------------------------------------------


--Удаление временных таблиц.
IF OBJECT_ID('tempdb..#ASSESSMENT_DEPENDENCE') IS NOT NULL BEGIN DROP TABLE #ASSESSMENT_DEPENDENCE END --Оценка зависимостей.


--------------------------------------------------------------------------------------------------------------------------------


--Создание временных таблиц.
CREATE TABLE #ASSESSMENT_DEPENDENCE (
    PERSONOUID                  INT,    --Идентификатор личного дела.
    BIRTH_DATE                  DATE,   --Дата рождения.
    INSPECT_FOR_STAZ            INT,    --Оценка зависимости в стационарной форме.
    INSPECT_DATE                DATE,   --Дата проведения обследования.
    INSPECT_INDEX               INT,    --Номер обследования у человека.
    INSPECT_NEXT_DATE           DATE,   --Дата следующего обследования.
    ORGANIZATION                INT,    --Идентиикатор учреждения.
    DEGREE                      INT,    --Степень зависимости в итоге.
    SUM_VALUE                   INT,    --Количество баллов в итоге.
    MOVE_OUTSIDE_HOME_POINT     INT,    --Передвижение вне помещения, предназначенного для проживания выбранное значение.
    MOVE_OUTSIDE_HOME_VALUE     FLOAT,  --Передвижение вне помещения, предназначенного для проживания баллы.
    APARTMENT_CLEANING_POINT    INT,    --Способность выполнять уборку и поддерживать порядок выбранное значение.
    APARTMENT_CLEANING_VALUE    FLOAT,  --Способность выполнять уборку и поддерживать порядок баллы.
    LAUNDRY_POINT               INT,    --Стирка выбранное значение.
    LAUNDRY_VALUE               FLOAT,  --Стирка баллы.
    COOKING_POINT               INT,    --Приготовление пищи выбранное значение.
    COOKING_VALUE               FLOAT,  --Приготовление пищи баллы.
    MOVING_HOUSE_POINT          INT,    --Передвижение в помещении, предназначенном для проживания выбранное значение.
    MOVING_HOUSE_VALUE          FLOAT,  --Передвижение в помещении, предназначенном для проживания баллы.
    FALLS_POINT                 INT,    --Падения в течение последних трех месяцев выбранное значение.
    FALLS_VALUE                 FLOAT,  --Падения в течение последних трех месяцев баллы.
    DRESSING_POINT              INT,    --Одевание выбранное значение.
    DRESSING_VALUE              FLOAT,  --Одевание баллы.
    HYGIENE_POINT               INT,    --Личная гигиена выбранное значение.
    HYGIENE_VALUE               FLOAT,  --Личная гигиена баллы.
    RECEPTION_EAT_MED_POINT     INT,    --Прием пищи и прием лекарств выбранное значение.
    RECEPTION_EAT_MED_VALUE     FLOAT,  --Прием пищи и прием лекарств баллы.
    URINATION_DEFECATION_POINT  INT,    --Мочеиспускание и дефекация выбранное значение.
    URINATION_DEFECATION_VALUE  FLOAT,  --Мочеиспускание и дефекация баллы.
    SUPERVISION_POINT           INT,    --Присмотр выбранное значение.
    SUPERVISION_VALUE           FLOAT,  --Присмотр баллы.
    HEAR_POINT                  INT,    --Слух выбранное значение.
    HEAR_VALUE                  FLOAT,  --Слух баллы.
    PRESENCE_DANGER_POINT       INT,    --Опасное (пагубное поведение). Наличие зависимостей выбранное значение.
    PRESENCE_DANGER_VALUE       FLOAT,  --Опасное (пагубное поведение). Наличие зависимостей баллы.
    SUPPORT_POINT               INT,    --Наличие внешних ресурсов выбранное значение.
    SUPPORT_VALUE               FLOAT   --Наличие внешних ресурсов баллы.
)


------------------------------------------------------------------------------------------------------------------------------


--Выбор оценок зависимости.
INSERT INTO #ASSESSMENT_DEPENDENCE (PERSONOUID, BIRTH_DATE, INSPECT_FOR_STAZ, INSPECT_DATE, INSPECT_INDEX, INSPECT_NEXT_DATE, ORGANIZATION, DEGREE, SUM_VALUE,
    MOVE_OUTSIDE_HOME_POINT, MOVE_OUTSIDE_HOME_VALUE, APARTMENT_CLEANING_POINT, APARTMENT_CLEANING_VALUE, LAUNDRY_POINT, LAUNDRY_VALUE, COOKING_POINT, COOKING_VALUE,
    MOVING_HOUSE_POINT, MOVING_HOUSE_VALUE, FALLS_POINT, FALLS_VALUE, DRESSING_POINT, DRESSING_VALUE, HYGIENE_POINT, HYGIENE_VALUE, RECEPTION_EAT_MED_POINT, RECEPTION_EAT_MED_VALUE,
    URINATION_DEFECATION_POINT, URINATION_DEFECATION_VALUE, SUPERVISION_POINT, SUPERVISION_VALUE, HEAR_POINT, HEAR_VALUE, PRESENCE_DANGER_POINT, PRESENCE_DANGER_VALUE, SUPPORT_POINT, SUPPORT_VALUE
)
SELECT
    PERSONOUID, 
    BIRTH_DATE, 
    INSPECT_FOR_STAZ, 
    INSPECT_DATE, 
    ROW_NUMBER() OVER (PARTITION BY t.PERSONOUID ORDER BY t.INSPECT_DATE)   AS INSPECT_INDEX,
    INSPECT_NEXT_DATE, 
    ORGANIZATION, 
    DEGREE, 
    SUM_VALUE,
    MOVE_OUTSIDE_HOME_POINT,
    MOVE_OUTSIDE_HOME_VALUE, 
    APARTMENT_CLEANING_POINT, 
    APARTMENT_CLEANING_VALUE, 
    LAUNDRY_POINT, 
    LAUNDRY_VALUE, 
    COOKING_POINT, 
    COOKING_VALUE,
    MOVING_HOUSE_POINT, 
    MOVING_HOUSE_VALUE, 
    FALLS_POINT, 
    FALLS_VALUE, DRESSING_POINT, 
    DRESSING_VALUE, 
    HYGIENE_POINT, 
    HYGIENE_VALUE, 
    RECEPTION_EAT_MED_POINT, 
    RECEPTION_EAT_MED_VALUE,
    URINATION_DEFECATION_POINT, 
    URINATION_DEFECATION_VALUE, 
    SUPERVISION_POINT, 
    SUPERVISION_VALUE, 
    HEAR_POINT, 
    HEAR_VALUE, 
    PRESENCE_DANGER_POINT, 
    PRESENCE_DANGER_VALUE, 
    SUPPORT_POINT, 
    SUPPORT_VALUE
FROM (
    SELECT
        personalCard.OUID                                                                           AS PERSONOUID,
        CONVERT(DATE, personalCard.BIRTHDATE)                                                       AS BIRTH_DATE,
        1                                                                                           AS INSPECT_FOR_STAZ,
        CONVERT(DATE, assesmentStaz.A_DATE_INSPECT)                                                 AS INSPECT_DATE,
        CONVERT(DATE, assesmentStaz.A_DATE_NEXT_INSPECTION)                                         AS INSPECT_NEXT_DATE,
        assesmentStaz.A_SPR_ORG_USON                                                                AS ORGANIZATION,
        A_DEGREE                                                                                    AS DEGREE,
        A_SUM_BALS                                                                                  AS SUM_VALUE,
        SUBSTRING(A_MOVE_OUTSIDE_HOME, 0, CHARINDEX('_', A_MOVE_OUTSIDE_HOME))                                                                              AS MOVE_OUTSIDE_HOME_POINT,
        SUBSTRING(A_MOVE_OUTSIDE_HOME, CHARINDEX('_', A_MOVE_OUTSIDE_HOME) + 1, LEN(A_MOVE_OUTSIDE_HOME) - CHARINDEX('_', A_MOVE_OUTSIDE_HOME))             AS MOVE_OUTSIDE_HOME_VALUE,
        SUBSTRING(A_APARTMENT_CLEANING, 0, CHARINDEX('_', A_APARTMENT_CLEANING))                                                                            AS APARTMENT_CLEANING_POINT,
        SUBSTRING(A_APARTMENT_CLEANING, CHARINDEX('_', A_APARTMENT_CLEANING) + 1, LEN(A_APARTMENT_CLEANING) - CHARINDEX('_', A_APARTMENT_CLEANING))         AS APARTMENT_CLEANING_VALUE,
        SUBSTRING(A_LAUNDRY, 0, CHARINDEX('_', A_LAUNDRY))                                                                                                  AS LAUNDRY_POINT,
        SUBSTRING(A_LAUNDRY, CHARINDEX('_', A_LAUNDRY) + 1, LEN(A_LAUNDRY) - CHARINDEX('_', A_LAUNDRY))                                                     AS LAUNDRY_VALUE,
        SUBSTRING(A_COOKING, 0, CHARINDEX('_', A_COOKING))                                                                                                  AS COOKING_POINT,
        SUBSTRING(A_COOKING, CHARINDEX('_', A_COOKING) + 1, LEN(A_COOKING) - CHARINDEX('_', A_COOKING))                                                     AS COOKING_VALUE,
        SUBSTRING(A_MOVING_HOUSE, 0, CHARINDEX('_', A_MOVING_HOUSE))                                                                                        AS MOVING_HOUSE_POINT,
        SUBSTRING(A_MOVING_HOUSE, CHARINDEX('_', A_MOVING_HOUSE) + 1, LEN(A_MOVING_HOUSE) - CHARINDEX('_', A_MOVING_HOUSE))                                 AS MOVING_HOUSE_VALUE,
        SUBSTRING(A_FALLS, 0, CHARINDEX('_', A_FALLS))                                                                                                      AS FALLS_POINT,
        SUBSTRING(A_FALLS, CHARINDEX('_', A_FALLS) + 1, LEN(A_FALLS) - CHARINDEX('_', A_FALLS))                                                             AS FALLS_VALUE,
        SUBSTRING(A_DRESSING, 0, CHARINDEX('_', A_DRESSING))                                                                                                AS DRESSING_POINT,
        SUBSTRING(A_DRESSING, CHARINDEX('_', A_DRESSING) + 1, LEN(A_DRESSING) - CHARINDEX('_', A_DRESSING))                                                 AS DRESSING_VALUE,
        SUBSTRING(A_HYGIENE, 0, CHARINDEX('_', A_HYGIENE))                                                                                                  AS HYGIENE_POINT,
        SUBSTRING(A_HYGIENE, CHARINDEX('_', A_HYGIENE) + 1, LEN(A_HYGIENE) - CHARINDEX('_', A_HYGIENE))                                                     AS HYGIENE_VALUE,
        SUBSTRING(A_RECEPTION_EAT_MED, 0, CHARINDEX('_', A_RECEPTION_EAT_MED))                                                                              AS RECEPTION_EAT_MED_POINT,
        SUBSTRING(A_RECEPTION_EAT_MED, CHARINDEX('_', A_RECEPTION_EAT_MED) + 1, LEN(A_RECEPTION_EAT_MED) - CHARINDEX('_', A_RECEPTION_EAT_MED))             AS RECEPTION_EAT_MED_VALUE,
        SUBSTRING(A_URINATION_DEFECATION, 0, CHARINDEX('_', A_URINATION_DEFECATION))                                                                        AS URINATION_DEFECATION_POINT,
        SUBSTRING(A_URINATION_DEFECATION, CHARINDEX('_', A_URINATION_DEFECATION) + 1, LEN(A_URINATION_DEFECATION) - CHARINDEX('_', A_URINATION_DEFECATION)) AS URINATION_DEFECATION_VALUE,
        SUBSTRING(A_SUPERVISION, 0, CHARINDEX('_', A_SUPERVISION))                                                                                          AS SUPERVISION_POINT,
        SUBSTRING(A_SUPERVISION, CHARINDEX('_', A_SUPERVISION) + 1, LEN(A_SUPERVISION) - CHARINDEX('_', A_SUPERVISION))                                     AS SUPERVISION_VALUE,
        SUBSTRING(A_HEAR, 0, CHARINDEX('_', A_HEAR))                                                                                                        AS HEAR_POINT,
        SUBSTRING(A_HEAR, CHARINDEX('_', A_HEAR) + 1, LEN(A_HEAR) - CHARINDEX('_', A_HEAR))                                                                 AS HEAR_VALUE,
        SUBSTRING(A_PRESENCE_DANGER, 0, CHARINDEX('_', A_PRESENCE_DANGER))                                                                                  AS PRESENCE_DANGER_POINT,
        SUBSTRING(A_PRESENCE_DANGER, CHARINDEX('_', A_PRESENCE_DANGER) + 1, LEN(A_PRESENCE_DANGER) - CHARINDEX('_', A_PRESENCE_DANGER))                     AS PRESENCE_DANGER_VALUE,
        SUBSTRING(A_SUPPORT, 0, CHARINDEX('_', A_SUPPORT))                                                                                                  AS SUPPORT_POINT,
        SUBSTRING(A_SUPPORT, CHARINDEX('_', A_SUPPORT) + 1, LEN(A_SUPPORT) - CHARINDEX('_', A_SUPPORT))                                                     AS SUPPORT_VALUE
    FROM WM_ASSESSMENT_DEPENDENCE_STAZ assesmentStaz
    ----Личное дело гражданина.
        INNER JOIN WM_PERSONAL_CARD personalCard
            ON personalCard.OUID = assesmentStaz.PERSONOUID
                AND personalCard.A_STATUS = 10
    WHERE assesmentStaz.A_STATUS = 10
    UNION ALL
    SELECT
        personalCard.OUID                                                                           AS PERSONOUID,
        CONVERT(DATE, personalCard.BIRTHDATE)                                                       AS BIRTH_DATE,
        0                                                                                           AS INSPECT_FOR_STAZ,
        CONVERT(DATE, assesment.A_DATE_INSPECT)                                                     AS INSPECT_DATE,
        CONVERT(DATE, assesment.A_DATE_NEXT_INSPECTION)                                             AS INSPECT_NEXT_DATE,
        assesment.A_SPR_ORG_USON                                                                    AS ORGANIZATION,
        A_DEGREE                                                                                    AS DEGREE,
        A_SUM_BALS                                                                                  AS SUM_VALUE,
        SUBSTRING(A_MOVE_OUTSIDE_HOME, 0, CHARINDEX('_', A_MOVE_OUTSIDE_HOME))                                                                              AS MOVE_OUTSIDE_HOME_POINT,
        SUBSTRING(A_MOVE_OUTSIDE_HOME, CHARINDEX('_', A_MOVE_OUTSIDE_HOME) + 1, LEN(A_MOVE_OUTSIDE_HOME) - CHARINDEX('_', A_MOVE_OUTSIDE_HOME))             AS MOVE_OUTSIDE_HOME_VALUE,
        SUBSTRING(A_APARTMENT_CLEANING, 0, CHARINDEX('_', A_APARTMENT_CLEANING))                                                                            AS APARTMENT_CLEANING_POINT,
        SUBSTRING(A_APARTMENT_CLEANING, CHARINDEX('_', A_APARTMENT_CLEANING) + 1, LEN(A_APARTMENT_CLEANING) - CHARINDEX('_', A_APARTMENT_CLEANING))         AS APARTMENT_CLEANING_VALUE,
        SUBSTRING(A_LAUNDRY, 0, CHARINDEX('_', A_LAUNDRY))                                                                                                  AS LAUNDRY_POINT,
        SUBSTRING(A_LAUNDRY, CHARINDEX('_', A_LAUNDRY) + 1, LEN(A_LAUNDRY) - CHARINDEX('_', A_LAUNDRY))                                                     AS LAUNDRY_VALUE,
        SUBSTRING(A_COOKING, 0, CHARINDEX('_', A_COOKING))                                                                                                  AS COOKING_POINT,
        SUBSTRING(A_COOKING, CHARINDEX('_', A_COOKING) + 1, LEN(A_COOKING) - CHARINDEX('_', A_COOKING))                                                     AS COOKING_VALUE,
        SUBSTRING(A_MOVING_HOUSE, 0, CHARINDEX('_', A_MOVING_HOUSE))                                                                                        AS MOVING_HOUSE_POINT,
        SUBSTRING(A_MOVING_HOUSE, CHARINDEX('_', A_MOVING_HOUSE) + 1, LEN(A_MOVING_HOUSE) - CHARINDEX('_', A_MOVING_HOUSE))                                 AS MOVING_HOUSE_VALUE,
        SUBSTRING(A_FALLS, 0, CHARINDEX('_', A_FALLS))                                                                                                      AS FALLS_POINT,
        SUBSTRING(A_FALLS, CHARINDEX('_', A_FALLS) + 1, LEN(A_FALLS) - CHARINDEX('_', A_FALLS))                                                             AS FALLS_VALUE,
        SUBSTRING(A_DRESSING, 0, CHARINDEX('_', A_DRESSING))                                                                                                AS DRESSING_POINT,
        SUBSTRING(A_DRESSING, CHARINDEX('_', A_DRESSING) + 1, LEN(A_DRESSING) - CHARINDEX('_', A_DRESSING))                                                 AS DRESSING_VALUE,
        SUBSTRING(A_HYGIENE, 0, CHARINDEX('_', A_HYGIENE))                                                                                                  AS HYGIENE_POINT,
        SUBSTRING(A_HYGIENE, CHARINDEX('_', A_HYGIENE) + 1, LEN(A_HYGIENE) - CHARINDEX('_', A_HYGIENE))                                                     AS HYGIENE_VALUE,
        SUBSTRING(A_RECEPTION_EAT_MED, 0, CHARINDEX('_', A_RECEPTION_EAT_MED))                                                                              AS RECEPTION_EAT_MED_POINT,
        SUBSTRING(A_RECEPTION_EAT_MED, CHARINDEX('_', A_RECEPTION_EAT_MED) + 1, LEN(A_RECEPTION_EAT_MED) - CHARINDEX('_', A_RECEPTION_EAT_MED))             AS RECEPTION_EAT_MED_VALUE,
        SUBSTRING(A_URINATION_DEFECATION, 0, CHARINDEX('_', A_URINATION_DEFECATION))                                                                        AS URINATION_DEFECATION_POINT,
        SUBSTRING(A_URINATION_DEFECATION, CHARINDEX('_', A_URINATION_DEFECATION) + 1, LEN(A_URINATION_DEFECATION) - CHARINDEX('_', A_URINATION_DEFECATION)) AS URINATION_DEFECATION_VALUE,
        SUBSTRING(A_SUPERVISION, 0, CHARINDEX('_', A_SUPERVISION))                                                                                          AS SUPERVISION_POINT,
        SUBSTRING(A_SUPERVISION, CHARINDEX('_', A_SUPERVISION) + 1, LEN(A_SUPERVISION) - CHARINDEX('_', A_SUPERVISION))                                     AS SUPERVISION_VALUE,
        SUBSTRING(A_HEAR, 0, CHARINDEX('_', A_HEAR))                                                                                                        AS HEAR_POINT,
        SUBSTRING(A_HEAR, CHARINDEX('_', A_HEAR) + 1, LEN(A_HEAR) - CHARINDEX('_', A_HEAR))                                                                 AS HEAR_VALUE,
        SUBSTRING(A_PRESENCE_DANGER, 0, CHARINDEX('_', A_PRESENCE_DANGER))                                                                                  AS PRESENCE_DANGER_POINT,
        SUBSTRING(A_PRESENCE_DANGER, CHARINDEX('_', A_PRESENCE_DANGER) + 1, LEN(A_PRESENCE_DANGER) - CHARINDEX('_', A_PRESENCE_DANGER))                     AS PRESENCE_DANGER_VALUE,
        SUBSTRING(A_SUPPORT, 0, CHARINDEX('_', A_SUPPORT))                                                                                                  AS SUPPORT_POINT,
        SUBSTRING(A_SUPPORT, CHARINDEX('_', A_SUPPORT) + 1, LEN(A_SUPPORT) - CHARINDEX('_', A_SUPPORT))                                                     AS SUPPORT_VALUE
    FROM WM_ASSESSMENT_DEPENDENCE assesment
    ----Личное дело гражданина.
        INNER JOIN WM_PERSONAL_CARD personalCard
            ON personalCard.OUID = assesment.PERSONOUID
                AND personalCard.A_STATUS = 10
    WHERE assesment.A_STATUS = 10
) t



------------------------------------------------------------------------------------------------------------------------------


--Общая выборка.
SELECT
    *
FROM #ASSESSMENT_DEPENDENCE assesment
ORDER BY assesment.PERSONOUID, assesment.INSPECT_INDEX


------------------------------------------------------------------------------------------------------------------------------


--Сравнение.
SELECT 
    assesment1.PERSONOUID,
    assesment1.BIRTH_DATE,
    assesment1.INSPECT_FOR_STAZ     AS INSPECT_FOR_STAZ_1,
    assesment1.INSPECT_DATE         AS INSPECT_DATE_1,
    assesment1.INSPECT_INDEX        AS INSPECT_INDEX_1,
    assesment1.INSPECT_NEXT_DATE    AS INSPECT_NEXT_DATE_1, 
    assesment1.ORGANIZATION         AS ORGANIZATION_1, 
    assesment1.DEGREE               AS DEGREE_1, 
    assesment1.SUM_VALUE            AS SUM_VALUE_1,
    assesment2.INSPECT_FOR_STAZ     AS INSPECT_FOR_STAZ_2,
    assesment2.INSPECT_DATE         AS INSPECT_DATE_2,
    assesment2.INSPECT_INDEX        AS INSPECT_INDEX_2,
    assesment2.INSPECT_NEXT_DATE    AS INSPECT_NEXT_DATE_2, 
    assesment2.ORGANIZATION         AS ORGANIZATION_2, 
    assesment2.DEGREE               AS DEGREE_2, 
    assesment2.SUM_VALUE            AS SUM_VALUE_2,
    CASE
        WHEN assesment1.DEGREE < assesment2.DEGREE THEN 'worse'
        WHEN assesment1.DEGREE = assesment2.DEGREE THEN 'equal'
        WHEN assesment1.DEGREE > assesment2.DEGREE THEN 'better'
    END AS DEGREE_CHANGE,
    CASE
        WHEN assesment1.SUM_VALUE < assesment2.SUM_VALUE THEN 'worse'
        WHEN assesment1.SUM_VALUE = assesment2.SUM_VALUE THEN 'equal'
        WHEN assesment1.SUM_VALUE > assesment2.SUM_VALUE THEN 'better'
    END AS SUM_VALUE_CHANGE
FROM #ASSESSMENT_DEPENDENCE assesment1
    LEFT JOIN #ASSESSMENT_DEPENDENCE assesment2
        ON assesment1.PERSONOUID = assesment2.PERSONOUID
            AND assesment1.INSPECT_INDEX = assesment2.INSPECT_INDEX - 1
ORDER BY assesment1.PERSONOUID, assesment1.INSPECT_INDEX


------------------------------------------------------------------------------------------------------------------------------