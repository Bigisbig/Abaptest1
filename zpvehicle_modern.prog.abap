*&---------------------------------------------------------------------*
*& Report ZPVEHICLE_MODERN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpvehicle_modern.
CLASS vehicle DEFINITION.

  PUBLIC SECTION.
    CLASS-DATA: numofvehicles TYPE i.
    CLASS-METHODS: class_constructor.

    METHODS setnumseat
      IMPORTING
        newnumseats TYPE i.

    METHODS gofaster
      IMPORTING
        increment TYPE i
      EXPORTING
        result    TYPE i.

    METHODS goslower
      IMPORTING
        decrement     TYPE i
      RETURNING
        VALUE(result) TYPE i.
    METHODS constructor
      IMPORTING
        make     TYPE c
        model    TYPE c
        numseat  TYPE i
        maxspeed TYPE i.

    METHODS viewvehicle.

  PRIVATE SECTION.
    DATA: make     TYPE c LENGTH 20,
          model    TYPE c LENGTH 20,
          numseat  TYPE i,
          speed    TYPE i,
          maxspeed TYPE i.

    CLASS-DATA carlog TYPE c LENGTH 40.

ENDCLASS.

CLASS vehicle IMPLEMENTATION.
  METHOD setnumseat.
    numseat = newnumseats.
  ENDMETHOD.
  METHOD gofaster.
    DATA buffer_speed TYPE i.
    buffer_speed = speed + increment.

    IF buffer_speed <= maxspeed.
      speed  = speed + increment.
    ENDIF.
    result = speed.
  ENDMETHOD.

  METHOD goslower.
    DATA buffer_speed TYPE i.
    buffer_speed = speed - decrement.

    IF buffer_speed > 0.
      speed  = speed - decrement.
    ENDIF.
    result = speed.
  ENDMETHOD.

  METHOD constructor.
    me->make  =  make.
    me->model = model.
    me->numseat = numseat.
    me->maxspeed = maxspeed.
    numofvehicles = numofvehicles + 1.

  ENDMETHOD.
  METHOD class_constructor.
    carlog = 'Vehicle Details'.
    WRITE: / carlog.
  ENDMETHOD.
  METHOD viewvehicle.
    WRITE: / 'Make :', make LEFT-JUSTIFIED.
    WRITE: / 'Model :', model LEFT-JUSTIFIED.
    WRITE: / 'Numseat :', numseat LEFT-JUSTIFIED.
    WRITE: / 'Maxspeed :', maxspeed LEFT-JUSTIFIED.
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.
  DATA newresult TYPE i.
  DATA(vehicle1) = NEW vehicle(
     make = 'Benz'
      model    = 'C'
      numseat  = 5
      maxspeed = 180 ).
  vehicle1->viewvehicle( ).
  ULINE.
  DATA(vehicle2) = NEW vehicle(
      make     = 'Toyota'
      model    = 'Hilux'
      numseat  = 5
      maxspeed = 180 ).
  vehicle2->viewvehicle( ).
  ULINE.

  vehicle1->setnumseat( 6 ).
  vehicle1->viewvehicle( ).
  ULINE.
  vehicle1->setnumseat( newnumseats = 3 ).
  vehicle1->viewvehicle( ).
  ULINE.

  vehicle1->gofaster( EXPORTING increment = 40 IMPORTING result = newresult ).
  WRITE: / 'new speed of the vehicle-GOFASTER', newresult LEFT-JUSTIFIED.
  ULINE.
  vehicle1->gofaster( EXPORTING increment = 20 IMPORTING result = newresult ).
  WRITE: / 'new speed of the vehicle-GOFASTER', newresult LEFT-JUSTIFIED.

  vehicle1->goslower( EXPORTING decrement = 15 RECEIVING result = newresult ).
  WRITE: / 'new speed of the vehicle(functional method)-GOSLOWER', newresult.
  ULINE.
  newresult = vehicle1->goslower( 15 ).
  WRITE: / 'better way of calling functional methods- GOSLOWER', newresult.
  ULINE.
  WRITE: / 'Total No of vehicles : ',vehicle=>numofvehicles.
  ULINE.

  WRITE: ' Just New changes on 16.09.2020'.
  WRITE: / ' Just New changes on 01.10.2020 afternoon'.