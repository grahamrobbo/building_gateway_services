class ZCL_DEMO_SALESORDER definition
  public
  inheriting from ZCL_BO_ABSTRACT
  create protected .

public section.

  interfaces ZIF_GW_METHODS .
  interfaces ZIF_DEMO_SALESORDER .

  aliases GET_CREATED_AT
    for ZIF_DEMO_SALESORDER~GET_CREATED_AT .
  aliases GET_SO_ID
    for ZIF_DEMO_SALESORDER~GET_SO_ID .

  class-methods GET
    importing
      !NODE_KEY type SNWD_NODE_KEY
    returning
      value(INSTANCE) type ref to ZIF_DEMO_SALESORDER
    raising
      ZCX_DEMO_BO .
  class-methods GET_USING_SO_ID
    importing
      !SO_ID type SNWD_SO_ID
    returning
      value(INSTANCE) type ref to ZIF_DEMO_SALESORDER
    raising
      ZCX_DEMO_BO .
protected section.

  types:
    BEGIN OF instance_type,
        node_key TYPE snwd_node_key,
        instance TYPE REF TO zif_demo_salesorder,
      END OF instance_type .
  types:
    instance_ttype TYPE TABLE OF instance_type .

  class-data INSTANCES type INSTANCE_TTYPE .
  data SALESORDER_DATA type ZDEMO_SALESORDER .

  methods CONSTRUCTOR
    importing
      !NODE_KEY type SNWD_NODE_KEY
    raising
      ZCX_DEMO_BO .
  methods LOAD_SALESORDER_DATA
    importing
      !NODE_KEY type SNWD_NODE_KEY
    raising
      ZCX_DEMO_BO .
  PRIVATE SECTION.

ENDCLASS.



