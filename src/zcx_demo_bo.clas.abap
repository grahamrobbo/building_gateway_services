class ZCX_DEMO_BO definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

public section.

  constants NOT_FOUND type SOTR_CONC value '0050568378E31ED5B6D5E7D4CC44BC95' ##NO_TEXT.
  constants ERROR type SOTR_CONC value '0050568378E31ED5B6D5FE9DB7CEBC95' ##NO_TEXT.
  constants NOT_AUTHORISED type SOTR_CONC value '0050568378E31ED683B4EE7E985A3C95' ##NO_TEXT.
  data BO_TYPE type STRING .
  data BO_ID type STRING .
  data ERROR_MESSAGE type STRING .

  methods CONSTRUCTOR
    importing
      !TEXTID like TEXTID optional
      !PREVIOUS like PREVIOUS optional
      !BO_TYPE type STRING optional
      !BO_ID type STRING optional
      !ERROR_MESSAGE type STRING optional .
protected section.
private section.
ENDCLASS.



CLASS ZCX_DEMO_BO IMPLEMENTATION.


  method CONSTRUCTOR ##ADT_SUPPRESS_GENERATION.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
TEXTID = TEXTID
PREVIOUS = PREVIOUS
.
me->BO_TYPE = BO_TYPE .
me->BO_ID = BO_ID .
me->ERROR_MESSAGE = ERROR_MESSAGE .
  endmethod.
ENDCLASS.
