/*
  Recherche par shipments des SO liés et de leur état afin de décider de la facturation
  Notes:
  SO statut: NOT_ENOUGH_FOR_ORDER = -3;statut_CANCELED = -1;DRAFT = 0;VALIDATED = 1;SHIPMENTONPROCESS = 2;CLOSED = 3;
  SHIPMENT statut:_DRAFT = 0;VALIDATED = 1; CLOSED = 2;
*/
SELECT DISTINCT
  c.date_valid AS Date,
  c.rowid AS SO,
  c.ref   AS SO_ref,
  c.ref_client AS SO_refclient,
  c.multicurrency_code AS Currency,
  c.multicurrency_total_ht AS Amount,
  s.nom   AS Societe,
  p.libelle AS Reglement,
  CASE
    WHEN c.fk_statut = -3 THEN 'NOT ENOUGH'
    WHEN c.fk_statut = -1 THEN 'CANCELED'
    WHEN c.fk_statut = 0 THEN 'DRAFT'
    WHEN c.fk_statut = 1 THEN 'VALIDATED'
    WHEN c.fk_statut = 2 THEN 'ON PROCESS'
    WHEN c.fk_statut = 3 THEN 'CLOSED'
  ELSE c.fk_statut END
  AS SO_statut,
  e.rowid AS SH,
  e.ref   AS SH_ref,
  CASE
    WHEN e.fk_statut = 0 THEN 'DRAFT'
    WHEN e.fk_statut = 1 THEN 'VALIDATED'
    WHEN e.fk_statut = 2 THEN 'CLOSED'
  ELSE e.fk_statut END
  AS SH_statut,
  e.fk_statut AS SH_statut,
  sm.libelle  AS Carrier,
  CONCAT('<a href="',REPLACE(sm.tracking,'{TRACKID}',e.tracking_number),'">',e.tracking_number,'</a>') AS Tracking,
  c.note_private AS SO_Note
FROM llx_expedition AS e
  LEFT JOIN llx_element_element AS ee ON ee.targettype = 'shipping' AND e.rowid = ee.fk_target
  LEFT JOIN llx_commande AS c ON ee.sourcetype = 'commande' AND c.rowid = ee.fk_source
  LEFT JOIN llx_commande_extrafields AS ce ON ce.fk_object = c.rowid
  LEFT JOIN llx_c_paiement AS p ON p.id = c.fk_mode_reglement
  LEFT JOIN llx_societe AS s ON s.rowid = c.fk_soc
  LEFT JOIN llx_c_shipment_mode AS sm ON sm.rowid = e.fk_shipping_method
  LEFT JOIN llx_element_element AS eebis ON c.rowid = eebis.fk_source AND eebis.sourcetype = 'commande' AND  eebis.targettype = 'facture'
  LEFT JOIN llx_facture AS f ON f.rowid = eebis.fk_target
WHERE c.rowid IS NOT NULL
ORDER BY c.rowid DESC