CLASS ZCL_DEMO_SALESORDER IMPLEMENTATION.


  METHOD constructor.
    super->constructor( ).

    load_salesorder_data( node_key ).

  ENDMETHOD.


  METHOD get.

    TRY.
        DATA(inst) = instances[ node_key = node_key ].
      CATCH cx_sy_itab_line_not_found.
        inst-node_key = node_key.
        DATA(class_name) = get_subclass( 'ZCL_DEMO_SALESORDER' ).
        CREATE OBJECT inst-instance
          TYPE (class_name)
          EXPORTING
            node_key = inst-node_key.
        APPEND inst TO instances.
    ENDTRY.

    instance ?= inst-instance.
  ENDMETHOD.


  METHOD get_using_so_id.

    DATA: lv_so_id TYPE snwd_so_id.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = so_id
      IMPORTING
        output = lv_so_id.

    SELECT SINGLE node_key
      FROM snwd_so
      INTO @DATA(node_key)
      WHERE so_id = @lv_so_id.
    IF sy-subrc = 0.
      instance = get( node_key ).
    ELSE.
      RAISE EXCEPTION TYPE zcx_demo_bo
        EXPORTING
          textid  = zcx_demo_bo=>not_found
          bo_type = 'SalesOrder'
          bo_id   = |{ so_id }|.
    ENDIF.

  ENDMETHOD.


  METHOD load_salesorder_data.

    SELECT SINGLE *
      FROM snwd_so
      INTO CORRESPONDING FIELDS OF salesorder_data
      WHERE node_key = node_key.

    IF sy-subrc NE 0.
      RAISE EXCEPTION TYPE zcx_demo_bo
        EXPORTING
          textid  = zcx_demo_bo=>not_found
          bo_type = 'DEMO_SALESORDER'
          bo_id   = |{ node_key }|.
    ENDIF.
  ENDMETHOD.


  METHOD zif_demo_salesorder~get_created_at.
    created_at = me->salesorder_data-created_at.
  ENDMETHOD.


  METHOD zif_demo_salesorder~get_customer.
    customer = zcl_demo_customer=>get( salesorder_data-buyer_guid ).
  ENDMETHOD.


  METHOD zif_demo_salesorder~get_items.

    DATA(so_node_key) = zif_demo_salesorder~get_node_key( ).

    SELECT node_key
      FROM snwd_so_i
      INTO @DATA(node_key)
      WHERE parent_key = @so_node_key
      ORDER BY so_item_pos.
      TRY.
          APPEND zcl_demo_salesorderitem=>get( node_key ) TO items.
        CATCH cx_root.
      ENDTRY.
    ENDSELECT.

  ENDMETHOD.


  METHOD zif_demo_salesorder~get_item_by_pos.

    DATA(so_node_key) = zif_demo_salesorder~get_node_key( ).

    DATA: lv_so_item_pos TYPE snwd_so_item_pos.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = so_item_pos
      IMPORTING
        output = lv_so_item_pos.

    SELECT SINGLE node_key
      FROM snwd_so_i
      INTO @DATA(node_key)
      WHERE parent_key = @so_node_key
      AND so_item_pos = @lv_so_item_pos.

    item = zcl_demo_salesorderitem=>get( node_key ).

  ENDMETHOD.


  METHOD zif_demo_salesorder~get_node_key.
    node_key = salesorder_data-node_key.
  ENDMETHOD.


  METHOD zif_demo_salesorder~get_so_id.
    so_id = me->salesorder_data-so_id.
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
          WHEN 'SalesOrderItem'.
            DATA(source_keys) = io_tech_request_context->get_source_keys( ).
            zcl_demo_salesorder=>get_using_so_id(
              CONV #( source_keys[ name = 'SO_ID' ]-value )
              )->zif_gw_methods~map_to_entity(
                EXPORTING
                  entity      = REF #( er_entity )
                  entity_name = io_tech_request_context->get_entity_type_name( )
                  model       = io_model
              ).
          WHEN OTHERS.
            DATA(keys) = io_tech_request_context->get_keys( ).
            zcl_demo_salesorder=>get_using_so_id(
              CONV #( keys[ name = 'SO_ID' ]-value )
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
*--------------------------------------------------------------------*
* See ZCL_DEMO_CUSTOMER->ZIF_GW_METHODS~GET_ENTITYSET for better example
*--------------------------------------------------------------------*

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
        orderby_clause = orderby_clause &&
          |{ orderby->property } { orderby->order CASE = UPPER }ENDING |.
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
          WHEN 'SO_ID'.
            DATA(so_range) = filterby->select_options.
            where_clause = |{ where_clause } & SO_ID IN @SO_RANGE|.
          WHEN 'CREATED_AT'.
            DATA(created_range) = filterby->select_options.
            where_clause = |{ where_clause } & CREATED_AT IN @CREATED_RANGE|.
        ENDCASE.
      ELSE.
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            textid       = /iwbep/cx_mgw_busi_exception=>filter_not_supported
            filter_param = CONV #( property-external_name ).
      ENDIF.
    ENDLOOP.
    IF sy-subrc NE 0.
      where_clause = io_tech_request_context->get_filter( )->get_filter_string( ).
    ENDIF.

    DATA(source_keys) = io_tech_request_context->get_source_keys( ).
    CASE io_tech_request_context->get_source_entity_type_name( ).
      WHEN 'Customer'.
        TRY.
            DATA(buyer_guid) = zcl_demo_customer=>get_using_bp_id( CONV #( source_keys[ name = 'BP_ID' ]-value ) )->get_node_key( ).
            where_clause = |{ where_clause } & BUYER_GUID = @BUYER_GUID|.
          CATCH cx_sy_itab_line_not_found zcx_demo_bo INTO DATA(cx).
            RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
              EXPORTING
                textid   = /iwbep/cx_mgw_busi_exception=>business_error
                previous = cx
                message  = |{ cx->get_text( ) }|.
        ENDTRY.
      WHEN OTHERS.
    ENDCASE.

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
            INTO dbcount
            FROM snwd_so
            WHERE (where_clause).
          es_response_context-inlinecount = dbcount. "why is this a string?
        ENDIF.

        " Get primary keys
        SELECT node_key
          INTO CORRESPONDING FIELDS OF @<entity>
          FROM snwd_so
          WHERE (where_clause)
          ORDER BY (orderby_clause).
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
      TRY.
          zcl_demo_salesorder=>get( <node_key> )->zif_gw_methods~map_to_entity(
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
