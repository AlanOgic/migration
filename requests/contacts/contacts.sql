SELECT
  DATE_FORMAT(date(contact.tms),'%y-%m-%d') AS ModDate,
  contact.civility as Civility, contact.firstname as Firstname, contact.lastname as Lastname,contact.poste AS Poste,
  contact.email AS Email,contact.socialnetworks AS Social,
  contact.phone AS Phone,contact.phone_mobile AS Mobile,
  group_concat(categories.journey SEPARATOR ',') AS Journey,
  group_concat(categories.position SEPARATOR ',') AS Position,
  contact.fk_prospectcontactlevel AS Engagement,
  societe.nom as Company,
  societe.url AS WebSite,
  country.label AS Country,country.code AS CountryCode,region.code_departement AS RegionCode,
  societe.zip AS Zip,societe.town AS Town,societe.address AS Street,
  CASE societe.client WHEN 0 THEN 'none'  WHEN 1 THEN 'customer' WHEN 2 THEN 'prospect' WHEN 3 THEN 'prosp_cust' ELSE 'error' END AS Customer,
  group_concat(categories.business SEPARATOR ',') AS Business,
  group_concat(categories.size SEPARATOR ',') AS Size,
  group_concat(categories.buyer SEPARATOR ',') AS Buyer,
  group_concat(categories.specificity SEPARATOR ',') AS Specificity,
  'ERP' AS Book,
  NULL AS Newsletter,
  CONCAT('https://dolibarr.cyanview.ovh/societe/card.php?socid=',societe.rowid) AS SocId,
  CONCAT('https://dolibarr.cyanview.ovh/contact/card.php?id=',contact.rowid) AS  ContactId
FROM
  llx_socpeople AS contact
  LEFT JOIN llx_societe AS societe ON societe.rowid = contact.fk_soc
  LEFT JOIN llx_c_country AS country ON country.rowid = societe.fk_pays
  LEFT JOIN llx_c_departements AS region ON region.rowid = societe.fk_departement
  LEFT JOIN
    (SELECT
      catcont.fk_socpeople AS contactid,
      NULL AS socid,
      NULL AS business,
      NULL AS size,
      NULL AS buyer,
      NULL AS specificity,
      SUBSTR(cat_jney.label,3) AS journey,
      SUBSTR(cat_pos.label,3) AS position
      FROM  llx_categorie_contact AS catcont
      -- find journey categorie : meta-categorie (parent) is 39, categorie type is contact (4)
      LEFT JOIN llx_categorie AS cat_jney ON cat_jney.rowid = catcont.fk_categorie and cat_jney.fk_parent = 215  and cat_jney.type = 4
      -- find position categorie : meta-categorie (parent) is 214, categorie type is customer (4)
      LEFT JOIN llx_categorie AS cat_pos ON cat_pos.rowid = catcont.fk_categorie and cat_pos.fk_parent = 214  and cat_pos.type = 4
    UNION
    SELECT
      NULL AS contactid,
      catsoc.fk_soc AS socid,
      SUBSTR(cat_biz.label,3) AS business,
      cat_size.label AS size,
      SUBSTR(cat_buy.label,3) AS buyer,
      cat_spec.label AS specificity,
      NULL AS journey,
      NULL AS position
    FROM  llx_categorie_societe AS catsoc
      -- find business categorie : meta-categorie (parent) is 39, categorie type is customer (2)
      LEFT JOIN llx_categorie AS cat_biz ON cat_biz.rowid = catsoc.fk_categorie and cat_biz.fk_parent = 39  and cat_biz.type = 2
      -- find size categorie : meta-categorie (parent) is 48, categorie type is customer (2)
      LEFT JOIN llx_categorie AS cat_size ON cat_size.rowid = catsoc.fk_categorie and cat_size.fk_parent = 48  and cat_size.type = 2
      -- find buyer categorie : meta-categorie (parent) is 157, categorie type is customer (2)
      LEFT JOIN llx_categorie AS cat_buy ON cat_buy.rowid = catsoc.fk_categorie and cat_buy.fk_parent = 157  and cat_buy.type = 2
      -- find specificity categorie : meta-categorie (parent) is 209, categorie type is customer (2)
      LEFT JOIN llx_categorie AS cat_spec ON cat_spec.rowid = catsoc.fk_categorie and cat_spec.fk_parent = 209  and cat_spec.type = 2
    )
      AS categories ON categories.socid = societe.rowid OR categories.contactid = contact.rowid
WHERE 1 = 1
GROUP BY contact.rowid
ORDER BY contact.lastname
