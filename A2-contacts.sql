-- id  	name	is_company	parent_id	vat	website	email	customer_rank	supplier_rank	title/shortcut	function	category_id	phone	mobile
-- state_id	country_code	city	zip	street	date	create_date	comment
-- ??? property_account_position_id/name : "FISCAL POSITION" (TODO)
CREATE OR REPLACE VIEW a2_contacts AS
SELECT
  CONCAT("compan",LPAD(societe.rowid,4,0)) AS "External ID",
  societe.nom AS "Name",
  "TRUE" AS "Is a Company",
  "" AS "Related Company",
  IFNULL(societe.tva_intra,"") AS "Tax ID",
  CASE 
    WHEN country.code = "BE" THEN  "Régime National"
    WHEN country.code IN ("AT","BG","HR","CY","CZ","DK","EE","FI","FR","DE","GR","HU","IE","IT","LV","LT","LU","MT","NL","PL","PT","RO","SK","SI","ES","SE","EU") THEN "Régime Intra-Communautaire" 
    ELSE IF(ISNULL(country.code),NULL,"Régime Extra-Communautaire") 
  END AS "property_account_position_id", -- To be checked
  IFNULL(IFNULL(societe.url,CONCAT("https://www.",SUBSTRING_INDEX(societe.email, '@', -1))),'') AS "Website Link",
  IFNULL(societe.email,"") AS "Email",
  societe.client AS "Customer Rank",  --ON VA TROUVER MIEUX
  societe.fournisseur AS "Supplier Rank", --PAREIL
  "" AS "Title",
  "" AS "Job Position",
  TRIM(BOTH ',' FROM
    REPLACE(
      CONCAT(
        IFNULL(CONCAT(categories.business,","),""),
        IFNULL(CONCAT(categories.buyer,","),""),
        IFNULL(CONCAT(categories.specificity,","),""),
        IFNULL(categories.size,"")
        )
      ,",,",",")
    )  AS "Tags",
  IFNULL(societe.phone,"") AS "Phone",
  "" AS "Mobile",
  IFNULL(country.code,"") AS "Country",
  IF(country.code IN ("US","CA"),IFNULL(state.nom,""),"") AS "State", -- Suppressing States not understtod by Odoo
  IFNULL(societe.zip,"") AS "Zip",
  IFNULL(societe.town,"") AS "City",
  IFNULL(societe.address,"") AS "Street",
  -- IFNULL(DATE_FORMAT(date(societe.tms)  ,'%Y-%m-%d'),"2019-07-01") AS "Date",
  IFNULL(DATE_FORMAT(date(societe.datec),'%Y-%m-%d'),"2019-07-01") AS "Date",
  IFNULL(societe.note_private,"") As "Notes"
FROM
  llx_societe AS societe
  LEFT JOIN llx_c_country AS country ON country.rowid = societe.fk_pays
  LEFT JOIN llx_c_departements AS state ON state.rowid = societe.fk_departement
  LEFT JOIN (
    SELECT
      catsoc.fk_soc AS socid,
      GROUP_CONCAT(IF (cat_biz.label IN ("Unknown","Others"),"",CONCAT("Business / ", SUBSTR(cat_biz.label,3))) SEPARATOR ',') AS business,
      GROUP_CONCAT(CONCAT("Size / ", cat_size.label) SEPARATOR ',')               AS size, 
      GROUP_CONCAT(IF (cat_buy.label IN ("Unknown","Others"),"",CONCAT("Buyer / ", SUBSTR(cat_buy.label,3))) SEPARATOR ',') AS buyer,
      GROUP_CONCAT(CONCAT("Specificity / ", cat_spec.label) SEPARATOR ',')        AS specificity
    FROM  llx_categorie_societe AS catsoc
      -- find business categorie : meta-categorie (parent) is 39, categorie type is customer (2)
      LEFT JOIN llx_categorie AS cat_biz ON cat_biz.rowid = catsoc.fk_categorie and cat_biz.fk_parent = 39  and cat_biz.type = 2
      -- find size categorie : meta-categorie (parent) is 48, categorie type is customer (2)
      LEFT JOIN llx_categorie AS cat_size ON cat_size.rowid = catsoc.fk_categorie and cat_size.fk_parent = 48  and cat_size.type = 2
      -- find buyer categorie : meta-categorie (parent) is 157, categorie type is customer (2)
      LEFT JOIN llx_categorie AS cat_buy ON cat_buy.rowid = catsoc.fk_categorie and cat_buy.fk_parent = 157  and cat_buy.type = 2
      -- find specificity categorie : meta-categorie (parent) is 209, categorie type is customer (2)
      LEFT JOIN llx_categorie AS cat_spec ON cat_spec.rowid = catsoc.fk_categorie and cat_spec.fk_parent = 209  and cat_spec.type = 2
    WHERE 1 = 1
    GROUP BY catsoc.fk_soc
  ) AS categories ON categories.socid = societe.rowid
  WHERE societe.fk_pays IS NOT NULL  -- FULL EXPORT (with suppression of Pipedrive phantoms)
  -- WHERE societe.rowid IN(473,246,843,345,624)  -- SIMPIFIED EXPORT
