INTERFACE zif_demo_salesorderitem
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
  METHODS get_so_item_pos
    RETURNING
      VALUE(so_item_pos) TYPE snwd_so_item_pos
    RAISING
      zcx_demo_bo .
  METHODS get_product_id
    RETURNING
      VALUE(product_id) TYPE snwd_product_id
    RAISING
      zcx_demo_bo .
  METHODS get_text
    RETURNING
      VALUE(text) TYPE snwd_desc
    RAISING
      zcx_demo_bo .
  METHODS get_net_amount
    RETURNING
      VALUE(net_amount) TYPE snwd_ttl_net_amount
    RAISING
      zcx_demo_bo .
  METHODS get_currency_code
    RETURNING
      VALUE(currency_code) TYPE snwd_curr_code
    RAISING
      zcx_demo_bo .
  METHODS get_currency_txt
    RETURNING
      VALUE(currency_txt) TYPE zdemo_waerk_text
    RAISING
      zcx_demo_bo .
ENDINTERFACE.
