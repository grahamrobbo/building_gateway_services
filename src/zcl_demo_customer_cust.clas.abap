class ZCL_DEMO_CUSTOMER_CUST definition
  public
  inheriting from ZCL_DEMO_CUSTOMER
  final
  create protected

  global friends ZCL_DEMO_CUSTOMER .

public section.

  methods GET_SEGMENTATION
    returning
      value(SEGMENTATION) type ZDEMO_SEGMENTATION
    raising
      ZCX_DEMO_BO .
protected section.
private section.
ENDCLASS.



CLASS ZCL_DEMO_CUSTOMER_CUST IMPLEMENTATION.


METHOD get_segmentation.
*--------------------------------------------------------------------*
* Sample extension of BO class with new method                       *
*--------------------------------------------------------------------*
  DATA(name) = zif_demo_customer~get_company_name( ).
  segmentation = |{ name(1) CASE = UPPER }|.
ENDMETHOD.
ENDCLASS.
