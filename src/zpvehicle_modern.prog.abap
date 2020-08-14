*&---------------------------------------------------------------------*
*& Report ZPVEHICLE_MODERN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPVEHICLE_MODERN.
CLASS vehicle DEFINITION.

  PUBLIC SECTION."calling proramme can have access to all attributes in Public section

*static methods and static attributes must only be defined in Public section
    CLASS-DATA: numofvehicles TYPE i." static attribute
    CLASS-METHODS: class_constructor. " static constructor and its name must be like that

    METHODS setnumseat
      IMPORTING
        newnumseats TYPE i.

*not using "returning value" but rather "Exporting" hence not functional method
    METHODS gofaster
      IMPORTING
        increment TYPE i
      EXPORTING
        result    TYPE i.

*returning a value hence functional method
    METHODS goslower
      IMPORTING
        decrement     TYPE i
      RETURNING
        VALUE(result) TYPE i." one can even use same variable names in different methods since they are local to methods
    METHODS constructor " instance constructors must be only importing
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

    CLASS-DATA carlog TYPE c LENGTH 40.  " used by class_constructor because they only work with static attributes

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
*    make  =  make
*        model = model
*        numseat = numseat
*        maxspeed = maxspeed.

*    applying self referencing
    me->make  =  make. "me represents the vehicle class in this case hence me->make refers to "make" of class parameter and another "make" refers to parameter of the constructor
    me->model = model. "me->model same as vehicle->model
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
  DATA: vehicle1 TYPE REF TO vehicle, "declare class
        vehicle2 TYPE REF TO vehicle.
  CREATE OBJECT vehicle1
    EXPORTING
      make     = 'Benz'
      model    = 'C'
      numseat  = 5
      maxspeed = 200.
  vehicle1->viewvehicle( ).
  ULINE.
  CREATE OBJECT vehicle2
    EXPORTING
      make     = 'Toyota'
      model    = 'Hilux'
      numseat  = 5
      maxspeed = 180.
  vehicle2->viewvehicle( ).
  ULINE.
*changing the seats parameter.
  vehicle1->setnumseat( 6 ). " methods with 1 parameter dont necessarily require wrtting parameter variable when EXPORTING"
  vehicle1->viewvehicle( ).
  ULINE.
  vehicle1->setnumseat( newnumseats = 3 ). " exporting 1 parameter doesnt require writting "EXPORTING"
  vehicle1->viewvehicle( ).
  ULINE.
  " in call methods, Exporting reads right to left and importing does the vice versa
  vehicle1->gofaster( EXPORTING increment = 40 IMPORTING result = newresult ).
  WRITE: / 'new speed of the vehicle-GOFASTER', newresult LEFT-JUSTIFIED.
  ULINE.
  vehicle1->gofaster( EXPORTING increment = 20 IMPORTING result = newresult ).
  WRITE: / 'new speed of the vehicle-GOFASTER', newresult LEFT-JUSTIFIED.

  vehicle1->goslower( EXPORTING decrement = 15 RECEIVING result = newresult ).
  WRITE: / 'new speed of the vehicle(functional method)-GOSLOWER', newresult LEFT-JUSTIFIED.
  ULINE.
*  a better way of calling functional methods.
  newresult = vehicle1->goslower( 15 ).
  WRITE: / 'better way of calling functional methods- GOSLOWER', newresult LEFT-JUSTIFIED.
  ULINE.
   WRITE: / 'Total No of vehicles : ',vehicle=>numofvehicles LEFT-JUSTIFIED.
  ULINE.
