class ZCL_DEMO_MPC_CUST definition
  public
  inheriting from ZCL_DEMO_MPC_EXT
  final
  create public .

public section.

  methods DEFINE
    redefinition .
protected section.

  methods EXTEND_CUSTOMER
    raising
      /IWBEP/CX_MGW_MED_EXCEPTION .
private section.
ENDCLASS.



CLASS ZCL_DEMO_MPC_CUST IMPLEMENTATION.


  METHOD define.
    super->define( ).

    extend_customer( ).

  ENDMETHOD.


  METHOD extend_customer.

    DATA:
      lo_entity_type TYPE REF TO /iwbep/if_mgw_odata_entity_typ, "#EC NEEDED
      lo_property    TYPE REF TO /iwbep/if_mgw_odata_property. "#EC NEEDED

***********************************************************************************************************************************
*   ENTITY - Customer
***********************************************************************************************************************************

    lo_entity_type = model->get_entity_type( 'Customer' ).  "#EC NOTEXT

***********************************************************************************************************************************
*Properties
***********************************************************************************************************************************

    lo_property = lo_entity_type->create_property(
      iv_property_name = 'Segmentation'
      iv_abap_fieldname = 'SEGMENTATION' ).                 "#EC NOTEXT
    lo_property->set_type_edm_string( ).
    lo_property->set_maxlength( iv_max_length = 1 ).        "#EC NOTEXT
    lo_property->set_creatable( abap_false ).
    lo_property->set_updatable( abap_false ).
    lo_property->set_sortable( abap_false ).
    lo_property->set_nullable( abap_false ).
    lo_property->set_filterable( abap_false ).

  ENDMETHOD.
ENDCLASS.