/*
  Version "MyList" de la requête.
  !!Seule la version XML permet de configurer MyList, l'interface utilisateur ne permet pas de
    saisir l'affichage du lien de tracking!!

<?xml version='1.0' encoding='ISO-8859-1'?><mylist>
<label>OrdersCheck</label>
<titlemenu>OrdersCheck</titlemenu>
<mainmenu>cyanview</mainmenu>
<leftmenu></leftmenu>
<elementtab></elementtab>
<perms>$user->rights->produit->lire</perms>
<datatable>true</datatable>
<shownumline>false</shownumline>
<langs>orders:sendings</langs>
<export>0</export>
<model_pdf>-1</model_pdf>
<author>TNA</author>
<querylist>
FROM llx_expedition AS e LEFT JOIN llx_element_element AS ee ON ee.targettype = 'shipping' AND e.rowid = ee.fk_target LEFT JOIN llx_commande AS c ON ee.sourcetype = 'commande' AND c.rowid = ee.fk_source LEFT JOIN llx_commande_extrafields AS ce ON ce.fk_object = c.rowid LEFT JOIN llx_c_paiement AS p ON p.id = c.fk_mode_reglement LEFT JOIN llx_societe AS s ON s.rowid = c.fk_soc LEFT JOIN llx_c_shipment_mode AS sm ON sm.rowid = e.fk_shipping_method LEFT JOIN llx_element_element AS eebis ON c.rowid = eebis.fk_source AND eebis.sourcetype = 'commande' AND  eebis.targettype = 'facture' LEFT JOIN llx_facture AS f ON f.rowid = eebis.fk_target WHERE c.rowid IS NOT NULL ORDER BY VDate DESC
</querylist>
<fieldinit>

</fieldinit>
<querydo>

</querydo>
<fields>
  <!-- DATE DE VALIDATION DU SO-->
	<field >
	 	<name>VDate</name>
	 	<field>DATE_FORMAT(c.date_valid,'%y-%m-%d')</field>
	 	<alias>VDate</alias>
	 	<type>Text</type>
	 	<rang>1</rang>
	 	<param></param>
	 	<align>left</align>
	 	<enabled>1</enabled>
	 	<sumreport>0</sumreport>
	 	<pctreport>0</pctreport>
	 	<cumreport>0</cumreport>
	 	<cumpctreport>0</cumpctreport>
	 	<avgreport>0</avgreport>
	 	<barcode></barcode>
	 	<visible>1</visible>
	 	<filter>1</filter>
	 	<width>100</width>
	 	<widthpdf>0</widthpdf>
	 	<filterinit></filterinit>
  </field>
  <!-- CHAMP DE SO: SO link, SO_statut, INV Link, Reglement, Tracking -->
  <field >
	 	<name>SO</name>
	 	<field>c.rowid</field>
	 	<alias>SO</alias>
	 	<type>List</type>
	 	<rang>2</rang>
	 	<param>Commande:/commande/class/commande.class.php</param>
	 	<align>left</align>
	 	<enabled>1</enabled>
	 	<sumreport>0</sumreport>
	 	<pctreport>0</pctreport>
	 	<cumreport>0</cumreport>
	 	<cumpctreport>0</cumpctreport>
	 	<avgreport>0</avgreport>
	 	<barcode></barcode>
	 	<visible>1</visible>
	 	<filter>1</filter>
	 	<width>100</width>
	 	<widthpdf>0</widthpdf>
	 	<filterinit></filterinit>
	</field>
  <field >
	 	<name>SOStatut</name>
	 	<field>c.fk_statut</field>
	 	<alias>SOStatut</alias>
	 	<type>Statut</type>
	 	<rang>3</rang>
	 	<param>Commande:/commande/class/commande.class.php:#0#1#2#3</param>
	 	<align>left</align>
	 	<enabled>1</enabled>
	 	<sumreport>0</sumreport>
	 	<pctreport>0</pctreport>
	 	<cumreport>0</cumreport>
	 	<cumpctreport>0</cumpctreport>
	 	<avgreport>0</avgreport>
	 	<barcode></barcode>
	 	<visible>1</visible>
	 	<filter>1</filter>
	 	<width>30</width>
	 	<widthpdf>0</widthpdf>
	 	<filterinit></filterinit>
	</field>
  <field>
    <name>INV</name>
    <field>f.rowid</field>
    <alias>INV</alias>
    <type>List</type>
    <rang>4</rang>
    <param>Facture:/compta/facture/class/facture.class.php</param>
    <align>left</align>
    <enabled>1</enabled>
    <sumreport>0</sumreport>
    <pctreport>0</pctreport>
    <cumreport>0</cumreport>
    <cumpctreport>0</cumpctreport>
    <avgreport>0</avgreport>
    <barcode></barcode>
    <visible>1</visible>
    <filter>1</filter>
    <width>100</width>
    <widthpdf>0</widthpdf>
    <filterinit></filterinit>
  </field>
  <field >
   	<name>Reglement</name>
   	<field>p.libelle</field>
   	<alias>Reglement</alias>
   	<type>Text</type>
   	<rang>6</rang>
   	<param></param>
   	<align>left</align>
   	<enabled>1</enabled>
   	<sumreport>0</sumreport>
   	<pctreport>0</pctreport>
   	<cumreport>0</cumreport>
   	<cumpctreport>0</cumpctreport>
   	<avgreport>0</avgreport>
   	<barcode></barcode>
   	<visible>1</visible>
   	<filter>1</filter>
   	<width>30</width>
   	<widthpdf>0</widthpdf>
   	<filterinit></filterinit>
  </field>
  <field >
    <name>Tracking</name>
    <field>CONCAT('<![CDATA[<a href="]]>',REPLACE(sm.tracking,'{TRACKID}',e.tracking_number),'<![CDATA[">]]>',e.tracking_number,'<![CDATA[</a>]]>')</field>
    <alias>Tracking</alias>
    <type>Text</type>
    <rang>7</rang>
    <param></param>
    <align>left</align>
    <enabled>1</enabled>
    <sumreport></sumreport>
    <pctreport></pctreport>
    <cumreport></cumreport>
    <cumpctreport></cumpctreport>
    <avgreport></avgreport>
    <barcode></barcode>
    <visible>1</visible>
    <filter>1</filter>
    <width>30</width>
    <widthpdf></widthpdf>
    <filterinit></filterinit>
  </field>
  <!-- CHAMP DE SH: SH link, Statut, Reference -->
  <field >
   	<name>Shipment</name>
   	<field>e.rowid</field>
   	<alias>Shipment</alias>
   	<type>List</type>
   	<rang>8</rang>
   	<param>Expedition:/expedition/class/expedition.class.php</param>
   	<align>left</align>
   	<enabled>1</enabled>
   	<sumreport>0</sumreport>
   	<pctreport>0</pctreport>
   	<cumreport>0</cumreport>
   	<cumpctreport>0</cumpctreport>
   	<avgreport>0</avgreport>
   	<barcode></barcode>
   	<visible>1</visible>
   	<filter>1</filter>
   	<width>100</width>
   	<widthpdf>0</widthpdf>
   	<filterinit></filterinit>
  </field>
  <field >
   	<name>SHStatut</name>
   	<field>e.fk_statut</field>
   	<alias>SHStatut</alias>
   	<type>Statut</type>
   	<rang>9</rang>
   	<param>Expedition:/expedition/class/expedition.class.php:0#1#2</param>
   	<align>left</align>
   	<enabled>1</enabled>
   	<sumreport>0</sumreport>
   	<pctreport>0</pctreport>
   	<cumreport>0</cumreport>
   	<cumpctreport>0</cumpctreport>
   	<avgreport>0</avgreport>
   	<barcode></barcode>
   	<visible>1</visible>
   	<filter>1</filter>
   	<width>30</width>
   	<widthpdf>0</widthpdf>
   	<filterinit></filterinit>
  </field>
  <field >
   	<name>CustRef</name>
   	<field>c.ref_client</field>
   	<alias>CustRef</alias>
   	<type>Text</type>
   	<rang>10</rang>
   	<param></param>
   	<align>left</align>
   	<enabled>1</enabled>
   	<sumreport>0</sumreport>
   	<pctreport>0</pctreport>
   	<cumreport>0</cumreport>
   	<cumpctreport>0</cumpctreport>
   	<avgreport>0</avgreport>
   	<barcode></barcode>
   	<visible>1</visible>
   	<filter>1</filter>
   	<width>30</width>
   	<widthpdf>0</widthpdf>
   	<filterinit></filterinit>
  </field>
  <!-- Montants -->
  <field >
   	<name>Amount</name>
   	<field>c.multicurrency_total_ht</field>
   	<alias>Amount</alias>
   	<type>Price</type>
   	<rang>11</rang>
   	<param></param>
   	<align>left</align>
   	<enabled>1</enabled>
   	<sumreport>0</sumreport>
   	<pctreport>0</pctreport>
   	<cumreport>0</cumreport>
   	<cumpctreport>0</cumpctreport>
   	<avgreport>0</avgreport>
   	<barcode></barcode>
   	<visible>1</visible>
   	<filter>1</filter>
   	<width>100</width>
   	<widthpdf>0</widthpdf>
   	<filterinit></filterinit>
  </field>
  <field >
   	<name>Currency</name>
   	<field>c.multicurrency_code</field>
   	<alias>Currency</alias>
   	<type>Text</type>
   	<rang>12</rang>
   	<param></param>
   	<align>left</align>
   	<enabled>1</enabled>
   	<sumreport>0</sumreport>
   	<pctreport>0</pctreport>
   	<cumreport>0</cumreport>
   	<cumpctreport>0</cumpctreport>
   	<avgreport>0</avgreport>
   	<barcode></barcode>
   	<visible>1</visible>
   	<filter>1</filter>
   	<width>30</width>
   	<widthpdf>0</widthpdf>
   	<filterinit></filterinit>
  </field>
  <!-- DIVERS: Client, Transporteur, Note -->
  <field >
   	<name>Customer</name>
   	<field>s.rowid</field>
   	<alias>Customer</alias>
   	<type>List</type>
   	<rang>13</rang>
   	<param>Societe:/societe/class/societe.class.php:societe:nom</param>
   	<align>left</align>
   	<enabled>1</enabled>
   	<sumreport>0</sumreport>
   	<pctreport>0</pctreport>
   	<cumreport>0</cumreport>
   	<cumpctreport>0</cumpctreport>
   	<avgreport>0</avgreport>
   	<barcode></barcode>
   	<visible>1</visible>
   	<filter>1</filter>
   	<width>100</width>
   	<widthpdf>0</widthpdf>
   	<filterinit></filterinit>
  </field>
  <field >
   	<name>Carrier</name>
   	<field>sm.libelle</field>
   	<alias>Carrier</alias>
   	<type>Text</type>
   	<rang>14</rang>
   	<param></param>
   	<align>left</align>
   	<enabled>1</enabled>
   	<sumreport>0</sumreport>
   	<pctreport>0</pctreport>
   	<cumreport>0</cumreport>
   	<cumpctreport>0</cumpctreport>
   	<avgreport>0</avgreport>
   	<barcode></barcode>
   	<visible>1</visible>
   	<filter>1</filter>
   	<width>30</width>
   	<widthpdf>0</widthpdf>
   	<filterinit></filterinit>
  </field>
  <field >
   	<name>Note</name>
   	<field>c.note_private</field>
   	<alias>Note</alias>
   	<type>Text</type>
   	<rang>15</rang>
   	<param></param>
   	<align>left</align>
   	<enabled>1</enabled>
   	<sumreport>0</sumreport>
   	<pctreport>0</pctreport>
   	<cumreport>0</cumreport>
   	<cumpctreport>0</cumpctreport>
   	<avgreport>0</avgreport>
   	<barcode></barcode>
   	<visible>1</visible>
   	<filter>1</filter>
   	<width>30</width>
   	<widthpdf>0</widthpdf>
   	<filterinit></filterinit>
  </field>
</fields>
</mylist>
*/