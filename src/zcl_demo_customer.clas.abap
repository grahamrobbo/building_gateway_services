class ZCL_DEMO_CUSTOMER definition
  public
  inheriting from ZCL_BO_ABSTRACT
  create protected .

public section.

  interfaces ZIF_GW_METHODS .
  interfaces ZIF_DEMO_CUSTOMER .

  aliases GET_BP_ID
    for ZIF_DEMO_CUSTOMER~GET_BP_ID .
  aliases GET_CITY
    for ZIF_DEMO_CUSTOMER~GET_CITY .
  aliases GET_COMPANY_NAME
    for ZIF_DEMO_CUSTOMER~GET_COMPANY_NAME .
  aliases GET_COUNTRY
    for ZIF_DEMO_CUSTOMER~GET_COUNTRY .
  aliases GET_COUNTRY_TEXT
    for ZIF_DEMO_CUSTOMER~GET_COUNTRY_TEXT .
  aliases GET_NODE_KEY
    for ZIF_DEMO_CUSTOMER~GET_NODE_KEY .
  aliases GET_POSTAL_CODE
    for ZIF_DEMO_CUSTOMER~GET_POSTAL_CODE .
  aliases GET_STREET
    for ZIF_DEMO_CUSTOMER~GET_STREET .

  class-methods GET
    importing
      !NODE_KEY type SNWD_NODE_KEY
    returning
      value(INSTANCE) type ref to ZIF_DEMO_CUSTOMER
    raising
      ZCX_DEMO_BO .
  class-methods GET_USING_BP_ID
    importing
      !BP_ID type SNWD_PARTNER_ID
    returning
      value(INSTANCE) type ref to ZIF_DEMO_CUSTOMER
    raising
      ZCX_DEMO_BO .
