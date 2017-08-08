interface ZIF_GW_METHODS
  public .


  class-methods CREATE_ENTITY
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_C optional
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER optional
      !IO_MODEL type ref to ZCL_GW_MODEL
      !IO_MESSAGE_CONTAINER type ref to /IWBEP/IF_MESSAGE_CONTAINER optional
    exporting
      !ER_ENTITY type DATA
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  class-methods CREATE_DEEP_ENTITY
    importing
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER
      !IO_EXPAND type ref to /IWBEP/IF_MGW_ODATA_EXPAND
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_C optional
      !IO_MODEL type ref to ZCL_GW_MODEL
      !IO_MESSAGE_CONTAINER type ref to /IWBEP/IF_MESSAGE_CONTAINER optional
    exporting
      !ER_DEEP_ENTITY type ref to DATA
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  class-methods DELETE_ENTITY
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_D optional
      !IO_MODEL type ref to ZCL_GW_MODEL
      !IO_MESSAGE_CONTAINER type ref to /IWBEP/IF_MESSAGE_CONTAINER optional
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  class-methods GET_ENTITY
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY optional
      !IO_MODEL type ref to ZCL_GW_MODEL
      !IO_MESSAGE_CONTAINER type ref to /IWBEP/IF_MESSAGE_CONTAINER optional
    exporting
      !ER_ENTITY type DATA
      !ES_RESPONSE_CONTEXT type /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_ENTITY_CNTXT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  class-methods GET_ENTITYSET
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITYSET
      !IO_MODEL type ref to ZCL_GW_MODEL
      !IO_MESSAGE_CONTAINER type ref to /IWBEP/IF_MESSAGE_CONTAINER optional
    exporting
      !ET_ENTITYSET type DATA
      !ES_RESPONSE_CONTEXT type /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_CONTEXT
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  class-methods UPDATE_ENTITY
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_U optional
      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER optional
      !IO_MODEL type ref to ZCL_GW_MODEL
      !IO_MESSAGE_CONTAINER type ref to /IWBEP/IF_MESSAGE_CONTAINER optional
    exporting
      !ER_ENTITY type DATA
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  class-methods EXECUTE_ACTION
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_FUNC_IMPORT
      !IO_MODEL type ref to ZCL_GW_MODEL
      !IO_MESSAGE_CONTAINER type ref to /IWBEP/IF_MESSAGE_CONTAINER optional
    exporting
      !ER_DATA type ref to DATA
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods MAP_TO_ENTITY
    importing
      !ENTITY type ref to DATA
      !ENTITY_NAME type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_INTERNAL_NAME optional
      !MODEL type ref to ZCL_GW_MODEL optional
    raising
      ZCX_DEMO_BO .
endinterface.
