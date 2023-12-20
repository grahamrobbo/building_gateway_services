INTERFACE zif_demo_salesorder
  PUBLIC .


  INTERFACES zif_gw_methods .

  METHODS get_node_key
    RETURNING
      VALUE(node_key) TYPE snwd_node_key
    RAISING
      zcx_demo_bo .
  METHODS get_so_id
    RETURNING
      VALUE(so_id) TYPE snwd_so_id
    RAISING
      zcx_demo_bo .
  METHODS get_created_at
    RETURNING
      VALUE(created_at) TYPE timestampl
    RAISING
      zcx_demo_bo .
  METHODS get_items
    RETURNING
      VALUE(items) TYPE osreftab
    RAISING
      zcx_demo_bo .
  METHODS get_item_by_pos
    IMPORTING
      !so_item_pos TYPE snwd_so_item_pos
    RETURNING
      VALUE(item)  TYPE REF TO zif_demo_salesorderitem
    RAISING
      zcx_demo_bo .
  METHODS get_customer
    RETURNING
      VALUE(customer) TYPE REF TO zif_demo_customer
    RAISING
      zcx_demo_bo .
ENDINTERFACE.