protected section.

  types:
    BEGIN OF instance_type,
        node_key TYPE snwd_node_key,
        instance TYPE REF TO zif_demo_customer,
      END OF instance_type .
  types:
    instance_ttype TYPE TABLE OF instance_type .

  class-data INSTANCES type INSTANCE_TTYPE .
  class-data:
    countries TYPE TABLE OF t005t .
  data CUSTOMER_DATA type ZDEMO_CUSTOMER .

  methods CONSTRUCTOR
    importing
      !NODE_KEY type SNWD_NODE_KEY
    raising
      ZCX_DEMO_BO .
  methods LOAD_CUSTOMER_DATA
    importing
      !NODE_KEY type SNWD_NODE_KEY
    raising
      ZCX_DEMO_BO .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DEMO_CUSTOMER IMPLEMENTATION.


  METHOD constructor.
    super->constructor( ).

    load_customer_data( node_key ).

  ENDMETHOD.


  METHOD get.

    TRY.
        DATA(inst) = instances[ node_key = node_key ].
      CATCH cx_sy_itab_line_not_found.
        inst-node_key = node_key.
        DATA(class_name) = get_subclass( 'ZIF_DEMO_CUSTOMER' ).
        CREATE OBJECT inst-instance
          TYPE (class_name)
          EXPORTING
            node_key = inst-node_key.
        APPEND inst TO instances.
    ENDTRY.

    instance ?= inst-instance.

  ENDMETHOD.


  METHOD get_using_bp_id.

    DATA: lv_bp_id TYPE snwd_partner_id.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = bp_id
      IMPORTING
        output = lv_bp_id.

    SELECT SINGLE node_key
      FROM snwd_bpa
      INTO @DATA(node_key)
      WHERE bp_id = @lv_bp_id.
    IF sy-subrc = 0.
      instance = get( node_key ).
    ELSE.
      RAISE EXCEPTION TYPE zcx_demo_bo
        EXPORTING
          textid  = zcx_demo_bo=>not_found
          bo_type = 'Customer'
          bo_id   = |{ bp_id }|.
    ENDIF.
  ENDMETHOD.


  METHOD load_customer_data.

    SELECT SINGLE bp~node_key, bp~bp_id, bp~company_name,
      ad~street, ad~city, ad~postal_code, ad~country
      FROM snwd_bpa AS bp
        INNER JOIN snwd_ad AS ad
        ON bp~address_guid = ad~node_key
      INTO CORRESPONDING FIELDS OF @customer_data
      WHERE bp~node_key = @node_key.

    IF sy-subrc NE 0.
      RAISE EXCEPTION TYPE zcx_demo_bo
        EXPORTING
          textid  = zcx_demo_bo=>not_found
          bo_type = 'DEMO_CUSTOMER'
          bo_id   = |{ node_key }|.
    ENDIF.
  ENDMETHOD.


  METHOD zif_demo_customer~get_bp_id.
    bp_id = me->customer_data-bp_id.
  ENDMETHOD.


  METHOD zif_demo_customer~get_city.
    city = me->customer_data-city.
  ENDMETHOD.


  METHOD zif_demo_customer~get_company_name.
    company_name = me->customer_data-company_name.
  ENDMETHOD.


  METHOD zif_demo_customer~get_country.
    country = me->customer_data-country.
  ENDMETHOD.


  METHOD zif_demo_customer~get_country_text.
    TRY.
        country_text = countries[ land1 = customer_data-country ]-landx50.
      CATCH cx_sy_itab_line_not_found.
        SELECT land1 landx50
          FROM t005t
          APPENDING CORRESPONDING FIELDS OF TABLE countries
          WHERE spras = sy-langu
          AND land1 = customer_data-country.
        IF sy-subrc = 0.
          country_text = countries[ land1 = customer_data-country ]-landx50.
        ENDIF.
    ENDTRY.
  ENDMETHOD.


  METHOD zif_demo_customer~get_node_key.
    node_key = me->customer_data-node_key.
  ENDMETHOD.


  METHOD zif_demo_customer~get_postal_code.
    postal_code = me->customer_data-postal_code.
  ENDMETHOD.


  METHOD zif_demo_customer~get_street.
    street = me->customer_data-street.
  ENDMETHOD.


  METHOD zif_gw_methods~create_deep_entity.
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
      EXPORTING
        textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
        method = 'ZIF_GW_METHODS~CREATE_DEEP_ENTITY'.
  ENDMETHOD.


  METHOD zif_gw_methods~create_entity.
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
      EXPORTING
        textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
        method = 'ZIF_GW_METHODS~CREATE_ENTITY'.
  ENDMETHOD.


  METHOD zif_gw_methods~delete_entity.
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
      EXPORTING
        textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
        method = 'ZIF_GW_METHODS~DELETE_ENTITY'.
  ENDMETHOD.


  METHOD zif_gw_methods~execute_action.
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
      EXPORTING
        textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
        method = 'ZIF_GW_METHODS~EXECUTE_ACTION'.
  ENDMETHOD.


  METHOD zif_gw_methods~get_entity.

    TRY.
        CASE io_tech_request_context->get_source_entity_type_name( ).
          WHEN 'SalesOrder'.
            DATA(source_keys) = io_tech_request_context->get_source_keys( ).
            zcl_demo_salesorder=>get_using_so_id(
              CONV #( source_keys[ name = 'SO_ID' ]-value )
              )->get_customer( )->zif_gw_methods~map_to_entity(
                EXPORTING
                  entity      = REF #( er_entity )
                  entity_name = io_tech_request_context->get_entity_type_name( )
                  model       = io_model
              ).
          WHEN OTHERS.
            DATA(keys) = io_tech_request_context->get_keys( ).
            zcl_demo_customer=>get_using_bp_id(
              CONV #( keys[ name = 'BP_ID' ]-value )
              )->zif_gw_methods~map_to_entity(
                EXPORTING
                  entity      = REF #( er_entity )
                  entity_name = io_tech_request_context->get_entity_type_name( )
                  model       = io_model
              ).
        ENDCASE.

      CATCH zcx_demo_bo cx_sy_itab_line_not_found INTO DATA(exception).
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            textid   = /iwbep/cx_mgw_busi_exception=>business_error
            previous = exception
            message  = |{ exception->get_text( ) }|.
    ENDTRY.

  ENDMETHOD.


  METHOD zif_gw_methods~get_entityset.

    FIELD-SYMBOLS: <entityset> TYPE STANDARD TABLE.
    ASSIGN et_entityset TO <entityset>.

    " Use RTTS/RTTC to create anonymous object like line of et_entityset
    DATA: entity         TYPE REF TO data.
    TRY.
        DATA(struct_descr) = get_struct_descr( et_entityset ).
        CREATE DATA entity TYPE HANDLE struct_descr.
        ASSIGN entity->* TO FIELD-SYMBOL(<entity>).
      CATCH cx_sy_create_data_error INTO DATA(cx_sy_create_data_error).
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception
          EXPORTING
            textid   = /iwbep/cx_mgw_tech_exception=>internal_error
            previous = cx_sy_create_data_error.
    ENDTRY.

    " $orderby query options
    DATA: orderby_clause TYPE string.
    LOOP AT io_tech_request_context->get_orderby( ) REFERENCE INTO DATA(orderby).
      DATA(property) =
        io_model->get_property(
          iv_entity_name = io_tech_request_context->get_entity_type_name( )
          iv_property_name  = orderby->property ).
      IF property-sortable = abap_true.
        CASE orderby->property. " This is where we add table aliases for the SQL join
          WHEN 'BP_ID' OR 'COMPANY_NAME'.
            orderby_clause = orderby_clause &&
              |, BP~{ orderby->property } { orderby->order CASE = UPPER }ENDING |.
          WHEN OTHERS.
            orderby_clause = orderby_clause &&
              |, AD~{ orderby->property } { orderby->order CASE = UPPER }ENDING |.
        ENDCASE.
      ELSE.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            textid  = /iwbep/cx_mgw_busi_exception=>business_error
            message = |Order property '{ property-external_name }' is not supported|.
      ENDIF.
    ENDLOOP.
    SHIFT orderby_clause LEFT DELETING LEADING ', '.

    " $filterby query options
    DATA: where_clause   TYPE string.
    LOOP AT io_tech_request_context->get_filter( )->get_filter_select_options( ) REFERENCE INTO DATA(filterby).
      property =
        io_model->get_property(
          iv_entity_name = io_tech_request_context->get_entity_type_name( )
          iv_property_name  = CONV #( filterby->property ) ).
      IF property-filterable = abap_true.
        CASE filterby->property.
          WHEN 'BP_ID'.
            DATA(bp_range) = filterby->select_options.
            where_clause = |{ where_clause } & BP~BP_ID IN @BP_RANGE|.
          WHEN 'COMPANY_NAME'.
            DATA(name_range) = filterby->select_options.
            where_clause = |{ where_clause } & BP~COMPANY_NAME IN @NAME_RANGE|.
          WHEN 'STREET'.
            DATA(street_range) = filterby->select_options.
            where_clause = |{ where_clause } & AD~STREET IN @STREET_RANGE|.
          WHEN 'CITY'.
            DATA(city_range) = filterby->select_options.
            where_clause = |{ where_clause } & AD~CITY IN @CITY_RANGE|.
          WHEN 'POSTAL_CODE'.
            DATA(pcode_range) = filterby->select_options.
            where_clause = |{ where_clause } & AD~POSTAL_CODE IN @PCODE_RANGE|.
          WHEN 'COUNTRY'.
            DATA(country_range) = filterby->select_options.
            where_clause = |{ where_clause } & AD~COUNTRY IN @COUNTRY_RANGE|.
        ENDCASE.
      ELSE.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            textid       = /iwbep/cx_mgw_busi_exception=>filter_not_supported
            filter_param = CONV #( property-external_name ).
      ENDIF.
    ENDLOOP.
    IF sy-subrc NE 0. " Catch complex $filter queries
      where_clause = io_tech_request_context->get_filter( )->get_filter_string( ).
      " This is where we add table aliases for the SQL join
      " All this is a bit flakey as we have not really parsed the where clause
      " in a way that will avoid the consumer building an invalid $filter clause
      REPLACE ALL OCCURRENCES OF ` BP_ID ` IN where_clause WITH ` BP~BP_ID `.
      REPLACE ALL OCCURRENCES OF ` COMPANY_NAME ` IN where_clause WITH ` BP~COMPANY_NAME `.
      REPLACE ALL OCCURRENCES OF ` STREET ` IN where_clause WITH ` AD~STREET `.
      REPLACE ALL OCCURRENCES OF ` CITY ` IN where_clause WITH ` AD~CITY `.
      REPLACE ALL OCCURRENCES OF ` POSTAL_CODE ` IN where_clause WITH ` AD~POSTAL_CODE `.
      REPLACE ALL OCCURRENCES OF ` COUNTRY ` IN where_clause WITH ` AD~COUNTRY `.
    ENDIF.

    SHIFT where_clause LEFT DELETING LEADING ' &'.
    REPLACE ALL OCCURRENCES OF '&' IN where_clause WITH 'AND'.

    DATA: top  TYPE i,
          skip TYPE i.
    top = io_tech_request_context->get_top( ). "why does this API return a string?
    skip = io_tech_request_context->get_skip( ).

    TRY.
        " $inlinecount=allpages
        IF io_tech_request_context->has_inlinecount( ) = abap_true.
          DATA dbcount TYPE int4 .
          SELECT COUNT(*)
            INTO @dbcount
            FROM snwd_bpa AS bp
              INNER JOIN snwd_ad AS ad
              ON bp~address_guid = ad~node_key
            WHERE (where_clause).
          es_response_context-inlinecount = dbcount. "why is this a string?
        ENDIF.

        " Get primary keys
        SELECT bp~node_key
          FROM snwd_bpa AS bp
            INNER JOIN snwd_ad AS ad
            ON bp~address_guid = ad~node_key
              WHERE (where_clause)
              ORDER BY (orderby_clause)
              INTO CORRESPONDING FIELDS OF @<entity>.

          CHECK sy-dbcnt > skip.
          APPEND <entity> TO <entityset>.
          IF top > 0 AND lines( <entityset> ) GE top.
            EXIT.
          ENDIF.
        ENDSELECT.
      CATCH cx_sy_dynamic_osql_error INTO DATA(cx_sy_dynamic_osql_error).
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            textid   = /iwbep/cx_mgw_busi_exception=>business_error
            previous = cx_sy_dynamic_osql_error
            message  = |{ cx_sy_dynamic_osql_error->get_text( ) }|.
    ENDTRY.

    " $count
    CHECK io_tech_request_context->has_count( ) NE abap_true.

    " $skiptoken
    CONSTANTS: max_page_size TYPE i VALUE 50.
    DATA: index_start TYPE i,
          index_end   TYPE i.

    IF lines( <entityset> ) > max_page_size.
      index_start = io_tech_request_context->get_skiptoken( ).
      IF index_start = 0. index_start = 1. ENDIF.
      index_end = index_start + max_page_size - 1.
      LOOP AT <entityset> REFERENCE INTO entity.
        IF index_start > 1.
          DELETE <entityset>.
          SUBTRACT 1 FROM index_start.
        ELSE.
          CHECK sy-tabix > max_page_size.
          DELETE <entityset>.
        ENDIF.
      ENDLOOP.
      IF lines( <entityset> ) = max_page_size.
        es_response_context-skiptoken = index_end + 1.
      ENDIF.
    ENDIF.

    " Fill entities
    LOOP AT <entityset> REFERENCE INTO entity.
      ASSIGN entity->* TO <entity>.
      ASSIGN COMPONENT 'NODE_KEY' OF STRUCTURE <entity> TO FIELD-SYMBOL(<node_key>).
      CHECK <node_key> IS ASSIGNED.
      TRY.
          zcl_demo_customer=>get( <node_key> )->zif_gw_methods~map_to_entity(
            EXPORTING
              entity      = entity
              entity_name = io_tech_request_context->get_entity_type_name( )
              model       = io_model
          ).
        CATCH zcx_demo_bo.
      ENDTRY.
    ENDLOOP.

  ENDMETHOD.


  METHOD zif_gw_methods~map_to_entity.
    call_all_getters(
      EXPORTING
        entity      = entity
        entity_name = entity_name
        model       = model
    ).
  ENDMETHOD.


  METHOD zif_gw_methods~update_entity.
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
      EXPORTING
        textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
        method = 'ZIF_GW_METHODS~UPDATE_ENTITY'.
  ENDMETHOD.
ENDCLASS.
