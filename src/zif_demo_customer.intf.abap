interface ZIF_DEMO_CUSTOMER
  public .


  interfaces ZIF_GW_METHODS .

  methods GET_NODE_KEY
    returning
      value(NODE_KEY) type SNWD_NODE_KEY
    raising
      ZCX_DEMO_BO .
  methods GET_BP_ID
    returning
      value(BP_ID) type SNWD_PARTNER_ID
    raising
      ZCX_DEMO_BO .
  methods GET_COMPANY_NAME
    returning
      value(COMPANY_NAME) type SNWD_COMPANY_NAME
    raising
      ZCX_DEMO_BO .
  methods GET_STREET
    returning
      value(STREET) type SNWD_STREET
    raising
      ZCX_DEMO_BO .
  methods GET_CITY
    returning
      value(CITY) type SNWD_CITY
    raising
      ZCX_DEMO_BO .
  methods GET_POSTAL_CODE
    returning
      value(POSTAL_CODE) type SNWD_POSTAL_CODE
    raising
      ZCX_DEMO_BO .
  methods GET_COUNTRY
    returning
      value(COUNTRY) type SNWD_COUNTRY
    raising
      ZCX_DEMO_BO .
  methods GET_COUNTRY_TEXT
    returning
      value(COUNTRY_TEXT) type LANDX50
    raising
      ZCX_DEMO_BO .
endinterface.