UNION
SELECT
  CONCAT("people",LPAD(contact.rowid,4,0)) AS "External ID",
  IFNULL(CONCAT (contact.firstname," ",contact.lastname),"") AS "Name",
  "FALSE" AS "Is a Company",
  societe.nom AS "Related Company",
  "" AS "Tax ID",
  "" AS "property_account_position_id", -- To be checked
  IF(ISNULL(contact.email),"",IFNULL(societe.url,CONCAT("www.",SUBSTRING_INDEX(contact.email,"@",-1)))) AS "Website Link",
  IFNULL(contact.email,"") AS "Email",
  0 AS "Customer Rank",
  0 AS "Supplier Rank",
  CASE
    WHEN contact.civility="MR" THEN "Mister" WHEN contact.civility="MME" THEN "Madam"
    WHEN contact.civility="MRS" THEN "Madam" WHEN contact.civility="MLLE" THEN "Miss" ELSE ""
    END AS "Title",
  IFNULL(contact.poste,"") AS "Job Position",
  TRIM(BOTH ',' FROM
    REPLACE(
      CONCAT(
        IFNULL(CONCAT(SUBSTR(categories.journey,1),","),""),
        IFNULL(SUBSTR(categories.position,1),"")
        )
      ,",,",",")
  ) AS "Tags",
  IFNULL(contact.phone_perso,IFNULL(contact.phone,""))AS "Phone",
  IFNULL(contact.phone_mobile,"") AS "Mobile",
  IFNULL(country.code,"") AS "Country",
  IF(country.code IN ("US","CA"),IFNULL(state.nom,""),"") AS "State",
  IFNULL(societe.zip,"") AS "Zip",
  IFNULL(societe.town,"") AS "City",
  IFNULL(societe.address,"") AS "Street",
  -- IFNULL(DATE_FORMAT(date(contact.tms)  ,'%Y-%m-%d'),"2019-07-01") AS "Date",
  IFNULL(DATE_FORMAT(date(contact.datec),'%Y-%m-%d'),"2019-07-01") AS "Date",
  IFNULL(contact.note_private,"") As "Notes"
FROM
  llx_socpeople AS contact
  LEFT JOIN llx_societe AS societe ON societe.rowid = contact.fk_soc
  LEFT JOIN llx_c_country AS country ON country.rowid = contact.fk_pays
  LEFT JOIN llx_c_departements AS state ON state.rowid = contact.fk_departement
  LEFT JOIN(
    SELECT
      catcont.fk_socpeople AS contactid,
      GROUP_CONCAT(IF (cat_jney.label IN ("Unknown","Others"),"",CONCAT("Journey / ", SUBSTR(cat_jney.label,3))) SEPARATOR ',')  AS journey,
      GROUP_CONCAT(IF (cat_pos.label  IN ("Unknown","Others"),"",CONCAT("Position / ", SUBSTR(cat_pos.label,3))) SEPARATOR ',')  AS position
      FROM  llx_categorie_contact AS catcont
        -- find journey categorie : meta-categorie (parent) is 39, categorie type is contact (4)
        LEFT JOIN llx_categorie AS cat_jney ON cat_jney.rowid = catcont.fk_categorie and cat_jney.fk_parent = 215  and cat_jney.type = 4
        -- find position categorie : meta-categorie (parent) is 214, categorie type is customer (4)
        LEFT JOIN llx_categorie AS cat_pos ON cat_pos.rowid = catcont.fk_categorie and cat_pos.fk_parent = 214  and cat_pos.type = 4
      WHERE 1 = 1 
      GROUP BY catcont.fk_socpeople
  ) AS categories ON categories.contactid = contact.rowid
  WHERE societe.fk_pays IS NOT NULL
ORDER BY "External Id";  -- FULL EXPORT (with suppression of Pipedrive phantoms)
  -- WHERE societe.rowid IN(473,246,843,345,624);  -- LIGHT EXPORT
SELECT * FROM a2_contacts; 