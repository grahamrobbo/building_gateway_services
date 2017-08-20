class ZCL_BO_ABSTRACT definition
  public
  abstract
  create public .

public section.

  methods CALL_ALL_GETTERS
  final
    importing
      !ENTITY type ref to DATA
      !ENTITY_NAME type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_INTERNAL_NAME optional
      !MODEL type ref to ZCL_GW_MODEL optional
    raising
      ZCX_DEMO_BO .
protected section.

  class-methods RAISE_EXCEPTION_ON_ERROR
    importing
      !BAPIRETURN type BAPIRET2_TAB optional
    raising
      ZCX_DEMO_BO .
  class-methods GET_SUBCLASS
    importing
      !CLSNAME_IN type SEOCLSNAME
    returning
      value(CLSNAME_OUT) type SEOCLSNAME .
  class-methods GET_STRUCT_DESCR
    importing
      !DATA type DATA
    returning
      value(STRUCT_DESCR) type ref to CL_ABAP_STRUCTDESCR
    raising
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_BO_ABSTRACT IMPLEMENTATION.


  METHOD call_all_getters.
*--------------------------------------------------------------------*
* This method fills the entity properties by calling the GET method  *
* for each property in turn.                                         *
*                                                                    *
* To work both the GET method and the returning parameter must have  *
* the same name as the ABAP field.                                   *
*                                                                    *
* i.e. KUNNR property filled by calling ...                          *
*                                                                    *
*              entity->kunnr = me->get_kunnr( ).                     *
*                                                                    *
*--------------------------------------------------------------------*

    DATA: properties   TYPE stringtab,
          struct_descr TYPE REF TO cl_abap_structdescr,
          parameter    TYPE abap_parmbind,
          parameters   TYPE abap_parmbind_tab.

    TRY.
* If model and entity name are available we can determine the entity properties from the model ...
        LOOP AT model->get_entity_properties( entity_name ) REFERENCE INTO DATA(model_property).
          APPEND model_property->name TO properties.
        ENDLOOP.
      CATCH cx_root.
* ... otherwise we use rtts to determine entity properties from entity itself.
        TRY.
            struct_descr ?= cl_abap_structdescr=>describe_by_data_ref( entity ).
            LOOP AT struct_descr->components REFERENCE INTO DATA(component).
              APPEND component->name TO properties.
            ENDLOOP.
          CATCH cx_root.
        ENDTRY.
    ENDTRY.

    ASSIGN entity->* TO FIELD-SYMBOL(<entity>).
    CHECK sy-subrc = 0.

    LOOP AT properties REFERENCE INTO DATA(property).
      CLEAR parameters.
      TRY.
          ASSIGN COMPONENT property->* OF STRUCTURE <entity> TO FIELD-SYMBOL(<comp>).
          IF sy-subrc = 0.
            parameter-name = property->*.
            parameter-kind = cl_abap_objectdescr=>returning.
            GET REFERENCE OF <comp> INTO parameter-value.
            INSERT parameter INTO TABLE parameters.
            DATA(method_name) = |GET_{ property->* }|.
            CALL METHOD me->(method_name)
              PARAMETER-TABLE parameters.
          ENDIF.
        CATCH cx_sy_dyn_call_error.
      ENDTRY.
    ENDLOOP.

  ENDMETHOD.


METHOD get_struct_descr.
*--------------------------------------------------------------------*
* Returns instantiated CL_ABAP_STRUCTDESCR for the linetype of the   *
* passed in itab.                                                    *
*--------------------------------------------------------------------*
  DATA: table_descr    TYPE REF TO cl_abap_tabledescr.

  TRY.
      table_descr ?= cl_abap_tabledescr=>describe_by_data( data ).
      struct_descr ?= table_descr->get_table_line_type( ).
    CATCH cx_sy_move_cast_error INTO DATA(cx_sy_move_cast_error).
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception
        EXPORTING
          textid   = /iwbep/cx_mgw_tech_exception=>internal_error
          previous = cx_sy_move_cast_error.
  ENDTRY.
ENDMETHOD.


METHOD GET_SUBCLASS.
*--------------------------------------------------------------------*
* This method walks down the inheritance tree and returns the name   *
* of the last child.                                                 *
*--------------------------------------------------------------------*
    DATA: obj TYPE REF TO cl_oo_object,
          inf TYPE REF TO cl_oo_interface,
          cls TYPE REF TO cl_oo_class.

    DATA(lv_clsname) = clsname_in.

    WHILE clsname_out IS INITIAL.
      TRY.
          obj = cl_oo_object=>get_instance( lv_clsname ).
          TRY.
              cls ?= obj.
              DATA(subclasses) = cls->get_subclasses( ).
              READ TABLE subclasses REFERENCE INTO DATA(subclass) INDEX 1.
              IF sy-subrc  = 0.
                lv_clsname = subclass->clsname.
              ELSE.
                clsname_out = lv_clsname.
              ENDIF.
            CATCH cx_sy_move_cast_error.
              TRY.
                  inf ?= obj.
                  DATA(classes) = inf->get_implementing_classes( ).
                  READ  TABLE classes REFERENCE INTO DATA(class) INDEX 1.
                  IF sy-subrc  = 0.
                    lv_clsname = class->clsname.
                  ELSE.
                    clsname_out = lv_clsname.
                  ENDIF.
                CATCH cx_sy_move_cast_error.
                  clsname_out = lv_clsname.
              ENDTRY.
          ENDTRY.
        CATCH cx_class_not_existent.
          clsname_out = lv_clsname.
      ENDTRY.
    ENDWHILE.

  ENDMETHOD.


METHOD raise_exception_on_error.
*--------------------------------------------------------------------*
* This helper method is designed to take in the BAPIRET2TAB itab,    *
* parse for error messages, and then raise an exception.             *
*--------------------------------------------------------------------*
  LOOP AT bapireturn REFERENCE INTO DATA(lr_return) WHERE type = 'E'.
    MESSAGE ID lr_return->id TYPE lr_return->type NUMBER lr_return->number
            INTO DATA(error_message)
            WITH lr_return->message_v1 lr_return->message_v2 lr_return->message_v3 lr_return->message_v4.
    RAISE EXCEPTION TYPE zcx_demo_bo
      EXPORTING
        textid        = zcx_demo_bo=>error
        error_message = error_message.
  ENDLOOP.

ENDMETHOD.
ENDCLASS.
