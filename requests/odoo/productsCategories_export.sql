-- Suppose that "All / Saleable","All / Consumable",
  (SELECT "All" AS "Parent Category",  "Services" AS Name)
UNION
  (SELECT "All" AS "Parent Category",  "Obsolete" AS Name)
UNION
  (SELECT "All" AS "Parent Category",  "Consumable" AS Name)
UNION SELECT
  IF(c.rowid IN(194,195,196),"All / Saleable","All / Consumable") AS "Parent Category",
  c.label AS Name
  FROM  llx_categorie AS c
  WHERE c.type = 0 AND c.fk_parent IN (192) AND c.rowid IN (194,195,196,197,198,199) -- categorie type is product (0)
